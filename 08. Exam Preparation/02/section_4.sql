--SECTION 4
--11
CREATE OR REPLACE FUNCTION fn_get_volunteers_count_from_department(
searched_volunteers_department VARCHAR(30)
)
RETURNS INT
AS
$$
DECLARE count_of_volunteers INT;
BEGIN
	-- count_of_volunteers := (
	-- SELECT COUNT(*) FROM volunteers AS v
	-- JOIN volunteers_departments AS vd ON vd.id = v.department_id
	-- WHERE vd.department_name = searched_volunteers_department;
	-- );

	SELECT COUNT(*) INTO count_of_volunteers FROM volunteers AS v
	JOIN volunteers_departments AS vd ON vd.id = v.department_id
	WHERE vd.department_name = searched_volunteers_department;
	
	RETURN count_of_volunteers;
END;
$$
LANGUAGE plpgsql;

SELECT fn_get_volunteers_count_from_department('Education program assistant');
SELECT fn_get_volunteers_count_from_department('Guest engagement');
SELECT fn_get_volunteers_count_from_department('Zoo events');

--12
CREATE OR REPLACE PROCEDURE sp_animals_with_owners_or_not(
	IN animal_name VARCHAR(30),
	OUT result VARCHAR(30)
)
AS
$$
BEGIN
	SELECT 
		o.name 
	FROM owners AS o
	JOIN animals AS a ON a.owner_id = o.id
	WHERE a.name = animal_name
	INTO result;
	IF result IS NULL THEN result := 'For adoption'; END IF;
END;
$$
LANGUAGE plpgsql;

--CALL sp_animals_with_owners_or_not('Pumpkinseed Sunfish', NULL);
CALL sp_animals_with_owners_or_not('Pumpkinseed Sunfish', '');
