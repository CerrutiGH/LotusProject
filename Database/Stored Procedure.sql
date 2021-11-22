
DROP PROCEDURE IF EXISTS spInsertCustomer;
Delimiter $$
CREATE PROCEDURE spInsertCustomer(varCustCPF varchar(14), varCustName varchar(150), varCustDtNasc datetime,
varCustGender char(1), varCustTel varchar(14), varCustEmail varchar(150), varCustPassword varchar(18), 
varCustNumberAddress integer, varCEP varchar(10))
BEGIN

IF NOT EXISTS (SELECT CEP FROM tbCep WHERE CEP = varCEP) THEN
            INSERT INTO tbCep (CEP) VALUES (varCEP);
END IF;

IF NOT EXISTS (SELECT CustCPF FROM tbCustomer WHERE CustCPF = varCustCPF) THEN
				INSERT INTO tbCustomer (CustCPF, CustName, CustDtNasc, CustGender, CustTel, CustEmail, CustPassword, CustNumberAddress, CEPAddress)
                VALUES (varCustCPF, varCustName, varCustDtNasc, varCustGender, varCustTel, varCustEmail, varCustPassword, varCustNumberAddress, (SELECT CEP FROM tbCep WHERE CEP = varCEP));
END IF;

END; 
$$ DELIMITER ;




DELIMITER $$
CREATE PROCEDURE spLoginUser(varEmailUser varchar(150), varPasswordUser varchar(18))
BEGIN
SELECT * FROM tbCustomer WHERE CustEmail = varEmailUser AND CustPassword = varPasswordUser AND IsDeleted = 'No';
END
$$ DELIMITER ;


DELIMITER $$
CREATE PROCEDURE spSelectEmail(varEmailUser varchar(150))
BEGIN
SELECT CustEmail FROM tbCustomer WHERE CustEmail = varEmailUser;
END
$$ DELIMITER ;




DROP PROCEDURE IF EXISTS spInsertEmployee;

Delimiter $$
CREATE PROCEDURE spInsertEmployee(varEmpCPF varchar(14), varEmpName varchar(150), varEmpLogin varchar(50), varEmpDtNasc datetime,
varEmpGender char(1), varEmpTel varchar(14), varEmpEmail varchar(150), varEmpPassword varchar(18), 
varEmpNumberAddress integer, varCEP varchar(10), varRoleName varchar(50))
BEGIN

IF NOT EXISTS (SELECT CEP FROM tbCep WHERE CEP = varCEP) THEN
            INSERT INTO tbCep (CEP) VALUES (varCEP);
END IF;


IF NOT EXISTS (SELECT EmpLogin FROM tbEmployee WHERE EmpLogin = varEmpLogin) THEN

				IF NOT EXISTS (SELECT EmpCPF FROM tbEmployee WHERE EmpCPF = varEmpCPF) THEN
                
								IF NOT EXISTS (SELECT EmpTel FROM tbEmployee WHERE EmpTel = varEmpTel) THEN
											IF NOT EXISTS (SELECT EmpEmail FROM tbEmployee WHERE EmpEmail = varEmpEmail) THEN
																IF NOT EXISTS (SELECT RoleCode FROM tbrole WHERE RoleName = varRoleName) THEN 
																		INSERT INTO tbRole (RoleName) VALUES (varRoleName);
																END IF; -- End RoleCode
                                
														INSERT INTO tbEmployee (EmpCPF, EmpName, EmpLogin, EmpDtNasc, EmpGender, EmpTel, EmpEmail, EmpPassword, EmpNumberAddress, EmpRole, CEPAddress)
														VALUES (varEmpCPF, varEmpName, varEmpLogin, varEmpDtNasc, varEmpGender, varEmpTel, varEmpEmail, varEmpPassword, varEmpNumberAddress, (SELECT RoleCode FROM tbrole WHERE RoleName = varRoleName), (SELECT CEP FROM tbCep WHERE CEP = varCEP));
                                            END IF; -- End EmpEmail
								END IF; -- End EmpTel
                END IF; -- End EmpCPF
END IF; -- End EmpLogin

END; 
$$ DELIMITER ;








DELIMITER $$
CREATE PROCEDURE spInsertProduct (varProdBarCode int, varProdName varchar(100), varProdPrice decimal(8,2), varCatName varchar(100))
BEGIN
IF NOT EXISTS (SELECT ProdBarCode FROM tbproduct WHERE ProdBarCode = varProdBarCode) THEN
				IF NOT EXISTS (SELECT CatName FROM tbcategoryprod WHERE CatName = varCatName) THEN
								INSERT INTO tbcategoryprod (CatName) VALUES (varCatName);
				END IF;
                
                INSERT INTO tbProduct (ProdBarCode, ProdName, ProdPrice, CatCode) VALUES (varProdBarCode, varProdName, varProdPrice, (SELECT CatCode FROM tbCategoryProd WHERE CatName = varCatName));
END IF;
END; 
$$ DELIMITER ;





DROP PROCEDURE IF EXISTS spInsertOrderItem;
DELIMITER $$
CREATE PROCEDURE spInsertOrderItem (varProdBarCode int, varItemAmount int, varCustCPF varchar(14))
BEGIN
IF NOT EXISTS (SELECT OrdCode FROM tborder WHERE CustCPF = varCustCPF AND StatusOrder = 'U') THEN
				INSERT INTO tborder (CustCPF) VALUES (varCustCPF);
        END IF;
IF NOT EXISTS (SELECT varProdBarCode FROM tbOrderItem WHERE OrdCode = (SELECT OrdCode FROM tborder WHERE CustCPF = varCustCPF AND StatusOrder = 'U') AND ProdBarCode = varProdBarCode) THEN
		
				INSERT INTO tbOrderItem (OrdCode, ProdBarCode, ItemUnitaryPrice, ItemAmount, ItemTotalPrice)
                VALUES ((SELECT OrdCode FROM tborder WHERE CustCPF = varCustCPF AND StatusOrder = 'U'), varProdBarCode, (SELECT ProdPrice FROM tbproduct WHERE ProdBarCode = varProdBarCode), varItemAmount, (SELECT ProdPrice FROM tbproduct WHERE ProdBarCode = varProdBarCode));
                
                UPDATE tbOrderItem SET ItemTotalPrice = (varItemAmount * ItemUnitaryPrice) WHERE OrdCode = (SELECT OrdCode FROM tborder WHERE CustCPF = varCustCPF AND StatusOrder = 'U') AND ProdBarCode = varProdBarCode;
ELSE

UPDATE tbOrderItem SET ItemAmount =  varItemAmount WHERE OrdCode = (SELECT OrdCode FROM tborder WHERE CustCPF = varCustCPF AND StatusOrder = 'U') AND ProdBarCode = varProdBarCode;
UPDATE tbOrderItem SET ItemTotalPrice = (varItemAmount * ItemUnitaryPrice) WHERE OrdCode = (SELECT OrdCode FROM tborder WHERE CustCPF = varCustCPF AND StatusOrder = 'U') AND ProdBarCode = varProdBarCode;
END IF;
END; 
$$ DELIMITER ;



DROP PROCEDURE IF EXISTS spFinishOrder;
DELIMITER $$
CREATE PROCEDURE spFinishOrder(varPayOption varchar(20), varCustCPF varchar(14))
BEGIN
IF NOT EXISTS (SELECT OpPayCode FROM tbOptionPay WHERE PayOption = varPayOption) THEN
				INSERT INTO tbOptionPay (PayOption) VALUES (varPayOption);
END IF;
IF EXISTS (SELECT PayCode FROM tbOrder WHERE StatusOrder = 'U' AND CustCPF = varCustCPF) THEN
				INSERT INTO tbpayment (PayValue, OpPayCode, CustCPF) VALUES ((SELECT SUM(ItemTotalPrice) FROM tbOrderItem WHERE OrdCode = (SELECT OrdCode FROM tbOrder WHERE CustCPF = varCustCPF AND StatusOrder = 'U')), (SELECT OpPayCode FROM tbOptionPay WHERE PayOption = varPayOption), varCustCPF);
END IF;

UPDATE tbOrder SET OrdTotalPrice = (SELECT PayValue FROM tbpayment WHERE CustCPF = varCustCPF AND StatusPayment = 'U'), StatusOrder = 'F', PayCode = (SELECT PayCode FROM tbpayment WHERE CustCPF = varCustCPF AND StatusPayment = 'U') WHERE CustCPF = varCustCPF AND StatusOrder = 'U';
Update tbpayment SET StatusPayment = 'F' WHERE CustCPF = varCustCPF AND StatusPayment = 'U';
END; 
$$ DELIMITER ;



DELIMITER $$
CREATE PROCEDURE spDeleteProductOrderItem(varCustCPF varchar(14), varProdBarCode int)
BEGIN
DELETE FROM tbOrderItem WHERE OrdCode = (SELECT OrdCode FROM tbOrder WHERE CustCPF = varCustCPF AND StatusOrder = 'U') AND ProdBarCode = varProdBarCode;
END
$$ DELIMITER ;




DELIMITER $$
CREATE PROCEDURE spViewOrdersByCPF (varCustCPF varchar(14))
BEGIN
select * From vwAllOrders WHERE CustCPF = varCustCPF;
END; 
$$ DELIMITER ;

DROP PROCEDURE IF EXISTS spInsertPackage;
DELIMITER $$
CREATE PROCEDURE spInsertPackage (varPackPrice decimal(8,2), varPackName varchar(150), varPackDescription varchar(300))
BEGIN
INSERT INTO tbpackage (PackPrice, PackName, PackDescription)
VALUES(varPackPrice, varPackName, varPackDescription);
END; 
$$ DELIMITER ;




DELIMITER $$
CREATE PROCEDURE spReserve (varResAmount int, varCustCPF varchar(14), varPackName varchar(150))
BEGIN
IF NOT EXISTS (SELECT ResCode FROM tbreserve WHERE CustCPF = varCustCPF AND StatusReserve = 'U') THEN
INSERT INTO tbreserve (ResPrice,ResAmount, CustCPF, PackCode)
VALUES ((SELECT PackPrice FROM tbPackage WHERE PackName = varPackName AND StatusPack = 'A') * varResAmount,varResAmount, varCustCPF, (SELECT PackCode FROM tbPackage WHERE PackName = varPackName AND StatusPack = 'A'));
ELSE 
UPDATE tbreserve SET ResPrice = (SELECT PackPrice FROM tbPackage WHERE PackName = varPackName AND StatusPack = 'A'), ResAmount = varResAmount, PackCode = (SELECT PackCode FROM tbPackage WHERE PackName = varPackName AND StatusPack = 'A') WHERE CustCPF = varCustCPF AND StatusReserve = 'U';
END IF;
END; 
$$ DELIMITER ;



DELIMITER $$
CREATE PROCEDURE spFinishReserve (varPayOption varchar(20), varCustCPF varchar(14))
BEGIN
IF NOT EXISTS (SELECT OpPayCode FROM tbOptionPay WHERE PayOption = varPayOption) THEN
				INSERT INTO tbOptionPay (PayOption) VALUES (varPayOption);
END IF;

IF EXISTS (SELECT PayCode FROM tbreserve WHERE CustCPF = varCustCPF AND StatusReserve = 'U') THEN
INSERT INTO tbpayment (PayValue, OpPayCode, CustCPF) VALUES ((SELECT ResPrice FROM tbReserve WHERE CustCPF = varCustCPF AND StatusReserve = 'U'), (SELECT OpPayCode FROM tbOptionPay WHERE PayOption = varPayOption), varCustCPF);
END IF;
UPDATE tbreserve SET StatusReserve = 'F', PayCode = (SELECT PayCode FROM tbpayment WHERE CustCPF = varCustCPF AND StatusPayment = 'U') WHERE CustCPF = varCustCPF AND StatusReserve = 'U';
UPDATE tbpayment SET StatusPayment = 'F' WHERE CustCPF = varCustCPF AND StatusPayment = 'U';
END; 
$$ DELIMITER ;


/*CALL PROCEDURES*/


/* Insert Customer */
CALL spInsertCustomer(44687871801, "Gabriel Cerruti", '2003-02-25', "M", 11975466558, "bielhcsousa@gmail.com", "123321", 65, 05133160);
CALL spInsertCustomer(44687871822, "Gabriel Cerruti", '2003-02-25', "M", 11975466522, "bielhcsou22@gmail.com", "123322", 70, 05133122);
CALL spInsertCustomer(45665465444, "Fernanda Rocha", '2003-02-25', "F", 11975465522, "fefes@gmail.com", "123322", 70, 05133122);


CALL spLoginUser("bielhcsou22@gmail.com", "123322");

/* Insert Employee */
CALL spInsertEmployee("44697971801", "Gabriel Cerruti", "Cerriti", '2003-02-25', "m", "1197546558", "bielhousa@gmail.com", "123321", 12, "02522-100", "Gerente");

/* Insert Products */
CALL spInsertProduct (123654656, "Celular", 50.63, "Eletronico");
CALL spInsertProduct (123600006, "Bob esponja", 70.00, "Brinquedo");
CALL spInsertProduct (123609999, "Mickey", 70.00, "Brinquedo");
CALL spInsertProduct (123607999, "Mickey mouse", 70.00, "Pelucia");
CALL spInsertProduct (555555555, "Mickey mouse", 70.00, "Pelucia");

/* Add product in cart */
CALL spInsertOrderItem (123609999, 4, 45665465444);
CALL spInsertOrderItem (123600006, 4, 45665465444);
CALL spInsertOrderItem (123607999, 3, 45665465444);
CALL spInsertOrderItem (555555555, 3, 45665465444);

/* Finish Order and close payment */
CALL spFinishOrder ("Crédito", 45665465444);

/* Insert Package*/
CALL spInsertPackage(50.67, "Sonho Feliz", "Esta é a descrição :)");

/* Make reserve */
CALL spReserve(4, 44687871801, 'Sonho Feliz');
CALL spReserve(3, 45665465444, 'Sonho Feliz');

/*Finish Reserve and close payment*/
CALL spFinishReserve ("Débito", "44687871801");

CALL spDeleteProductOrderItem(44687871822, 555555555);

CALL spViewOrdersByCPF (44687871801);

