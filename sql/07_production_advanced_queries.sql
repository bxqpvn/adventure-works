------------------------------------------------------------------------------------------------------------------------------------------------

/* Category-level production metrics query */

WITH ProductionCategoryAndSubcategory as
	(SELECT
		p.ProductID,
		p.Name as ProductName,
		c.Name as Category,
		sc.Name as Subcategory,
		StandardCost,
		ListPrice	
	FROM Production.Product p
	left join Production.ProductSubcategory sc				-- Join Product with Category and Subcategory tables
		ON p.ProductSubcategoryID = sc.ProductSubcategoryID
	left join Production.ProductCategory c
		ON sc.ProductCategoryID = c.ProductCategoryID
),
CategoryCostAndProfit as
	(SELECT
		CASE
		WHEN Category IS NULL THEN 'Others'				-- Products without assigned category						
		ELSE Category
		END AS Category,
		COUNT(ProductID) as NumberOfProducts,						-- Number of products per category
		ROUND(AVG(StandardCost),0) AS  AverageStandardCost,			-- Average standard cost per category
		ROUND(AVG(ListPrice),0) as AverageListPrice,				-- Average list price per category
		ROUND(SUM(StandardCost),2) AS  TotalCost,
		ROUND(SUM(ListPrice),2) as TotalPrice,
		SUM(ListPrice - StandardCost) as TotalProfit,				-- Total profit per category
		ROUND(SUM(ListPrice - StandardCost) / NULLIF(SUM(ListPrice), 0) * 100, 2) AS ProfitMargin	-- Profit margin (%)
	FROM ProductionCategoryAndSubcategory
	GROUP BY Category
)
SELECT
	Category,
	NumberOfProducts,
	AverageStandardCost,
	AverageListPrice,
	TotalCost,
	TotalPrice,
	TotalProfit,
	ProfitMargin,
	RANK() OVER (ORDER BY TotalProfit DESC) AS ProfitabilityRank,			-- Ranked the profit using RANK()
	CASE
		WHEN TotalProfit > 50000 THEN 'Most Profitable'						-- Profitability flag by profit ranges with CASE
		WHEN TotalProfit BETWEEN 15000 AND 50000 THEN 'Very Profitable'
		ELSE 'Profitable'
		END AS ProfitabilityFlag
FROM CategoryCostAndProfit
ORDER BY TotalProfit DESC;

------------------------------------------------------------------------------------------------------------------------------------------------

/* Top 10 most expensive products */

WITH ProductPriceDetails AS (
	SELECT
		DISTINCT LEFT(p.Name, ISNULL(NULLIF(CHARINDEX(',', p.Name), 0) - 1, LEN(p.Name))) AS ProductName,	-- Remove size/variant information after the comma in product names
		psc.Name AS Subcategory,																			-- "Road-150 Red, 62" becomes "Road-150 Red"
		p.ListPrice,
		CASE
			WHEN p.MakeFlag = 1 THEN 'Manufactured in-house'		-- ProductType Flag: Manufactured and Purchased
			ELSE 'Purchased'
		END AS ProductType
	FROM Production.Product p
	LEFT JOIN Production.ProductSubcategory psc						-- Join the ProductSubcategory table to better understand the product
		ON p.ProductSubcategoryID = psc.ProductSubcategoryID
)
SELECT TOP 10		-- Final selection: top 10 most expensive products
	ProductName,
	Subcategory,
	ListPrice
FROM ProductPriceDetails
WHERE ProductType like 'Manufactured%'	-- Use 'Purchased' or 'P%' to get the Top 10 most expensive purchased products
ORDER BY ListPrice DESC;

------------------------------------------------------------------------------------------------------------------------------------------------

/* Product Ratings */

SELECT
	Name as ProductName,
	Rating,
	ReviewerName,
	Comments
FROM Production.Product	p
LEFT JOIN Production.ProductReview pr
	on p.ProductID = pr.ProductID
WHERE Rating is NOT NULL	-- Only 4 products have received a review
ORDER BY Rating DESC;

------------------------------------------------------------------------------------------------------------------------------------------------
