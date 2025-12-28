-- Day 02 – SQL ORDER BY & LIMIT Practice
--
-- This file contains SQL queries focused on:
-- - Sorting data using ORDER BY
-- - Limiting results using LIMIT
-- - Filtering combined with sorting
--
-- Table used: employees



USE daily_sql;
-- Q1  Retrieve all employees sorted by age in ascending order.
SELECT * FROM employees ORDER BY age ASC;

-- Q2  Retrieve all employees sorted by salary in descending order.
SELECT * FROM employees ORDER BY salary DESC;

-- Q3  Retrieve the top 5 highest-paid employees.
SELECT * FROM employees ORDER BY salary DESC LIMIT 5;

-- Q4  Retrieve the top 3 youngest employees.
SELECT * FROM employees ORDER BY age ASC LIMIT 3;

-- Q5  Find employees whose salary is greater than 60,000 and sort them by salary descending.
SELECT * FROM employees WHERE salary > 60000  ORDER BY salary DESC;  

-- Q6  Retrieve employees from Engineering or Data Science departments.
SELECT * FROM employees WHERE department in ('Engineering','Data Science');

-- Q7  Retrieve employees whose age is less than 30 and sort by age.
SELECT * FROM employees WHERE age<30 ORDER BY age ASC;

-- Q8  Retrieve employees whose salary is between 50,000 and 70,000, sorted by salary.
SELECT * FROM employees WHERE salary BETWEEN 50000 AND 70000 ORDER BY salary ASC;

-- Q9  Retrieve the first 5 employees when sorted alphabetically by name.
SELECT * FROM employees ORDER BY name LIMIT 5;

-- Q10  Retrieve the second highest salary using ORDER BY and LIMIT.
SELECT * FROM employees ORDER BY salary DESC LIMIT 1,1;