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
                                  SISTEMA SIGAL-LF


                             +-------------------------+
                             | Cliente Web (Caja)      |
                             | - Ventas                |
                             | - Recepción             |
                             | - Reportes              |
                             +-----------+-------------+
                                         |
                                      HTTPS
                                         |
                                         v
                             +-------------------------+
                             | Backend API             |
                             | Node.js + Express       |
                             | - Validaciones          |
                             | - Seguridad (JWT)       |
                             | - Lógica del sistema    |
                             +-----------+-------------+
                                         |
                                    PostgreSQL
                                         |
                                         v
                             +-------------------------+
                             | Base de Datos           |
                             | PostgreSQL (Supabase)   |
                             | - Inventario            |
                             | - Usuarios              |
                             | - Movimientos           |
                             +-------------------------+
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
    código_barra VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    categoría VARCHAR(100),
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
    estado VARCHAR(10) CHECK(estado IN ('en proceso', 'completado', 'cancelado')) NOT NULL,
    fecha_ingreso TIMESTAMP DEFAULT NOW(),
    activo BOOLEAN DEFAULT FALSE
);
-- Tabla de sincronización con sistema de ventas (integración con POS)
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

-- ============================================
-- 🔥 ÍNDICES DE OPTIMIZACIÓN (Agregar AQUÍ)
-- ============================================

-- Para búsquedas rápidas por código de barras en el mostrador
CREATE INDEX idx_prendas_codigo ON prendas(codigo_barra);

-- Para consultas matriciales por talla y color (consulta express)
CREATE INDEX idx_inventario_prenda_talla_color ON inventario(id_prenda, talla, color);

-- Para consultas de movimientos por fecha (reportes)
CREATE INDEX idx_movimientos_fecha ON movimientos(fecha_movimiento);

-- Para consultas de sincronización por estado
CREATE INDEX idx_sync_estado ON sync_ventas(estado_sync);
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
                           FLUJO DE DESCUENTO AUTOMATIZADO POR VENTAS


                         +---------------------------+
                         |   Cliente Web (Caja)      |
                         |   Registra la venta       |
                         +-------------+-------------+
                                       |
                                       | Envía la venta
                                       ▼
                         +---------------------------+
                         |      Backend API          |
                         |   Valida la solicitud     |
                         +-------------+-------------+
                                       |
                                       | Consulta el stock
                                       ▼
                         +---------------------------+
                         |     Base de Datos         |
                         | PostgreSQL (Supabase)     |
                         +-------------+-------------+
                                       |
                            ¿Hay stock disponible?
                                /              \
                              Sí                No
                              |                 |
                              ▼                 ▼
                  +-------------------+   +-------------------+
                  | Descuenta         |   | Rechaza la venta  |
                  | el stock          |   | e informa que     |
                  | Registra el       |   | no hay stock      |
                  | movimiento        |   +-------------------+
                  +---------+---------+
                            |
                            ▼
                  +---------------------------+
                  |      Backend API          |
                  | Confirma la operación     |
                  +-------------+-------------+
                                |
                                ▼
                  +---------------------------+
                  |   Cliente Web (Caja)      |
                  | ✓ Venta realizada         |
                  | ✓ Stock actualizado       |
                  +---------------------------+
```

### 5.2 Flujo de recepción de fardos (Aumento de stock masivo)


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

---

## 8. Endpoints de la API

| Método | Endpoint | Descripción | Autenticación | Rol Requerido |
|--------|----------|-------------|---------------|---------------|
| POST | `/api/auth/login` | Iniciar sesión | No | - |
| POST | `/api/auth/logout` | Cerrar sesión | Sí | Todos |
| GET | `/api/stock/:codigo` | Consultar stock por código | Sí | Todos |
| GET | `/api/stock/:codigo/talla/:talla` | Consultar stock por código y talla | Sí | Todos |
| POST | `/api/inventario/recepcion` | Registrar entrada de fardo de Marvisur | Sí | Apoyo |
| POST | `/api/inventario/venta` | Decrementar stock por venta | Sí | Cajera |
| POST | `/api/inventario/merma` | Registrar merma justificada | Sí | Supervisor |
| GET | `/api/reportes/rotacion` | Reporte de rotación por talla/color | Sí | Supervisor |
| GET | `/api/reportes/consistencia` | Reporte de consistencia de saldos | Sí | Supervisor |
| GET | `/api/reportes/export/:tipo` | Exportar reporte a PDF/Excel | Sí | Supervisor |

---

## 9. Ejemplos de Peticiones a la API

### 9.1 Registrar Recepción de Fardo (Marvisur)

**Petición:**
```json
POST /api/inventario/recepcion
{
    "codigo_barra": "8801234567890",
    "nombre": "Camisa Roja",
    "precio": 45.00,
    "talla": "M",
    "color": "Rojo",
    "ubicacion": "almacen",
    "cantidad": 100,
    "estado_calidad": "Conforme",
    "guia_remision": "MRV-2026-07-001",
    "id_usuario": 3
}
```
Respuesta Exitosa:
```json
{
    "success": true,
    "message": "Fardo registrado exitosamente",
    "data": {
        "id_inventario": 1,
        "stock_anterior": 0,
        "stock_actual": 100
    }
}
```
9.2 Registrar Venta (Decremento de Stock)
Petición:
```json
POST /api/inventario/venta
{
    "codigo_barra": "8801234567890",
    "talla": "M",
    "color": "Rojo",
    "cantidad": 1,
    "ubicacion": "piso_venta",
    "id_usuario": 1
}
```
Respuesta Exitosa:
```json
{
    "success": true,
    "message": "Stock actualizado exitosamente",
    "data": {
        "stock_anterior": 100,
        "stock_actual": 99
    }
}
```
9.3 Registrar Merma (Solo Supervisor)
Petición:
```json
POST /api/inventario/merma
{
    "codigo_barra": "8801234567890",
    "talla": "M",
    "color": "Rojo",
    "cantidad": 2,
    "motivo": "Falla de Costura",
    "descripcion": "Rotura en la costura del hombro",
    "id_usuario": 2
}
```
Respuesta Exitosa:
```json
{
    "success": true,
    "message": "Merma registrada exitosamente",
    "data": {
        "stock_anterior": 99,
        "stock_actual": 97
    }
}
```
9.4 Consultar Stock por Código de Barras
Petición:

GET /api/stock/8801234567890

Respuesta:
```json
{
    "success": true,
    "data": {
        "codigo_barra": "8801234567890",
        "nombre": "Camisa Roja",
        "precio": 45.00,
        "stock": {
            "S": 10,
            "M": 100,
            "L": 15,
            "XL": 5
        },
        "ubicaciones": {
            "almacen": 120,
            "piso_venta": 10
        }
    }
}
```
**Revisores:** Isabel Hurtado
**Resultado:** ✅ Aprobado
