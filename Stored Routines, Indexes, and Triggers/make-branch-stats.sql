-- [Problem 1]
-- Index Definition
CREATE INDEX account_idx_branch_balance ON account(branch_name, balance);

-- [Problem 2]
--  table definition for the materialized results
CREATE TABLE mv_branch_account_stats (
    branch_name     VARCHAR(15),
    num_accounts    INT NOT NULL,
    total_deposits  NUMERIC(12, 2) NOT NULL,
    min_balance     NUMERIC(12, 2) NOT NULL,
    max_balance     NUMERIC(12, 2) NOT NULL,

    PRIMARY KEY (branch_name)
);

-- [Problem 3]
-- initial SQL DML statement to populate the materialized view table
INSERT INTO mv_branch_account_stats 
SELECT branch_name,
       COUNT(*) AS num_accounts,
       SUM(balance) AS total_deposits,
       MIN(balance) AS min_balance,
       MAX(balance) AS max_balance
FROM account
GROUP BY branch_name;

-- [Problem 4]
--  view definition for branch_account_stats, using the column names specified
CREATE VIEW branch_account_stats AS
  SELECT branch_name, num_accounts, total_deposits, 
         (total_deposits / num_accounts) AS avg_balance, 
         min_balance, max_balance
  FROM mv_branch_account_stats; 

-- [Problem 5]
-- Provided solution for Problem 5
DELIMITER !

-- A procedure to execute when inserting a new branch name and balance
-- to the bank account stats materialized view (mv_branch_account_stats).
-- If a branch is already in view, its current balance is updated
-- to account for total deposits and adjusted min/max balances.
CREATE PROCEDURE sp_branchstat_newacct(
    new_branch_name VARCHAR(15),
    new_balance NUMERIC(12, 2)
)
BEGIN 
    INSERT INTO mv_branch_account_stats 
        -- branch not already in view; add row
        VALUES (new_branch_name, 1, new_balance, new_balance, new_balance)
    ON DUPLICATE KEY UPDATE 
        -- branch already in view; update existing row
        num_accounts = num_accounts + 1,
        total_deposits = total_deposits + new_balance,
        min_balance = LEAST(min_balance, new_balance),
        max_balance = GREATEST(max_balance, new_balance);
END !

-- Handles new rows added to account table, updates stats accordingly
CREATE TRIGGER trg_account_insert AFTER INSERT
       ON account FOR EACH ROW
BEGIN
      -- Example of calling our helper procedure, passing in 
      -- the new row's information
    CALL sp_branchstat_newacct(NEW.branch_name, NEW.balance);
END !
DELIMITER ;

-- [Problem 6]
-- The trigger (and related procedures) to handle deletes.
DELIMITER !

-- A procedure to execute when deleting a new branch name and balance
-- to the bank account stats materialized view (mv_branch_account_stats).
CREATE PROCEDURE sp_branchstat_deleteacct(
    prev_branch_name VARCHAR(15),
    prev_balance NUMERIC(12, 2)
)
BEGIN 
    -- When a row is deleted then the num_accounts decreases 
    -- If num_accounts is zero then delete row otherwise update
    -- row

    DECLARE new_count INT;
    DECLARE new_min NUMERIC(12, 2);
    DECLARE new_max NUMERIC(12, 2);

    SELECT COUNT(*), MIN(balance), MAX(balance)
    INTO new_count, new_min, new_max
    FROM account 
    WHERE prev_branch_name = branch_name;

    IF (new_count = 0)
        THEN DELETE FROM mv_branch_account_stats 
            WHERE branch_name = prev_branch_name;
    ELSE 
        UPDATE mv_branch_account_stats
        SET num_accounts = new_count - 1,
            total_deposits = total_deposits - prev_balance,
            min_balance = new_min,
            max_balance = new_max
        WHERE branch_name = prev_branch_name;
END !

-- Handles rows deleted from account table
CREATE TRIGGER trg_account_delete AFTER DELETE
       ON account FOR EACH ROW
BEGIN
      -- Example of calling our helper procedure, passing in the prev row's 
      -- information
    CALL sp_branchstat_deleteacct(OLD.branch_name, OLD.balance);
END !
DELIMITER ;

-- [Problem 7]
DELIMITER !

-- Handles row updates from account table
CREATE TRIGGER trg_account_update AFTER UPDATE
       ON account FOR EACH ROW
BEGIN
    -- in acocunts user can change the branch_name or the balance. If
    -- branch name is changed then we can delete that old branch and add in a
    -- new brach with the same balance just with th new name. Else, if
    -- balance is changed we simply update our balance stats by incrementing
    -- balance and updated min and max as needed.
    DECLARE new_min NUMERIC(12, 2);
    DECLARE new_max NUMERIC(12, 2);
    
    IF OLD.branch_name <> NEW.branch THEN
        CALL  sp_branchstat_deleteacct(OLD.branch_name, OLD.balance);
        CALL sp_branchstat_newacct(NEW.branch_name, NEW.balance);
    ELSE
        SELECT MIN(balance), MAX(balance) 
        INTO new_min, new_max
        FROM account
        WHERE branch_name = OLD.branch_name;

        UPDATE mv_branch_account_stats 
        SET total_deposits = total_deposits + (NEW.balance - OLD.balance),
            min_balance = new_min,
            max_balance = new_max
        WHERE branch_name = NEW.branch_name;
    END IF;
END !
DELIMITER ;
