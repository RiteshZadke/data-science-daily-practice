-- Day 03 – SQL Aggregate Functions Practice
--
-- This file contains SQL queries focused on:
-- - Using aggregate functions such as COUNT, SUM, AVG, MIN, and MAX
-- - Applying aggregates with WHERE conditions
-- - Analyzing numerical data at a summary level
--
-- Table used: employees

USE daily_sql;

-- Q1. Find the total number of employees.
SELECT COUNT(*) AS total_employees FROM employees;

-- Q2. Find the average salary of all employees.
SELECT AVG(salary) AS avg_salary FROM employees;

-- Q3. Find the minimum salary in the company.
SELECT MIN(salary) AS min_salary FROM employees;

-- Q4. Find the maximum age among employees.
SELECT MAX(age) AS max_age FROM employees;

-- Q5. Find the total salary paid to all employees.
SELECT SUM(salary) AS total_salary FROM employees;

-- Q6. Find the average age of employees.
SELECT AVG(age) AS avg_age FROM employees;

-- Q7. Count how many employees work in the Data Science department.
SELECT COUNT(*) AS total_ds_employees FROM employees WHERE department = 'Data Science';

-- Q8. Find the average salary of employees in the Engineering department.
SELECT AVG(salary) AS avg_salary_engineering FROM employees WHERE department = 'Engineering';

-- Q9. Find the highest salary in the Finance department.
SELECT MAX(salary) AS max_salary_finance FROM employees WHERE department = 'Finance';

-- Q10. Find the difference between highest and lowest salary in the company.
SELECT MAX(salary) - MIN(salary) AS salary_difference FROM employees ;