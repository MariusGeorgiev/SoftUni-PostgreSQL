--00
CREATE DATABASE subqueries_joins_booking_db;

--01 Booked for Nights
SELECT
	CONCAT(a.address, ' ', a.address_2) AS apartment_address,
	booked_for AS nights
FROM
	apartments AS a
	JOIN bookings AS b ON b.booking_id = a.booking_id
ORDER BY
	a.apartment_id;

--02 First 10 Apartments Booked At
SELECT
	a.name,
	a.country,
	DATE (b.booked_at)
FROM
	apartments AS a
	LEFT JOIN bookings AS b ON b.booking_id = a.booking_id
LIMIT
	10;

--03 First 10 Customers with Bookings
SELECT
	b.booking_id,
	DATE (b.starts_at) AS starts_at,
	b.apartment_id,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM
	bookings AS b
	RIGHT JOIN customers AS c ON b.customer_id = c.customer_id
ORDER BY
	customer_name ASC
LIMIT
	10;

--04 Booking Information
SELECT
	b.booking_id,
	a.name AS apartment_owner,
	a.apartment_id,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM
	apartments AS a
	FULL JOIN bookings AS b USING (booking_id)
	FULL JOIN customers AS c USING (customer_id)
ORDER BY
	b.booking_id ASC,
	apartment_owner ASC,
	customer_name ASC;

--05 Multiplication of Information**
SELECT
	b.booking_id,
	c.first_name AS customer_name
FROM
	bookings AS b
	CROSS JOIN customers AS c
ORDER BY
	customer_name;

--06 Unassigned Apartments
SELECT
	b.booking_id,
	b.apartment_id,
	c.companion_full_name
FROM
	bookings AS b
	JOIN customers AS c USING (customer_id)
WHERE
	b.apartment_id IS NULL;

--07 Bookings Made by Lead
SELECT
	b.apartment_id,
	b.booked_for,
	c.first_name,
	c.country
FROM
	bookings AS b
	JOIN customers AS c USING (customer_id)
WHERE
	job_type = 'Lead';

--08 Hahn`s Bookings
SELECT
	COUNT(*)
FROM
	bookings AS b
	JOIN customers AS c USING (customer_id)
WHERE
	c.last_name = 'Hahn';

--09 Total Sum of Nights
SELECT
	a.name,
	SUM(b.booked_for)
FROM
	apartments AS a
	JOIN bookings AS b USING (apartment_id)
GROUP BY
	a.name
ORDER BY
	a.name;

--10 Popular Vacation Destination
SELECT
	a.country,
	COUNT(b.booking_id) AS booking_count
FROM
	bookings AS b
	JOIN apartments AS a USING (apartment_id)
	WHERE
	b.booked_at > '2021-05-18 07:52:09.904+03'
	AND b.booked_at < '2021-09-17 19:48:02.147+03'
GROUP BY
	a.country
ORDER BY booking_count DESC;