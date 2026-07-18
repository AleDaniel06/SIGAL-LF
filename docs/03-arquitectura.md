# 03 · Arquitectura Técnica — Sistema "La Fábrica"

**Proyecto:** Sistema Integrado de Gestión de Almacén e Inventario — Tiendas "La Fábrica"  
**Versión:** 1.0 · Julio 2026  
**Autor:** José Moori (Arquitecto)  
**Revisor:** Isabel Hurtado  

---

## 1. Decisión Arquitectónica

### 1.1 Patrón elegido: Arquitectura de Cliente Único con Conexión Directa Cloud (Bajo Demanda)

El problema de "La Fábrica" se centra en la optimización del tiempo de respuesta en el mostrador y la erradicación del cruce manual de códigos. Al contar con **una sola caja física compartida**, la solución idónea es una Aplicación de Página Única (SPA) web ligera que interactúa directamente con una base de datos en la nube sin capas intermedias redundantes que sumen latencia.

| Arquitectura anterior | Arquitectura propuesta |
| :--- | :--- |
| Consultas e inventarios manuales o en papel | Consulta Express en tiempo real mediante base de datos |
| Errores por digitación manual de códigos | Entrada automatizada mediante escáner de códigos de barras |
| Falta de trazabilidad en las bajas físicas | Pre-registro de mermas e incidencias desde la misma caja |
| Cuellos de botella en horas punta por lentitud | Renderizado matricial inmediato ($\le 0.5$ segundos) |

### 1.2 Referentes del patrón
Este patrón de conexión directa a servicios backend distribuidos (*Backend-as-a-Service*) es el estándar en sistemas de retail ágiles e inventarios de alta rotación, garantizando la consistencia inmediata de los datos matriciales de inventario sin depender de pesados servidores locales.

---

## 2. Diagrama de Arquitectura

+-----------------------------------------------------------------------+
|                      TIENDA FÍSICA "LA FÁBRICA"                       |
|                                                                       |
|  +----------------------- MOSTRADOR CENTRAL -----------------------+  |
|  |                                                                 |  |
|  |     [ Escáner de Barras ]                                       |  |
|  |               │ (Entrada Nativa USB/HID)                        |  |
|  |               ▼                                                 |  |
|  |   +---------------------------------------------------------+   |  |
|  |   |             TERMINAL ÚNICA (Navegador Web)              |   |  |
|  |   |  • SPA en JavaScript Vanilla (Consulta Express)         |   |  |
|  |   |  • Búfer de Contingencia (localStorage)                 |   |  |
|  |   +---------------------------------------------------------+   |  |
|  |                                                                 |  |
|  +-----------------------------------------------------------------+  |
+-----------------------------------------------------------------------+
│
│ HTTPS / TLS 1.3 (Internet)
▼
+-----------------------------------------------------------------------+
|                           ENTORNO NUBE                                |
|                                                                       |
|  +------------------- SERVICIO BACKEND (Supabase) ------------------+  |
|  |  • PostgreSQL 15 (Tablas Matriciales Indexadas)                    |  |
|  |  • Autenticación y Roles de Usuario (Supabase Auth)              |  |
|  +------------------------------------------------------------------+  |
+-----------------------------------------------------------------------+

---

## 3. Stack Tecnológico

### 3.1 Capa 1 — Aplicación de Caja Única (Frontend)

| Componente | Tecnología | Versión | Justificación |
| :--- | :--- | :--- | :--- |
| Entorno de Ejecución | Navegador Web | — | Elimina la necesidad de instalar ejecutables locales en la única PC. Acceso inmediato. |
| Interfaz de Usuario | JS Vanilla | ES13 | Sin frameworks (React/Vue). Garantiza una carga ligera y respuesta sub-segundo con el escáner. |
| Estilos | CSS Estructurado | CSS3 | Diseño de alta densidad y contraste, optimizado para visualización remota desde el piso. |
| Búfer Temporal | localStorage | — | Almacena localmente las incidencias de mermas en caso de microcortes de red en la tienda. |

**¿Por qué una Web App ligera y no una aplicación de escritorio?**  
Al operar con una terminal única, una SPA web en JavaScript Vanilla ofrece el rendimiento óptimo que el negocio requiere, manteniendo el foco del teclado automatizado para las lecturas del escáner sin añadir complejidad de mantenimiento técnico local.

### 3.2 Capa 2 — Base de Datos Central y Seguridad (Cloud)

| Componente | Tecnología | Versión | Justificación |
| :--- | :--- | :--- | :--- |
| Base de datos | PostgreSQL | 15.x | Soporte de consultas indexadas complejas para la matriz de Tallas/Colores. |
| Hosting / BaaS | Supabase | Cloud | Conexión directa ultra rápida, seguridad por políticas de fila (RLS) y costo cero en prototipo. |

### 3.3 Herramientas de Desarrollo y Calidad

| Herramientas | Uso | Costo |
| :--- | :--- | :--- |
| GitHub | Control de versiones y alojamiento de la documentación | Gratis |
| Figma | Diseño de la matriz visual de Tallas/Colores para el mostrador | Gratis |
| DBeaver | Modelado y ejecución del esquema relacional en Supabase | Gratis (Open Source) |

**Costo total del stack: S/. 0.00**

---
## 4. Diseño de Base de Datos

### 4.1 Supabase — Esquema Relacional Matricial

```sql
-- Tabla de Productos General
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    codigo_barra VARCHAR(50) UNIQUE NOT NULL,
    descripcion VARCHAR(150) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);

-- Tabla de Inventario de Variantes Matriciales (Talla / Color)
CREATE TABLE inventario_matricial (
    id SERIAL PRIMARY KEY,
    producto_id INT REFERENCES productos(id) ON DELETE CASCADE,
    talla VARCHAR(10) NOT NULL,
    color VARCHAR(30) NOT NULL,
    stock_disponible INT NOT NULL CHECK (stock_disponible >= 0),
    ubicacion_estante VARCHAR(50) NOT NULL,
    CONSTRAINT unica_variante UNIQUE(producto_id, talla, color)
);

-- Tabla de Control de Incidencias y Mermas
CREATE TABLE mermas_registro (
    id SERIAL PRIMARY KEY,
    inventario_id INT REFERENCES inventario_matricial(id),
    cantidad INT NOT NULL CHECK (cantidad > 0),
    motivo_falla VARCHAR(255) NOT NULL,
    estado VARCHAR(30) DEFAULT 'en_verificacion' CHECK (estado IN ('en_verificacion', 'baja_aprobada')),
    registrado_por VARCHAR(50) NOT NULL,
    autorizado_por VARCHAR(50),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices optimizados para la velocidad del escáner de códigos de barras
CREATE INDEX idx_productos_codigo ON productos(codigo_barra);
CREATE INDEX idx_inventario_variante ON inventario_matricial(producto_id, talla, color);

```

## 5. Lógica Operativa en Terminal Única

### 5.1 Flujo de Consulta Express por Escáner

[El Vendedor llega a Caja con Prenda]
│
▼
Lectura de Código con Escáner
│
▼
¿El cursor está enfocado en la barra?
├── NO ──> El sistema auto-enfoca dinámicamente mediante JS
└── SÍ ──> Captura la cadena de texto de barra
│
▼
Consulta Indexada a Supabase (≤ 0.5s)
│
▼
Despliegue de Matriz en Pantalla de Caja
• Verde: Stock Disponible + Ubicación de Estante
• Rojo: Agotado (Bloqueo de botón de venta)
│
▼
[Tecla ESC] ──> Limpia Pantalla y Regresa a Modo Venta

---

## 6. Alcance del Prototipo Académico

Para la entrega académica se construye el flujo completo integrado en la terminal única que demuestra el ciclo:

Escaneo de Prenda en Mostrador ──> Visualización Matricial ──> Registro de Incidencia de Falla ──> Validación del Encargado

Al ser una sucursal con una sola caja, el alcance web cubre la interfaz unificada con cambio rápido de rol de usuario mediante código PIN sin pérdida de estado en la pestaña del navegador.

---

## 7. Walkthrough SQA2 — Revisión de Arquitectura

| Criterio | ¿Cumple? | Observación |
| :--- | :--- | :--- |
| La arquitectura resuelve el problema raíz identificado | [X] Sí | Centraliza e introduce el escáner de códigos de barras, solucionando las demoras en caja y el cruce manual. |
| El stack es justificado técnicamente | [X] Sí | Se justifica la eliminación de frameworks para mantener la agilidad de carga en el terminal fijo. |
| Los diagramas son consistentes entre sí | [X] Sí | El diagrama de bloques se alinea con la base de datos distribuida en Supabase. |
| El motor de búsqueda maneja casos de error | [X] Sí | Si el stock matricial da cero, la interfaz inhabilita la adición del producto. |
| El alcance académico es realista | [X] Sí | El prototipo funcional de caja única cubre el 100% de la operatividad física de la sucursal. |

**Revisores:** José Moori(autor) · Isabel Hurtado(revisor)  
**Resultado:** [X] Aprobado  

---
*Documento de Arquitectura v1.0 · UPLA · MDS 2026-I*
