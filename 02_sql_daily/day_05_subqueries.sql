-- Day 05 – SQL Subqueries Practice
--
-- This file contains SQL queries focused on:
-- - Scalar subqueries
-- - Correlated subqueries
-- - Subqueries with aggregate functions
-- - Nested subqueries for analytical queries
--
-- Table used: employees


USE daily_sql;
-- Q1. Find employees whose salary is greater than the average salary.
SELECT * FROM employees 
WHERE salary>(
	SELECT AVG(salary) 
    FROM employees
    );
	
-- Q2. Find employees who earn the maximum salary in the company.
SELECT *  FROM employees
WHERE salary = (
	SELECT MAX(salary)
    FROM employees
    );

-- Q3. Find employees who earn more than the average salary of their department.
SELECT * FROM employees
WHERE salary>(
	SELECT AVG(salary)
    FROM employees
    WHERE department = employees.department
    );

-- Q4. Find departments where the average salary is greater than the overall average salary.
SELECT department FROM employees
 GROUP BY department 
 HAVING AVG(salary)>(
	SELECT AVG(salary) 
    FROM employees
    );

-- Q5. Find the second highest salary in the company using a subquery.
SELECT MAX(salary) FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);

-- Q6. Find employees who belong to departments having more than 5 employees.
SELECT * FROM employees
WHERE department IN (
	SELECT department
    FROM employees
    GROUP BY department 
    HAVING COUNT(*) > 5
    );

-- Q7. Find employees whose salary is less than the average salary of the Finance department.
SELECT * FROM employees
WHERE salary < (
	SELECT AVG(salary) 
    FROM employees
    WHERE department = 'Finance'
    );

-- Q8. Find the department(s) with the highest total salary.
SELECT department FROM employees GROUP BY department 
HAVING SUM(salary) = (
    SELECT MAX(total_salary)
    FROM (
        SELECT SUM(salary) AS total_salary
        FROM employees
        GROUP BY department
    ) t
);

-- Q9. Find employees who earn the minimum salary in their department.
SELECT * FROM employees e
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
    WHERE department = e.department
);

-- Q10. Find employees who earn more than the average salary of the highest-paying department.
SELECT * FROM employees
WHERE salary > (
    SELECT MAX(dept_avg)
    FROM (
        SELECT AVG(salary) AS dept_avg
        FROM employees
        GROUP BY department
    ) t
);