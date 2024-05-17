-- CS 121
-- Assignment 3: Correlated Queries and SQL DDL
-- Setup file for defining and loading auto-insurance data.

-- clean up old tables:
-- drop tables with foreign keys first due to 
-- referential integrity constraints.
DROP TABLE IF EXISTS participated;
DROP TABLE IF EXISTS owns;
DROP TABLE IF EXISTS accident;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS person;

-- Represents a driver who is uniquely identified
-- by their driver id hence no two people can have 
-- the same driver id. Requires all non-null values. 
CREATE TABLE person (
    -- Assuming id's are of fixed length
    -- Primary keys not null by deafult
    driver_id CHAR(10),
    `name`    VARCHAR(15) NOT NULL,
    -- Addresses tend to be very long
    `address` VARCHAR(220) NOT NULL,
    PRIMARY KEY(driver_id)
);

-- Represents a car's information inlcuding it's
-- license plate, model, and year.
CREATE TABLE car (
    -- All car license values are exactly 7 characters.
    -- Primary keys not null by deafult
    license CHAR(7),
    -- car model can be null if unknown
    -- model names differ in length by model
    model   VARCHAR(15),
    -- year manufactored could be null if unknown
    -- ex: 2024
    `year` YEAR,
    PRIMARY KEY (license)
);

-- Represents information regading an accident such 
-- as the summary, time, location, and report number.
CREATE TABLE accident (
    -- We cannot have null types for accident as we need 
    -- all of the information regarding an accident to insure.
    -- Primary keys not null by deafult
    report_number INT AUTO_INCREMENT,
    -- built in data type that stores date and time of accident
    -- ex: 2024-02-3 23:03:00
    date_occurred TIMESTAMP NOT NULL,
    -- addresses can be long
    -- nearby address or an intersection.
    -- ex: 12 bachelder road, windsor, CT
    `location`    VARCHAR(120) NOT NULL,
    -- accident summaries can be very long should be detailed
    -- can be null if the details are unknown
    summary       VARCHAR(10000),
    PRIMARY KEY (report_number)
);

-- Represents the car owner's infromation such as their 
-- license and driver_id so that they can be identified
CREATE TABLE owns (
    driver_id CHAR(10),
    license   CHAR(7),
    -- If a person no longer has or updates a linces or car then
    -- we should delete, or update that person's ownership
    PRIMARY KEY(driver_id, license),
    FOREIGN KEY (driver_id) REFERENCES person(driver_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (license) REFERENCES car(license)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Represents the individuals and cars that participated in a 
-- car crash.
CREATE TABLE participated(
    -- Primary keys not null by deafult
    driver_id     CHAR(10), 
    license       CHAR(7), 
    report_number INT,
    -- MAx 1,000,000 USD but may be just under this value
    -- Damage cost can be null.
    damage_amount  NUMERIC(8, 2),
    PRIMARY KEY(driver_id, license, report_number),
    FOREIGN KEY (driver_id) REFERENCES person(driver_id)
        ON UPDATE CASCADE,
    FOREIGN KEY (license) REFERENCES car(license)
        ON UPDATE CASCADE,
    FOREIGN KEY (report_number) REFERENCES accident(report_number)
        ON UPDATE CASCADE
);