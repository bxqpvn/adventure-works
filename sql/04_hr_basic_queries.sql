Use AdventureWorks2022

-- Employee general info
select top 20 *
from HumanResources.Employee;

-- Employee pay history
select top 20 *
from HumanResources.EmployeePayHistory;

-- Resumes table/ job applicants
select top 20 *
from HumanResources.JobCandidate;

-- Employee departments, transfers, work shift
select top 20 *
from HumanResources.EmployeeDepartmentHistory;

select *
from HumanResources.Department;

select name, StartTime, EndTime
from HumanResources.Shift;
