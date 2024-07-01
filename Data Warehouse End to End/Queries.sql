

--Incremental Load Logisc
select MAX(OrderDate) as maxdate from sales.FactInternetSales

select d.* from sales.SalesOrderDetail d
join sales.SalesOrderHeader h on d.SalesOrderID = h.SalesOrderID
where h.OrderDate > '1-1-2014'

select * from sales.SalesOrderHeader 
where OrderDate > '1-1-2014'



-- product insert and scd code
-- DimCurrency insert 105
with cte as (
select CurrencyCode, Name from sales.Currency
)
select a.* from cte a left join AW_core.sales.DimCurrency b on a.CurrencyCode = b.AlternatecurrencyCode
where b.AlternateCurrencyCode is null;



--dim product insert 504

with cte as (
select p.ProductNumber, p.Name, coalesce(c.Name, 'other') as category, coalesce(sc.Name,'other') as subcategory, isnull(p.Color , 'NA') as Color, p.ListPrice, P.Size
from production.Product p left join production.ProductSubcategoty sc on p.ProductSubcategoryID = sc.ProductSubcategoryID
left join production.ProductCategory c on sc.ProductCategoryID = c.ProductCategoryID)

select cte.*, null [a.SizeRange], null [a.Status] from cte left join AW_core.sales.DimProduct a on cte.ProductNumber = a.AlternateProductKey
where a.AlternateProductKey is null;



-- DimTerritory insert 10

with cte as (
select TerritoryID, Name, CountryRegionCode, Groups
from sales.SalesTerritory
)
select cte.*
from cte left join AW_core.sales.DimRegion dim on cte.TerritoryID = dim.AlternateTerritoryKey
where dim.AlternateTerritoryKey is null

select * from AW_core.sales.DimRegion



-- DimReseller insert 701

with cte as (
select BusinessEntityID, Name
from sales.store
)
select cte.*, null [YearOpened], 0 [NumberEmployees]
from cte left join AW_core.sales.DimReseller dim on cte.BusinessEntityID = dim.ResellerAlternatekey
where dim.ResellerAlternatekey is null



-- dimcustomer insert 19844

with cte as(
select c.CustomerID, p.NameStyle, p.Title, p.FirstName, p.LastName, p.Suffix, ea.EmailAddress, a.AddressLine1, a.City, at1.Name as addresstype, '9999999999' [phone]
from sales.Customer c left join person.Person p on c.PersonID = p.BusinessEntityID
left join person.EmailAddress ea on p.BusinessEntityID = ea.BusinessEntityID
left join person.BusinessEntityAddress bea on p.BusinessEntityID = bea.BusinessEntityID
left join person.Address a on bea.AddressID = a.AddressID
left join person.AddressType at1 on bea.AddressTypeID = at1.AddressTypeID)

select cte.* from cte left join AW_core.sales.DimCustomer dim on cte.CustomerID = dim.CustomerAlternateKey
where dim.CustomerAlternateKey is null


-- dim employee insert-- 290

with cte as (
select e.NationalIDNumber, p.FirstName, p.LastName, e.JobTitle, e.Gender, ea.EmailAddress, 9999999999 [phone], e.MaritalStatus,
'xyz' [Department], e.HireDate, e.BirthDate, 0 [status]
from hr.employee e left join person.Person p on e.BusinessEnteityID = p.BusinessEntityID
left join person.EmailAddress ea on e.BusinessEnteityID = ea.BusinessEntityID
)
select cte.* 
from cte left join AW_core.sales.DimEmployee dim on cte.NationalIDNumber = dim.NationalIDNumber
where dim.NationalIDNumber is null



-- employee history--296

with cte as (
select e.NationalIDNumber, p.FirstName, p.LastName, e.JobTitle, e.Gender, ea.EmailAddress, 9999999999 [phone], e.MaritalStatus,
d.name, e.HireDate, e.BirthDate, 0 [status]
,dh.[StartDate],dh.[EndDate]
from hr.employee e left join person.Person p on e.BusinessEnteityID = p.BusinessEntityID
left join person.EmailAddress ea on e.BusinessEnteityID = ea.BusinessEntityID
left join [hr].[EmployeeDepartmentHistory] dh on e.BusinessEnteityID = dh.[BusinessEntityID]
left join [hr].[Department] d on dh.[DepartmentID] = d.[DepartmentID]
)
select cte.* 
from cte left join AW_core.sales.DimEmployee dim on cte.NationalIDNumber = dim.NationalIDNumber
where dim.NationalIDNumber is null



-- dim date insert
use AW_stg;
Create Procedure [dbo].[Refresh_DimDate]
as
Begin

declare @startdate date = '2005-01-01',
    @enddate date = '2014-12-31'

IF @startdate IS NULL
    BEGIN
        Select Top 1 @startdate = FulldateAlternateKey
        From AW_core.sales.DimDate 
        Order By DateKey ASC 
    END

Declare @datelist table (FullDate date)

while @startdate <= @enddate

Begin 
    Insert into @datelist (FullDate)
    Select @startdate

    Set @startdate = dateadd(dd,1,@startdate)

end 

 Insert into AW_core.sales.DimDate 
    (DateKey, 
        FullDateAlternateKey, 
        DayNumberOfWeek, 
        EnglishDayNameOfWeek, 
      
        DayNumberOfMonth, 
        DayNumberOfYear, 
        WeekNumberOfYear, 
        EnglishMonthName, 
     
        MonthNumberOfYear, 
        CalendarQuarter, 
        CalendarYear, 
        CalendarSemester, 
        FiscalQuarter, 
        FiscalYear, 
        FiscalSemester)


select convert(int,convert(varchar,dl.FullDate,112)) as DateKey,
    dl.FullDate,
    datepart(dw,dl.FullDate) as DayNumberOfWeek,
    datename(weekday,dl.FullDate) as EnglishDayNameOfWeek,
    
    
    datepart(d,dl.FullDate) as DayNumberOfMonth,
    datepart(dy,dl.FullDate) as DayNumberOfYear,
    datepart(wk, dl.FUllDate) as WeekNumberOfYear,
    datename(MONTH,dl.FullDate) as EnglishMonthName,
   
   
    Month(dl.FullDate) as MonthNumberOfYear,
    datepart(qq, dl.FullDate) as CalendarQuarter,
    year(dl.FullDate) as CalendarYear,
    case datepart(qq, dl.FullDate)
        when 1 then 1
        when 2 then 1
        when 3 then 2
        when 4 then 2
    end as CalendarSemester,
    case datepart(qq, dl.FullDate)
        when 1 then 3
        when 2 then 4
        when 3 then 1
        when 4 then 2
    end as FiscalQuarter,
    case datepart(qq, dl.FullDate)
        when 1 then year(dl.FullDate)
        when 2 then year(dl.FullDate)
        when 3 then year(dl.FullDate) + 1
        when 4 then year(dl.FullDate) + 1
    end as FiscalYear,
    case datepart(qq, dl.FullDate)
        when 1 then 2
        when 2 then 2
        when 3 then 1
        when 4 then 1
    end as FiscalSemester

from @datelist dl left join 
    AW_core.sales.DimDate dd 
        on dl.FullDate = dd.FullDateAlternateKey
Where dd.FullDateAlternateKey is null 

End


-- scd2 code for dim employee
create view stg
as
select * from (select e.NationalIDNumber, p.FirstName, p.LastName, e.JobTitle, e.Gender, ea.EmailAddress, 9999999999 [phone], e.MaritalStatus,
d.name as dept, e.HireDate, e.BirthDate, 0 [status]
,dh.[StartDate],dh.[EndDate]
from hr.employee e left join person.Person p on e.BusinessEnteityID = p.BusinessEntityID
left join person.EmailAddress ea on e.BusinessEnteityID = ea.BusinessEntityID
left join [hr].[EmployeeDepartmentHistory] dh on e.BusinessEnteityID = dh.[BusinessEntityID]
left join [hr].[Department] d on dh.[DepartmentID] = d.[DepartmentID]
) as a
where a.EndDate is null
drop view stg


create procedure dbo.[employee_refresh]
as
begin

create table #merge_output(
action NVARCHAR(10),
[NationalIDNumber] nvarchar(15),
[FirstName] nvarchar(50),
[LastName] nvarchar(50),
[JobTitle] nvarchar(50),
[Gender] nvarchar(1),
[EmailAddress] nvarchar(50),
[Phone] nvarchar(25),
[MaritialStatus] nchar(1),
[Department] nvarchar(100),
[BirthDate] date,
[HireDate] date,
[Status] nvarchar(50),
[StartDate] datetime,
[EndDate] datetime
)



merge AW_core.[sales].[DimEmployee] as target
using [dbo].[stg] as source
on target.[NationalIDNumber] = source.[NationalIDNumber] and target.[EndDate] is null

when matched and target.[Department] <> source.[name] then
update set
target.[EndDate] = getdate()
output
$action, source.[NationalIDNumber], source.[FirstName], source.[LastName], source.[JobTitle], source.[Gender], source.[EmailAddress],
source.[phone], source.[MaritalStatus], source.[name], source.[BirthDate], source.[HireDate], source.[status], GETDATE(), 
null
into #merge_output (action, [NationalIDNumber], [FirstName], [LastName], [JobTitle], [Gender], [EmailAddress], [Phone], [MaritialStatus], [Department],
[BirthDate], [HireDate], [Status], [StartDate], [EndDate]);


insert into AW_core.sales.DimEmployee([NationalIDNumber], [FirstName], [LastName], [JobTitle], [Gender], [EmailAddress], [Phone], [MaritialStatus], [Department],
[BirthDate], [HireDate], [Status], [StartDate], [EndDate])
select
[NationalIDNumber], [FirstName], [LastName], [JobTitle], [Gender], [EmailAddress], [Phone], [MaritialStatus], [Department],
[BirthDate], [HireDate], [Status], [StartDate], [EndDate]
from #merge_output
where action = 'Update';

DROP TABLE #merge_output;

end


--Helper Code
alter table person.Address
add SpatialLocationn varchar(max)
alter table sales.DimProduct
alter column [AlternateProductKey] nvarchar(25)

ALTER TABLE person.Address
DROP COLUMN SpatialLocation;

alter table [sales].[DimEmployee]
add [StartDate] [date] NULL,
[EndDate] [date] NULL

select * from person.Address

update person.Address
set SpatialLocationn = SpatialLocation.STAsText();

ALTER TABLE AW_core.sales.DimEmployee
ALTER COLUMN StartDate datetime;

ALTER TABLE AW_core.sales.DimEmployee
ALTER COLUMN EndDate datetime;

ALTER TABLE [hr].[EmployeeDepartmentHistory]
ALTER COLUMN StartDate datetime;

ALTER TABLE [hr].[EmployeeDepartmentHistory]
ALTER COLUMN EndDate datetime;


