-- [Problem 5]
-- Recived extension from EL
-- DROP TABLE commands:
DROP TABLE IF EXISTS flight_info;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS travelers;
DROP TABLE IF EXISTS purchaser;
DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS contact_phone;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS aircrafts;

-- CREATE TABLE commands:
-- There is nothing wrong with esccaping keywords with `` according to El.

-- Defines a table for the aircraft information associated with each 
-- flight including the  manufacturer, aircraft model, and IATA aircraft code.
CREATE TABLE aircrafts(
    aircraft_type CHAR(3), 
    company       VARCHAR(50) NOT NULL, 
    -- aircraft's manufactorer. eg: boeing
    model         VARCHAR(50) NOT NULL, 
    -- aircraft model.
    UNIQUE        (company, model),
    -- in case companies have same model name
    PRIMARY KEY   (aircraft_type)
);

-- Defines a table for flights including the fkught number, date, time, 
-- source and destination IATA codes alonside the type of flight
-- and aircraft completing the flight.
CREATE TABLE flights(
    flight_number   VARCHAR(25),
    `date`          DATE,
    `time`          TIME    NOT NULL,
    source          CHAR(3) NOT NULL, 
    --  IATA code of flight source. eg: LAX
    destination     CHAR(3) NOT NULL, 
    --  IATA code of flight destination.
    is_domestic     TINYINT NOT NULL, 
    --  domestic (1) or international (0).
    aircraft_type   CHAR(3) NOT NULL, 
    --  3-char IATA aircraft type code.

    UNIQUE          (flight_number, `date`, aircraft_type),
    PRIMARY KEY     (flight_number, `date`),
    FOREIGN KEY     (aircraft_type) REFERENCES aircrafts(aircraft_type)
    -- if the aircraft is no longer availbe or changed then 
    -- the past flights shouldnt change hence not cascades.
);

-- Defines a table for the seats available in each aircraft with the seat 
-- number, class, and type alongside its exit row seat status.
CREATE TABLE seats(
    aircraft_type   CHAR(3), 
    seat_number     VARCHAR(5),
    seat_class      VARCHAR(25) NOT NULL, 
    -- ex: first class
    seat_type       CHAR(1) NOT NULL,
    -- aisle (A), middle (M), and window (W) seats
    exit_row        TINYINT NOT NULL,
    -- exit row seat (1) and non-exit row seat (0)

    CHECK       (seat_type IN ('A', 'M', 'W')),
    PRIMARY KEY (aircraft_type, seat_number),
    FOREIGN KEY (aircraft_type) REFERENCES aircrafts(aircraft_type)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    -- IN CASE AIRCRAFTS UPDATE THEIR SEATS OR NO LONGER EXISTS
);

-- Defines a table for our customers with their name, email, and customer id.
CREATE TABLE customer(
    cust_id     INT AUTO_INCREMENT,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    email       VARCHAR(100) NOT NULL,

    PRIMARY KEY (cust_id)
);

-- Define a table for  a collection of one or more tickets bought by a  
-- particular purchaser in a single transaction with the purchase id,
-- customer id, time of purchase and confirmation number.
CREATE TABLE purchases(
    purchase_id         INT AUTO_INCREMENT,
    cust_id             INT NOT NULL,
    purchase_time       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    confirmation_num    CHAR(6) NOT NULL,

    UNIQUE      (confirmation_num),
    PRIMARY KEY (purchase_id),
    FOREIGN KEY (cust_id) REFERENCES customer(cust_id)
);

-- Defines a tabel for purhasers identified by their unique customer id
-- that saves their creditc card information for future purchases if they
-- please.
CREATE TABLE purchaser(
    cust_id             INT,
    card_number         NUMERIC(16, 0),
    exper_date          CHAR(4), 
    -- MM/YY for experation date stored as 'MMYY'.
    verification_code   NUMERIC(3, 0),

    PRIMARY KEY (cust_id),
    FOREIGN KEY (cust_id) REFERENCES customer(cust_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Defines a table for each travelers information such as their passport
-- number, country of citizenship, an emergency contact name and phone
-- number alongside their frequent flyer number if they have one.
-- Travelers are not required to provide these details immediately; they only
-- need to be entered at least 72 hours before the flight. Therefore, it is 
-- perfectly acceptable to allow null values.
CREATE TABLE travelers(
    cust_id                 INT,
    passport_num            VARCHAR(50),
    citizenship_country     VARCHAR(60),
    emergency_name          VARCHAR(100), 
    -- first and last name for emergency name.
    emergency_number        VARCHAR(25),
    -- phone number of emergency contact. Not specified to support 
    -- international numbers.
    freq_flyer_num          CHAR(7),

    PRIMARY KEY (cust_id),
    FOREIGN KEY (cust_id) REFERENCES customer(cust_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Defines a table for a customers phone numbers where each
-- can have zero or many numbers on file.
CREATE TABLE contact_phone(
    cust_id         INT,
    phone_number    VARCHAR(25) NOT NULL,
    -- Not specified to support international numbers.

    PRIMARY KEY (cust_id, phone_number),
    FOREIGN KEY (cust_id) REFERENCES customer(cust_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Defines a table for information regarding a ticket holder
-- and purchaser alongisde it's cost.
CREATE TABLE tickets(
    ticket_id    INT AUTO_INCREMENT,   
    ticket_cost  NUMERIC(6, 2),
    purchase_id  INT NOT NULL,
    cust_id      INT NOT NULL,

    PRIMARY KEY (ticket_id),
    FOREIGN KEY (cust_id) REFERENCES customer(cust_id),
    FOREIGN KEY (purchase_id) REFERENCES purchases(purchase_id)
);

-- A table for the realtion between a flight, its seats, and tickets
-- for that flight.
CREATE TABLE flight_info(
    flight_number       VARCHAR(25),
    `date`              DATE,
    seat_number         VARCHAR(5),
    ticket_id           INT NOT NULL,
    aircraft_type       CHAR(3),

    UNIQUE      (ticket_id),
    -- each ticket needs to be unique to avoid having overlap

    PRIMARY KEY (flight_number, `date`, seat_number, aircraft_type),

    FOREIGN KEY (flight_number, `date`, aircraft_type) 
    REFERENCES flights(flight_number, `date`, aircraft_type),
    -- ensures that the flight has a valid aircraft.
    
    FOREIGN KEY (aircraft_type, seat_number) 
    REFERENCES seats(aircraft_type, seat_number),
    -- To ensure seat number and aircraft being used align and is the
    -- same aircraft as the flight hence the additional contraint

    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id)
);