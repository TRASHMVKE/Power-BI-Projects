-- 4. POBLADO DE MAESTROS
INSERT INTO Categorias VALUES ('Electrónica', 'Gadgets y computadoras'), ('Mobiliario', 'Sillas y escritorios'), ('Oficina', 'Papel y consumibles');
INSERT INTO Transportistas VALUES ('SpeedyExpress', 10.00), ('UnitedPackage', 15.00), ('FederalShipping', 20.00);
INSERT INTO Proveedores VALUES ('TechGiant', 'USA', 'John Doe'), ('FurnitureKing', 'China', 'Li Wei'), ('PaperCo', 'USA', 'Dwight S.');
INSERT INTO Empleados VALUES ('Nancy Davolio', 'Sales Rep', '2020-01-01', 'Norte'), ('Andrew Fuller', 'Vice President', '2019-05-01', 'Central'), ('Janet Leverling', 'Sales Rep', '2021-03-15', 'Sur');

-- Generamos 10 Productos
INSERT INTO Productos VALUES 
('Laptop X1', 1, 1, 500, 900, 50), ('Mouse Wireless', 1, 1, 10, 25, 200), ('Monitor 4K', 1, 1, 150, 300, 80),
('Silla Ergonómica', 2, 2, 80, 200, 40), ('Escritorio Standing', 2, 2, 120, 350, 20),
('Paquete Papel A4', 3, 3, 2, 5, 500), ('Bolígrafos Pack', 3, 3, 1, 3, 1000),
('Smartphone Pro', 1, 1, 300, 700, 60), ('Tablet 10in', 1, 1, 150, 300, 100), ('Lámpara LED', 2, 2, 15, 40, 150);

-- Generamos 10 Clientes
INSERT INTO Clientes (NombreEmpresa, Pais, Ciudad, EsMiembroPremium) VALUES 
('Alfreds Futterkiste', 'Alemania', 'Berlin', 1), ('Ana Trujillo Emparedados', 'Mexico', 'DF', 0), 
('Antonio Moreno Taquería', 'Mexico', 'DF', 0), ('Around the Horn', 'UK', 'London', 1), 
('Berglunds snabbköp', 'Suecia', 'Luleå', 0), ('Blauer See Delikatessen', 'Alemania', 'Mannheim', 1), 
('Blondel père et fils', 'Francia', 'Strasbourg', 0), ('Bólido Comidas', 'España', 'Madrid', 1), 
('Bon app', 'Francia', 'Marseille', 0), ('Bottom-Dollar Markets', 'Canada', 'Tsawwassen', 0);

-- 5. GENERADOR DE TRANSACCIONES COMPLEJAS
SET NOCOUNT ON;

DECLARE @i INT = 0;
DECLARE @TotalOrdenes INT = 2000; -- Generaremos 2000 órdenes

-- Variables para el bucle
DECLARE @OrdenID INT, @ClienteID INT, @EmpleadoID INT, @TransportistaID INT;
DECLARE @FechaOrden DATE, @FechaEnvio DATE;
DECLARE @DiasEnvio INT, @CostoEnvioBase DECIMAL(10,2);
DECLARE @NumItems INT, @j INT, @ProdID INT, @Cant INT, @Precio DECIMAL(10,2), @DetalleID INT;
DECLARE @EsDevolucion INT;

WHILE @i < @TotalOrdenes
BEGIN
    -- 1. Datos de Cabecera
    SET @ClienteID = (SELECT TOP 1 ClienteID FROM Clientes ORDER BY NEWID());
    SET @EmpleadoID = (SELECT TOP 1 EmpleadoID FROM Empleados ORDER BY NEWID());
    SET @TransportistaID = (SELECT TOP 1 TransportistaID FROM Transportistas ORDER BY NEWID());
    
    -- Fecha aleatoria entre 2023 y 2025
    SET @FechaOrden = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 1000), '2023-01-01');
    
    -- Lógica de Envío: Entre 1 y 10 días después de la orden. A veces NULL (aún no enviado).
    IF (ABS(CHECKSUM(NEWID()) % 100) < 5) -- 5% de probabilidad de no haber sido enviado aún
        SET @FechaEnvio = NULL;
    ELSE
        BEGIN
            SET @DiasEnvio = ABS(CHECKSUM(NEWID()) % 10) + 1;
            SET @FechaEnvio = DATEADD(DAY, @DiasEnvio, @FechaOrden);
        END

    -- Costo envío (Base + un extra random)
    SELECT @CostoEnvioBase = TarifaBase FROM Transportistas WHERE TransportistaID = @TransportistaID;
    
    INSERT INTO Ordenes (ClienteID, EmpleadoID, FechaOrden, FechaEnvioReal, TransportistaID, CostoEnvio)
    VALUES (@ClienteID, @EmpleadoID, @FechaOrden, @FechaEnvio, @TransportistaID, @CostoEnvioBase + (ABS(CHECKSUM(NEWID()) % 20)));
    
    SET @OrdenID = SCOPE_IDENTITY(); -- Capturamos el ID de la orden creada

    -- 2. Datos de Detalle (Items dentro de la orden)
    SET @NumItems = ABS(CHECKSUM(NEWID()) % 4) + 1; -- Entre 1 y 4 productos por orden
    SET @j = 0;

    WHILE @j < @NumItems
    BEGIN
        SET @ProdID = (SELECT TOP 1 ProductoID FROM Productos ORDER BY NEWID());
        SET @Cant = ABS(CHECKSUM(NEWID()) % 10) + 1;
        SELECT @Precio = PrecioUnitario FROM Productos WHERE ProductoID = @ProdID;

        INSERT INTO DetalleOrden (OrdenID, ProductoID, PrecioVenta, Cantidad, Descuento)
        VALUES (@OrdenID, @ProdID, @Precio, @Cant, (ABS(CHECKSUM(NEWID()) % 20)) / 100.0 );
        
        SET @DetalleID = SCOPE_IDENTITY();

        -- 3. Lógica de Devoluciones (Complejidad extra)
        -- 8% de probabilidad de que este item sea devuelto
        IF (ABS(CHECKSUM(NEWID()) % 100) < 8) AND @FechaEnvio IS NOT NULL
        BEGIN
            INSERT INTO Devoluciones (DetalleID, FechaDevolucion, Motivo, CantidadDevuelta)
            VALUES (
                @DetalleID, 
                DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 30) + 5, @FechaEnvio), -- Devolución 5-35 días después del envío
                CASE ABS(CHECKSUM(NEWID()) % 3) 
                    WHEN 0 THEN 'Producto Dañado' 
                    WHEN 1 THEN 'No coincide descripción' 
                    ELSE 'Pedido equivocado' 
                END,
                @Cant -- Devuelve todo
            );
        END

        SET @j = @j + 1;
    END

    SET @i = @i + 1;
END

PRINT 'Base de datos NexusDB creada con estructura compleja y datos simulados.';
SET NOCOUNT OFF;
GO