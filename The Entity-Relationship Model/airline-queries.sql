-- [Problem 6a]
-- Recived extension from EL

-- query that will retrieve all purchases and associated ticket 
-- information for the customer
SELECT purchases.purchase_id, purchase_time, last_name AS traveler_last_name, 
       first_name AS traveler_first_name
FROM purchases
INNER JOIN tickets ON tickets.purchase_id = purchases.purchase_id
INNER JOIN flight_info ON tickets.ticket_id = flight_info.ticket_id
INNER JOIN customer ON customer.cust_id = tickets.cust_id
WHERE purchases.cust_id = 54321
ORDER BY purchase_id DESC, `date` ASC, last_name ASC, first_name ASC;

-- [Problem 6b]
--  query that reports the total revenue from ticket sales for each kind of 
--airplane in our flight booking database, generated from flights with a 
-- departure time within the last two weeks
SELECT aircraft_type, SUM(ticket_cost)
FROM aircrafts
NATURAL LEFT JOIN (tickets NATURAL JOIN flight_info)
WHERE `date` BETWEEN CURRENT_DATE - INTERVAL 2 WEEK AND CURRENT_DATE
GROUP BY aircraft_type;

-- [Problem 6c]
-- a query that reports all travelers on international flights that have
-- not yet specified all of their international flight information
SELECT first_name, last_name
FROM flights
NATURAL JOIN flight_info
NATURAL JOIN travelers
NATURAL JOIN tickets
NATURAL JOIN customer
WHERE is_domestic = 0       AND (
      passport_num          IS NULL OR
      citizenship_country   IS NULL OR
      emergency_name        IS NULL OR
      emergency_number      IS NULL OR
      freq_flyer_num        IS NULL);