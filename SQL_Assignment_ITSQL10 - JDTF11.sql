USE pw_assignment;

-- ===== Customers =====
Create table Customers ( CustomerID INT, 
CustomerName VARCHAR(30),
City VARCHAR(30),
JoinDate DATE);

INSERT INTO Customers VALUES
(101,'Rahul Sharma','Bangalore','2023-01-15'),
(102,'Priya Mehta','Mumbai','2024-03-20'),
(103,'Arjun Nair','Chennai','2025-01-12'),
(104,'Sneha Gupta','Delhi','2022-07-10'),
(105,'Kavya Reddy','Hyderabad','2024-08-15'),
(106,'Amit Verma','Pune','2023-11-05'),
(107,'Rohan Singh','Kolkata','2024-05-18'),
(108,'Simran Kaur','Delhi','2025-02-01'),
(109,'Anjali Jain','Mumbai','2023-09-22'),
(110,'Vikram Patel','Ahmedabad','2022-12-30');


-- ===== Orders =====
CREATE TABLE Orders (
OrderID INT,
CustomerID INT,
OrderDate DATE,
OrderAmount DECIMAL(10,2),
Status VARCHAR(20)
);

INSERT INTO Orders VALUES
(5001,101,'2025-01-05',12000,'Delivered'),
(5002,102,'2025-01-15',8500,'Pending'),
(5003,101,'2025-02-10',22000,'Delivered'),
(5004,104,'2025-02-15',4500,'Cancelled'),
(5005,103,'2025-03-01',17500,'Delivered'),
(5006,105,'2025-03-10',9800,'Pending'),
(5007,106,'2025-03-18',25000,'Delivered'),
(5008,107,'2025-04-02',14500,'Delivered'),
(5009,101,'2025-04-10',30000,'Delivered'),
(5010,109,'2025-04-15',6500,'Pending'),
(5011,110,'2025-05-01',42000,'Delivered'),
(5012,104,'2025-05-08',18000,'Delivered'),
(5013,106,'2025-05-15',7000,'Cancelled'),
(5014,102,'2025-05-20',27000,'Delivered'),
(5015,107,'2025-06-01',15500,'Pending'); 

-- ===== Employees =====
CREATE TABLE Employees (
EmployeeID INT,
EmployeeName VARCHAR(50),
ManagerID INT,
Department VARCHAR(30),
JoiningDate DATE,
Salary DECIMAL(10,2)
);


INSERT INTO Employees VALUES
(1,'Rajesh Kumar',NULL,'Management','2018-01-10',150000),
(2,'Neha Sharma',1,'Sales','2020-03-15',90000),
(3,'Amit Gupta',1,'IT','2019-06-20',110000),
(4,'Priyanka Singh',2,'Sales','2022-01-12',65000),
(5,'Vikas Patel',2,'Sales','2021-09-18',70000),
(6,'Rohit Jain',3,'IT','2023-02-05',60000),
(7,'Anjali Verma',3,'IT','2022-11-10',62000),
(8,'Karan Mehta',1,'HR','2021-05-25',80000),
(9,'Sneha Kapoor',8,'HR','2024-01-05',50000),
(10,'Arjun Malhotra',3,'IT','2024-04-15',55000);


-- =====================================================
-- QUESTION 1: Display the top 5 highest-value orders along with customer names.
-- =====================================================

SELECT o.OrderID, c.CustomerName, o.OrderAmount, o.OrderDate, o.Status
FROM Orders o JOIN Customers c
ON o.CustomerID = c.CustomerID
ORDER BY o.OrderAmount DESC
LIMIT 5;


-- =====================================================
-- QUESTION 2 : Display customers whose names start with A, R, or S. Without using multiple OR conditions.
-- =====================================================

SELECT * FROM Customers
WHERE LEFT(CustomerName, 1) IN ('A', 'R', 'S');


-- =====================================================
-- QUESTION 3: Customers who have placed orders worth more than  ₹10,000 but whose order status is Pending.
-- =====================================================

SELECT DISTINCT c.CustomerName, o.OrderID, o.OrderAmount, o.Status
FROM Customers c JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderAmount > 10000
AND o.Status = 'Pending';


-- =====================================================
-- QUESTION 4: Customers who joined more than 365 days ago. Display the number of days associated with the company.
-- =====================================================

SELECT DISTINCT CustomerID, CustomerName, JoinDate,
DATEDIFF(CURRENT_DATE(), JoinDate) AS `Associated Days`
FROM Customers
WHERE DATEDIFF(CURRENT_DATE(), JoinDate) > 365;


-- =====================================================
-- QUESTION 5 : 
-- Future revenue report:
-- Order ID
-- Current Amount
-- 18% GST
-- Total Amount After GST
-- Expected Collection Date (15 days after order date)
-- =====================================================

SELECT OrderID, OrderAmount AS `Current Amount`, ROUND(OrderAmount * 0.18, 2) AS `18% GST`,
ROUND(OrderAmount * 1.18, 2) AS `Total Amount After GST`, DATE_ADD(OrderDate, INTERVAL 15 DAY) AS `Expected Collection Date`
FROM Orders;


-- =====================================================
-- QUESTION 6: Customers ranked between 11th and 20th highest orders.
-- Use LIMIT and OFFSET.
-- =====================================================

SELECT DISTINCT c.CustomerName, o.OrderID, o.OrderAmount FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
ORDER BY o.OrderAmount DESC
LIMIT 10 OFFSET 10;


-- =====================================================
-- QUESTION 7:
-- Customers who have never placed any order.
-- Display Customer ID, Customer Name, Join Date,
-- and Number of Days Since Registration.
-- =====================================================

SELECT DISTINCT c.CustomerID, c.CustomerName, c.JoinDate,
DATEDIFF(CURRENT_DATE(), c.JoinDate) AS `Number of Days Since Registration`
FROM Customers c LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;


-- =====================================================
-- QUESTION 8 : Organizational hierarchy.
-- Display Employee Name, Manager Name, Department.
-- =====================================================

SELECT e.EmployeeName AS `Employee Name`, m.EmployeeName AS `Manager Name`, e.Department
FROM Employees e LEFT JOIN Employees m
ON e.ManagerID = m.EmployeeID;


-- =====================================================
-- QUESTION 9 : Customers who placed their FIRST order within 30 days
-- of joining the platform.
-- =====================================================

SELECT c.CustomerName, c.JoinDate, MIN(o.OrderDate) AS `Order Date`, 
DATEDIFF(MIN(o.OrderDate), c.JoinDate) AS `Days Taken To Place First Order`
FROM Customers c JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName, c.JoinDate
HAVING DATEDIFF(MIN(o.OrderDate), c.JoinDate) <= 30;


-- =====================================================
-- QUESTION 10 : 
-- Customer Name
-- Total Purchase Amount
-- Spending Category
-- Loyalty Status
-- =====================================================

SELECT DISTINCT c.CustomerName, SUM(o.OrderAmount) AS `Total_Purchase_Amount`,
CASE WHEN SUM(o.OrderAmount) > 50000 THEN 'Premium'
	 WHEN SUM(o.OrderAmount) >= 20000 THEN 'Gold'
	 ELSE 'Silver'
END AS `Spending_Category`,

CASE WHEN YEAR(c.JoinDate) < 2024 THEN 'Loyal Customer'
	ELSE 'New Customer'
END AS `Loyalty_Status`
FROM Customers c JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY  c.CustomerID, c.CustomerName, c.JoinDate;


-- =====================================================
-- QUESTION 11: Customers whose order amount is higher than the
-- average order amount of all orders.
-- =====================================================

SELECT DISTINCT c.CustomerName, o.OrderID, o.OrderAmount
FROM Customers c JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderAmount > ( SELECT AVG(OrderAmount) FROM Orders
);


-- =====================================================
-- QUESTION 12: Display the 2nd to 6th highest orders.
-- =====================================================

SELECT DISTINCT c.CustomerName, o.OrderID, o.OrderAmount
FROM Customers c JOIN Orders o
ON c.CustomerID = o.CustomerID
ORDER BY o.OrderAmount DESC LIMIT 5 OFFSET 1;
