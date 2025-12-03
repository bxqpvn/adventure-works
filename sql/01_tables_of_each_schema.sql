
-- Purpose: Explore database schemas and list tables per functional area
/*Tables by functional area*/

-- Production
select name as [Production Tables]
from sys.tables
where schema_id = schema_id('Production')
order by name asc

-- Sales
select name as [Sales Tables]
from sys.tables
where schema_id = schema_id('Sales')
order by name asc

-- HR
select name as [HR Tables]
from sys.tables
where schema_id = schema_id('HumanResources')
order by name asc

-- Person
select name as [Person Tables]
from sys.tables
where schema_id = schema_id('Person')
order by name asc

-- Purchasing
select name as [Purchasing Tables]
from sys.tables
where schema_id = schema_id('Purchasing')
order by name asc
