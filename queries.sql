/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '01-01-2016' AND '12-31-2019';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

--Add a column species of type string to your animals table.
ALTER TABLE animals
ADD COLUMN species varchar(100);


--Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that species columns went back to the state before tranasction.
BEGIN;

UPDATE animals SET species = 'unspecified';

ROLLBACK;


/*
Inside a transaction:
  Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
  Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
  Commit the transaction.
  Verify that change was made and persists after commit.
*/
BEGIN;

UPDATE animals SET species = 'digimon' WHERE name like '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

COMMIT;


--Now, take a deep breath and... Inside a transaction delete all records in the animals table, then roll back the transaction.
BEGIN;

DELETE FROM animals;

ROLLBACK;

/*
Inside a transaction:
  Delete all animals born after Jan 1st, 2022.
  Create a savepoint for the transaction.
  Update all animals' weight to be their weight multiplied by -1.
  Rollback to the savepoint
  Update all animals' weights that are negative to be their weight multiplied by -1.
  Commit transaction
*/
BEGIN;

DELETE FROM animals WHERE date_of_birth > '01-01-2022';
SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg*-1;
ROLLBACK TO SP1;
UPDATE animals SET weight_kg = weight_kg*-1 WHERE weight_kg < 0;

COMMIT;


/*
Write queries to answer the following questions:
  How many animals are there?
  How many animals have never tried to escape?
  What is the average weight of animals?
  Who escapes the most, neutered or not neutered animals?
  What is the minimum and maximum weight of each type of animal?
  What is the average number of escape attempts per animal type of those born between 1990 and 2000?
*/
SELECT COUNT(*) AS animals_count FROM animals;
SELECT COUNT(*) AS animals_tried_escape FROM animals WHERE escape_attempts > 0;
SELECT AVG(weight_kg) AS average_weight FROM animals;
SELECT neutered, SUM(escape_attempts) AS escape_count FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg)  FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '01-01-1990' AND '12-31-2000' GROUP BY species;