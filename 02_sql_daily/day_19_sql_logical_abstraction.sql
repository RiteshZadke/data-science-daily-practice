-- Day 19 – Core SQL Logical Abstraction & Query Design
--
-- This file focuses on:
-- - Breaking complex problems into logical SQL steps
-- - Using subqueries as logical abstractions
-- - Choosing readable SQL over clever SQL
-- - Interview-level query reasoning
--
-- Tables used: employees, departments


USE daily_sql;

-- Q1. Logical Abstraction with Subquery
--     Find employees who earn more than the company average salary.
--     Treat the subquery as a "logical variable" for average salary.
--     Add comments explaining this abstraction.
SELECT *
FROM employees
WHERE salary >
(
    SELECT AVG(salary)
    FROM employees
);
-- This subquery acts like a logical variable
-- It abstracts the idea of "average salary of the entire company"

-- Q2. Department-Level Abstraction
--     Find departments whose average salary is greater than 65,000.
--     Use GROUP BY + HAVING.
--     Explain in comments how this abstracts department performance.
SELECT department_id,
	AVG(salary) AS avg_dep_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary)>65000;
-- HAVING filters aggregated results (departments),
-- not individual employees.
-- This allows us to compare department performance
-- instead of employee-level data.

-- Q3. Nested Logic Abstraction
--     Find employees who earn more than the average salary
--     of their own department.
--     (Correlated subquery)
--     Explain how each employee is evaluated independently.
SELECT e.*
FROM employees e
WHERE e.salary >
(
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);
-- Logical abstraction:
-- Each employee is evaluated independently.
-- For every employee row in the outer query,
-- the subquery calculates the average salary
-- of THAT employee’s department.

-- Q4. EXISTS as a Logical Question
--     Find departments that have at least one employee
--     earning more than 80,000.
--     Explain in comments how EXISTS behaves like a YES/NO question.
SELECT e.department_id
FROM employees e
WHERE EXISTS (
	SELECT 1
    FROM departments d
    WHERE e.department_id = d.department_id
      AND salary > 80000
);

-- Q5. Avoiding Over-Abstraction
--     Rewrite Q4 using IN.
--     Explain in comments why EXISTS is clearer here.
SELECT e.department_id
FROM employees e
WHERE EXISTS (
	SELECT 1
    FROM departments d
    WHERE e.department_id = d.department_id
      AND salary > 80000
);
-- Why EXISTS is clearer than IN here:
-- IN focuses on matching values between two sets.
-- EXISTS focuses on intent:
-- "Does this department have at least one employee
--  earning more than 80,000?"
-- EXISTS reads like a YES/NO business rule,
-- which makes it easier to reason about in interviews.



-- Q6. Abstracting Absence (Negative Logic)
--     Find employees who do not belong to any department.
--     Solve using NOT EXISTS.
--     Explain why this is safer than NOT IN.
SELECT e.*
FROM employees e
WHERE NOT EXISTS
(
    SELECT 1
    FROM departments d
    WHERE d.department_id = e.department_id
);

-- Why NOT EXISTS is safer than NOT IN:
-- NOT IN fails if the subquery returns NULL values.
-- NOT EXISTS does not care about NULLs.
-- It checks logical absence, not value comparison.

-- Q7. Multi-Step Thinking
--     Find departments whose average salary is higher
--     than the company average salary.
--     Break the logic into steps in comments.

-- Step 1: Compute company-wide average salary
-- Step 2: Compute average salary per department
-- Step 3: Compare department average with company average

SELECT
    department_id,
    AVG(salary) AS dept_avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) >
(
    SELECT AVG(salary)
    FROM employees
);

-- Q8. Maximum per Group (Without Window Functions)
--     Find employees who earn the maximum salary
--     in their respective department.
--     Explain why this query is harder than it looks.
SELECT e.*
FROM employees e
WHERE e.salary =
(
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id
);


-- Q9. Readability over Cleverness
--     Take ANY ONE query above and:
--     - Write a very compact but hard-to-read version
--     - Write a clearer, more readable version
--     Explain why the readable version is preferred.
SELECT * FROM employees e
WHERE salary = (SELECT MAX(salary) FROM employees WHERE department_id = e.department_id);

--  Clear and readable
SELECT e.*
FROM employees e
WHERE e.salary =
(
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- Why readable SQL is preferred:
-- Easier to explain in interviews
-- Easier to debug
-- Easier for teammates to maintain
-- Clever SQL impresses nobody long-term

-- Q10. SQL Reflection (comments only):
--      - One place where subqueries act like abstraction
--      - One place where abstraction makes SQL worse
--      - One SQL design habit you improved by Day 19


-- Subqueries as abstraction:
-- Using subqueries to represent company or department averages
-- as logical benchmark values.

-- When abstraction makes SQL worse:
-- Deeply nested subqueries that hide simple intent
-- and make debugging difficult.

-- SQL habit improved by Day 19:
-- Designing queries around business logic first,
-- then translating that logic into SQL.