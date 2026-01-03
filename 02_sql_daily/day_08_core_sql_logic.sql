USE daily_sql;
-- Q1. Find employees earning more than the company average salary.
SELECT * FROM employees
WHERE salary > (
	SELECT AVG(salary)
	FROM employees
    );

-- Q2. Find employees earning more than the average salary of their department.
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- Q3. Find the second highest salary.
SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);


-- Q4. Find departments having more than 3 employees.
SELECT department_id, COUNT(*) AS emp_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 3;

-- Q5. Find department-wise average salary where average salary > 60,000.
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 60000;

-- Q6. Display employee name and department name.
SELECT e.name, d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;


-- Q7. Find departments with no employees.
SELECT d.department_id, d.department_name
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
WHERE e.emp_id IS NULL;

-- Q8. Find the highest paid employee in each department.
SELECT *
FROM employees e
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- Q9. Find the department with the highest total salary expense.
SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
ORDER BY total_salary DESC
LIMIT 1;

-- Q10. Find employees who earn the same salary as another employee.
SELECT *
FROM employees
WHERE salary IN (
    SELECT salary
    FROM employees
    GROUP BY salary
    HAVING COUNT(*) > 1
);
