--00 create database
CREATE DATABASE minions_db;


--01 create table
CREATE TABLE minions	(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30),
	age INT 
);

--02 change table name
ALTER TABLE minions RENAME TO minions_info;


--03 add new columns to table
ALTER TABLE minions_info
ADD COLUMN code CHAR(4) NOT NULL,
ADD COLUMN task TEXT NOT NULL,
ADD COLUMN salary DECIMAL(8,3);

--04 change name of column 
ALTER TABLE minions_info 
RENAME COLUMN salary TO banana;

--05 add new column
ALTER TABLE minions_info
ADD COLUMN email VARCHAR(20),
ADD COLUMN equipped BOOLEAN NOT NULL;

--06 create ENUM type
CREATE TYPE type_mood AS ENUM (
'happy',
'relaxed',
'stressed',
'sad'
);
ALTER TABLE minions_info
ADD COLUMN mood type_mood;

--07 set default
ALTER TABLE minions_info
ALTER COLUMN age SET DEFAULT 0,
ALTER COLUMN name SET DEFAULT '',
ALTER COLUMN code SET DEFAULT '';

--08 add constraints
ALTER TABLE minions_info
ADD CONSTRAINT unique_containt UNIQUE (id, email), -- uq_minions_info_id_email
ADD CONSTRAINT banana_check CHECK (banana > 0); -- chk_minions_info_banana_greater_then_zero

--09 Change Column’s Data Type
ALTER TABLE minions_info
ALTER COLUMN task TYPE VARCHAR(150);

--10 Drop Constraint
ALTER TABLE minions_info
ALTER COLUMN equipped
DROP NOT NULL; 

--11 Remove Column
ALTER TABLE minions_info
DROP COLUMN age;

--12 create Table Birthdays
CREATE TABLE minions_birthdays (
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name VARCHAR(50),
date_of_birth DATE,
age INT,
present VARCHAR(100),
party TIMESTAMPTZ
);

--13 Insert data Into some colums
INSERT INTO minions_info(
	name,
	code,
	task,
	banana,
	email, 
	equipped, 
	mood
)
VALUES
	('Mark', 'GKYA', 'Graphing Points', 3265.265, 'mark@minion.com', false, 'happy'),
	('Mel', 'HSK', 'Science Investigation', 54784.996, 'mel@minion.com', true, 'stressed'),
	('Bob', 'HF', 'Painting', 35.652, 'bob@minion.com', true, 'happy'),
	('Darwin', 'EHND', 'Create a Digital Greeting', 321.958, 'darwin@minion.com', false, 'relaxed'),
	('Kevin', 'KMHD', 'Construct with Virtual Blocks', 35214.789, 'kevin@minion.com', false, 'happy'),
	('Norbert', 'FEWB', 'Testing', 3265.500, 'norbert@minion.com', true, 'sad'),
	('Donny', 'L', 'Make a Map', 8.452, 'donny@minion.com', true, 'happy');


--14 Select some colums from some table
SELECT name,task,email,banana 
FROM minions_info;

--15 Truncate the Table
TRUNCATE TABLE minions_info;

--16 Drop the Table
DROP TABLE minions_birthdays;

--17.0 create db
CREATE DATABASE mini_db;
--17 Drop database
DROP DATABASE mini_db WITH (FORCE);

--18 bonus
CREATE TYPE address AS (
street VARCHAR(100),
city VARCHAR(50),
zip_code CHAR(4)
);

CREATE TABLE custumers(
id SERIAL PRIMARY KEY,
name VARCHAR(50),
customer_address address
);

INSERT INTO 
	customers(name, customer_address)
VALUES
	('pesho', ('maritsa', 'Sofia', '1600'));

SELECT * FROM customers;