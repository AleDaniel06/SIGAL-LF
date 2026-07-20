# Diagrama Entidad-Relación (DER) — SIGAL-LF

**Sistema:** Sistema Integrado de Gestión de Almacén e Inventario en Tienda "La Fábrica" - Sucursal Huancayo

---

## Código Mermaid

```mermaid
erDiagram
    USUARIOS {
        int id_usuario PK
        string nombre
        string email UK
        string password_hash
        string rol
        boolean activo
        timestamp creado_en
    }

    PRENDAS {
        int id_prenda PK
        string codigo_barra UK
        string nombre
        decimal precio
        string categoria
        string marca
        timestamp fecha_ingreso
    }

    INVENTARIO {
        int id_inventario PK
        int id_prenda FK
        string talla
        string color
        string ubicacion
        int stock_cantidad
    }

    MOVIMIENTOS {
        int id_movimiento PK
        int id_inventario FK
        string tipo_movimiento
        int cantidad
        timestamp fecha_movimiento
        string motivo
        string estado
        int id_usuario FK
        timestamp fecha_ingreso
        boolean activo
    }

    SYNC_VENTAS {
        int id_sync PK
        string codigo_prenda
        string talla
        string color
        int cantidad_vendida
        timestamp fecha_venta
        string estado_sync
        int intentos
        timestamp ultimo_intento
        string error_mensaje
    }

    CONFIGURACION {
        int id_config PK
        string clave UK
        string valor
        string descripcion
        timestamp actualizado_en
    }

    USUARIOS ||--o{ MOVIMIENTOS : "registra"
    PRENDAS ||--o{ INVENTARIO : "tiene"
    INVENTARIO ||--o{ MOVIMIENTOS : "genera"
    INVENTARIO ||--o{ SYNC_VENTAS : "sincroniza"
```

---

## Tabla de Entidades

```
+----------------+--------------------------------------------------+-------------------+
| Entidad        | Descripción                                      | Clave Primaria    |
+----------------+--------------------------------------------------+-------------------+
| USUARIOS       | Usuarios del sistema                             | id_usuario        |
| PRENDAS        | Catálogo de prendas                              | id_prenda         |
| INVENTARIO     | Stock matricial por talla/color/ubicación        | id_inventario     |
| MOVIMIENTOS    | Auditoría de transacciones                       | id_movimiento     |
| SYNC_VENTAS    | Sincronización con POS                           | id_sync           |
| CONFIGURACION  | Parámetros del sistema                           | id_config         |
+----------------+--------------------------------------------------+-------------------+
```

---

## Claves Foráneas

```
+----------------+-------------------+------------------------------------------+
| Tabla          | Clave Foránea     | Referencia                               |
+----------------+-------------------+------------------------------------------+
| INVENTARIO     | id_prenda         | PRENDAS(id_prenda)                       |
| MOVIMIENTOS    | id_inventario     | INVENTARIO(id_inventario)                |
| MOVIMIENTOS    | id_usuario        | USUARIOS(id_usuario)                     |
+----------------+-------------------+------------------------------------------+
```

---

## Relaciones

```
+---------------------------+--------+--------------------------------------------------+
| Relación                  | Tipo   | Descripción                                      |
+---------------------------+--------+--------------------------------------------------+
| USUARIOS → MOVIMIENTOS    | 1:N    | Un usuario registra muchos movimientos           |
| PRENDAS → INVENTARIO      | 1:N    | Una prenda tiene muchos registros de inventario  |
| INVENTARIO → MOVIMIENTOS  | 1:N    | Un registro de inventario genera muchos movimientos |
| INVENTARIO → SYNC_VENTAS  | 1:N    | Un registro de inventario tiene muchas sincronizaciones |
+---------------------------+--------+--------------------------------------------------+
```

---

## Restricciones de Integridad

| Restricción | Tabla | Descripción |
|-------------|-------|-------------|
| UNIQUE | PRENDAS | `codigo_barra` debe ser único |
| UNIQUE | CONFIGURACION | `clave` debe ser única |
| UNIQUE | INVENTARIO | `(id_prenda, talla, color, ubicacion)` debe ser única |
| CHECK | INVENTARIO | `talla` solo puede ser S, M, L, XL, XXL |
| CHECK | INVENTARIO | `ubicacion` solo puede ser almacen, piso_venta |
| CHECK | MOVIMIENTOS | `tipo_movimiento` solo puede ser entrada, venta, merma, ajuste |
| ON DELETE CASCADE | INVENTARIO | Si se elimina una prenda, se eliminan sus registros de inventario |

---

*Diagrama Entidad-Relación — SIGAL-LF · UPLA · MDS 2026-1*
