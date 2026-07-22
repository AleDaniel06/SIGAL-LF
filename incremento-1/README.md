# Incremento 1 — Cimientos de Seguridad y Recepción Logística

**Semanas:** 2 y 3 (Sprint 1)  
**Estado:** ✅ Completado  
**Responsable:** José Moori (Scrum Master / Arquitecto Técnico)

---

## Objetivo del Incremento

> Establecer la base de seguridad del sistema SIGAL-LF y habilitar el primer flujo operativo crítico: el registro de recepción de fardos de Marvisur. Este incremento garantiza que solo personal autorizado pueda acceder al sistema y que la entrada de mercadería quede registrada de forma inmediata y confiable en la base de datos centralizada, eliminando la latencia del proceso manual en Excel.

### Aspectos clave cubiertos:
* **Autenticación:** Implementación de login seguro con encriptación de contraseñas mediante la librería `bcrypt` en el backend.
* **Control de Acceso:** Roles diferenciados basados en el modelo RBAC (**Apoyo de Caja**, **Cajera Principal**, **Encargado de Tienda**) con interfaces y vistas específicas para mitigar errores operativos.
* **Recepción de Fardos:** Formulario web nativo y optimizado para el registro veloz de prendas recibidas por encomienda terrestre desde Marvisur.
* **Actualización de Stock:** Inyección e incremento automático de existencias en las tablas base al procesar el guardado del fardo.
* **Validación de Calidad:** Obligatoriedad en la clasificación del estado de cada prenda (Conforme, Falla de Costura, Manchado) como requisito previo para habilitar el stock comercializable.

---

## Entregables

| Artefacto | Ubicación | Estado |
| :--- | :--- | :---: |
| Diagnóstico organizacional y análisis de contexto | `docs/01-diagnostico.md` | ✅ |
| Especificación de Requisitos de Software (ERS) v1.0 | `docs/02-ERS.md` | ✅ |
| Wireframes y prototipos UI (Figma) | [Ver en Figma →](https://www.figma.com/make/uZrBafr9Ie5NdCXooxZ4M2/Sistema-de-Inventario?fullscreen=1&t=35yQ2zDvDHuZXCLS-1&code-node-id=0-9) | ✅ |
| Script SQL de inicialización de tablas (`usuarios`, `prendas`, `inventario`) | `incremento-1/sql/init.sql` | ✅ |
| Módulo de Autenticación (Login + RBAC) | `incremento-1/auth/` | ✅ |
| Interfaz de Recepción de Carga (Formulario web Vanilla JS) | `incremento-1/recepcion/` | ✅ |
| API base de lectura de stock (`GET /api/stock/:codigo`) | `incremento-1/api/` | ✅ |
| Checklist SQA1 (Auditoría de requisitos) | `docs/02-ERS.md#checklist` | ✅ |
| Acta de validación con el equipo de "La Fábrica" | `incremento-1/acta-validacion.md` | ✅ |
| Casos de prueba iniciales (Autenticación y Recepción) | `docs/05-casos-de-prueba.md` | ✅ |

---

## Issues del Incremento

Ver todas las issues etiquetadas con `incremento-1` en el tablero del proyecto.

* `#1` Configurar proyecto Node.js con Express
* `#2` Diseñar modelo de datos relacional para usuarios y prendas
* `#3` Implementar registro seguro de usuarios y login con encriptación
* `#4` Crear interfaz web de recepción de fardos entrantes
* `#5` Implementar lógica del servidor para el incremento automático de stock
* `#6` Validación obligatoria de calidad de prendas en el formulario de recepción
* `#7` Pruebas unitarias de autenticación y verificación de autorización (RBAC)
* `#8` Revisión y auditoría SQA1 de la Especificación de Requisitos

---

## Lección Aprendida

El diagnóstico confirmó que el problema principal de "La Fábrica" - Sucursal Huancayo no era únicamente la falta de digitalización del inventario, sino la **dependencia de un proceso manual asíncrono con el ingeniero central**. La latencia de actualización (archivo Excel → correo → ingeniero central → sistema) era el verdadero cuello de botella que provocaba que el stock virtual estuviera permanentemente desactualizado, generando el cruce de códigos en mostrador y los descuadres económicos que afectaban al personal.

★ **Decisión clave de arquitectura:** Esta conclusión determinó que la arquitectura de SIGAL-LF debía ser **centralizada en la nube con actualización en tiempo real**, eliminando por completo la dependencia de procesos manuales intermedios. El Incremento 2 se enfocará en construir la estructura del motor de persistencia que permita la consulta de stock desglosada de forma exacta por talla, color y ubicación espacial.

🟢 **Validación de entorno socio-técnico:** La restricción de no uso de celulares en el piso de venta fue confirmada como un factor crítico durante el levantamiento de información. Esto reafirmó la decisión de centralizar el software en la terminal física de la caja, convirtiendo a la cajera en el nodo central de consulta a viva voz para dar soporte ágil a los vendedores en el piso.

---

## Estado de Calidad (SQA) del Incremento

| Actividad SQA | Responsable | Estado |
| :--- | :--- | :---: |
| **SQA1** - Auditoría estricta de requisitos (ERS) | Alexandra Cuchula | ✅ Completado |
| **SQA2** - Walkthrough de arquitectura y diseño relacional del DER | José Moori + Isabel Hurtado | ✅ Completado |
| **SQA3** - Análisis estático automático de código (Anti-patterns/SQL Injection) | Isabel Hurtado | ✅ Aprobado |
| **SQA4** - Code Review cruzado en Pull Requests de GitHub | Célula de Ingeniería | ✅ Aprobado |
| **DoD** - Verificación del cumplimiento del *Definition of Done* por ítem | Célula de Ingeniería | ✅ Verificado |

---
*Incremento 1 — Proyecto SIGAL-LF · UPLA · MDS 2026-1*
