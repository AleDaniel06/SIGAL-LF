# 02 · Especificación de Requisitos de Software (ERS v1.0)

**Proyecto:** Sistema Integrado de Gestión de Almacén e Inventario — Tiendas "La Fábrica"
**Estándar:** IEEE 830 adaptado
**Versión:** 1.0 · Julio 2026
**Estado:** Validado con cliente  

---

## 1. Introducción

### 1.1 Propósito
Este documento especifica los requisitos funcionales y no funcionales del sistema SIGAL-LF para Tiendas "La Fábrica" — Sucursal Huancayo. Está dirigido al equipo de desarrollo (Grupo [Número]) y al cliente (Encargado de Tienda de la sucursal).

### 1.2 Ámbito del Sistema
El sistema se denomina **SIGAL-LF** y cubre la recepción de mercadería en fardos masivos, el control de inventario matricial, la consulta express en el mostrador de caja y el reporte de mermas e incidencias de fábrica. No cubre módulos de RRHH (planillas o asistencia), créditos o préstamos a clientes, ni integración con sistemas de compras de proveedores externos.

### 1.3 Definiciones

| Término | Definición |
| :--- | :--- |
| **Stock Matricial** | Inventario organizado por la combinación de tres variables: Talla, Color y Ubicación. |
| **Consulta Express** | Buscador de alta velocidad optimizado para el mostrador de caja. |
| **Fardo Masivo** | Lote de mercadería cerrada que llega en grandes cantidades vía transporte comercial. |
| **Merma** | Prenda de vestir o calzado que presenta fallas de origen o daños que impiden su venta. |
| **Cruce de Códigos** | Escaneo fraudulento de un código de barras activo para vender un producto sin stock lógico. |

---

## 2. Descripción General

### 2.1 Perspectiva del Producto
SIGAL-LF es un sistema nuevo que reemplaza el flujo desarticulado de hojas Excel locales enviadas por correo. A diferencia de su predecesor, la aplicación web se conecta directamente a una base de datos relacional centralizada en la nube, garantizando que el stock de prendas (desglosado por talla y color) esté disponible para la caja de forma inmediata tras su recepción física en el almacén local.

### 2.2 Funciones Principales
