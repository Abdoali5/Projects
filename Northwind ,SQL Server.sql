SELECT C.CustomerID, C.CompanyName, C.Country, YEAR(O.OrderDate) AS year
FROM dbo.Customers AS C LEFT OUTER JOIN dbo.Orders AS O 
ON C.CustomerID = O.CustomerID

SELECT R.ShipCountry, CONVERT(numeric(10, 2), SUM(O.UnitPrice * O.Quantity * O.Discount)) AS Discount
FROM dbo.Orders AS R LEFT OUTER JOIN dbo.[Order Details] AS O 
ON R.OrderID = O.OrderID
GROUP BY R.ShipCountry

SELECT C.Country, FORMAT(SUM(T.Net_sales), 'F2') AS Total_Salse
FROM dbo.Orders AS O LEFT OUTER JOIN dbo.Total_price AS T 
ON O.OrderID = T.OrderID 
INNER JOIN dbo.Customers AS C 
ON O.CustomerID = C.CustomerID
WHERE (O.ShippedDate IS NOT NULL)
GROUP BY C.Country


SELECT T.OrderID, SUM(T.Net_Sales) AS Net_Sales, CONVERT(numeric(10, 2), SUM(T.Net_Sales * 0.07)) AS Profit, 
CONVERT(numeric(10, 2), SUM(O.UnitPrice * O.Quantity * O.Discount)) AS Discount, T.Month, T.year
FROM dbo.Total_Salse AS T LEFT OUTER JOIN dbo.[Order Details] AS O 
ON T.OrderID = O.OrderID
GROUP BY T.OrderID, T.Month, T.year


SELECT TOP (5) O.CustomerID, FORMAT(SUM(T.Net_sales), 'N2') AS Total_Salse
FROM dbo.Orders AS O LEFT OUTER JOIN
dbo.Total_price AS T ON O.OrderID = T.OrderID
WHERE  (O.ShippedDate IS NOT NULL)
GROUP BY O.CustomerID


SELECT TOP (5) ProductID, ProductName, FORMAT(SUM(Net_sales), 'N2') AS Net_Salse
FROM dbo.Total_price
GROUP BY ProductID, ProductName
ORDER BY Net_Salse DESC


SELECT O.OrderID, O.ProductID, P.ProductName, O.UnitPrice * O.Quantity AS sales, O.UnitPrice * O.Quantity * O.Discount AS Discount,
O.UnitPrice * O.Quantity - O.UnitPrice * O.Quantity * O.Discount AS Net_sales
FROM dbo.[Order Details] AS O LEFT OUTER JOIN dbo.Products AS P 
ON O.ProductID = P.ProductID


SELECT O.OrderID, CONVERT(numeric(10, 2), SUM(O.UnitPrice * O.Quantity - O.UnitPrice * O.Quantity * O.Discount)) AS Net_Sales,
FORMAT(R.ShippedDate, 'yyyy') AS year, FORMAT(R.ShippedDate, 'MMMM') AS Month
FROM dbo.[Order Details] AS O LEFT OUTER JOIN dbo.Orders AS R 
ON O.OrderID = R.OrderID
WHERE (R.ShippedDate IS NOT NULL)
GROUP BY O.OrderID, FORMAT(R.ShippedDate, 'yyyy'), FORMAT(R.ShippedDate, 'MMMM')


 Alter VIEW the_profit__product AS
SELECT O.ProductID, P.ProductName,Format(SUM (O.UnitPrice * O.Quantity - O.UnitPrice * O.Quantity * O.Discount ), 'F2')AS Net_sales,
Format(SUM (O.UnitPrice * O.Quantity - O.UnitPrice * O.Quantity * O.Discount )*0.07, 'F2')AS Net_profit
FROM dbo.[Order Details] AS O LEFT JOIN dbo.Products AS P 
ON O.ProductID = P.ProductID
GROUP BY O.ProductID, P.ProductName

create view Categories_PS AS
SELECT C.CategoryName,Format(SUM (O.UnitPrice * O.Quantity - O.UnitPrice * O.Quantity * O.Discount ), 'N')AS Net_sales,
Format(SUM (O.UnitPrice * O.Quantity - O.UnitPrice * O.Quantity * O.Discount )*0.07, 'N')AS Net_profit
FROM dbo.[Order Details] AS O LEFT OUTER JOIN dbo.Products AS P
ON O.ProductID = P.ProductID
LEFT JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName

Select * from Products_quantity 
create view Products_quantity AS
SELECT D.ProductID , P.ProductName , SUM(D.Quantity) AS Quantities ,YEAR(O.ShippedDate) as Year
FROM [Order Details] as D left join Products AS P 
ON D.ProductID = P.ProductID
left join Orders AS O
ON D.OrderID = O.OrderID
WHERE O.ShippedDate IS NOT NULL
group by D.ProductID , P.ProductName, YEAR(O.ShippedDate)

SELECT COUNT(Distinct OrderID)
FROM Orders
WHERE ShippedDate IS NOT NULL

SELECT COUNT(Distinct ProductID)
FROM Products

SELECT COUNT (Discontinued)
FROM Products
WHERE Discontinued = 1

SELECT COUNT(Distinct D.ProductID)
FROM [Order Details] AS D left join Orders AS O
ON D.OrderID = O.OrderID
WHERE O.ShippedDate IS NOT NULL 

SELECT * FROM Monthly_Net_sales
ALTER VIEW Monthly_Net_sales AS
SELECT O.EmployeeID , E.FirstName , SUM(T.Net_Sales) AS Net_Sales , T.Month , T.year FROM Orders AS O LEFT JOIN Total_Salse AS T 
ON O.OrderID = T.OrderID 
left join Employees AS E 
ON O.EmployeeID = E.EmployeeID
WHERE T.Net_Sales IS NOT NULL
group by O.EmployeeID , T.Month , T.year, E.FirstName

CREATE VIEW ORDER_SALES AS
SELECT O.OrderID , O.EmployeeID , E.FirstName , SUM(T.Net_Sales) AS Net_Sales 
FROM Orders AS O LEFT JOIN Total_Salse AS T 
ON O.OrderID = T.OrderID 
left join Employees AS E 
ON O.EmployeeID = E.EmployeeID
WHERE T.Net_Sales IS NOT NULL
group by O.EmployeeID , O.OrderID, E.FirstName

SELECT * FROM ORDER_SALES



CREATE VIEW ORDER_DATE AS
SELECT E.FirstName AS EmployeeName, SUM(CASE WHEN O.ShippedDate <= O.RequiredDate THEN 1 ELSE 0 END) AS OnTimeOrders,
SUM(CASE WHEN O.ShippedDate > O.RequiredDate THEN 1 ELSE 0 END) AS DelayedOrders
FROM Employees E JOIN Orders O ON E.EmployeeID = O.EmployeeID
WHERE O.ShippedDate IS NOT NULL
GROUP BY E.FirstName, E.LastName
SELECT * FROM ORDER_DATE

ALTER VIEW Shipping_Cost AS
SELECT S.ShipperID , S.CompanyName , O.ShipCountry ,SUM(O.Freight) AS TotalFreight
FROM Shippers AS S LEFT JOIN Orders AS O
ON S.ShipperID = O.ShipVia
AND O.ShippedDate IS NOT NULL
GROUP BY S.ShipperID , S.CompanyName , O.ShipCountry

SELECT * FROM Delivery

CREATE VIEW Delivery AS
SELECT S.ShipperID , S.CompanyName ,
	SUM(CASE WHEN ShippedDate <= RequiredDate THEN 1 ELSE 0 END) AS On_time ,
	SUM(CASE WHEN ShippedDate > RequiredDate THEN 1 ELSE 0 END) AS Delayed
FROM Shippers AS S LEFT JOIN Orders AS O
ON S.ShipperID = O.ShipVia
AND O.ShippedDate IS NOT NULL
GROUP BY S.ShipperID , S.CompanyName

SELECT SUM(Freight) FROM Orders
WHERE ShippedDate IS NOT NULL

SELECT  * FROM Categories_PS

SELECT AVG( DATEDIFF(DAY, ShippedDate , RequiredDate) )AS DaysBetween
FROM Orders
WHERE ShippedDate IS NOT NULL;

