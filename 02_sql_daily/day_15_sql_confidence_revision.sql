-- Day 15 – Core SQL Confidence & Logic Revision
--
-- This file focuses on:
-- - Reinforcing core SQL confidence
-- - Revising joins, aggregates, and filters
-- - Avoiding common interview mistakes
-- - Writing clean, readable SQL
--
-- Tables used: employees, departments


USE daily_sql;

-- Q1. Display employee name, salary, and department name.
--     Use an INNER JOIN.
SELECT e.name,e.salary,e.department 
FROM employees e
INNER JOIN departments d
  ON e.department = d.department_name;

-- Q2. Display all employees and their department names.
--     Include employees who do not belong to any department.
SELECT e.emp_id,e.name,d.department_name
FROM employees e
LEFT JOIN departments d 
  ON e.department_id = d.department_id;

-- Q3. Display all departments and the number of employees in each.
--     Include departments with zero employees.
SELECT 
    d.department_name,
    COUNT(e.emp_id) AS emp_count
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Q4. Find employees who earn more than the average salary of the company.
SELECT * FROM employees
WHERE salary > (
	SELECT AVG(salary) 
    FROM employees
);

-- Q5. Find employees who earn less than the average salary of their department.
--     (Correlated subquery expected)
SELECT * FROM employees
WHERE salary < (
	SELECT AVG(salary)
    FROM employees
);

-- Q6. Find departments that have more than 3 employees.
SELECT department
 FROM employees
 GROUP BY department
 HAVING COUNT(*) > 3;
 
-- Q7. Find departments whose average salary is greater than 60,000.
SELECT department
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;

-- Q8. Find employees who work in departments
--     where at least one employee earns more than 80,000.
SELECT * FROM employees
WHERE salary > 80000;

-- Q9. Find employees whose salary is the maximum
--     in their respective department.
SELECT * FROM employees e
WHERE salary = (
	SELECT MAX(salary)
    FROM employees
    WHERE department = e.department
);

-- Q10. Interview Reflection (write as SQL comments):
--      - One common JOIN mistake you now avoid
--      - One aggregate-related mistake beginners make
--      - One SQL habit you improved during Days 8–15

-- 1) One common JOIN mistake I now avoid:
--    Using INNER JOIN by default without thinking about missing matches.
--    I now consciously choose LEFT JOIN when the requirement says
--    “include all records from the main table” (e.g., departments with zero employees).

-- 2) One aggregate-related mistake beginners make:
--    Using aggregate functions in the WHERE clause or comparing
--    non-aggregated columns in HAVING.
--    I now clearly separate:
--    WHERE  -> row-level filtering
--    HAVING -> group-level filtering after aggregation.

-- 3) One SQL habit I improved during Days 8–15:
--    I first translate the question into plain English logic
--    (base table, join type, grouping, filtering),
--    then write SQL step by step instead of trial-and-error queries.
