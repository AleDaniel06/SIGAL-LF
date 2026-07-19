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

PREVENCIÓN (40%)                  DETECCIÓN (45%)                  CORRECCIÓN (15%)
┌──────────────────────────────┐  ┌──────────────────────────────┐  ┌──────────────────────────────┐
│ SQA1: Revisión ERS           │  │ SQA3: Análisis Estático      │  │ Corrección de bugs           │
│ SQA2: Walkthrough DER y Arq. │  │ SQA4: Code Review en PRs     │  │ Refactoring de código        │
│ Definición de DoD            │  │ SQA5: Pruebas de Aceptación  │  │                              │
│ Estándares de Codificación   │  │ SQA6: Pruebas de Rendimiento │  │                              │
└──────────────────────────────┘  └──────────────────────────────┘  └──────────────────────────────┘
