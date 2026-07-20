-- ============================================
-- SIGAL-LF - Datos de Prueba (Seed)
-- Versión: 1.0
-- ============================================

-- ============================================
-- USUARIOS DE PRUEBA
-- Contraseña: 123456 (hash generado con bcrypt)
-- ============================================
INSERT INTO usuarios (nombre, email, password_hash, rol) VALUES
('Cajera Principal', 'cajera@lafabrica.com', '$2b$10$ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890', 'cajera'),
('Encargado Tienda', 'encargado@lafabrica.com', '$2b$10$ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890', 'supervisor'),
('Apoyo Caja', 'apoyo@lafabrica.com', '$2b$10$ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890', 'apoyo');

-- ============================================
-- PRENDAS DE PRUEBA
-- ============================================
INSERT INTO prendas (codigo_barra, nombre, precio, categoria, marca) VALUES
('8801234567890', 'Camisa Roja', 45.00, 'Camisas', 'Marca A'),
('8801234567891', 'Pantalón Azul', 65.00, 'Pantalones', 'Marca B'),
('8801234567892', 'Zapatos Negros', 85.00, 'Calzado', 'Marca C');

-- ============================================
-- INVENTARIO INICIAL
-- ============================================
INSERT INTO inventario (id_prenda, talla, color, ubicacion, stock_cantidad) VALUES
(1, 'S', 'Rojo', 'almacen', 10),
(1, 'M', 'Rojo', 'almacen', 20),
(1, 'L', 'Rojo', 'almacen', 15),
(1, 'XL', 'Rojo', 'almacen', 5),
(2, 'M', 'Azul', 'piso_venta', 25),
(3, '42', 'Negro', 'piso_venta', 30);
