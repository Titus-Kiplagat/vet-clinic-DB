/* Database schema to keep the structure of entire database. */
CREATE DATABASE vet_clinic;

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOlEAN,
    weight_kg DECIMAL(5, 2),
    PRIMARY KEY (id)
);

ALTER TABLE animals ADD COLUMN species VARCHAR(100);

CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    age INT
);

CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

ALTER TABLE animals
ADD PRIMARY KEY(id);

ALTER TABLE animals
DROP COLUMN species; 

ALTER TABLE animals
ADD COLUMN species_id INT REFERENCES species(id); 

ALTER TABLE animals
ADD COLUMN owner_id INT REFERENCES owners(id); 

CREATE TABLE vets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    date_of_graduation DATE
);

CREATE TABLE specializations (
    id SERIAL PRIMARY KEY,
    vet_id INT REFERENCES vets(id),
    species_id INT REFERENCES species(id)
);

CREATE TABLE visits (
    id SERIAL PRIMARY KEY,
    animal_id INT REFERENCES animals(id),
    vet_id INT REFERENCES vets(id),
    visit_date DATE
);

ALTER TABLE owners ADD COLUMN email VARCHAR(120);
