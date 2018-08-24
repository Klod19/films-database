-- Database: FILMS

-- DROP DATABASE "FILMS";

CREATE DATABASE "FILMS"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United Kingdom.1252'
    LC_CTYPE = 'English_United Kingdom.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
	
--CREATE TABLE table_name (
-- column_name COULUMN DATA TYPE
-- column_name COULUMN DATA TYPE
-- etc
-- )

CREATE TABLE directors (
	
	-- I want an id as an increasing number; I'll use SERIAL as data type --> increments with every new row
	-- I'll also set this id as the primary key, to establish links to other tables
	-- after data type, write PRIMARY KEY --> id field will become primary key
	id SERIAL PRIMARY KEY,
	-- the name, data type VARCHAR a string of max 30 characters (arbitrary limit, names can be long)
	-- the make 2 constraints: UNIQUE and NOT NULL
	-- 1) make name field UNIQUE, so that 2 directors can't have the same name --> 
	-- if we try to enter a name that already exists, we won't be allowed
	-- 2) NOT NULL --> if I try to enter a row without name, it won't be allowed
	name VARCHAR(30) UNIQUE NOT NULL,
	-- date of birth, data type DATE --> constraint NOT NULL too
	date_of_birth DATE NOT NULL,
	-- awards, data type INT
	awards INT	
);

SELECT * FROM directors;

/* I'll have to set FOREIGN KEYS*/
/* column_name_2 DATA TYPE REFERENCES table_name_1(column_name_1)*/
/* after REFERENCES we have the table name and the column name to which the created column refers*/

CREATE TABLE movies (

	id SERIAL PRIMARY KEY,
	name VARCHAR(40) UNIQUE NOT NULL,
	-- make the following as release year
	-- SELECT EXTRACT(YEAR FROM TIMESTAMP '2001-02-16 20:38:40');
	release_date DATE NOT NULL,
	--set the following two columns as FOREIGN ID:
	director INT REFERENCES directors(id),
	lead_actor INT, 
	-- rating needs a CHECK constraint, to allow only values between 1 and 100
	rating INT CHECK (rating BETWEEN 1 AND 100)
	
);

SELECT * FROM movies;