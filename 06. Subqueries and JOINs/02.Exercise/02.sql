--11.00
CREATE DATABASE subqueries_joins_geography_db;

--11 Bulgaria's Peaks Higher than 2835 Meters
SELECT
	mc.country_code,
	m.mountain_range,
	p.peak_name,
	p.elevation
FROM
	mountains AS m
	JOIN peaks AS p ON p.mountain_id = m.id
	JOIN mountains_countries AS mc ON mc.mountain_id = m.id
WHERE
	p.elevation > 2835
	AND mc.country_code = 'BG'
ORDER BY
	p.elevation DESC;

--12 Count Mountain Ranges
SELECT
	mc.country_code,
	COUNT(*) AS mountain_range_count
FROM
	mountains_countries AS mc
	JOIN mountains AS m ON m.id = mc.mountain_id
WHERE
	mc.country_code IN ('BG', 'RU', 'US')
GROUP BY
	mc.country_code
ORDER BY
	mountain_range_count DESC;

--13 Rivers in Africa
SELECT
	c.country_name,
	r.river_name
FROM
	continents AS con
	LEFT JOIN countries AS c USING (continent_code)
	LEFT JOIN countries_rivers AS cr USING (country_code)
	LEFT JOIN rivers AS r ON r.id = cr.river_id
WHERE
	con.continent_name = 'Africa'
ORDER BY
	c.country_name
LIMIT
	5;

--14 Minimum Average Area Across Continents
SELECT
	MIN(avg_area) AS min_average_area
FROM
	(
		SELECT
			AVG(area_in_sq_km) AS avg_area
		FROM
			countries
		GROUP BY
			continent_code
	) AS sub;

--15 Countries Without Any Mountains
SELECT
	COUNT(*) AS countries_without_mountains
FROM
	countries AS c
	LEFT JOIN mountains_countries AS mc USING (country_code)
WHERE
	mc.mountain_id IS NULL;

--16 Monasteries by Country
CREATE TABLE monasteries (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	monastery_name VARCHAR(255),
	country_code CHAR(2)
);

INSERT INTO
	monasteries (monastery_name, country_code)
VALUES
	('Rila Monastery "St. Ivan of Rila"', 'BG'),
	('Bachkovo Monastery "Virgin Mary"', 'BG'),
	(
		'Troyan Monastery "Holy Mother''s Assumption"',
		'BG'
	),
	('Kopan Monastery', 'NP'),
	('Thrangu Tashi Yangtse Monastery', 'NP'),
	('Shechen Tennyi Dargyeling Monastery', 'NP'),
	('Benchen Monastery', 'NP'),
	('Southern Shaolin Monastery', 'CN'),
	('Dabei Monastery', 'CN'),
	('Wa Sau Toi', 'CN'),
	('Lhunshigyia Monastery', 'CN'),
	('Rakya Monastery', 'CN'),
	('Monasteries of Meteora', 'GR'),
	('The Holy Monastery of Stavronikita', 'GR'),
	('Taung Kalat Monastery', 'MM'),
	('Pa-Auk Forest Monastery', 'MM'),
	('Taktsang Palphug Monastery', 'BT'),
	('Sümela Monastery', 'TR');

ALTER TABLE countries
ADD COLUMN three_rivers BOOLEAN DEFAULT FALSE;

UPDATE countries
SET
	three_rivers = (
		SELECT
			COUNT(*) >= 3
		FROM
			countries_rivers AS cr
		WHERE
			cr.country_code = countries.country_code
	);

SELECT
	m.monastery_name,
	c.country_name
FROM
	monasteries AS m
	JOIN countries AS c USING (country_code)
WHERE
	NOT three_rivers
ORDER BY
	m.monastery_name;

--17. Monasteries by Continents and Countries
UPDATE countries
SET
	country_name = 'Burma'
WHERE
	country_name = 'Myanmar';

INSERT INTO
	monasteries (monastery_name, country_code)
VALUES
	(
		'Hanga Abbey',
		(
			SELECT
				country_code
			FROM
				countries
			WHERE
				country_name = 'Tanzania'
		)
	),
	(
		'Myin-Tin-Daik',
		(
			SELECT
				country_code
			FROM
				countries
			WHERE
				country_name = 'Myin-Tin-Daik'
		)
	);

SELECT
	con.continent_name,
	c.country_name,
	COUNT(m.country_code) AS monasteries_count
FROM
	continents AS con
	JOIN countries AS c USING (continent_code)
	LEFT JOIN monasteries AS m USING (country_code)
WHERE
	NOT three_rivers
GROUP BY
	c.country_name,
	con.continent_name
ORDER BY
	monasteries_count DESC,
	c.country_name ASC;

--18 Retrieving Information about Indexes
SELECT
	tablename,
	indexname,
	indexdef
FROM
	pg_indexes
WHERE
	schemaname = 'public'
ORDER BY
	tablename,
	indexname;

--19 Continents and Currencies
CREATE VIEW continent_currency_usage AS
SELECT
	ra.continent_code,
	ra.currency_code,
	ra.currency_usage
FROM
	(
		SELECT
			ct.continent_code,
			ct.currency_code,
			ct.currency_usage,
			DENSE_RANK() OVER (
				PARTITION BY
					ct.continent_code
				ORDER BY
					ct.currency_usage DESC
			) AS ranked_usage
		FROM
			(
				SELECT
					continent_code,
					currency_code,
					COUNT(currency_code) AS currency_usage
				FROM
					countries
				GROUP BY
					continent_code,
					currency_code
				HAVING
					COUNT(currency_code) > 1
			) AS ct
	) AS ra
WHERE
	ra.ranked_usage = 1
ORDER BY
	currency_usage DESC;

--20 The Highest Peak in Each Country
WITH
	results AS (
		SELECT
			c.country_name,
			COALESCE(p.peak_name, '(no highest peak)') AS highest_peak_name,
			COALESCE(p.elevation, 0) AS highest_peak_elevation,
			COALESCE(m.mountain_range, '(no mountain)') AS mountain,
			ROW_NUMBER() OVER (
				PARTITION BY
					c.country_name
				ORDER BY
					p.elevation DESC
			) AS row_num
		FROM
			countries AS c
			LEFT JOIN mountains_countries AS mc USING (country_code)
			LEFT JOIN peaks AS p USING (mountain_id)
			LEFT JOIN mountains AS m ON m.id = p.mountain_id
	)
SELECT
	country_name,
	highest_peak_name,
	highest_peak_elevation,
	mountain
FROM
	results
WHERE
	row_num = 1
ORDER BY
	country_name ASC,
	highest_peak_elevation DESC;