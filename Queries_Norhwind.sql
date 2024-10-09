---------------------------------------------------------------------------------------------------------------------
-- ANALISIS COMERCIAL
---------------------------------------------------------------------------------------------------------------------
-- Se crea esta vista (ventana virtual) con el fin de entrelazar los datos mas importantes de 7 de las tablas
-- Con este compendio de información se puede realizar en excel, el análisis, creación de tablas dinámicas, gráficos y Dashboard

CREATE VIEW ImportantDate AS
SELECT od.OrderID, o.OrderDate, 
	   c.CategoryName, 
	   ProductName, 
	   sup.SupplierName, sup.CitySuppl, sup.CountrySuppl,
	   CONCAT(FirstName,' ',LastName) AS EmployeeName,
	   cus.CustomerName, cus.City, cus.Country,
	   od.Quantity, p.Price, od.Quantity * p.Price AS TotalGrossProfit
FROM 
	   OrderDetails od
LEFT JOIN Orders o 
	   ON od.OrderID = o.OrderID
INNER JOIN Employees e 
	   ON o.EmployeeID = e.EmployeeID
INNER JOIN Products p 
	   ON od.ProductID = p.ProductID
INNER JOIN Categories c 
	   ON p.CategoryID = c.CategoryID
INNER JOIN Customers cus 
	   ON o.CustomerID = cus.CustomerID
INNER JOIN Suppliers sup 
	   ON p.SupplierID = sup.SupplierID
-- Resultado: consulta ejecutada con éxito. Tardó 0ms

-- De igual forma se pueden realizar las consultas individuales en SQLite y trabajar con los gráficos o datos que nos proporciona

-- Vista Utilidad bruta
CREATE VIEW CommercialStatus AS
SELECT p.CategoryID, od.ProductID, p.ProductName, p.Price AS UnitPrice, sum(od.Quantity) AS QuantitySold,
	   p.Price * sum(od.Quantity) AS GrossProfit
FROM OrderDetails od
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY od.ProductID 
ORDER BY GrossProfit desc
-- Resultado: consulta ejecutada con éxito. Tardó 0ms

-- Segmentación de Ventas por Categoría
SELECT cs.CategoryID, c.CategoryName,
	   sum(QuantitySold) AS QuantityCategory, 
	   sum(GrossProfit) AS GrossProfitCategory
FROM CommercialStatus cs
INNER JOIN Categories c ON cs.CategoryID = c.CategoryID
GROUP BY cs.CategoryID
ORDER BY GrossProfitCategory DESC
-- Resultado: 8 filas devueltas en 29ms

-- Vista Utilidad por pedido 
CREATE VIEW UtilityOrders AS
SELECT od.OrderID, o.OrderDate,
	   sum(Quantity) AS TotalQuantity,
	   sum(Quantity * p.Price) AS Utility
FROM OrderDetails od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY od.OrderID
-- Resultado: consulta ejecutada con éxito. Tardó 0ms

-- Utilidad Mensual
SELECT COUNT(OrderID) AS QuantityOrders, 
	   strftime('%Y-%m', OrderDate) AS YearsMonth,
	   sum(Utility) AS UtilityMonth
FROM UtilityOrders
GROUP BY YearsMonth
-- Resultado: 8 filas devueltas en 48ms

-- Segmentación de Ventas y Utilidad por país
SELECT Country, 
	   sum(uo.TotalQuantity) AS TotalQuantity2, 
	   sum(uo.Utility) AS Utility2
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN UtilityOrders uo ON o.OrderID = uo.OrderID
GROUP BY Country
ORDER BY Utility2 DESC
-- Resultado: 21 filas devueltas en 30ms

SELECT o.OrderID, od.ProductID, c.Country,
	   ce.ProductName, od.Quantity
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN CommercialStatus ce ON od.ProductID = ce.ProductID
WHERE Country IN ('USA', 'Austria', 'Germany', 'Brazil', 'Canada', 
	              'France','UK', 'Ireland', 'Venezuela', 'Sweden')
GROUP BY ce.ProductName
ORDER BY c.Country
-- Resultado: 77 filas devueltas en 46ms

-- Segmentación de empleados por categoría
SELECT cs.CategoryID, o.EmployeeID,
	   CONCAT(e.FirstName,' ', e.LastName) AS EmployeeName,
	   sum(od.Quantity) AS TotalQuantityEmploy,
	   sum(od.Quantity * cs.UnitPrice) AS GrossProfitEmploy 
FROM Orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN CommercialStatus cs ON od.ProductID = cs.ProductID
GROUP BY e.EmployeeID, CategoryID
ORDER BY CategoryID, TotalQuantityEmploy DESC
-- Resultado: 70 filas devueltas en 45ms

-- Top 5 de los mejores clientes por categoría
WITH CustomersCategory AS (
	SELECT 
		p.CategoryID, o.CustomerID, 
	    c.CustomerName,
	    sum(od.Quantity) AS TotalQuantity,
	    sum(od.Quantity * Price) AS GrossProfitCust
	FROM 
		Orders o
	INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
	INNER JOIN Products p 	ON od.ProductID = p.ProductID
	INNER JOIN Customers c ON o.CustomerID = c.CustomerID
	GROUP BY 
		p.CategoryID, o.CustomerID
	--ORDER BY 
		--CategoryID, GrossProfitCust DESC
)
SELECT *,
	(SELECT count(*)
	FROM CustomersCategory cc2
	WHERE cc2.CategoryID = cc.CategoryID
	  and cc2.GrossProfitCust >= cc.GrossProfitCust) AS Ranking
FROM
	CustomersCategory cc
WHERE Ranking <=5
ORDER BY CategoryID, Ranking
-- Resultado: 40 filas devueltas en 35ms