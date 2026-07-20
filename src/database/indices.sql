-- ============================================
-- SIGAL-LF - Índices de Optimización
-- Versión: 1.0
-- ============================================

-- Para búsquedas rápidas por código de barras
CREATE INDEX idx_prendas_codigo ON prendas(codigo_barra);

-- Para consultas matriciales por talla y color
CREATE INDEX idx_inventario_prenda_talla_color ON inventario(id_prenda, talla, color);

-- Para consultas de movimientos por fecha
CREATE INDEX idx_movimientos_fecha ON movimientos(fecha_movimiento);

-- Para consultas de sincronización por estado
CREATE INDEX idx_sync_estado ON sync_ventas(estado_sync);
