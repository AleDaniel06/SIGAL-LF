# Incremento 2 — Motor de Persistencia y API de Integración

**Sprints:** Sprint 2 y 3  
**Semanas:** 4 a 7  
**Estado:** ✅ Completado  
**Responsables:** José Moori (API) + Alexandra Cuchula (BD) + Isabel Hurtado (QA)

---

## Objetivo del Incremento

> Construir el motor de persistencia de datos que permita el almacenamiento, rastreo relacional y segmentación detallada de prendas por atributos (Talla, Color, Ubicación) en la base de datos, y habilitar la integración con el sistema de ventas externo para el decremento automático de stock al realizar una venta. Este incremento elimina la latencia del proceso manual en Excel y resuelve el problema de "búsqueda ciega" en la tienda.

### Aspectos clave cubiertos:
* **Base de Datos Matricial:** Implementación de la tabla `inventario` en PostgreSQL (Supabase) estructurada bajo el flujo multidimensional: Código Base $\rightarrow$ Talla $\rightarrow$ Color $\rightarrow$ Ubicación Espacial.
* **Optimización:** Creación de 4 índices estratégicos para garantizar que las consultas en la terminal física de mostrador respondan en tiempos $< 1.5$ segundos.
* **API REST:** Programación de endpoints asíncronos y ligeros en Node.js + Express para la consulta express y el decremento transaccional de stock.
* **Integración Activa:** Comunicación directa con el sistema de ventas (POS) para automatizar la disminución de existencias por cada ítem cobrado en caja.
* **Auditoría Logística:** Tabla `movimientos` para el registro inmutable de transacciones, asegurando el rastreo completo de entradas, ventas y mermas.

---

## Entregables

| Artefacto | Ubicación | Responsable | Estado |
| :--- | :--- | :--- | :---: |
| Documento de Arquitectura Técnica | `docs/03-arquitectura.md` | José Moori | ✅ |
| Plan de Calidad ISO/IEC 25010 |`docs/04-plan-calidad.md` | Isabel Hurtado | ✅ |
| Casos de prueba de aceptación | `docs/05-casos-de-prueba.md` | Isabel Hurtado | ✅ |
| Esquema PostgreSQL (tablas completas) | [src/database/schema.sql](src/database/schema.sql) | Alexandra Cuchula | ✅ |
| Scripts de optimización de índices | [src/database/indices.sql](src/database/indices.sql) | Alexandra Cuchula | ✅ |
| API de consulta de stock (GET) | [src/api/stock.js](src/api/stock.js) | José Moori | ✅ |
| API de decremento por venta (POST) | [src/api/venta.js](src/api/venta.js) | José Moori | ✅ |
| Swagger/OpenAPI de la API | [src/api/swagger.yaml](src/api/swagger.yaml) | José Moori | ✅ |
| Pruebas de rendimiento (JMeter) | `incremento-2/resultados-pruebas/` | Isabel Hurtado | 🔄 Pendiente |
| Archivo .gitignore | `incremento-2/.gitignore` | Equipo | ✅ |
| Documentación adicional README1.md | `incremento-2/README1.md` | Alexandra Cuchula | ✅ |
| Informe final del Incremento 2 |`incremento-2/informe-final.md` | Equipo | 🔄 Pendiente |

---

## Issues del Incremento

> Ver todas las issues etiquetadas con `incremento-2` en el tablero del proyecto.

* `#9` Diseñar esquema completo de base de datos PostgreSQL
* `#10` Crear tabla `prendas` con código de barras único
* `#11` Crear tabla `inventario` con talla, color y ubicación
* `#12` Implementar restricción UNIQUE en `(id_prenda, talla, color, ubicacion)`
* `#13` Crear tabla `movimientos` para auditoría completa
* `#14` Crear tabla `sync_ventas` para integración
* `#15` Optimizar índices para consultas $< 1.5$s
* `#16` Implementar API de consulta de stock (`GET /api/stock/:codigo`)
* `#17` Implementar API de decremento por venta (`POST /api/inventario/venta`)
* `#18` Documentar API con Swagger/OpenAPI
* `#19` Validar integridad referencial en scripts SQL
* `#20` Pruebas de rendimiento con 2000+ registros
* `#21` Pruebas de integración con el sistema de ventas (simulado)

---

## Demostración del ciclo completo

```text
[Apoyo de Caja]
Registra fardo de Marvisur (incremento de stock)
       ↓
[Base de Datos - PostgreSQL]
Stock actualizado en matriz (Código → Talla → Color → Ubicación)
       ↓
[Cajera - Consulta Express]
Busca "Camisa Roja M" en ≤ 1.5 segundos
       ↓
[Vendedor - Mostrador]
Confirma prenda al cliente
       ↓
[Cajera - Venta]
El sistema de ventas envía POST /api/inventario/venta
       ↓
[Backend - SIGAL-LF]
Decrementa stock en < 1.5 segundos
       ↓
[Auditoría]
Movimiento registrado en tabla movimientos (tipo: 'venta')
       ↓
[Stock actualizado]
El sistema muestra el nuevo stock disponible
```
Descripción del flujo: Este ciclo de operación demuestra que la arquitectura de base de datos matricial combinada con la API de integración resuelve el problema de "búsqueda ciega" y de "latencia de Excel" en "La Fábrica". La cajera puede consultar stock en tiempo real por talla, color y ubicación, y el stock se decrementa automáticamente al realizar una venta, sin necesidad de procesos manuales intermedios.
Tiempo estimado de demostración: 3 minutos

## Estado de Calidad (SQA)

| Actividad SQA | Responsable | Herramienta | Estado |
| :--- | :--- | :--- | :---: |
| **SQA1** - Auditoría de requisitos (ERS) | Alexandra Cuchula | Checklist | ✅ |
| **SQA2** - Walkthrough de arquitectura y DER | José + Isabel | Revisión presencial | ✅ |
| **SQA3** - Análisis estático de código | Isabel (automático) | SonarCloud | ✅ |
| **SQA4** - Code Review en Pull Requests | Equipo | GitHub PR | ✅ |
| **SQA5** - Validación de integridad SQL | Alexandra Cuchula | Revisión manual | ✅ |
| **SQA6** - Pruebas de rendimiento (consultas) | José Moori | JMeter + Network Panel | ✅ |
| **SQA7** - Pruebas de integración API | Isabel Hurtado | Postman | ✅ |
| **DoD** - Definition of Done | Equipo | Checklist | ✅ |

### Métricas de rendimiento validadas:

| Métrica | Valor Objetivo | Valor Alcanzado | Estado |
| :--- | :--- | :--- | :---: |
| Tiempo de consulta de stock | $\le 1.5$ segundos | 0.8 segundos | ✅ |
| Tiempo de decremento por venta | $\le 1.5$ segundos | 0.9 segundos | ✅ |
| Consumo de RAM en PC de caja | $\le 65\%$ (2.6 GB) | $42\%$ (1.7 GB) | ✅ |
| Registros de prueba | 2000+ | 2500 registros | ✅ |
| Vulnerabilidades críticas OWASP | 0 | 0 | ✅ |
| Cobertura de código | $\ge 70\%$ | $78\%$ | ✅ |

---

## Lección Aprendida

La implementación del motor de persistencia y la API de integración confirmó que el problema de "latencia de Excel" en "La Fábrica" se resolvía completamente al eliminar la dependencia del ingeniero central. La combinación de una base de datos relacional con índices optimizados y una API REST ligera permite consultas y actualizaciones en tiempo real desde el mostrador, reduciendo el tiempo de respuesta de días a milisegundos.

* ★ **Decisión clave:** La arquitectura de la base de datos debe priorizar la velocidad de consulta sobre la complejidad del modelo. La implementación de `UNIQUE(id_prenda, talla, color, ubicacion)` evitó duplicidades y garantizó la integridad del stock en todo momento.
* ★ **Próximo paso:** El Incremento 3 se enfocará en el Panel de Auditoría de Mermas (MOD-05), el Dashboard de Consistencia y Reportes (MOD-04), y el despliegue final en producción (Render Cloud).

---
*Incremento 2 — Proyecto SIGAL-LF · UPLA · MDS 2026-1*
