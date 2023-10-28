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

SELECT name
FROM animals
WHERE owner_id = (SELECT id FROM owners WHERE full_name = 'Melody Pond');

SELECT name
FROM animals
WHERE species_id = (SELECT id FROM species WHERE name = 'Pokemon');

SELECT o.full_name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name;

SELECT s.name, COUNT(a.id) as total_animals
FROM species s
LEFT JOIN animals a ON s.id = a.species_id
GROUP BY s.name;

SELECT a.name
FROM animals a
INNER JOIN owners o ON a.owner_id = o.id
INNER JOIN species s ON a.species_id = s.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

SELECT a.name
FROM animals a
INNER JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

SELECT o.full_name, COUNT(a.id) as total_animals
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY total_animals DESC
LIMIT 1;

-- Who was the last animal seen by William Tatcher?
SELECT a.name AS animal_name, v.name AS vet_name, MAX(vt.visit_date) AS last_visit_date
FROM visits vt
JOIN animals a ON vt.animal_id = a.id
JOIN vets v ON vt.vet_id = v.id
WHERE v.name = 'William Tatcher'
GROUP BY a.name, v.name
ORDER BY last_visit_date DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT v.name AS vet_name, COUNT(DISTINCT a.id) AS num_animals_seen
FROM visits vt
JOIN vets v ON vt.vet_id = v.id
JOIN animals a ON vt.animal_id = a.id
WHERE v.name = 'Stephanie Mendez'
GROUP BY v.name;

-- List all vets and their specialties, including vets with no specialties.
SELECT v.name AS vet_name, COALESCE(s.name, 'None') AS specialty
FROM vets v
LEFT JOIN specializations sp ON v.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name AS animal_name, vt.visit_date
FROM visits vt
JOIN vets v ON vt.vet_id = v.id
JOIN animals a ON vt.animal_id = a.id
WHERE v.name = 'Stephanie Mendez'
  AND vt.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT a.name AS animal_name, COUNT(vt.id) AS num_visits
FROM visits vt
JOIN animals a ON vt.animal_id = a.id
GROUP BY a.name
ORDER BY num_visits DESC
LIMIT 1;

-- Details for the most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal_name, v.name AS vet_name, vt.visit_date
FROM visits vt
JOIN vets v ON vt.vet_id = v.id
JOIN animals a ON vt.animal_id = a.id
ORDER BY vt.visit_date DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(vt.id) AS num_visits
FROM visits vt
JOIN vets v ON vt.vet_id = v.id
JOIN animals a ON vt.animal_id = a.id
LEFT JOIN specializations s ON v.id = s.vet_id AND s.species_id = a.species_id
WHERE s.id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name AS recommended_specialty, COUNT(v.id) AS visit_count
FROM visits vt
JOIN animals a ON vt.animal_id = a.id
JOIN species s ON a.species_id = s.id
JOIN vets v ON vt.vet_id = v.id
WHERE v.name = 'Maisy Smith'
GROUP BY s.name
ORDER BY visit_count DESC
LIMIT 1;
