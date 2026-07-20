# Diagrama de Secuencia — Registro de Venta (Decremento de Stock)

**Sistema:** SIGAL-LF  
**Flujo:** Cajera realiza una venta y el sistema decrementa el stock automáticamente

---

## Código Mermaid

```mermaid
sequenceDiagram
    participant Cajera
    participant Frontend as Cliente Web (Caja)
    participant Backend as API Backend (Node.js + Express)
    participant BD as Base de Datos (PostgreSQL)

    Cajera->>Frontend: Escanea código de barras
    Frontend->>Backend: GET /api/stock/:codigo
    Backend->>BD: SELECT * FROM inventario WHERE codigo = ?
    BD-->>Backend: Devuelve stock por talla/color
    Backend-->>Frontend: Respuesta con stock disponible
    Frontend-->>Cajera: Muestra stock disponible

    Cajera->>Frontend: Confirma venta de 1 unidad
    Frontend->>Backend: POST /api/inventario/venta
    
    Backend->>BD: SELECT stock_cantidad FROM inventario WHERE id = ? FOR UPDATE
    BD-->>Backend: stock_actual = 100

    alt Stock suficiente (>= 1)
        Backend->>BD: UPDATE inventario SET stock_cantidad = 99 WHERE id = ?
        BD-->>Backend: Stock actualizado
        
        Backend->>BD: INSERT INTO movimientos (tipo, cantidad, motivo)
        BD-->>Backend: Movimiento registrado
        
        Backend-->>Frontend: 200 OK - Stock actualizado
        Frontend-->>Cajera: ✅ Venta exitosa
    else Stock insuficiente (< 1)
        Backend-->>Frontend: 400 Bad Request - Stock insuficiente
        Frontend-->>Cajera: ❌ No hay stock disponible
    end
```

---

## Descripción del Flujo

### Paso 1: Consulta de Stock

| Paso | Actor | Acción | Descripción |
|------|-------|--------|-------------|
| 1 | Cajera | Escanea código | La cajera escanea el código de barras de la prenda |
| 2 | Frontend | GET /api/stock/:codigo | Envía petición al backend |
| 3 | Backend | Consulta BD | Ejecuta SELECT en la base de datos |
| 4 | BD | Devuelve stock | Retorna stock disponible por talla/color |
| 5 | Backend | Responde | Devuelve respuesta al Frontend |
| 6 | Frontend | Muestra stock | Muestra stock disponible a la Cajera |

### Paso 2: Registro de Venta

| Paso | Actor | Acción | Descripción |
|------|-------|--------|-------------|
| 7 | Cajera | Confirma venta | La cajera confirma la venta de 1 unidad |
| 8 | Frontend | POST /api/inventario/venta | Envía petición de decremento |
| 9 | Backend | Valida stock | Ejecuta SELECT FOR UPDATE para bloquear la fila |
| 10 | BD | Devuelve stock | Retorna stock_actual = 100 |
| 11 | Backend | Decrementa stock | UPDATE stock_cantidad = 99 |
| 12 | Backend | Registra movimiento | INSERT INTO movimientos |
| 13 | Backend | Confirma | 200 OK - Stock actualizado |
| 14 | Frontend | Muestra éxito | ✅ Venta exitosa |

---

## Escenarios Alternativos

| Escenario | Comportamiento |
|-----------|----------------|
| **Stock insuficiente** | El sistema rechaza la venta y muestra mensaje de error |
| **Caída de internet** | El Frontend guarda la venta en LocalStorage para sincronizar después |
| **Base de datos bloqueada** | El Backend ejecuta rollback automático (ACID) |

---

*Diagrama de Secuencia — SIGAL-LF · UPLA · MDS 2026-1*
