-- Day 06 – SQL JOINs Practice
--
-- This file contains SQL queries focused on:
-- - Using INNER, LEFT, and RIGHT JOINs
-- - Combining data from multiple related tables
-- - Aggregating data after JOIN operations
-- - Writing clean and interview-ready JOIN queries
--
-- Tables used: employees, departments


USE daily_sql;
-- CREATE TABLE departments (
--     department_id INT AUTO_INCREMENT PRIMARY KEY,
--     department_name VARCHAR(100) NOT NULL UNIQUE
-- );

-- INSERT INTO departments (department_name) VALUES
-- ('Data Science'),
-- ('Analytics'),
-- ('HR'),
-- ('Engineering'),
-- ('Marketing'),
-- ('Finance');

-- ALTER TABLE employees
-- ADD department_id INT;

-- SET SQL_SAFE_UPDATES = 0;


-- UPDATE employees e
-- JOIN departments d
-- ON e.department = d.department_name
-- SET e.department_id = d.department_id;

-- SET SQL_SAFE_UPDATES = 1;

-- Q1. Retrieve all employees along with their department names (INNER JOIN).
SELECT e.*, d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;

-- Q2. Retrieve all employees, including those without a department (LEFT JOIN).
SELECT e.*, d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;

-- Q3. Retrieve all departments, including those with no employees (RIGHT / LEFT JOIN depending on DB).
SELECT d.department_name
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id;


-- Q4. Count the number of employees per department using JOIN.
SELECT d.department_name,COUNT(emp_id) AS employees_count 
FROM departments d
LEFT JOIN employees e
	ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Q5. Find departments where no employees exist.
SELECT 
    d.department_name
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
WHERE e.emp_id IS NULL;

-- Q6 Find employees who earn more than the average salary of their department (JOIN + subquery).
SELECT * FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
JOIN (
    SELECT 
        department_id,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) dept_avg
    ON e.department_id = dept_avg.department_id
WHERE e.salary > dept_avg.avg_salary;

-- Q7. Find the highest-paid employee in each department.
SELECT * FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

-- Q8 Find departments with more than 3 employees using JOIN + GROUP BY.
SELECT 
    d.department_name,
    COUNT(e.emp_id) AS employee_count
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING COUNT(e.emp_id) > 3;

-- Q9 Find employees who share the same salary with someone else.
SELECT * FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
WHERE e.salary IN (
    SELECT salary
    FROM employees
    GROUP BY salary
    HAVING COUNT(*) > 1
)
ORDER BY e.salary;

-- Q10. Find the department(s) with the highest total salary payout using JOIN.
SELECT 
    d.department_name,
    SUM(e.salary) AS total_salary
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING SUM(e.salary) = (
    SELECT MAX(dept_total)
    FROM (
        SELECT 
            SUM(salary) AS dept_total
        FROM employees
        GROUP BY department_id
    ) t
);
