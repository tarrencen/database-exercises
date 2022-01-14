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

# Forgot the "currently employed" parameter!

-- Remove the first_name and last_name columns from the table.

ALTER TABLE employees_with_departments DROP COLUMN first_name;
ALTER TABLE employees_with_departments DROP COLUMN last_name;

# Is there a way to add/drop multiple columns in one line of code?? 

SELECT * FROM employees_with_departments;

DROP TABLE employees_with_departments;

-- What is another way you could have ended up with this same table?

/* Create the temp table with the following code:*/

CREATE TEMPORARY TABLE employees_with_departments AS (
													SELECT CONCAT(employees.first_name, " ", employees.last_name) AS full_name, departments.dept_name AS Dept
													FROM employees.employees, employees.departments 
											JOIN employees.dept_emp 
											WHERE dept_emp.to_date LIMIT 10);
											
SELECT * FROM employees_with_departments;

-- Create a temporary table based on the payment table from the sakila database.

/*CREATE TEMPORARY TABLE fake_sakila AS (SELECT * FROM sakila.payment LIMIT 100);
SELECT * FROM fake_sakila;

-- Write the SQL necessary to transform the amount column such that it is stored as an integer representing the number of cents of the payment. For example, 1.99 should become 199.

DESCRIBE fake_sakila;

ALTER TABLE fake_sakila DROP COLUMN amount;

SELECT * FROM fake_sakila;

ALTER TABLE fake_sakila ADD COLUMN amount INT;

SELECT * FROM fake_sakila;

INSERT INTO fake_sakila.amount (SELECT payment.amount * 100 FROM sakila.payment LIMIT 100);

# Stuck... turning to Google

ALTER TABLE fake_sakila DROP COLUMN amount;

SELECT * FROM fake_sakila;

SELECT * | (payment.amount * 100) AS amount_in_pennies INTO innis_1673.fake_sakila FROM sakila.payment LIMIT 100;

# Alter the table and MODIFY the column, after having taken the data into the table (with amount * 100 upon creation of the temp table). Should probably start over.*/

CREATE TEMPORARY TABLE fake_payments AS (
										SELECT payment.payment_id, 
												payment.customer_id, 
										 payment.rental_id, 
										  payment.staff_id, 
										  payment.amount * 100 AS amount_in_pennies
										 FROM sakila.payment LIMIT 25);
										 
SELECT * FROM fake_payments;

ALTER TABLE fake_payments MODIFY amount_in_pennies INT NOT NULL;

SELECT * FROM fake_payments;

# Left off last two fields from sakila.payments


-- Find out how the current average pay in each department compares to the overall, historical average pay. In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, what is the best department right now to work for? The worst?


CREATE TEMPORARY TABLE averages_now AS (SELECT departments.dept_name AS Dept, AVG(salaries.salary) AS avg_sal_now, STDDEV(salaries.salary) AS std_dev_sal
										FROM employees.departments 
									JOIN employees.dept_emp ON dept_emp.dept_no = departments.dept_no
									JOIN employees.salaries ON salaries.emp_no = dept_emp.dept_no
									WHERE dept_emp.to_date LIKE '9999%'
									GROUP BY departments.dept_name);
									
SELECT * FROM averages_now;

DROP TABLE averages_now;



# No rows returned. Time to debug.
/*USING employees DB */

SELECT dept_name, ROUND(AVG(salary),2) AS avg_sal_now, ROUND(STDDEV(salary),2) AS std_dev_sal
		FROM salaries
	   JOIN dept_emp ON dept_emp.emp_no = salaries.emp_no
	    JOIN departments ON departments.dept_no = dept_emp.dept_no 
		WHERE dept_emp.to_date LIKE '9999%' AND salaries.to_date LIKE '9999%'
		GROUP BY dept_name;
		
SELECT AVG(salary) AS historic_avg_sal, STDDEV(salary) AS historic_std_dev_sal
		FROM salaries;
		
/*These worked. Trying again.*/

CREATE TEMPORARY TABLE averages_now AS (SELECT departments.dept_name AS Dept, AVG(salaries.salary) AS avg_sal_now, STDDEV(salaries.salary) AS std_dev_sal
										FROM employees.departments 
									JOIN employees.dept_emp ON dept_emp.dept_no = departments.dept_no
									JOIN employees.salaries ON salaries.emp_no = dept_emp.emp_no
									WHERE dept_emp.to_date LIKE '9999%' AND salaries.to_date LIKE '9999%'
									GROUP BY departments.dept_name);
									
SELECT * FROM averages_now;

SELECT AVG(avg_sal_now) FROM averages_now;

SELECT AVG(salary) 
FROM employees.salaries
JOIN employees.dept_emp ON dept_emp.emp_no = salaries.emp_no
WHERE dept_emp.to_date > CURDATE();

CREATE TEMPORARY TABLE historical_avgs AS (SELECT departments.dept_name AS Dept, AVG(salaries.salary) AS hist_avg_sal, STDDEV(salaries.salary) AS hist_sal_std
											FROM employees.departments
									JOIN employees.dept_emp ON dept_emp.dept_no = departments.dept_no
									JOIN employees.salaries ON salaries.emp_no = dept_emp.emp_no
										GROUP BY departments.dept_name);
										
SELECT * FROM historical_avgs;


SELECT AVG(salary) 
FROM employees.salaries
JOIN employees.dept_emp ON dept_emp.emp_no = salaries.emp_no
WHERE dept_emp.to_date > CURDATE();


# Current and historical data compiled. Now to calculate zscore...

SELECT AVG(hist_sal_std) FROM historical_avgs;

SELECT Dept, AVG(avg_sal_now) - AVG(hist_avg_sal) AS diff
	FROM averages_now
	JOIN historical_avgs USING(Dept)
	GROUP BY Dept
	ORDER BY diff DESC;

SELECT Dept, (AVG(averages_now.avg_sal_now) - AVG(historical_avgs.hist_avg_sal)) / AVG(historical_avgs.hist_sal_std) AS maybe_zscore
	FROM averages_now
	JOIN historical_avgs USING(Dept)
	GROUP BY Dept
	ORDER BY maybe_zscore DESC;


# Numbers close, but not quite matching Madeleine's...

CREATE TEMPORARY TABLE salary_analysis AS (
											SELECT averages_now.Dept AS Department, 
											ROUND(AVG(averages_now.avg_sal_now),2) AS current_avg, 
											ROUND(AVG(historical_avgs.hist_avg_sal),2) AS historical_avg,
											ROUND(AVG(historical_avgs.hist_sal_std),2) AS historical_std,
											(AVG(averages_now.avg_sal_now) - AVG(historical_avgs.hist_avg_sal)) / AVG(historical_avgs.hist_sal_std) AS zscore
										FROM averages_now
										JOIN historical_avgs USING(Dept)
										GROUP BY Department
										ORDER BY zscore DESC);

SELECT * FROM salary_analysis;

# Did this work correctly??




