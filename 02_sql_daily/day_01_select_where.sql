-- CREATE DATABASE daily_sql;
-- USE daily_sql;
-- CREATE TABLE employees(
-- 	emp_id INT AUTO_INCREMENT PRIMARY KEY,
--     name VARCHAR(100) NOT NULL,
--     department VARCHAR(100) NOT NULL,
--     salary DECIMAL(10,2) NOT NULL,
--     age INT
--     );
--     
-- INSERT INTO employees (emp_id, name, department, salary, age) VALUES
-- 	(1, 'Ritesh Zadke', 'Data Science', 60000, 24),
-- 	(2, 'Ankit Sharma', 'Analytics', 55000, 26),
-- 	(3, 'Priya Verma', 'HR', 40000, 28),
-- 	(4, 'Aman Gupta', 'Engineering', 70000, 30),
-- 	(5, 'Neha Singh', 'Marketing', 45000, 25),
-- 	(6, 'Rahul Mehta', 'Finance', 65000, 32),
-- 	(7, 'Sneha Patil', 'Data Science', 62000, 27),
-- 	(8, 'Vikas Rao', 'Engineering', 72000, 34),
-- 	(9, 'Pooja Nair', 'HR', 42000, 29),
-- 	(10, 'Kunal Jain', 'Analytics', 58000, 26),
-- 	(11, 'Aditi Kulkarni', 'Marketing', 48000, 24),
-- 	(12, 'Rohit Yadav', 'Finance', 67000, 31),
-- 	(13, 'Simran Kaur', 'Data Science', 61000, 28),
-- 	(14, 'Arjun Malhotra', 'Engineering', 75000, 35),
-- 	(15, 'Isha Choudhary', 'HR', 39000, 27),
-- 	(16, 'Nikhil Bansal', 'Analytics', 56000, 29),
-- 	(17, 'Tanvi Deshmukh', 'Marketing', 47000, 26),
-- 	(18, 'Mohit Agarwal', 'Finance', 69000, 33),
-- 	(19, 'Kavya Iyer', 'Data Science', 64000, 30),
-- 	(20, 'Saurabh Mishra', 'Engineering', 73000, 34),

-- 	(21, 'Payal Shah', 'HR', 41000, 28),
-- 	(22, 'Deepak Soni', 'Analytics', 59000, 31),
-- 	(23, 'Riya Kapoor', 'Marketing', 46000, 25),
-- 	(24, 'Ashish Pandey', 'Finance', 68000, 36),
-- 	(25, 'Meenal Joshi', 'Data Science', 65000, 29),
-- 	(26, 'Harsh Vardhan', 'Engineering', 76000, 37),
-- 	(27, 'Naina Arora', 'HR', 43000, 30),
-- 	(28, 'Abhishek Roy', 'Analytics', 60000, 32),
-- 	(29, 'Shruti Sen', 'Marketing', 49000, 27),
-- 	(30, 'Manoj Kumar', 'Finance', 71000, 38),
-- 	(31, 'Sakshi Goyal', 'Data Science', 67000, 31),
-- 	(32, 'Pranav Kulkarni', 'Engineering', 78000, 39),
-- 	(33, 'Divya Malhotra', 'HR', 44000, 29),
-- 	(34, 'Rajat Khanna', 'Analytics', 61000, 33),
-- 	(35, 'Ananya Bose', 'Marketing', 50000, 28),
-- 	(36, 'Puneet Arora', 'Finance', 72000, 40),
-- 	(37, 'Komal Thakur', 'Data Science', 69000, 34),
-- 	(38, 'Yogesh Patel', 'Engineering', 80000, 41),
-- 	(39, 'Swati Kulkarni', 'HR', 45000, 31),
-- 	(40, 'Naveen Chandra', 'Analytics', 62000, 35),
-- 	(41, 'Shalini Saxena', 'Marketing', 52000, 29),
-- 	(42, 'Varun Singhal', 'Finance', 74000, 42),
-- 	(43, 'Pallavi Rane', 'Data Science', 71000, 36),
-- 	(44, 'Rakesh Verma', 'Engineering', 82000, 43),
-- 	(45, 'Bhavna Joshi', 'HR', 46000, 32),
-- 	(46, 'Akash Tripathi', 'Analytics', 63000, 34),
-- 	(47, 'Monika Bhat', 'Marketing', 54000, 30),
-- 	(48, 'Sunil Desai', 'Finance', 76000, 45),
-- 	(49, 'Reema Pillai', 'Data Science', 73000, 38),
-- 	(50, 'Ajay Saxena', 'Engineering', 85000, 46);
    
    
-- Q1.  query to select all columns from the employees table.
SELECT * FROM employees;

-- Q2.  Display only name and salary of all employees.
SELECT name,salary FROM employees;

-- Q3.  Find employees whose salary is greater than 50,000.
SELECT * FROM employees WHERE salary>50000;

-- Q4.  Retrieve employees belonging to Data Science department.
SELECT * FROM employees WHERE department = 'Data Science';

-- Q5.  Sort employees by salary in descending order.
SELECT * FROM employees ORDER BY salary DESC;

-- Q6.  Find employees whose age is between 25 and 35.
SELECT * FROM employees WHERE age BETWEEN 25 AND 35;

-- Q7.  Count total number of employees.
SELECT COUNT(*) AS total_employees FROM employees;

-- Q8.  Find the maximum salary in the company.
SELECT MAX(salary) FROM employees;

-- Q9.  Retrieve distinct departments from the table.
SELECT DISTINCT department FROM employees;

-- Q10.  Find employees whose name starts with ‘A’.
SELECT * FROM employees WHERE name LIKE 'A%';
