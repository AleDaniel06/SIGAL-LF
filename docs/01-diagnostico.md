# 01 · Diagnóstico Organizacional — Tiendas "La Fábrica"

Proyecto: Sistema SELLA SIGAL-LF
Grupo: 01 · Metodología de Desarrollo de Software · V Semestre 2026-I

| **Atributo**        | **Detalle**                                                                                                             |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **Nombre**          | La Fábrica (Sucursal Calle Real)                                                                                        |
| **Ubicación**       | Calle Real, Huancayo, Región Junín, Perú                                                                                |
| **Rubro**           | Retail de prendas de vestir, calzado y moda masiva.                                                                     |
| **Antigüedad**      | Más de 35 años de operación.                                                                                            |
| **Tamaño**          | 10 colaboradores.                                                                                                       |
| **Infraestructura** | Local comercial de aproximadamente **450 m²**, con área de ventas, mostradores de caja y un almacén de tamaño moderado. |
| **Soporte TI**      | No cuenta con un área ni personal de soporte TI.                                                                   |
| **Operación**       | El proyecto se centra en optimizar los procesos de Caja y Almacén de la sucursal.                                       |

## 2. Sistema Actual — Procesamiento Manual y Excel Asíncrono
El flujo operativo de inventario en la sucursal Huancayo está desarticulado y presenta etapas críticas que evidencian ineficiencias:
| **Etapa / Proceso**                  | **Descripción (resumida)**                                                                                                                                                                            |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Recepción y Control de Calidad**   | La mercadería llega en fardos con guía física. El personal realiza el conteo y la inspección de forma manual, generando demoras y posibles errores.                                                   |
| **Procesamiento (Excel)**            | La cajera registra el inventario en Excel y lo envía por correo a la sede central para su actualización. Durante ese tiempo, los productos permanecen con **stock 0** en el sistema.                  |
| **Venta de Contingencia**            | Cuando un producto no está actualizado en el sistema, se vende utilizando el código de otro artículo con el mismo precio, ocasionando inconsistencias en el inventario y posibles descuadres de caja. |
| **Búsqueda y Control de Inventario** | El sistema no muestra talla, color ni ubicación de las prendas. La búsqueda es manual y los registros de contingencia provocan diferencias en los inventarios y pérdidas económicas.                  |

### Flujo Representativo
                 ┌──────────────┐
                 │   PROCESO    │
                 └──────┬───────┘
                        │
                        ▼
           ┌────────────────────────┐
           │ Recepción de           │
           │ mercadería             │
           └──────────┬─────────────┘
                      │
                      ▼
           ┌────────────────────────┐
           │ Conteo e inspección    │
           │ manual                 │
           └──────────┬─────────────┘
                      │
                      ▼
           ┌────────────────────────┐
           │ Registro en Excel      │
           └──────────┬─────────────┘
                      │
                      ▼
           ┌────────────────────────┐
           │ Envío a sede central   │
           └──────────┬─────────────┘
                      │
                      ▼
           ┌────────────────────────┐
           │ Actualización del      │
           │ sistema                │
           └──────────┬─────────────┘
                      │
                      ▼
              ◇ ¿Stock actualizado? ◇
                 /                 \
               Sí                   No
               │                     │
               ▼                     ▼
      ┌──────────────┐      ┌─────────────────┐
      │ Venta normal │      │ Código alterno │
      └──────┬───────┘      └────────┬────────┘
             │                       │
             └───────────┬───────────┘
                         ▼
          ┌─────────────────────────────┐
          │ Descuadre de inventario y   │
          │ pérdidas económicas         │
          └─────────────────────────────┘

## 3. Diagnóstico: Problemas Identificados

### 3.1 Problema Principal — Descalce crítico de inventario y latencia de datos transaccionales
Este es el problema raíz. El proceso actual genera una brecha temporal severa entre la disponibilidad física del producto en piso de venta y su habilitación en el sistema lógico. Esto destruye la trazabilidad por características (Talla, Color, Ubicación) y traslada el costo financiero de los descuadres directamente a los trabajadores.

*   **Frecuencia:** Diario, agudizándose en la recepción de campañas estacionales masivas.
*   **Impacto estimado:** Pérdida de horas hombre en conteos repetitivos, corrupción total del inventario lógico y penalizaciones económicas recurrentes al personal de tienda.

### 3.2 Problemas Derivados

| ID | Problema en la Tienda | Impacto Real en el Negocio |
| :--- | :--- | :--- |
| **P1** | La mercadería llega en fardos gigantes y se cuenta manualmente. | Se pierde demasiado tiempo y es muy fácil que no se noten las prendas que vinieron falladas de fábrica. |
| **P2** | El stock real tarda horas (o días) en aparecer en el sistema porque depende de un Excel enviado por correo. | Hay ropa lista en la tienda para ser vendida, pero la caja no la puede pasar porque en el sistema figura con "stock cero". |
| **P3** | Para no perder la venta, la cajera escanea el código de otra prenda que cuesta lo mismo. | El sistema se vuelve una locura: empieza a marcar que se vendieron cosas que siguen en el estante y viceversa. |
| **P4** | El sistema actual no muestra si la prenda es talla S, M o L, ni su color o en qué estante está. | El personal busca "a ciegas" en el almacén, haciendo perder tiempo al cliente y generando colas en la caja. |
| **P5** | Los inventarios finales nunca cuadran y el personal debe pagar los faltantes de su propio bolsillo. | El equipo trabaja desmotivado, hay un clima de desconfianza y los empleados terminan renunciando rápido. |

### 3.3 Análisis de Causa Raíz
Aplicando el modelo de contexto socio-técnico (Sommerville, 2011):

*   **Causa técnica:** Inexistencia de un sistema web local centralizado con base de datos relacional capaz de gestionar stock matricial y registrar mermas en tiempo real.
*   **Causa operativa:** Dependencia de la digitación manual en hojas de cálculo locales y validaciones externas por correo hacia la central.
*   **Causa de entorno/cultura:** Alta presión transaccional en caja combinada con la restricción estricta del uso de dispositivos móviles personales en el piso de venta, forzando la necesidad de una solución centralizada en la terminal de mostrador.

---

## 4. Requisitos de Alto Nivel

A partir del diagnóstico, se identifican los siguientes requisitos de alto nivel que debe cumplir el nuevo sistema SIGAL-LF:

| ID | Requisito | Prioridad |
| :--- | :--- | :--- |
| **RAN-01** | El sistema debe automatizar el registro y validación del ingreso de mercadería por fardos | Alta |
| **RAN-02** | Control matricial estricto de existencias desglosado por Talla, Color y Ubicación física | Alta |
| **RAN-03** | Módulo de Consulta Express en mostrador de caja para verificación inmediata de stock local | Alta |
| **RAN-04** | Registro, control y reportería automatizada de mermas e incidencias de fábrica | Alta |
| **RAN-05** | Interfaz web responsiva optimizada exclusivamente para terminales de escritorio de caja | Media |
| **RAN-06** | Generación de reportes de auditoría de inventario para validación de cuentas del personal | Alta |

---

## 5. Justificación del Nuevo Sistema

El nuevo sistema **SIGAL-LF** no busca replicar el flujo administrativo externo de la central, sino resolver el vacío operativo en el punto de venta. Convierte la caja y el almacén local en un entorno digitalizado en tiempo real, erradicando las ventas de contingencia por códigos cruzados y proporcionando un escudo de transparencia analítica que protege al trabajador de las penalizaciones por pérdidas que no causó.

---

## 6. Alcance del Proyecto

### Dentro del alcance
*   **Módulo 01: Autenticación y Control de Accesos:** Perfiles diferenciados (Encargado de Tienda, Cajera Principal, Personal de Ventas).
*   **Módulo 02: Recepción de Mercadería:** Registro de fardos, conteo de piezas y detección temprana de fallas.
*   **Módulo 03: Stock Matricial:** Gestión del inventario cruzado por atributos específicos (Tallas, Colores, Ubicaciones).
*   **Módulo 04: Consulta Express:** Buscador ultra-rápido integrado en caja para mitigar colas de clientes.
*   **Módulo 05: Reporte de Mermas:** Registro justificado de roturas, fallas de origen y desfases físicos.
*   **Infraestructura Cloud:** Base de datos relacional en la nube (Supabase) y despliegue del servicio web (Render).

### Fuera del alcance
*   Módulo de facturación electrónica directa con SUNAT (Se mantiene el core transaccional de caja actual).
*   Gestión de planillas, recursos humanos o asistencia del personal de tienda.
*   Módulo de compras o pasarela de pagos integrados con proveedores externos.
*   Aplicación móvil nativa para clientes finales.

---
*Documento elaborado por Grupo [Número] — UPLA · MDS 2026-I*
