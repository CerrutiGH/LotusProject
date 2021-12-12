DROP VIEW IF EXISTS vwAllOrders;
CREATE VIEW vwAllOrders AS
SELECT Cust.CustName, Cust.CustCPF, Cust.CustEmail, Ord.OrdDate, Ord.OrdTotalPrice
FROM tbOrder Ord 
INNER JOIN tbCustomer Cust ON Ord.CustCPF = CUst.CustCPF 
WHERE Ord.StatusOrder = 'F';

CREATE VIEW vwDataEmployee AS
SELECT Emp.EmpCPF, Emp.EmpName, Emp.EmpLogin, Emp.EmpDtNasc, Emp.EmpTel, Emp.EmpEmail, Emp.CEPAddress, Rolee.RoleName 
FROM tbEmployee Emp 
INNER JOIN tbrole Rolee ON Rolee.RoleCode = Emp.EmpRole;

SELECT * FROM vwDataEmployee;

DROP VIEW IF EXISTS vwAllReserves;
CREATE VIEW vwAllReserves AS
SELECT res.CustCPF,cust.CustName, res.ResAmount, res.ResPrice, res.ResValidity, res.StatusReserve, res.ResCode
FROM tbreserve res 
INNER JOIN tbcustomer cust ON res.CustCPF = cust.CustCPF 
WHERE res.StatusReserve != 'U';




SELECT 
    COUNT(*)
FROM
    vwAllReserves;

select SUM(OrdTotalPrice) FROM vwAllOrders WHERE MONTH(OrdDate) = month(now());

select DATE_ADD(OrdDate,INTERVAL 10 DAY) From vwAllOrders ;




SELECT COUNT(*) FROM vwAllReserves WHERE MONTH(ResValidity) = MONTH(NOW());
SELECT CustCPF, CustName, ResAmount, ResPrice, DATE_FORMAT(ResValidity,'%d/%m/%y'), StatusReserve, ResCode FROM vwAllReserves LIMIT 5;