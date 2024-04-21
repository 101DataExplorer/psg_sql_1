SELECT * FROM employee;
SELECT * FROM EmployeeDetail;

-- Q1(a): Find the list of employees whose salary ranges between 2L to 3L.

SELECT *
FROM employee
WHERE salary BETWEEN 200000 AND 300000;

-- Q1(b): Write a query to retrieve the list of employees from the same city.

SELECT e1.empid, e1.empname, e1.city
FROM employee e1, employee e2
WHERE e1.city = e2.city AND e1.empid != e2.empid

-- Q1(c): Query to find the null values in the Employee table.

SELECT *
FROM employee
WHERE empid IS NULL;

-- Q2(a): Query to find the cumulative sum of employee’s salary.

SELECT empid, salary, sum(salary) over(order by empid) AS cumulativeSal
FROM employee;

-- Q2(b): What’s the male and female employees ratio.

SELECT
(COUNT(*) FILTER(WHERE gender = 'M') * 100.0 / COUNT(*)) AS maleRatio,
(COUNT(*) FILTER(WHERE gender = 'F') * 100.0 / COUNT(*)) AS femaleRatio
FROM employee;

-- Q2(c): Write a query to fetch 50% records from the Employee table.
SELECT * FROM employee
WHERE empid <= (SELECT COUNT(empid)/2 FROM employee)

-- Q3: Query to fetch the employee’s salary but replace the LAST 2 digits with ‘XX’ i.e 12345 will be 123XX
SELECT * FROM employee

-- REPALCE will be used when whole text needed tobe replaced
			   
SELECT salary, CONCAT(SUBSTRING(salary::text, 1, LENGTH(salary::text)-2),'XX' )
FROM employee;

-- Q4: Write a query to fetch even and odd rows from Employee table.

with cte_row as 
(
SELECT *,
ROW_NUMBER() OVER(ORDER BY empid) AS row_number
FROM employee
)		
SELECT * 
FROM cte_row 
WHERE MOD(row_number,2) != 0;

-- For even rows
SELECT * FROM
	(SELECT *,
	 ROW_NUMBER() OVER(ORDER BY empid) AS RowNumber
	 FROM employee) AS Emp
WHERE MOD(Emp.RowNumber, 2) = 0;

-- For odd rows
SELECT * FROM
	(SELECT *,
	 ROW_NUMBER() OVER(ORDER BY empid) AS RowNumber
	 FROM employee) AS Emp
WHERE MOD(Emp.RowNumber, 2) != 0;

-- Alternative solution

-- for even number rows
SELECT *
FROM employee
WHERE MOD (empid,2) = 0

-- for even number rows
SELECT *
FROM employee
WHERE MOD (empid,2) = 1


-- Q5(a): Write a query to find all the Employee names whose name:
-- • Begin with ‘A’
-- • Contains ‘A’ alphabet at second place
-- • Contains ‘Y’ alphabet at second last place
-- • Ends with ‘L’ and contains 4 alphabets
-- • Begins with ‘V’ and ends with ‘A’

-- Write a query to find all the Employee names whose name:
-- • Begin with ‘A’

SELECT empname
FROM employee
WHERE empname LIKE 'A%';

--  Contains ‘A’ alphabet at second place

SELECT empname
FROM employee
WHERE empname LIKE '_a%';

-- • Contains ‘Y’ alphabet at second last place

SELECT empname
FROM employee
WHERE empname LIKE '%y_';

-- • Ends with ‘L’ and contains 4 alphabets

SELECT empname
FROM employee
WHERE empname LIKE '____L';

-- • Begins with ‘V’ and ends with ‘A’
SELECT empname
FROM employee
WHERE empname LIKE 'v%a';


-- Q5(b): Write a query to find the list of Employee names which is:
-- • starting with vowels (a, e, i, o, or u), without duplicates
-- • ending with vowels (a, e, i, o, or u), without duplicates
-- • starting & ending with vowels (a, e, i, o, or u), without duplicates

-- • starting with vowels (a, e, i, o, or u), without duplicates
SELECT DISTINCT empname
FROM employee
WHERE lower(empname) similar to '[aeiou]%';

-- • ending with vowels (a, e, i, o, or u), without duplicates
SELECT DISTINCT empname
FROM employee
WHERE lower(empname) similar to '%[aeiou]';

-- • starting & ending with vowels (a, e, i, o, or u), without duplicates
SELECT DISTINCT empname
FROM employee
WHERE lower(empname) similar to '[aeiou]%[aeiou]';

-- Q6: Find Nth highest salary from employee table with and without using the
-- TOP/LIMIT keywords.

SELECT * FROM employee;	

SELECT salary
FROM employee e1
WHERE 2 = (SELECT COUNT(DISTINCT(e2.salary))
			FROM employee e2
			WHERE e2.salary > e1.salary);
			
SELECT salary FROM employee
ORDER BY salary DESC 
LIMIT 1 OFFSET N-1


-- Q7(a): Write a query to find and remove duplicate records from a table.
SELECT * FROM employee;
SELECT * FROM EmployeeDetail;
-- e.empid, e.empname, ed.project
select empid, count(empid)
from employee
group by 1
having count(empid) > 1

--  Removing duplicates
-- DELETE FROM Employee
-- WHERE empid IN
-- (SELECT empid FROM Employee
-- GROUP BY empid
-- HAVING COUNT(*) > 1);


-- Q7(b): Query to retrieve the list of employees working in same project.

-- with employee name and id
with cte as(
select e.empid, e.empname, ed.project from employee e
left join EmployeeDetail ed
on e.empid = ed.empid
)

select c1.empid, c1.empname, c1.project
from cte c1, cte c2
where c1.project = c2.project and c1.empid != c2.empid

-- with employee name
with cte as(
select e.empid, e.empname, ed.project from employee e
left join EmployeeDetail ed
on e.empid = ed.empid
)

select c1.empname, c2.empname, c1.project
from cte c1, cte c2
where c1.project = c2.project and c1.empid != c2.empid and c1.empid < c2.empid;


-- Q8: Show the employee with the highest salary for each project
select ed.project, max(e.salary) projSal
from employee e
join EmployeeDetail ed
on e.empid = ed.empid
group by 1
order by projSal desc
;

with cte as(
select ed.project, e.empname, e.salary,
row_number() over(partition by ed.project order by e.salary desc) as row_rank
from employee e
join EmployeeDetail ed
on e.empid = ed.empid
)
select project, empname, salary
from cte
where row_rank = 1;

-- Q9: Query to find the total count of employees joined each year
select e.empid, e.empname, ed.doj, DATE_PART('YEAR',ed.doj) as join_year
from employee e
join EmployeeDetail ed
on e.empid = ed.empid;

select DATE_PART('YEAR',ed.doj) as join_year, count(e.empid) as count_of_employee
from employee e
join EmployeeDetail ed
on e.empid = ed.empid
group by 1;

select extract('YEAR' from ed.doj) as join_year, count(e.empid) as count_of_employee
from employee e
join EmployeeDetail ed
on e.empid = ed.empid
group by 1;

-- Q10: Create 3 groups based on salary col, salary less than 1L is low, between 1 - 2L is medium and above 
-- 2L is High

select salary,
case when salary > 200000 then 'High'
	 when salary between 100000 and 200000 then 'medium'
  	 else 'low'
	 end as salary_range
from employee;

-- Query to pivot the data in the Employee table and retrieve the total salary for each city.
select * from employee;

select city, sum(salary) as total_salary
from employee
group by 1
order by total_salary desc;

select empid, empname,
sum(case when city = 'Mathura' then salary end) as Mathura,
sum(case when city = 'Bangalaore' then salary end) as Bangalaore,
sum(case when city = 'Pune' then salary end) as Pune,
sum(case when city = 'Delhi' then salary end) as Delhi
from employee
group by 1,2;


			