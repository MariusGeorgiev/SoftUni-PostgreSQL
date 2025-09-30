--00
CREATE DATABASE gringotts_db;

--01 COUNT of Records
SELECT
	COUNT(id)
FROM
	wizard_deposits;

--02 Total Deposit Amount
SELECT
	SUM(deposit_amount)
FROM
	wizard_deposits;

--03 AVG Magic Wand Size
SELECT
	ROUND(AVG(magic_wand_size), 3)
FROM
	wizard_deposits;

--04 MIN Deposit Charge
SELECT
	MIN(deposit_charge)
FROM
	wizard_deposits;

--05 MAX Age
SELECT
	MAX(age)
FROM
	wizard_deposits;

--06 GROUP BY Deposit Interest
SELECT
	deposit_group,
	SUM(deposit_interest)
FROM
	wizard_deposits
GROUP BY
	deposit_group
ORDER BY
	SUM(deposit_interest) DESC;

--07 LIMIT the Magic Wand Creator
SELECT
	magic_wand_creator,
	MIN(magic_wand_size)
FROM
	wizard_deposits
GROUP BY
	magic_wand_creator
ORDER BY
	MIN(magic_wand_size)
LIMIT
	5;

--08 Bank Profitability
SELECT
	deposit_group,
	is_deposit_expired,
	FLOOR(AVG(deposit_interest)) AS deposit_interest
FROM
	wizard_deposits
WHERE
	deposit_start_date > '1985-01-01'
GROUP BY
	deposit_group,
	is_deposit_expired
ORDER BY
	deposit_group DESC,
	is_deposit_expired ASC;

--09 Notes with Dumbledore
SELECT
	last_name,
	COUNT(notes) AS notes_with_dumbledore
FROM
	wizard_deposits
WHERE
	notes LIKE '%Dumbledore%'
GROUP BY
	last_name;

--10 Wizard View
CREATE VIEW view_wizard_deposits_with_expiration_date_before_1983_08_17 AS
SELECT
	CONCAT(first_name, ' ', last_name) AS wizard_name,
	deposit_start_date AS start_date,
	deposit_expiration_date AS expiration_date,
	deposit_amount AS amount
FROM
	wizard_deposits
WHERE
	deposit_expiration_date <= '1983-08-17'
GROUP BY
	wizard_name,
	start_date,
	expiration_date,
	amount
ORDER BY
	expiration_date;

--11 Filter Max Deposit
SELECT
	magic_wand_creator,
	MAX(deposit_amount)
FROM
	wizard_deposits
WHERE
	deposit_amount < 20000
	OR deposit_amount > 40000
GROUP BY
	magic_wand_creator
ORDER BY
	MAX(deposit_amount) DESC
LIMIT
	3;

--12 Age Group
SELECT
	CASE
		WHEN age BETWEEN 0 AND 10  THEN '[0-10]'
		WHEN age BETWEEN 11 AND 20  THEN '[11-20]'
		WHEN age BETWEEN 21 AND 30  THEN '[21-30]'
		WHEN age BETWEEN 31 AND 40  THEN '[31-40]'
		WHEN age BETWEEN 41 AND 50  THEN '[41-50]'
		WHEN age BETWEEN 51 AND 60  THEN '[51-60]'
		WHEN age >= 61 THEN '[61+]'
	END AS age_group,
	COUNT(*)
FROM
	wizard_deposits
GROUP BY
	age_group
ORDER BY
	age_group ASC;