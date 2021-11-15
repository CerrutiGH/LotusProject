USE dbLotus;

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
$$ DELIMITER ;
/*varCustCPF, varCustName, varCustDtNasc, varCustGender, varCustTel, varCustEmail, varCustPassword, varCustNumberAddress, varCEPAddress, varCityname, varUF, varAddress*/
CALL spInsertCustomer(44687871801, "Gabriel Cerruti", '2003-02-25', "M", 11975466558, "bielhcsousa@gmail.com", "123321", 65, 05133160, "São Paulo", "SP" ,"Rua Carolina Guedes");
CALL spInsertCustomer(44687871822, "Gabriel Cerruti", '2003-02-25', "M", 11975466522, "bielhcsou22@gmail.com", "123322", 70, 05133122, "São Carlos", "SP" ,"Rua Homiranha");



DELIMITER $$
CREATE PROCEDURE spLoginUser(varEmailUser varchar(150), varPasswordUser varchar(18))
BEGIN
SELECT * FROM tbCustomer WHERE CustEmail = varEmailUser AND CustPassword = varPasswordUser;
END
$$ DELIMITER ;

CALL spLoginUser("bielhcsou22@gmail.com", "123322");