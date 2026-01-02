-- Day 07 – SQL Weekly Revision
--
-- This file contains mixed SQL practice covering:
-- - SELECT, WHERE, and ORDER BY
-- - GROUP BY and HAVING
-- - Subqueries and correlated subqueries
-- - JOINs across multiple tables
--
-- Tables used: employees, departments


USE daily_sql;
-- Q1. Retrieve employees who earn more than company average salary.
SELECT * FROM employees 
WHERE salary > (
	SELECT AVG(salary)
	FROM employees
);

-- Q2. Find department-wise employee count, sorted descending.
SELECT d.department_name, COUNT(e.emp_id) AS emp_count
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY emp_count DESC;

-- Q3. Find employees who earn more than department average.
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);


-- Q4. Find departments with no employees.
SELECT 
    d.department_name
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
WHERE e.emp_id IS NULL;

-- Q5. Find the second highest salary in the company.
SELECT * FROM employees 
ORDER BY salary DESC LIMIT 1,1;

-- Q6. Find employees whose salary is above average salary of the highest-paying department.
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = (
        SELECT department_id
        FROM employees
        GROUP BY department_id
        ORDER BY AVG(salary) DESC
        LIMIT 1
    )
);


-- Q7. Find department(s) with highest total salary payout.
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING SUM(e.salary) = (
    SELECT MAX(dept_total)
    FROM (
        SELECT SUM(salary) AS dept_total
        FROM employees
        GROUP BY department_id
    ) t
);
-- Q8. Find employees who share the same salary with someone else.
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

-- Q9 Find the youngest employee in each department.
SELECT *
FROM employees e
WHERE age = (
    SELECT MIN(age)
    FROM employees
    WHERE department_id = e.department_id
);

-- Q10. Find employees who earn more than the average salary of their department AND company average.
SELECT *
FROM employees e
WHERE salary > (
        SELECT AVG(salary)
        FROM employees
        WHERE department_id = e.department_id
      )
  AND salary > (
        SELECT AVG(salary)
        FROM employees
      );