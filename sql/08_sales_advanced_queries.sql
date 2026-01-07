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

/* Running Total of Monthly Sales */

WITH YearMonthExtract AS (                                 -- Extract year and month from OrderDate using FORMAT()
    SELECT
        FORMAT(OrderDate, 'yyyy-MM') AS YearMonth,
        TotalDue
    FROM Sales.SalesOrderHeader
),
MonthlySales AS (                                         -- Aggregate sales to calculate total monthly revenue
    SELECT
        YearMonth,
        SUM(TotalDue) AS TotalSales
    FROM YearMonthExtract
    GROUP BY YearMonth
),
SalesRunningTotal AS (                                    -- Calculate running total of monthly sales
    SELECT
        YearMonth,
        TotalSales,
        SUM(TotalSales) OVER (
            ORDER BY YearMonth ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW -- Includes all previous months up to the current one to compute cumulative sales over time
        ) AS RunningTotal
    FROM MonthlySales
)
SELECT                                                     -- Final result with rounded values for better readability
    YearMonth,
    ROUND(TotalSales, 2) AS TotalSales,
    ROUND(RunningTotal, 2) AS RunningTotal
FROM SalesRunningTotal;

--==============================================================================================================================================

/* Total Sales per Category */	-- Sales + Production

WITH SalesPerCategory AS (
    SELECT
        pc.Name AS Category,          -- Product category name
        sod.LineTotal                 -- Revenue at product (order line) level
    FROM Sales.SalesOrderDetail sod
    LEFT JOIN Production.Product p
        ON sod.ProductID = p.ProductID
    LEFT JOIN Production.ProductSubcategory ps
        ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    LEFT JOIN Production.ProductCategory pc
        ON ps.ProductCategoryID = pc.ProductCategoryID
)
SELECT
    Category,
    ROUND(SUM(LineTotal), 2) AS TotalSales   -- Total sales per category
FROM SalesPerCategory
GROUP BY Category
ORDER BY TotalSales DESC;

--==============================================================================================================================================
