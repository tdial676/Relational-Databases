-- [Problem 0a]
-- Using float or double could result in higher precision 
-- than desired meaning that the balnce can include fractions
-- of a cent which does not make sense. Therefore numeric allows
-- us to define precission to two decimal places whihc is the most 
-- precision needed in this case as you account cannot have half a 
-- penny for example. Also Floats and DOubles are an approximation 
-- and we want the exact amount for balance not some approximation.

-- [Problem 0b]
-- The account number can be represented by a char instead as it 
-- is of fixed length and will cost less memory.

-- [Problem 1a]
-- project loan numbers and amounts for amounts in range [1000, 2000].
SELECT loan_number, amount
FROM loan
WHERE amount >= 1000 
    AND amount <= 2000;

-- [Problem 1b]
-- Get laon numbers with amounts owned by Smith
SELECT loan.loan_number, loan.amount
FROM loan NATURAL JOIN borrower NATURAL JOIN customer
WHERE customer.customer_name = 'Smith'
ORDER BY loan.loan_number ASC;

-- [Problem 1c]
-- Retrieve the city of the branch where account A-446 is open.
SELECT branch.branch_city
FROM account NATURAL JOIN branch
WHERE account.account_number = 'A-446';

-- [Problem 1d]
-- Retrieve the customer name, account number, branch name, and balance 
-- of accounts owned by customers whose names start with “J”.
SELECT depositor.customer_name, account.account_number, 
    account.branch_name, account.balance
FROM account NATURAL JOIN depositor
WHERE depositor.customer_name LIKE 'J%';

-- [Problem 1e]
-- Retrieve the names of all customers with more than five bank accounts.
SELECT customer_name
FROM depositor
GROUP BY customer_name
HAVING COUNT(account_number) > 5;

-- [Problem 2a]
-- All customer cities without a bank branch in that city.
SELECT DISTINCT customer_city
FROM customer
WHERE customer_city
    NOT IN (SELECT branch_city FROM branch)
ORDER BY customer.customer_city ASC;

-- [Problem 2b]
-- Customers that have neither an account nor a loan.
SELECT customer_name
FROM customer
WHERE customer_name NOT IN (SELECT customer_name from borrower)
    AND customer_name NOT IN (SELECT customer_name from depositor);

-- [Problem 2c]
--  Make a $75 gift-deposit into accounts held in the city of Horseneck.
UPDATE account
SET balance = balance + 75
WHERE account.branch_name IN 
    (SELECT branch.branch_name 
    FROM branch
    WHERE branch.branch_city = 'Horseneck');

-- [Problem 2d]
-- Make a $75 gift-deposit into accounts held in the city of Horseneck.
UPDATE account, branch
SET balance = balance + 75
WHERE account.branch_name = branch.branch_name
    AND branch.branch_city = 'Horseneck';

-- [Problem 2e]
-- Retrive details for largest account at each bank using a join in from.
SELECT account.account_number, account.branch_name, account.balance
FROM account JOIN 
    (SELECT branch_name, MAX(balance) AS max_balance
    FROM account
    GROUP BY branch_name) AS max_accounts
ON account.branch_name = max_accounts.branch_name
AND account.balance = max_accounts.max_balance;

-- [Problem 2f]
-- Retrive details for largest account at each bank using IN.
SELECT account_number, branch_name, balance
FROM account 
WHERE (branch_name, balance) IN
    (SELECT branch_name, MAX(balance) AS balance
    FROM account
    GROUP BY branch_name);

-- [Problem 3]
-- The rank of all bank branches, based on the amount of assets 
-- that each branch holds.
SELECT branch.branch_name, branch.assets, 
    1 + COUNT(branch_copy.branch_name) AS `rank`
FROM branch LEFT OUTER JOIN branch AS branch_copy
    ON branch.assets < branch_copy.assets
GROUP BY branch.branch_name
ORDER BY branch.assets DESC, branch.branch_name ASC;
