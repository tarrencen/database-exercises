-- Write a query that returns all employees, their department number, their start date, their end date, and a new column 'is_current_employee' that is a 1 if the employee is still with the company and 0 if not.

SELECT CONCAT(e.first_name, " ", e.Last_name) AS Employee, de.dept_no AS Dept, de.from_date AS start_date, de.to_date AS end_date, 
	de.to_date, IF(de.to_date > CURDATE(), 1, 0) AS is_current_employee
	FROM employees e
	JOIN dept_emp de USING(emp_no)
	ORDER BY Dept	;
	
-- Write a query that returns all employee names (previous and current), and a new column 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' depending on the first letter of their last name.

SELECT first_name, 
	last_name, 
	CASE last_name
		WHEN last_name IN ('A%', 'B%', 'C%', 'D%', 'E%', 'F%', 'G%', 'H%') THEN 'A-H'
		WHEN last_name IN ('I%', 'J%', 'K%', 'L%', 'M%', 'N%', 'O%', 'P%', 'Q%') THEN 'I-Q'
		ELSE 'R-Z'
	END AS alpha_group
FROM employer;

# Wrong! Fix it, cheesus!!



-- How many employees (current or previous) were born in each decade?

# Finding range with this query: 

SELECT MIN(birth_date), MAX(birth_date) FROM employees;

# Oldest employee born in '52, youngest in '65

SELECT COUNT(*),(
				SELECT COUNT(*)
				FROM employees
				WHERE birth_date LIKE '195%') AS born_in_fifties,
				(
			   SELECT COUNT(*)
				FROM employees
				WHERE birth_date LIKE '196%') AS born_in_sixties
		FROM employees;

#Didn't have to use a CASE or IF statement... I probably should figure out how to do it that way though...

-- What is the current average salary for each of the following department groups: R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?


SELECT s.AVG(salary),
	CASE s.AVG(salary)
		WHEN d.dept_name