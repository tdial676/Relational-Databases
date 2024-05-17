-- [Problem 1a]
-- Project student names registered in courses 
-- in the Comp. Sci. deparment.
SELECT DISTINCT student.name  
FROM course, takes, student 
WHERE course.course_id  = takes.course_id 
    AND student.id = takes.id 
    AND course.dept_name = 'Comp. Sci.';

-- [Problem 1b]
-- Project the department and max salary by grouping 
-- the departments and finding the max salaary in each group.
SELECT dept_name, MAX(salary) AS max_salary
FROM instructor 
GROUP BY dept_name;

-- [Problem 1c]
-- Find the minimum salary amongst the maximum salaries 
-- of each department using the results of a sub query.
SELECT MIN(max_salary) AS smallest_max_salary
FROM 
    (SELECT dept_name, MAX(salary) AS max_salary
    FROM instructor 
    GROUP BY dept_name) as max_salaries;

-- [Problem 1d]
-- Find the minimum salary amongst the maximum salaries 
-- of each department using a temporary table of max salaries.
CREATE TEMPORARY TABLE memb_counts
    SELECT dept_name, MAX(salary) AS max_salary
    FROM instructor 
    GROUP BY dept_name;

SELECT MIN(max_salary) AS smallest_max_salary
FROM memb_counts;

-- [Problem 2a]
-- Add CS-001 course to course table
INSERT INTO course VALUES ('CS-001',  'Weekly Seminar', 'Comp. Sci.', '0');

-- [Problem 2b]
-- Create a section for added course
INSERT INTO section 
VALUES ('CS-001', '1', 'Winter', '2023', NULL, NULL, NULL);

-- [Problem 2c]
-- Enroll every student into new course
INSERT INTO takes
SELECT id, course_id, sec_id, semester, year, NULL
FROM student, section
WHERE student.dept_name =  'Comp. Sci.'
    AND section.course_id = 'CS-001';

-- [Problem 2d]
-- unenroll student Snow from the added section
DELETE FROM takes
WHERE course_id = 'CS-001'
    AND id = (SELECT id FROM student WHERE name = 'Snow');

-- [Problem 2e]
-- delete cs1 course
DELETE FROM course
WHERE course_id = 'CS-001';
-- The above operation executes fine, but in theory it should not work as 
-- course_id is a foreign key referenced from course for sections meaning
-- that we would still have sections of this course we are tryign to delete
-- hence why we should of deleted the section first before the deleting 
-- the course. However, after deleting the course, I noticed
-- that the course section was also deleted probably due to the
-- ON DELETE CASCADE which explains why he command executed instead of being
-- trejected as it delted both the course and section.

-- [Problem 2f]
-- remove all students taking a database course section
DELETE FROM takes
WHERE course_id = (SELECT course_id FROM course WHERE title LIKE '%database%')

-- [Problem 3a]
-- ordered names of all poeple who have borrowed a book by "McGraw-Hill"
SELECT DISTINCT name
FROM member, book, borrowed
WHERE book.publisher = 'McGraw-Hill'
    AND member.memb_no = borrowed.memb_no
    AND book.isbn = borrowed.isbn
ORDER BY name ASC;

-- [Problem 3b]
-- ordered names of all individuals who have read all books by "McGraw-Hill"
CREATE TEMPORARY TABLE McGraw_books_read 
    SELECT DISTINCT name, COUNT(book.isbn) AS book_count
    FROM member, book, borrowed
    WHERE book.publisher = 'McGraw-Hill'
        AND member.memb_no = borrowed.memb_no
        AND book.isbn = borrowed.isbn
    GROUP BY name;

SELECT DISTINCT name
FROM McGraw_books_read, book
WHERE McGraw_books_read.book_count = (SELECT COUNT(isbn) 
                                    FROM book 
                                    WHERE publisher = 'McGraw-Hill');

-- [Problem 3c]
-- Retrive names of people who have read more than five books
-- from one publisher and that publsiher.
SELECT book.publisher, member.name
FROM member, book, borrowed
WHERE member.memb_no = borrowed.memb_no
    AND book.isbn = borrowed.isbn
    GROUP BY publisher, name
    HAVING COUNT(publisher) > 5
ORDER BY member.name ASC;

-- [Problem 3d]
-- average number of books borrowed accross all members
SELECT COUNT(*)  / (SELECT COUNT(*) FROM member) AS avg_num_books
FROM borrowed;

-- [Problem 3e]
-- average number of books borrowed accross all members using temp table
CREATE TEMPORARY TABLE memb_counts
    SELECT memb_no, COUNT(isbn) AS count
    FROM borrowed
    GROUP BY memb_no;

SELECT SUM(count) / (SELECT COUNT(*) FROM member) AS avg_num_books
FROM memb_counts