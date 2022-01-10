-- Write a query to to find all employees whose last name starts and ends with 'E'. Use concat() to combine their first and last name together as a single column named full_name.

SELECT CONCAT (first_name, " ", last_name) AS full_name FROM employees WHERE last_name LIKE 'E%e';

-- Convert the names produced in your last query to all uppercase.

# This didn't work: SELECT CONCAT (first_name, " ", last_name) AS UPPER (full_name) FROM employees WHERE last_name LIKE 'E%e';

#Below only sort of worked:

SELECT UPPER (first_name) AS shouted_first_name, UPPER (last_name) AS shouted_last_name
FROM employees 
WHERE last_name LIKE 'E%e';

#3rd try is the charm:
SELECT CONCAT(UPPER (first_name), " ", UPPER(last_name)) AS shouted_full_name FROM employees WHERE last_name LIKE 'E%e';


-- Find all employees hired in the 1990s and born on Christmas. Use datediff() function to find how many days they have been working at the company (Hint: You will also need to use NOW() or CURDATE()),

SELECT hire_date, CURDATE(), DATEDIFF (CURDATE(), hire_date) AS total_days_at_company FROM employees WHERE hire_date LIKE '199%' and birth_date LIKE '%-12-25';

-- Find the smallest and largest current salary from the salaries table.

DESCRIBE salaries;
SELECT MIN(salary), MAX(salary) FROM salaries;

-- Use your knowledge of built in SQL functions to generate a username for all of the employees. A username should be all lowercase, and consist of the first character of the employees first name, the first 4 characters of the employees last name, an underscore, the month the employee was born, and the last two digits of the year that they were born.

SELECT first_name, last_name, birth_date FROM employees LIMIT 10;

SELECT CONCAT (LOWER (SUBSTR(first_name, 1, 1)), LOWER (SUBSTR(last_name, 1, 4)), "_", SUBSTR(birth_date, 6, 2), SUBSTR(birth_date, 3, 2)) AS username, first_name, last_name, birth_date
FROM employees LIMIT 10;

