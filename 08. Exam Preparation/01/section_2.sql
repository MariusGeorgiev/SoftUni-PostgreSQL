-- SECTION 2
--02 Insert
INSERT INTO
	clients (full_name, phone_number)
SELECT
	CONCAT(first_name, ' ', last_name) AS full_name,
	'(088) 9999' || id * 2 AS phone_number
FROM
	drivers
WHERE
	id BETWEEN 10 AND 20;

--03 Update
UPDATE cars
SET
	condition = 'C'
WHERE
	(
		mileage >= 800000
		OR mileage IS NULL
	)
	AND year <= 2010
	-- make != 'Mercedes-Benz'
	-- make <> 'Mercedes-Benz'
	AND make NOT LIKE 'Mercedes-Benz';

--04 Delete
DELETE FROM clients 
WHERE 
	LENGTH(full_name) > 3
		AND 
	id NOT IN (
		SELECT client_id
		FROM courses
	);
