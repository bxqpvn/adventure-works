--==============================================================================================================================================

/* Data Quality Checks */

------------------------------------------------------------------------------------------------------------------------------------------------
-- How many products have a production cost and list price equal to 0? -------------------------------------------------------------------------
WITH CostAndPriceFlag AS (
	SELECT
		ProductID,
		Name as ProductName,
		StandardCost,
		ListPrice,
		MakeFlag,			-- 0 = Product is purchased, 1 = Product is manufactured in-house.
		CASE
			WHEN StandardCost = 0 AND ListPrice = 0 THEN 1	-- Products with both StandardCost and ListPrice equal to 0 are flagged as 1
		ELSE 0
		END AS ZeroPriceFlag
	FROM Production.Product
)
SELECT DISTINCT
	(SELECT COUNT(ProductID) FROM CostAndPriceFlag WHERE MakeFlag = 1 and ZeroPriceFlag = 1) as ManufacturedProducts,
	(SELECT COUNT(ProductID) FROM CostAndPriceFlag WHERE MakeFlag = 0 and ZeroPriceFlag = 1) as PurchasedProducts
FROM CostAndPriceFlag;
------------------------------------------------------------------------------------------------------------------------------------------------
-- How many products are missing a color? ------------------------------------------------------------------------------------------------------
-- How many products are missing size information? ---------------------------------------------------------------------------------------------
-- How many products are not linked to a product model? ----------------------------------------------------------------------------------------
WITH MissingAttributes as (
	SELECT
		CASE WHEN Color IS NULL THEN 1 ELSE 0 END as ColorFlag,
		CASE WHEN Size IS NULL THEN 1 ELSE 0 END as SizeFlag,
		CASE WHEN ProductModelID IS NULL THEN 1 ELSE 0 END as ModelFlag
	FROM Production.Product
)
SELECT
	(SELECT SUM(ColorFlag) FROM MissingAttributes WHERE ColorFlag = 1) as ColorMissing,
	(SELECT SUM(SizeFlag) FROM MissingAttributes WHERE SizeFlag = 1) as SizeMissing,
	(SELECT SUM(ModelFlag) FROM MissingAttributes WHERE ModelFlag = 1) as ModelMissing;
------------------------------------------------------------------------------------------------------------------------------------------------
-- How many products are not linked to a category / subcategory? -------------------------------------------------------------------------------
WITH ProductsNullColumns as (
	SELECT
		CASE WHEN c.Name IS NULL THEN 1 ELSE 0 END as CategoryFlag,
		CASE WHEN sc.Name IS NULL THEN 1 ELSE 0 END as SubcategoryFlag	
	FROM Production.Product p
		left join Production.ProductSubcategory sc
			ON p.ProductSubcategoryID = sc.ProductSubcategoryID
		left join Production.ProductCategory c
			ON sc.ProductCategoryID = c.ProductCategoryID
)
SELECT
	SUM(CategoryFlag) as NullCategory,
	SUM(SubcategoryFlag) as NullSubcategory
From ProductsNullColumns;
------------------------------------------------------------------------------------------------------------------------------------------------

--==============================================================================================================================================

/* Category-level production metrics query */

WITH ProductionCategoryAndSubcategory as
	(SELECT
		p.ProductID,
		p.Name as ProductName,
		c.Name as Category,
		sc.Name as Subcategory,
		StandardCost
	FROM Production.Product p
	LEFT JOIN Production.ProductSubcategory sc				-- Join Product with Category and Subcategory tables
		ON p.ProductSubcategoryID = sc.ProductSubcategoryID
	LEFT JOIN Production.ProductCategory c
		ON sc.ProductCategoryID = c.ProductCategoryID
),
CategorySalesAndProfit AS
(
    SELECT
        CASE
            WHEN c.Category IS NULL THEN 'Others'        -- Products without assigned category
            ELSE c.Category
        END AS Category,
        COUNT(DISTINCT p.ProductID) AS NumberOfProducts, -- Number of distinct products per category
        SUM(sod.OrderQty * p.StandardCost) AS TotalCost, -- Total cost based on sold quantity
        SUM(
            sod.LineTotal - (sod.OrderQty * p.StandardCost)
        ) AS TotalProfit,                                -- Total profit based on real sales
        ROUND(
            SUM(
                sod.LineTotal - (sod.OrderQty * p.StandardCost)
            ) / NULLIF(SUM(sod.LineTotal), 0) * 100,
            2
        ) AS ProfitMargin                                -- Profit margin (%) per category
    FROM ProductionCategoryAndSubcategory c
    LEFT JOIN Production.Product p
        ON c.ProductID = p.ProductID
    LEFT JOIN Sales.SalesOrderDetail sod                 -- Join with Sales table to get real sales data
        ON p.ProductID = sod.ProductID
    GROUP BY c.Category
)
SELECT
    Category,
    NumberOfProducts,
    TotalCost,
    TotalProfit,
    ProfitMargin,
    RANK() OVER (ORDER BY TotalProfit DESC) AS ProfitabilityRank, -- Rank categories by total profit
    CASE
        WHEN TotalProfit > 500000 THEN 'Most Profitable'          -- Profitability flag by profit ranges
        WHEN TotalProfit BETWEEN 150000 AND 500000 THEN 'Very Profitable'
        ELSE 'Profitable'
    END AS ProfitabilityFlag
FROM CategorySalesAndProfit;

--==============================================================================================================================================

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

--==============================================================================================================================================

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

--==============================================================================================================================================
