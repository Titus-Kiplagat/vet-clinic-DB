/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES
  ('Agumon', date '2020-02-03', 0, TRUE, 10.23),
  ('Gabumon', date '2018-11-15', 2, TRUE, 8),
  ('Pikachu', date '2021-01-07', 1, FALSE, 15.04),
  ('Devimon', date '2017-05-12', 5, TRUE, 11);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES
('Charmander', date '2020-02-08', 0, false, -11),
('Plantmon', date '2021-11-15', 2, true, -5.7),
('Squirtle', date '1993-04-02', 3, false, -12.13),
('Angemon', date '2005-06-12', 1, true, -45),
('Boarmon', date '2005-06-07', 7, true, 20.4),
('Blossom', date '1998-10-13', 3, true, 17),
('Ditto', date '2022-05-14', 4, true, 22);

INSERT INTO owners (full_name, age) 
VALUES 
('Sam Smith', 34),
('Jennifer Orwell', 19),
('Bod', 45),
('Melody Pond', 77),
('Dean Winchester', 14),
('Jodie Whittaker', 38);

INSERT INTO species (name)
VALUES
('Pokemon'),
('Digimon');

UPDATE animals
SET species_id = (CASE 
  WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
  ELSE (SELECT id FROM species WHERE name = 'Pokemon')
  END);


UPDATE animals
SET owner_id = (CASE 
  WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
  WHEN name IN ('Gabumon', 'Pikachu') THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
  WHEN name IN ('Devimon', 'Plantmon') THEN (SELECT id FROM owners WHERE full_name = 'Bob')
  WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
  WHEN name IN ('Angemon', 'Boarmon') THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
  END);