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

## 👥 Equipo de Desarrollo y Roles
La célula de desarrollo opera bajo una estructura autoorganizada y de responsabilidad compartida:

| Integrante | Rol en el Proyecto | Responsabilidades Clave |
| :--- | :--- | :--- |
| **Alexandra Milagros Cuchula Daniel** | Product Owner Proxy / Analista de Negocio | Gestión del Product Backlog, levantamiento de reglas de negocio en retail y validación de consistencia del stock. |
| **José Andrés Moori Zegarra** | Scrum Master / Arquitecto Técnico | Disciplina metodológica, remoción de bloqueos técnicos, arquitectura backend y control de integración en GitHub. |
| **Isabel Hurtado** | Ingeniera de Software / Aseguramiento de Calidad (QA) | Diseño del plan de pruebas, automatización de pruebas unitarias y SQA general. |

---

## 🎯 Contexto del Problema
La sucursal estratégica de **"La Fábrica"** en Huancayo (Calle Real, Junín) opera en el rubro de retail textil masivo. Actualmente, el flujo logístico sufre ineficiencias críticas por procesos manuales basados en hojas de cálculo aisladas:

* **Latencia Crítica en Recepción:** Los fardos de mercadería llegan por Marvisur y se cuentan manualmente. Su transcripción a Excel y envío por correo a la central genera un desfase donde el stock virtual figura en "cero", bloqueando la venta lógica de prendas físicamente disponibles.
* **Cruce de Códigos en Mostrador:** Ante la falta de stock virtual actualizado, el personal de caja escanea códigos de prendas ajenas con el mismo precio para no perder la venta, alterando sistemáticamente la fidelidad del inventario.
* **Búsqueda Ciega de Prendas:** El sistema genérico omite el desglose por Talla, Color y Ubicación Física, forzando a los asesores a buscar a ciegas en los almacenes del segundo piso.
* **Penalizaciones Económicas:** Los descuadres finales acumulados son cobrados directamente del sueldo del personal operativo debido a las políticas punitivas vigentes.

### 🚫 Restricciones Críticas del Entorno
* 📱 **Prohibido el uso de celulares** en el piso de venta (uso obligado de terminal de caja web única).
* 🖥️ **PC de caja antigua con 4GB RAM** (Línea base restrictiva para el rendimiento del software).
* 💰 **Presupuesto FINANCIERO CERO ($0.00)** (Uso mandatorio de herramientas de capa gratuita).
* ⏳ **Plazo académico de 13 semanas** improrrogables.

---

## 💡 Solución Propuesta
**SIGAL-LF** es una aplicación web centralizada con actualización transaccional en tiempo real que elimina la latencia de procesamiento.

### Características Clave
* **Actualización en Tiempo Real:** Sincronización inmediata entre la recepción de fardos y el punto de caja.
* **Stock Matricial Multidimensional:** Indexación relacional estricta: `Código Base` $\rightarrow$ `Talla` $\rightarrow$ `Color` $\rightarrow$ `Ubicación`.
* **Consulta Express Eficiente:** Interfaz minimalista optimizada para renderizar consultas en la PC antigua en menos de 1.5 segundos.
* **Auditoría de Mermas:** Registro justificado de prendas dañadas o pérdidas validadas para evitar cargos injustificados al sueldo del personal.

---

## 🛠️ Stack Tecnológico
Para garantizar la viabilidad técnica bajo la restricción de presupuesto cero ($0.00$), se estructuró la siguiente arquitectura basada en software libre y capas gratuitas (*Free Tier*):

| Capa | Tecnología | Justificación Contextual | Costo |
| :--- | :--- | :--- | :--- |
| **Frontend** | HTML5 + CSS3 + Vanilla JS | Sin frameworks pesados. Renderizado nativo ultraligero para optimizar el consumo en la PC de 4GB RAM. | $0.00 |
| **Backend** | Node.js + Express.js | Entorno asíncrono y ligero. Modelo de E/S sin bloqueo capaz de procesar múltiples decrementos concurrentes. | $0.00 |
| **Base de Datos** | PostgreSQL (Supabase) | Motor relacional robusto. Soporte nativo para transacciones ACID que garantiza la consistencia del stock matricial. | $0.00 |
| **ORM** | Prisma ORM | Consultas tipadas que mitigan errores de sintaxis y previenen vulnerabilidades de inyección SQL. | $0.00 |
| **Alojamiento Cloud** | Render Cloud | Despliegue automatizado continuo acoplado mediante webhooks al repositorio de GitHub. | $0.00 |
| **Control Versiones** | GitHub | Eje central de la integración del código, gestión de Pull Requests y GitHub Projects. | $0.00 |
| **Análisis Estático** | SonarCloud | Escaneo automatizado de vulnerabilidades y deudas técnicas del código fuente (Shift Left). | $0.00 |
| **Pruebas Unitarias** | Jest | Framework de pruebas para asegurar la estabilidad del motor logístico y de sincronización. | $0.00 |
| **Pruebas de Carga** | Apache JMeter | Simulación de alta concurrencia y flujos masivos en el mostrador de caja durante horas punta. | $0.00 |

**COSTO TOTAL DE INFRAESTRUCTURA: $0.00 USD**

---

## 📐 Metodología y Modelo de Proceso

El proyecto adopta el marco de trabajo **Scrum** adaptado con **Integración Continua de Datos**.

### 📊 Evaluación de Alternativas Metodológicas

| Criterio de Evaluación | Modelo en Cascada (Tradicional) | Modelo Espiral (Basado en Riesgos) | Marco de Trabajo Scrum (Ágiles) |
| :--- | :--- | :--- | :--- |
| **a. Claridad de requisitos** | **Baja.** Asume requisitos estáticos; fracasaría ante variaciones de precios y traslados imprevistos de Marvisur. | **Alta.** Permite evolución progresiva, pero la sobrecarga analítica inicial dilata el inicio de la programación. | **Alta.** Diseñado para entornos volátiles. Permite refinar y priorizar las reglas logísticas en cada ciclo. |
| **b. Riesgo técnico** | **Baja.** La integración final tardía provocaría que la lentitud en la PC de caja antigua se detecte irreversiblemente tarde. | **Muy Alta.** Enfoque matemático sólido ante riesgos que excede las necesidades de esta escala comercial local. | **Alta.** Los riesgos de rendimiento se mitigan mediante pruebas de incrementos reales en la PC de caja en cada Sprint. |
| **c. Madurez del equipo** | **Media/Baja.** Documentación técnica masiva previa que saturaría la capacidad operativa de la célula compacta. | **Baja.** Exige comités corporativos y herramientas estadísticas avanzadas inviables para pregrado. | **Alta.** Promueve autoorganización en equipos reducidos, optimizando las capacidades directas de los desarrolladores. |
| **d. Documentación** | **Muy Alta.** Produce manuales rígidos. La administración de la tienda prefiere resultados operativos rápidos. | **Alta.** Documentación robusta de mitigación de fallos y actas de control cíclico estructuradas. | **Modificada.** Prioriza el código funcional sobre la documentación masiva, adaptándose para generar actas logísticas de stock. |
| **e. Velocidad de entrega** | **Muy Baja.** Principio de "todo o nada". La tienda continuaría perdiendo dinero durante meses antes de ver software útil. | **Media.** Entregas progresivas mediante prototipos analíticos que ralentizan la atención a dolores urgentes. | **Muy Alta.** Garantiza un módulo operativo y testeado (ej. consulta rápida de stock) al término de cada ciclo de 2 semanas. |

### 💡 Justificación de la Elección
1. **Naturaleza Empírica frente al Retail:** Permite responder quincenalmente ante fluctuaciones de precios o ingresos imprevistos de mercancía a través de la inspección y adaptación.
2. **Mitigación de Hardware en Fases Tempranas:** Obliga al equipo a desplegar un incremento utilizable al final de cada Sprint, posibilitando pruebas de rendimiento en caliente sobre la PC física de la tienda.
3. **Eficiencia de Procesos:** Elimina la sobreingeniería y burocracia de comités complejos, optimizando las horas hombre del equipo de 3 integrantes.

---

## 📈 Incrementos del Proyecto (Planificación Temporal)

El desarrollo del MVP se divide estrictamente en bloques de tiempo regulares e invariables (*Timeboxing*) a lo largo de **13 semanas**:

| Incremento | Sprints | Semanas | Contenido Funcional | Módulos Relacionados |
| :--- | :--- | :--- | :--- | :--- |
| **Incremento 1** | Sprint 0 + 1 | Semanas 1-3 | **Seguridad y Captura de Carga:** Configuración de arquitectura, autenticación con control de accesos basado en roles (RBAC) e interfaz de recepción de fardos de Marvisur. | `MOD-01` (Autenticación)<br>`MOD-02` (Recepción) |
| **Incremento 2** | Sprint 2 + 3 | Semanas 4-7 | **Stock Matricial e Interoperabilidad:** Motor relacional con almacenamiento dimensional (talla, color, ubicación) y API REST de descuento automático por ventas en mostrador. | `MOD-03` (Control Transaccional) |
| **Incremento 3** | Sprint 4 + 5 + 6 | Semanas 8-13 | **Auditoría, Analítica y Despliegue:** Panel de registro de mermas, dashboard de rotación textil, exportaciones (PDF/Excel), pruebas de aceptación en PC real y lanzamiento web en Render Cloud. | `MOD-04` (Consulta Express)<br>`MOD-05` (Mermas)<br>`Release 1.0` |

---

## 🗂️ Estructura del Repositorio

El árbol jerárquico del repositorio organiza el código y la documentación técnica de manera limpia y modular:

```text
sigal-lf/
├── .gitignore                         # Exclusiones de archivos en Git
├── README.md                          # Este archivo (Carta de presentación principal)
│
├── assets/
│   └── diagramas/                     # Prototipos de pantallas y diagramas UI
│       ├── Pantalla-1-POS.md          # Diagrama de Interfaz Consulta Express
│       ├── Pantalla-2-cierre-de-caja.md # Diagrama de Cierre de Caja
│       └── Pantalla-3-dashboard.md    # Diagrama de Dashboard Analítico
│
├── docs/                              # Documentación del ciclo de vida de ingeniería
│   ├── 01-diagnostico.md              # Diagnóstico detallado socio-técnico de la tienda
│   ├── 02-ERS.md                      # Especificación de Requisitos de Software
│   ├── 03-arquitectura.md             # Diseño de arquitectura técnica y DER relacional
│   ├── 04-plan-calidad.md             # Estrategia de Calidad ISO 25010 y SQA
│   └── 05-casos-de-prueba.md          # Especificación de Casos de Prueba (SQA5 y SQA6)
│
├── incremento-1/                      # Entregables funcionales del Bloque 1
│   └── README.md                      # Artefactos de Seguridad y Recepción
│
├── incremento-2/                      # Entregables funcionales del Bloque 2
│   ├── .gitignore                     # Exclusiones locales de entorno
│   ├── README.md                      # Artefactos del Motor Matricial y API
│   └── README1.md                     # Documentación adicional de integración
│
└── incremento-3/                      # Entregables funcionales del Bloque 3
    └── README.md                      # Módulos finales, Dashboards y Release 1.0
```
🎖️ Plan de Calidad y Estrategia SQA📊 Métricas de Calidad ISO/IEC 25010El sistema se somete a evaluaciones cuantitativas bajo las siguientes características críticas:Eficiencia de Desempeño (5/5 ★): Tiempo de respuesta transaccional $\le$ 1.5 segundos. Consumo controlado de memoria RAM en la terminal de caja $\le$ 65% (2.6GB).Fiabilidad (5/5 ★): Consistencia del 100% en base de datos. Rollback automático ante pérdidas bruscas de energía para un 0% de registros corruptos.Usabilidad (5/5 ★): Reducción de fatiga visual e interfaces ergonómicas. Bloqueo de escritura libre en variables lógicas mediante dropdowns (Tasa de error humano $<$ 2%).Seguridad (5/5 ★): Encriptación de contraseñas y control de accesos sin vulnerabilidades críticas en el escaneo OWASP Top 10.🛡️ Estrategia SQA (Shift Left)El aseguramiento de la calidad se ejecuta mediante pruebas tempranas para mitigar la propagación de bugs:SQA1: Auditoría estricta de requisitos y criterios de aceptación (Sprint 0).SQA2: Walkthrough técnico de arquitectura y del Diagrama Entidad-Relación.SQA3: Análisis estático automatizado de código integrado en la integración continua con SonarCloud.SQA4: Code Review e inspección de pares obligatoria en cada Pull Request antes de su mezcla a main.SQA5: Pruebas funcionales de aceptación ejecutadas in situ en la PC física de la sucursal.SQA6: Pruebas automatizadas de carga y rendimiento de la API mediante Apache JMeter.📉 La Regla 1-10-100 de Calidad: Corregir un tipo de dato en el diseño del script SQL cuesta 1. Modificar una consulta lenta en el desarrollo con Postman cuesta 10. Resolver un bug de inventario corrupto en producción que afecte financieramente el sueldo de los trabajadores de la tienda cuesta 100.🛠️ Seguimiento del ProyectoEl avance técnico y las actividades diarias se administran con transparencia a través de herramientas nativas de la plataforma:📊 Gestión de Tareas: Gestionado en GitHub Projects — Tablero Kanban del Proyecto📌 Milestones (Hitos): Cierre de Incremento 1 · Cierre de Incremento 2 · Cierre de Incremento 3🏷️ Etiquetas organizacionales: incremento-1 · incremento-2 · incremento-3 · sqa · análisis · diseño · backend · frontend🔗 Enlaces Rápidos a la Documentación📝 Documentos Técnicos de Ingeniería📋 Diagnóstico Organizacional📝 Especificación de Requisitos (ERS)🏗️ Arquitectura Técnica e Índices✅ Plan de Calidad e ISO 25010🧪 Casos de Prueba SQA🚀 Artefactos por Incremento🔒 Incremento 1 — Módulos de Seguridad y Recepción de Carga⚙️ Incremento 2 — Motor de Stock Matricial e Interoperabilidad API📊 Incremento 3 — Auditoría de Mermas, Dashboards Analíticos y Release
