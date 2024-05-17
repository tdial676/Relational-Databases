-- [Problem 1]
-- Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Return the minimum submission interval
CREATE FUNCTION min_submit_interval(ID INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE curr_sub INT DEFAULT 0;
    DECLARE prev_sub INT DEFAULT 0;
    DECLARE curr_min INT DEFAULT NULL;
    DECLARE subs INT DEFAULT 0;

    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR 
        SELECT UNIX_TIMESTAMP(sub_date) AS sec_intervals
        FROM fileset
        WHERE sub_id = ID
        ORDER BY sec_intervals ASC;
    
    -- When fetch is complete, handler sets flag
    -- 02000 is MySQL error for "zero rows fetched"
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
    SET done = 1;

    OPEN cur;
    WHILE NOT done DO
        FETCH cur INTO curr_sub;
        IF (NOT done) THEN
            -- This handles the case where we have atmost one submissions
            SET subs = subs + 1;
            IF (curr_min IS NULL)
                THEN SET curr_min = curr_sub;
            ELSEIF (curr_sub - prev_sub < curr_min)
                THEN SET curr_min = curr_sub - prev_sub;
            END IF;
            SET prev_sub = curr_sub;
        END IF;
    END WHILE;
    CLOSE cur;
    -- ONLY RETURN A MIN GIVEN MORE THAN ONE SUBMISSION
    IF (subs < 2)
        THEN RETURN NULL;
    ELSE RETURN curr_min;
    END IF;
END !
-- Back to the standard SQL delimiter
DELIMITER ;

-- [Problem 2]
-- Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Return the maximum submission interval
CREATE FUNCTION max_submit_interval(ID INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE curr_sub INT DEFAULT 0;
    DECLARE prev_sub INT DEFAULT 0;
    DECLARE curr_max INT DEFAULT 0;
    DECLARE subs INT DEFAULT 0;

    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR 
        SELECT UNIX_TIMESTAMP(sub_date) AS sec_intervals
        FROM fileset
        WHERE sub_id = ID
        ORDER BY sec_intervals ASC;
    
    -- When fetch is complete, handler sets flag
    -- 02000 is MySQL error for "zero rows fetched"
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
    SET done = 1;

    OPEN cur;
    WHILE NOT done DO
        FETCH cur INTO curr_sub;
        IF (NOT done) THEN
            -- This handles the case where we have atmost one submissions
            SET subs = subs + 1;
            IF (subs > 1 AND curr_sub - prev_sub > curr_max)
                THEN SET curr_max = curr_sub - prev_sub;
            END IF;
            SET prev_sub = curr_sub;
        END IF;
    END WHILE;
    CLOSE cur;
    -- ONLY RETURN A MAX GIVEN MORE THAN ONE SUBMISSION
    IF (subs < 2)
        THEN RETURN NULL;
    ELSE RETURN curr_max;
    END IF;
END !
-- Back to the standard SQL delimiter
DELIMITER ;

-- [Problem 3]
-- Return avarage submission interval 
-- Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !
CREATE FUNCTION avg_submit_interval(ID INT) RETURNS DOUBLE DETERMINISTIC
BEGIN
    DECLARE avg_interval DOUBLE;

    SELECT (MAX(UNIX_TIMESTAMP(sub_date)) -  MIN(UNIX_TIMESTAMP(sub_date)))
     / (COUNT(*) - 1) 
    INTO avg_interval
    FROM fileset
    WHERE sub_id = ID;

    RETURN avg_interval;
END !

-- Back to the standard SQL delimiter
DELIMITER ;

-- [Problem 4]
-- Given the above query and the definitions of your functions, create an 
-- index on fileset that will dramatically speed up the query
CREATE INDEX file_idx ON fileset(sub_id);
