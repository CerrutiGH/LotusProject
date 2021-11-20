DROP DATABASE IF EXISTS dbLotus;
CREATE DATABASE IF NOT EXISTS dbLotus;

USE dbLotus;


CREATE TABLE IF NOT EXISTS tbCep(
CEP varchar(10) primary key not null
);


CREATE TABLE IF NOT EXISTS tbCustomer(
CustCPF varchar(14) primary key not null,
CustName varchar(150) not null,
CustDtNasc datetime not null,
CustGender char(1) not null,
CustTel varchar(12) not null unique,
CustEmail varchar(150) not null unique,
CustPassword varchar(18) not null,
CustNumberAddress int not null,
IsDeleted char(1) not null default 'N', -- N = No | Y = Yes
CEPAddress varchar(10) not null references tbCep(CEP) on update cascade -- Verificado primeiro
);

CREATE TABLE IF NOT EXISTS tbRole(
RoleCode int primary key auto_increment,
RoleName varchar(50) not null unique
);

CREATE TABLE IF NOT EXISTS tbEmployee(
EmpCPF varchar(14) primary key not null,
EmpName varchar(150) not null,
EmpLogin varchar(50) not null unique,
EmpDtNasc datetime not null,
EmpGender char(1) not null,
EmpTel varchar(12) not null unique,
EmpEmail varchar(150) not null unique,
EmpPassword varchar(18) not null,
EmpNumberAddress int not null,
EmpRole int not null references tbRole(RoleCode) on update cascade,
IsDeleted char(1) not null default 'N', -- N = No | Y = Yes
CEPAddress varchar(10) not null references tbAddress(CEP) on update cascade -- Verificado primeiro
);







CREATE TABLE IF NOT EXISTS tbPackage(
PackCode int primary key auto_increment,
PackPrice decimal(8,2) not null,
PackName varchar(150) not null,
PackDescription varchar(300) not null
);

CREATE TABLE IF NOT EXISTS tbReserve(
ResCode int primary key auto_increment,
ResValidity datetime not null,
ResPrice decimal(8,2) not null,
ResAmount int not null,
IsDeleted char(1) not null default 'N', -- N = No | Y = Yes
CustCPF varchar(14) not null references tbCustomer(CustCPF) on update cascade,
PackCode int not null references tbPackage(PackCode) on update cascade,
PayCode int not null references tbpayment(PayCode) on update cascade
);

CREATE TABLE IF NOT EXISTS tbCategoryProd(
CatCode int primary key auto_increment,
CatName varchar(100) not null
);

CREATE TABLE IF NOT EXISTS tbProduct(
ProdBarCode int primary key,
ProdName varchar(100) not null,
ProdPrice decimal(8,2) not null,
IsDeleted char(1) not null default 'N', -- N = No | Y = Yes
CatCode int not null references tbCategoryProd(CatCode) on update cascade
);


CREATE TABLE IF NOT EXISTS tbOrder(
OrdCode int primary key auto_increment,
OrdDate datetime not null default current_timestamp,
OrdTotalPrice decimal(8,2) not null default 0,
StatusOrder char(1) not null default 'U', -- U = Unfinished | F = Finished 
IsDeleted char(1) not null default 'N', -- N = No | Y = Yes
PayCode int null references tbpayment(PayCode) on update cascade,
CustCPF varchar(14) not null references tbCustomer(CustCPF) on update cascade
);


CREATE TABLE IF NOT EXISTS tbOrderItem(
OrdCode int not null references tbOrder(OrdCode) on update cascade,
ProdBarCode int not null references tbProduct(ProdBarCode) on update cascade,
ItemUnitaryPrice decimal(8,2) not null,
ItemAmount int not null,
ItemTotalPrice decimal(18,2) not null
);

CREATE TABLE IF NOT EXISTS tbOptionPay(
OpPayCode int primary key auto_increment,
PayOption varchar(20) not null unique
);


CREATE TABLE IF NOT EXISTS tbPayment(
PayCode int primary key auto_increment,
PayDate datetime not null default current_timestamp,
PayValue decimal(8,2) not null,
IsDeleted char(1) not null default 'N', -- N = No | Y = Yes
StatusPayment char(1) not null default 'U', -- U = Unfinished | F = Finished
OpPayCode varchar(20) not null references tbOptionPay(OpPayCode) on update cascade,
CustCPF varchar(14) not null references tbCustomer(CustCPF) on update cascade
);

  
SELECT * FROM tbCep;            -- Used     
SELECT * FROM tbRole;           -- Used 
SELECT * FROM tbCustomer;       -- Done
SELECT * FROM tbEmployee;       -- Done

SELECT * FROM tbCategoryProd;   -- Used
SELECT * FROM tbProduct;        -- Done

SELECT * FROM tbOptionPay;
SELECT * FROM tbPayment;
SELECT * FROM tbPackage;
SELECT * FROM tbReserve;

SELECT * FROM tbOrder;          -- 
SELECT * FROM tbOrderItem;      -- Done


