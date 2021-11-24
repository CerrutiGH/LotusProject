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

DROP VIEW vwAllReserves;
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

SELECT * FROM vwAllReserves LIMIT 5;


CREATE TEMPORARY TABLE MonthOrders(
select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = 1,
select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = 2,
select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = 3,
select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = 4,
select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = 5,
select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = 6,
select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = 7,
select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = 8,
select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = 9,
select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = 10,
select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = 11,
select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = 12,
);