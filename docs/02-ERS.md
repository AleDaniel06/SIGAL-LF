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
*   **Disponibilidad Absoluta:** Al ser la única terminal física de la tienda para ventas, consultas de piso y registro de mermas, el sistema web debe garantizar un tiempo de actividad $\ge 99.9\%$ en horario comercial.
*   **Persistencia ante Interrupciones:** El sistema debe retener de forma local los datos de un fardo o reporte de incidencia si se interrumpe la conexión a internet en medio de la digitación, evitando perder el progreso en la pantalla única.

### RNF-02 · Eficiencia de Desempeño ★ CRÍTICA
*   **Velocidad de Respuesta con Escáner:** El motor de Consulta Express debe procesar la lectura del escáner de códigos de barras y renderizar la cuadrícula matricial (Tallas/Colores) en $\le 0.5$ segundos. Al compartirse la pantalla entre el cobro y las consultas de los vendedores, la respuesta del periférico debe ser instantánea.
*   **Retorno Inmediato al Modo Venta:** El sistema debe permitir limpiar la consulta de stock con un solo comando de teclado o un escaneo de código de control para que la cajera retome el cobro al cliente de inmediato.

### RNF-03 · Seguridad y Control de Sesiones
*   **Cambio de Rol en Caliente:** El sistema debe permitir que el Encargado de Tienda o el Apoyo introduzcan una clave rápida o PIN en la misma terminal para autorizar tareas administrativas (como mermas) sin necesidad de cerrar por completo la sesión de venta de la cajera.
*   **Restricción de Interfaces:** Las opciones de modificación crítica de inventario o aprobación de bajas deben estar protegidas visualmente detrás de una confirmación de credenciales en el mismo equipo.

### RNF-04 · Usabilidad en Mostrador Único
*   **Compatibilidad Nativa con Periféricos:** La barra de búsqueda express debe mantener el enfoque (*focus*) automático del cursor para recibir las lecturas del escáner de códigos de barras sin necesidad de hacer clic previo en la pantalla.
*   **Interfaz de Alta Densidad:** La pantalla de Consulta Express debe mostrar toda la matriz de existencias (Talla, Color y Estante Almacén) en una sola vista compacta para que el vendedor de piso pueda leer la información de un vistazo rápido por encima del mostrador.
*   **Operación Sin Mouse:** El sistema debe configurarse para operar fluidamente combinando el escáner de códigos y atajos de teclado, minimizando el uso del mouse para agilizar el flujo de trabajo compartido.

---

## 5. Casos de Uso Principales

### CU-01 · Consultar Disponibilidad Matricial en Caja Única
*   **Actores:** Cajera Principal / Personal de Ventas / Apoyo de Caja
*   **Precondición:** El Personal de Ventas o Apoyo se acerca al mostrador con la prenda física. La terminal única está en el módulo de consulta express con el cursor listo en la barra de búsqueda.
*   **Flujo principal:**
    1. El usuario pasa la prenda por el escáner de códigos de barras de la caja.
    2. El sistema detecta el código de barras e interroga de inmediato a las tablas indexadas de Supabase.
    3. El sistema despliega en la pantalla del mostrador la cuadrícula con las combinaciones de Talla y Color disponibles junto a su ubicación física exacta en el almacén trasero.
    4. El personal de ventas visualiza la información y regresa al piso a atender al cliente.
*   **Postcondición:** Existencias y ubicación expuestas en la pantalla única tras la lectura del periférico.
*   **Flujo alternativo (Stock Cero):** Si la variante escaneada no cuenta con existencias, el sistema somete el registro a un sombreado rojo y bloquea el procesamiento de venta para erradicar el cruce manual de códigos defectuosos.

### CU-02 · Pre-registro de Incidencias en Mostrador
*   **Actores:** Apoyo de Caja / Cajera Principal
*   **Precondición:** Se detecta una prenda fallada durante el proceso de pago o el personal de ventas la trae desde el piso por una falla visible.
*   **Flujo principal:**
    1. Aprovechando un espacio entre clientes, el usuario abre el formulario rápido de "Reporte de Incidencia" en la terminal única.
    2. Pasa la prenda defectuosa por el escáner de códigos de barras; el sistema auto-completa el código y la descripción, exigiendo solo seleccionar la Talla y el Color específicos.
    3. Selecciona el tipo de desperfecto (ej. "Roto de origen", "Manchado").
    4. El sistema guarda la prenda en estado "En Verificación", restándola inmediatamente de la matriz vendible.
*   **Postcondición:** Prenda inhabilitada en el inventario desde la pantalla común mediante entrada por escáner.

### CU-03 · Aprobación y Cierre de Mermas
*   **Actor:** Encargado de Tienda
*   **Precondición:** Existen prendas pre-registradas acumuladas en la terminal pendientes de baja definitiva.
*   **Flujo principal:**
    1. El encargado toma el control de la terminal única (al final del turno o en un momento de baja afluencia).
    2. Ingresa sus credenciales administrativas para desbloquear el módulo de mermas.
    3. Valida visualmente las prendas apartadas en el contenedor físico de fallas.
    4. Confirma la baja en el sistema; el software aplica el descuento irreversible en Supabase y genera el ticket de auditoría.
*   **Postcondición:** Stock modificado de forma permanente y sesión devuelta al modo caja estándar.

---

## 6. Historias de Usuario

### HU-01 · Consulta Instantánea por Escáner en Caja Única
> Como **cajera de la tienda**, quiero que la barra de búsqueda procese las lecturas del escáner de códigos de barras instantáneamente, para poder dictar el stock matricial al vendedor de piso con un solo "pistoleo" sin interrumpir la digitación del cobro actual.

*   **Criterios de aceptación:**
    *   [ ] El campo de búsqueda express mantiene el foco activo para recibir lecturas de código de barras en cualquier momento.
    *   [ ] Muestra en una sola pantalla compacta el estante físico y las unidades disponibles por variante en menos de medio segundo.
    *   [ ] Cuenta con un botón de escape rápido (Esc) que borra la consulta y devuelve la pantalla al estado de venta.

### HU-02 · Consulta Remota a través del Mostrador
> Como **personal de ventas**, quiero acercarme a la caja, escanear el código de la prenda directamente y ver claramente desde mi posición la matriz de tallas en pantalla, para confirmar al cliente si tengo stock en almacén sin entorpecer el espacio de la cajera.

*   **Criterios de aceptación:**
    *   [ ] Los números de stock y letras de las ubicaciones (ej. STANTE A) utilizan una tipografía de gran tamaño y alto contraste para leerse a distancia del mostrador.
    *   [ ] El sistema resalta visualmente en color verde las variantes con stock disponible y en rojo opaco las variantes agotadas.

### HU-03 · Aislamiento por Escáner de Prendas Rechazadas
> Como **apoyo de caja**, quiero registrar una prenda fallada pasando su código por el escáner de barras en el formulario de incidencias, para autocompletar sus datos básicos y sacarla del inventario vendible en segundos.

*   **Criterios de aceptación:**
    *   [ ] El formulario aparece superpuesto sin necesidad de cerrar la pestaña principal de venta.
    *   [ ] La lectura del escáner rellena automáticamente el ID del producto y restringe las opciones a sus variantes físicas.
    *   [ ] Al guardar la incidencia, la variante queda bloqueada para la venta en el sistema de manera inmediata.

### HU-04 · Auditoría de Turno en Terminal Compartida
> Como **encargado de tienda**, quiero autenticar mis permisos administrativos sobre la misma pantalla de caja mediante un código PIN rápido, para validar las mermas registradas en el día sin cerrar la sesión operativa de la cajera.

*   **Criterios de aceptación:**
    *   [ ] La ventana de aprobación de mermas solicita confirmación de credenciales (PIN administrativo) antes de procesar bajas definitivas.
    *   [ ] Al finalizar la confirmación, el sistema genera automáticamente un reporte PDF resumido con los movimientos de inventario del día.
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
| Los requisitos son verificables | [X] Sí | Cada requisito funcional cuenta con flujos definidos, precondiciones y resultados comprobables mediante la interfaz de la caja única. |
| Los requisitos no son ambiguos | [X] Sí | Se eliminaron ambigüedades técnicas; el comportamiento de la Consulta Express y el uso del escáner de códigos de barras están detallados con precisión. |
| Los requisitos son completos | [X] Sí | Cubre integralmente el ciclo de la tienda: recepción de fardos, control matricial (Talla/Color), venta/consulta en mostrador único y flujo de mermas. |
| Los requisitos son consistentes | [X] Sí | No hay conflictos de concurrencia al mapear una sola terminal física. Los roles (Cajera, Ventas, Apoyo) operan bajo restricciones claras en el mismo equipo. |
| Los requisitos están priorizados | [X] Sí | Los atributos de calidad críticos e indispensables para la operación de la caja (Disponibilidad, Velocidad con Escáner) están marcados con el símbolo ★. |
| Trazabilidad a necesidades del cliente | [X] Sí | Se garantiza la correspondencia directa entre las necesidades de control local de "La Fábrica" y las funcionalidades especificadas en este documento. |

**Revisor:**Alexandra Cuchula  
**Fecha de revisión:** Julio 2026  
**Resultado:** Aprobado sin observaciones críticas  

---
*ERS v1.0 · UPLA · MDS 2026-I*
