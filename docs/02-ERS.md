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

### RNF-01 · Confiabilidad y Consistencia ★ CRÍTICA
*   **Disponibilidad del Sistema:** El acceso a la plataforma web en los mostradores de atención debe garantizar un tiempo de actividad $\ge 99.5\%$ en el horario comercial de la tienda.
*   **Aislamiento de Transacciones:** El sistema debe implementar bloqueos optimistas en la base de datos (Supabase) para evitar que dos terminales descuenten simultáneamente la misma unidad física de una prenda si solo queda una (1) en stock matricial.
*   **Persistencia Garantizada:** En caso de una desconexión abrupta del navegador, los datos de las mermas en proceso de registro no deben quedar en estados inconsistentes o duplicados en el servidor.

### RNF-02 · Eficiencia de Desempeño ★ CRÍTICA
*   **Velocidad de Búsqueda:** El motor de Consulta Express debe procesar las solicitudes y renderizar la cuadrícula de tallas/colores en $\le 1.5$ segundos bajo una carga de hasta 10 usuarios concurrentes en la red local.
*   **Optimización de Carga:** El procesamiento de reportes analíticos pesados de mermas e inventario debe ejecutarse en segundo plano mediante llamadas asíncronas, evitando congelar el flujo operativo de la interfaz de caja.

### RNF-03 · Seguridad ★ CRÍTICA
*   **Control de Accesos (RBAC):** El sistema debe impedir estrictamente que los roles de Personal de Ventas y Apoyo de Caja accedan a las funciones de aprobación de mermas o alteración manual de stock físico.
*   **Cifrado:** Toda la comunicación entre los clientes web y el backend en la nube se realizará obligatoriamente bajo el protocolo HTTPS utilizando TLS 1.3.
*   **Resguardo de Credenciales:** Las contraseñas de todos los usuarios se almacenarán en la base de datos aplicando un hash seguro con sal (algoritmo bcrypt).

### RNF-04 · Usabilidad y Ergonomía
*   **Regla de los 3 Clics:** El personal de apoyo o caja debe poder localizar la ubicación exacta de cualquier variante matricial (Talla/Color) en un máximo de 3 interacciones a partir de la pantalla principal.
*   **Diseño Responsivo:** La interfaz del buscador express debe estar optimizada para pantallas táctiles de terminales de punto de venta y dispositivos móviles (tablets/smartphones) usados por el personal en el piso de venta.
*   **Claridad Visual:** El sistema debe utilizar alertas de color de alto contraste (ej. Rojo para stock cero) legibles para evitar confusiones operativas en horas punta.

### RNF-05 · Mantenibilidad
*   **Trazabilidad del Código:** Todo cambio en la lógica del sistema debe gestionarse mediante Pull Requests validados en GitHub.
*   **Auditoría de Datos:** El esquema de base de datos debe registrar automáticamente la fecha, hora y ID del usuario que realice cualquier modificación sobre las tablas de inventario y mermas.

---

## 5. Casos de Uso Principales

### CU-01 · Consultar Disponibilidad Matricial (Buscador Express)
*   **Actores:** Cajera Principal / Apoyo de Caja / Personal de Ventas
*   **Precondición:** El usuario cuenta con una sesión activa en el sistema desde cualquier terminal de la tienda.
*   **Flujo principal:**
    1. El usuario escanea el código de barras o digita la descripción de la prenda en la barra de búsqueda express.
    2. El sistema procesa la solicitud en las tablas indexadas de Supabase.
    3. El sistema despliega de forma inmediata la matriz con todas las combinaciones de Talla y Color existentes.
    4. El sistema resalta la ubicación física exacta (Almacén, Estante, Fila) del artículo seleccionado.
*   **Postcondición:** El stock y la ubicación de la prenda quedan expuestos en la pantalla del usuario.
*   **Flujo alternativo (Stock Agotado):** Si la variante consultada tiene stock igual a cero (0), el sistema sombrea el registro en color rojo y bloquea el botón de confirmación para impedir que se use ese código de barras en una transacción ficticia (cruce de códigos).

### CU-02 · Registrar Prenda Fallada en Piso de Venta
*   **Actores:** Personal de Ventas / Apoyo de Caja
*   **Precondición:** El trabajador identifica una prenda con daño físico o defecto en el piso de exhibición.
*   **Flujo principal:**
    1. El usuario accede al formulario simplificado de "Reporte de Incidencia".
    2. Escanea el código de barras de la prenda seleccionando la Talla y el Color observados.
    3. Describe brevemente el desperfecto visualizado (ej. "Mancha de tinte", "Costura suelta").
    4. El sistema guarda el registro con estado "Pendiente de Revisión" y notifica visualmente al Administrador.
*   **Postcondición:** La prenda queda pre-registrada en el sistema, a la espera de la validación del Encargado de Tienda para su descuento definitivo como merma.

### CU-03 · Registrar Baja por Merma (Aprobación)
*   **Actor:** Encargado de Tienda
*   **Precondición:** Existen prendas retenidas o reportadas con fallas pendientes de validación.
*   **Flujo principal:**
    1. El encargado ingresa al panel administrativo de mermas y revisa las incidencias enviadas por el personal de piso.
    2. Verifica físicamente el estado de la prenda dañada.
    3. Confirma la baja del producto seleccionando la opción "Aprobar Merma".
    4. El sistema descuenta de forma irreversible la unidad de la tabla de stock matricial.
*   **Postcondición:** El inventario se actualiza y el sistema genera un registro de auditoría con el ID del encargado.

---

## 6. Historias de Usuario

### HU-01 · Búsqueda Express de Variantes
> Como **cajera de la tienda**, quiero buscar una prenda filtrando por su talla y color en tiempo real, para responder rápidamente al cliente en el mostrador y agilizar las filas.

*   **Criterios de aceptación:**
    *   [ ] El motor de búsqueda filtra simultáneamente por código de barras, descripción y color.
    *   [ ] La cuadrícula de resultados muestra la ubicación física exacta del producto en el almacén.
    *   [ ] La pantalla refresca los datos de stock al instante sin requerir la recarga del sitio web completo.

### HU-02 · Verificación de Existencias en Piso de Exhibición
> Como **personal de ventas**, quiero consultar la disponibilidad de una talla específica desde mi terminal de piso, para confirmar de inmediato al cliente si tenemos la prenda en almacén sin necesidad de abandonar la zona de atención.

*   **Criterios de aceptación:**
    *   [ ] La interfaz se adapta correctamente a la pantalla de la terminal de piso o dispositivo móvil.
    *   [ ] El sistema muestra por separado el stock disponible en exhibición y el stock guardado en el almacén trasero.
    *   [ ] Si la prenda no está en la sucursal, el sistema muestra un mensaje claro indicando "Sin existencias locales".

### HU-03 · Reporte Rápido de Prendas Dañadas
> Como **apoyo de caja**, quiero pre-registrar las prendas que los clientes devuelven en el mostrador por fallas de fábrica, para apartarlas del inventario vendible y enviarlas a revisión administrativa.

*   **Criterios de aceptación:**
    *   [ ] El formulario de reporte requiere un máximo de 2 datos obligatorios: combinación matricial y motivo del descarte.
    *   [ ] Al guardar, el sistema cambia el estado de la prenda a "Inhabilitado para venta" de forma automática.
    *   [ ] El sistema emite un ticket digital de confirmación del reporte para control interno del turno.

### HU-04 · Resguardo Analítico de Mermas
> Como **encargado de tienda**, quiero revisar y aprobar formalmente las mermas reportadas por el personal, para sustentar legalmente los descuadres ante la administración central de "La Fábrica".

*   **Criterios de aceptación:**
    *   [ ] El panel administrativo muestra un listado ordenado cronológicamente con todas las pre-mermas enviadas por el personal de apoyo y ventas.
    *   [ ] Cada aprobación genera un registro histórico inmutable que asocia el ID del encargado, la fecha y la prenda eliminada del stock.
    *   [ ] Incluye una opción para exportar la lista de bajas mensuales directamente a un formato PDF estandarizado.

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
