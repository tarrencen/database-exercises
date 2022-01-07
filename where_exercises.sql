USE employees;
DESCRIBE employees;

-- Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya' using IN. Enter a comment with the number of records returned.

SELECT * FROM employees WHERE first_name IN ('Irena', 'Vidya', 'Maya');
# 709 records returned

-- Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', as in Q2, but use OR instead of IN. Enter a comment with the number of records returned. Does it match number of rows from Q2?

SELECT * FROM employees WHERE (first_name = 'Irena' OR first_name = 'Vidya' OR first_name = 'Maya');
# Yes, this query returns the same number of rows as in Q2

-- Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', using OR, and who is male. Enter a comment with the number of records returned.

SELECT * FROM employees WHERE first_name IN ('Irena', 'Vidya', 'Maya') AND gender = 'M';
# 441 rows returned

-- Find all current or previous employees whose last name starts with 'E'. Enter a comment with the number of employees whose last name starts with E.

SELECT * FROM employees WHERE last_name LIKE 'E%';
# 7330 employees


-- Find all current or previous employees whose last name starts or ends with 'E'. Enter a comment with the number of employees whose last name starts or ends with E. How many employees have a last name that ends with E, but does not start with E?

SELECT * FROM employees WHERE last_name LIKE 'E%' OR last_name LIKE '%e';
# 30723 employees have last names that starts or ends with 'E'

SELECT * FROM employees WHERE last_name LIKE '%e' AND last_name NOT LIKE 'E%';
# 23393 employees have last names that end with 'E' but do not start with 'E' 

-- Find all current or previous employees employees whose last name starts and ends with 'E'. Enter a comment with the number of employees whose last name starts and ends with E. How many employees' last names end with E, regardless of whether they start with E?

SELECT * FROM employees WHERE last_name LIKE 'E%e';
# 899 employees have last names that start and end with 'E'

SELECT * FROM employees WHERE last_name LIKE '%e';
# 24292 employees' last names end with 'E'

-- Find all current or previous employees hired in the 90s. Enter a comment with the number of employees returned.

SELECT * FROM employees WHERE hire_date BETWEEN '1990-01-01' AND '1999-12-31';
# 135214 employees hired in the 90s

-- Find all current or previous employees born on Christmas. Enter a comment with the number of employees returned.

SELECT * FROM employees WHERE birth_date LIKE '%-12-25';
# 842 employees born on Christmas

-- Find all current or previous employees hired in the 90s and born on Christmas. Enter a comment with the number of employees returned.

SELECT * FROM employees WHERE hire_date BETWEEN '1990-01-01' AND '1999-12-31' AND birth_date LIKE '%-12-25';
# 362 employees hired in the 90s and born on Christmas

-- Find all current or previous employees with a 'q' in their last name. Enter a comment with the number of records returned.

SELECT * FROM employees WHERE last_name LIKE '%q%';
# 1873 employees with a 'Q' in their last name

-- Find all current or previous employees with a 'q' in their last name but not 'qu'. How many employees are found?

SELECT * FROM employees WHERE last_name LIKE '%q%' AND last_name NOT LIKE '%qu%';
# 547 employees with 'q' but not 'qu' in their last name
