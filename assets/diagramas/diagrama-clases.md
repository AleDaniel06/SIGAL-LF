# Diagrama de Clases — SIGAL-LF (Backend)

**Sistema:** Sistema Integrado de Gestión de Almacén e Inventario en Tienda "La Fábrica" - Sucursal Huancayo

---

## Código Mermaid

```mermaid
classDiagram
    class Usuario {
        +int id_usuario
        +string nombre
        +string email
        +string password_hash
        +string rol
        +boolean activo
        +timestamp creado_en
        +autenticar(email, password) boolean
        +cambiarRol(id, nuevoRol) boolean
        +desactivar(id) boolean
    }

    class Prenda {
        +int id_prenda
        +string codigo_barra
        +string nombre
        +decimal precio
        +string categoria
        +string marca
        +timestamp fecha_ingreso
        +actualizarPrecio(id, nuevoPrecio) boolean
        +obtenerStockPorTalla(id) array
        +obtenerStockPorColor(id) array
    }

    class Inventario {
        +int id_inventario
        +int id_prenda
        +string talla
        +string color
        +string ubicacion
        +int stock_cantidad
        +incrementarStock(id, cantidad) boolean
        +decrementarStock(id, cantidad) boolean
        +validarStock(id, cantidad) boolean
        +obtenerStockMatricial(id) array
    }

    class Movimiento {
        +int id_movimiento
        +int id_inventario
        +string tipo_movimiento
        +int cantidad
        +timestamp fecha_movimiento
        +string motivo
        +string estado
        +int id_usuario
        +registrarMovimiento(data) boolean
        +obtenerHistorial(filtros) array
        +obtenerMovimientosPorFecha(fechaInicio, fechaFin) array
    }

    class SyncVenta {
        +int id_sync
        +string codigo_prenda
        +string talla
        +string color
        +int cantidad_vendida
        +timestamp fecha_venta
        +string estado_sync
        +int intentos
        +timestamp ultimo_intento
        +string error_mensaje
        +sincronizar(id) boolean
        +reintentar(id) boolean
        +obtenerPendientes() array
    }

    class Configuracion {
        +int id_config
        +string clave
        +string valor
        +string descripcion
        +timestamp actualizado_en
        +obtenerConfiguracion(clave) string
        +actualizarConfiguracion(clave, valor) boolean
    }

    class AuthService {
        +login(email, password) token
        +logout(token) boolean
        +verificarToken(token) boolean
        +generarToken(user) string
        +validarRol(token, rolRequerido) boolean
    }

    class InventarioService {
        +consultarStock(codigo) object
        +consultarStockMatricial(codigo, talla, color) object
        +registrarRecepcion(data) object
        +registrarVenta(data) object
        +registrarMerma(data) object
        +validarStockDisponible(codigo, talla, color, cantidad) boolean
    }

    class ReporteService {
        +generarRotacion(filtros) object
        +generarConsistencia(filtros) object
        +exportarPDF(data) file
        +exportarExcel(data) file
        +generarDashboard() object
    }

    Usuario "1" --> "*" Movimiento : registra
    Prenda "1" --> "*" Inventario : tiene
    Inventario "1" --> "*" Movimiento : genera
    Inventario "1" --> "*" SyncVenta : sincroniza
    AuthService --> Usuario : autentica
    InventarioService --> Inventario : gestiona
    InventarioService --> Movimiento : registra
    ReporteService --> Movimiento : analiza
    ReporteService --> Inventario : consulta
```

## Descripción de Clases

```
+-------------------+--------------------------------------------------+----------------------------------------+
| Clase             | Descripción                                      | Atributos Clave                        |
+-------------------+--------------------------------------------------+----------------------------------------+
| Usuario           | Representa a los usuarios del sistema           | id, nombre, email, rol                 |
| Prenda            | Catálogo de prendas de vestir                   | id, codigo_barra, nombre, precio       |
| Inventario        | Stock matricial por talla/color/ubicación       | id_prenda, talla, color, ubicacion, stock |
| Movimiento        | Auditoría de todas las transacciones            | tipo_movimiento, cantidad, motivo      |
| SyncVenta         | Sincronización con sistema de ventas            | estado_sync, intentos                  |
| Configuracion     | Parámetros del sistema                          | clave, valor                           |
| AuthService       | Servicio de autenticación                       | -                                      |
| InventarioService | Lógica de negocio de inventario                 | -                                      |
| ReporteService    | Generación de reportes                          | -                                      |
+-------------------+--------------------------------------------------+----------------------------------------+
```

---

## Relaciones

```
+---------------------+--------+------------------------------------------------------+
| Relación            | Tipo   | Descripción                                          |
+---------------------+--------+------------------------------------------------------+
| Usuario → Movimiento | 1:N    | Un usuario registra muchos movimientos               |
| Prenda → Inventario  | 1:N    | Una prenda tiene muchos registros de inventario      |
| Inventario → Movimiento | 1:N | Un registro de inventario tiene muchos movimientos   |
| Inventario → SyncVenta | 1:N  | Un registro de inventario tiene muchas sincronizaciones |
+---------------------+--------+------------------------------------------------------+
```

---

*Diagrama de Clases — SIGAL-LF · UPLA · MDS 2026-1*
