-- [Problem 1a]
-- This Query is projecting custermer names and the number of loans 
-- thye have using a correlated subquery. In the subquery, they are 
-- selecting borrower, from the borrower tabel, names that are equal 
-- to customer names in customer table hence making the the two 
-- correlated.
SELECT c.customer_name, COUNT(loan_number) AS loan_count
FROM customer c
NATURAL LEFT JOIN borrower b
GROUP BY c.customer_name
ORDER BY loan_count DESC;

-- [Problem 1b]
-- This query is projecting branch names that have less assets than total.
-- loans. This is correlated as it is comparing loan table to the branch 
-- table.
SELECT branch_name
FROM branch b
NATURAL JOIN (
    SELECT branch_name, SUM(amount) AS loan_tot 
    FROM loan 
    GROUP BY branch_name) AS loan_sums
WHERE b.assets < loan_sums.loan_tot;

-- [Problem 1c]
SELECT branch_name, 
        (SELECT COUNT(*) FROM loan l
        WHERE l.branch_name = b.branch_name) AS loan_counts,
        (SELECT COUNT(*) FROM account a
        WHERE a.branch_name = b.branch_name) AS num_accounts
FROM branch b;

-- [Problem 1d]
SELECT branch_name, 
        COUNT(DISTINCT loan_number) AS loan_counts,
        COUNT(DISTINCT account_number) AS num_accounts
FROM branch
NATURAL LEFT JOIN loan
NATURAL JOIN account
GROUP BY branch_name;