-- Day 14 – Core SQL Consolidation (Joins + Aggregates + Subqueries)
--
-- This file focuses on:
-- - Revising JOINs with confidence
-- - Combining JOINs with GROUP BY
-- - Using subqueries where they are actually needed
-- - Writing clean, interview-ready SQL
--
-- Tables used: employees, departments


USE daily_sql;

-- Q1. Display employee name, salary, and department name.
--     Use an appropriate JOIN.
SELECT 
    e.name,
    e.salary,
    d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;


-- Q2. Display all departments and the number of employees in each department.
--     Include departments with zero employees.
SELECT 
    d.department_name,
    COUNT(e.emp_id) AS employee_count
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name;


-- Q3. Find departments whose average salary is greater than 60,000.
--     Display department_id and average salary.
SELECT 
    department_id,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 60000;


-- Q4. Find employees who earn more than the average salary of their department.
--     (Correlated subquery expected)
SELECT 
    name,
    salary,
    department_id
FROM employees e
WHERE salary >
(
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);


-- Q5. Find the department(s) with the highest average salary.
--     Do NOT use LIMIT.
SELECT 
    department_id,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) =
(
    SELECT MAX(avg_salary)
    FROM
    (
        SELECT AVG(salary) AS avg_salary
        FROM employees
        GROUP BY department_id
    ) t
);


-- Q6. Find employees who do not belong to any department.
--     (department_id exists in employees but not in departments)
SELECT 
    e.name,
    e.department_id
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_id IS NULL;


-- Q7. Display department name and total salary expense.
--     Include departments with no employees.
SELECT 
    d.department_name,
    COALESCE(SUM(e.salary), 0) AS total_salary
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name;


-- Q8. Find employees who earn the same salary as another employee
--     but work in the same department.
SELECT 
    e1.name,
    e1.salary,
    e1.department_id
FROM employees e1
JOIN employees e2
ON e1.department_id = e2.department_id
AND e1.salary = e2.salary
AND e1.emp_id <> e2.emp_id;


-- Q9. Find departments that have more than 3 employees
--     and an average salary greater than the company average.
SELECT 
    department_id
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 3
AND AVG(salary) >
(
    SELECT AVG(salary)
    FROM employees
);


-- Q10. Write ONE query twice:
--      1) Using JOIN
--      2) Using subquery
--      Add comments explaining which approach is clearer
--      and why you would choose it in real projects.
SELECT 
    e.name,
    d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;

-- WHY JOIN IS CLEARER:
-- 1. Relationships are explicit
-- 2. Easier to read and debug
-- 3. Better performance in real-world databases
-- 4. Preferred by interviewers and production teams
