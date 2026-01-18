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
