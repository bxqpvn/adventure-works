------------------------------------------------------------------------------------------------------------------------------------------------

/* Category-level production metrics query*/
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
