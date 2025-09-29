--00 
CREATE DATABASE geography_db;

--01 river info
CREATE VIEW view_river_info AS
SELECT
	CONCAT(
		'The river ',
		river_name,
		' flows into the ',
		outflow,
		' and is ',
		"length",
		' kilometers long.'
	) AS "River Information"
FROM
	rivers
ORDER BY
	river_name;

--02 Concatenate Geography Data
CREATE VIEW view_continents_countries_currencies_details AS
SELECT
	CONCAT(
		RTRIM(LTRIM(c.continent_name)),
		': ',
		c.continent_code
	) AS continent_details,
	CONCAT(
		co.country_name,
		' - ',
		co.capital,
		' - ',
		co.area_in_sq_km,
		' - km2'
	) AS country_information,
	CONCAT(cur.description, ' (', cur.currency_code, ')') AS currencies
FROM
	continents AS c
	JOIN countries AS co ON c.continent_code = co.continent_code
	JOIN currencies AS cur ON cur.currency_code = co.currency_code
ORDER BY
	country_information,
	currencies;

--03 Capital Code
ALTER TABLE countries
ADD COLUMN capital_code CHAR(2);

UPDATE countries
SET
	capital_code = SUBSTRING(capital, 1, 2);

--04 (Descr)iption
--RIGHT(description, -4)
--SUBSTRING(description, FROM 5)
SELECT
	SUBSTRING(description, 5)
FROM
	currencies;

--05 Substring River Length
SELECT
	--(REGEXP_MATCHES("River Information", '([0-9]{1,4})'))[1], 
	SUBSTRING("River Information", '([0-9]{1,4})')
FROM
	view_river_info;

--06 Replace A
SELECT
	REPLACE(mountain_range, 'a', '@') AS replace_a,
	REPLACE(mountain_range, 'A', '$') AS "replace_A"
FROM
	mountains;

--07 Translate
SELECT
	capital,
	TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') AS translate_name
FROM
	countries;

--08 LEADING
SELECT
	continent_name,
	RTRIM(LTRIM(continent_name)) AS "trim"
FROM
	continents;

--09 TRAILING
SELECT
	continent_name,
	--TRIM(continent_name) AS "trim" 
	BTRIM(continent_name) AS "trim"
FROM
	continents;

--10 LTRIM & RTRIM
SELECT
	LTRIM(peak_name, 'M') AS left_trim,
	RTRIM(peak_name, 'm') AS right_trim
FROM
	peaks;

--11 Character Length and Bits
SELECT
	CONCAT(mountain_range, ' ', peak_name) AS mountain_information,
	LENGTH(CONCAT(mountain_range, ' ', peak_name)) AS characters_length,
	BIT_LENGTH(CONCAT(mountain_range, ' ', peak_name)) AS bits_of_a_tring
FROM
	mountains
	JOIN peaks ON peaks.mountain_id = mountains.id;

--12 Length of a Number
SELECT
	population,
	LENGTH(CAST(population AS VARCHAR)) AS "length"
FROM
	countries;

--13 Positive and Negative LEFT
SELECT
	peak_name,
	SUBSTRING(peak_name, 1, 4) AS positive_left,
	LEFT(peak_name, -4) AS negative_left
FROM
	peaks;

--14 Positive and Negative RIGHT
SELECT
	peak_name,
	RIGHT(peak_name, 4) AS positive_right,
	RIGHT(peak_name, -4) AS negative_right
FROM
	peaks;

--15 Update iso_code
--RETURNING*
UPDATE countries
SET
	iso_code = UPPER(LEFT(country_name, 3))
WHERE
	iso_code IS NULL;

--16 REVERSE country_code
UPDATE countries
SET
	country_code = REVERSE(LOWER(country_code));

--17 Elevation --->> Peak Name
SELECT
	CONCAT_WS(
		' ',
		elevation,
		REPEAT('-', 3) || REPEAT('>', 2),
		peak_name
	) AS "Elevation -->> Peak Name"
FROM
	peaks
WHERE
	elevation >= 4884;
