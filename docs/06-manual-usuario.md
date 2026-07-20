# 📖 Manual de Usuario — SIGAL-LF

**Sistema Integrado de Gestión de Almacén e Inventario en Tienda "La Fábrica" - Sucursal Huancayo**

---

## 1. Introducción

SIGAL-LF es un sistema web diseñado para gestionar el inventario de la tienda "La Fábrica" - Sucursal Huancayo. Permite registrar la recepción de mercadería, consultar stock por talla/color/ubicación, registrar ventas y gestionar mermas.

---

## 2. Acceso al Sistema

### 2.1 Inicio de Sesión

1. Abrir el navegador web en la PC de caja
2. Ingresar a la URL: `https://sigal-lf.onrender.com`
3. Ingresar las credenciales:
   - **Usuario:** (entregado por el administrador)
   - **Contraseña:** (entregada por el administrador)
4. Hacer clic en **"Iniciar Sesión"**

### 2.2 Roles y Permisos

| Rol | Descripción | Módulos Accesibles |
|-----|-------------|-------------------|
| **Apoyo de Caja** | Registra recepción de fardos | Recepción de Carga, Consulta de Stock |
| **Cajera Principal** | Gestiona ventas y consultas | Consulta Express, Congelar Precios, Cierre de Caja |
| **Encargado de Tienda** | Gestiona mermas y reportes | Todos los módulos + Dashboard |

---

## 3. Módulo: Recepción de Carga (Apoyo de Caja)

### 3.1 Registro de Fardo de Marvisur

1. Ir a **"Recepción de Carga"**
2. Escanear o digitar el **código de barras** de la prenda
3. Seleccionar:
   - **Talla:** S, M, L, XL
   - **Color:** (ej. Rojo, Azul, Negro)
   - **Ubicación:** Almacén General / Piso de Venta
4. Ingresar la **cantidad** recibida
5. Seleccionar el **estado de calidad:**
   - ✅ Conforme
   - ⚠️ Falla de Costura
   - ⚠️ Manchado
6. Ingresar el número de **Guía de Remisión** de Marvisur
7. Hacer clic en **"Guardar Fardo"**

**Resultado:** El stock se incrementa automáticamente en la base de datos.

---

## 4. Módulo: Consulta de Stock (Todos los roles)

### 4.1 Búsqueda por Código de Barras

1. Ir a **"Consulta de Stock"**
2. Ingresar el código de barras en el campo de búsqueda
3. Presionar **Enter** o hacer clic en **"Buscar"**
4. Ver los resultados:
   - Nombre de la prenda
   - Precio
   - Stock por talla (S, M, L, XL)
   - Stock por color
   - Ubicación física

### 4.2 Búsqueda por Palabra Clave

1. Escribir el nombre de la prenda (ej. "Camisa")
2. El sistema mostrará todas las prendas que coincidan
3. Seleccionar la prenda deseada para ver el detalle

---

## 5. Módulo: Consulta Express (Cajera)

### 5.1 Búsqueda Rápida

1. Ir a **"Consulta Express"** (pantalla optimizada para velocidad)
2. Escanear el código de barras o digitar el nombre
3. Ver la información en **< 1.5 segundos**

### 5.2 Congelar Precio (Contingencia)

**Uso:** Cuando el sistema de ventas externo no responde o el precio ha cambiado sin aviso.

1. Buscar la prenda en **"Consulta Express"**
2. Hacer clic en **"Congelar Precio"**
3. Ingresar el precio manualmente (ej. S/. 45.00)
4. Confirmar el cambio
5. El sistema usará este precio para la venta hasta que se restaure la conexión

---

## 6. Módulo: Registro de Mermas (Encargado de Tienda)

### 6.1 Registrar Merma

1. Ir a **"Registro de Mermas"**
2. Seleccionar la prenda afectada
3. Seleccionar el **motivo:**
   - Falla de Costura
   - Manchado
   - Robo Verificado
   - Transporte Dañado
4. Ingresar la **cantidad** afectada
5. Agregar una **descripción** (opcional)
6. Hacer clic en **"Registrar Merma"**

**Resultado:** El stock disminuye justificadamente y queda registrado en el historial.

---

## 7. Módulo: Dashboard y Reportes (Encargado de Tienda)

### 7.1 Visualizar Dashboard

1. Ir a **"Dashboard"**
2. Ver los indicadores clave:
   - Rotación de inventario por talla/color
   - Stock estancado (prendas sin movimiento en 30 días)
   - Consistencia de saldos (comparación almacén vs ventas)

### 7.2 Exportar Reportes

1. En el Dashboard, seleccionar el filtro deseado (fecha, categoría, talla)
2. Hacer clic en **"Exportar a PDF"** o **"Exportar a Excel"**
3. El archivo se descargará automáticamente

---

## 8. Cierre de Caja (Cajera Principal)

1. Al final del turno, ir a **"Cierre de Caja"**
2. Verificar el resumen:
   - Total de ventas del turno
   - Desglose por método de pago (efectivo, Yape, Plin)
   - Número de transacciones
   - Ventas pendientes de sincronización
3. Hacer clic en **"Cerrar Turno"**

---

## 9. Solución de Problemas Comunes

| Problema | Solución |
|----------|----------|
| No puedo iniciar sesión | Verificar credenciales con el encargado de tienda |
| La consulta de stock es lenta | Verificar conexión a internet, limpiar caché del navegador |
| El precio no se actualiza | Usar "Congelar Precio" en modo contingencia |
| No puedo registrar merma | Verificar que el usuario tenga rol de "Encargado" |
| El sistema no responde | Esperar 10 segundos y recargar la página (F5) |

---

## 10. Contacto y Soporte

- **Responsable del sistema:** José Moori (Scrum Master)
- **Correo:** T00052C@ms.upla.edu.pe
- **Reporte de incidentes:** Crear un issue en GitHub

---

*Manual de Usuario — SIGAL-LF · UPLA · MDS 2026-1*
