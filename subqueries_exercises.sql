-- Find all the current employees with the same hire date as employee 101010 using a sub-query.

SELECT CONCAT(e.first_name, " ", e.last_name), e.hire_date
FROM employees e
JOIN dept_emp de USING(emp_no)
WHERE hire_date = (
		SELECT hire_date 
		FROM employees 
		WHERE emp_no = 101010
		) AND de.to_date > CURDATE();
		
# 55 results returned.

-- Find all the titles ever held by all current employees with the first name Aamod.

SELECT CONCAT(employees.first_name," Bambaclaat ", employees.last_name) AS empleado, titles.title
FROM employees
JOIN titles
	ON titles.emp_no = employees.emp_no
WHERE employees.first_name LIKE 'Aamod'
GROUP BY empleado, titles.title
ORDER BY empleado 
IN (SELECT to_date
	FROM dept_emp
	WHERE to_date LIKE '9999%');
	
#Not sure this query is outputting like it should, but I did give all the Aamods the middle name "Bambaclaat" to see if it would work... and for the giggles, too... so try again...

SELECT t.title, COUNT(t.title)
FROM titles t
JOIN employees e USING(emp_no)
JOIN dept_emp de USING(emp_no)
WHERE de.to_date < CURDATE() AND e.first_name LIKE 'Aamod'
GROUP BY t.title;

# No subquery...

-- How many people in the employees table are no longer working for the company? Give the answer in a comment in your code.

SELECT COUNT(*)
FROM employees e
JOIN dept_emp de USING(emp_no)
WHERE de.to_date < CURDATE();

# 91479 counted from this query, but since a subquery is expected, probably not right...

-- Find all the current department managers that are female. List their names in a comment in your code.

SELECT CONCAT(first_name, " ", last_name) 
FROM employees
WHERE gender = 'F'; 

(SELECT * FROM dept_manager
WHERE to_date > CURDATE());

SELECT CONCAT(e.first_name, " ", e.last_name)
FROM employees e
JOIN dept_manager dm USING(emp_no)
WHERE e.gender = 'F' AND dm.to_date > CURDATE();

# Isamu Legleitner, Karsten Sigstam, Leon DasSarma,  Hilary Kambii from this query with no subquery...


-- Find all the employees who currently have a higher salary than the companies overall, historical average salary.

-- How many current salaries are within 1 standard deviation of the current highest salary? (Hint: you can use a built in function to calculate the standard deviation.) What percentage of all salaries is this?

SELECT COUNT(de.emp_no), ROUND(MAX(s.salary) - STDDEV(s.salary), 2) AS top_sal_std
FROM salaries s
JOIN dept_emp de USING (emp_no)
WHERE s.salary >= top_sal_std AND de.to_date > CURDATE();
	

-- Hint Number 1 You will likely use a combination of different kinds of subqueries.
-- Hint Number 2 Consider that the following code will produce the z score for current salaries.

-- BONUS

-- Find all the department names that currently have female managers.

-- Find the first and last name of the employee with the highest salary.

-- Find the department name that the employee with the highest salary works in.