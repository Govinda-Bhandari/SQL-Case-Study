--Formating data and keeping in correct order
SELECT TOP (10) InvoiceNo
      ,StockCode
      ,Description
      ,Quantity
      ,FORMAT(InvoiceDate,'yyyy-MM-dd') as InvoiceDate
      ,ROUND(UnitPrice,2) as UnitPrice
      ,[CustomerID]
      ,[Country]
  FROM [DATA_DB].[dbo].retail_sales_data

--Deleting records whre CustomerID is null and Negative Quantity value
DELETE FROM retail_sales_data
 WHERE CustomerID IS NULL
 or Quantity < 0;

--Removing Duplicates with Rank Windows Functions:

WITH RankedSales AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY InvoiceNo, 
        StockCode, Quantity, InvoiceDate ORDER BY InvoiceNo) AS rank
    FROM retail_sales_data
)
DELETE FROM RankedSales
    WHERE rank > 1


-- TOP 5 Product by Quantity
SELECT TOP (5) StockCode, Description, 
    SUM(Quantity) AS TotalQuantity
FROM retail_sales_data
GROUP BY StockCode, Description
ORDER BY TotalQuantity DESC
;

--Total Revenue by Country
SELECT Country, 
round(SUM(Quantity * UnitPrice),2) AS TotalRevenue
FROM retail_sales_data
GROUP BY Country
ORDER BY TotalRevenue DESC;

--Top 3 Most Spending Customers
SELECT Top (3) CustomerID,
    round(SUM(Quantity * UnitPrice),2) AS TotalSpend
FROM retail_sales_data
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY TotalSpend DESC
