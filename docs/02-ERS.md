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
   ```text

 
                 
                 ┌────────────────────┐
                 │      SIGAL-LF      │
                 └─────────┬──────────┘
                           │
          ┌────────────────┴────────────────┐
          │                                 │
          ▼                                 ▼
 ┌──────────────────┐              ┌──────────────────┐
 │   Módulo Caja    │              │ Módulo Admin.    │
 └────────┬─────────┘              └────────┬─────────┘
          │                                 │
          ▼                                 ▼
 Consulta Express                 Recepción de Fardos
 Validación Stock                 Auditoría Inventario
 Alerta Stock Cero                Registro de Mermas
          │                                 │
          └──────────────┬──────────────────┘
                         ▼
              ┌──────────────────────┐
              │  Base de Datos Cloud │
              │      Supabase        │
              └──────────────────────┘

``` 

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

### RNF-01 · Confiabilidad y Disponibilidad ★ CRÍTICA
*   **Disponibilidad del Sistema:** Al contar la sucursal con **una sola caja**, el acceso a la plataforma web en dicho mostrador es un punto único de fallo; debe garantizar un tiempo de actividad $\ge 99.9\%$ en horario comercial.
*   **Persistencia Local Temporal:** El sistema debe asegurar que, ante microcortes de internet en la terminal única, no se pierdan los datos del fardo o la merma que se estén digitando en ese instante.

### RNF-02 · Eficiencia de Desempeño ★ CRÍTICA
*   **Velocidad de Respuesta:** El motor de Consulta Express en la caja única debe procesar y renderizar la cuadrícula de tallas/colores en $\le 1.0$ segundo para evitar embotellamientos en el único punto de despacho.
*   **Ligereza de Carga:** La comunicación con Supabase debe estar optimizada mediante consultas indexadas para no saturar el ancho de banda de la tienda.

### RNF-03 · Seguridad
*   **Control de Roles en Terminal Única:** El sistema debe permitir el cambio rápido de sesión (Cajera Principal, Apoyo de Caja, Encargado) en la misma terminal, aplicando restricciones estrictas según el rol activo.
*   **Protección de Rutas:** El Personal de Ventas y Apoyo de Caja tienen prohibido el acceso al módulo de aprobación definitiva de mermas, incluso si la sesión se queda abierta en la caja.

### RNF-04 · Usabilidad
*   **Operación Express:** El cajero o su apoyo deben localizar la ubicación y stock de cualquier prenda en un máximo de 2 clics o un solo escaneo desde la pantalla principal.
*   **Diseño Adaptable:** La interfaz debe ser intuitiva y de alto contraste, optimizada para la pantalla fija del mostrador y para dispositivos de consulta rápida en el piso de venta.

---

## 5. Casos de Uso Principales

### CU-01 · Consultar Disponibilidad Matricial (Buscador Express)
*   **Actores:** Cajera Principal / Apoyo de Caja / Personal de Ventas
*   **Precondición:** Terminal de caja única o dispositivo de piso con sesión activa.
*   **Flujo principal:**
    1. El usuario escanea el código o digita la prenda en la barra de búsqueda express.
    2. El sistema consulta la base de datos en la nube.
    3. El sistema despliega la matriz de Tallas y Colores con su ubicación exacta (ej: "Estante B-Fila 2").
*   **Postcondición:** Existencias visualizadas en pantalla.
*   **Flujo alternativo (Stock Cero):** Si la variante seleccionada está agotada, el sistema bloquea el botón de venta en la terminal para erradicar el cruce manual de códigos.

### CU-02 · Pre-registro de Incidencias en Mostrador o Piso
*   **Actores:** Apoyo de Caja / Personal de Ventas
*   **Precondición:** Identificación de una prenda fallada devuelta por un cliente en caja o detectada en exhibición.
*   **Flujo principal:**
    1. El usuario abre el formulario rápido de "Reporte de Incidencia".
    2. Escanea el código de barras y selecciona la combinación de Talla y Color afectada.
    3. Registra el desperfecto observable (ej: "Mancha", "Salida de costura").
    4. El sistema guarda la prenda en estado "Bloqueado por Revisión" para sacarla del stock vendible.
*   **Postcondición:** Prenda inhabilitada temporalmente en la matriz de inventario.

### CU-03 · Aprobación Definitiva de Merma
*   **Actor:** Encargado de Tienda
*   **Precondición:** Existencia de prendas pre-registradas como incidencias.
*   **Flujo principal:**
    1. El encargado inicia sesión en el panel administrativo (desde la terminal de caja o su oficina).
    2. Revisa y convalida físicamente las prendas retenidas por el personal de apoyo o ventas.
    3. Presiona "Confirmar Baja por Merma".
    4. El sistema descuenta de forma irreversible la unidad del inventario y genera el registro de auditoría.
*   **Postcondición:** Stock matricial actualizado permanentemente.

---

## 6. Historias de Usuario

### HU-01 · Búsqueda Express en Caja Única
> Como **cajera de la tienda**, quiero que el buscador filtre prendas por talla y color instantáneamente en mi terminal, para no generar colas ni retrasos al ser la única caja disponible.

*   **Criterios de aceptación:**
    *   [ ] Búsqueda simultánea por código de barras o texto descriptivo en menos de un segundo.
    *   [ ] Visualización clara de la ubicación física en el almacén trasero o estantes.
    *   [ ] Bloqueo visual inmediato del botón de adición si el stock matricial de la variante es 0.

### HU-02 · Agilización de Atención en Piso
> Como **personal de ventas**, quiero consultar el stock matricial desde mi pantalla de apoyo, para asegurarle al cliente si la prenda está disponible en almacén sin tener que interrumpir la operación de la caja principal.

*   **Criterios de aceptación:**
    *   [ ] Interfaz de solo lectura que muestra la matriz completa de existencias por sucursal.
    *   [ ] Actualización de datos sincronizada con los movimientos de la caja única.

### HU-03 · Retención de Prendas Defuctuosas
> Como **apoyo de caja**, quiero registrar rápidamente en el sistema una prenda que el cliente rechazó por falla al momento del pago, para apartarla físicamente y evitar que se intente vender por error nuevamente.

*   **Criterios de aceptación:**
    *   [ ] Formulario directo de dos pasos: escanear variante y seleccionar tipo de falla.
    *   [ ] El sistema descuenta temporalmente la pieza del stock disponible bajo el estado "En Verificación".

### HU-04 · Auditoría de Bajas Locales
> Como **encargado de tienda**, quiero validar y firmar digitalmente las mermas acumuladas en el turno, para enviar el reporte limpio a la central de "La Fábrica" y justificar los descuadres del inventario.

*   **Criterios de aceptación:**
    *   [ ] Bandeja de entrada que agrupa las incidencias reportadas por el personal de apoyo y piso.
    *   [ ] Generación de un archivo PDF de auditoría no modificable con fecha, hora y usuario del encargado.

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
