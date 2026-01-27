-- Day 20 – Core SQL Mastery: Safety, Correctness & Judgment
--
-- This file focuses on:
-- - Safe SQL patterns
-- - Handling edge cases correctly
-- - Choosing constructs with least risk
-- - Writing production-grade, interview-ready SQL
--
-- Tables used: employees, departments


USE daily_sql;

-- Q1. Find employees whose salary is greater than
--     the average salary of the company.
--     Write the cleanest and safest version.
SELECT
    e.emp_id,
    e.name,
    e.salary
FROM employees e
WHERE e.salary >
      (
          SELECT AVG(salary)
          FROM employees
      );

-- Q2. Find employees whose salary is greater than
--     the average salary of their department.
--     Use a correlated subquery.
SELECT
    e.emp_id,
    e.name,
    e.department_id,
    e.salary
FROM employees e
WHERE e.salary >
      (
          SELECT AVG(e2.salary)
          FROM employees e2
          WHERE e2.department_id = e.department_id
      );


-- Q3. Find departments that have NO employees.
--     Solve using LEFT JOIN.
--     Be careful to avoid LEFT JOIN + WHERE trap.
SELECT
    d.department_id,
    d.department_name
FROM departments d
LEFT JOIN employees e
       ON d.department_id = e.department_id
WHERE e.department_id IS NULL;

-- Q4. Rewrite Q3 using NOT EXISTS.
SELECT
    d.department_id,
    d.department_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
);


-- Q5. Find employees who do not belong to any department.
--     (department_id exists in employees but not in departments)
SELECT
    e.emp_id,
    e.name,
    e.department_id
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM departments d
    WHERE d.department_id = e.department_id
);


-- Q6. Find employees who earn the MAX salary
--     in their respective department.
--     Do NOT use window functions.
SELECT
    e.emp_id,
    e.name,
    e.department_id,
    e.salary
FROM employees e
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);


-- Q7. Find departments whose average salary
--     is higher than the company average salary.
--     Break logic into steps using comments.

SELECT
    department_id
FROM employees
-- Step 1: Group all employee rows by department
--         so aggregate functions work per department
GROUP BY department_id
HAVING
    -- Step 2: For each department group,
    --         compute the average salary of that department
    AVG(salary) >
    (
        -- Step 3: This subquery runs first (independently)
        --         and calculates the company-wide average salary
        --         It returns a single scalar value
        SELECT AVG(salary)
        FROM employees
    );

-- Q8. NULL Safety Check
--     Find employees whose salary is NOT NULL
--     and greater than 60,000.
--     Explain in comments why explicit NULL checks matter.
SELECT
    emp_id,
    name,
    salary
FROM employees
WHERE
    salary IS NOT NULL
    AND salary > 60000;

-- This question is testing understanding of NULL handling in SQL.
-- It is not just about filtering salaries greater than 60,000.
-- The key requirement is recognizing that NULL represents an unknown value.
-- Comparisons involving NULL do not return TRUE or FALSE, but UNKNOWN.
-- Writing an explicit IS NOT NULL check makes the intent clear and avoids relying on implicit SQL behavior.
-- This shows defensive, professional SQL rather than accidental correctness.

-- Q9. Over-Optimization Trap
--     Take ANY ONE query above and:
--     - write a compact, clever version
--     - write a clearer, safer version
--     Explain why you prefer the safer version.
-- 1. Compact clever version
SELECT *
FROM employees e
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- 2. Clearer safer version
SELECT
    e.emp_id,
    e.name,
    e.department_id,
    e.salary
FROM employees e
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);
-- The compact version is technically correct, but it hides intent.
-- Using SELECT * makes the output unclear and fragile if the table schema changes.
-- Reusing column names without clear aliases increases cognitive load when reading or debugging.
-- The safer version is explicit about selected columns, table aliases, and relationships.
-- It communicates why the query works, not just that it works.
-- In real systems, clarity reduces bugs, improves maintainability, and helps reviewers understand logic faster.

-- Q10. FINAL SQL REFLECTION (comments only):
--      - One SQL mistake you will never repeat
--      - One construct you trust more after Day 20
--      - One mindset shift you experienced across Days 8–20


-- One SQL mistake I will never repeat:
-- Using NOT IN for absence checks without thinking about NULLs.
-- I now know that a single NULL in a subquery can silently break the logic
-- and return incorrect or empty results.

-- One SQL construct I trust more after Day 20:
-- NOT EXISTS.
-- It expresses absence clearly, is NULL-safe, and matches how I reason
-- about missing relationships in real data.

-- One mindset shift across Days 8–20:
-- I stopped writing SQL to "make it work" and started writing SQL
-- to make the logic obvious.
-- Clarity, safety, and intent now matter more to me than cleverness
-- or shortest possible queries.
