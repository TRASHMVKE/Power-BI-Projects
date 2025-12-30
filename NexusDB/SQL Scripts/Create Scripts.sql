-- 1. CREACIÓN DE LA BASE DE DATOS
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'NexusDB')
BEGIN
    CREATE DATABASE NexusDB;
END
GO

USE NexusDB;
GO

-- REINICIO TOTAL (SOLO PARA PRUEBAS)
-- Borramos tablas en orden inverso a sus relaciones para evitar errores de FK
IF OBJECT_ID('Devoluciones', 'U') IS NOT NULL DROP TABLE Devoluciones;
IF OBJECT_ID('DetalleOrden', 'U') IS NOT NULL DROP TABLE DetalleOrden;
IF OBJECT_ID('Ordenes', 'U') IS NOT NULL DROP TABLE Ordenes;
IF OBJECT_ID('Productos', 'U') IS NOT NULL DROP TABLE Productos;
IF OBJECT_ID('Proveedores', 'U') IS NOT NULL DROP TABLE Proveedores;
IF OBJECT_ID('Categorias', 'U') IS NOT NULL DROP TABLE Categorias;
IF OBJECT_ID('Transportistas', 'U') IS NOT NULL DROP TABLE Transportistas;
IF OBJECT_ID('Clientes', 'U') IS NOT NULL DROP TABLE Clientes;
IF OBJECT_ID('Empleados', 'U') IS NOT NULL DROP TABLE Empleados;
GO