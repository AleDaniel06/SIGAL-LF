# 03 · Arquitectura Técnica — Sistema "La Fábrica"

*Proyecto:* Sistema Integrado de Gestión de Almacén e Inventario — Tiendas "La Fábrica"  
*Versión:* 1.0 · Julio 2026  
*Autor:* José Moori (Arquitecto)  
*Revisor:* Isabel Hurtado

---

## 1. Decisión Arquitectónica

### 1.1 Patrón elegido: Aplicación Web Centralizada con Sincronización Asíncrona
El problema de La Fábrica — Sucursal Huancayo es un **problema arquitectónico** de integridad de datos y rendimiento en mostrador, no de funcionalidades. La solución no es mantener el flujo manual basado en hojas de cálculo distribuidas, sino cambiar radicalmente el patrón de dependencia de datos mediante una arquitectura web centralizada de consumo express y contingencia local.

| Arquitectura anterior (Actual) | Arquitectura propuesta (SIGAL-LF) |
| :--- | :--- |
| Inventario en Excel local | Base de datos centralizada en la nube |
| Actualización manual por correo | Actualización automática en tiempo real |
| Stock virtual desactualizado (cero) | Stock matricial actualizado (talla/color/ubicación) |
| Cruce de códigos en mostrador | Consulta express con validación |
| Búsqueda ciega de prendas | Ubicación exacta de cada prenda |

### 1.2 Referentes del patrón
Este patrón de consumo centralizado mediante APIs ligeras con persistencia cloud y mecanismos de persistencia en cliente (*LocalStorage/In-Memory*) es el estándar utilizado por sistemas POS de alta velocidad y baja infraestructura como *Square POS*, *Toast POS* y *Shopify POS*, garantizando la operatividad fluida en terminales de hardware antiguo.

---

## 2. Diagrama de Arquitectura

```text
+---------------------------+
|      CLIENTE WEB          |
| (Caja / Navegador Web)    |
+-------------+-------------+
              |
        HTTPS / JSON
              |
              v
+---------------------------+
|     API BACKEND           |
| Node.js + Express         |
| (Render Cloud)            |
+-------------+-------------+
              |
         PostgreSQL
              |
              v
+---------------------------+
|    BASE DE DATOS          |
| PostgreSQL (Supabase)     |
+---------------------------+
```

### 3. Stack Tecnológico

#### 3.1 Capa 1 — Cliente (Frontend Web)

| Componente | Tecnología | Versión | Justificación |
| :--- | :--- | :--- | :--- |
| Interfaz web | HTML5 + CSS3 + Vanilla JS | ECMAScript 2025+ | Sin frameworks pesados, optimizado para PC de 4GB RAM |
| Estilos | Tailwind CSS | 3.x | Rápido de implementar, ligero |
| Peticiones HTTP | Fetch API | Nativo | Nativo del navegador, sin dependencias externas |
| Almacenamiento local | LocalStorage | Nativo | Para congelar precios en contingencia ante caídas de red |

**¿Por qué una aplicación web y no una app de escritorio?**
La PC de caja antigua ya cuenta con un navegador web moderno instalado. Una aplicación web (SPA) no requiere procesos complejos de instalación ni actualizaciones manuales en sitio, es accesible inmediatamente y el equipo de desarrollo domina el ecosistema web, maximizando el rendimiento del hardware disponible.

#### 3.2 Capa 2 — Servidor (Backend API)

| Componente | Tecnología | Versión | Justificación |
| :--- | :--- | :--- | :--- |
| Runtime | Node.js | 20 LTS | Mismo ecosistema JavaScript del equipo de ingeniería |
| Framework API | Express.js | 4.x | Minimalista, veloz, adecuado para endpoints RESTful |
| ORM / Query Builder | Prisma | 5.x | Genera queries tipadas, evita SQL manual propenso a errores lógicos |

#### 3.3 Capa 3 — Base de Datos Central

| Componente | Tecnología | Versión | Justificación |
| :--- | :--- | :--- | :--- |
| Base de datos | PostgreSQL | 16.x | Open source, robusto, transaccional, estándar de industria |
| Hosting | Supabase (Free Tier) | Cloud | Incluye PostgreSQL nativo con API REST y autenticación integrada |
| Almacenamiento | Supabase Storage | Cloud | Almacenamiento de reportes persistentes (PDF/Excel) |

#### 3.4 Herramientas de Desarrollo y Calidad

| Herramienta | Uso | Costo |
| :--- | :--- | :--- |
| GitHub | Control de versiones + gestión ágil del proyecto (Projects Kanban) | \$0.00 |
| GitHub Actions | CI/CD: Automatización de pruebas y análisis en cada Push | \$0.00 |
| Render | Hosting y despliegue del backend de la API en la nube | \$0.00 |
| Swagger / OpenAPI | Documentación interactiva de los endpoints del sistema | \$0.00 |
| Figma | Diseño de wireframes y prototipos UI adaptados a baja resolución | \$0.00 |
| Postman | Pruebas funcionales e integración de endpoints de la API | \$0.00 |

**Costo total del stack: S/. 0.00**

---

## 4. Diseño de Base de Datos

### 4.1 PostgreSQL — Esquema de la Base de Datos Central (SIGAL-LF)

```sql
-- Tabla de usuarios (control de acceso RBAC)
CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(20) CHECK(rol IN ('cajera', 'supervisor', 'apoyo')) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT NOW()
);

-- Tabla de prendas (catálogo maestro)
CREATE TABLE prendas (
    id_prenda SERIAL PRIMARY KEY,
    codigo_barra VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(100),
    marca VARCHAR(100),
    fecha_ingreso TIMESTAMP DEFAULT NOW()
);

-- Tabla de inventario (stock matricial tridimensional)
CREATE TABLE inventario (
    id_inventario SERIAL PRIMARY KEY,
    id_prenda INTEGER NOT NULL REFERENCES prendas(id_prenda) ON DELETE CASCADE,
    talla VARCHAR(5) CHECK(talla IN ('S', 'M', 'L', 'XL', 'XXL')) NOT NULL,
    color VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(20) CHECK(ubicacion IN ('almacen', 'piso_venta')) NOT NULL,
    stock_cantidad INTEGER DEFAULT 0 CHECK(stock_cantidad >= 0),
    UNIQUE(id_prenda, talla, color, ubicacion)
);

-- Tabla de movimientos de inventario (auditoría completa de flujos)
CREATE TABLE movimientos (
    id_movimiento SERIAL PRIMARY KEY,
    id_inventario INTEGER NOT NULL REFERENCES inventario(id_inventario),
    tipo_movimiento VARCHAR(20) CHECK(tipo_movimiento IN ('entrada', 'venta', 'merma', 'ajuste')) NOT NULL,
    cantidad INTEGER NOT NULL,
    fecha_movimiento TIMESTAMP DEFAULT NOW(),
    motivo TEXT,
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id_usuario),
    referencia VARCHAR(100)  -- Código de venta o guía de remisión Marvisur
);

-- Tabla de configuración (precios congelados y parámetros locales)
CREATE TABLE configuracion (
    id_config SERIAL PRIMARY KEY,
    clave VARCHAR(100) UNIQUE NOT NULL,
    valor TEXT NOT NULL,
    descripcion TEXT,
    actualizado_en TIMESTAMP DEFAULT NOW()
);

-- Índices de rendimiento para optimización en hardware de 4GB RAM
CREATE INDEX idx_inventario_prenda_talla_color ON inventario(id_prenda, talla, color);
CREATE INDEX idx_movimientos_fecha ON movimientos(fecha_movimiento);
CREATE INDEX idx_prendas_codigo ON prendas(codigo_barra);
```

### 4.2 Tabla de Movimientos de Sincronización (Integración con Ventas)

```sql
-- Tabla para registrar transacciones con el sistema de ventas externo
CREATE TABLE sync_ventas (
    id_sync SERIAL PRIMARY KEY,
    codigo_prenda VARCHAR(50) NOT NULL,
    talla VARCHAR(5) NOT NULL,
    color VARCHAR(50) NOT NULL,
    cantidad_vendida INTEGER NOT NULL,
    fecha_venta TIMESTAMP DEFAULT NOW(),
    estado_sync VARCHAR(20) CHECK(estado_sync IN ('pendiente', 'procesado', 'error')) DEFAULT 'pendiente',
    intentos INTEGER DEFAULT 0,
    ultimo_intento TIMESTAMP,
    error_mensaje TEXT
);
```
## 5. Motor de Sincronización

### 5.1 Flujo de descuento automatizado por ventas (API REST)

```text
[ CLIENTE WEB / FRONTEND SPA ] 
               |
               | 1. HTTP POST /api/v1/inventario/venta (Petición Fetch asíncrona)
               | Payload: { codigo: "PR-1029", talla: "M", color: "Azul", cantidad: 1 }
               v
[ SERVIDOR API / BACKEND NODE.JS ]
               |
               | 2. Middleware: Verifica formato JSON y firma del Token JWT (RBAC)
               | 3. Controlador: Inicializa bloque transaccional mediante Prisma ORM
               v
[ BASE DE DATOS / POSTGRESQL (SUPABASE) ]
               |
               | 4. Query SQL: SELECT stock_cantidad FROM inventario WHERE ... FOR UPDATE;
               |
               +---> ¿Condición Lógica: stock_cantidad >= cantidad?
                        |
                        ├── [ NO ] ---> 5a. Lanza Excepción / Ejecuta ROLLBACK automático
                        |
                        └── [ SÍ ] ---> 5b. Ejecuta UPDATE decremental en ubicación 'piso_venta'
                                            Inserta en tabla 'movimientos' (tipo: 'venta')
                                            Inserta en 'sync_ventas' (estado: 'procesado')
                                            Commit de la transacción (Aislamiento ACID completo)
               |
               v
[ SERVIDOR API / BACKEND NODE.JS ]
               |
               | 6. Parsea respuesta de la base de datos a estructura JSON limpia
               | 7. Retorna HTTP Status 200 OK con payload de confirmación de stock
               v
[ CLIENTE WEB / FRONTEND SPA ] ---> (Actualiza la interfaz de caja en un tiempo < 1.5 segundos)
```

### 5.2 Flujo de recepción de fardos (Aumento de stock masivo)

```text
MÓDULO RECEPCIÓN (Recepción de fardos terrestres vía Marvisur)

1. Llegada de carga terrestre -> Conteo físico y control de calidad por Apoyo de Caja.
2. Lectura óptica / Digitación manual de códigos de barra en el cliente web.
3. Selección obligatoria de atributos: Talla, Color, Ubicación (almacen/piso_venta).
4. Clasificación de calidad: Conforme / Falla de Costura / Manchado.
5. Envío HTTP POST hacia endpoint /api/v1/inventario/recepcion.
6. API ejecuta transacción SQL:
   - Incrementa 'stock_cantidad' en tabla 'inventario'.
   - Registra registro en 'movimientos' con tipo_movimiento = 'entrada' y motivo = 'Guía Marvisur'.
7. Base de datos consolida cambios -> Stock disponible reflejado en mostrador inmediatamente.
```
### 5.3 Manejo de conflictos

*   **Operación en Caja Única:** Al contar la sucursal con una sola caja física en mostrador, se elimina el riesgo de colisión simultánea de ventas presenciales. Sin embargo, el uso de `SELECT FOR UPDATE` en PostgreSQL se mantiene activo en la API como una medida de diseño defensivo. Esto garantiza que si en el futuro se integra un canal de venta digital (E-commerce) o si se procesan ráfagas de sincronización asíncrona pendientes en la cola, el stock de la base de datos central conserve un aislamiento ACID estricto, impidiendo quiebres de stock virtuales.
*   **Caída Crítica de Internet:** Si la red de la tienda falla, la caja no se detiene. El frontend SPA captura el error de conexión y almacena de forma estructurada los códigos vendidos localmente en el `LocalStorage` del navegador. Durante el periodo de desconexión, la interfaz opera en modo de contingencia utilizando los precios previamente congelados en el cliente. Al detectar el restablecimiento del enlace de internet, el sistema envía automáticamente el lote de transacciones acumuladas en segundo plano para que el servidor las procese de forma secuencial y ordenada.

---

## 6. Alcance del Prototipo Académico (MVP)

El Producto Mínimo Viable para la entrega académica se acota a **1 terminal funcional** web centralizada en mostrador que simula el ciclo de vida logístico completo en un entorno controlado:

*   **Autenticación:** Login seguro con 3 perfiles diferenciados (Cajera, Supervisor, Apoyo).
*   **Recepción:** Interfaz de entrada para fardos con selector matricial y estado de costura/manchado.
*   **Consulta Express:** Pantalla optimizada de búsqueda instantánea por código, talla y color.
*   **Transaccionalidad:** Decremento atómico automatizado ante simulación de ventas.
*   **Mermas:** Módulo restrictivo para el supervisor para declarar pérdidas justificadas.
*   **Reportes:** Exportación limpia de datos acumulados a formatos Excel/PDF.

**Escalabilidad:** El diseño desacoplado permite escalar el sistema a múltiples sucursales simplemente registrando un identificador de sucursal (`id_sucursal`) en el esquema relacional central, reutilizando el 100% de la lógica de backend sin modificaciones en el código fuente.

---

## 7. Walkthrough SQA2 — Revisión de Arquitectura

| Criterio | ¿Cumple? | Observación |
| :--- | :--- | :--- |
| La arquitectura resuelve el problema raíz identificado | ✅ | Centraliza datos, elimina latencia de actualización y quita el flujo en Excel manual |
| El stack es justificado técnicamente | ✅ | Sección 3 define componentes optimizados para hardware antiguo y costo financiero cero |
| Los diagramas son consistentes entre sí | ✅ | Flujos de la API y el diseño de esquemas SQL comparten la misma estructura multidimensional |
| El motor de sincronización maneja casos de error | ✅ | Sección 5.3 implementa transacciones ACID, bloqueo FOR UPDATE y contingencia local |
| El alcance académico es realista | ✅ | MVP delimita funciones prioritarias realizables por 2 integrantes en 13 semanas |
| La base de datos soporta la matriz multidimensional | ✅ | Tabla inventario indexa de forma compuesta las variables talla, color y ubicación |
| El sistema respeta la restricción de hardware | ✅ | Arquitectura web ligera basada en JavaScript Vanilla sin sobrecarga de memoria RAM |

**Revisores:** Isabel Hurtado
**Resultado:** ✅ Aprobado
