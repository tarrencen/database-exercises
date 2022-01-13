-- Use join, left join, and right join to combine results from the users and roles tables as we did in the lesson. Before you run each query, guess the expected number of results.

DESCRIBE roles;
SELECT * FROM roles;

DESCRIBE users;
SELECT * FROM users;

SELECT *
FROM roles
JOIN users
ON roles.id
ORDER BY users.id;

SELECT *
FROM users
LEFT JOIN roles
ON roles.id
ORDER BY users.id;

SELECT *
FROM roles
RIGHT JOIN users
ON roles.id
ORDER BY users.id;

SELECT *
FROM users
RIGHT JOIN roles
ON roles.id
ORDER BY users.id;

SELECT *
FROM roles
JOIN users
ON users.id
ORDER BY users.id;

SELECT users.name, roles.name
FROM users
LEFT JOIN roles ON users.role_id = roles.id;

SELECT users.name, roles.name
FROM users
RIGHT JOIN roles ON users.role_id = roles.id;

# Why am I getting so many results for the above queries?? Let's try again, from the top.

SELECT users.name AS the_rock, roles.name AS ya_gibroni
FROM users
JOIN roles ON users.role_id = roles.id;

# And still... 16 rows... until I added "= roles.id" to JOIN statement. But why???

SELECT users.name as user_name, roles.name AS role_name
FROM users
LEFT JOIN roles ON users.role_id = roles.id;

-- Although not explicitly covered in the lesson, aggregate functions like count can be used with join queries. Use count and the appropriate join type to get a list of roles along with the number of users that has the role. Hint: You will also need to use group by in the query.

SELECT users.name, users.role_id, COUNT(users.role_id)
FROM roles
JOIN users
ON users.role_id = roles.id
GROUP BY users.name, users.role_id;

# Error thrown: "execute command denied to user 'innis_1673@%' for routine 'join_example_db.COUNT'" (Once again, the code wasn't right.)

-- Using the example in the Associative Table Joins section as a guide, write a query that shows each department along with the name of the current manager for that department.

SELECT * FROM dept_manager WHERE to_date LIKE '9999%';

SELECT departments.dept_name AS dpto, dept_manager.emp_no AS emp_id, CONCAT(employees.first_name, " ", employees.last_name) AS mgr_name
FROM employees
JOIN dept_manager
	ON dept_manager.emp_no = employees.emp_no
JOIN departments
	ON departments.dept_no = dept_manager.dept_no
WHERE dept_manager.to_date LIKE '9999%';


-- Find the name of all departments currently managed by women.

SELECT departments.dept_name AS DPTO, dept_manager.emp_no AS emp_id, employees.gender AS sex
FROM employees
JOIN dept_manager
	ON dept_manager.emp_no = employees.emp_no
JOIN departments
	ON departments.dept_no = dept_manager.dept_no
WHERE dept_manager.to_date LIKE '9999%' AND employees.gender = 'F';

# Is selecting "emp_id" calling back more data than requested? Probably... so, maybe try it again without "emp_id"

SELECT departments.dept_name AS dpto, employees.gender AS sexo_de_gerente
FROM employees
JOIN dept_manager
	ON dept_manager.emp_no = employees.emp_no
JOIN departments
	ON departments.dept_no = dept_manager.dept_no
WHERE dept_manager.to_date LIKE '9999%' AND employees.gender = 'F';

# It strikes me that I really don't even have to display the gender. I only need to call it in the WHERE statement...


-- Find the current titles of employees currently working in the Customer Service department.

SELECT titles.title AS Titulo, COUNT(titles.title) AS numeros_de_este_titulo
FROM titles
JOIN dept_emp
	ON dept_emp.emp_no = titles.emp_no
JOIN departments
	ON departments.dept_no = dept_emp.dept_no
WHERE dept_emp.to_date LIKE '9999%' AND departments.dept_name LIKE 'customer service'
GROUP BY titles.title;

-- Find the current salary of all current managers.

SELECT departments.dept_name AS dpto, CONCAT(employees.first_name, " ", employees.last_name) AS gerente, salaries.salary AS lana
FROM salaries
JOIN dept_manager
	ON dept_manager.emp_no = salaries.emp_no
JOIN employees
	ON employees.emp_no = dept_manager.emp_no
JOIN departments
	ON departments.dept_no = dept_manager.dept_no
WHERE dept_manager.to_date LIKE '9999%' AND salaries.to_date LIKE '9999%';

-- Find the number of current employees in each department.

SELECT dept_emp.dept_no AS dpto_no, departments.dept_name AS dpto, COUNT(dept_emp.dept_no)
FROM departments
JOIN dept_emp
	ON dept_emp.dept_no = departments.dept_no
WHERE dept_emp.to_date LIKE '9999%'
GROUP BY departments.dept_name, dept_emp.dept_no
ORDER BY dept_emp.dept_no;

-- Which department has the highest average salary? Hint: Use current not historic information.

SELECT departments.dept_name AS dpto, AVG(salaries.salary) AS grana_padano
FROM departments
JOIN dept_emp
	ON dept_emp.dept_no = departments.dept_no
JOIN salaries
	ON salaries.emp_no = dept_emp.emp_no
WHERE salaries.to_date LIKE '9999%'
GROUP BY dpto
ORDER BY grana_padano DESC;

# Sales is the highest paid department, on average.

-- Who is the highest paid employee in the Marketing department?

SELECT employees.first_name AS pila, employees.last_name as apellido
FROM employees
JOIN salaries
	ON salaries.emp_no = employees.emp_no
JOIN dept_emp
	ON dept_emp.emp_no = employees.emp_no
JOIN departments
	ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name LIKE 'Marketing'
ORDER BY salaries.salary DESC LIMIT 1;

-- Which current department manager has the highest salary?

SELECT CONCAT(employees.first_name, " ", employees.last_name) AS Boss, salaries.salary AS Boss_pay
FROM salaries
JOIN dept_manager
	ON dept_manager.emp_no = salaries.emp_no
JOIN employees
	ON employees.emp_no = dept_manager.emp_no
WHERE dept_manager.to_date LIKE '9999%'
ORDER BY Boss_pay DESC LIMIT 1;
 
-- Determine the average salary for each department. Use all salary information and round your results. 

SELECT departments.dept_name AS dpto, ROUND(AVG(salaries.salary),0) AS plata_prom
FROM departments
JOIN dept_emp
	ON dept_emp.dept_no = departments.dept_no
JOIN salaries
	ON salaries.emp_no = dept_emp.emp_no
GROUP BY dpto
ORDER BY plata_prom DESC;

# How do we round the numbers??

-- Bonus Find the names of all current employees, their department name, and their current manager's name.

SELECT employees.last_name
FROM employees
JOIN dept_manager
	ON dept_manager.emp_no = employees.emp_no
WHERE dept_manager.to_date LIKE '9999%' AS Boss_name
(SELECT CONCAT(employees.first_name, " ", employees.last_name) AS empleado, departments.dept_name AS dpto, Boss_name
FROM employees
JOIN dept_manager
	ON dept_manager.emp_no = employees.emp_no
WHERE dept_manager.emp_no

-- Bonus Who is the highest paid employee within each department.
