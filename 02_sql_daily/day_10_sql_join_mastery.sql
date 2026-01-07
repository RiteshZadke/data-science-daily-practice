-- Day 10 – Core SQL JOIN Mastery
--
-- This file focuses on:
-- - INNER, LEFT, RIGHT JOIN behavior
-- - Join edge cases
-- - Key-based joins only
-- - Interview-style join logic
--
-- Tables used: employees, departments


USE daily_sql;

-- Q1. Display employee name, salary, and department name
--     Use INNER JOIN on department_id.
SELECT 
    e.name,
    e.salary,
    d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;

-- Q2. Display all departments and their employees.
--     Include departments even if they have no employees.
--     Columns: department_name, emp_name
SELECT 
    d.department_name,
    e.name AS emp_name
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id;

-- Q3. Find departments that have no employees.
--     Use LEFT JOIN carefully (avoid LEFT JOIN + WHERE trap).
SELECT 
    d.department_name
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
WHERE e.department_id IS NULL;

-- Q4. Using RIGHT JOIN, display employee name and department name.
--     Add comments explaining how this query can be rewritten
--     using LEFT JOIN instead.
SELECT 
    e.name AS emp_name,
    d.department_name
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id;

/*
This RIGHT JOIN can be rewritten as:

SELECT e.name, d.department_name
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id;

LEFT JOIN is preferred because:
- More readable
- More commonly used
- Avoids confusion
*/

-- Q5. Find employees whose department_id does not exist
--     in the departments table.
--     (Hint: LEFT JOIN + NULL check)
SELECT 
    e.name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

-- Q6. Display employee name and department name.
--     If an employee does not belong to any department,
--     department name should be NULL.
SELECT 
    e.name,
    d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;

-- Q7. Find department-wise employee count.
--     Include departments with zero employees.
SELECT 
    d.department_name,
    COUNT(e.emp_id) AS emp_count
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Q8. Find department-wise total salary expense.
--     Include departments with no employees.
--     Do NOT use CASE WHEN.
SELECT 
    d.department_name,
    SUM(e.salary) AS total_salary
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name;


-- Q9. Perform a self-join to find pairs of employees
--     working in the same department.
--     Do not match an employee with themselves.
--     Output: emp1_name, emp2_name, department_id
SELECT 
    e1.name AS emp1_name,
    e2.name AS emp2_name,
    e1.department_id
FROM employees e1
JOIN employees e2
ON e1.department_id = e2.department_id
AND e1.emp_id < e2.emp_id;

-- Q10. Solve ANY ONE of the above questions twice:
--      1) Using JOIN
--      2) Using subquery
--      Add SQL comments explaining which approach
--      is clearer and why.
SELECT d.department_name
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
WHERE e.department_id IS NULL;

/*
JOIN version is clearer because:
- Shows relationship explicitly
- Easier to debug
- Preferred in interviews
*/