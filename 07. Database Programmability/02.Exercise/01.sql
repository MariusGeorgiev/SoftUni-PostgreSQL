--01 User-defined Function Full Name
CREATE OR REPLACE FUNCTION fn_full_name (
first_name VARCHAR(50),
last_name VARCHAR(50)
) RETURNS VARCHAR(101) 
AS 
$$
BEGIN
	RETURN INITCAP(LOWER(first_name)) || ' ' || INITCAP(LOWER(last_name));
END;
$$ 
LANGUAGE plpgsql;

--test 01
SELECT fn_full_name ('DIDO', 'dido');

SELECT
	INITCAP(LOWER('first_name')) || ' ' || INITCAP(LOWER('DIDO'));

--02 User-defined Function Future Value
CREATE OR REPLACE FUNCTION fn_calculate_future_value(
initial_sum DECIMAL,
yearly_interest_rate DECIMAL,
number_of_years INT
) RETURNS DECIMAL
AS
$$
BEGIN 
	RETURN TRUNC(
	initial_sum * POWER((1 + yearly_interest_rate), number_of_years), 
	4
	);
END;
$$
LANGUAGE plpgsql;

SELECT fn_calculate_future_value(1000, 0.1, 5);

--03 User-defined Function Is Word Comprised
CREATE OR REPLACE FUNCTION fn_is_word_comprised(
set_of_letters VARCHAR(50),
word VARCHAR(50)
) RETURNS BOOLEAN
AS
$$
DECLARE
	i INT;
	letter CHAR(1);
BEGIN 
	FOR i IN 1..LENGTH(word) LOOP
		letter := SUBSTRING(LOWER(word), i, 1);

		IF POSITION(letter IN LOWER(set_of_letters)) = 0 THEN
			RETURN FALSE;
		END IF;
	END LOOP;

	RETURN TRUE;
	
END;
$$
LANGUAGE plpgsql;

SELECT fn_is_word_comprised('ois tmiah%f', 'halves');

--03.1 different solution
CREATE OR REPLACE FUNCTION fn_is_word_comprised(
set_of_letters VARCHAR(50),
word VARCHAR(50)
) RETURNS BOOLEAN
AS
$$
BEGIN 
	RETURN TRIM(LOWER(word), LOWER(set_of_letters)) = '' ;
END;
$$
LANGUAGE plpgsql;
SELECT fn_is_word_comprised('ois tmiah%f', 'halves');

--04.00
CREATE DATABASE diablo_db;
--04 Game Over
CREATE OR REPLACE FUNCTION fn_is_game_over(
is_game_over BOOLEAN
) RETURNS TABLE (
	name VARCHAR(50),
	game_type_id INT,
	is_finished BOOLEAN
)
AS
$$
BEGIN 
	RETURN QUERY
	SELECT 
		g.name,
		g.game_type_id,
		g.is_finished
	FROM 
		games AS g
	WHERE 
		g.is_finished = is_game_over;
END;
$$
LANGUAGE plpgsql;

SELECT fn_is_game_over(TRUE);

--05 Difficulty Level
CREATE OR REPLACE FUNCTION fn_difficulty_level(
level INT
) RETURNS VARCHAR 
AS
$$
DECLARE 
	difficulty_level VARCHAR;
BEGIN 
	IF (level <= 40) THEN difficulty_level := 'Normal Difficulty';
	ELSEIF (level <= 60) THEN difficulty_level := 'Nightmare Difficulty';
	ELSE difficulty_level := 'Hell Difficulty';
	END IF;
	
	RETURN difficulty_level;
END;
$$
LANGUAGE plpgsql;

SELECT 
	user_id,
	level,
	cash,
	fn_difficulty_level(level) AS difficulty_level
FROM 
	users_games
ORDER BY 
	user_id ASC;

--06 Cash in User Games Odd Rows
CREATE OR REPLACE FUNCTION fn_cash_in_users_games(
game_name VARCHAR(50)
) RETURNS TABLE (
total_cash NUMERIC
)
AS
$$
BEGIN 
RETURN QUERY

		WITH 
			ranked_game_rows
		AS (
			SELECT 
				cash,
				ROW_NUMBER() OVER (ORDER BY cash DESC)
			FROM 
				games AS g
			JOIN users_games AS ug
			ON ug.game_id = g.id
			WHERE g.name = game_name
			)

			SELECT ROUND(SUM(cash), 2) AS total_cash FROM ranked_game_rows
			WHERE row_number % 2 <> 0;

	
END;
$$
LANGUAGE plpgsql;

SELECT * FROM fn_cash_in_users_games('Love in a mist');
