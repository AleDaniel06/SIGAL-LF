# Diagrama de Secuencia — Recepción de Fardo de Marvisur

**Sistema:** SIGAL-LF  
**Flujo:** Apoyo de Caja registra la entrada de mercadería en el sistema

---

## Código Mermaid

```mermaid
sequenceDiagram
    participant Apoyo as Apoyo de Caja
    participant Frontend as Cliente Web (Caja)
    participant Backend as API Backend (Node.js + Express)
    participant BD as Base de Datos (PostgreSQL)

    Apoyo->>Frontend: Abre módulo "Recepción de Carga"
    Frontend-->>Apoyo: Muestra formulario de recepción

    Apoyo->>Frontend: Escanea código de barras
    Frontend->>Backend: GET /api/stock/:codigo
    Backend->>BD: SELECT * FROM prendas WHERE codigo_barra = ?
    
    alt Código existe
        BD-->>Backend: Devuelve datos de la prenda
        Backend-->>Frontend: Datos de la prenda
        Frontend-->>Apoyo: Muestra nombre y precio
    else Código NO existe
        BD-->>Backend: No encontrado
        Backend-->>Frontend: 404 Not Found
        Frontend-->>Apoyo: Muestra formulario para nueva prenda
        Apoyo->>Frontend: Ingresa nombre, precio, categoría, marca
        Frontend->>Backend: POST /api/prendas
        Backend->>BD: INSERT INTO prendas
        BD-->>Backend: Prenda creada
        Backend-->>Frontend: 201 Created
    end

    Apoyo->>Frontend: Selecciona Talla (S, M, L, XL)
    Apoyo->>Frontend: Selecciona Color
    Apoyo->>Frontend: Selecciona Ubicación (almacen/piso_venta)
    Apoyo->>Frontend: Ingresa cantidad recibida
    Apoyo->>Frontend: Selecciona estado de calidad
    Apoyo->>Frontend: Ingresa Guía de Remisión

    Apoyo->>Frontend: Hace clic en "Guardar Fardo"
    Frontend->>Backend: POST /api/inventario/recepcion

    Backend->>BD: SELECT stock_cantidad FROM inventario WHERE id = ? FOR UPDATE
    BD-->>Backend: stock_actual

    Backend->>BD: UPDATE inventario SET stock_cantidad = stock_actual + cantidad
    BD-->>Backend: Stock actualizado

    Backend->>BD: INSERT INTO movimientos (tipo, cantidad, motivo)
    BD-->>Backend: Movimiento registrado

    Backend-->>Frontend: 200 OK - Fardo registrado
    Frontend-->>Apoyo: ✅ "Fardo registrado exitosamente"
```

---

## Descripción del Flujo

### Paso 1: Verificación de Prenda

| Paso | Actor | Acción | Descripción |
|------|-------|--------|-------------|
| 1 | Apoyo | Abre módulo | Ingresa a "Recepción de Carga" |
| 2 | Frontend | Muestra formulario | Presenta el formulario vacío |
| 3 | Apoyo | Escanea código | Lee el código de barras de la prenda |
| 4 | Frontend | GET /api/stock/:codigo | Consulta si la prenda existe |
| 5 | Backend | Consulta BD | Ejecuta SELECT en tabla prendas |

### Paso 2: Registro de Nueva Prenda (si no existe)

| Paso | Actor | Acción | Descripción |
|------|-------|--------|-------------|
| 6 | Apoyo | Ingresa datos | Nombre, precio, categoría, marca |
| 7 | Frontend | POST /api/prendas | Envía datos de nueva prenda |
| 8 | Backend | INSERT INTO prendas | Crea la prenda en la BD |
| 9 | Backend | 201 Created | Confirma creación |

### Paso 3: Registro de Recepción

| Paso | Actor | Acción | Descripción |
|------|-------|--------|-------------|
| 10 | Apoyo | Selecciona atributos | Talla, Color, Ubicación |
| 11 | Apoyo | Ingresa cantidad | Número de unidades recibidas |
| 12 | Apoyo | Selecciona calidad | Conforme / Falla / Manchado |
| 13 | Apoyo | Ingresa Guía | Número de guía de Marvisur |
| 14 | Apoyo | Guarda Fardo | Envía formulario completo |
| 15 | Backend | SELECT FOR UPDATE | Bloquea fila para evitar conflictos |
| 16 | Backend | UPDATE stock | Incrementa stock_cantidad |
| 17 | Backend | INSERT movimiento | Registra entrada en auditoría |
| 18 | Backend | 200 OK | Confirma operación |

---

## Escenarios Alternativos

| Escenario | Comportamiento |
|-----------|----------------|
| **Código de barras no existe** | El sistema permite registrar una nueva prenda |
| **Calidad defectuosa** | El stock se marca como "no apto para venta" |
| **Cantidad incorrecta** | El Apoyo puede corregir antes de guardar |
| **Caída de internet** | El Frontend guarda en LocalStorage para sincronizar después |

---

*Diagrama de Secuencia — SIGAL-LF · UPLA · MDS 2026-1*
