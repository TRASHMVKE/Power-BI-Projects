--CREATE VIEW Compras_PowerBi AS
SELECT 
a.PurchaseOrderID as OrdenID,
b.OrderDate as FechaOrden,
b.ShipDate as FechaEnvio,
a.DueDate as FechaVencimiento,
a.ProductID,
d.Name as Descripcion, 
a.OrderQty as CantidadPedida,
a.ReceivedQty as CantidadRecibida,
a.RejectedQty as CantidadDevuelta,
a.UnitPrice as PrecioUnitario,
a.LineTotal as MontoTotal,
b.VendorID as ProveedorID,
e.Name as Proveedor,
c.AverageLeadTime
FROM Purchasing.PurchaseOrderDetail a
JOIN Purchasing.PurchaseOrderHeader b on a.PurchaseOrderID = b.PurchaseOrderID
JOIN Purchasing.ProductVendor c on a.ProductID = c.ProductID
JOIN Production.Product d on c.ProductID = d.ProductID 
JOIN Purchasing.Vendor e  on b.VendorID = e.BusinessEntityID
