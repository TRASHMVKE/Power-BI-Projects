--CREATE VIEW Inventario_PorweBI as
SELECT 
a.ModifiedDate as FechaEntrada,
a.ProductID,
b.Name as Producto,
d.ProductModelID,
d.Name as ProductLine, 
c.LocationID,
c.Name as Location, 
a.Quantity
FROM Production.ProductInventory a 
join Production.Product b on a.ProductID = b.ProductID
join Production.Location c on a.LocationID = c.LocationID
join Production.ProductModel d on b.ProductModelID = d.ProductModelID
