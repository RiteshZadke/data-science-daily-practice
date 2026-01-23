-- Day 18 – Core SQL Depth: Equivalent Logic, Different Constructs
--
-- This file focuses on:
-- - Solving the same problem using different SQL approaches
-- - JOIN vs EXISTS vs IN tradeoffs
-- - Readability vs performance vs correctness
-- - Interview-style reasoning about SQL choices
--
-- Tables used: employees, departments


USE daily_sql;

-- Q1. Display employee name and department name.
--     Solve using:
--     a) INNER JOIN
--     b) Correlated subquery
--     Add comments explaining which is clearer and why.
SELECT 
  e.name,
  d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.department_id;
  -- COMMENT:
-- This is the clearest and most readable approach.
-- The relationship between employees and departments
-- is explicit in the JOIN condition.
-- Easy to debug, easy to optimize, interview-preferred.


SELECT 
	e.name,
    (
		SELECT d.department_name
        FROM departments d
        WHERE e.department_id = d.department_id
    ) AS department_name
FROM employees e;

-- COMMENT:
-- This works logically, but readability is lower.
-- The relationship is hidden inside a subquery.
-- Harder to extend and reason about for complex queries.


-- Q2. Find employees who earn more than the company average salary.
--     Solve using a scalar subquery.
SELECT * 
FROM employees
WHERE salary > (
	SELECT AVG(salary)
    FROM employees
);

-- Q3. Rewrite Q2 using a JOIN-based approach
--     (JOIN with a derived table containing company average).
--     Explain in comments which approach you prefer.
SELECT
	e.*
FROM employees e
JOIN (
	SELECT AVG(salary) AS avg_salary
    FROM employees
) a
ON e.salary > a.avg_salary;

-- COMMENT:
-- I prefer the scalar subquery approach from Q2:
--   WHERE salary > (SELECT AVG(salary) FROM employees)
-- because it is shorter, more readable,
-- and directly expresses the intent.
-- JOIN-based approach is better when
-- multiple aggregated columns are required.


-- Q4. Find departments that have at least one employee
--     earning more than 85,000.
--     Solve using EXISTS.
SELECT 
	d.department_id,
    d.department_name
FROM departments d
WHERE EXISTS (
	SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
    AND salary > 85000
);

-- Q5. Rewrite Q4 using IN.
--     Add comments explaining potential risks of IN
--     when NULL values are involved.
SELECT
	department_id,
    department
FROM employees 
WHERE department_id IN (
	SELECT department_id
    FROM employees
    WHERE salary > 85000
);
-- COMMENT:
-- IN works by checking if department_id matches
-- any value returned by the subquery.
--
-- POTENTIAL RISK WITH NULLs:
-- If the subquery returns NULL values,
-- comparisons may behave unexpectedly.
-- In NOT IN cases, a single NULL can cause
-- the entire condition to return no rows.
--
-- Because of this, EXISTS is generally safer
-- and preferred for existence checks.

-- Q6. Find employees who do not belong to any department.
--     Solve using LEFT JOIN + NULL check.
SELECT e.*
FROM employees e
LEFT JOIN departments d
	ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

-- Q7. Rewrite Q6 using NOT EXISTS.
--     Explain in comments why NOT EXISTS is often safer
--     than NOT IN.
SELECT e.*
FROM employees e
WHERE NOT EXISTS (
	SELECT 1
    FROM departments d
    WHERE d.department_id = e.department_id
);
-- WHY NOT EXISTS IS SAFER THAN NOT IN:
-- NOT IN fails when the subquery returns even a single NULL,
-- because comparisons with NULL result in UNKNOWN.
-- This can cause the query to return zero rows unexpectedly.
--
-- NOT EXISTS does not suffer from NULL-related issues
-- and gives correct, predictable results.
-- Hence, NOT EXISTS is preferred in real-world SQL.
	

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

-- Q9. Find departments whose average salary is greater
--     than the company average salary.
--     Use GROUP BY + HAVING.
SELECT
    d.department_id,
    d.department_name
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY
    d.department_id,
    d.department_name
HAVING AVG(e.salary) >
       (SELECT AVG(salary) FROM employees);

-- Q10. SQL Reflection (comments only):
--      - One SQL construct you now use interchangeably
--      - One construct you choose carefully after Day 18
--      - One readability improvement you consciously make

-- One SQL construct I now use interchangeably:
-- JOIN and EXISTS (when checking related-row presence)

-- One construct I choose carefully after Day 18:
-- NOT IN (due to NULL-related bugs)

-- One readability improvement I consciously make:
-- Always align query structure with intent
-- (JOIN for relationships, EXISTS for existence checks)