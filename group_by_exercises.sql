-- In your script, use DISTINCT to find the unique titles in the titles table. How many unique titles have there ever been? Answer that in a comment in your SQL file.

DESCRIBE titles;
SELECT * FROM titles;

SELECT DISTINCT title FROM titles GROUP BY title;
# There have been 6 unique titles.

-- Write a query to to find a list of all unique last names of all employees that start and end with 'E' using GROUP BY.
SELECT DISTINCT last_name
FROM employees
	WHERE last_name LIKE 'E%e'
	GROUP BY last_name;
	
-- Write a query to to find all unique combinations of first and last names of all employees whose last names start and end with 'E'.
SELECT DISTINCT(
CONCAT(first_name, " ", last_name)) AS unique_name_combo
FROM employees
	WHERE last_name LIKE 'E%e';
	


-- Write a query to find the unique last names with a 'q' but not 'qu'. Include those names in a comment in your sql code.
SELECT DISTINCT last_name
FROM employees
	WHERE last_name LIKE '%q%' 
		AND last_name NOT LIKE '%qu%';
# Chleq, Lindqvist, Qiwen

-- Add a COUNT() to your results (the query above) to find the number of employees with the same last name.
SELECT last_name, COUNT(*)
FROM employees
	WHERE last_name LIKE '%q%' 
		AND last_name NOT LIKE '%qu%'
	GROUP BY last_name;
# 189 Chleqs, 190 Lindqvists, 168 Qiwens

-- Find all all employees with first names 'Irena', 'Vidya', or 'Maya'. Use COUNT(*) and GROUP BY to find the number of employees for each gender with those names.

SELECT first_name, gender, COUNT(gender)
FROM employees
	WHERE first_name IN ('Irena', 'Vidya', 'Maya')
	GROUP BY first_name, gender
	ORDER BY first_name;
	
-- Using your query that generates a username for all of the employees, generate a count employees for each unique username. Are there any duplicate usernames? BONUS: How many duplicate usernames are there?

SELECT CONCAT 
(LOWER (SUBSTR(first_name, 1, 1)), LOWER (SUBSTR(last_name, 1, 4)), "_", SUBSTR(birth_date, 6, 2), SUBSTR(birth_date, 3, 2)) AS username, 
COUNT(*) AS n_same_username
FROM employees
GROUP BY username
HAVING n_same_username > 1
ORDER BY n_same_username DESC;

# Query indicates 5 duped usernames. Output doesn't show them individually, though. How do we make that happen?
# ^ WRONG! Way more than 5 dupes!


-- More practice with aggregate functions:

-- Determine the historic average salary for each employee. When you hear, read, or think "for each" with regard to SQL, you'll probably be grouping by that exact column.

DESCRIBE salaries;

SELECT AVG(salary), emp_no
FROM salaries
	GROUP BY emp_no
	LIMIT 25;

-- Using the dept_emp table, count how many current employees work in each department. The query result should show 9 rows, one for each department and the employee count.

DESCRIBE dept_emp;

SELECT * FROM dept_emp;

SELECT DISTINCT dept_no, COUNT(dept_no) AS dept_numbers
FROM dept_emp
 	WHERE to_date LIKE '9999%'
		GROUP BY dept_no;
		
# Glossed over that "current employee" part (to_date LIKE 9999%)		

-- Determine how many different salaries each employee has had. This includes both historic and current.
DESCRIBE salaries;

SELECT emp_no, COUNT(*)
FROM salaries
	GROUP BY emp_no;
# Error reads, "executed command denied to user 'innis_1673@%' for routine 'employees.COUNT'"; but the query was wrong anyway

-- Find the maximum salary for each employee.
SELECT emp_no, MAX(salary)
FROM salaries
	GROUP BY emp_no;

-- Find the minimum salary for each employee.
SELECT emp_no, MIN(salary)
FROM salaries
	GROUP BY emp_no;

-- Find the standard deviation of salaries for each employee.
SELECT emp_no, STDDEV(salary)
FROM salaries
	GROUP BY emp_no;

-- Now find the max salary for each employee where that max salary is greater than $150,000.
SELECT emp_no, MAX(salary)
FROM salaries
	WHERE salary > 150000
		GROUP BY emp_no;

-- Find the average salary for each employee where that average salary is between $80k and $90k.
SELECT emp_no, AVG(salary)
FROM salaries
	GROUP BY emp_no
	HAVING AVG(salary) BETWEEN 80000 AND 90000;
