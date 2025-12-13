![SSMS 22](https://img.shields.io/badge/SSMS-22-blue) ![SQL Server](https://img.shields.io/badge/SQL%20Server-blue)
![adventureworkslogo](https://github.com/user-attachments/assets/8ee8d47e-54de-4f9e-af49-a9aa898066f2)

***AdventureWorks is a Microsoft sample database that simulates a fictional company, Adventure Works Cycles, and provides structured data across sales, production, HR, and other business areas.***

>[!NOTE]
>### Project Overview & Tools
>
>*In this project, I will use SSMS 22 to connect to the AdventureWorks database. I will explore and analyze the tables, writing SQL queries to practice and demonstrate my SQL skills. After completing the SQL analysis, I also plan to build my first Power BI dashboard based on the insights gathered from the dataset.*
>Tools:
>
>SQL Server Management Studio (SSMS) 22 – Querying and managing the AdventureWorks database
>
>SQL Server Express – Local SQL environment for restoring and working with the database
>
>AdventureWorks 2022 – Sample dataset used for analysis
>
>Power BI Desktop – Building the dashboard based on SQL insights

## 1. Connecting to the AdventureWorks Database

I restored the AdventureWorks2022 sample database in SSMS following the official [Microsoft installation guide](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=ssms):

- Moving the .bak file into the SQL Server backup folder

![sql server backup location](https://github.com/user-attachments/assets/c51e97dc-dae7-4641-8f58-5c37ee215751)

- Restoring the database from SSMS

![restore database](https://github.com/user-attachments/assets/51055724-7456-420e-b5a6-542df1a8e679)

- Locating the .bak file

![bak file](https://github.com/user-attachments/assets/e30a8c9b-4b82-4b87-915b-af873a4275cc)

- That’s it: the connection is set up and ready for querying

![connection restored succesfully](https://github.com/user-attachments/assets/fb6aca1c-09c2-4d23-865e-27432ac7bffa)

## 2. Database Diagrams

To better understand the structure of the AdventureWorks database, I created diagrams for each major functional areas:

- **Production**

![production diagram](https://github.com/user-attachments/assets/37165444-0abf-4e05-8d3a-06c7db46be77)

- **Sales**

![sales diagram](https://github.com/user-attachments/assets/2700a126-94cf-4c09-811f-261971652935)

- **Human Resources**

![HR diagram](https://github.com/user-attachments/assets/1b894189-4998-4228-8242-b0a256c95fb1)

- **Person**

![person diagram](https://github.com/user-attachments/assets/425e89c7-d78e-46d5-b86b-3e2fabb6f939)

- **Purchasing**

![purchasing diagram](https://github.com/user-attachments/assets/8a9e729c-74b0-44d3-8541-071380b337e0)

Done! This is how it looks in the Object Explorer window: 

![database diagrams](https://github.com/user-attachments/assets/920a01a0-b819-4b96-93d1-eca7c909a21f)

>[!IMPORTANT]
>By showing table relationships (PK–FK) and the overall schema structure, these diagrams serve as a foundation for the SQL queries covered in the next section.

## 3. Database Exploration

*In this section, I explore each functional area by reviewing table relationships and column metadata, including table and column properties. I also run basic queries to better understand the data before moving to advanced analysis.*

I started with exploratory SQL queries to review tables across all functional areas.

![tables by functional area](https://github.com/user-attachments/assets/2f2a7760-903d-4254-a162-f8c0722d3a43)

As a result, I obtained a table listing all tables for each schema.

![canva schema tables](https://github.com/user-attachments/assets/c08d9b87-ab12-4e75-a239-3f5506e95af6)


Then, I used the Properties window to explore details for tables and columns.

![properties 1](https://github.com/user-attachments/assets/730b2498-a4f6-46d9-85ba-bbca2b4f8bab)

![properties 2](https://github.com/user-attachments/assets/e2d1fb13-8a7f-4be0-9bb1-4c0608e35220)


I then ran simple TOP (20) queries on tables from the Production schema to quickly preview the data and validate table contents:

![production basiq queries](https://github.com/user-attachments/assets/318b4543-477c-4e1a-97d8-e9a0e7bde378)


I applied the same exploratory queries to the Sales schema to review transactional tables:

![sales basic queries](https://github.com/user-attachments/assets/da178e8b-d4a7-47ae-8c03-21e829cec892)


I followed the same steps for the HR, Person, and Purchasing schemas to get a quick overview of their datasets.


>[!IMPORTANT]
>This step helped me build a clear understanding of the database before moving on to more advanced queries.

## 4. Advanced SQL Queries & Insights

*Here, I perform advanced SQL queries to uncover meaningful insights from the data, using filtering and analytics techniques to answer specific business questions.*

**Initially, I focused on the Production tables:**

```sql
use AdventureWorks2022

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
```
This query retrieves a list of products along with their corresponding categories and subcategories. It joins the Product table with the ProductSubcategory and ProductCategory tables using **LEFT JOINs**, ensuring that all products are included even if some do not have a subcategory or category assigned.

As a result, I obtained the following table:

![product + category + subcategory](https://github.com/user-attachments/assets/681c63a0-bd36-4154-a851-9bbf840c0317)

After joining the required tables (as shown in the previous CTE), I calculated ***AGGREGATED PRODUCTION METRICS AT CATEGORY-LEVEL***, including **costs, prices, profit, and profit margin**, and **handled missing category values** by assigning a default category label.

```sql
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
```

A profitability rank was then added using the **RANK() function**, along with a business-oriented profitability flag created through a **CASE expression**.

```sql
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
```

The table below shows the output of this query.

![category-level metrics](https://github.com/user-attachments/assets/0be18770-d343-420c-a99c-534416dcc144)

After that, I tried to find the ***TOP 10 MOST EXPENSIVE PRODUCTS***

> [!WARNING]
> In the first phase, I wrote this query, but the result was not satisfying because it returned a table with the same products repeated, only differing by size/variant. In practice, the columns representing product names and their prices were duplicated.
>
> ![top 10 products wrong](https://github.com/user-attachments/assets/bb952c31-c925-4ec4-8a32-2c33a5768df3)

> [!TIP]
> To fix this, I decided to remove the size/ variant information that appears after the comma, keeping only the base product name.
> 
> It was also necessary to add ```DISTINCT``` to eliminate duplicates. Otherwise, the result would have been exactly the same as before.
> ```sql 
> DISTINCT LEFT(p.Name, ISNULL(NULLIF(CHARINDEX(',', p.Name), 0) - 1, LEN(p.Name))) AS ProductName
> 
> -- "Road-150 Red, 62" becomes "Road-150 Red"
> ```

> [!IMPORTANT]
> DISTINCT must be placed inside the CTE.
> 
> If we put it in the final query, we get an error because of the TOP 10 clause.

This led me to the following query and the final result shown below:

```sql
WITH ProductPriceDetails AS (
	SELECT
		DISTINCT LEFT(p.Name, ISNULL(NULLIF(CHARINDEX(',', p.Name), 0) - 1, LEN(p.Name))) AS ProductName,	-- Remove size/ variant information after the comma in product names
		psc.Name AS Subcategory,
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
```

On the left side are the Manufactured in-house products, and on the right side the Purchased ones.

![manufactured top 10](https://github.com/user-attachments/assets/9a114386-3827-4965-8886-b062b76e60ae) ![purhcased top 10](https://github.com/user-attachments/assets/c51e606d-3fb5-4601-b24d-79418a598f58)
