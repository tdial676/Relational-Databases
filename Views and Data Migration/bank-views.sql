-- [Problem 1a]
-- View  containing the account numbers and customer names 
-- (but not the balances) for all accounts at the Stonewell
-- branch.
CREATE VIEW stonewell_customers AS
    SELECT account_number, customer_name
    FROM depositor
    NATURAL JOIN account
    WHERE branch_name = 'Stonewell';

-- [Problem 1b]
-- A view  containing the name, street, and city of all 
-- customers who have an account with the bank, but do not 
-- have a loa
CREATE VIEW onlyacct_customers AS
    SELECT customer_name, customer_street, customer_city
    FROM customer
    WHERE customer_name 
        NOT IN (SELECT customer_name FROM borrower)
    AND customer_name 
        IN (SELECT customer_name FROM depositor);

-- [Problem 1c]
-- A view  that lists all branches in the bank, along with the 
-- total account balance of each branch, and the average account
-- balance of each branch
CREATE VIEW branch_deposits AS
    SELECT branch_name, 
        IFNULL(SUM(balance), 0) AS total_balance, 
        IFNULL(AVG(balance), NULL) AS avg_balance
    FROM account NATURAL RIGHT JOIN branch
    GROUP BY branch_name;
