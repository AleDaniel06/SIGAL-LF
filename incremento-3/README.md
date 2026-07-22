# Incremento 3 — Control Operativo, Auditoría y Despliegue Final

### Detalles del Ciclo
*   **Sprints:** Sprint 4, Sprint 5 y Sprint 6 (Semanas 8 a 13)
*   **Estado:** ✅ Completado
*   **Responsables:** 
    *   **Isabel Hurtado** (QA / Auditoría de Mermas)
    *   **Alexandra Cuchula** (Analista / Dashboard y Reportes)
    *   **José Moori** (Arquitecto / Optimización y Despliegue)

---

## Objetivo del Incremento
> Completar el sistema SIGAL-LF con los módulos de control operativo (Mermas), auditoría (Dashboard y Reportes) y el despliegue final en producción. Este incremento garantiza que el supervisor pueda registrar justificadamente las pérdidas de inventario, que el equipo tenga visibilidad de la rotación de prendas y que el sistema esté completamente operativo en la PC de caja de "La Fábrica" - Sucursal Huancayo.

### Enfoques Específicos Cubiertos:
*   **Mermas:** Registro balanceado de prendas dañadas o robos verificados con motivos completamente justificados.
*   **Dashboard:** Visualización directa de la rotación textil por talla/color y detección de stock estancado.
*   **Reportes:** Exportación limpia a formatos PDF/Excel con métricas de consistencia transaccional.
*   **Despliegue:** Migración e integración del backend hacia la nube mediante Render Cloud (Free Tier).
*   **Pruebas:** Control de rendimiento y aceptación en entorno real en la PC física de caja de 4GB RAM en horas punta.
*   **Capacitación:** Entrenamiento interactivo en mostrador al personal operativo de la tienda.

---

## Entregables del Incremento

| Artefacto | Ubicación en Repositorio | Responsable | Estado |
| :--- | :--- | :--- | :---: |
| Panel de Registro de Mermas (MOD-05) | [`src/mermas/`](src/mermas/) | Isabel Hurtado | ✅ |
| Historial de Ajustes Manuales de Almacén | [`src/mermas/historial/`](src/mermas/historial/) | Isabel Hurtado | ✅ |
| Dashboard de Consistencia (MOD-04) | [`src/dashboard/`](src/dashboard/) | Alexandra Cuchula | ✅ |
| Reportes de Rotación (PDF/Excel) | [`src/reportes/`](src/reportes/) | Alexandra Cuchula | ✅ |
| Consulta Express optimizada | [`src/consulta/`](src/consulta/) | José Moori | ✅ |
| Congelamiento de precios (LocalStorage) | `src/consulta/contingencia.js` | José Moori | ✅ |
| Scripts de despliegue (Render) | `deploy/render.yaml` | José Moori | ✅ |
| Informe de pruebas de carga (JMeter) | `incremento-3/resultados-pruebas/` | Isabel Hurtado | ✅ |
| Manual de Usuario | `docs/06-manual-usuario.md` | Alexandra Cuchula | ✅ |
| Manual Técnico de Integración | `docs/07-manual-tecnico.md` | José Moori | ✅ |
| Acta de Capacitación al Personal | `incremento-3/acta-capacitacion.md` | Alexandra Cuchula | ✅ |
| Informe final del Incremento 3 | `incremento-3/informe-final.md` | Equipo | ✅ |

---

## Issues del Incremento

*   `#22` Diseñar formulario de registro de mermas (supervisor)
*   `#23` Implementar validación de motivos obligatorios
*   `#24` Crear historial de ajustes manuales de almacén
*   `#25` Implementar consultas SQL para rotación por talla/color
*   `#26` Desarrollar Dashboard de consistencia de saldos
*   `#27` Implementar exportación a PDF y Excel
*   `#28` Optimizar Consulta Express para PC de 4GB RAM
*   `#29` Implementar congelamiento de precios (LocalStorage)
*   `#30` Configurar despliegue en Render Cloud
*   `#31` Pruebas de aceptación en PC de caja (horas punta)
*   `#32` Pruebas de rendimiento (consultas < 1.5s)
*   `#33` Capacitación al personal de la tienda
*   `#34` Release 1.0 - Producción final

---

## Demostración del Ciclo Completo

```text
[Supervisor - Mermas]
       │ Registra prenda dañada con motivo "Falla de Costura"
       ▼
[Base de Datos]
       │ Stock disminuye justificadamente en 2 unidades
       ▼
[Supervisor - Dashboard]
       │ Verifica consistencia de saldos entre almacén y ventas
       ▼
[Supervisor - Reportes]
       │ Genera reporte de rotación por talla/color en PDF/Excel
       ▼
[Supervisor - Análisis]
       │ Identifica stock estancado y toma decisiones estratégicas
       ▼
[Personal - Capacitado]
       │ Opera el sistema sin errores en horas punta de atención
       ▼
[Sistema - Producción]
       └─► SIGAL-LF funcionando en PC de caja con < 1.5s de respuesta
```
### Descripción del Flujo
> **Este ciclo de operación demuestra que SIGAL-LF resuelve completamente los 4 problemas identificados en el diagnóstico:** Elimina la latencia de Excel, erradica el cruce de códigos, resuelve la búsqueda ciega y protege el sueldo del personal. El supervisor tiene control total de las pérdidas, el equipo tiene visibilidad de la rotación, y la cajera opera con un sistema rápido y confiable en la PC de 4GB RAM.

*   **Tiempo estimado de demostración:** 5 minutos

---

## Estado de Calidad (SQA)

### Actividades SQA Ejecutadas
| Actividad SQA | Responsable | Herramienta | Estado |
| :--- | :--- | :--- | :---: |
| **SQA1** - Auditoría de requisitos | Alexandra Cuchula | Checklist | ✅ |
| **SQA2** - Walkthrough de arquitectura | José + Isabel | Revisión presencial | ✅ |
| **SQA3** - Análisis estático de código | Isabel Hurtado | SonarCloud | ✅ |
| **SQA4** - Code Review en Pull Requests | Equipo | GitHub PR | ✅ |
| **SQA5** - Validación de integridad SQL | Alexandra Cuchula | Revisión manual | ✅ |
| **SQA6** - Pruebas de rendimiento (consultas) | José Moori | JMeter + Network Panel | ✅ |
| **SQA7** - Pruebas de aceptación en PC real | Isabel Hurtado | Casos de prueba | ✅ |
| **SQA8** - Pruebas de carga (horas punta) | Isabel Hurtado | JMeter | ✅ |
| **DoD** - Definition of Done | Equipo | Checklist | ✅ |

### Métricas Finales Validadas
*   **Tiempo de consulta de stock:** 0.8 segundos *(Objetivo: ≤ 1.5s)* ✅
*   **Tiempo de decremento por venta:** 0.9 segundos *(Objetivo: ≤ 1.5s)* ✅
*   **Tiempo de generación de reporte:** 2.1 segundos *(Objetivo: ≤ 3.0s)* ✅
*   **Consumo de RAM en PC de caja:** 40% / 1.6 GB *(Objetivo: ≤ 65% / 2.6 GB)* ✅
*   **Vulnerabilidades críticas OWASP:** 0 *(Objetivo: 0)* ✅
*   **Cobertura de código:** 82% *(Objetivo: ≥ 70%)* ✅
*   **Tasa de error humano en digitación:** 0.8% *(Objetivo: < 2%)* ✅
*   **Registros de stock corruptos:** 0% *(Objetivo: 0%)* ✅

---

## Lección Aprendida

> La implementación del módulo de mermas y el dashboard de reportes confirmó que el problema de "cruce de códigos" y "descuadres económicos" en "La Fábrica" se resuelve completamente al proporcionar al supervisor visibilidad en tiempo real del inventario y herramientas para justificar las pérdidas. La capacidad de registrar mermas con motivos verificables elimina la necesidad de cruzar códigos en el mostrador y protege el sueldo del personal operativo.
> 
> **Decisión clave:** La tabla `movimientos` con auditoría completa fue fundamental para rastrear cada transacción (entradas, ventas, mermas, ajustes), proporcionando transparencia total y eliminando los descuadres que afectaban al personal.
> 
> **Logro final:** SIGAL-LF está completamente operativo en la PC de caja de "La Fábrica" - Sucursal Huancayo, con tiempos de respuesta < 1.5 segundos, consumo de RAM < 2GB y cobertura de código del 82%. El sistema ha sido validado por el personal operativo y está listo para su uso en producción.

---
*Incremento 3 — Proyecto SIGAL-LF · UPLA · MDS 2026-1*
