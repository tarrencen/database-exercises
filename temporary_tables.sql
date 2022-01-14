-- Using the example from the lesson, create a temporary table called employees_with_departments that contains first_name, last_name, and dept_name for employees currently with that department. Be absolutely sure to create this table on your own database. If you see "Access denied for user ...", it means that the query was attempting to write a new table to a database that you can only read.

SELECT Database();
SHOW TABLES;

CREATE TEMPORARY TABLE employees_with_departments AS (SELECT employees.first_name, employees.last_name, departments.dept_name 
														FROM employees.employees, employees.departments 
												LIMIT 10); 



SELECT * FROM employees_with_departments;


-- Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of the lengths of the first name and last name columns

ALTER TABLE employees_with_departments ADD COLUMN full_name VARCHAR(30);
SELECT * FROM employees_with_departments;

-- Update the table so that full name column contains the correct data

UPDATE employees_with_departments SET full_name = CONCAT(first_name, " ", last_name);
SELECT * FROM employees_with_departments;

-- Remove the first_name and last_name columns from the table.

ALTER TABLE employees_with_departments DROP COLUMN first_name;
ALTER TABLE employees_with_departments DROP COLUMN last_name;

# Is there a way to add/drop multiple columns in one line of code??

SELECT * FROM employees_with_departments;

-- What is another way you could have ended up with this same table?

/* Create the temp table with the following aliased select statement: AS (SELECT CONCAT(employees.first_name, " ", employees.last_name) AS last_name, departments.dept_name 
																			FROM employees.employees, employees.departments LIMIT 10); */

-- Create a temporary table based on the payment table from the sakila database.

CREATE TEMPORARY TABLE fake_sakila AS (SELECT * FROM sakila.payment LIMIT 100);
SELECT * FROM fake_sakila;

-- Write the SQL necessary to transform the amount column such that it is stored as an integer representing the number of cents of the payment. For example, 1.99 should become 199.

DESCRIBE fake_sakila;

ALTER TABLE fake_sakila DROP COLUMN amount;

SELECT * FROM fake_sakila;

ALTER TABLE fake_sakila ADD COLUMN amount INT;

SELECT * FROM fake_sakila;

UPDATE fake_sakila SET amount = (SELECT payment.amount * 100 FROM sakila.payment);


-- Find out how the current average pay in each department compares to the overall, historical average pay. In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, what is the best department right now to work for? The worst?