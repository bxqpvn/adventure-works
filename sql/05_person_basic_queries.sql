Use AdventureWorks2022

-- AdventureWorks persons: employees, customers, vendors
select top 20 *
from Person.Person;

/*Person details*/

-- Email adress
select top 20 *
from Person.EmailAddress;

-- Passwords
select top 20 *
from Person.Password;

-- Phone number, number type
select *
from Person.PersonPhone;
select *
from Person.PhoneNumberType;


-- Location info
select top 20 *
from Person.Address;

select top 20 *
from Person.StateProvince;

select top 20 *
from Person.CountryRegion;

-- BusinessEntity ID
select top 20 *
from Person.BusinessEntity;

-- Business Entity address and contact
select top 20 *								-- address
from Person.BusinessEntityAddress;

select
	AddressTypeID,
	Name
from Person.AddressType;

select top 20								-- contact
	BusinessEntityID,
	PersonID,
	ContactTypeID
from Person.BusinessEntityContact;

select *
from Person.ContactType;
