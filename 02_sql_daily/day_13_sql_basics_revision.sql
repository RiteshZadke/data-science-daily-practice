-- Day 13 – Core SQL Basics Revision
--
-- This file focuses on:
-- - Revising SELECT, WHERE, ORDER BY
-- - Practicing GROUP BY and HAVING
-- - Reinforcing aggregate functions
-- - Strengthening core SQL thinking
--
-- Tables used: employees, departments


USE daily_sql;

-- Q1. Display all employees.
--     Show emp_id, emp_name, salary, department_id.
SELECT emp_id,name,salary,department_id FROM employees;

-- Q2. Display employees whose salary is greater than 50,000.
SELECT * FROM employees WHERE salary > 50000;

-- Q3. Display employees whose salary is between 40,000 and 70,000.
SELECT * FROM employees WHERE salary BETWEEN 40000 AND 70000;

-- Q4. Display employees who do NOT belong to any department
--     (department_id is NULL).
SELECT * FROM employees WHERE department = NULL;

-- Q5. Display employees ordered by salary in descending order.
SELECT * FROM employees ORDER BY salary DESC;

-- Q6. Find the total number of employees in the company.
SELECT COUNT(*) AS total_employees FROM employees;

-- Q7. Find the average salary of all employees.
SELECT AVG(salary) FROM employees;

-- Q8. Find department-wise employee count.
--     Display department_id and employee count.
SELECT COUNT(*) AS total_employees,department_id FROM employees GROUP BY department_id;

-- Q9. Find departments having more than 3 employees.
SELECT department FROM employees GROUP BY department HAVING COUNT(*) > 3;

-- Q10. Find department-wise average salary
--      and display only departments where
--      average salary is greater than 60,000.
SELECT department FROM employees GROUP BY department HAVING AVG(salary) > 60000;