-- ============================================
-- SIGAL-LF - Script de Inicialización de Base de Datos
-- Versión: 1.0
-- Fecha: Julio 2026
-- ============================================

-- ============================================
-- 1. TABLA DE USUARIOS
-- ============================================
CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(20) CHECK(rol IN ('cajera', 'supervisor', 'apoyo')) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- 2. TABLA DE PRENDAS (CATÁLOGO)
-- ============================================
CREATE TABLE prendas (
    id_prenda SERIAL PRIMARY KEY,
    codigo_barra VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(100),
    marca VARCHAR(100),
    fecha_ingreso TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- 3. TABLA DE INVENTARIO (STOCK MATRICIAL)
-- ============================================
CREATE TABLE inventario (
    id_inventario SERIAL PRIMARY KEY,
    id_prenda INTEGER NOT NULL REFERENCES prendas(id_prenda) ON DELETE CASCADE,
    talla VARCHAR(5) CHECK(talla IN ('S', 'M', 'L', 'XL', 'XXL')) NOT NULL,
    color VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(20) CHECK(ubicacion IN ('almacen', 'piso_venta')) NOT NULL,
    stock_cantidad INTEGER DEFAULT 0 CHECK(stock_cantidad >= 0),
    UNIQUE(id_prenda, talla, color, ubicacion)
);

-- ============================================
-- 4. TABLA DE MOVIMIENTOS (AUDITORÍA)
-- ============================================
CREATE TABLE movimientos (
    id_movimiento SERIAL PRIMARY KEY,
    id_inventario INTEGER NOT NULL REFERENCES inventario(id_inventario),
    tipo_movimiento VARCHAR(20) CHECK(tipo_movimiento IN ('entrada', 'venta', 'merma', 'ajuste')) NOT NULL,
    cantidad INTEGER NOT NULL,
    fecha_movimiento TIMESTAMP DEFAULT NOW(),
    motivo TEXT,
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id_usuario),
    referencia TEXT
);

-- ============================================
-- 5. TABLA DE SINCRONIZACIÓN CON SISTEMA DE VENTAS
-- ============================================
CREATE TABLE sync_ventas (
    id_sync SERIAL PRIMARY KEY,
    codigo_prenda VARCHAR(50) NOT NULL,
    talla VARCHAR(5) NOT NULL,
    color VARCHAR(50) NOT NULL,
    cantidad_vendida INTEGER NOT NULL,
    fecha_venta TIMESTAMP DEFAULT NOW(),
    estado_sync VARCHAR(20) CHECK(estado_sync IN ('pendiente', 'procesado', 'error')) DEFAULT 'pendiente',
    intentos INTEGER DEFAULT 0,
    ultimo_intento TIMESTAMP,
    error_mensaje TEXT
);

-- ============================================
-- 6. TABLA DE CONFIGURACIÓN
-- ============================================
CREATE TABLE configuracion (
    id_config SERIAL PRIMARY KEY,
    clave VARCHAR(100) UNIQUE NOT NULL,
    valor TEXT NOT NULL,
    descripcion TEXT,
    actualizado_en TIMESTAMP DEFAULT NOW()
);
