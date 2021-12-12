SET SQL_SAFE_UPDATES=0;

Delimiter $$
CREATE PROCEDURE spUpdateCustomer(varCustCPF varchar(14), varCustName varchar(150), varCustDtNasc datetime,
varCustGender char(1), varCustPassword varchar(18), varCustNumberAddress integer, varCEP varchar(10))
BEGIN

IF NOT EXISTS (SELECT CEP FROM tbCep WHERE CEP = varCEP) THEN
            INSERT INTO tbCep (CEP) VALUES (varCEP);
END IF;

IF EXISTS (SELECT CustCPF FROM tbCustomer WHERE CustCPF = varCustCPF) THEN
				UPDATE tbCustomer SET CustName = varCustName, CustDtNasc = varCustDtNasc, CustGender = varCustGender, CustPassword = varCustPassword, CustNumberAddress = varCustNumberAddress, CEPAddress = (SELECT CEP FROM tbCep WHERE CEP = varCEP) WHERE CustCPF = varCustCPF;
END IF;

END; 
$$ DELIMITER ;


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



DROP PROCEDURE IF EXISTS spLoginUser;
DELIMITER $$
CREATE PROCEDURE spLoginUser(varEmailUser varchar(150), varPasswordUser varchar(18))
BEGIN
SELECT * FROM tbCustomer WHERE CustEmail = varEmailUser AND CustPassword = varPasswordUser AND IsDeleted = 'N';
END
$$ DELIMITER ;

DROP PROCEDURE IF EXISTS spLoginEmployee;
DELIMITER $$
CREATE PROCEDURE spLoginEmployee(varLoginEmployee varchar(150), varPasswordEmployee varchar(18))
BEGIN
SELECT * FROM tbemployee WHERE EmpLogin = varLoginEmployee AND EmpPassword = varPasswordEmployee AND IsDeleted = 'N';
END
$$ DELIMITER ;

CALL spLoginEmployee("Cerriti", "123321");


DELIMITER $$
CREATE PROCEDURE spSelectEmail(varEmailUser varchar(150))
BEGIN
SELECT CustEmail FROM tbCustomer WHERE CustEmail = varEmailUser;
END
$$ DELIMITER ;

DROP PROCEDURE IF EXISTS spSelectEmployeeData;
DELIMITER $$
CREATE PROCEDURE spSelectEmployeeData(varLogin varchar(50))
BEGIN
SELECT * FROM vwDataEmployee WHERE EmpLogin = varLogin;
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



DROP PROCEDURE IF EXISTS spReserve;
DELIMITER $$
CREATE PROCEDURE spReserve (varResAmount int, varCustCPF varchar(14), varPackCode int)
BEGIN
IF NOT EXISTS (SELECT ResCode FROM tbreserve WHERE CustCPF = varCustCPF AND StatusReserve = 'U') THEN
INSERT INTO tbreserve (ResPrice,ResAmount, CustCPF, PackCode)
VALUES ((SELECT PackPrice FROM tbPackage WHERE PackCode = varPackCode AND StatusPack = 'A') * varResAmount,varResAmount, varCustCPF, varPackCode);
ELSE 
UPDATE tbreserve SET ResPrice = (SELECT PackPrice FROM tbPackage WHERE PackCode = varPackCode AND StatusPack = 'A'), ResAmount = varResAmount, PackCode = (SELECT PackCode FROM tbPackage WHERE PackName = varPackName AND StatusPack = 'A') WHERE CustCPF = varCustCPF AND StatusReserve = 'U';
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

DELIMITER $$
CREATE PROCEDURE spChangeStatusReserve (varResCode int, varStatusReserve char(1))
BEGIN

IF EXISTS (SELECT ResCode FROM tbReserve WHERE ResCode = varResCode AND StatusReserve = 'F') THEN
UPDATE tbReserve SET StatusReserve = varStatusReserve WHERE ResCode = varResCode;
END IF;
END; 
$$ DELIMITER ;

CALL spChangeStatusReserve (2, 'C');


/*CALL PROCEDURES*/


/* Insert Customer */


CALL spLoginUser("bielhcsou22@gmail.com", "123322");

/* Insert Employee */
CALL spInsertEmployee("44697971801", "Gabriel Cerruti", "Cerriti", '2003-02-25', "m", "1197546558", "bielhousa@gmail.com", "123321", 12, "02522-100", "Gerente");
CALL spInsertEmployee("44697971822", "Fernanda Rocha", "Cerrit", '2003-02-25', "m", "1197546522", "bielhou22@gmail.com", "123321", 12, "02522-100", "Administrator");
CALL spInsertEmployee("44697971823", "Gabriel Cerruti", "Cerri", '2003-02-25', "m", "1197546523", "bielhou32@gmail.com", "123321", 12, "02522-100", "Administrator");

/* Insert Products */
CALL spInsertProduct (123654656, "Celular", 50.63, "Eletronico");
CALL spInsertProduct (123600006, "Bob esponja", 70.00, "Brinquedo");
CALL spInsertProduct (123609999, "Mickey", 70.00, "Brinquedo");
CALL spInsertProduct (123607999, "Mickey mouse", 70.00, "Pelucia");
CALL spInsertProduct (555555555, "Mickey mouse", 70.00, "Pelucia");


CALL spInsertOrderItem (123609999, 4, 45665465444);
CALL spInsertOrderItem (123600006, 4, 45665465444);
CALL spInsertOrderItem (123607999, 3, 45665465444);
CALL spInsertOrderItem (555555555, 3, 45665465444);

/* Finish Order and close payment */
CALL spFinishOrder ("Crédito", 45665465444);

/* Insert Package*/
CALL spInsertPackage(50.67, "Sonho Feliz", "Esta é a descrição :)");

/* Make reserve */
CALL spReserve(4, 44687871801, 1); /*quantidade, cpf, codigo pack*/
CALL spReserve(3, 45665465444, 1);

/*Finish Reserve and close payment*/
CALL spFinishReserve ("Débito", "44687871801");

CALL spDeleteProductOrderItem(44687871822, 555555555);

CALL spViewOrdersByCPF (44687871801);



CALL spInsertCustomer(44687871801, "Gabriel Cerruti", '2003-02-25', "M", 11975466558, "bielhcsousa@gmail.com", "123321", 65, 05133160);
CALL spInsertCustomer(44687871822, "Gabriel Cerruti", '2003-02-25', "M", 11975466522, "bielhcsou22@gmail.com", "123322", 70, 05133122);
CALL spInsertCustomer(45665465444, "Fernanda Rocha", '2003-02-25', "F", 11975465522, "fefes@gmail.com", "123322", 70, 05133122);
CALL spInsertCustomer ("489.599.928-52","Elvis Johnson","1951-01-31","M","(11)94886-2634","elvisjohnson@gmail.com","I84JZ3Z",1659,"86413-061");
  CALL spInsertCustomer ("260.767.833-45","Xandra Lowery","1991-03-11","M","(11)92652-1325","xandralowery@hotmail.com","M80OP0W",3660,"83829-081");
  CALL spInsertCustomer ("225.681.182-06","Demetrius Daquan Lane","1991-09-03","M","(11)93110-0642","demetriusdaquanlane7552@gmail.com","W41DH1O",7735,"68212-929");
  CALL spInsertCustomer ("741.581.728-52","Brett Danielle Flores","1983-09-02","F","(11)91455-7594","brettdanielleflores9598@aol.com","Z67AC0V",4338,"24239-587");
  CALL spInsertCustomer ("906.192.123-25","Erasmus Dixon","2001-08-02","M","(11)99694-3752","erasmusdixon382@aol.com","J71BS5I",9619,"67710-217");
  CALL spInsertCustomer ("536.736.450-70","Zenaida Pearson","1963-03-26","M","(11)93931-6333","zenaidapearson338@aol.com","P60CP5C",9044,"35337283");
  CALL spInsertCustomer ("582.519.711-76","Sandra Nora Joyner","1967-08-10","M","(11)98784-6539","sandranorajoyner@outlook.com","F32HA9K",2444,"98770-062");
  CALL spInsertCustomer ("905.048.123-21","Stacy Wendy Fitzgerald","1958-06-16","M","(11)90226-1003","stacywendyfitzgerald@outlook.com","W47PC5D",2177,"38597512");
  CALL spInsertCustomer ("097.714.758-98","Alexandra Reed Solis","1995-01-08","F","(11)95114-7331","alexandrareedsolis@gmail.com","E47EQ5N",8995,"75793-478");
  CALL spInsertCustomer ("443.342.612-76","Irma MacKenzie Wheeler","1980-09-19","M","(11)95823-8243","irmamackenziewheeler8833@aol.com","H44GE5F",4022,"81814-611");

  CALL spInsertCustomer ("865.053.044-70","Brooke Griffin Hudson","1996-12-08","F","(11)92849-2905","brookegriffinhudson@aol.com","V40JJ4A",538,"68172-427");
  CALL spInsertCustomer ("807.946.948-40","Glenna Aurora Bridges","1993-08-30","F","(11)97636-6133","glennaaurorabridges9581@icloud.com","Y67JP4R",4767,"65143-251");
  CALL spInsertCustomer ("797.677.658-66","Zorita Amaya Brown","2002-06-08","F","(11)96256-1673","zoritaamayabrown@outlook.com","N79RU7U",6861,"46634-624");
  CALL spInsertCustomer ("774.284.468-55","Hall Holden","1957-04-21","F","(11)94059-3372","hallholden466@aol.com","F63YP8O",611,"88280-644");
  CALL spInsertCustomer ("052.187.703-76","Roth Abbott","2000-02-05","M","(11)96256-2248","rothabbott2570@outlook.com","X62OI0B",4778,"58573-784");
  CALL spInsertCustomer ("158.881.876-81","Cassady Shellie Fuller","1999-04-10","F","(11)97622-9344","cassadyshelliefuller@yahoo.com","G06QQ4L",3812,"41454-057");
  CALL spInsertCustomer ("862.229.750-84","Catherine Kenneth Hunter","1958-04-26","M","(11)98727-7322","catherinekennethhunter5112@hotmail.com","C16EQ1F",4232,"53778-847");
  CALL spInsertCustomer ("002.317.561-81","Carissa Hansen","1960-04-05","F","(11)96251-3857","carissahansen8668@gmail.com","Y34PK8M",1149,"61532-434");
  CALL spInsertCustomer ("214.767.216-22","Dieter Warner","1956-04-28","M","(11)92543-3626","dieterwarner@icloud.com","V67QL4V",1500,"58026-362");
  CALL spInsertCustomer ("421.534.474-56","Lyle Hunter","2002-05-11","F","(11)94223-6534","lylehunter6745@outlook.com","F77FS9F",4854,"58891-345");
 
  CALL spInsertCustomer ("629.137.614-55","Heather Chaim Jones","1956-10-10","F","(11)98160-8150","heatherchaimjones8423@gmail.com","Q53TN9W",2756,"58311-702");
  CALL spInsertCustomer ("348.353.490-17","Tobias Rivera","1957-07-03","M","(11)95935-5655","tobiasrivera3702@aol.com","H72SW6M",3007,"74714-434");
  CALL spInsertCustomer ("438.333.678-36","Rajah Pratt","1968-09-05","M","(11)92874-8766","rajahpratt1199@yahoo.com","N64NJ6Y",6986,"91758-480");
  CALL spInsertCustomer ("888.576.789-78","Alexa Franklin","1995-05-30","F","(11)95520-3567","alexafranklin@icloud.com","J58KM2T",9237,"58784-197");
  CALL spInsertCustomer ("180.505.712-40","Salvador Miller","1983-04-13","M","(11)94235-4242","salvadormiller@outlook.com","K86UB1T",8536,"67154-823");
  CALL spInsertCustomer ("666.808.232-41","Germaine Lavinia Chase","1985-10-19","F","(11)98818-2967","germainelaviniachase5316@hotmail.com","E33FL1F",1151,"23613-805");
  CALL spInsertCustomer ("855.671.766-09","Solomon Perry","1955-08-26","F","(11)92255-8763","solomonperry6122@outlook.com","S59QD3V",5104,"67289-455");
  CALL spInsertCustomer ("523.412.093-72","Holly Inga Wilkins","1997-03-26","F","(11)99825-5642","hollyingawilkins8908@outlook.com","E52PP3I",4576,"11232-111");
  CALL spInsertCustomer ("666.187.726-42","Kasper Scott","2002-04-03","M","(11)93157-7707","kasperscott@gmail.com","O31AK8Y",8245,"46686-633");
  CALL spInsertCustomer ("858.479.018-44","Price Aiko Page","1960-09-27","M","(11)97826-7461","priceaikopage@gmail.com","T93PV6Y",9608,"88514-200");

  CALL spInsertCustomer ("715.517.345-54","Breanna Penelope Wooten","1989-05-09","F","(11)90084-1841","breannapenelopewooten@outlook.com","M76FF3K",5460,"14234-843");
  CALL spInsertCustomer ("507.897.878-28","Quinn Kieran Gilmore","1996-01-16","M","(11)98416-1060","quinnkierangilmore@yahoo.com","F14WS2D",1581,"52324-435");
  CALL spInsertCustomer ("526.082.961-70","Axel Sloan","1972-12-12","M","(11)99611-2124","axelsloan@gmail.com","E66TN7L",6520,"74769-964");
  CALL spInsertCustomer ("865.693.125-16","Tashya Oren Pate","1993-12-02","F","(11)96296-9644","tashyaorenpate8668@yahoo.com","W62ON8R",8824,"41045-440");
  CALL spInsertCustomer ("174.655.844-38","Yael Romero","1960-05-26","M","(11)96563-2315","yaelromero354@hotmail.com","W65WG3N",7270,"54471-670");
  CALL spInsertCustomer ("612.427.673-23","Amir Sykes","1962-02-10","M","(11)92439-4442","amirsykes@hotmail.com","T32HO1G",7876,"92132-311");
  CALL spInsertCustomer ("760.917.578-66","Tatum Nehru Mason","1991-09-25","F","(11)98354-2474","tatumnehrumason@gmail.com","C68TQ7N",5387,"42247-179");
  CALL spInsertCustomer ("685.186.019-23","Hanna Alexa Wilson","1966-01-13","M","(11)94237-0224","hannaalexawilson9125@aol.com","C23DR1Z",3521,"12823-077");
  CALL spInsertCustomer ("504.069.321-72","Selma Halee Durham","1957-07-03","M","(11)95788-3268","selmahaleedurham796@aol.com","J16IB4C",5075,"53577-718");
  CALL spInsertCustomer ("314.448.946-23","Bevis Ulysses Delaney","1993-07-21","M","(11)98151-1373","bevisulyssesdelaney@hotmail.com","N76UN0M",2578,"54269-578");

  CALL spInsertCustomer ("279.824.816-38","Callie Jenette O'connor","1994-04-02","F","(11)97941-2157","calliejenetteoconnor@icloud.com","V88NT6I",9612,"65727-387");
  CALL spInsertCustomer ("802.581.822-12","Melyssa Griffin","1981-03-22","M","(11)92372-4225","melyssagriffin@gmail.com","Y39TR2V",9022,"65076-266");
  CALL spInsertCustomer ("349.003.175-41","Madison Huber","1983-10-07","M","(11)91748-6224","madisonhuber@icloud.com","H66LR8S",8487,"75764-730");
  CALL spInsertCustomer ("844.936.746-17","Amal Martha Goodwin","1986-10-30","M","(11)97542-3317","amalmarthagoodwin@icloud.com","Q85JF1P",5024,"88476-875");
  CALL spInsertCustomer ("796.950.517-73","Garrison Roman","1984-04-30","M","(11)99786-6247","garrisonroman@aol.com","R36QI3V",3498,"88558-461");
  CALL spInsertCustomer ("158.457.613-28","Cameran Shaeleigh Lopez","1987-04-21","F","(11)92371-8208","cameranshaeleighlopez@hotmail.com","C72QD5S",8986,"89456-015");
  CALL spInsertCustomer ("671.590.423-96","Gannon Frances Anderson","1976-10-23","M","(11)95658-4595","gannonfrancesanderson@hotmail.com","T66YI0L",6117,"99436-787");
  CALL spInsertCustomer ("470.864.437-72","Gavin Mays","1986-03-29","F","(11)95217-3315","gavinmays8695@icloud.com","H56TH3T",3618,"52339-562");
  CALL spInsertCustomer ("824.127.682-37","Blossom Wallace Frederick","1990-05-03","F","(11)92387-3325","blossomwallacefrederick@gmail.com","P54DO9V",7011,"58735-144");
  CALL spInsertCustomer ("726.644.154-83","Buffy Carey","1972-11-07","M","(11)96382-1276","buffycarey2289@icloud.com","G64IW0I",59,"21026-731");

  CALL spInsertCustomer ("033.232.442-63","Eve Church","1999-06-04","F","(11)91231-8107","evechurch1899@icloud.com","V88QC3M",6640,"94123-276");
  CALL spInsertCustomer ("886.918.545-64","Tyler Thor Lang","1952-04-20","M","(11)97378-3627","tylerthorlang@hotmail.com","H54PW6L",7599,"36384716");
  CALL spInsertCustomer ("426.796.432-51","Tad Neil Mcneil","1955-07-02","M","(11)93173-3141","tadneilmcneil@icloud.com","S37GN7Q",235,"65170-047");
  CALL spInsertCustomer ("352.164.734-56","Brenden Medge Anderson","1982-07-27","M","(11)91256-7793","brendenmedgeanderson@aol.com","S78NR9X",8168,"31481431");
  CALL spInsertCustomer ("317.665.475-11","Grant Gabriel Wilkinson","1980-04-04","M","(11)93417-4595","grantgabrielwilkinson@icloud.com","W92TG2B",6324,"95532-387");
  CALL spInsertCustomer ("573.366.268-45","Erich Aimee Hartman","1957-05-26","F","(11)92684-8421","erichaimeehartman3474@icloud.com","L01PD0O",5237,"58773-678");
  CALL spInsertCustomer ("644.673.518-75","Shaine Quentin Baldwin","1991-07-09","M","(11)90325-5164","shainequentinbaldwin3691@outlook.com","K64YD7N",6339,"58674-241");
  CALL spInsertCustomer ("864.881.611-91","Phyllis Caldwell Lester","1969-03-14","F","(11)95240-0705","phylliscaldwelllester1035@aol.com","B53HX3U",7231,"89516-634");
  CALL spInsertCustomer ("269.395.885-32","Samuel Wade Cleveland","1966-02-19","M","(11)95532-5452","samuelwadecleveland7168@hotmail.com","V92ZU7T",2480,"65268-462");
  CALL spInsertCustomer ("964.148.192-17","Dieter Marks","1953-02-06","F","(11)92669-5713","dietermarks@outlook.com","L27ZG2E",2836,"61401-135");

  CALL spInsertCustomer ("181.668.825-67","Candace Reese Hanson","1967-04-13","F","(11)94418-7225","candacereesehanson6275@gmail.com","Q92XL4P",2062,"52956-947");
  CALL spInsertCustomer ("318.656.646-43","Noel Griffin","1953-01-02","M","(11)98181-4555","noelgriffin@hotmail.com","T36YF6H",8101,"67794-388");
  CALL spInsertCustomer ("118.633.600-18","Keelie Janna Dalton","1964-11-10","F","(11)94217-1673","keeliejannadalton4364@hotmail.com","O79WE2U",9229,"88523-444");
  CALL spInsertCustomer ("796.723.818-44","Harding Mccarthy","1955-07-29","F","(11)91831-6583","hardingmccarthy2231@aol.com","A48KT1Z",8483,"62865-481");
  CALL spInsertCustomer ("433.859.703-05","Madeson Acevedo","1990-01-09","M","(11)91670-5292","madesonacevedo7882@hotmail.com","O80TW8D",7731,"58681-554");
  CALL spInsertCustomer ("399.399.637-46","Celeste Fleming","1973-02-12","F","(11)96877-1222","celestefleming@yahoo.com","X15GX8I",9267,"23294-602");
  CALL spInsertCustomer ("761.472.186-14","Ina Bernard Bishop","1959-10-27","F","(11)98932-5743","inabernardbishop@outlook.com","W44EQ0I",6049,"54203-713");
  CALL spInsertCustomer ("528.676.290-53","Flynn Kellie Gillespie","1967-09-14","M","(11)94150-0329","flynnkelliegillespie8907@yahoo.com","Y05CP5Y",1626,"25111-665");
  CALL spInsertCustomer ("252.746.300-53","Dante Dieter Underwood","1950-12-30","M","(11)93175-7657","dantedieterunderwood4438@hotmail.com","D54VG8N",1274,"76762-162");
  CALL spInsertCustomer ("743.319.266-51","Robert Chester Burton","1995-08-04","F","(11)91871-3897","robertchesterburton@aol.com","K32CQ6Q",4892,"47533-223");

  CALL spInsertCustomer ("553.174.029-17","Teegan Fuentes","1955-08-17","M","(11)95415-1713","teeganfuentes@hotmail.com","H16OY6E",1670,"88357-427");
  CALL spInsertCustomer ("373.314.740-78","Gary Lindsay","1968-08-15","F","(11)95483-6261","garylindsay@aol.com","D54SO9Z",6309,"36711925");
  CALL spInsertCustomer ("425.591.651-25","Branden Amal Hartman","1960-06-07","F","(11)98824-8024","brandenamalhartman@icloud.com","R77BL5Q",871,"89863-208");
  CALL spInsertCustomer ("292.911.222-83","Glenna Carson Boyer","1989-11-07","F","(11)93875-4877","glennacarsonboyer@hotmail.com","W87OR4O",8728,"62113-759");
  CALL spInsertCustomer ("686.638.846-28","Whilemina Hampton","1961-03-07","F","(11)98763-4146","whileminahampton@gmail.com","K96VU5V",4332,"58717-881");
  CALL spInsertCustomer ("469.250.725-24","Ifeoma Cunningham","1958-05-21","M","(11)97263-1658","ifeomacunningham3128@outlook.com","L54UG7S",3578,"61558-502");
  CALL spInsertCustomer ("591.028.493-83","Odessa Fitzgerald Oneal","1965-08-17","M","(11)94345-3861","odessafitzgeraldoneal8594@gmail.com","D40EJ6K",7754,"58940-651");
  CALL spInsertCustomer ("933.732.104-12","Callum Mariko Sutton","1968-09-12","F","(11)95557-7240","callummarikosutton908@yahoo.com","X69CY2C",1518,"44712-729");
  CALL spInsertCustomer ("082.379.831-41","Cain Strong","1954-10-25","F","(11)98809-4821","cainstrong2639@gmail.com","I38HV0N",2111,"51746-695");
  CALL spInsertCustomer ("767.671.114-87","Virginia Vinson","1962-06-22","F","(11)94173-0548","virginiavinson@icloud.com","S56BC1Q",6905,"58684-316");

  CALL spInsertCustomer ("804.534.853-41","Liberty Pittman","1995-08-31","F","(11)93827-7423","libertypittman@outlook.com","K85GR4H",6186,"21179-634");
  CALL spInsertCustomer ("686.195.518-24","Martena Barrett Michael","1978-12-21","M","(11)96065-5013","martenabarrettmichael5286@outlook.com","Y57NU1B",482,"41810-656");
  CALL spInsertCustomer ("709.235.574-00","Regan Sutton","1963-10-06","M","(11)92996-0661","regansutton@outlook.com","E84WH4N",2093,"12896-918");
  CALL spInsertCustomer ("812.855.488-72","Wyatt Wynne Hurst","1962-05-12","F","(11)92188-2305","wyattwynnehurst@gmail.com","E74RT8L",8742,"15824-181");
  CALL spInsertCustomer ("703.523.850-73","Melanie Mcmillan","1997-05-18","F","(11)96846-5163","melaniemcmillan@gmail.com","M81SB2Y",7402,"32619307");
  CALL spInsertCustomer ("513.593.345-82","Henry Tillman","1967-03-30","F","(11)90323-1784","henrytillman@hotmail.com","K54LG6W",3733,"36168534");
  CALL spInsertCustomer ("491.894.715-15","Jin Ratliff","1989-12-02","F","(11)98351-8495","jinratliff@outlook.com","L64WS3T",1391,"27443-768");
  CALL spInsertCustomer ("380.382.197-77","Colt Yoshio Heath","1994-11-23","F","(11)95063-5244","coltyoshioheath@hotmail.com","F71GA5A",3251,"14722-654");
  CALL spInsertCustomer ("942.140.776-47","Susan Holden","1969-09-26","M","(11)95571-4878","susanholden@aol.com","C25QF5P",7937,"54343-933");
  CALL spInsertCustomer ("834.711.284-82","Shelly Freeman","1971-03-25","M","(11)96035-0808","shellyfreeman@aol.com","H52VF1G",5957,"68552-078");

  CALL spInsertCustomer ("417.561.471-06","Basia Moss","1968-10-27","M","(11)90411-9057","basiamoss5161@yahoo.com","M66EC4I",713,"44476-185");
  CALL spInsertCustomer ("297.715.855-33","Driscoll Solomon","1986-09-11","F","(11)93731-6966","driscollsolomon@hotmail.com","W70NC3F",3250,"52200-338");
  CALL spInsertCustomer ("472.854.518-64","Lucian Olivia Lester","1993-02-16","F","(11)95782-3925","lucianolivialester890@outlook.com","A74WL7I",475,"41304-603");
  CALL spInsertCustomer ("424.433.539-17","Forrest Anika Dean","2002-05-10","F","(11)93156-9595","forrestanikadean5207@yahoo.com","H83IQ3V",8864,"89341-921");
  CALL spInsertCustomer ("706.995.337-58","Ezra Hatfield","1970-04-22","M","(11)91472-1738","ezrahatfield@aol.com","V25OU7F",282,"67826-631");
  CALL spInsertCustomer ("633.524.273-95","Bradley Amity Alston","1954-10-16","M","(11)93354-8581","bradleyamityalston@aol.com","R80EX5F",3247,"58793-676");
  CALL spInsertCustomer ("759.863.760-85","Richard Coby Pratt","2000-03-18","F","(11)97055-1135","richardcobypratt@icloud.com","Z39DP3J",1602,"61684-501");
  CALL spInsertCustomer ("111.192.389-32","Jarrod Roberson","1953-04-05","F","(11)95556-5402","jarrodroberson4405@yahoo.com","Q80KR8N",1470,"56632-510");
  CALL spInsertCustomer ("122.085.391-99","Rajah Phelan Porter","1968-09-06","F","(11)92296-2854","rajahphelanporter@icloud.com","F33UU6O",2493,"43402-735");
  CALL spInsertCustomer ("532.868.522-71","Aladdin Rich","1969-05-02","M","(11)90724-1810","aladdinrich1294@outlook.com","U06AM8I",2652,"43841-912");

  CALL spInsertCustomer ("841.526.239-18","Eric Idona Humphrey","1998-07-15","M","(11)91176-5235","ericidonahumphrey@aol.com","V78GG5C",1767,"58698-365");
  CALL spInsertCustomer ("364.340.578-36","Randall Cyrus Rowland","1982-08-23","M","(11)98851-7645","randallcyrusrowland@hotmail.com","M60BH5Y",3494,"35580165");
  CALL spInsertCustomer ("014.623.435-84","Zoe Castor Robertson","1957-08-20","F","(11)93351-5274","zoecastorrobertson@icloud.com","O65VL0I",7949,"39812847");
  CALL spInsertCustomer ("683.491.463-55","Callum Harrell","1962-03-30","M","(11)98334-3924","callumharrell8504@aol.com","M86FV4N",5603,"92250-161");
  CALL spInsertCustomer ("614.246.872-59","Harper Moreno","1989-05-25","M","(11)91984-8857","harpermoreno@aol.com","K29OE3C",1707,"22831-469");
  CALL spInsertCustomer ("647.956.962-27","Melanie Copeland","1953-05-18","F","(11)97442-6162","melaniecopeland8055@gmail.com","M11NZ5N",9727,"74739-001");
  CALL spInsertCustomer ("928.352.147-15","Carter Carver","1959-02-19","M","(11)96734-7132","cartercarver@icloud.com","D01LP6N",837,"67146-642");
  CALL spInsertCustomer ("141.210.014-26","Carissa Cotton","1982-05-27","F","(11)96657-1137","carissacotton4904@outlook.com","Y55UN6P",8298,"53835-307");
  CALL spInsertCustomer ("604.371.771-52","Quinlan Whitfield","1951-12-29","M","(11)92260-5573","quinlanwhitfield597@outlook.com","N33FU4R",9329,"48484-622");
  CALL spInsertCustomer ("544.839.477-28","Ryan Paul","1959-11-09","F","(11)98313-3696","ryanpaul@outlook.com","U41TD2H",7707,"82789-583");

  CALL spInsertCustomer ("754.171.877-21","Clinton Imani Workman","1972-05-11","M","(11)96661-9434","clintonimaniworkman1081@outlook.com","I51NK6J",8339,"58522-286");
  CALL spInsertCustomer ("477.784.563-73","Holly Sanders","1992-10-03","F","(11)96023-0550","hollysanders@gmail.com","O47CC6T",9152,"12143-111");
  CALL spInsertCustomer ("614.284.726-65","Giacomo Claire Britt","1984-10-04","M","(11)98225-4625","giacomoclairebritt4194@outlook.com","G53IN8V",8591,"96682-377");
  CALL spInsertCustomer ("356.371.811-72","Octavius Conrad","1961-02-20","F","(11)91535-6757","octaviusconrad247@hotmail.com","D57XI3O",6689,"51759-230");
  CALL spInsertCustomer ("576.238.283-23","Wanda Dejesus","1986-01-23","F","(11)94954-2073","wandadejesus1462@icloud.com","G78OY4K",419,"47260-573");
  CALL spInsertCustomer ("580.338.817-41","Callum Goodman","1963-10-11","F","(11)94727-3563","callumgoodman@aol.com","T42UE4L",2730,"76786-758");
  CALL spInsertCustomer ("171.699.623-48","Tamekah Arnold","1999-02-16","M","(11)94267-8280","tamekaharnold@outlook.com","A52OT2F",2971,"16748-436");
  CALL spInsertCustomer ("505.524.341-14","Chaney Crosby","1976-11-20","M","(11)91695-5735","chaneycrosby@icloud.com","S26EG6J",257,"60211-547");
  CALL spInsertCustomer ("512.733.997-03","Chancellor Chandler Wade","1977-01-02","M","(11)93143-8276","chancellorchandlerwade@outlook.com","B73SR4Z",9463,"65655-461");
  CALL spInsertCustomer ("860.594.167-04","Kylynn Alan Gordon","1974-10-24","F","(11)96465-1167","kylynnalangordon@aol.com","P62NG2L",4024,"45726-203");

  CALL spInsertCustomer ("625.983.227-73","Asher Goodman","1985-06-30","F","(11)95326-1624","ashergoodman663@gmail.com","Y74DM0F",2440,"54053-031");
  CALL spInsertCustomer ("873.535.308-81","Allistair Raymond","1968-08-04","M","(11)96358-4480","allistairraymond@aol.com","O11WK9N",1109,"67367-356");
  CALL spInsertCustomer ("766.194.357-87","Scarlet Robertson","1965-01-13","M","(11)94895-8306","scarletrobertson@outlook.com","N43PC3O",8504,"95916-850");
  CALL spInsertCustomer ("476.780.464-34","Jakeem Nicole Rivera","1991-12-31","M","(11)98819-3021","jakeemnicolerivera6414@outlook.com","I48OP5M",6787,"75716-021");
  CALL spInsertCustomer ("173.164.333-37","Orla Haley Love","1991-12-16","M","(11)94987-5508","orlahaleylove@gmail.com","S29OH3X",5405,"89956-390");
  CALL spInsertCustomer ("896.131.186-42","Helen Forbes","1950-05-25","F","(11)93714-5415","helenforbes@outlook.com","F93IV5W",6907,"39917893");
  CALL spInsertCustomer ("548.519.819-21","Timon Bowman","1965-07-22","F","(11)95118-2216","timonbowman@hotmail.com","K26UH6Q",2395,"62509-248");
  CALL spInsertCustomer ("641.484.780-47","Francis Quamar Langley","1976-06-08","M","(11)97345-6688","francisquamarlangley@hotmail.com","C24HL2L",3037,"58503-833");
  CALL spInsertCustomer ("551.355.136-43","Tallulah Lacey Baxter","1967-06-06","F","(11)94400-4196","tallulahlaceybaxter@gmail.com","Q67US8B",4456,"53751-767");
  CALL spInsertCustomer ("935.157.732-75","Herman Sandra Moss","1952-01-01","M","(11)96625-3127","hermansandramoss2332@gmail.com","B85TC7T",3053,"88643-786");

  CALL spInsertCustomer ("115.485.257-77","Ursula Rhodes","1996-08-09","F","(11)97953-4401","ursularhodes@icloud.com","A32PU5P",9051,"96732-029");
  CALL spInsertCustomer ("136.708.324-49","Brody Farmer","1997-06-14","M","(11)95019-5586","brodyfarmer@yahoo.com","U57JF6O",7328,"65439-772");
  CALL spInsertCustomer ("874.764.756-24","Shaine Zephr Paul","1960-08-02","F","(11)90381-6141","shainezephrpaul@yahoo.com","M29UW2P",7431,"97640-468");
  CALL spInsertCustomer ("239.878.818-22","Geraldine Barrett","1970-04-23","M","(11)97712-0714","geraldinebarrett@hotmail.com","C58WI2Q",3043,"62561-371");
  CALL spInsertCustomer ("247.861.363-73","Reagan Micah Meadows","1961-08-14","M","(11)93109-4455","reaganmicahmeadows572@gmail.com","D64RD2N",195,"74767-471");
  CALL spInsertCustomer ("759.672.447-50","Kelly Mckenzie","1977-03-13","M","(11)91846-8914","kellymckenzie6687@icloud.com","Z51NT6X",5543,"35644095");
  CALL spInsertCustomer ("425.379.164-75","Scott Oneal","1991-01-12","F","(11)90562-3129","scottoneal@outlook.com","H72ZK6W",3019,"55198-734");
  CALL spInsertCustomer ("178.188.845-63","Elijah Sweet","1952-10-26","F","(11)94263-5104","elijahsweet6169@hotmail.com","E71IE7G",3892,"43747-477");
  CALL spInsertCustomer ("801.617.786-56","Desirae Sylvester Brock","1983-01-17","M","(11)94046-3014","desiraesylvesterbrock@outlook.com","G77DS5E",1408,"25584-516");
  CALL spInsertCustomer ("393.618.687-48","Malcolm Robinson","1953-02-23","M","(11)94858-2769","malcolmrobinson@aol.com","W77HL8S",2214,"68556-721");

  CALL spInsertCustomer ("508.244.632-34","Isaiah Rush","1964-12-05","F","(11)92368-6310","isaiahrush@icloud.com","A63XV8L",7173,"16934-830");
  CALL spInsertCustomer ("175.921.305-81","Stewart Saunders","1955-05-03","F","(11)97143-0516","stewartsaunders5086@yahoo.com","M06NV8K",8663,"54376-424");
  CALL spInsertCustomer ("047.769.475-68","Camden Abraham Gamble","1984-11-30","M","(11)99674-2163","camdenabrahamgamble@aol.com","U12OS6N",1809,"15250-267");
  CALL spInsertCustomer ("869.511.487-75","Eleanor Mason Cherry","1986-07-02","F","(11)91200-8477","eleanormasoncherry@gmail.com","V30UK2K",7305,"61682-961");
  CALL spInsertCustomer ("844.587.444-61","Chadwick Keiko Foster","1965-07-15","M","(11)97449-7325","chadwickkeikofoster@gmail.com","G48VS1Y",5652,"26740-354");
  CALL spInsertCustomer ("192.110.444-26","Cody Glenn","1982-03-12","M","(11)91576-1155","codyglenn1569@gmail.com","Z72TT7Z",4871,"81145-195");
  CALL spInsertCustomer ("791.212.680-05","David Ferris Davis","1993-03-04","M","(11)94459-1671","davidferrisdavis5927@yahoo.com","Y47VL1K",3142,"58110-422");
  CALL spInsertCustomer ("111.429.988-24","Aretha Harvey","1955-03-26","M","(11)92350-6087","arethaharvey@aol.com","C47QF1B",6848,"76724-418");
  CALL spInsertCustomer ("527.145.738-24","Aidan Schneider","1971-11-18","M","(11)96968-8182","aidanschneider2024@aol.com","I11DY1W",3743,"81672-777");
  CALL spInsertCustomer ("894.186.404-29","Alexander Gage Cross","1982-11-25","F","(11)97855-7613","alexandergagecross@outlook.com","A12YG1X",3731,"81485-739");
