-- 1. CREACIÓN DE LA BASE DE DATOS
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'TechTrendDB')
BEGIN
    CREATE DATABASE TechTrendDB;
END
GO

USE TechTrendDB;
GO

-- 2. ELIMINAR TABLAS SI EXISTEN (Para reiniciar limpio)
IF OBJECT_ID('FactVentas', 'U') IS NOT NULL DROP TABLE FactVentas;
IF OBJECT_ID('DimProducto', 'U') IS NOT NULL DROP TABLE DimProducto;
IF OBJECT_ID('DimCliente', 'U') IS NOT NULL DROP TABLE DimCliente;
IF OBJECT_ID('DimTienda', 'U') IS NOT NULL DROP TABLE DimTienda;
IF OBJECT_ID('DimVendedor', 'U') IS NOT NULL DROP TABLE DimVendedor;
GO

-- 3. CREACIÓN DE TABLAS DE DIMENSIÓN (Quién, Qué, Dónde)

-- Dimensión Producto
CREATE TABLE DimProducto (
    ProductoID INT PRIMARY KEY IDENTITY(1,1),
    NombreProducto NVARCHAR(100),
    Categoria NVARCHAR(50),
    CostoUnitario DECIMAL(10, 2),
    PrecioVenta DECIMAL(10, 2)
);

-- Dimensión Cliente
CREATE TABLE DimCliente (
    ClienteID INT PRIMARY KEY IDENTITY(1,1),
    NombreCliente NVARCHAR(100),
    Pais NVARCHAR(50),
    Segmento NVARCHAR(50) -- Ej: Corporativo, Particular
);

-- Dimensión Tienda
CREATE TABLE DimTienda (
    TiendaID INT PRIMARY KEY IDENTITY(1,1),
    NombreTienda NVARCHAR(50),
    Ciudad NVARCHAR(50)
);

-- Dimensión Vendedor
CREATE TABLE DimVendedor (
    VendedorID INT PRIMARY KEY IDENTITY(1,1),
    NombreVendedor NVARCHAR(100),
    Zona NVARCHAR(50)
);

-- 4. POBLADO DE DATOS MAESTROS (DIMENSIONES)

INSERT INTO DimProducto (NombreProducto, Categoria, CostoUnitario, PrecioVenta) VALUES
('Laptop Pro X', 'Computación', 800.00, 1200.00),
('Smartphone Z', 'Moviles', 300.00, 600.00),
('Monitor 24in', 'Periféricos', 100.00, 180.00),
('Teclado Mecánico', 'Periféricos', 40.00, 90.00),
('Auriculares NoiseCancel', 'Audio', 50.00, 110.00);

INSERT INTO DimCliente (NombreCliente, Pais, Segmento) VALUES
('Empresa Alpha', 'España', 'Corporativo'),
('Juan Perez', 'México', 'Particular'),
('Tech Solutions', 'Colombia', 'Corporativo'),
('Maria Garcia', 'España', 'Particular'),
('Global Services', 'México', 'Corporativo'),
('Carlos Lopez', 'Argentina', 'Particular');

INSERT INTO DimTienda (NombreTienda, Ciudad) VALUES
('Tienda Central', 'Madrid'),
('Sucursal Norte', 'CDMX'),
('Sucursal Sur', 'Bogotá'),
('Tienda Online', 'Internet');

INSERT INTO DimVendedor (NombreVendedor, Zona) VALUES
('Ana Torres', 'EMEA'),
('Luis Gomez', 'LATAM'),
('Sofia Ruiz', 'LATAM');

-- 5. CREACIÓN DE TABLA DE HECHOS (Transacciones)
CREATE TABLE FactVentas (
    VentaID INT PRIMARY KEY IDENTITY(1,1),
    FechaVenta DATE,
    ProductoID INT FOREIGN KEY REFERENCES DimProducto(ProductoID),
    ClienteID INT FOREIGN KEY REFERENCES DimCliente(ClienteID),
    TiendaID INT FOREIGN KEY REFERENCES DimTienda(TiendaID),
    VendedorID INT FOREIGN KEY REFERENCES DimVendedor(VendedorID),
    Cantidad INT,
    MontoTotal DECIMAL(10, 2) -- Se calculará en base a PrecioVenta * Cantidad
);
GO

-- 6. GENERADOR DE DATOS ALEATORIOS (BUCLE PARA 1000 VENTAS)
SET NOCOUNT ON;
DECLARE @i INT = 0;
DECLARE @TotalRows INT = 1000; -- Cantidad de ventas a simular
DECLARE @FechaRandom DATE;
DECLARE @ProdID INT;
DECLARE @CliID INT;
DECLARE @StoreID INT;
DECLARE @VendID INT;
DECLARE @Cant INT;
DECLARE @Precio DECIMAL(10,2);

WHILE @i < @TotalRows
BEGIN
    -- Generar fecha aleatoria entre 2023-01-01 y 2024-12-31
    SET @FechaRandom = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 730), '2023-01-01');
    
    -- Seleccionar IDs aleatorios existentes en las dimensiones
    SET @ProdID = (SELECT TOP 1 ProductoID FROM DimProducto ORDER BY NEWID());
    SET @CliID = (SELECT TOP 1 ClienteID FROM DimCliente ORDER BY NEWID());
    SET @StoreID = (SELECT TOP 1 TiendaID FROM DimTienda ORDER BY NEWID());
    SET @VendID = (SELECT TOP 1 VendedorID FROM DimVendedor ORDER BY NEWID());
    
    -- Cantidad aleatoria entre 1 y 5
    SET @Cant = ABS(CHECKSUM(NEWID()) % 5) + 1;
    
    -- Obtener precio actual del producto para calcular total
    SELECT @Precio = PrecioVenta FROM DimProducto WHERE ProductoID = @ProdID;

    -- Insertar venta
    INSERT INTO FactVentas (FechaVenta, ProductoID, ClienteID, TiendaID, VendedorID, Cantidad, MontoTotal)
    VALUES (@FechaRandom, @ProdID, @CliID, @StoreID, @VendID, @Cant, @Cant * @Precio);

    SET @i = @i + 1;
END

PRINT 'Base de datos creada y 1000 filas generadas exitosamente.';
SET NOCOUNT OFF;
GO

-- 7. VERIFICACIÓN RÁPIDA
SELECT  * FROM FactVentas;