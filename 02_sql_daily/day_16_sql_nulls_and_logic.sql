-- Day 16 – Core SQL Depth: Logic, NULLs & Interview Traps
--
-- This file focuses on:
-- - Handling NULLs correctly
-- - Understanding WHERE vs HAVING
-- - EXISTS vs IN pitfalls
-- - Writing logically correct SQL under edge cases
--
-- Tables used: employees, departments


USE daily_sql;

-- Q1. Find all employees whose department_id is NULL.
--     Explain in comments why "=" does not work with NULL.
SELECT *
FROM employees
WHERE department_id IS NUll;

-- Q2. Find all employees who do NOT belong to any department.
--     (department_id exists in employees but not in departments)
SELECT *
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM departments d
    WHERE d.department_name = e.department
);

-- Q3. Find departments that have NO employees.
--     Be careful with JOIN + WHERE conditions.
SELECT e.department_id
FROM employees e
LEFT JOIN departments d
	ON e.department_id = d.department_id
WHERE e.department_id IS NULL;

-- Q4. Find employees whose salary is greater than the average salary
--     of the company.
--     (Simple subquery – focus on correctness, not speed)
SELECT * FROM employees
WHERE salary > (
	SELECT AVG(salary)
    FROM employees
);

-- Q5. Find employees whose salary is NOT NULL
--     and greater than 50,000.
SELECT *
FROM employees
WHERE salary IS NOT NULL 
	AND salary > 50000;

-- Q6. Find departments where the average salary is greater than 60,000.
--     Explain in comments why this condition must go in HAVING,
--     not WHERE.
SELECT department
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;
-- HAVING is used instead of WHERE because AVG(salary) is an aggregate function.
-- WHERE filters individual rows before GROUP BY is applied.
-- Aggregate functions are calculated only after grouping,
-- so conditions on aggregate results must be written in HAVING.

-- Q7. Find employees who earn the same salary as someone else.
--     Ensure employees are not matched with themselves.
SELECT DISTINCT e1.*
FROM employees e1
JOIN employees e2
	ON e1.salary = e2.salary
    AND e1.emp_id != e2.emp_id;

-- Q8. Find employees who earn more than ALL employees
--     in department_id = 2.
--     Explain in comments what happens if the subquery returns NULL.
-- We compare each employee's salary with ALL salaries
-- of employees in department_id = 2
SELECT *
FROM employees
WHERE salary > ALL (
    SELECT salary
    FROM employees
    WHERE department_id = 2
      AND salary IS NOT NULL
);


-- Q9. Rewrite Q8 using a safer approach
--     (avoid ALL, use aggregate logic instead).
SELECT *
FROM employees
WHERE salary > (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = 2
);

-- Q10. Interview Reflection (SQL comments only):
--      - One NULL-related mistake beginners make
--      - One EXISTS / IN mistake you now avoid
--      - One SQL habit you consciously improved today

-- NULL-related mistake:
-- Using = NULL or != NULL instead of IS NULL / IS NOT NULL,
-- which always results in UNKNOWN and filters out rows incorrectly.

-- EXISTS / IN mistake:
-- Using NOT IN with a subquery that can return NULL,
-- which causes the entire condition to evaluate to UNKNOWN.
-- I now prefer NOT EXISTS for safe, NULL-aware logic.

-- SQL habit improved:
-- Always confirming table schema and column names
-- before writing JOIN or subquery conditions,
-- instead of assuming column names.