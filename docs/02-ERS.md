# 02 · Especificación de Requisitos de Software (ERS v1.0)

**Proyecto:** Sistema Integrado de Gestión de Almacén e Inventario — Tiendas "La Fábrica"
**Estándar:** IEEE 830 adaptado
**Versión:** 1.0 · Julio 2026
**Estado:** Validado con cliente  

---

## 1. Introducción

### 1.1 Propósito
Este documento especifica los requisitos funcionales y no funcionales del sistema SIGAL-LF para Tiendas "La Fábrica" — Sucursal Huancayo. Está dirigido al equipo de desarrollo y al encargado de tienda para asegurar la correcta automatización de las existencias matriciales.

### 1.2 Ámbito del Sistema
El sistema se denomina **SIGAL-LF** y cubre la recepción de mercadería en fardos masivos, el control de inventario desglosado por atributos específicos (Talla, Color, Ubicación), la consulta express en mostrador de caja y el módulo de reporte de mermas. No cubre módulos de planillas de RRHH, créditos de clientes, ni compras automatizadas a proveedores externos.

### 1.3 Definiciones

| Término | Definición |
| :--- | :--- |
| **Stock Matricial** | Registro estructurado de existencias basado en ejes combinados (Talla + Color + Ubicación). |
| **Consulta Express** | Motor de búsqueda de alta velocidad integrado en caja para verificar stock real en segundos. |
| **Fardo Masivo** | Lote de mercadería cerrada enviada por la central cuya recepción exige desglose inmediato. |
| **Mermas** | Ropa o calzado que presenta fallas de origen, roturas o daños físicos que impiden su venta. |
| **Cruce de Códigos** | Mala práctica operativa donde se escanea una prenda alterna para suplantar un stock en cero. |

---

## 2. Descripción General

### 2.1 Perspectiva del Producto
SIGAL-LF es un sistema web centralizado para la tienda local que erradica el flujo manual y desarticulado de hojas Excel enviadas por correo electrónico. A diferencia del flujo anterior, las prendas recibidas físicamente se ingresan a una base de datos relacional en la nube (Supabase), permitiendo a la terminal de caja conocer el inventario real al instante.

### 2.2 Funciones Principales

SIGAL-LF
├── Módulo Caja y Piso de Venta (Web App Frontend)
│   ├── Consulta Express (Buscador por Talla / Color)
│   ├── Validación en línea de alertas de stock cero
│   └── Registro preliminar de prendas falladas
├── Módulo Administrativo Local (Dashboard Web)
│   ├── Recepción de Fardos Masivos (Ingreso Guiado)
│   ├── Gestión de Matriz de Inventario (Ubicaciones en Estantes)
│   └── Aprobación y Reportería de Mermas con Auditoría
└── Infraestructura de Datos Cloud
└── API de Persistencia Centralizada (Supabase)

### 2.3 Usuarios del Sistema

| Rol | Descripción | Módulo que usa |
| :--- | :--- | :--- |
| **Cajera Principal** | Despacha ventas y realiza búsquedas rápidas. | Consulta Express en Mostrador |
| **Encargado de Tienda** | Supervisa el stock local, fardos y mermas. | Dashboard de Administración |
| **Personal de Ventas** | Reporta fallas y asiste al cliente en piso. | Consulta Express (Modo Lectura) |

---

## 3. Requisitos Funcionales

### RF-01 · Recepción y Desglose de Fardos
*   **Descripción:** El encargado puede registrar la entrada de un fardo masivo asociando su guía de transporte, obligando al sistema a pedir la verificación de piezas antes de activar el stock.
*   **Precondición:** El fardo físico ha llegado a la tienda y existe la guía de despacho.
*   **Flujo principal:**
    1. El encargado ingresa el código de la guía de transporte.
    2. El sistema despliega la lista teórica de prendas enviadas por la central.
    3. El usuario realiza el conteo físico y digita las cantidades validadas.
    4. El sistema actualiza el stock general y registra si existieron discrepancias de origen.
*   **Postcondición:** Inventario físico ingresado y marcado como "Habilitado para la Venta".

### RF-02 · Control Matricial Completo
*   **Descripción:** Cada vez que se registra una prenda, esta debe ser indexada por su combinación exacta de propiedades físicas.
*   **Requisitos específicos:**
    *   Clasificación obligatoria por eje tridimensional: Talla, Color y Ubicación física exacta del estante.
    *   Actualización inmediata de las tres variables al confirmarse una salida o traspaso interno.

### RF-03 · Consulta Express en Caja
*   **Descripción:** La cajera busca una prenda por palabra clave o código de barra y el sistema muestra de forma instantánea sus variantes y ubicación.
*   **Flujo principal:**
    1. La cajera escribe el nombre o escanea el código de la prenda.
    2. El sistema devuelve una cuadrícula con las tallas y colores disponibles en tiempo real.
    3. El sistema indica la ubicación física exacta (ejemplo: "Estante B - Almacén Trasero").
*   **Alerta:** Si el stock de la variante consultada es cero (0), el botón de venta se bloquea visualmente para impedir el cruce fraudulento de códigos.

### RF-04 · Registro e Impresión de Mermas
*   **Descripción:** El sistema genera un reporte oficial de bajas de inventario por daños o fallas, protegiendo al personal de descuentos injustificados.
*   **Contenido del reporte:** ID del usuario, fecha, código matricial afectado, motivo detallado de la baja y opción de exportación directa.

---

## 4. Requisitos No Funcionales

### RNF-01 · Eficiencia de Desempeño ★ CRÍTICA
*   El tiempo de respuesta del buscador de Consulta Express en caja debe ser $\le 1.5$ segundos bajo una carga concurrente estándar.
*   La sincronización e inserción de datos hacia Supabase no debe congelar ni bloquear la interfaz de usuario de la cajera.

### RNF-02 · Confiabilidad y Disponibilidad ★ CRÍTICA
*   Disponibilidad de la plataforma web en la nube (Render) $\ge 99.5\%$ en horario comercial.
*   Integridad referencial estricta en base de datos para impedir que dos cajas resten stock de la misma prenda si solo queda una unidad disponible.

### RNF-03 · Seguridad
*   Autenticación obligatoria mediante contraseñas cifradas bajo algoritmo robusto (bcrypt).
*   Toda la comunicación de datos entre el navegador y el servidor en la nube se realizará sobre protocolo seguro HTTPS.

### RNF-04 · Usabilidad
*   Interfaz web optimizada para pantallas de escritorio de terminales de caja, usando un diseño limpio que reduzca las acciones operativas a un máximo de 3 clics para las búsquedas frecuentes.

---

## 5. Casos de Uso Principales

### CU-01 · Buscar Prenda en Caja
*   **Actor:** Cajera Principal / Personal de Ventas
*   **Precondición:** Sesión activa en la terminal de mostrador.
*   **Flujo:**
    1. El usuario digita el código o descripción en la barra de búsqueda express.
    2. El sistema consulta las tablas indexadas en la nube.
    3. El sistema despliega las existencias divididas por Talla, Color y Ubicación.
*   **Postcondición:** Ubicación de la prenda visualizada en pantalla.
*   **Flujo alternativo:** Si la variante no cuenta con existencias, el sistema resalta el registro en rojo y bloquea la operación.

### CU-02 · Registrar Baja por Merma
*   **Actor:** Encargado de Tienda
*   **Precondición:** Haber identificado físicamente una prenda rota o con defecto de fábrica insalvable.
*   **Flujo:**
    1. El encargado selecciona la opción "Registrar Merma".
    2. Escanea el código del producto y selecciona la combinación exacta de Talla y Color.
    3. Digita el motivo de la baja (ejemplo: "Cierre roto de fábrica").
    4. El sistema descuenta la unidad de la base de datos y genera el comprobante de auditoría.
*   **Postcondición:** Stock actualizado y reporte archivado.

---

## 6. Historias de Usuario

### HU-01 · Consulta express de variantes
> Como cajera de la tienda, quiero buscar una prenda filtrando por su talla y color en segundos para poder responder rápidamente al cliente y agilizar las filas.

*   [ ] El buscador filtra simultáneamente por código, color y talla.
*   [ ] La interfaz muestra el estante físico exacto donde se encuentra la prenda.
*   [ ] El indicador de stock se actualiza inmediatamente sin necesidad de recargar la página web.

### HU-02 · Resguardo de mermas auditadas
> Como encargado de tienda, quiero emitir un reporte impreso de las prendas dadas de baja por fallas de fábrica para sustentar los descuadres ante la central y evitar descuentos injustos en el sueldo del personal.

*   [ ] El reporte incluye la firma digital del usuario que registra la baja.
*   [ ] Bloqueo de edición del reporte una vez guardado en el sistema.
*   [ ] Opción nativa de descarga en formato PDF legible.

---

## 7. Matriz de Trazabilidad

| Requisito Alto Nivel | Req. Funcional | Req. No Funcional | Historia de Usuario |
| :--- | :--- | :--- | :--- |
| **RAN-01** (Validación de fardos) | RF-01 | RNF-02 | — |
| **RAN-02** (Control matricial) | RF-02 | RNF-02 | HU-01 |
| **RAN-03** (Consulta en caja) | RF-03 | RNF-01, RNF-04 | HU-01 |
| **RAN-04** (Reporte de mermas) | RF-04 | RNF-03 | HU-02 |

---

## 8. Checklist SQA1 — Revisión IEEE 830

| Criterio | ¿Cumple? | Observación |
| :--- | :--- | :--- |
| Los requisitos son verificables |  | Cada función cuenta con flujos claros y resultados medibles. |
| Los requisitos no son ambiguos |  | Definiciones clave explicadas detalladamente en la Sección 1.3. |
| Los requisitos son completos |  | Cubre el core operativo de la tienda local sin arrastrar elementos fuera de alcance. |
| Los requisitos son consistentes |  | No existen conflictos lógicos entre las funciones de caja y la administración. |
| Los requisitos están priorizados |  | Atributos de calidad indispensables marcados formalmente con ★. |
| Trazabilidad a necesidades del cliente |  | Conectado directamente mediante la matriz de la Sección 7. |

**Revisores:** [Tu Nombre / Integrantes del Grupo]  
**Fecha de revisión:** Julio 2026  
**Resultado:**   Aprobado sin observaciones críticas  

---
*ERS v1.0 · UPLA · MDS 2026-I*
