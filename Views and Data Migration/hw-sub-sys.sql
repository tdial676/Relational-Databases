-- [Problem 1a]
-- Compute what would be a “perfect score” in the course
SELECT SUM(maxscore) AS perfect_score
FROM assignment;

-- [Problem 1b]
--  lists every section’s name, and how many students 
-- are in that section
SELECT sec_name, COUNT(username) AS num_students
FROM section NATURAL JOIN student
GROUP BY sec_name;

-- [Problem 1c]
-- A view which computes each student’s total score over 
-- all assignments in the course
CREATE VIEW score_totals AS
    SELECT username, SUM(score) AS total_score
    FROM submission
    GROUP BY username
    ORDER BY username;

-- [Problem 1d]
-- A view which lists the usernames and scores of all students 
-- that are passing (with atleats 40 points).
CREATE VIEW passing AS
    SELECT username, total_score
    FROM score_totals
    WHERE total_score >= 40
    ORDER BY total_score DESC, username;

-- [Problem 1e]
-- A view which lists the usernames and scores of all students
-- that are failing (with less than 40 points).
CREATE VIEW failing AS
    SELECT username, total_score
    FROM score_totals
    WHERE total_score < 40
    ORDER BY total_score DESC, username;

-- [Problem 1f]
-- Query  of all students that failed to submit work for at least 
-- one lab assignment, but still managed to pass the course
SELECT DISTINCT username
FROM assignment 
    NATURAL JOIN submission
    NATURAL LEFT JOIN fileset
    NATURAL JOIN passing
WHERE fset_id IS NULL 
AND  shortname LIKE 'lab%';

-- [Problem 1g]
-- list any students that failed to submit either the midterm or 
-- the final, yet still managed to pass the course.
SELECT DISTINCT username
FROM assignment 
    NATURAL JOIN submission
    NATURAL LEFT JOIN fileset
    NATURAL JOIN passing
WHERE fset_id IS NULL
AND shortname IN ('midterm', 'final');

-- [Problem 2a]
-- Query that reports the usernames (in alphabetical order) of all
-- students that submitted work for the midterm after the due date.
SELECT DISTINCT username
FROM assignment
NATURAL JOIN submission
NATURAL JOIN fileset
WHERE shortname = 'midterm'
AND due < sub_date
ORDER BY username;

-- [Problem 2b]
-- Query that reports, for each hour in the day, how many lab assignments
-- (assignments whose short-names start with 'lab') are submitted in that hour
SELECT EXTRACT(HOUR FROM sub_date) AS submit_hour,
       COUNT(sub_id) AS num_submits
FROM assignment
NATURAL JOIN submission
NATURAL JOIN fileset
WHERE shortname LIKE 'lab%'
GROUP BY submit_hour
ORDER BY submit_hour;

-- [Problem 2c]
-- Query that reports the total number of final exams that were submitted in
-- the 30 minutes before the final exam due date.
SELECT COUNT(*) AS last_minute_final_submissions
FROM assignment
NATURAL JOIN submission
NATURAL JOIN fileset
WHERE shortname = 'final'
AND sub_date BETWEEN due - INTERVAL '30' MINUTE AND due;

-- [Problem 3a]
-- Add a column named email to the student table, which should be a 
-- VARCHAR(200).  When you create the new column, allow NULL values.
ALTER TABLE student
ADD email VARCHAR(200);

UPDATE student
SET email = CONCAT(username,  '@school.edu');

ALTER TABLE student
MODIFY email VARCHAR(200) NOT NULL;

-- [Problem 3b]
-- Add a column named submit_files to the assignment table, which is 
-- a TINYINT column.  Make the default value 1.
-- sets all “daily quiz” assignments to have submit_files = 0.
ALTER TABLE assignment
ADD submit_files TINYINT
DEFAULT 1;

UPDATE assignment
SET submit_files = 0
WHERE shortname LIKE 'dq%';

-- [Problem 3c]
-- Create a new table gradescheme and populate it
-- ADD FOREIGN KEY CONTSTRAINT.
CREATE TABLE gradescheme (
    scheme_id INTEGER,
    scheme_desc VARCHAR(100) NOT NULL,
    PRIMARY KEY (scheme_id)
);

INSERT INTO gradescheme VALUES
    ( 0, 'Lab assignment with min-grading.' ),
    ( 1, 'Daily quiz.' ),
    ( 2, 'Midterm or final exam.' );

ALTER TABLE assignment
RENAME COLUMN gradescheme TO scheme_id;

ALTER TABLE assignment
MODIFY scheme_id INTEGER NOT NULL;

ALTER TABLE assignment
ADD FOREIGN KEY (scheme_id) REFERENCES gradescheme(scheme_id);

