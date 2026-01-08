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
