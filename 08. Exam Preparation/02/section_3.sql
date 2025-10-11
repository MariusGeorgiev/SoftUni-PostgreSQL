DROP TABLE volunteers_departments,
volunteers,
owners,
animals,
cages,
animal_types,
animals_cages;

--SECTION 3
--05
SELECT
	name,
	phone_number,
	address,
	animal_id,
	department_id
FROM
	volunteers
ORDER BY
	name ASC,
	animal_id ASC,
	department_id ASC;

--06
SELECT
	a.name,
	a_t.animal_type,
	TO_CHAR(a.birthdate, 'DD.MM.YYYY') AS birthdate
FROM
	animals AS a
	JOIN animal_types AS a_t ON a_t.id = a.animal_type_id
ORDER BY
	a.name;

--07
SELECT
	o.name AS owner,
	COUNT(*) AS count_of_animals
FROM
	owners AS o
	JOIN animals AS a ON a.owner_id = o.id
GROUP BY
	o.name
ORDER BY
	count_of_animals DESC,
	o.name
LIMIT
	5;

--08
SELECT
	CONCAT(o.name, ' - ', a.name) AS "owners - animals",
	o.phone_number,
	ac.cage_id
FROM
	owners AS o
	JOIN animals AS a ON a.owner_id = o.id
	JOIN animals_cages AS ac ON ac.animal_id = a.id
	JOIN animal_types AS at ON at.id = a.animal_type_id
WHERE
	at.animal_type = 'Mammals'
ORDER BY
	o.name,
	a.name DESC;

SELECT
	*
FROM
	animal_types;

--09
SELECT
	v.name AS volunteers,
	v.phone_number,
	TRIM(v.address, 'Sofia, ') AS address
FROM
	volunteers AS v
	JOIN volunteers_departments AS vd ON vd.id = v.department_id
WHERE
	v.address LIKE '%Sofia%'
	AND vd.department_name = 'Education program assistant'
ORDER BY
	volunteers;

--10
SELECT
	a.name AS animal,
	-- date_part('year', a.birthdate) AS birth_year,
	EXTRACT(YEAR FROM a.birthdate) AS birth_year,
	at.animal_type
FROM
	animals AS a
	JOIN animal_types AS at ON at.id = a.animal_type_id
WHERE
	a.owner_id IS NULL AND at.animal_type NOT LIKE 'Birds' AND AGE('01/01/2022', a.birthdate) <= '5 YEAR'
ORDER BY
	a.name;