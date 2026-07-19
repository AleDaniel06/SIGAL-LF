# 04 · Plan de Calidad — ISO/IEC 25010 + SQA Shift Left

**Proyecto:** Sistema Integrado de Gestión de Almacén e Inventario en Tienda "La Fábrica" - Sucursal Huancayo (SIGAL-LF)  
**Versión:** 1.0 · Julio 2026  

---

## 1. Perfil de Calidad ISO/IEC 25010

Las 8 características de calidad del estándar se evalúan y priorizan según el contexto operativo y las restricciones críticas de la sucursal de "La Fábrica" - Huancayo.

### 1.1 Características Críticas (nivel 5/5)

Estas tres características son **no negociables**. Si el sistema falla en alguna de ellas, el problema de "La Fábrica" no queda resuelto.

#### ★ Eficiencia de Desempeño — 5/5

**¿Por qué es crítica?**  
La PC de caja tiene solo 4GB de RAM y la tienda atiende un flujo masivo de clientes en horas punta. El sistema debe ser extremadamente ligero y rápido. Si el sistema se congela o tarda en responder, la atención al cliente se paraliza en el único punto de venta y se generan pérdidas económicas inmediatas.

| Métrica | Valor objetivo | Herramienta de verificación |
| :--- | :--- | :--- |
| Tiempo de respuesta de consulta de stock | ≤ 1.5 segundos | Network Panel del navegador |
| Consumo de memoria RAM de la PC | ≤ 65% (2.6GB de 4GB) | Administrador de tareas de Windows |
| Tiempo de renderizado de la interfaz | ≤ 500 ms | Lighthouse / Performance Panel |
| Consultas simultáneas sin degradación | 1 usuario (1 caja) | Prueba manual + monitoreo |

**Estrategia:** El frontend usa Vanilla JS (sin frameworks pesados como React o Angular). Las consultas SQL están optimizadas con índices. Las tablas de inventario se cargan de forma diferida en bloques de 10 ítems por página.

#### ★ Fiabilidad (Confiabilidad) — 5/5

**¿Por qué es crítica?**  
Los descuadres de inventario en "La Fábrica" generan pérdidas económicas que el personal debe pagar de su propio bolsillo. El sistema debe garantizar la integridad referencial y que **nunca** se pierda información de los movimientos de stock ante fallas de red o cortes eléctricos.

| Métrica | Valor objetivo | Herramienta de verificación |
| :--- | :--- | :--- |
| Registros de stock corruptos o perdidos | 0% | Revisión de logs y base de datos |
| Rollback automático ante fallo de transacción | Siempre | Prueba de corte de energía manual |
| Tiempo de recuperación ante caída del servidor | ≤ 3 minutos | Prueba de caída de internet |
| Pérdida de datos por falla de red | 0 | Revisión de cola de sincronización |

**Estrategia:** La fiabilidad se logra por diseño mediante transacciones ACID en PostgreSQL (Supabase) y por contingencia (cola de sincronización asíncrona local mediante `LocalStorage`). Cada movimiento de stock se registra en la tabla `movimientos` con auditoría completa.

#### ★ Usabilidad — 5/5

**¿Por qué es crítica?**  
La cajera opera bajo alta presión en horas punta. El sistema debe ser intuitivo y no requerir capacitación extensa. Además, está prohibido el uso de celulares en el piso de venta, por lo que los vendedores dependen de la información que la cajera les proporcione de forma verbal desde el mostrador.

| Métrica | Valor objetivo | Herramienta de verificación |
| :--- | :--- | :--- |
| Tasa de error humano en digitación | ≤ 2% | Pruebas de usuario en entorno real |
| Consulta de stock completada en | ≤ 3 clics | Prueba de usabilidad |
| Tiempo de aprendizaje del sistema | ≤ 15 minutos | Prueba con nuevos usuarios |
| Fatiga visual reducida | Interfaces limpias | Evaluación subjetiva del personal |

**Estrategia:** La interfaz usa selectores fijos (`dropdowns`) para talla, color y ubicación, evitando la escritura libre de texto. Los botones son grandes y de alto contraste. La tabla de resultados muestra la información más relevante primero (stock disponible por ubicación).

#### ★ Seguridad — 5/5

**¿Por qué es crítica?**  
El sistema maneja información de precios comerciales, códigos de barras y registros de inventario. Una vulnerabilidad puede permitir la manipulación de stock o el acceso no autorizado a información analítica sensible de mermas y pérdidas.

| Métrica | Valor objetivo | Herramienta de verificación |
| :--- | :--- | :--- |
| Vulnerabilidades críticas OWASP Top 10 | 0 | SonarCloud (automático en cada push) |
| Comunicación frontend-backend cifrada | HTTPS obligatorio | Revisión de configuración de Render |
| Acceso sin autenticación | Imposible | Pruebas de penetración manuales |
| Contraseñas en texto plano | 0 | Revisión de código + SonarCloud |

**Estrategia:** SonarCloud se integra en el pipeline de GitHub Actions. Cada Pull Request es bloqueado automáticamente si introduce una vulnerabilidad crítica o debilidad de seguridad. Las contraseñas se encriptan con `bcrypt`.

---

### 1.2 Características Importantes (nivel 4/5)

| Característica | Nivel | Métrica principal | Justificación |
| :--- | :---: | :--- | :--- |
| **Adecuación Funcional** | 4/5 | ≥ 95% de los RF verificados con casos de prueba | El sistema debe cubrir todas las necesidades críticas de inventario por talla y color. |
| **Mantenibilidad** | 4/5 | Cobertura de código ≥ 70% (Jest) | El equipo de 2 personas debe poder mantener y evolucionar el sistema fácilmente. |
| **Compatibilidad** | 4/5 | Funciona en navegadores modernos (Chrome, Firefox) | La PC de caja usa Windows con un navegador web estándar como cliente. |

---

### 1.3 Características Complementarias (nivel 3/5)

| Característica | Nivel | Justificación |
| :--- | :---: | :--- |
| **Portabilidad** | 3/5 | Se despliega en la nube (Render), no requiere instalación local compleja. El equipo tiene control del entorno web. |
| **Interoperabilidad** | 3/5 | Se integra con el sistema de ventas preexistente mediante servicios API REST, garantizando un acoplamiento ligero de datos. |

---

## 2. Distribución de Esfuerzo de Calidad

Aplicando la **Regla 1-10-100** (Pressman, 2020):  
Detectar un defecto en requisitos cuesta 1 unidad. En desarrollo cuesta 10. En producción cuesta 100.

```text
PREVENCIÓN (40%)                  DETECCIÓN (45%)                  CORRECCIÓN (15%)
┌──────────────────────────────┐  ┌──────────────────────────────┐  ┌──────────────────────────────┐
│ SQA1: Revisión ERS           │  │ SQA3: Análisis Estático      │  │ Corrección de bugs           │
│ SQA2: Walkthrough DER y Arq. │  │ SQA4: Code Review en PRs     │  │ Refactoring de código        │
│ Definición de DoD            │  │ SQA5: Pruebas de Aceptación  │  │                              │
│ Estándares de Codificación   │  │ SQA6: Pruebas de Rendimiento │  │                              │
└──────────────────────────────┘  └──────────────────────────────┘  └──────────────────────────────┘
```
**Justificación:** La mayor inversión está en prevención y detección temprana porque el costo de corregir en producción (con descuadres reales que afectan directamente el sueldo del personal de mostrador) es inaceptable. Además, el plazo acotado de 13 semanas académicas no tolera correcciones tardías de arquitectura.

---

## 3. Plan SQA — Actividades Shift Left

"Shift Left" significa mover las actividades de calidad hacia el inicio del proceso de software, antes de que los defectos se encarezcan en el entorno real de la tienda.

| ID | Actividad | Fase | ¿Shift Left? | Responsable | Herramienta |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **SQA1** | Revisión ERS con checklist IEEE 830 | Análisis (Sprint 0) | Sí | Alexandra Cuchula | Checklist en doc `02-ERS.md` |
| **SQA2** | Walkthrough de arquitectura y modelo de datos (DER) | Diseño (Sprint 0-1) | Sí | José Moori + Alexandra | Revisión presencial + diagramas |
| **SQA3** | Análisis estático en cada Pull Request | Construcción (Sprint 1-6) | Sí | Todos (automático) | SonarCloud + GitHub Actions |
| **SQA4** | Code Review obligatorio en cada PR (mínimo 1 revisor) | Construcción (Sprint 1-6) | Sí | Todos (rotativo) | GitHub Pull Requests |
| **SQA5** | Pruebas de aceptación en entorno real (PC de caja) | Despliegue (Sprint 6) | ⚠ PARCIAL | Ambos integrantes | Casos de prueba (doc 05) + PC física |
| **SQA6** | Pruebas de rendimiento (consultas < 1.5s, consumo RAM) | Despliegue (Sprint 6) | ⚠ PARCIAL | José Moori | Network Panel + Task Manager |

> ── **Nota sobre SQA5 y SQA6:** Son parcialmente Shift Left porque dependen de software funcional, pero se planifican desde el inicio (los casos de prueba están escritos antes del desarrollo en el documento `05-casos-de-prueba.md`).

---

## 4. Definition of Done (DoD)

Cada historia de usuario se considera **Terminada** (Done) únicamente cuando cumple con **todos** los criterios siguientes:

* [ ] Código revisado mediante Pull Request (mínimo 1 revisor aprobó).
* [ ] SonarCloud no reporta issues nuevos de severidad *Critical* o *Blocker*.
* [ ] Pruebas unitarias escritas con cobertura $\ge 70\%$ del módulo (Jest).
* [ ] Criterios de aceptación de la historia verificados manualmente en entorno local.
* [ ] Documentación actualizada en Swagger/OpenAPI si la historia modifica o añade endpoints.
* [ ] Issue cerrada en GitHub Projects y movida a la columna de "Terminado".
* [ ] Verificación de rendimiento en la PC de caja (consultas express $< 1.5$ segundos).

**Sin DoD, "terminado" no tiene significado concreto.** Este checklist es el contrato de calidad del equipo SIGAL-LF.

---

## 5. Flujo de Calidad en GitHub Actions

Cada vez que un integrante hace push a una rama de desarrollo o abre un Pull Request, se ejecuta automáticamente el pipeline de integración continua:

```text
Push / Pull Request
        ↓
[GitHub Actions Pipeline]
  ├── 1. npm install (Instalación limpia de dependencias)
  ├── 2. npm test (Ejecución de Jest → cobertura obligatoria ≥ 70%)
  ├── 3. SonarCloud Scan (Análisis estático OWASP Top 10)
  └── 4. npm audit (Verificación de vulnerabilidades en dependencias)
        ↓
   ¿Pasó todo?
     ├── SÍ → El PR puede ser aprobado y mergeado a main
     └── NO → El PR queda bloqueado automáticamente hasta corregir
```
Este flujo implementa SQA3 de forma automática sin intervención manual en cada integración.

## 6. Métricas de Calidad Adicionales (Específicas para SIGAL-LF)

| Métrica | Valor objetivo | Frecuencia de medición | Responsable |
| :--- | :--- | :--- | :--- |
| Tiempo de respuesta de consulta express | < 1.5 segundos | Cada Sprint | José Moori |
| Consumo de RAM en PC de caja antigua | < 2.6 GB (65% del total) | Cada Sprint | José Moori |
| Tasa de descuadres de inventario en tienda | 0% | Al final de cada Sprint | Alexandra Cuchula |
| Cobertura de código (Unit Testing) | $\ge 70\%$ | En cada PR | SonarCloud (automático) |
| Vulnerabilidades críticas OWASP detectadas | 0 | En cada PR | SonarCloud (automático) |
| Tiempo de aprendizaje del sistema | < 15 minutos | Única (Sprint 6) | Prueba con cajera y apoyo |

---
*Plan de Calidad v1.0 — Proyecto SIGAL-LF · UPLA · MDS 2026-1*
