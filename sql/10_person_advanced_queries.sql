--==============================================================================================================================================  

/* Customer Profile Overview */

WITH CustomerNames AS (
    SELECT
        BusinessEntityID,
        CASE                       -- Format full name and identify if a middle name exists
            WHEN MiddleName IS NOT NULL 
                THEN CONCAT(FirstName, ' ', MiddleName, ' ', LastName)
            ELSE CONCAT(FirstName, ' ', LastName)
        END AS FullName,
        CASE
            WHEN MiddleName IS NULL THEN 'NO'
            ELSE 'YES'
        END AS HasMiddleName,
        PersonType
    FROM Person.Person
),

CustomerContactInfo AS (
    SELECT                          -- Attach contact details (email and phone number)
        cn.BusinessEntityID,
        cn.FullName,
        cn.HasMiddleName,
        cn.PersonType,
        pp.PhoneNumber,
        ea.EmailAddress
    FROM CustomerNames cn
    LEFT JOIN Person.EmailAddress ea        -- LEFT JOIN is used because not all customers have email or phone records
        ON cn.BusinessEntityID = ea.BusinessEntityID
    LEFT JOIN Person.PersonPhone pp
        ON cn.BusinessEntityID = pp.BusinessEntityID
),

CustomerLocation AS (
    SELECT                      -- Add geographic information
        cci.BusinessEntityID,
        cci.FullName,
        cci.HasMiddleName,
        cci.PersonType,
        cci.PhoneNumber,
        cci.EmailAddress,
        cr.Name AS Country,
        sp.Name AS State,
        a.City
    FROM CustomerContactInfo cci
    LEFT JOIN Person.BusinessEntityAddress bea
        ON cci.BusinessEntityID = bea.BusinessEntityID
    LEFT JOIN Person.Address a
        ON bea.AddressID = a.AddressID
    LEFT JOIN Person.StateProvince sp
        ON a.StateProvinceID = sp.StateProvinceID
    LEFT JOIN Person.CountryRegion cr
        ON sp.CountryRegionCode = cr.CountryRegionCode
)
SELECT                  -- Final query: customer profiles with name, contact, and location details
    FullName,
    HasMiddleName,
    PhoneNumber,
    EmailAddress,
    Country,
    State,
    City
FROM CustomerLocation
WHERE PersonType = 'IN';   -- filter to individual customers only

--==============================================================================================================================================

/* Top 5 Customers by Number of Orders */

WITH CustomerOrders AS (
    SELECT
        SalesOrderID,
        c.CustomerID,
        CASE                            -- Format full name
            WHEN MiddleName IS NOT NULL 
                THEN CONCAT(FirstName, ' ', MiddleName, ' ', LastName)
            ELSE CONCAT(FirstName, ' ', LastName)
        END AS FullName
    FROM Sales.SalesOrderHeader soh
    LEFT JOIN Sales.Customer c
        ON soh.CustomerID = c.CustomerID   -- Join Customer table to link sales to people
    LEFT JOIN Person.Person p
        ON c.PersonID = p.BusinessEntityID -- Join Person table to retrieve customer names
)
SELECT TOP 5
    FullName AS CustomerName,
    COUNT(DISTINCT SalesOrderID) AS OrderCount  -- Count the number of orders per customer
FROM CustomerOrders
GROUP BY FullName        -- Group results by customer
ORDER BY OrderCount DESC;

--==============================================================================================================================================
