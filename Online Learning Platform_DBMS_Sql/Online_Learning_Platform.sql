/* ============================================================
   ONLINE LEARNING PLATFORM (LMS WITH ANALYTICS)
   DBMS Semester Project
   Student: Waqar Ahmad
   Instructor: Mr. Ihtisham Ullah
   Semester: Spring 2026
   Database: MySQL
   ============================================================ */


/* =========================
   1. DATABASE CREATION
   ========================= */

CREATE DATABASE Online_Learning_Platform;
USE Online_Learning_Platform;


/* =========================
   2. TABLE CREATION
   ========================= */


/* -------- USERS TABLE --------
   Stores Students, Instructors, and Admins
*/
CREATE TABLE Users (
    User_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Role VARCHAR(20) NOT NULL
);


/* -------- COURSES TABLE --------
   Each course is taught by one instructor
*/
CREATE TABLE Courses (
    Course_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Description TEXT,
    Instructor_ID INT NOT NULL,
    FOREIGN KEY (Instructor_ID)
        REFERENCES Users(User_ID)
        ON DELETE CASCADE
);


/* -------- ENROLLMENTS TABLE --------
   Resolves many-to-many relationship between Users and Courses
*/
CREATE TABLE Enrollments (
    Enrollment_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT NOT NULL,
    Course_ID INT NOT NULL,
    Enrollment_Date DATE NOT NULL,
    FOREIGN KEY (User_ID)
        REFERENCES Users(User_ID)
        ON DELETE CASCADE,
    FOREIGN KEY (Course_ID)
        REFERENCES Courses(Course_ID)
        ON DELETE CASCADE
);


/* -------- ASSIGNMENTS TABLE --------
   Each course can have multiple assignments
*/
CREATE TABLE Assignments (
    Assignment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Course_ID INT NOT NULL,
    Title VARCHAR(100) NOT NULL,
    Due_Date DATE NOT NULL,
    FOREIGN KEY (Course_ID)
        REFERENCES Courses(Course_ID)
        ON DELETE CASCADE
);


/* -------- SUBMISSIONS TABLE --------
   Stores student submissions and marks
*/
CREATE TABLE Submissions (
    Submission_ID INT AUTO_INCREMENT PRIMARY KEY,
    Assignment_ID INT NOT NULL,
    User_ID INT NOT NULL,
    Marks INT,
    Submission_Date DATE NOT NULL,
    FOREIGN KEY (Assignment_ID)
        REFERENCES Assignments(Assignment_ID)
        ON DELETE CASCADE,
    FOREIGN KEY (User_ID)
        REFERENCES Users(User_ID)
        ON DELETE CASCADE
);


/* =========================
   3. CONSTRAINTS
   ========================= */

/* Marks must be between 0 and 100 */
ALTER TABLE Submissions
ADD CONSTRAINT chk_marks CHECK (Marks BETWEEN 0 AND 100);

/* Role validation */
ALTER TABLE Users
ADD CONSTRAINT chk_role
CHECK (Role IN ('Student', 'Instructor', 'Admin'));


/* =========================
   4. SAMPLE DATA INSERTION
   ========================= */


/* ---- USERS ---- */
INSERT INTO Users (Name, Email, Role) VALUES
('Ali Khan', 'ali@gmail.com', 'Student'),
('Sara Ahmed', 'sara@gmail.com', 'Student'),
('Dr. Ihtisham', 'ihtisham@gmail.com', 'Instructor'),
('Admin User', 'admin@gmail.com', 'Admin');


/* ---- COURSES ---- */
INSERT INTO Courses (Title, Description, Instructor_ID) VALUES
('Database Systems', 'Learn DBMS concepts and SQL', 3),
('Web Development', 'Frontend and Backend Development', 3);


/* ---- ENROLLMENTS ---- */
INSERT INTO Enrollments (User_ID, Course_ID, Enrollment_Date) VALUES
(1, 1, '2026-02-01'),
(2, 1, '2026-02-02'),
(1, 2, '2026-02-03');


/* ---- ASSIGNMENTS ---- */
INSERT INTO Assignments (Course_ID, Title, Due_Date) VALUES
(1, 'ER Diagram', '2026-03-10'),
(1, 'Normalization Task', '2026-03-15'),
(2, 'Website Layout', '2026-03-20');


/* ---- SUBMISSIONS ---- */
INSERT INTO Submissions (Assignment_ID, User_ID, Marks, Submission_Date) VALUES
(1, 1, 85, '2026-03-08'),
(1, 2, 90, '2026-03-09'),
(2, 1, 88, '2026-03-14'),
(3, 1, 92, '2026-03-18');


/* =========================
   5. QUERY IMPLEMENTATION
   ========================= */


/* ---- JOIN QUERY ----
   Student + Course + Assignment + Marks
*/
SELECT u.Name AS Student,
       c.Title AS Course,
       a.Title AS Assignment,
       s.Marks
FROM Submissions s
JOIN Users u ON s.User_ID = u.User_ID
JOIN Assignments a ON s.Assignment_ID = a.Assignment_ID
JOIN Courses c ON a.Course_ID = c.Course_ID;


/* ---- AGGREGATION ----
   Average marks of all submissions
*/
SELECT AVG(Marks) AS Average_Marks
FROM Submissions;


/* ---- GROUP BY ----
   Course-wise enrolled students
*/
SELECT c.Title,
       COUNT(e.User_ID) AS Total_Students
FROM Courses c
JOIN Enrollments e ON c.Course_ID = e.Course_ID
GROUP BY c.Title;


/* ---- SUBQUERY ----
   Top performing student (highest average marks)
*/
SELECT Name
FROM Users
WHERE User_ID = (
    SELECT User_ID
    FROM Submissions
    GROUP BY User_ID
    ORDER BY AVG(Marks) DESC
    LIMIT 1
);


/* ---- FILTERING ----
   Students scoring above 85
*/
SELECT u.Name, s.Marks
FROM Users u
JOIN Submissions s ON u.User_ID = s.User_ID
WHERE s.Marks > 85;


/* ---- MONTHLY REPORT ----
   Assignment submissions per month
*/
SELECT MONTH(Submission_Date) AS Month,
       COUNT(*) AS Total_Submissions
FROM Submissions
GROUP BY MONTH(Submission_Date);


/* =========================
   END OF SCRIPT
   ========================= */