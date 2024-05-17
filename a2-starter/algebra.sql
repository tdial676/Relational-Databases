-- [Problem 1]
-- project A from r whihc should return a set hence distinct
SELECT DISTINCT A
FROM r;

-- [Problem 2]
-- select all rows where B = 42 in relation r where we can have duplicates.
SELECT * 
FROM r 
WHERE B = 42;

-- [Problem 3]
-- product of r and s which can have duplicates
SELECT *
FROM r, s;

-- [Problem 4]
-- project A,F (hence returning a set) from the product of r and s where C = D.
SELECT DISTINCT A, F
FROM r, s
WHERE C = D;

-- [Problem 5]
-- r1 union r2 which should return a set hence UNION
SELECT * FROM r1
UNION
SELECT * FROM r2;

-- [Problem 6]
-- set intersection of r1 and r2
SELECT * FROM r1
INTERSECT
SELECT * FROM r2;

-- [Problem 7]
SELECT * FROM r1 
WHERE (A, B, C) NOT IN (SELECT * FROM r2);
