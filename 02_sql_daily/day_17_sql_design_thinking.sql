-- Day 17 – Core SQL Design Thinking & Query Choice
--
-- This file focuses on:
-- - Choosing JOIN vs subquery correctly
-- - EXISTS vs IN decision making
-- - Avoiding over-complex SQL
-- - Writing readable, maintainable queries
--
-- Tables used: employees, departments


USE daily_sql;

-- Q1. Display employee name and department name.
--     Solve this using:
--     a) JOIN
--     b) Subquery
--     Add comments explaining which version is clearer and why.
-- a) JOIN---------------------------------
SELECT e.name AS employee_name,
d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;
-- d) Subquery ---------------------------------------------

SELECT name AS employees_name,
 (
        SELECT department_name
        FROM departments d
        WHERE d.department_id = e.department_id
    ) AS department_name
FROM employees e;
-- JOIN is clearer than a subquery because it explicitly shows
-- how tables are related and is easier to read, maintain, and optimize.

-- Q2. Find employees who earn more than the average salary
--     of their department.
--     Write the query in the cleanest possible way.
SELECT e.* FROM employees e
WHERE e.salary > (
	SELECT AVG(e2.salary) 
    FROM employees e2
    WHERE e.department_id = e2.department_id
);

-- Q3. Find departments that have at least one employee
--     earning more than 90,000.
--     Solve using EXISTS (preferred).
SELECT d.department_id,
d.department_name 
FROM departments d
WHERE EXISTS (
	SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
    AND e.salary > 90000
);

-- Q4. Rewrite Q3 using IN.
--     Add comments explaining which approach you would
--     choose in real projects and why.
SELECT d.department_id,
d.department_name
FROM departments d
WHERE d.department_id IN (
	SELECT DISTINCT e.department_id
    FROM employees e
    WHERE e.salary > 90000
);

-- REAL PROJECT CHOICE:
-- I would choose EXISTS over IN in real projects.
--
-- WHY EXISTS IS BETTER:
-- 1. EXISTS stops checking as soon as one matching row is found
-- 2. IN may scan and store many values internally
-- 3. EXISTS handles large datasets more efficiently
-- 4. EXISTS is safer when NULLs are involved
-- 5. EXISTS reads more naturally for "at least one" conditions


-- Q5. Find employees who do not belong to any department.
--     Solve using LEFT JOIN + NULL check.
SELECT e.*
FROM employees e
LEFT JOIN departments d
  ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

-- Q6. Rewrite Q5 using NOT EXISTS.
--     Explain in comments why NOT EXISTS is often safer
--     than NOT IN.
SELECT e.*
FROM employees e
WHERE NOT EXISTS(
	SELECT 1
    FROM departments d
    WHERE e.department_id = d.department_id
);

-- WHY NOT EXISTS IS SAFER THAN NOT IN:
--
-- 1. NOT EXISTS handles NULL values correctly
--    If e.department_id is NULL, NOT EXISTS still works as expected
--
-- 2. NOT IN fails when the subquery returns NULL
--
-- 3. NOT EXISTS uses correlation and checks row-by-row logic,
--    making the intent clearer and safer
--
-- 4. NOT EXISTS scales better and avoids hidden NULL pitfalls

-- Q7. Find departments whose average salary is higher
--     than the company average salary.
SELECT department 
FROM employees
GROUP BY department
HAVING AVG(salary)>(
	SELECT AVG(salary)
    FROM employees
);

-- Q8. Find employees whose salary is the maximum
--     in their department.
--     Avoid window functions.
SELECT e.* 
FROM employees e
WHERE e.salary = (
	SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e.department_id = e2.department_id
);

-- Q9. Over-Engineering Check
--     Take ANY ONE of the above queries and:
--     - first write an over-complicated version
--     - then write a simplified version
--     Explain in comments why simpler SQL is better.
-- Q9. Over-Engineering Check
-- Problem chosen:
-- Find employees who do not belong to any department


--  OVER-COMPLICATED VERSION (unnecessary complexity)

SELECT e.*
FROM employees e
WHERE e.department_id NOT IN (
    SELECT d.department_id
    FROM departments d
    WHERE d.department_id IS NOT NULL
)
AND e.department_id IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.department_id = e.department_id
      AND e2.emp_id <> e.emp_id
);

-- Why this is bad:
-- 1. Mixes NOT IN and NOT EXISTS without need
-- 2. Adds redundant NULL checks
-- 3. Harder to read and reason about
-- 4. Increases chances of logical bugs
-- 5. Does not communicate intent clearly


-- ✅ SIMPLIFIED VERSION (preferred)

SELECT e.*
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

-- Why simpler SQL is better:
-- 1. Logic matches the question directly
-- 2. Easier to read and maintain
-- 3. Fewer moving parts = fewer bugs
-- 4. Clear intent is visible at a glance
-- 5. Interviewers and real projects prefer clarity over cleverness


-- Q10. SQL Reflection (comments only):
--      - One SQL construct you now use more confidently
--      - One construct you will avoid misusing
--      - One mindset change you experienced by Day 17

-- One SQL construct I now use more confidently:
-- EXISTS / NOT EXISTS, because I understand how correlation works
-- and why it is safer and more scalable than IN / NOT IN.

-- One construct I will avoid misusing:
-- NOT IN, because NULL values in subqueries can silently break logic.

-- One mindset change by Day 17:
-- I now prioritize clarity and correctness over writing clever or complex SQL.
-- I think in terms of intent first, syntax second.
