--SECTION 4
--10 Find all Courses by Client’s Phone Number
CREATE OR REPLACE FUNCTION fn_courses_by_client (phone_num VARCHAR(20)) RETURNS INT AS $$
DECLARE num_of_courses INT;
BEGIN
	SELECT 
		COUNT(*) INTO num_of_courses
	FROM courses AS c
	JOIN clients AS cli ON cli.id = c.client_id
	WHERE cli.phone_number = phone_num;
	RETURN num_of_courses;
END;
$$ LANGUAGE plpgsql;

SELECT
	fn_courses_by_client ('(803) 6386812');

--11 Full Info for Address
CREATE TABLE search_results (
	id SERIAL PRIMARY KEY,
	address_name VARCHAR(50),
	full_name VARCHAR(100),
	level_of_bill VARCHAR(20),
	make VARCHAR(30),
	condition CHAR(1),
	category_name VARCHAR(50)
);

CREATE OR REPLACE PROCEDURE sp_courses_by_address (address_name VARCHAR(100)) AS $$
BEGIN
	TRUNCATE search_results;

	INSERT INTO search_results(address_name, full_name,level_of_bill,make,condition,category_name)
	SELECT 
		a.name,
		cl.full_name,
		CASE
			WHEN co.bill <= 20 THEN 'Low'
			WHEN co.bill <= 30 THEN 'Medium'
			ELSE 'High'
		END,
		car.make,
		car.condition,
		cat.name
	FROM addresses AS a
	JOIN courses AS co ON co.from_address_id = a.id
	JOIN cars AS car ON car.id = co.car_id
	JOIN categories AS cat ON cat.id = car.category_id
	JOIN clients AS cl ON cl.id = co.client_id
	WHERE a.name = address_name
	ORDER BY car.make ASC, cl.full_name ASC; 
END;
$$ LANGUAGE plpgsql;

CALL sp_courses_by_address ('66 Thompson Drive');
CALL sp_courses_by_address('700 Monterey Avenue');
SELECT
	*
FROM
	search_results;--SECTION 4
--10 Find all Courses by Client’s Phone Number
CREATE OR REPLACE FUNCTION fn_courses_by_client (phone_num VARCHAR(20)) RETURNS INT AS $$
DECLARE num_of_courses INT;
BEGIN
	SELECT 
		COUNT(*) INTO num_of_courses
	FROM courses AS c
	JOIN clients AS cli ON cli.id = c.client_id
	WHERE cli.phone_number = phone_num;
	RETURN num_of_courses;
END;
$$ LANGUAGE plpgsql;

SELECT
	fn_courses_by_client ('(803) 6386812');

--11 Full Info for Address
CREATE TABLE search_results (
	id SERIAL PRIMARY KEY,
	address_name VARCHAR(50),
	full_name VARCHAR(100),
	level_of_bill VARCHAR(20),
	make VARCHAR(30),
	condition CHAR(1),
	category_name VARCHAR(50)
);

CREATE OR REPLACE PROCEDURE sp_courses_by_address (address_name VARCHAR(100)) AS $$
BEGIN
	TRUNCATE search_results;

	INSERT INTO search_results(address_name, full_name,level_of_bill,make,condition,category_name)
	SELECT 
		a.name,
		cl.full_name,
		CASE
			WHEN co.bill <= 20 THEN 'Low'
			WHEN co.bill <= 30 THEN 'Medium'
			ELSE 'High'
		END,
		car.make,
		car.condition,
		cat.name
	FROM addresses AS a
	JOIN courses AS co ON co.from_address_id = a.id
	JOIN cars AS car ON car.id = co.car_id
	JOIN categories AS cat ON cat.id = car.category_id
	JOIN clients AS cl ON cl.id = co.client_id
	WHERE a.name = address_name
	ORDER BY car.make ASC, cl.full_name ASC; 
END;
$$ LANGUAGE plpgsql;

CALL sp_courses_by_address ('66 Thompson Drive');
CALL sp_courses_by_address('700 Monterey Avenue');
SELECT
	*
FROM
	search_results;