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

---

## ✅ Plan de Calidad

**ISO/IEC 25010:** El sistema se evalúa bajo las siguientes características críticas:

| Característica | Nivel | Métrica |
|----------------|-------|---------|
| **Eficiencia de Desempeño** | 5/5 ★ | Tiempo de respuesta ≤ 1.5 segundos · Consumo RAM ≤ 65% (2.6GB) |
| **Fiabilidad** | 5/5 ★ | 0% de registros corruptos · Rollback automático ACID |
| **Usabilidad** | 5/5 ★ | Tasa de error humano < 2% · Selectores fijos (dropdowns) |
| **Seguridad** | 5/5 ★ | 0 vulnerabilidades críticas OWASP Top 10 |

**Estrategia SQA (Shift Left):**
- SQA1: Auditoría de requisitos (Sprint 0)
- SQA2: Walkthrough de arquitectura y DER
- SQA3: Análisis estático de código (SonarCloud)
- SQA4: Code Review obligatorio en cada PR
- SQA5: Pruebas de aceptación en PC real
- SQA6: Pruebas de carga y rendimiento (JMeter)

---

## 📊 Seguimiento del Proyecto

El avance se gestiona mediante **GitHub Projects** con tablero Kanban.  
Cada tarea está asignada a un integrante y vinculada a su incremento.

- **Issues activas** → [Tablero del proyecto](https://github.com/...)
- **Milestones** → Cierre Incremento 1 · Cierre Incremento 2 · Cierre Incremento 3
- **Etiquetas** → `incremento-1` `incremento-2` `incremento-3` `sqa` `análisis` `diseño` `backend` `frontend`

---


*README.md — Proyecto SIGAL-LF · UPLA · MDS 2026-1*
