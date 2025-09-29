--01 select cities
SELECT * FROM cities
ORDER BY id ASC;

--02 concatenate and reneme
SELECT 
	CONCAT(name, ' ', state) AS cities_information,
	area AS area_km2
FROM cities;

--03 remove dublicated rows
SELECT 
	DISTINCT name, 
	area AS area_km2 
FROM cities
	ORDER BY name DESC;

--04 limit records
SELECT 
	id,
	CONCAT(first_name, ' ', last_name) AS full_name,
	job_title
FROM employees
	ORDER BY first_name
	LIMIT 50;
	
--05 skip rows
SELECT 
	id,
	CONCAT(first_name, ' ',middle_name, ' ', last_name) AS full_name,
	hire_date
FROM employees
	ORDER BY hire_date
	OFFSET 9;

--06 Find the Addresses
SELECT 
	id,
	CONCAT(number, ' ', street) AS address,
	city_id
FROM addresses
	WHERE (id >= 20);

--07 Positive Even Number
SELECT
	CONCAT(number, ' ', street) AS address,
	city_id
FROM addresses
	WHERE (city_id % 2 = 0)
	ORDER BY city_id;

--08 Projects within a Date Range
SELECT
	name,
	start_date,
	end_date
FROM projects
	WHERE (start_date >= '2016-06-01 07:00:00')
	AND (end_date < '2023-06-04 00:00:00')
	ORDER BY start_date;

--09 Multiple Conditions
SELECT number, street
FROM addresses
WHERE id BETWEEN 50 AND 100 OR number < 1000;

--10 Set of Values
SELECT employee_id, project_id 
FROM employees_projects
WHERE 
	employee_id IN (200, 250) 
		AND 
	project_id NOT IN (50, 100);

--11 Compare Character Values
SELECT name, start_date
FROM projects
WHERE name IN('Mountain', 'Road', 'Touring')
LIMIT 20;

--12 Salary
SELECT 
	CONCAT(first_name, ' ', last_name) AS full_name,
	job_title,
	salary
FROM employees
WHERE salary IN (12500, 14000, 23600, 25000)
ORDER BY salary DESC;

--13 missing VALUE
SELECT id, first_name, last_name
FROM employees
WHERE middle_name IS NULL
LIMIT 3;

--14 INSERT into Departments
INSERT INTO 
	departments(department, manager_id)
VALUES
		('Finance', 3),
	('Information Services', 42),
	('Document Control', 90),
	('Quality Assurance', 274),
	('Facilities and Maintenance', 218),
	('Shipping and Receiving', 85),
	('Executive', 109);

--15 create new table and insert records from another table
CREATE TABLE company_chart
AS
SELECT 
	CONCAT(first_name, ' ', last_name) AS full_name, 
	job_title,
	department_id,
	manager_id
FROM employees;

--16 update the project end date
UPDATE 
	projects
SET
	end_date = start_date + INTERVAL '5 months'
WHERE 
	end_date IS NULL;

--17 Award Employees with Experience
UPDATE 
	employees
SET 
	salary = salary + 1500,
	job_title = 'Senior ' || job_title
WHERE hire_date BETWEEN '1998-01-01' AND '2000-01-05';

--18 delete from addresses
DELETE FROM addresses
WHERE city_id IN (5, 17, 20, 30);

--19 create VIEW
-- DROP VIEW view_company_chart;
CREATE VIEW view_company_chart 
	AS
SELECT 
	full_name,
	job_title
FROM 
	company_chart
WHERE 
	manager_id = 184;

--20 Create a View with Multiple Tables
CREATE VIEW view_addresses 
	AS
SELECT
	CONCAT(e.first_name, ' ', e.last_name) AS full_name,
	e.department_id,
	CONCAT(a.number, ' ', a.street) AS address
FROM 
employees AS e
JOIN addresses AS a
ON e.address_id = a.id
ORDER BY address;

--21 ALTER name of the VIEW
ALTER VIEW 
	view_addresses 
RENAME TO 
	view_employee_addresses_info;

--22 Drop View
DROP VIEW view_company_chart;

--23 *UPPER case
UPDATE projects
SET name = UPPER(name);

--24 *SUBSTRING
CREATE VIEW view_initials
AS
SELECT SUBSTRING(first_name, 1, 2) AS initial, last_name 
FROM employees
ORDER BY last_name;

--25 LIKE
SELECT
	name,
	start_date
FROM projects
WHERE
	name LIKE 'MOUNT%';