-- [Problem 2a]
-- person
INSERT INTO person (driver_id, `name`, `address`)
VALUES 
    ('cat-lover1', 'Favour', 'Flemming House, Pasadena, CA'),
    ('cat-lover2', 'Lea', '1200 E California Blvd, Pasadena, CA'),
    ('cat-lover3', 'Boris', 'I-9 highway, CA');

-- car
INSERT INTO car VALUES ('eicgg18', 'Twingo', 2015);
INSERT INTO car (license, model) VALUES ('eicgg22', 'Honda Civic');
INSERT INTO car (license, `year`) VALUES ('eicgg20', 2004);

-- accident
INSERT INTO accident (date_occurred, `location`, summary)
VALUES
    ('2023-02-3 23:03:00', 'Beckman Auditaurium', 
    'car crash drove into wedding cake and the students lost their minds.'),
    ('2020-07-3 09:03:00', 'Annenberg', 
    'car backed into OH.');
INSERT INTO accident (date_occurred, `location`)
VALUES
    ('2009-12-3 23:03:00', 'Canada');

-- owns
INSERT INTO owns
VALUES
    ('cat-lover1', 'eicgg18'),
    ('cat-lover2', 'eicgg20'),
    ('cat-lover3', 'eicgg22');

-- particpated
INSERT INTO participated (driver_id, license, damage_amount)
VALUES
    ('cat-lover1', 'eicgg18', 6587.25),
    ('cat-lover2', 'eicgg20', 927.98);
INSERT INTO participated (driver_id, license)
VALUES
    ('cat-lover3', 'eicgg22');

-- [Problem 2b]
UPDATE person
SET `name` = 'Lea Grohmann' WHERE `name` = 'Lea';

UPDATE car
SET license = 'eicgg00' WHERE model = 'Honda Civic';

UPDATE person 
SET driver_id = 'cat-lover0' WHERE `name` = 'Favour';

-- [Problem 2c]
-- DELETE FROM car WHERE license = 'eicgg20';
-- mysql> DELETE FROM car WHERE license = 'eicgg20';
-- ERROR 1451 (23000): Cannot delete or update a parent row: a 
-- foreign key constraint fails ("autodb"."participated", CONSTRAINT 
-- "participated_ibfk_2" FOREIGN KEY ("license") REFERENCES "car" ("license")
-- ON UPDATE CASCADE)