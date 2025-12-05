Use AdventureWorks2022

-- Sales order general info
select top 20 *
from Sales.SalesOrderHeader
order by OrderDate desc;

-- Credit card info
select top 20 *
from Sales.CreditCard
order by ExpYear desc;

-- Order details: tracking number, quantity, selling and unit price, subtotal, dicounts
select top 20 *
from Sales.SalesOrderDetail

select top 20 *
from Sales.SpecialOfferProduct

select top 20 *
from Sales.SpecialOffer;


-- Currency exchange rate, standard ISO currencies
select top 20 *
from Sales.CurrencyRate;

select top 20 *
from Sales.CountryRegionCurrency;

select top 20 *
from Sales.Currency;


-- Person, customer, store info
select top 20 *
from Sales.SalesPerson;

select top 20 *
from Sales.Customer;

select top 20 *
from Sales.Store;

-- Sales territories
select *
from Sales.SalesTerritory;
