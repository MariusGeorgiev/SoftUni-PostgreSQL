--00
CREATE DATABASE table_relations;

--01 PRIMARY KEY
CREATE TABLE IF NOT EXISTS products (product_name VARCHAR(100));

INSERT INTO
	products (product_name)
VALUES
	('Broccoli'),
	('Shampoo'),
	('Toothpaste'),
	('Candy');

ALTER TABLE products
ADD COLUMN id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY;

--02 Remove Primary Key
ALTER TABLE products
DROP CONSTRAINT products_pkey;

--03.00
CREATE DATABASE customs_db;

--03 Customs
CREATE TABLE passports (
	id INT GENERATED ALWAYS AS IDENTITY (
		START
		WITH
			100 INCREMENT BY 1
	) PRIMARY KEY,
	nationality VARCHAR(50)
);

INSERT INTO
	passports (nationality)
VALUES
	('N34FG21B'),
	('K65LO4R7'),
	('ZE657QP2');

CREATE TABLE people (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	salary DECIMAL(10, 2),
	passport_id INT REFERENCES passports (id)
);

INSERT INTO
	people (first_name, salary, passport_id)
VALUES
	('Roberto', 43300.0000, 101),
	('Tom', 56100.0000, 102),
	('Yana', 60200.0000, 100);

--04.00
CREATE DATABASE car_manufacture_db;

--04 Car Manufacture
CREATE TABLE manufacturers (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE models (
	id INT GENERATED ALWAYS AS IDENTITY (
		START
		WITH
			1000 INCREMENT BY 1
	) PRIMARY KEY,
	model_name VARCHAR(50),
	manufacturer_id INT REFERENCES manufacturers (id)
);

CREATE TABLE production_years (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	established_on DATE,
	manufacturer_id INT REFERENCES manufacturers (id)
);

INSERT INTO
	manufacturers (name)
VALUES
	('BMW'),
	('Tesla'),
	('Lada');

INSERT INTO
	models (model_name, manufacturer_id)
VALUES
	('X1', 1),
	('i6', 1),
	('Model S', 2),
	('Model X', 2),
	('Model 3', 2),
	('Nova', 3);

INSERT INTO
	production_years (established_on, manufacturer_id)
VALUES
	('1916-03-01', 1),
	('2003-01-01', 2),
	('1966-05-01', 3);

--05 only view ERD diagrame
--06.00
CREATE DATABASE photo_shooting_db;

--06 Photo Shooting
CREATE TABLE customers (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name VARCHAR(50),
	date DATE
);

CREATE TABLE photos (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	url VARCHAR(50),
	place VARCHAR(50),
	customer_id INT REFERENCES customers (id)
);

INSERT INTO
	customers (name, date)
VALUES
	('Bella', '2022-03-25'),
	('Philip', '2022-07-05');

INSERT INTO
	photos (url, place, customer_id)
VALUES
	('bella_1111.com', 'National Theatre', 1),
	('bella_1112.com', 'Largo', 1),
	('bella_1113.com', 'The View Restaurant', 1),
	('philip_1121.com', 'Old Town', 2),
	('philip_1122.com', 'Rowing Canal', 2),
	('philip_1123.com', 'Roman Theater', 2);

--07 only view ERD diagrame
--08.00
CREATE DATABASE study_session_db;

--08 Study Session 
CREATE TABLE students (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	student_name VARCHAR(50)
);

CREATE TABLE exams (
	id INT GENERATED ALWAYS AS IDENTITY (
		START
		WITH
			101 INCREMENT BY 1
	) PRIMARY KEY,
	exam_name VARCHAR(50)
);

CREATE TABLE study_halls (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	study_hall_name VARCHAR(50),
	exam_id INT REFERENCES exams (id)
);

CREATE TABLE students_exams (
	student_id INT REFERENCES students (id),
	exam_id INT REFERENCES exams (id)
);

INSERT INTO
	students (student_name)
VALUES
	('Mila'),
	('Toni'),
	('Ron');

INSERT INTO
	exams (exam_name)
VALUES
	('Python Advanced'),
	('Python OOP'),
	('PostgreSQL');

INSERT INTO
	study_halls (study_hall_name, exam_id)
VALUES
	('Open Source Hall', 102),
	('Inspiration Hall', 101),
	('Creative Hall', 103),
	('Masterclass Hall', 103),
	('Information Security Hall', 103);

INSERT INTO
	students_exams (student_id, exam_id)
VALUES
	(1, 101),
	(1, 102),
	(2, 101),
	(3, 103),
	(2, 102),
	(2, 103);

--09 only view ERD diagrame

--10.00
CREATE DATABASE online_store_db;
--10 Online Store 
CREATE TABLE item_types(
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
item_type_name VARCHAR(50)
);

CREATE TABLE items(
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
item_name VARCHAR(50),
item_type_id INT REFERENCES item_types(id)
);

CREATE TABLE cities(
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
city_name VARCHAR(50)
);

CREATE TABLE customers(
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
customer_name VARCHAR(50),
birthday DATE,
city_id INT REFERENCES cities(id)
);

CREATE TABLE orders(
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
customer_id INT REFERENCES customers(id)
);

CREATE TABLE order_items(
order_id INT REFERENCES orders(id),
item_id INT REFERENCES items(id),

CONSTRAINT order_items_pkey
PRIMARY KEY (order_id, item_id)
);

--11.00
CREATE DATABASE table_relations_geography_db;
--11 Delete Cascade
ALTER TABLE countries
ADD CONSTRAINT 
	continents_countries_fkey
FOREIGN KEY
	(continent_code)
REFERENCES 
	continents(continent_code)
ON DELETE CASCADE;

ALTER TABLE countries
ADD CONSTRAINT 
	currencies_countries_fkey
FOREIGN KEY
	(currency_code)
REFERENCES 
	currencies(currency_code)
ON DELETE CASCADE;

--12 Update Cascade
ALTER TABLE 
	countries_rivers
ADD CONSTRAINT countries_countries_rivers_river_id_fkey
FOREIGN KEY
	(river_id)
REFERENCES
	rivers(id)
ON UPDATE CASCADE,

ADD CONSTRAINT countries_countries_rivers_country_code_fkey
FOREIGN KEY
	(country_code)
REFERENCES
	countries(country_code)
ON UPDATE CASCADE;

--13 SET NULL
CREATE TABLE customers(
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
customer_name VARCHAR(50)
);

CREATE TABLE contacts( 
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
contact_name VARCHAR(50),
phone VARCHAR(50),
email VARCHAR(50),
customer_id INT REFERENCES customers(id) ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO customers(customer_name)
VALUES
('BlueBird Inc'),
('Dolphin LLC');

INSERT INTO contacts(contact_name,phone,email,customer_id)
VALUES
('John Doe',	'(408)-111-1234',	'john.doe@bluebird.dev',	1),
('Jane Doe',	'(408)-111-1235',	'jane.doe@bluebird.dev',	1),
('David Wright',	'(408)-222-1234',	'david.wright@dolphin.dev',	2);

DELETE FROM customers
WHERE id = 1;

--14 Peaks in Rila
SELECT m.mountain_range, p.peak_name, p.elevation
FROM mountains AS m
JOIN peaks AS p ON p.mountain_id = m.id
WHERE m.mountain_range = 'Rila'
ORDER BY p.elevation DESC;

--15 Countries Without Any Rivers
SELECT 
COUNT(*)
FROM countries AS c
LEFT JOIN countries_rivers AS cr
USING (country_code)
WHERE river_id IS NULL;