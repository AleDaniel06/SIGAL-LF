# 02 · Especificación de Requisitos de Software (ERS v1.0)

**Proyecto:** Sistema Integrado de Gestión de Almacén e Inventario — Tiendas "La Fábrica"  
**Estándar:** IEEE 830 adaptado  
**Versión:** 1.0 · Julio 2026  
**Estado:** Validado con cliente  

---

## 1. Introducción

### 1.1 Propósito
Este documento especifica los requisitos funcionales y no funcionales del sistema SIGAL-LF para Tiendas "La Fábrica" — Sucursal Huancayo. Está dirigido al equipo de desarrollo y al cliente (Encargado de Tienda de la sucursal).

### 1.2 Ámbito del Sistema
El sistema se denomina **SIGAL-LF** y cubre la recepción de mercadería en fardos masivos, el control de inventario matricial, la consulta express en el mostrador de caja y el reporte de mermas e incidencias de fábrica. No cubre módulos de RRHH (planillas o asistencia), créditos o préstamos a clientes, ni integración con sistemas de compras de proveedores externos.

### 1.3 Definiciones

| Término | Definición |
| :--- | :--- |
| **Stock Matricial** | Inventario organizado por la combinación de tres variables: Talla, Color y Ubicación. |
| **Consulta Express** | Buscador de alta velocidad optimizado para el mostrador de caja. |
| **Fardo Masivo** | Lote de mercadería cerrada que llega en grandes cantidades vía transporte comercial. |
| **Merma** | Prenda de vestir o calzado que presenta fallas de origen o daños que impiden su venta. |
| **Cruce de Códigos** | Escaneo fraudulento de un código de barras activo para vender un producto sin stock lógico. |

---

## 2. Descripción General

### 2.1 Perspectiva del Producto
SIGAL-LF es un sistema nuevo que reemplaza el flujo desarticulado de hojas Excel locales enviadas por correo. A diferencia de su predecesor, la aplicación web se conecta directamente a una base de datos relacional centralizada en la nube, garantizando que el stock de prendas (desglosado por talla y color) esté disponible para la caja de forma inmediata tras su recepción física en el almacén local.

### 2.2 Funciones Principales
flowchart TB

subgraph Caja["Módulo Caja"]
    C1["Consulta Express"]
    C2["Validación de Stock"]
    C3["Alerta Stock Cero"]
end

subgraph Admin["Módulo Administrativo"]
    A1["Recepción de Fardos"]
    A2["Auditoría de Inventario"]
    A3["Registro de Mermas"]
end

subgraph Datos["Persistencia de Datos"]
    D1["Base de Datos Cloud"]
    D2["Supabase"]
end

Caja --> Datos
Admin --> Datos
                           
### 2.3 Usuarios del Sistema

| Rol | Descripción | Módulo que usa |
| :--- | :--- | :--- |
| **Cajera Principal** | Registra ventas y verifica stock local rápido. | App de Caja / Consulta Express |
| **Encargado de Tienda** | Supervisa ingresos, fardos, mermas e inventario. | Dashboard de Administración |
| **Personal de Ventas** | Consulta disponibilidad de tallas y colores en piso. | App de Caja (Modo Lectura) |

---

## 3. Requisitos Funcionales

### RF-01 · Recepción Guiada de Fardos
*   **Descripción:** El encargado puede registrar el ingreso de fardos de ropa vinculando la guía de transporte para proceder con el conteo físico pieza por pieza.
*   **Precondición:** El fardo físico se encuentra en el almacén local y la sesión está iniciada.
*   **Flujo principal:**
    1. El encargado ingresa el número de guía de transporte (Marvisur).
    2. El sistema despliega la lista teórica de artículos enviados por la central.
    3. El encargado realiza el conteo físico y registra las unidades validadas por variante.
    4. El sistema actualiza las tablas de stock general de la tienda.
*   **Postcondición:** Mercadería registrada e ingresada al inventario general.

### RF-02 · Control de Inventario Matricial
*   **Descripción:** El sistema mantiene el catálogo local de prendas desglosado estrictamente por sus propiedades físicas específicas.
*   **Requisitos específicos:**
    *   Búsqueda exacta indexando combinaciones de Talla (S, M, L, XL) y Color.
    *   Asignación obligatoria de Ubicación física dentro del almacén local (Estante/Fila).
    *   Actualización automática de registros tras confirmarse salidas o mermas.

### RF-03 · Consulta Express en Caja
*   **Descripción:** La cajera puede verificar la disponibilidad de una prenda y su ubicación exacta directamente desde la pantalla de mostrador para agilizar la fila.
*   **Precondición:** Usuario autenticado en la terminal de caja.
*   **Flujo principal:**
    1. La cajera escanea el código de barras o escribe la descripción del artículo.
    2. El sistema calcula y muestra las existencias divididas por Talla y Color en tiempo real.
    3. El sistema muestra en pantalla la ubicación exacta del producto (ej: "Estante C-4").
*   **Postcondición:** Información visualizada; botón de venta habilitado únicamente si el stock es $>0$.
*   **Manejo de errores:** Si el stock de la variante seleccionada es cero (0), el sistema emite una alerta visual persistente y bloquea el procesamiento de ese código para impedir el cruce manual de productos.

### RF-04 · Registro Automatizado de Mermas
*   **Descripción:** El encargado registra las prendas dañadas o falladas de origen, descontándolas del inventario con su justificación respectiva.
*   **Flujo principal:**
    1. El encargado selecciona la opción "Registrar Merma" en el panel.
    2. Escanea la prenda y selecciona la combinación de Talla y Color afectada.
    3. Registra el motivo obligatorio del descarte (Falla de fábrica / Daño físico).
    4. El sistema descuenta la unidad y genera un comprobante de auditoría no modificable.

---

## 4. Requisitos No Funcionales

### RNF-01 · Confiabilidad ★ CRÍTICA
*   Disponibilidad de la plataforma web expuesta en el mostrador $\ge 99.5\%$.
*   Integridad referencial total: las operaciones concurrentes entre terminales no deben duplicar transacciones sobre el mismo stock físico.

### RNF-02 · Eficiencia de Desempeño ★ CRÍTICA
*   Tiempo de respuesta de la Consulta Express en caja $\le 1.5$ segundos por búsqueda.
*   Las peticiones y persistencia en Supabase se ejecutan de manera asíncrona para no congelar la pantalla del cajero.

### RNF-03 · Seguridad ★ CRÍTICA
*   Autenticación individual por usuario con contraseñas protegidas mediante hash (bcrypt).
*   Cifrado de datos en tránsito obligatorio mediante protocolo seguro HTTPS.

### RNF-04 · Usabilidad
*   El cajero debe poder verificar la disponibilidad de una talla y color en $\le 3$ clics.
*   Interfaz limpia e intuitiva en idioma español, libre de tecnicismos informáticos complejos.

### RNF-05 · Mantenibilidad
*   Estructura modular de código desplegada en la nube (Render) con control de versiones en GitHub.
*   Documentación técnica del esquema de tablas de la base de datos actualizada.

---

## 5. Casos de Uso Principales

### CU-01 · Consultar Disponibilidad Matricial
*   **Actor:** Cajera Principal / Personal de Ventas
*   **Precondición:** Terminal iniciada y con acceso a la red.
*   **Flujo:**
    1. El usuario ingresa la descripción o código de barras de la prenda en el buscador express.
    2. El sistema consulta las tablas de inventario en la nube.
    3. El sistema muestra la matriz de disponibilidad (Tallas/Colores) junto a su estante.
*   **Postcondición:** Información de stock y ubicación mostrada en pantalla.
*   **Flujo alternativo:** Si la variante no posee existencias, el sistema bloquea el registro de venta y resalta la fila en color rojo.

### CU-02 · Registrar Baja por Merma
*   **Actor:** Encargado de Tienda
*   **Precondición:** Prenda identificada físicamente con rotura o imperfección.
*   **Flujo:**
    1. El encargado entra al apartado de gestión de mermas.
    2. Digita el código de barras e indica la variante exacta de talla y color.
    3. Selecciona la causa de descarte y guarda la operación.
    4. El sistema reduce el inventario lógico local.
*   **Postcondición:** Stock actualizado y registro almacenado en la tabla de auditoría.

---

## 6. Historias de Usuario

### HU-01 · Búsqueda Express de Variantes
> Como cajera de la tienda, quiero buscar una prenda filtrando por su talla y color en tiempo real, para responder rápidamente al cliente en el mostrador y agilizar las filas.

*   **Criterios de aceptación:**
    *   [ ] El motor de búsqueda filtra simultáneamente por código de barras, descripción y color.
    *   [ ] La cuadrícula de resultados muestra la ubicación física exacta del producto en el almacén.
    *   [ ] La pantalla refresca los datos de stock al instante sin requerir la recarga del sitio web completo.

### HU-02 · Resguardo Analítico de Mermas
> Como encargado de tienda, quiero generar reportes oficiales de prendas dadas de baja por fallas de fábrica, para sustentar los descuadres ante la central y evitar cobros injustos sobre el sueldo de los trabajadores.

*   **Criterios de aceptación:**
    *   [ ] El formulario exige de forma obligatoria el ingreso del motivo detallado del descarte.
    *   [ ] Cada reporte guardado genera un identificador único asociado al usuario responsable.
    *   [ ] El sistema cuenta con una opción nativa para exportar el reporte en formato PDF listo para impresión.

---

## 7. Matriz de Trazabilidad

| Requisito Alto Nivel | Req. Funcional | Req. No Funcional | Historia de Usuario |
| :--- | :--- | :--- | :--- |
| **RAN-01** (Validación de fardos) | RF-01 | RNF-01 | — |
| **RAN-02** (Control matricial) | RF-02 | RNF-01, RNF-05 | HU-01 |
| **RAN-03** (Consulta express) | RF-03 | RNF-02, RNF-04 | HU-01 |
| **RAN-04** (Reporte de mermas) | RF-04 | RNF-03 | HU-02 |

---

## 8. Checklist SQA1 — Revisión IEEE 830

| Criterio | ¿Cumple? | Observación |
| :--- | :--- | :--- |
| Los requisitos son verificables |  | Cada requerimiento funcional cuenta con flujos definidos y resultados comprobables. |
| Los requisitos no son ambiguos |  | Los conceptos operativos clave han sido definidos con precisión en la Sección 1.3. |
| Los requisitos son completos |  | Cubre integralmente el flujo de almacén, caja y control de mermas de la tienda. |
| Los requisitos son consistentes |  | No existen contradicciones operativas entre las funciones de la caja y los privilegios de administración. |
| Los requisitos están priorizados |  | Los atributos de calidad indispensables del sistema están marcados con el símbolo ★. |
| Trazabilidad a necesidades del cliente |  | El mapeo se encuentra completamente estructurado en la matriz de la Sección 7. |

**Revisores:** Alexandra Cuchula - José Moori 
**Fecha de revisión:** Julio 2026  
**Resultado:**   Aprobado sin observaciones críticas  

---
*ERS v1.0 · UPLA · MDS 2026-I*
