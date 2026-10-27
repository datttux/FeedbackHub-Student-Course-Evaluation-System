-- ====================================================================
-- Student Feedback System - Database Schema and Seed Data
-- Architecture: MVC with Java, JSP, JDBC, MySQL
-- ====================================================================

-- 1. Create Database if not exists
CREATE DATABASE IF NOT EXISTS student_feedback_db;
USE student_feedback_db;

-- 2. Drop existing tables for clean setup (optional in production)
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS admins;

-- 3. Create 'students' table
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_no VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    course VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Create 'feedback' table
CREATE TABLE IF NOT EXISTS feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    roll_no VARCHAR(50) NOT NULL,
    course VARCHAR(100) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comments TEXT NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_feedback_student FOREIGN KEY (student_id) 
        REFERENCES students(id) ON DELETE CASCADE
);

-- 5. Create 'admins' table
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) DEFAULT 'ADMIN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Seed Sample Data

-- Default Admin Account (Username: admin, Password: admin123)
INSERT INTO admins (username, password, full_name, role) VALUES 
('admin', 'admin123', 'Prof. Robert Vance', 'ADMIN');

-- Sample Students (Password for all demo accounts: student123)
INSERT INTO students (roll_no, name, email, course, password) VALUES
('CS202601', 'Aarav Sharma', 'aarav.sharma@college.edu', 'Computer Science & Engineering', 'student123'),
('CS202602', 'Diya Patel', 'diya.patel@college.edu', 'Computer Science & Engineering', 'student123'),
('AI202615', 'Rohan Gupta', 'rohan.gupta@college.edu', 'AI & Machine Learning', 'student123'),
('DS202633', 'Ananya Iyer', 'ananya.iyer@college.edu', 'Data Science', 'student123'),
('IT202644', 'Vikram Singh', 'vikram.singh@college.edu', 'Information Technology', 'student123');

-- Sample Feedback records
INSERT INTO feedback (student_id, student_name, roll_no, course, subject, rating, comments, submitted_at) VALUES
(1, 'Aarav Sharma', 'CS202601', 'Computer Science & Engineering', 'Data Structures & Algorithms', 5, 'Prof. Vance explains graph algorithms with great clarity and real-world analogies. The lab sessions are very helpful.', NOW() - INTERVAL 5 DAY),
(2, 'Diya Patel', 'CS202602', 'Computer Science & Engineering', 'Web Technologies (Java & JSP)', 5, 'Excellent coverage of Servlets, JDBC, and MVC architecture. Practical coding demonstrations made concepts very easy to digest.', NOW() - INTERVAL 4 DAY),
(3, 'Rohan Gupta', 'AI202615', 'AI & Machine Learning', 'Deep Learning & Neural Networks', 4, 'Great theoretical depth. Would appreciate a few more hands-on PyTorch assignments for computer vision.', NOW() - INTERVAL 3 DAY),
(4, 'Ananya Iyer', 'DS202633', 'Data Science', 'Big Data Analytics', 4, 'Very engaging curriculum. Spark and Hadoop distributed data processing exercises were thoroughly planned.', NOW() - INTERVAL 2 DAY),
(5, 'Vikram Singh', 'IT202644', 'Information Technology', 'Cloud Computing & DevOps', 3, 'Content is good but the cloud sandbox lab environment was occasionally slow during peak practical hours.', NOW() - INTERVAL 1 DAY),
(1, 'Aarav Sharma', 'CS202601', 'Computer Science & Engineering', 'Database Management Systems', 5, 'Query optimization and transaction ACID property sessions were top tier! Highly recommended.', NOW());

-- 7. Verification Queries
SELECT 'Database setup completed successfully!' AS Status;
SELECT COUNT(*) AS total_students FROM students;
SELECT COUNT(*) AS total_feedback FROM feedback;
SELECT COUNT(*) AS total_admins FROM admins;
