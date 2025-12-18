

CREATE OR ALTER VIEW vw_Productos AS
select 
	ProductoID,
	NombreProducto as Producto,
	Categoria,
	CostoUnitario as Costo, 
	PrecioVenta as Precio
from DimProducto
GO

Create or alter view vw_Clientes as
select 
	ClienteID,
	NombreCliente as Cliente,
	Pais,
	Segmento
from DimCliente
GO


CREATE OR ALTER VIEW vw_Tiendas AS
select 
	TiendaID,
	NombreTienda as Tienda,
	Ciudad
from DimTienda;
GO

-- 4. VISTA DE VENDEDORES (Dimensión)
CREATE OR ALTER VIEW vw_Vendedores AS
SELECT 
    VendedorID,
    NombreVendedor AS Vendedor,
    Zona
FROM DimVendedor;
GO


Create or alter VIEW vw_Ventas as
select
	VentaID,
	FechaVenta as Fecha, 
	ProductoID,
	ClienteID,
	TiendaID,
	VendedorID,
	Cantidad,
	MontoTotal as VentaTotal
from FactVentas
GO

PRINT 'Vistas creadas correctamente. Listas para Power BI.';