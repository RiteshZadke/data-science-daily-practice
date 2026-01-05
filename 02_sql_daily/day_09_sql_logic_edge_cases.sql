-- Day 09 – Core SQL Logic & Edge Case Handling
--
-- This file focuses on:
-- - Applying known subqueries in complex logic
-- - Comparison operators (IN, ANY, ALL)
-- - EXISTS vs IN
-- - Avoiding logical mistakes in SQL
--
-- Tables used: employees, departments

USE daily_sql;
-- Q1. Find employees whose salary is greater than at least one employee in another department.
SELECT * FROM employees e
WHERE salary > ANY (
	SELECT salary 
    FROM employees
    WHERE department_id <> e.department_id
    );

-- Q2. Find employees whose salary is greater than all employees in department_id = 1.
SELECT *
FROM employees
WHERE salary > ALL (
	SELECT salary
	FROM employees
	WHERE department_id = 1
);


-- Q3. Find employees who do not earn the maximum salary in their department.
SELECT *
FROM employees e
WHERE salary < (
	SELECT MAX(salary)
	FROM employees
	WHERE department_id = e.department_id
);

-- Q4. Find departments where no employee earns more than 70,000.
SELECT DISTINCT department_id
FROM employees e
WHERE 70000 >= ALL (
    SELECT salary
    FROM employees
    WHERE department_id = e.department_id
);

-- Q5. Find employees who work in departments that have at least one employee earning above 80,000.
SELECT * FROM employees e
WHERE EXISTS(
	SELECT 1
    FROM employees
    WHERE department_id = e.department_id
	 AND salary > 80000
    );

-- Q6. Find departments that have employees earning the same salary.
SELECT DISTINCT e1.department_id
FROM employees e1
JOIN employees e2
  ON e1.department_id = e2.department_id
 AND e1.salary = e2.salary
 AND e1.emp_id <> e2.emp_id;

-- Q7. Find employees whose salary is not unique in the company.
SELECT DISTINCT e1.*
FROM employees e1
JOIN employees e2
  ON e1.salary = e2.salary
 AND e1.emp_id <> e2.emp_id;
 
-- Q8. Find departments whose average salary is higher than company average
SELECT DISTINCT department_id
FROM employees e
GROUP BY department_id
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);

-- Q9. Find employees who belong to departments having more than 3 employees.
SELECT *
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM employees
    WHERE department_id = e.department_id
    GROUP BY department_id
    HAVING COUNT(*) > 3
);


-- Q10. Explain (in SQL comments):
-- When to use IN
-- When to use EXISTS
-- Why ALL is risky

-- ================================
-- WHEN TO USE IN
-- ================================
-- Use IN when:
-- 1) The subquery returns a SMALL, FIXED, or STATIC list of values.
-- 2) You want simple, readable SQL.
-- 3) The subquery is NOT correlated (does not depend on outer query).
-- Example:
--   SELECT *
--   FROM employees
--   WHERE department_id IN (
--       SELECT department_id
--       FROM employees
--       WHERE salary > 80000
--   );
-- Meaning:
--   First get the list of departments, then match employees against that list.


-- ================================
-- WHEN TO USE EXISTS
-- ================================
-- Use EXISTS when:
-- 1) The subquery is CORRELATED (uses columns from outer query).
-- 2) You only care whether at least ONE row exists (true/false check).
-- 3) The subquery may return many rows (EXISTS stops at first match).
-- Example:
--   SELECT *
--   FROM employees e
--   WHERE EXISTS (
--       SELECT 1
--       FROM employees
--       WHERE department_id = e.department_id
--         AND salary > 80000
--   );
-- Meaning:
--   For each employee, check if there exists
--   at least one employee in the same department earning > 80000.


-- ================================
-- WHY ALL IS RISKY
-- ================================
-- ALL compares a value against EVERY value returned by a subquery.
-- It is risky because:
-- 1) If the subquery returns NULL, the comparison can become UNKNOWN.
-- 2) Logic becomes unintuitive and easy to misread.
-- 3) One unexpected value can flip the entire condition.
-- Example:
--   salary > ALL (
--       SELECT salary
--       FROM employees
--       WHERE department_id = 10
--   );
-- Meaning:
--   salary must be greater than the MAX salary in department 10.
-- If ANY NULL exists in subquery -> result may be incorrect.
-- In interviews and production SQL, EXISTS or GROUP BY + HAVING
-- are safer and clearer than ALL.

