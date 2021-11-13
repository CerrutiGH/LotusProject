DROP DATABASE IF EXISTS dbLotus;
CREATE DATABASE IF NOT EXISTS dbLotus;

USE dbLotus;

CREATE TABLE IF NOT EXISTS tbUF(
UFCode int primary key auto_increment,
UF char(2) not null
);

CREATE TABLE IF NOT EXISTS tbCity(
CityCode int auto_increment primary key,
CityName varchar(100) not null,
UFCode int not null references tbUF(UFCode) on update cascade -- Verificado terceiro
);

CREATE TABLE IF NOT EXISTS tbAddress(
CEP varchar(10) primary key not null,
Address varchar(200) not null,
CityCode int not null references tbCity(CityCode) on update cascade -- Verificado segundo
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
IsDeleted char(3) not null default 'No',
CEPAddress varchar(10) not null references tbAddress(CEP) on update cascade -- Verificado primeiro
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
IsDeleted char(3) not null default 'No',
CEPAddress varchar(10) not null references tbAddress(CEP) on update cascade -- Verificado primeiro
);

CREATE TABLE IF NOT EXISTS tbPayment(
PayCode int primary key auto_increment,
PayOption varchar(20) not null unique,
PayDate datetime not null default current_timestamp,
PayValue decimal(8,2) not null,
IsDeleted char(3) not null default 'No',
CustCPF varchar(14) not null references tbCustomer(CustCPF) on update cascade
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
ResStatus char(3) not null, -- can(Canceled), occ(Occuring), pen(Pending), ans(Answered)
IsDeleted char(3) not null default 'No',
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
IsDeleted char(3) not null default 'No',
CatCode int not null references tbCategoryProd(CatCode) on update cascade
);

CREATE TABLE IF NOT EXISTS tbOrder(
OrdCode int primary key auto_increment,
OrdDate datetime not null default current_timestamp,
OrdTotalPrice decimal(8,2) not null,
IsDeleted char(3) not null default 'No',
CustCPF varchar(14) not null references tbCustomer(CustCPF) on update cascade
);

CREATE TABLE IF NOT EXISTS tbOrderItem(
OrdCode int not null references tbOrder(OrdCode) on update cascade,
ProdBarCode int not null references tbProduct(ProdBarCode) on update cascade,
ItemUnitaryPrice decimal(8,2) not null,
ItemAmount int not null,
ItemTotalPrice decimal(8,2) not null
);





Delimiter $$
CREATE PROCEDURE spInsertCustomer(varCustCPF varchar(14), varCustName varchar(150), varCustDtNasc datetime,
varCustGender char(1), varCustTel varchar(12), varCustEmail varchar(150), varCustPassword varchar(18), 
varCustNumberAddress integer, varCEPAddress varchar(10), varCityname varchar(100), varUF char(2), varAddress varchar(200))

BEGIN

IF NOT EXISTS (SELECT CEP FROM tbAddress WHERE CEP = varCEPAddress) THEN
			IF NOT EXISTS (SELECT CityCode FROM tbCity WHERE CityName = varCityname) THEN
						IF NOT EXISTS (SELECT UFCode FROM tbUF WHERE UF = varUF) THEN
										INSERT INTO tbUF (UF) VALUES (varUF);
						END IF;
						INSERT INTO tbCity (CityName, UFCode) VALUES (varCityName, (SELECT UFCode FROM tbUF WHERE UF = varUF));
			END IF;
            INSERT INTO tbAddress (CEP, Address, CityCode) VALUES (varCEPAddress, varAddress, (SELECT CityCode FROM tbCity WHERE CityName = varCityName));
END IF;

IF NOT EXISTS (SELECT CustCPF FROM tbCustomer WHERE CustCPF = varCustCPF) THEN
				INSERT INTO tbCustomer (CustCPF, CustName, CustDtNasc, CustGender, CustTel, CustEmail, CustPassword, CustNumberAddress, CEPAddress)
                VALUES (varCustCPF, varCustName, varCustDtNasc, varCustGender, varCustTel, varCustEmail, varCustPassword, varCustNumberAddress, varCEPAddress);
END IF;

END;
$$
DELIMITER ;


/*varCustCPF, varCustName, varCustDtNasc, varCustGender, varCustTel, varCustEmail, varCustPassword, varCustNumberAddress, varCEPAddress, varCityname, varUF, varAddress*/
CALL spInsertCustomer(44687871801, "Gabriel Cerruti", '2003-02-25', "M", 11975466558, "bielhcsousa@gmail.com", "123321", 65, 05133160, "São Paulo", "SP" ,"Rua Carolina Guedes");

CALL spInsertCustomer(44687871822, "Gabriel Cerruti", '2003-02-25', "M", 11975466522, "bielhcsou22@gmail.com", "123322", 70, 05133122, "São Carlos", "SP" ,"Rua Homiranha");
            
            
SELECT * FROM tbCustomer;
SELECT * FROM tbEmployee;
SELECT * FROM tbAddress;
SELECT * FROM tbCity;
SELECT * FROM tbUF;
SELECT * FROM tbReserve;
SELECT * FROM tbPayment;
SELECT * FROM tbPackage;
SELECT * FROM tbProduct;
SELECT * FROM tbOrder;
SELECT * FROM tbOrderItem;
SELECT * FROM tbCategoryProd;
SELECT * FROM tbRole;






 




