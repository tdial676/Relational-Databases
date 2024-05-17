-- [Problem 1a]
-- Given: Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Given a date value, returns 1 if it is a weekend, 0 if weekday
CREATE FUNCTION is_weekend (d DATE) RETURNS TINYINT DETERMINISTIC
BEGIN

-- DAYOFWEEK returns 7 for Saturday, 1 for Sunday
IF DAYOFWEEK(d) = 7 OR DAYOFWEEK(d) = 1
   THEN RETURN 1;
ELSE RETURN 0;
END IF;
END !

-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 1b]
-- Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Given a date value, returns the name of the holiday if it's a holiday
-- or NULL if it's not a holiday
CREATE FUNCTION is_holiday(d DATE) RETURNS VARCHAR(30) DETERMINISTIC
BEGIN
  DECLARE curr_weekday INT;
  DECLARE curr_month INT;
  DECLARE curr_day INT;

  SELECT DAYOFWEEK(d), MONTH(d), DAY(d)
  INTO curr_weekday, curr_month, curr_day;

  IF (curr_month = 1 AND curr_day = 1)
    THEN RETURN "New Year's Day";
  ELSEIF (curr_month = 8 AND curr_day = 26)
    THEN RETURN 'National Dog Day';
  ELSEIF (curr_month = 5 AND curr_weekday = 2 AND curr_day > 24) 
    THEN RETURN 'Memorial Day';
  ELSEIF (curr_month = 9 AND curr_weekday = 2 AND curr_day < 7)
    THEN RETURN 'Labor Day';
  ELSEIF (curr_month = 11 AND curr_weekday = 5 AND curr_day BETWEEN 22 AND 28)
    THEN RETURN 'Thanksgiving';
  ELSE RETURN NULL;
  END IF;
END !

-- Back to the standard SQL delimiter
DELIMITER ;

-- [Problem 2a]
--  query that reports how many filesets were submitted on the various 
-- holidays recognized by our is_holiday() function
SELECT is_holiday(DATE(sub_date)) AS holiday, COUNT(*) AS submission_count
FROM fileset
GROUP BY holiday;

-- [Problem 2b]
-- Query that reports how many filesets were submitted on a weekend, and 
-- how many were not submitted on a weekend.
SELECT 
  (CASE 
    WHEN is_weekend(DATE(sub_date)) = 0 THEN 'weekday'
    ELSE 'weekend'
  END) AS type_of_day, COUNT(*) AS submission_count
FROM fileset
GROUP BY type_of_day;
