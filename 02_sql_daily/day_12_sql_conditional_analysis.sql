-- Day 12 – SQL Conditional Logic & Analytical Thinking
--
-- This file focuses on:
-- - CASE WHEN expressions
-- - Creating derived columns
-- - Conditional comparisons using SQL
-- - Analytical-style queries (pre-feature engineering)
--
-- Tables used: employees, departments


USE daily_sql;

-- Q1. Classify employees based on salary.
--     Create a column salary_category:
--     - 'High'   → salary >= 80000
--     - 'Medium' → salary between 50000 and 79999
--     - 'Low'    → salary < 50000
--     Display: emp_name, salary, salary_category
SELECT 
    name,
    salary,
    CASE 
        WHEN salary >= 80000 THEN 'High'
        WHEN salary BETWEEN 50000 AND 79999 THEN 'Medium'
        ELSE 'Low'
    END AS salary_category
FROM employees;

-- Q2. Mark employees as 'Above Avg' or 'Below Avg'
--     based on comparison with company average salary.
--     Use CASE WHEN with a subquery.
SELECT 
    name,
    salary,
    CASE 
        WHEN salary > (SELECT AVG(salary) FROM employees)
            THEN 'Above Avg'
        ELSE 'Below Avg'
    END AS salary_flag
FROM employees;

-- Q3. Mark employees as 'Above Dept Avg' or 'Below Dept Avg'
--     based on their department's average salary.
--     (Correlated subquery expected)
SELECT 
    name,
    department_id,
    salary,
    CASE 
        WHEN salary >
             (SELECT AVG(e2.salary)
              FROM employees e2
              WHERE e2.department_id = e1.department_id)
            THEN 'Above Dept Avg'
        ELSE 'Below Dept Avg'
    END AS dept_salary_flag
FROM employees e1;

-- Q4. Create a derived column experience_level:
--     - 'Senior' → salary > 70000
--     - 'Junior' → salary <= 70000
--     Display: emp_name, department_id, experience_level
SELECT 
    name,
    department_id,
    CASE 
        WHEN salary > 70000 THEN 'Senior'
        ELSE 'Junior'
    END AS experience_level
FROM employees;


-- Q5. Display department-wise employee count
--     and a derived column dept_size:
--     - 'Large'  → count > 5
--     - 'Medium' → count between 3 and 5
--     - 'Small'  → count < 3
SELECT 
    department_id,
    COUNT(*) AS emp_count,
    CASE 
        WHEN COUNT(*) > 5 THEN 'Large'
        WHEN COUNT(*) BETWEEN 3 AND 5 THEN 'Medium'
        ELSE 'Small'
    END AS dept_size
FROM employees
GROUP BY department_id;

-- Q6. Find employees who earn the maximum salary
--     in their respective department.
--     Display: emp_name, department_id, salary
SELECT 
    name,
    department_id,
    salary
FROM employees e1
WHERE salary =
      (SELECT MAX(e2.salary)
       FROM employees e2
       WHERE e2.department_id = e1.department_id);

-- Q7. For each department, display:
--     department_name, average salary,
--     and a derived column salary_level:
--     - 'Premium'  → avg_salary >= 70000
--     - 'Standard' → avg_salary < 70000
SELECT 
    d.department_name,
    AVG(e.salary) AS avg_salary,
    CASE 
        WHEN AVG(e.salary) >= 70000 THEN 'Premium'
        ELSE 'Standard'
    END AS salary_level
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
GROUP BY d.department_name;

-- Q8. Display employee name, department name,
--     and a column pay_flag:
--     - 'Top Earner' if employee earns max salary in department
--     - 'Others' otherwise
SELECT 
    e.name,
    d.department_name,
    CASE 
        WHEN e.salary =
             (SELECT MAX(e2.salary)
              FROM employees e2
              WHERE e2.department_id = e.department_id)
            THEN 'Top Earner'
        ELSE 'Others'
    END AS pay_flag
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id;

-- Q9. Find departments where the average salary
--     is higher than the company average salary.
SELECT 
    department_id,
    AVG(salary) AS dept_avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) >
       (SELECT AVG(salary) FROM employees);


-- Q10. Explain (in SQL comments):
--      - Why CASE WHEN is preferred over filtering
--        when creating analytical columns
--      - One real-world example where CASE WHEN
--        is unavoidable


-- CASE WHEN is preferred over filtering because:
-- Filtering removes rows from the result set,
-- while CASE WHEN keeps all rows and adds
-- analytical meaning through derived columns.
--
-- Real-world example:
-- In salary analysis dashboards, we must show
-- ALL employees while labeling them as
-- High / Medium / Low income.
-- Filtering would destroy that comparison.
-- CASE WHEN makes analysis possible without data loss.