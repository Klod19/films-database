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

/* EXERCISES*/

--1. Create a producers table, with id, name and date_of_birth columns. 
--   Make the id a primary key and the name unique. 

CREATE TABLE producers (

	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL,
	date_of_birth DATE,
	movies INT REFERENCES movies(id)
);


--2. Create a writers table with id, name and date_of_birth columns. 
--   Make the id a primary key and add any constraints that you like. 

CREATE TABLE writers (

	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL,
	date_of_birth DATE NOT NULL,
	movies INT REFERENCES movies(id),
	rating INT CHECK(rating BETWEEN 1 AND 100)
);


/* ADD and DROP (remove) columns from a table*/
/*	ALTER TABLE table_name
	ADD column_name DATA TYPE constraints (for example NOT NULL)
	
	ALTER TABLE table_name
	DROP column_name
*/


SELECT * FROM directors;
SELECT * FROM movies;

ALTER TABLE directors
ADD nationality VARCHAR(20);

-- NUMERIC(n, m) (equal to DECIMAL); has 2 numbers as parameters
-- n: the total amount of numbers composing the decimal number
-- m: the total amount of numbers after the decimal point
ALTER TABLE movies
ADD earnings NUMERIC(6,2) NOT NULL;

ALTER TABLE movies
DROP rating;

/* MODIFYING COLUMNS (foreign keys, constraints, data types)*/

CREATE TABLE actors(

	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL,
	gender CHAR(1),
	date_of_birth DATE NOT NULL,
	nationality VARCHAR (20) NOT NULL
	
);

SELECT * FROM actors;
SELECT * FROM movies;

-- the column lead_actor from table movies doesn't have a foreign key connecting it to table actors
-- to add a foreign key to a table:
-- ALTER TABLE table_name_1 ADD FOREIGN KEY(column_name_1) REFERENCES table_name_2(column_name_2)

ALTER TABLE movies ADD FOREIGN KEY(lead_actor) REFERENCES actors(id);

-- add a UNIQUE constraint on the name field from actors table
-- ALTER TABLE table_name ADD CONSTRAINT constraint_name CONSTRAINT TYPE (column_name)
-- note: the constraint_name will not appear, it's just the name we gave to the constraint

ALTER TABLE actors ADD CONSTRAINT unique_name UNIQUE (name);

-- DROP (cancel) a  UNIQUE constraint
-- ALTER TABLE table_name DROP CONSTRAINT constraint_name

ALTER TABLE actors DROP CONSTRAINT unique_name;

-- !! SET (like ADD) a NOT NULL constraint (different from adding a UNIQUE)
-- ALTER TABLE table_name ALTER COLUMN column_name SET NOT NULL

ALTER TABLE actors ALTER COLUMN nationality SET NOT NULL;

-- DROP a NOT NULL constraint
-- ALTER TABLE table_name ALTER COLUMN column_name DROP NOT NULL

ALTER TABLE actors ALTER COLUMN nationality DROP NOT NULL;

-- ALTER a DATA TYPE
-- ALTER TABLE table_name ALTER COLUMN column_name TYPE DATA_TYPE_NAME(n)

ALTER TABLE actors ALTER COLUMN name TYPE VARCHAR(100);

/* REMOVE TABLES FROM DATABASE */
-- let's make a table first and insert some data into it
-- to delete it:
-- DROP TABLE table_name

CREATE TABLE example (

	id SERIAL PRIMARY KEY,
	name VARCHAR(20),
	gender CHAR(1)

);

INSERT INTO example (name, gender )
VALUES ('Martin', 'M');

INSERT INTO example(name, gender)
VALUES ('Ruth', 'F');

INSERT INTO example(name, gender)
VALUES ('Kim', 'F');

SELECT * FROM example;

DROP TABLE example;


/* TRUNCATE --> remove all rows from a table*/
/* it first deletes the table with DROP TABLE, then runs a CREATE of it; it will have no rows*/
/* TRUNCATE table_name*/

SELECT * FROM example;

TRUNCATE example;

/*EXERCISES*/

-- 1. Add a producer_id column to the movies table. 

ALTER TABLE movies 
ADD producer_id INT UNIQUE REFERENCES producers(id);

SELECT * FROM movies;

-- 2. Add a foreign key constraint to the producer_id column in the movies table 
-- that references the id column in the producers table. 
-- already done in the line before, but it would go this way:
ALTER TABLE movies ADD FOREIGN KEY (producer_id) REFERENCES producers(id);

 -- looks loke it can also modify the reference (the following is pointless, but works)
ALTER TABLE movies ADD FOREIGN KEY (producer_id) REFERENCES actors(id);


-- 3. Remove the writers table from the database. 
DROP TABLE writers;


/* SECTION 7: DATA MANIPULATION LANGUAGE*/

/* INSERT INTO --> insert data in a table */
/* INSERT INTO table_name (column_name_1, column_name_2, column_name_3 etc)
   VALUES ('value_1', 'value_2', value_3)
*/
/* !! note: strings need quotation marks, integers/numbers don't */

SELECT * FROM directors;

INSERT INTO directors (name, date_of_birth, awards, nationality)
VALUES ('Christopher Nolan', '19700730', 7, 'British');

-- I can also insert NULL values if there's no constraint against it:

INSERT INTO directors (name, date_of_birth, awards, nationality)
VALUES ('Danny Boyle', '19561020', 12, NULL);

-- There's an UNIQUE constraint on column "name", so there cannot be duplicates;
-- the following will return an error

INSERT INTO directors (name, date_of_birth, awards, nationality)
VALUES ('Christopher Nolan', '19700730', 7, 'yank');

-- insert 2 more rows:

INSERT INTO directors (name, date_of_birth, awards, nationality)
VALUES ('Jonathan Nolan', '19760606', 4, 'British');

INSERT INTO directors (name, date_of_birth, awards, nationality)
VALUES ('Luc Besson', '19590318', 9, 'French');


/*UPDATE data in a table */
/* UPDATE table_name 
   SET column_name_1 = new_value_x (with '' if string), column_name_2 = new_value_y
   WHERE clause (if needed)
*/

-- change 'Luc Besson' to 'Luke Besson' (which is wrong)

UPDATE directors
SET name = 'Luke Besson'
WHERE name = 'Luc Besson';

-- with the following I set all the nationalities to British (because no WHERE clause -- > every value updated)

UPDATE directors
SET nationality = 'British';

-- But this is wrong! Let's correct it, and correct also Luke Besson to Luc Besson

UPDATE directors
SET name = 'Luc Besson', nationality = 'French'
WHERE id = 5;

-- I would like to change the nationality of both the Nolans

UPDATE directors
SET nationality = 'Virgin Islands LOL'
WHERE name LIKE '%Nolan%';

