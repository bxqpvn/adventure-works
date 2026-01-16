--==============================================================================================================================================

/* Employee Age and Tenure Analysis */

WITH CleanNames AS (
    SELECT 
        RIGHT(LoginID, LEN(LoginID) - CHARINDEX('\', LoginID)) AS RawName,  -- Extract employee name from LoginID by keeping the part after the domain separator '\'
        JobTitle,
        BirthDate,
        HireDate
    FROM HumanResources.Employee
),
TrimmedNames AS (
    SELECT
        CASE 
            WHEN PATINDEX('%[0-9]%', REVERSE(RawName)) = 1     -- Remove trailing numeric characters from employee names (name1 → name)
            THEN LEFT(RawName, LEN(RawName) - 1)
            ELSE RawName
        END AS NameOnly,
        JobTitle,
        BirthDate,
        HireDate
    FROM CleanNames
)
SELECT
    UPPER(LEFT(NameOnly, 1)) + LOWER(SUBSTRING(NameOnly, 2, LEN(NameOnly))) AS EmployeeName,  -- Format employee name with proper capitalization
    JobTitle,
    DATEDIFF(year, BirthDate, CURRENT_TIMESTAMP) AS Age,                                      -- Calculate employee age based on birth date
    DATEDIFF(year, HireDate, CURRENT_TIMESTAMP) AS YearsInCompany                             -- Calculate number of years spent in the company
FROM TrimmedNames
ORDER BY YearsInCompany DESC;        -- Display employees ordered by tenure, from most experienced to least

--==============================================================================================================================================

/* Vacation Hours and Employee Count By Department */

SELECT
    d.GroupName,
    d.Name AS DepartmentName,
    SUM(e.VacationHours) AS TotalVacationHours,         -- Total vacation hours per department
    COUNT(DISTINCT e.BusinessEntityID) AS EmployeeCount -- Number of employees per department
FROM HumanResources.Employee e
LEFT JOIN HumanResources.EmployeeDepartmentHistory edh
    ON e.BusinessEntityID = edh.BusinessEntityID   -- Link employees to their department history
LEFT JOIN HumanResources.Department d
    ON edh.DepartmentID = d.DepartmentID           -- Get department name and group name
WHERE edh.EndDate IS NULL                          -- Use only current department
GROUP BY
    d.GroupName,
    d.Name
ORDER BY TotalVacationHours DESC;                  -- Departments with most vacation hours first

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
