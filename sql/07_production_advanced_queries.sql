use AdventureWorks2022

/* Product name, category and subcategory  */
select
	p.ProductID,
	p.Name as ProductName,
	c.Name as Category,
	sc.Name as Subcategory
from Production.Product p
left join Production.ProductSubcategory sc
	on p.ProductSubcategoryID = sc.ProductSubcategoryID
left join Production.ProductCategory c
	on sc.ProductCategoryID = c.ProductCategoryID
-- where c.name is not null
