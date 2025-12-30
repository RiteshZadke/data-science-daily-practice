-- Day 04 – SQL GROUP BY & HAVING Practice
--
-- This file contains SQL queries focused on:
-- - Grouping data using GROUP BY
-- - Applying aggregate functions on grouped data
-- - Filtering grouped results using HAVING
-- - Writing clean and readable aggregation queries
--
-- Table used: employees


USE daily_sql;

-- Q1. Find the number of employees in each department.
SELECT department,COUNT(*) AS total_employees FROM employees GROUP BY department; 

-- Q2. Find the average salary per department.
SELECT department,AVG(salary) AS avg_salary FROM employees GROUP BY department;

-- Q3. Find the maximum salary in each department.
SELECT department,MAX(salary) AS max_salary FROM employees GROUP BY department;

-- Q4. Find departments having more than 5 employees.
SELECT department FROM employees GROUP BY department HAVING COUNT(*) > 5;

-- Q5. Find departments where the average salary is greater than 60,000.
SELECT department FROM employees GROUP BY department HAVING AVG(salary) > 60000;

-- Q6. Find the minimum age per department.
SELECT department,MIN(age) AS min_age FROM employees GROUP BY department;

-- Q7. Count employees in each department and sort by count descending.
SELECT department,COUNT(*) AS total_employees FROM employees GROUP BY department ORDER BY total_employees DESC;

-- Q8. Find departments where the total salary exceeds 300,000.
SELECT department FROM employees GROUP BY department HAVING SUM(salary) > 300000;

-- Q9. Find the department with the highest average salary.
SELECT department FROM employees GROUP BY department ORDER BY AVG(salary) DESC LIMIT 1;

-- Q10. Find departments that have at least one employee earning more than 75,000.
SELECT department FROM employees GROUP BY department HAVING MAX(salary) > 75000;