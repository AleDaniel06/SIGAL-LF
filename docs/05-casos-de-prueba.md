# 05 · Casos de Prueba — SQA5 y SQA6

**Proyecto:** Sistema Integrado de Gestión de Almacén e Inventario en Tienda "La Fábrica" - Sucursal Huancayo (SIGAL-LF)
**Versión:** 1.0 · Julio 2026                     
**Responsable:** Isabel Hurtado (QA)

---

## 1. Casos de Prueba de Aceptación (SQA5)

Estos casos son ejecutados por la ingeniera de calidad Isabel Hurtado junto con Alexandra Cuchula (Product Owner Proxy). Verifican que el sistema cumple los requisitos funcionales desde la perspectiva del usuario real de la sucursal de Huancayo en la Calle Real.

### CP-01 · Registro de recepción de fardo de Marvisur

| Campo | Detalle |
|-------|---------|
| **ID** | CP-01 |
| **Historia de usuario** | HU-01 (Registro de recepción de fardos) |
| **Requisito** | RF-02 (Recepción y Calidad Logística) |
| **Módulo** | MOD-02[cite: 3] |
| **Precondición** | Usuario "apoyo" autenticado en el sistema |

**Pasos:**

1. Iniciar sesión en SIGAL-LF con credenciales de "Apoyo de Caja"[cite: 3].
2. Ir al módulo de "Recepción de Carga".
3. Escanear el código de barras de la prenda: `8801234567890`.
4. El sistema debe mostrar el nombre de la prenda automáticamente (o permitir digitarlo si no existe).
5. Seleccionar talla: **"M"** (Medium).
6. Seleccionar color: **"Rojo"**.
7. Seleccionar ubicación: **"Almacén General"**.
8. Ingresar cantidad: **100 unidades**.
9. Seleccionar estado de calidad: **"Conforme"**.
10. Ingresar número de guía de remisión de Marvisur: **"MRV-2026-07-001"**.
11. Hacer clic en **"Guardar Fardo"**.

**Resultado esperado:**
* ✅ El sistema confirma: "Fardo registrado exitosamente".
* ✅ El stock de "Camisa Roja M" se incrementa en 100 unidades.
* ✅ El movimiento se registra en el historial como "entrada".
* ✅ El sistema muestra el nuevo stock en la consulta de inventario.

**Resultado real:** [completar al ejecutar]  
**¿Pasó?** ☐ SÍ / ☐ NO  
**Observaciones:** ________________________

---

### CP-02 · Consulta de stock por talla y color

| Campo | Detalle |
|-------|---------|
| **ID** | CP-02 |
| **Historia de usuario** | HU-02 (Consulta de stock matricial) |
| **Requisito** | RF-03 (Control Transaccional y Stock Matricial) |
| **Módulo** | MOD-03[cite: 3] |
| **Precondición** | CP-01 ejecutado exitosamente (stock de 100 unidades registrado) |

**Pasos:**

1. Iniciar sesión en SIGAL-LF con credenciales de "Cajera Principal"[cite: 3].
2. Ir al módulo de "Consulta de Stock".
3. Ingresar código de barras: `8801234567890`.
4. Presionar **"Buscar"**.
5. Verificar la tabla de resultados.

**Resultado esperado:**
* ✅ El sistema muestra la prenda "Camisa Roja" con precio S/. 45.00.
* ✅ La tabla muestra el desglose por tallas:
  * S: 0 unidades
  * M: 100 unidades
  * L: 0 unidades
  * XL: 0 unidades
* ✅ La ubicación "Almacén General" se muestra correctamente[cite: 3].
* ✅ El tiempo de respuesta es ≤ 1.5 segundos.

**Resultado real:** [completar al ejecutar]  
**¿Pasó?** ☐ SÍ / ☐ NO  
**Observaciones:** ________________________

---

### CP-03 · Venta y decremento automático de stock

| Campo | Detalle |
|-------|---------|
| **ID** | CP-03 |
| **Historia de usuario** | HU-03 (Integración con punto de venta) |
| **Requisito** | RF-06 (Sincronización con Sistema de Ventas) |
| **Módulo** | MOD-03 (Integración)[cite: 3] |
| **Precondición** | CP-01 ejecutado, stock de 100 unidades en "Camisa Roja M" |

**Pasos:**

1. Simular una venta en el sistema de ventas externo (POS).
2. El POS envía petición POST a la API: `/api/inventario/venta`.
3. Datos enviados:
   * Código: `8801234567890`
   * Talla: `M`
   * Color: `Rojo`
   * Cantidad: `1`
   * Ubicación: `Piso de Venta`[cite: 3]
4. Verificar la respuesta del servidor.
5. Consultar el stock actualizado en SIGAL-LF.

**Resultado esperado:**
* ✅ El servidor responde con código 200 OK.
* ✅ Mensaje: "Stock actualizado exitosamente".
* ✅ El stock de "Camisa Roja M" disminuye de 100 a 99 unidades.
* ✅ El movimiento se registra en el historial como "venta".
* ✅ La ubicación "Piso de Venta" muestra el decremento[cite: 3].
* ✅ El tiempo de respuesta es ≤ 1.5 segundos.

**Resultado real:** [completar al ejecutar]  
**¿Pasó?** ☐ SÍ / ☐ NO  
**Observaciones:** ________________________

---

### CP-04 · Registro de merma (prenda dañada)

| Campo | Detalle |
|-------|---------|
| **ID** | CP-04 |
| **Historia de usuario** | HU-04 (Registro de mermas y ajustes) |
| **Requisito** | RF-06 (Auditoría de Mermas y Reportes) |
| **Módulo** | MOD-05[cite: 3] |
| **Precondición** | Usuario "supervisor" autenticado, stock de 99 unidades en "Camisa Roja M" |

**Pasos:**

1. Iniciar sesión en SIGAL-LF con credenciales de "Encargado de Tienda (Supervisor)"[cite: 3].
2. Ir al módulo de "Registro de Mermas"[cite: 3].
3. Seleccionar la prenda: "Camisa Roja M".
4. Seleccionar motivo: **"Falla de Costura"**[cite: 3].
5. Ingresar cantidad: **2 unidades**.
6. Agregar descripción: "Rotura en la costura del hombro, no apta para venta"[cite: 3].
7. Hacer clic en **"Registrar Merma"**[cite: 3].

**Resultado esperado:**
* ✅ El sistema confirma: "Merma registrada exitosamente".
* ✅ El stock de "Camisa Roja M" disminuye de 99 a 97 unidades.
* ✅ El movimiento se registra en el historial como "merma".
* ✅ El motivo "Falla de Costura" queda registrado en el sistema[cite: 3].
* ✅ El histórico de mermas muestra el registro con fecha y usuario.

**Resultado real:** [completar al ejecutar]  
**¿Pasó?** ☐ SÍ / ☐ NO  
**Observaciones:** ________________________

---

### CP-05 · Congelar precio en contingencia (sin conexión)

| Campo | Detalle |
|-------|---------|
| **ID** | CP-05 |
| **Historia de usuario** | HU-05 (Congelamiento de precios de contingencia) |
| **Requisito** | RF-04 (Consulta Express para Punto de Caja) |
| **Módulo** | MOD-04[cite: 3] |
| **Precondición** | Cajera autenticada, sistema de ventas externo desconectado (caída de internet) |

**Pasos:**

1. Desconectar el cable de red de la PC de caja (simular caída de internet).
2. Abrir SIGAL-LF en el navegador.
3. Buscar la prenda: "Camisa Roja M".
4. Verificar que el sistema muestra el precio actual: S/. 45.00.
5. Hacer clic en **"Congelar Precio"**[cite: 3].
6. Ingresar el precio manualmente: **S/. 50.00** (por ajuste de contingencia).
7. Confirmar el cambio.
8. Verificar que el sistema utiliza el precio congelado.

**Resultado esperado:**
* ✅ El sistema permite acceder a la consulta sin conexión.
* ✅ El precio se actualiza localmente a S/. 50.00.
* ✅ La aplicación NO muestra error ni se congela.
* ✅ El indicador de estado muestra "Sin conexión - Modo Contingencia".
* ✅ El precio congelado se mantiene hasta que se restablezca la conexión.

**Resultado real:** [completar al ejecutar]  
**¿Pasó?** ☐ SÍ / ☐ NO  
**Observaciones:** ________________________

---

### CP-06 · Generación de reporte de rotación de inventario

| Campo | Detalle |
|-------|---------|
| **ID** | CP-06 |
| **Historia de usuario** | HU-06 (Dashboard de reportes) |
| **Requisito** | RF-07 (Generación de Reportes en PDF/Excel) |
| **Módulo** | MOD-05[cite: 3] |
| **Precondición** | Supervisor autenticado, al menos 30 días de datos de movimientos |

**Pasos:**

1. Iniciar sesión en SIGAL-LF con credenciales de "Encargado de Tienda"[cite: 3].
2. Ir al módulo de "Dashboard de Reportes"[cite: 3].
3. Seleccionar el reporte de "Rotación de Inventario"[cite: 3].
4. Configurar filtros:
   * Fecha inicio: 01/06/2026
   * Fecha fin: 30/06/2026
   * Categoría: Todas
   * Talla: Todas
5. Hacer clic en **"Generar Reporte"**.
6. Verificar la información mostrada en el dashboard.
7. Hacer clic en **"Exportar a PDF"**.
8. Hacer clic en **"Exportar a Excel"**.

**Resultado esperado:**
* ✅ El dashboard muestra la tasa de rotación por talla y color[cite: 3].
* ✅ Identifica el stock estancado (prendas sin movimiento en 30 días)[cite: 3].
* ✅ Muestra la consistencia de saldos entre almacén y ventas[cite: 3].
* ✅ El PDF se genera y descarga correctamente[cite: 3].
* ✅ El Excel se genera y descarga correctamente[cite: 3].
* ✅ Los datos en el PDF/Excel coinciden con el dashboard[cite: 3].

**Resultado real:** [completar al ejecutar]  
**¿Pasó?** ☐ SÍ / ☐ NO  
**Observaciones:** ________________________

---

### CP-07 · Intento de acceso sin autenticación

| Campo | Detalle |
|-------|---------|
| **ID** | CP-07 |
| **Historia de usuario** | — |
| **Requisito** | RNF-04 (Seguridad) |
| **Módulo** | MOD-01[cite: 3] |
| **Precondición** | App instalada, sin sesión iniciada |

**Pasos:**

1. Abrir SIGAL-LF en el navegador.
2. Intentar acceder a la pantalla de "Consulta de Stock" sin ingresar credenciales.
3. Intentar acceder directamente a la URL del dashboard sin autenticación.
4. Intentar acceder a la URL del registro de mermas sin autenticación.

**Resultado esperado:**
* ✅ El sistema redirige automáticamente a la página de login.
* ✅ El sistema no permite acceso sin credenciales válidas.
* ✅ El dashboard redirige al login si no hay sesión activa.
* ✅ No se muestra ningún dato sensible antes de autenticarse.
* ✅ Todas las rutas protegidas están bloqueadas.

**Resultado real:** [completar al ejecutar]  
**¿Pasó?** ☐ SÍ / ☐ NO  
**Observaciones:** ________________________

---

## 2. Plan de Pruebas de Rendimiento (SQA6)

### Objetivo

Verificar que el sistema SIGAL-LF soporta las condiciones de operación reales en la tienda "La Fábrica" - Sucursal Huancayo, asegurando que el tiempo de respuesta no supere los 1.5 segundos y que el consumo de memoria RAM en la PC de caja (4GB) no exceda el 65% (2.6GB), tal como especifican los requerimientos de la arquitectura ligera en Vanilla JS[cite: 3].

> **Nota Crítica de Entorno:** La tienda opera con **UNA SOLA CAJA** en mostrador[cite: 3]. Las pruebas de carga omiten la concurrencia masiva de múltiples terminales físicas y se concentran estrictamente en la saturación por peticiones consecutivas, consultas masivas veloces y la estabilidad de la memoria local en el hardware antiguo de 4GB RAM[cite: 3].

### Herramienta

**Apache JMeter** — versión 5.6.x (gratuita, open source)

### Configuración del test

**Thread Group:**
* Número de hilos (usuarios simulados): **1** (representa la única caja física de la tienda)
* Ramp-up period: **1 segundo** (inicio inmediato del punto terminal)
* Loop count: **50** (consultas de transacciones secuenciales aceleradas)
* Total transacciones: **50 consultas secuenciales**

**Escenario especial - Simulación de hora punta:**
* Se ejecutan **20 consultas en rápida sucesión** con un intervalo de 1 segundo entre cada petición desde la misma instancia del navegador, emulando la atención crítica a clientes en hora punta (mediodía en la Calle Real)[cite: 3].

**Endpoints a probar:**
* `GET /api/inventario/:codigo` → Consulta express de stock matricial
* `POST /api/inventario/venta` → Decremento síncrono por venta en mostrador
* `GET /api/reportes/rotacion` → Generación de analíticas agregadas de inventario

**Navegación:**
* Pruebas de renderizado locales mediante **Lighthouse** en Google Chrome para asegurar la ligereza de la UI nativa.

---

### Métricas a medir

| Métrica | Umbral aceptable | Herramienta de medición |
| :--- | :--- | :--- |
| Tiempo de respuesta de consulta de stock | ≤ 1.5 segundos | Network Panel / JMeter |
| Tiempo de respuesta de decremento por venta | ≤ 1.5 segundos | Network Panel / JMeter |
| Tiempo de respuesta de reporte de rotación | ≤ 3.0 segundos | Network Panel / JMeter |
| Consumo de memoria RAM en PC de caja | **≤ 65% (2.6 GB de 4 GB)** | Administrador de tareas de Windows |
| Consumo de CPU en PC de caja | ≤ 60% | Administrador de tareas de Windows |
| Tiempo de renderizado de la interfaz | ≤ 500 ms | Lighthouse / Performance Panel |
| Tasa de errores en transacciones | 0% | JMeter / Logs del sistema |

---

### Escenarios de prueba

* **Escenario 1 — Consulta normal (caja operando):** 1 usuario (cajera) realizando 1 consulta de stock cada 5 segundos (ritmo de flujo estándar en el negocio).
* **Escenario 2 — Hora punta (flujo masivo):** 1 usuario (cajera) realizando 20 consultas en rápida sucesión (1 por segundo), simulando la atención manual de una cola de clientes al mediodía en la tienda.
* **Escenario 3 — Operación mixta:** 1 usuario ejecutando una combinación secuencial en la terminal de 10 consultas de stock, 5 registros de venta y 1 petición de reporte de rotación.
* **Escenario 4 — Simulación de clientes simultáneos en mostrador:** Simulación en JMeter de 5 peticiones concurrentes asíncronas desde el navegador de la misma terminal, representando la consulta rápida de múltiples variantes de prendas solicitadas en un lapso de 10 segundos por el personal de apoyo.
* **Escenario 5 — Stress-test de memoria RAM:** Ejecución de 100 consultas continuas y 20 mutaciones de stock durante 30 minutos ininterrumpidos para validar que el garbage collection de Vanilla JS mantiene el consumo de memoria por debajo de los 2.6 GB.

---

### Reporte esperado

JMeter genera un reporte HTML agregando los gráficos de rendimiento transaccional. El repositorio guardará las evidencias físicas adicionales:

* Captura de pantalla del Administrador de Tareas de Windows verificando el uso estable de la memoria RAM de 4GB.
* Reporte de Lighthouse con puntaje de rendimiento ≥ 90.

El reporte consolidado se guardará en la ruta `/incremento-6/resultados-pruebas/` del repositorio Git institucional[cite: 3].

---

## 3. Resumen de Cobertura

| Requisito | Módulo | CP que lo verifica | Estado |
| :--- | :--- | :--- | :--- |
| RF-02 (Recepción y Calidad Logística) | MOD-02[cite: 3] | CP-01 | 🟢 Pendiente |
| RF-03 (Control Transaccional y Stock Matricial) | MOD-03[cite: 3] | CP-02 | 🟢 Pendiente |
| RF-06 (Sincronización con Sistema de Ventas) | MOD-03[cite: 3] | CP-03 | 🟢 Pendiente |
| RF-06 (Auditoría de Mermas y Reportes) | MOD-05[cite: 3] | CP-04 | 🟢 Pendiente |
| RF-04 (Consulta Express para Punto de Caja) | MOD-04[cite: 3] | CP-05 | 🟢 Pendiente |
| RF-07 (Generación de Reportes en PDF/Excel) | MOD-05[cite: 3] | CP-06 | 🟢 Pendiente |
| RNF-04 (Seguridad) | MOD-01[cite: 3] | CP-07 | 🟢 Pendiente |
| RNF-01 (Rendimiento - Tiempo de respuesta ≤ 1.5s) | Todos | SQA6 - JMeter | 🟢 Pendiente |
| RNF-02 (Usabilidad - PC de 4GB RAM, sin saturación) | Todos | SQA6 - Monitorización | 🟢 Pendiente |

---
*Casos de Prueba v1.0 — Proyecto SIGAL-LF · UPLA · MDS 2026-1*[cite: 3]
