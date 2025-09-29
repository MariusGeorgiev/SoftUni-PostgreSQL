--18.0
CREATE DATABASE booking_db;

--18 Arithmetical Operators
CREATE TABLE bookings_calculation AS
SELECT
	booked_for,
	CAST(booked_for * 50 AS NUMERIC) AS multiplication,
	CAST(booked_for AS NUMERIC) AS modulo
FROM
	bookings
WHERE
	apartment_id = 93;

--19 ROUND vs TRUNC
SELECT
	latitude,
	ROUND(latitude, 2),
	TRUNC(latitude, 2)
FROM
	apartments;

--20 Absolute Value
SELECT
	longitude,
	ABS(longitude)
FROM
	apartments;

--21 Billing Day**	
ALTER TABLE bookings
ADD COLUMN billing_day TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;

SELECT
	TO_CHAR(
		billing_day,
		'DD "Day" Month "Month" YYYY "Year" HH24:MI:SS'
	) AS "Billing Day"
FROM
	bookings;

--22 EXTRACT Booked At
SELECT
	EXTRACT(
		YEAR
		FROM
			booked_at
	) AS "YEAR",
	EXTRACT(
		MONTH
		FROM
			booked_at
	) AS "MONTH",
	EXTRACT(
		DAY
		FROM
			booked_at
	) AS "DAY",
	EXTRACT(
		HOUR
		FROM
			booked_at
	) AS "HOUR",
	EXTRACT(
		MINUTE
		FROM
			booked_at
	) AS "MINUTE",
	CEIL(
		EXTRACT(
			SECOND
			FROM
				booked_at
		)
	) AS "SECOND"
FROM
	bookings;

--23 Early Birds** 
SELECT
	user_id,
	AGE(starts_at, booked_at) AS early_birds
FROM
	bookings
WHERE starts_at - booked_at >= '10 months';

--24 Match or Not
SELECT companion_full_name, email 
FROM users
WHERE companion_full_name ILIKE '%aNd%' AND email NOT LIKE '%@gmail';

--25 COUNT by Initial
SELECT 
	LEFT(first_name, 2) AS initials,
    COUNT('initials') AS user_count
FROM users
GROUP BY initials
ORDER BY user_count DESC, initials ASC;

--26 SUM*
SELECT SUM(booked_for) AS total_value
FROM bookings
WHERE apartment_id = 90;

--27 AVG*
SELECT AVG(multiplication) AS avg_value
FROM bookings_calculation;