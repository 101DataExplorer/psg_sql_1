-- 							Employee Table

CREATE TABLE Employee (
EmpID int NOT NULL,
EmpName Varchar,
Gender Char,
Salary int,
City Char(20) )

--- first run the above code then below code
INSERT INTO Employee
VALUES (1, 'Arjun', 'M', 75000, 'Pune'),
(2, 'Ekadanta', 'M', 125000, 'Bangalore'),
(3, 'Lalita', 'F', 150000 , 'Mathura'),
(4, 'Madhav', 'M', 250000 , 'Delhi'),
(5, 'Visakha', 'F', 120000 , 'Mathura')

SELECT * FROM employee;


-- 							EmployeeDetail Table

CREATE TABLE EmployeeDetail (
EmpID int NOT NULL,
Project Varchar,
EmpPosition Char(20),
DOJ date )

--- first run the above code then below code
INSERT INTO EmployeeDetail
VALUES (1, 'P1', 'Executive', '2019-01-26'),
(2, 'P2', 'Executive', '2020-05-04'),
(3, 'P1', 'Lead', '2021-10-21'),
(4, 'P3', 'Manager', '2019-11-29'),
(5, 'P2', 'Manager', '2020-08-01')

SELECT * FROM EmployeeDetail;