--SECTION 3
--05 cars 
SELECT
	make,
	model,
	condition
FROM
	cars
ORDER BY
	id ASC;

--06 drivers and cars
SELECT
	d.first_name,
	d.last_name,
	c.make,
	c.model,
	c.mileage
FROM
	drivers AS d
	JOIN cars_drivers AS cd ON cd.driver_id = d.id
	JOIN cars AS c ON c.id = cd.car_id
WHERE
	c.mileage IS NOT NULL
ORDER BY
	c.mileage DESC,
	d.first_name;

--07 Number of Courses for Each Car
SELECT
	c.id,
	c.make,
	c.mileage,
	COUNT(cou.id) AS count_of_courses,
	ROUND(AVG(cou.bill), 2) AS average_bill
FROM
	cars AS c
	LEFT JOIN courses AS cou ON cou.car_id = c.id
GROUP BY
	c.id
HAVING
	COUNT(cou.id) <> 2
ORDER BY
	count_of_courses DESC,
	c.id;

--08 Regular Clients
SELECT
	cli.full_name,
	COUNT(cli.id) AS count_of_cars,
	SUM(cou.bill) AS total_sum
FROM
	clients AS cli
	JOIN courses AS cou ON cou.client_id = cli.id
WHERE
	-- cli.full_name LIKE '_a%'
	SUBSTRING(cli.full_name, 2, 1) = 'a'
GROUP BY
	cli.id
HAVING COUNT(cli.id) > 1
ORDER BY
	cli.full_name;

--09 Full Information of Courses
SELECT 
	a.name AS address,
	CASE 
		WHEN EXTRACT(HOUR FROM co.start) BETWEEN 6 AND 20 THEN 'Day'
		ELSE 'Night'
	END AS day_time,
	co.bill,
	cli.full_name,
	c.make,
	c.model,
	cat.name AS category_name
FROM courses AS co
JOIN addresses AS a ON a.id = co.from_address_id
JOIN clients AS cli ON cli.id = co.client_id
JOIN cars AS c ON c.id = co.car_id
JOIN categories AS cat ON cat.id = c.category_id
ORDER BY co.id;