/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon"
select * from animals where name like '%mon';

-- List the name of all animals born between 2016 and 2019.
select name from animals where date_of_birth between '2016-01-01' and '2019-01-01';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
select name from animals where neutered = true and escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
select date_of_birth from animals where name in ('Agumon', 'Pikachu'); 

-- List name and escape attempts of animals that weigh more than 10.5kg
select name, escape_attempts from animals where weight_kg > 10.5;

-- Find all animals that are neutered.
select * from animals where neutered = true;

-- Find all animals not named Gabumon. (use <> or !=)
select * from animals where name <> 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including animals with weights equal to 10.4kg or 17.3kg)
select * from animals where weight_kg between 10.4 and 17.3;

-- update and roll back the animals table by setting the species column to unspecified.
-- Begin Transaction 
BEGIN; 
UPDATE animals SET species = 'unspecified' ; 
select * from animals; 
ROLLBACK;

-- Begin Transaction 
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT; 
SELECT * FROM animals; 

-- Begin Transaction 
BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK; 
SELECT * FROM animals; 

-- Begin the transaction
BEGIN; 
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT my_savepoint; 
UPDATE animals SET weight_kg = weight_kg * -1; 
SELECT * FROM animals;
ROLLBACK TO my_savepoint; 
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0; 
SELECT * FROM animals;
COMMIT;  

SELECT COUNT(*) FROM animals ;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals; 
SELECT neutered, MAX(escape_attempts) AS max_escape_attempts FROM animals GROUP BY neutered; 
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight FROM animals GROUP BY species; 
SELECT species, AVG(escape_attempts) AS avg_escape_attempts FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species; 