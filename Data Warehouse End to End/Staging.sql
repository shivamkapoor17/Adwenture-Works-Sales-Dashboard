

CREATE DATABASE AW_stg;
use AW_stg;

create schema hr;
CREATE schema person;
create schema sales;

CREATE TABLE [hr].[EmployeeDepartmentHistory](
	[BusinessEntityID] [int] NULL,
	[DepartmentID] [smallint] NULL,
	[ShiftID] [tinyint] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NULL,
	[DepartmentName] [nvarchar](50) NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
)

CREATE TABLE [hr].[Department](
	[DepartmentID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] nvarchar(50)  NULL,
	[GroupName] nvarchar(50)  NULL,
	[ModifiedDate] [datetime]  NULL
	);

create table hr.employee(
BusinessEnteityID int,
NationalIDNumber nvarchar(15),
LoginID nvarchar(256),
OrganizationNode hierarchyid,
OrganizationLevel smallint,
JobTitle nvarchar(50),
BirthDate date,
MaritalStatus nchar(1),
HireDate date,
SalariedFlag bit,
VacationHours smallint,
SickLeaveHours smallint,
CurrentFlag bit,
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int
)
alter table hr.employee
add Gender nvarchar(1)

select * from hr.employee

create table person.EmailAddress(
BusinessEntityID int,
EmailAddressID int,
EmailAddress nvarchar(50),
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)

create table person.Person(
BusinessEntityID int,
PersonType nvarchar(2),
NameStyle bit,
Title nvarchar(8),
FirstName nvarchar(50),
MiddleName nvarchar(50),
LastName nvarchar(50),
Suffix nvarchar(10),
EmailPromotion int,
AdditionalContactInfo nvarchar(max),
Demographics nvarchar(max),
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)

create table sales.Currency(
CurrencyCode nvarchar(3),
Name nvarchar(50),
--rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)

create table sales.Customer(
CustomerID int,
PersonID int,
StoreID int,
TerritoryID int,
AccountNumber nvarchar(10),
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)


create table sales.SalesPerson(
BusinessEntityID int,
TerritoryID int,
SalesQuota money,
Bonus money,
CommissionPct smallmoney,
SalesYTD money,
SalesLastYear money,
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)

create table sales.SalesTerritory(
TerritoryID int,
Name nvarchar(50),
CountryRegionCode nvarchar(3),
Groups nvarchar(50),
SalesYTD money,
SalesLastYear money,
CostYTD money,
CostLastYear money,
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)

create table sales.Store(
BusinessEntityID int,
Name nvarchar(50),
SalesPersonID int,
Demographics varchar(max),
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)

create table person.Address(
AddressID int,
AddressLine1 nvarchar(60),
AddreassLine2 nvarchar(60),
City nvarchar(30),
StateProvinceID int,
postalCode nvarchar(15),
SpatialLocation geography,
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)

create table person.AddressType(
AddressTypeID int,
Name nvarchar(50),
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)

create table person.BusinessEntityAddress(
BusinessEntityID int,
AddressID int,
AddressTypeID int,
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)

create schema production;

create table production.Product(
ProductID int,
Name nvarchar(50),
ProductNumber nvarchar(25),
MakeFlag bit,
FinishedGoodsFlag bit,
Color nvarchar(15),
SafetystockLevel smallint,
RecorderPoint smallint,
StandardCost money,
ListPrice money,
Size nvarchar(5),
SizeUnitMeasureCode nvarchar(3),
weightUnitMeasureCode nvarchar(3),
weight decimal(8,2),
DaysToManufacture int,
ProductLine nvarchar(2),
Class nvarchar(2),
Style nvarchar(2),
ProductSubcategoryID int,
ProductModalID int,
SellStartDate datetime,
SedllEndDate datetime,
DiscontinuedDate datetime,
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)

create table production.ProductCategory(
ProductCategoryID int,
Name nvarchar(50),
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)

create table production.ProductSubcategoty(
ProductSubcategoryID int,
ProductCategoryID int,
Name nvarchar(50),
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)


create table sales.SalesOrderDetail(
SalesOrderID int,
SalesOrderDetailID int,
CarrierTrackingNumber nvarchar(25),
OrderQty smallint,
ProdictID int,
SpecialOfferID int,
UnitPrice money,
UnitPriceDiscount money,
LineTotal numeric(38,6),
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)

create table sales.SalesOrderHeader(
SalesOrderID int,
RevisionNumber tinyint,
OrderDate datetime,
DueDate datetime,
shipDate datetime,
Status tinyint,
OnlineOrderFlag bit,
salesOrderNumber nvarchar(25),
PurchaseOrderNumber nvarchar(25),
AccountNumber nvarchar(15),
CustomerID int,
SalesPersonId int,
TerretoryID int,
BillToAddressID int,
ShipToAddressID int,
ShipMethodID int,
CreditCardID int,
CreditCardApprovalCode nvarchar(15),
CurrencyRateID int,
SubTotal money,
TaxAmt money,
Freight money,
TotalDue money,
Comment nvarchar(128),
rowguid uniqueidentifier,
ModifiedDate datetime,
Created_Dt datetime,
SSISTrackId int)



ALTER TABLE [sales].[Currency] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [hr].[employee] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [person].[Address] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [person].[AddressType] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [person].[BusinessEntityAddress] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [person].[EmailAddress] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [person].[Person] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [production].[Product] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [production].[ProductCategory] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [production].[ProductSubcategoty] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [sales].[Customer] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [sales].[SalesOrderDetail] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [sales].[SalesOrderHeader] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [sales].[SalesPerson] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [sales].[SalesTerritory] ADD  DEFAULT (getdate()) FOR [Created_Dt]
ALTER TABLE [sales].[Store] ADD  DEFAULT (getdate()) FOR [Created_Dt]