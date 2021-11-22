DROP VIEW IF EXISTS vwAllOrders;
CREATE VIEW vwAllOrders AS
SELECT Cust.CustName, Cust.CustCPF, Cust.CustEmail, Ord.OrdDate, Ord.OrdTotalPrice
FROM tbOrder Ord 
INNER JOIN tbCustomer Cust ON Ord.CustCPF = CUst.CustCPF 
WHERE Ord.StatusOrder = 'F';

DROP VIEW IF EXISTS vwAllOrders;
CREATE VIEW vwAllOrders AS
SELECT Cust.CustName, Cust.CustCPF, Cust.CustEmail, Ord.OrdDate, Ord.OrdTotalPrice
FROM tbOrder Ord 
INNER JOIN tbCustomer Cust ON Ord.CustCPF = CUst.CustCPF 
WHERE Ord.StatusOrder = 'F';



select SUM(OrdTotalPrice) FROM vwAllOrders WHERE MONTH(OrdDate) = 11;
select * From vwAllOrders;
select COUNT(*) From vwAllOrders;