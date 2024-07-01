
CREATE DATABASE AW_core;
use AW_core;

create schema sales



create table sales.DimEmployee(
EmployeeKey int PRIMARY KEY identity(1,1) not null,
NationalIDNumber nvarchar(15),
FirstName nvarchar(50),
LastName nvarchar(50),
JobTitle nvarchar(50),
Gender nvarchar(1),
EmailAddress nvarchar(50),
Phone nvarchar(25),
MaritialStatus nchar(1),
Department nvarchar(100),
BirthDate date,
HireDate date,
Status nvarchar(50))


create table sales.DimRegion(
TerritoryKey int PRIMARY KEY identity(1,1),
AlternateTerritoryKey int,
Region nvarchar(50),
CountryRegionCode nvarchar(3),
regionGroup nvarchar(50)
)

create table sales.DimReseller(
ResellerKey int PRIMARY KEY identity(1,1),
ResellerAlternatekey int,
ResellerName nvarchar(50),
YearOpened int,
NumberEmployees int
)

create table sales.DimProduct(
Productkey int PRIMARY KEY identity(1,1),
AlternateProductKey int,
ProductName nvarchar(50),
Color nvarchar(15),
Price money,
Size nvarchar(5),
SizeRange nvarchar(50),
ProductCategory nvarchar(50),
ProductSubCategory nvarchar(50),
Status nvarchar(7)
)

create table sales.DimCustomer(
CustomerKey int PRIMARY KEY identity(1,1),
CustomerAlternateKey int,
NameStyle bit,
Title nvarchar(8),
FirstName nvarchar(50),
LastName nvarchar(50),
Suffix nvarchar(10),
EmailAddress nvarchar(256),
Address nvarchar(120),
City nvarchar(50),
Phone nvarchar(50),
AddressType nvarchar(50)
)

create table sales.DimCurrency(
CurrencyKey int PRIMARY KEY identity(1,1),
AlternateCurrencyCode nvarchar(3),
CurrencyName nvarchar(50))

create table sales.DimDate(
	[DateKey] [int] PRIMARY KEY NOT NULL,
	[FullDateAlternateKey] [date] NOT NULL,
	[DayNumberOfWeek] [tinyint] NOT NULL,
	[EnglishDayNameOfWeek] [nvarchar](10) NOT NULL,
	[DayNumberOfMonth] [tinyint] NOT NULL,
	[DayNumberOfYear] [smallint] NOT NULL,
	[WeekNumberOfYear] [tinyint] NOT NULL,
	[EnglishMonthName] [nvarchar](10) NOT NULL,
	[MonthNumberOfYear] [tinyint] NOT NULL,
	[CalendarQuarter] [tinyint] NOT NULL,
	[CalendarYear] [smallint] NOT NULL,
	[CalendarSemester] [tinyint] NOT NULL,
	[FiscalQuarter] [tinyint] NOT NULL,
	[FiscalYear] [smallint] NOT NULL,
	[FiscalSemester] [tinyint] NOT NULL,
	)

	create table sales.FactInternetSales(
	OrderNumber int,
	LineNumber int,
	ProductKey int,
	OrderDateKey int,
	DueDateKey int,
	ShipDateKey int,
	CustomerKey int,
	CurrencyKey int,
	RegionKey int,
	OrderQuantity smallint,
	UnitPrice money,
	DiscountAmt money,
	LineTotal numeric(38,6),
	SalesAmt money,
	Freight money,
	OrderDate datetime,
	Duedate datetime,
	ShipDate datetime
	FOREIGN KEY (ProductKey) REFERENCES sales.DimProduct(ProductKey),
	foreign key (OrderDateKey) references sales.DimDate(DateKey),
	foreign key (DueDateKey) references sales.DimDate(DateKey),
	foreign key (ShipdateKey) references sales.DimDate(DateKey),
	foreign key (CustomerKey) references sales.DimCustomer(CustomerKey),
	foreign key (CurrencyKey) references sales.DimCurrency(CurrencyKey),
	foreign key (RegionKey) references sales.DimRegion(TerritoryKey)
	)

	create table sales.FactResellerSales(
	OrderNumber int,
	LineNumber int,
	ProductKey int,
	OrderDateKey int,
	DueDateKey int,
	ShipDateKey int,
	EmployeeKey int,
	CustomerKey int,
	ResellerKey int,
	CurrencyKey int,
	RegionKey int,
	OrderQuantity smallint,
	UnitPrice money,
	DiscountAmt money,
	LineTotal numeric(38,6),
	SalesAmt money,
	Freight money,
	OrderDate datetime,
	Duedate datetime,
	ShipDate datetime
	FOREIGN KEY (ProductKey) REFERENCES sales.DimProduct(ProductKey),
	foreign key (OrderDateKey) references sales.DimDate(DateKey),
	foreign key (DueDateKey) references sales.DimDate(DateKey),
	foreign key (ShipdateKey) references sales.DimDate(DateKey),
	foreign key (CustomerKey) references sales.DimCustomer(CustomerKey),
	foreign key (CurrencyKey) references sales.DimCurrency(CurrencyKey),
	foreign key (RegionKey) references sales.DimRegion(TerritoryKey),
	foreign key (ResellerKey) references sales.DimReseller(ResellerKey),
	foreign key (EmployeeKey) references sales.DimEmployee(EmployeeKey))


	alter table sales.Customer
	alter column AccountNumber varchar(10)
	select max([FullDateAlternateKey]) as maxdate from sales.DimDate


