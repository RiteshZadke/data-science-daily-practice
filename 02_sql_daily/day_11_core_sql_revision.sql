-- Day 11 – Core SQL Revision & Interview Logic
--
-- This file focuses on:
-- - Revising core SQL concepts
-- - Mixing filters, joins, subqueries
-- - Identifying common interview traps
-- - Writing clean, readable SQL
--
-- Tables used: employees, departments


USE daily_sql;

-- Q1. Find employees who earn more than the average salary of the company.
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- Q2. Find employees who earn less than the average salary of their department.
--     (Correlated subquery expected)
SELECT *
FROM employees e
WHERE salary < (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- Q3. Display department name and employee name.
--     Include departments even if they have no employees.
SELECT d.department_name, e.name
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id;


-- Q4. Find departments that have at least one employee earning more than 75,000.
SELECT DISTINCT d.department_name
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
WHERE e.salary > 75000;


-- Q5. Find employees who do NOT belong to any department.
--     (department_id exists in employees but not in departments)
SELECT *
FROM employees e
WHERE department_id NOT IN (
    SELECT department_id
    FROM departments
);


-- Q6. Find the department(s) with the highest average salary.
--     Do NOT use LIMIT.
SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) = (
    SELECT MAX(avg_salary)
    FROM (
        SELECT AVG(salary) AS avg_salary
        FROM employees
        GROUP BY department_id
    ) t
);

-- Q7. Find employees who earn the same salary as another employee
--     but work in a different department.
SELECT DISTINCT e1.*
FROM employees e1
JOIN employees e2
ON e1.salary = e2.salary
AND e1.department_id <> e2.department_id;

-- Q8. Find departments that have more than 3 employees
--     AND an average salary greater than 60,000.
SELECT department_id
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 3
AND AVG(salary) > 60000;

-- Q9. For each department, find the minimum salary.
--     Include departments with no employees.
SELECT d.department_name, MIN(e.salary) AS min_salary
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name;


-- Q10. Write ONE query and add comments explaining:
--      - Why you used JOIN instead of subquery
--        OR
--      - Why you used subquery instead of JOIN
--      (Focus on clarity and correctness)
SELECT d.department_name, COUNT(e.emp_id) AS employee_count
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name;


-- JOIN is clearer and more efficient when:
-- 1. We need columns from BOTH tables
-- 2. We want to include departments with zero employees
-- 3. Aggregation (COUNT) is required
-- A subquery would be harder to read and less optimal here.
