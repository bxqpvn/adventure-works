--==============================================================================================================================================

/* Month-over-Month Sales Growth */

WITH YearMonthExtract AS (		-- Extract year-month from order date and keep total sales value
	SELECT
		FORMAT(OrderDate, 'yyyy-MM') AS YearMonth,
		TotalDue
	FROM Sales.SalesOrderHeader
),
MoMSales AS (					-- Aggregate total sales per month
	SELECT
		YearMonth,
		ROUND(SUM(TotalDue), 0) AS TotalSales
	FROM YearMonthExtract
	GROUP BY YearMonth
),
MoMLag AS (						-- Use LAG() to get previous month's total sales
	SELECT
		YearMonth,
		TotalSales,
		LAG(TotalSales, 1) OVER (ORDER BY YearMonth) AS TotalSalesLag
	FROM MoMSales
)
SELECT							-- Calculate absolute and percentage Month-over-Month growth
	YearMonth,
	TotalSales,
	TotalSalesLag,
	TotalSales - TotalSalesLag AS [MoM Sales Difference],
	ROUND(((TotalSales - TotalSalesLag) / NULLIF(TotalSalesLag, 0)) * 100, 2) AS [MoM Growth (%)]
FROM MoMLag;

--==============================================================================================================================================

/* YoY Sales Difference */

WITH YoYSales AS (				-- Aggregate total sales per year
	SELECT
		YEAR(OrderDate) AS DateYear,
		ROUND(SUM(TotalDue), 0) AS TotalSales
	FROM Sales.SalesOrderHeader
	GROUP BY YEAR(OrderDate)
),
YoYLag AS (						-- Use LAG() to compare sales with previous year
	SELECT
		DateYear,
		TotalSales,
		LAG(TotalSales, 1) OVER (ORDER BY DateYear) AS TotalSalesLag
	FROM YoYSales
)
SELECT							-- Use LAG() to compare sales with previous year
	DateYear,
	TotalSales,
	TotalSalesLag,
	TotalSales - TotalSalesLag AS [YoY Sales Difference],
	ROUND(((TotalSales - TotalSalesLag) / NULLIF(TotalSalesLag, 0)) * 100, 2) AS [YoY Growth (%)]
FROM YoYLag;

--==============================================================================================================================================

/* Average Order Value by Territory */

WITH AddTerritory AS (
	SELECT
		YEAR(OrderDate) as DateYear,			-- Extract year from order date
		SalesOrderID,
		TotalDue,
		st.Name as Territory
	FROM Sales.SalesOrderHeader soh
	LEFT JOIN Sales.SalesTerritory st			-- Join SalesTerritory to add territory names
		ON soh.TerritoryID = st.TerritoryID
)
SELECT
	Territory,
	COUNT(DISTINCT SalesOrderID) as OrderCount,						-- Number of orders per territory
	ROUND(SUM(TotalDue), 2) as TotalSales,							-- Total sales per territory
	ROUND(SUM(TotalDue) / COUNT(DISTINCT SalesOrderID), 0) as AOV	-- Average Order Value per Territory
FROM AddTerritory
WHERE DateYear = 2014			-- Filter to analyze a single year for better comparability
GROUP BY Territory
ORDER BY AOV DESC;

--==============================================================================================================================================
