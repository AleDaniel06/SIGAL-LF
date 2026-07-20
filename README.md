# 🏬 SIGAL-LF: Sistema Integrado de Gestión de Almacén e Inventario
### Tienda "La Fábrica" — Sucursal Huancayo (Calle Real)

<p align="center">
  <img src="https://img.shields.io/badge/Curso-Metodología_del_Desarrollo_de_Software-blue?style=for-the-badge" alt="Curso">
  <img src="https://img.shields.io/badge/Ciclo-V_Semestre_2026--I-green?style=for-the-badge" alt="Ciclo">
  <img src="https://img.shields.io/badge/Sección-A1-orange?style=for-the-badge" alt="Sección">
</p>

---

## 🏛️ Información Institucional
* **Institución:** Universidad Peruana Los Andes (UPLA)
* **Facultad:** Ingeniería
* **Escuela:** Ingeniería de Sistemas y Computación
* **Docente:** Mtro. Jaime Huaytalla Pariona]

---

## 👥 Integrantes

| Nombre | Rol en el proyecto |
|--------|-------------------|
| Alexandra Milagros Cuchula Daniel | Product Owner Proxy / Analista de Negocio |
| José Andrés Moori Zegarra | Scrum Master / Arquitecto Técnico |
| Isabel Hurtado | Ingeniera de Software / Aseguramiento de Calidad (QA) |

---

## 🎯 Contexto del Problema

**Cliente:** Tienda "La Fábrica" — Sucursal Huancayo, Calle Real, Junín

**Problema:** El sistema de inventario actual opera con procesos manuales en Excel que generan latencia crítica. La mercadería llega en fardos de Marvisur, se cuenta manualmente, se transcribe a Excel y se envía por correo a un ingeniero central. Mientras esto ocurre, el stock virtual figura en "cero", forzando a la cajera a cruzar códigos en el mostrador.

**Impacto real:**
- ❌ Pérdida de ventas por stock desactualizado
- ❌ Cruce de códigos que altera el inventario lógico
- ❌ Búsqueda ciega de prendas (sin talla/color/ubicación)
- ❌ Descuadres económicos cobrados al personal

---

## 💡 Solución Propuesta

**Arquitectura centralizada con actualización en tiempo real:**  
SIGAL-LF es una aplicación web centralizada que elimina la latencia del proceso manual en Excel. El inventario se actualiza en tiempo real desde la recepción de fardos de Marvisur, permitiendo consultas instantáneas por código, talla, color y ubicación desde la PC de caja. El sistema incluye módulos de autenticación, recepción, stock matricial, consulta express, mermas y reportes.

**Características clave:**
- ✅ Actualización de stock en tiempo real
- ✅ Matriz multidimensional: Código → Talla → Color → Ubicación
- ✅ Consulta express en < 1.5 segundos
- ✅ Registro de mermas justificadas
- ✅ Dashboard de rotación y consistencia
- ✅ Exportación a PDF y Excel

---

## 🛠️ Stack Tecnológico

| Capa | Tecnología | Justificación |
|------|------------|---------------|
| **Aplicación Web (Frontend)** | HTML5 + CSS3 + Vanilla JS | Sin frameworks pesados, optimizado para PC de 4GB RAM |
| **Backend API** | Node.js + Express.js | Entorno ligero, mismo ecosistema JavaScript del equipo |
| **Base de Datos** | PostgreSQL (Supabase) | Open source, robusto, transacciones ACID, gratuito |
| **ORM/Query Builder** | Prisma | Queries tipadas, evita SQL manual propenso a errores |
| **Despliegue** | Render Cloud | Free tier, despliegue automatizado con GitHub webhooks |
| **Control de Versiones** | GitHub | Gestión de código, Pull Requests, GitHub Projects |
| **Análisis Estático** | SonarCloud | Detección de vulnerabilidades OWASP Top 10 |
| **Pruebas Unitarias** | Jest | Pruebas del motor de sincronización |
| **Pruebas de Carga** | Apache JMeter | Pruebas de rendimiento y concurrencia |

**Costo total: $0.00**

---

## 📐 Metodología

**Modelo de Proceso: Scrum (Adaptado con Integración Continua de Datos)**

Este proyecto aplica Scrum porque los requisitos del cliente evolucionan constantemente en el entorno retail textil, y el equipo necesita entregar valor de forma incremental cada 2 semanas. Scrum permite probar la ligereza de la interfaz en la PC de 4GB RAM desde las primeras iteraciones.

### Evaluación de alternativas metodológicas

| Criterio de Evaluación | Modelo en Cascada (Tradicional) | Modelo Espiral (Basado en Riesgos) | Marco de Trabajo Scrum (Ágiles) |
|------------------------|--------------------------------|-----------------------------------|--------------------------------|
| **a. Adecuación al nivel de claridad de los requisitos** | **Baja.** Asume que los requisitos se mantienen estáticos. Fracasaría ante las variaciones semanales de precios e ingresos de fardos de La Fábrica. | **Alta.** Permite la evolución progresiva de los requisitos, pero la sobrecarga de análisis inicial dilata el inicio de la programación de código. | **Alta.** Diseñado para entornos volátiles. Permite refinar, priorizar y reestructurar las reglas logísticas en el Product Backlog en cada ciclo. |
| **b. Tolerancia al riesgo técnico del proyecto** | **Baja.** La integración se ejecuta en la fase final, provocando que la lentitud en la PC de caja antigua se detecte de manera tardía e irreversible. | **Muy Alta.** Centrado en la evaluación matemática de riesgos, aportando una solidez técnica que excede las necesidades de este sistema local. | **Alta.** Los riesgos de compatibilidad y rendimiento de hardware se mitigan mediante pruebas de incremento reales en la PC de caja en cada Sprint. |
| **c. Compatibilidad con la madurez del equipo** | **Media/Baja.** Requiere la elaboración de documentación técnica estática y masiva previa a la codificación, saturando la capacidad de tres integrantes. | **Baja.** Exige un alto nivel de experiencia corporativa avanzada y el uso de herramientas estadísticas de riesgo, inadecuado para pregrado. | **Alta.** Promueve la autoorganización y la comunicación directa en células de tamaño reducido. Optimiza las capacidades del equipo Cuchula-Moori-Hurtado. |
| **d. Requisitos de documentación del cliente** | **Muy Alta.** Produce manuales y especificaciones rígidas de ingeniería. La administración de la tienda prefiere resultados operativos y visuales rápidos. | **Alta.** Documentación robusta enfocada en planes corporativos de mitigación de fallos logísticos y actas de control cíclico. | **Modificada.** Prioriza el código funcional sobre la documentación, adaptándose para generar actas de validación de inventario. |
| **e. Velocidad de entrega de valor al cliente** | **Muy Baja.** Sigue el principio de "todo o nada". La tienda continuaría perdiendo dinero y descuadrando caja durante meses antes de ver una pantalla funcional. | **Media.** Las entregas son progresivas mediante prototipos evolutivos de ingeniería, lo cual ralentiza la atención a los dolores urgentes. | **Muy Alta.** Garantiza la entrega de un módulo de software utilizable y operativo (ej. consulta rápida de stock) al término de cada iteración de 2 semanas. |

### Justificación de la elección

**Scrum fue seleccionado unánimemente porque:**

1. **Naturaleza Empírica frente a la Volatilidad del Retail:** En la sucursal de "La Fábrica", las variables operativas cambian de forma imprevista (traslados inter-tiendas de Marvisur no programados y fluctuaciones de precios sin aviso). Scrum permite que el sistema evolucione de forma quincenal a través de la retroalimentación directa en el mostrador.

2. **Mitigación Temprana del Riesgo de Hardware:** Al ser la máquina de caja un equipo antiguo con 4GB RAM, Scrum obliga al equipo a entregar un incremento de software utilizable al final de cada Sprint, permitiendo probar la ligereza de la interfaz web directamente en la computadora de la tienda desde las primeras semanas.

3. **Idoneidad para Equipos Reducidos:** Modelos complejos como el Espiral demandan comités de gestión de riesgos que consumirían el tiempo de codificación de un equipo de tres personas. Scrum proporciona un marco ligero que elimina la burocracia técnica.

---

## 🚀 Incrementos del Proyecto

| Incremento | Sprints | Semanas | Contenido | Módulos |
|------------|---------|---------|-----------|---------|
| **Incremento 1** | Sprint 1 | Semana 2-3 | Seguridad + Recepción de Carga | MOD-01, MOD-02 |
| **Incremento 2** | Sprint 2 + 3 | Semana 4-7 | Stock Matricial + API de Integración | MOD-03 (completo) |
| **Incremento 3** | Sprint 4 + 5 + 6 | Semana 8-13 | Mermas + Dashboard + Despliegue | MOD-04, MOD-05, Release |

**Detalle de cada incremento:**

- **Incremento 1 (Semanas 2-3):** Autenticación de usuarios (RBAC), registro de recepción de fardos de Marvisur, API base de lectura de stock.
- **Incremento 2 (Semanas 4-7):** Motor de persistencia con stock matricial (talla/color/ubicación), API de integración con POS para decremento automático por ventas.
- **Incremento 3 (Semanas 8-13):** Panel de mermas, dashboard de consistencia, reportes exportables (PDF/Excel), pruebas de aceptación en PC real, despliegue en Render Cloud.

---

## 📁 Estructura del Repositorio
El árbol jerárquico del repositorio organiza el código y la documentación técnica de manera limpia y modular:

```text
sigal-lf/
├── .gitignore # Archivos ignorados por Git
├── README.md # Este archivo
│
├── assets/
│ └── diagramas/
│ ├── Pantalla-1-POS.md # Diagrama de Consulta Express
│ ├── Pantalla-2-cierre-de-caja.md # Diagrama de Cierre/Caja
│ └── Pantalla-3-dashboard.md # Diagrama de Dashboard
│
├── docs/
│ ├── 01-diagnostico.md # Diagnóstico organizacional
│ ├── 02-ERS.md # Especificación de Requisitos
│ ├── 03-arquitectura.md # Diseño de arquitectura
│ ├── 04-plan-calidad.md # ISO 25010 + SQA Shift Left
│ ├── 05-casos-de-prueba.md # Casos de prueba (SQA5 y SQA6)
│ └── 06-manual-usuario.md # Manual de usuario
│
├── incremento-1/
│ └── README.md # Artefactos del Incremento 1
│
├── incremento-2/
│ ├── README.md # Artefactos del Incremento 2
│ ├── .gitignore # .gitignore específico del incremento
│ └── README1.md # Documentación adicional
│
└── incremento-3/
└── README.md # Artefactos del Incremento 3
```

---

## ⚠️ Plan de Mitigación de Riesgos (5 Riesgos)

| # | Riesgo | Probabilidad (1-5) | Impacto (1-5) | Severidad | Mitigación | Contingencia |
|---|--------|-------------------|---------------|-----------|------------|--------------|
| 1 | **Degradación del rendimiento por consumo de RAM en PC de caja** | 3 | 4 | 12 | Prohibición de frameworks pesados, uso de Vanilla JS | Limpieza automática de memoria y paginación de resultados si RAM > 85% |
| 2 | **Caída del enlace de internet local durante actualización de saldos** | 4 | 5 | 20 | Transacciones ACID con rollback automático | Cola de peticiones asíncronas en LocalStorage, sincronización al recuperar red |
| 3 | **Falta de adopción del sistema por el personal operativo** | 3 | 4 | 12 | Capacitación presencial, manual de usuario | Interfaz intuitiva con dropdowns, feedback continuo del personal |
| 4 | **Pérdida de datos por fallo en Supabase (servidor cloud)** | 2 | 5 | 10 | Backups automáticos diarios en Supabase | Rollback ACID, sincronización asíncrona, logs de auditoría |
| 5 | **Incumplimiento del cronograma por sobrecarga académica** | 4 | 3 | 12 | Daily Scrum, priorización de backlog | Ajuste de alcance del MVP, reducción de features opcionales |

---

## ✅ Plan de Calidad ISO/IEC 25010

| Característica | Nivel | Métrica |
|----------------|-------|---------|
| **Eficiencia de Desempeño** | 5/5 ★ | Tiempo de respuesta ≤ 1.5 segundos · Consumo RAM ≤ 65% (2.6GB) |
| **Fiabilidad** | 5/5 ★ | 0% de registros corruptos · Rollback automático ACID |
| **Usabilidad** | 5/5 ★ | Tasa de error humano < 2% · Selectores fijos (dropdowns) |
| **Seguridad** | 5/5 ★ | 0 vulnerabilidades críticas OWASP Top 10 |

---

## 🔧 Estrategia SQA (Shift Left) — 7 Actividades

| ID | Actividad | Fase | Shift Left | Responsable | Herramienta |
|----|-----------|------|------------|-------------|-------------|
| SQA1 | Auditoría de requisitos y criterios de aceptación | Sprint 0 | Sí | Alexandra Cuchula | GitHub Projects + Checklist |
| SQA2 | Walkthrough de arquitectura y DER | Sprint 0 | Sí | José Moori + Isabel Hurtado | Revisión presencial |
| SQA3 | Análisis estático automático de código | Sprint 1-6 | Sí | Isabel Hurtado | SonarCloud + GitHub Actions |
| SQA4 | Code Review obligatorio en cada Pull Request | Sprint 1-6 | Sí | Equipo (rotativo) | GitHub Pull Requests |
| SQA5 | Validación de integridad referencial en scripts SQL | Sprint 2 | Sí | Alexandra Cuchula | Revisión manual de scripts |
| SQA6 | Pruebas de aceptación en PC de caja (4GB RAM) | Sprint 6 | Parcial | Isabel Hurtado | Casos de prueba (doc 05) |
| SQA7 | Pruebas de rendimiento y carga (JMeter) | Sprint 6 | Parcial | José Moori | Apache JMeter |

---

## 📊 Seguimiento del Proyecto

El avance se gestiona mediante **GitHub Projects** con tablero Kanban.  
Cada tarea está asignada a un integrante y vinculada a su incremento.

- **Issues activas** → Tablero del proyecto
- **Milestones** → Cierre Incremento 1 · Cierre Incremento 2 · Cierre Incremento 3
- **Etiquetas** → `incremento-1` `incremento-2` `incremento-3` `sqa` `análisis` `diseño` `backend` `frontend`

---
## 💭 Reflexión del Equipo

### Alexandra Milagros Cuchula Daniel — Product Owner Proxy

> "El desarrollo de este plan integral me ha demostrado que la ingeniería de requisitos es una disciplina viva que no puede automatizarse con herramientas de texto genéricas. Al asumir el rol de Product Owner Proxy, entendí que un modelo tradicional en Cascada habría conducido al proyecto al fracaso total en una sucursal minorista como la nuestra. Documentar requisitos estáticos al inicio del semestre nos habría impedido adaptarnos a los cambios semanales en las reglas de asignación y en los flujos transaccionales de caja. El uso de Scrum nos permitió refinar el backlog en cada ciclo quincenal, asegurando que mi conocimiento práctico del mostrador textil se tradujera fielmente en interfaces web de alta usabilidad sin retrasar los plazos académicos."

### José Andrés Moori Zegarra — Scrum Master / Arquitecto Técnico

> "Desde la perspectiva de la arquitectura de software y backend, la adopción de un ciclo de vida adaptativo fue la única estrategia capaz de neutralizar las severas limitaciones de hardware del entorno destino. Si hubiéramos optado por un enfoque pesado orientado a riesgos puros como el modelo Espiral, el tiempo disponible se habría diluido en auditorías documentales redundantes. Gracias a las entregas funcionales de Scrum, pude desplegar e integrar incrementos de código funcionales directamente sobre la PC de 4GB de RAM de la tienda desde las fases tempranas del desarrollo. Esto facilitó la optimización de los índices SQL y las sentencias asíncronas de Node.js en caliente, garantizando que el tiempo de respuesta final en mostrador se mantuviera firmemente por debajo del umbral crítico de 1.5 segundos."

### Isabel Hurtado — Ingeniera de Software / Aseguramiento de Calidad (QA)

> "Desde el rol de Aseguramiento de Calidad (QA), el enfoque Shift Left implementado en SIGAL-LF fue determinante para garantizar la fiabilidad del sistema en un entorno de alta presión como el mostrador de 'La Fábrica'. La integración de SonarCloud en el pipeline de GitHub Actions permitió detectar vulnerabilidades de seguridad y código duplicado desde las primeras fases de desarrollo, evitando que errores críticos llegaran a la PC de caja. Las pruebas de aceptación en el hardware real (4GB RAM) confirmaron que el sistema respeta los umbrales de rendimiento establecidos (< 1.5 segundos), y el registro de mermas con motivos justificados protege al personal de descuentos injustificados en sueldo. Este proyecto me enseñó que la calidad no es una fase final, sino una disciplina que debe estar presente desde el primer día."

---

*Proyecto SIGAL-LF · UPLA · MDS 2026-1*
