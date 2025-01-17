use classicmodels;
/* Qusetion 1(a).	
Fetch the employee number,first name and last name of those employees who are working as Sales Rep 
reporting to employee with employeenumber 1102 (Refer employee table)*/
 
 SELECT employeeNumber, firstName, lastName
FROM Employees
WHERE jobTitle = 'Sales Rep' AND reportsTo = 1102;

-- Question 1(b)	Show the unique productline values containing the word cars at the end from the products table.

SELECT DISTINCT productLine
FROM productlines
WHERE productLine LIKE '%cars';

/* Question 2(a) Q2. CASE STATEMENTS for Segmentation

. a. Using a CASE statement, segment customers into three categories based on their country:(Refer Customers table)
                        "North America" for customers from USA or Canada
                        "Europe" for customers from UK, France, or Germany
                        "Other" for all remaining countries
     Select the customerNumber, customerName, and the assigned region as "CustomerSegment".
*/
SELECT 
    customerNumber, 
    customerName,
    CASE 
        WHEN country IN ('USA', 'Canada') THEN 'North America'
        WHEN country IN ('UK', 'France', 'Germany') THEN 'Europe'
        ELSE 'Other'
    END AS CustomerSegment
FROM 
    customers;

/* Question-3 (a)
	Using the OrderDetails table, identify the top 10 products (by productCode) with the highest total order quantity across all orders */


SELECT 
    productCode, 
    SUM(quantityOrdered) AS total_Ordered
FROM 
    orderdetails
GROUP BY 
    productCode
ORDER BY 
    total_Ordered DESC
LIMIT 10;

 /* Questions-3(b) 
 Company wants to analyse payment frequency by month.
 Extract the month name from the payment date to count the total number of payments for each month and include only those months with a payment count exceeding 20.
 Sort the results by total number of payments in descending order. */

SELECT 
    MONTHNAME(paymentDate) AS monthName,
    COUNT(*) AS totalPayments
FROM 
    payments
GROUP BY 
    monthName
HAVING 
    COUNT(*) > 20
ORDER BY 
    totalPayments DESC;

/* Question 4(a) CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default,Create a new database named and Customers_Orders ,
	Create a table named Customers to store customer information*/

CREATE DATABASE Customers_Orders;

USE Customers_Orders;

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20)
);

-- Question 4(b).Create a table named Orders to store information about customer orders.

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT chk_total_amount CHECK (total_amount > 0)
);

use classicmodels;

-- Question 5 Joins - List the top 5 countries (by order count) that Classic Models ships to. 

SELECT c.country, COUNT(o.orderNumber) AS orderCount
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.country
ORDER BY orderCount DESC
LIMIT 5;

/* Question 6 SELF JOIN
SELF JOIN
a. Create a table project with below fields.
●	EmployeeID : integer set as the PRIMARY KEY and AUTO_INCREMENT.
●	FullName: varchar(50) with no null values
●	Gender : Values should be only ‘Male’  or ‘Female’
●	ManagerID: integer  and Add data into it*/

CREATE TABLE project (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(50) NOT NULL,
    Gender ENUM('Male', 'Female'),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES project(EmployeeID)
);

INSERT INTO project (EmployeeID, FullName, Gender) VALUES
(1, 'Pranaya', 'Male'),    -- Pranaya
(2, 'Priyanka', 'Female'),  -- Priyanka
(3, 'Preety', 'Female'),    -- Preety
(4, 'Anurag', 'Male'),      -- Anurag
(5, 'Sambit', 'Male'),      -- Sambit
(6, 'Rajesh', 'Male'),      -- Rajesh
(7, 'Hina', 'Female');      -- Hina

UPDATE project SET ManagerID = 3 WHERE EmployeeID = 1;  
UPDATE project SET ManagerID = 1 WHERE EmployeeID = 2;  
UPDATE project SET ManagerID = NULL WHERE EmployeeID = 3;  
UPDATE project SET ManagerID = 1 WHERE EmployeeID = 4;  
UPDATE project SET ManagerID = 1 WHERE EmployeeID = 5;  
UPDATE project SET ManagerID = 3 WHERE EmployeeID = 6;  
UPDATE project SET ManagerID = 3 WHERE EmployeeID = 7;  

SELECT 
    e.FullName AS EmployeeName,
    m.FullName AS ManagerName
FROM 
    project e
LEFT JOIN 
    project m ON e.ManagerID = m.EmployeeID;
-- Question 7 . DDL Commands: Create, Alter, Rename
CREATE TABLE facility (
    Facility_ID INT,
    Name VARCHAR(25),
    State VARCHAR(25),
    Country VARCHAR(25)
);
ALTER TABLE facility
MODIFY Facility_ID INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE facility
ADD City VARCHAR(255) NOT NULL AFTER Name;

-- Question 8 . Views in SQL
CREATE VIEW product_category_sales AS
SELECT 
    pl.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM 
    productlines pl
JOIN 
    products p ON pl.productLine = p.productLine
JOIN 
    orderdetails od ON p.productCode = od.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    pl.productLine;

-- Question 9 Stored Procedures in SQL with parameters

DELIMITER //

CREATE PROCEDURE Get_country_payments (
    IN input_year INT,
    IN input_country VARCHAR(50)
)
BEGIN
    SELECT 
        YEAR(p.paymentDate) AS year,
        c.country,
        FORMAT(SUM(p.amount), 0) AS total_amount_k
    FROM 
        Customers c
    JOIN 
        Payments p ON c.customerNumber = p.customerNumber
    WHERE 
        YEAR(p.paymentDate) = input_year
        AND c.country = input_country
    GROUP BY 
        YEAR(p.paymentDate), c.country;
END //

DELIMITER ;

-- Question 10 Window functions - Rank, dense_rank, lead and lag
-- 10(a) Using customers and orders tables, rank the customers based on their order frequency

SELECT 
    c.customerName,
    COUNT(o.orderNumber) AS order_count,
    DENSE_RANK() OVER (ORDER BY COUNT(o.orderNumber) DESC) AS order_frequency_rank
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customerNumber = o.customerNumber
GROUP BY 
    c.customerName
ORDER BY 
    order_count DESC;
    
-- 10(b) Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.

SELECT @@sql_mode;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));


WITH MonthlyOrderCounts AS (
    SELECT 
        YEAR(orderDate) AS order_year,
        MONTH(orderDate) AS order_month,
        MONTHNAME(orderDate) AS month_name,
        COUNT(orderNumber) AS order_count
    FROM 
        orders
    GROUP BY 
        YEAR(orderDate), MONTH(orderDate)
),
YoYChange AS (
    SELECT 
        current.order_year,
        current.order_month,
        current.month_name,
        current.order_count,
        COALESCE(
            ROUND(
                (current.order_count - COALESCE(previous.order_count, 0)) * 100.0 / NULLIF(previous.order_count, 0), 0
            ), 0
        ) AS YoY_percentage
    FROM 
        MonthlyOrderCounts current
    LEFT JOIN 
        MonthlyOrderCounts previous 
        ON current.month_name = previous.month_name 
        AND current.order_year = previous.order_year + 1
)

SELECT 
    m.order_year,
    m.month_name,
    m.order_count,
    COALESCE(CONCAT(y.YoY_percentage, '%'), '0%') AS YoY_percentage
FROM 
    MonthlyOrderCounts m
LEFT JOIN 
    YoYChange y ON m.order_year = y.order_year AND m.month_name = y.month_name
ORDER BY 
    m.order_year, m.order_month;
    
    
-- Question - 11 Subqueries and their applications
/* Find out how many product lines are there for which the buy price value is greater than the average of buy price value.
 Show the output as product line and its count.*/

SELECT 
    pl.productLine AS productline,
    COUNT(p.productCode) AS total
FROM 
    productlines pl
JOIN 
    products p ON pl.productLine = p.productLine
WHERE 
    p.buyPrice > (SELECT AVG(buyPrice) FROM products)
GROUP BY 
    pl.productLine
    
/* Question 12 ERROR HANDLING in SQL
Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept.
 Show the message as “Error occurred” in case of anything wrong. */


CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    EmailAddress VARCHAR(100)
);

DELIMITER //

CREATE PROCEDURE AddEmployee (
    IN empID INT,
    IN empName VARCHAR(50),
    IN emailAddress VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN

        SELECT 'Error occurred' AS ErrorMessage;
    END;

    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (empID, empName, emailAddress);
END //

DELIMITER ;

-- Question 13 TRIGGERS Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.

CREATE TABLE Emp_BIT (
    Name VARCHAR(50),
    Occupation VARCHAR(50),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

DELIMITER //

CREATE TRIGGER before_insert_emp_bit
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = -NEW.Working_hours;
    END IF;
END //

DELIMITER ;



