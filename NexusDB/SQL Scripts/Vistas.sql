
-- =============================================
-- 1. DIMENSIÓN PRODUCTO
-- =============================================
-- Objetivo: Unir Producto + Categoría + Proveedor en una sola tabla ancha.
-- Así Power BI no tiene que saltar entre 3 tablas.

Create view vw_DimProducto as 
select 
	p.ProductoID,
	p.NombreProducto,
	c.NombreCategoria,
	pr.NombreEmpresa as Proveedor,
	pr.Pais as PaisOrigen,
	p.CostoUnitario,
	p.PrecioUnitario as PrecioLista
from Productos p
join Categorias c on p.CategoriaID = c.CategoriaID
join Proveedores pr on p.ProveedorID = pr.ProveedorID

go

-- =============================================
-- 2. DIMENSIÓN CLIENTE 
-- =============================================

CREATE OR ALTER VIEW vw_DimCliente AS 
SELECT 
	ClienteID,
	NombreEmpresa,
	Pais,
	Ciudad,
	CASE WHEN EsMiembroPremium = 1 then 'Premium'  ELSE 'Estandar' end as  TipoMembresia
from Clientes
GO


-- =============================================
-- 3. DIMENSIÓN LOGÍSTICA (Transportistas)
-- =============================================

CREATE OR ALTER VIEW vw_DimTransportista AS
SELECT 
    TransportistaID,
    NombreEmpresa AS Transportista
FROM Transportistas;
GO

-- =============================================
-- 4. FACT TABLE: VENTAS (La Transformación Clave)
-- =============================================

Create or alter view wv_FactVentas as 
select 
	d.DetalleID,
	o.OrdenID,
	o.FechaOrden,
	o.FechaEnvioReal,

	-- Llaves para el modelo estrella

	o.ClienteID,
	d.ProductoID,
	o.EmpleadoID,
	o.TransportistaID,
	
	-- Metricas Numericas

	d.Cantidad,
	d.PrecioVenta,
	d.Descuento,

	-- TRANSFORMACIÓN: Cálculo de Venta Neta (Ingreso Real)
    CAST(d.Cantidad * d.PrecioVenta * (1 - d.Descuento) AS DECIMAL(10,2)) AS VentaNeta,
	
	-- transformacion: Calculo de dias para enviar (el Lead Time)
	DATEDIFF(DAY, o.FechaOrden, o.FechaEnvioReal) as DiasEntrega
	
from Ordenes o
join DetalleOrden d on o.OrdenID = d.OrdenID;
GO

-- =============================================
-- 5. FACT TABLE: DEVOLUCIONES (Segunda Tabla de Hechos)
-- =============================================

CREATE OR ALTER VIEW vw_FactDevoluciones AS
SELECT 
	dev.DevolucionID,
	dev.FechaDevolucion,

	-- Recuperamos las llaves para conectar con Dimensiones
	d.ProductoID,
	o.ClienteID,

	--Metricas
	dev.CantidadDevuelta,
	dev.Motivo,

	-- Calculamos cuando dinero perdimos (aprox)
	cast(dev.CantidadDevuelta * d.PrecioVenta as decimal(10,2)) as MontoReembolsado


from Devoluciones dev
join DetalleOrden d on dev.DetalleID = d.DetalleID
join Ordenes o on d.OrdenID = o.OrdenID
GO

PRINT 'Vistas ETL creadas exitosamente. Estructura transformada a Estrella.';