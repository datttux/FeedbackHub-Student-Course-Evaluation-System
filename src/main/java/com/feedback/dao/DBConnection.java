package com.feedback.dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

/**
 * Database Connection Utility using standard JDBC.
 * Supports configurable MySQL connection via db.properties.
 * Includes automatic schema initialization and an embedded H2 fallback
 * to guarantee that the application runs out of the box even if MySQL credentials
 * need local configuration.
 */
public class DBConnection {

    private static String dbDriver;
    private static String dbUrl;
    private static String dbUser;
    private static String dbPassword;

    private static String h2Driver;
    private static String h2Url;
    private static String h2User;
    private static String h2Password;

    private static boolean isUsingFallback = false;
    private static boolean schemaInitialized = false;

    static {
        loadProperties();
    }

    private static void loadProperties() {
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            Properties props = new Properties();
            if (in != null) {
                props.load(in);
            }

            // System environment or properties take precedence if provided
            dbDriver = System.getProperty("db.driver", props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver"));
            dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : props.getProperty("db.url", "jdbc:mysql://localhost:3306/student_feedback_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
            dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : props.getProperty("db.user", "root");
            dbPassword = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : props.getProperty("db.password", "root");

            h2Driver = props.getProperty("h2.driver", "org.h2.Driver");
            h2Url = props.getProperty("h2.url", "jdbc:h2:mem:student_feedback_db;DB_CLOSE_DELAY=-1;MODE=MySQL");
            h2User = props.getProperty("h2.user", "sa");
            h2Password = props.getProperty("h2.password", "");

        } catch (Exception e) {
            System.err.println("[DBConnection] Warning: Could not load db.properties, using defaults. " + e.getMessage());
            dbDriver = "com.mysql.cj.jdbc.Driver";
            dbUrl = "jdbc:mysql://localhost:3306/student_feedback_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            dbUser = "root";
            dbPassword = "password";
            h2Driver = "org.h2.Driver";
            h2Url = "jdbc:h2:mem:student_feedback_db;DB_CLOSE_DELAY=-1;MODE=MySQL";
            h2User = "sa";
            h2Password = "";
        }
    }

    /**
     * Obtains a JDBC Connection.
     * Attempts MySQL first. If MySQL is unreachable, falls back to embedded H2.
     */
    public static synchronized Connection getConnection() throws SQLException {
        if (isUsingFallback) {
            return getH2Connection();
        }

        try {
            Class.forName(dbDriver);
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            if (!schemaInitialized) {
                initSchema(conn, false);
                schemaInitialized = true;
                System.out.println("[DBConnection] Successfully connected to MySQL at: " + dbUrl);
            }
            return conn;
        } catch (Exception ex) {
            System.err.println("[DBConnection] NOTICE: MySQL connection failed (" + ex.getMessage() + ")");
            System.err.println("[DBConnection] Activating Embedded H2 Database Fallback so your app runs smoothly!");
            isUsingFallback = true;
            return getH2Connection();
        }
    }

    private static Connection getH2Connection() throws SQLException {
        try {
            Class.forName(h2Driver);
            Connection conn = DriverManager.getConnection(h2Url, h2User, h2Password);
            if (!schemaInitialized) {
                initSchema(conn, true);
                schemaInitialized = true;
                System.out.println("[DBConnection] Embedded H2 Database active and seeded with sample data.");
            }
            return conn;
        } catch (ClassNotFoundException e) {
            throw new SQLException("Embedded database driver not found: " + e.getMessage(), e);
        }
    }

    public static boolean isFallbackActive() {
        return isUsingFallback;
    }

    /**
     * Initializes tables and demo seed data if they do not exist.
     */
    private static void initSchema(Connection conn, boolean isH2) {
        try (Statement stmt = conn.createStatement()) {
            // Check if tables already exist
            boolean tablesExist = false;
            try {
                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM students");
                if (rs.next()) {
                    tablesExist = true;
                }
            } catch (SQLException ignored) {
                // Table doesn't exist yet
            }

            if (!tablesExist) {
                System.out.println("[DBConnection] Initializing database tables and seed data...");

                // Create students table
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS students (" +
                    "  id INT AUTO_INCREMENT PRIMARY KEY," +
                    "  roll_no VARCHAR(50) NOT NULL UNIQUE," +
                    "  name VARCHAR(100) NOT NULL," +
                    "  email VARCHAR(100) NOT NULL UNIQUE," +
                    "  course VARCHAR(100) NOT NULL," +
                    "  password VARCHAR(255) NOT NULL," +
                    "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")"
                );

                // Create feedback table
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS feedback (" +
                    "  id INT AUTO_INCREMENT PRIMARY KEY," +
                    "  student_id INT NOT NULL," +
                    "  student_name VARCHAR(100) NOT NULL," +
                    "  roll_no VARCHAR(50) NOT NULL," +
                    "  course VARCHAR(100) NOT NULL," +
                    "  subject VARCHAR(100) NOT NULL," +
                    "  rating INT NOT NULL," +
                    "  comments TEXT NOT NULL," +
                    "  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")"
                );

                // Create admins table
                stmt.execute(
                    "CREATE TABLE IF NOT EXISTS admins (" +
                    "  id INT AUTO_INCREMENT PRIMARY KEY," +
                    "  username VARCHAR(50) NOT NULL UNIQUE," +
                    "  password VARCHAR(255) NOT NULL," +
                    "  full_name VARCHAR(100) NOT NULL," +
                    "  role VARCHAR(50) DEFAULT 'ADMIN'" +
                    ")"
                );

                // Seed default Admin
                stmt.execute(
                    "INSERT INTO admins (username, password, full_name, role) " +
                    "VALUES ('admin', 'admin123', 'Prof. Robert Vance', 'ADMIN')"
                );

                // Seed sample students
                stmt.execute(
                    "INSERT INTO students (roll_no, name, email, course, password) VALUES " +
                    "('CS202601', 'Aarav Sharma', 'aarav.sharma@college.edu', 'Computer Science & Engineering', 'student123')," +
                    "('CS202602', 'Diya Patel', 'diya.patel@college.edu', 'Computer Science & Engineering', 'student123')," +
                    "('AI202615', 'Rohan Gupta', 'rohan.gupta@college.edu', 'AI & Machine Learning', 'student123')," +
                    "('DS202633', 'Ananya Iyer', 'ananya.iyer@college.edu', 'Data Science', 'student123')," +
                    "('IT202644', 'Vikram Singh', 'vikram.singh@college.edu', 'Information Technology', 'student123')"
                );

                // Seed sample feedback
                stmt.execute(
                    "INSERT INTO feedback (student_id, student_name, roll_no, course, subject, rating, comments) VALUES " +
                    "(1, 'Aarav Sharma', 'CS202601', 'Computer Science & Engineering', 'Data Structures & Algorithms', 5, 'Prof. Vance explains graph algorithms with great clarity and real-world analogies. The lab sessions are very helpful.')," +
                    "(2, 'Diya Patel', 'CS202602', 'Computer Science & Engineering', 'Web Technologies (Java & JSP)', 5, 'Excellent coverage of Servlets, JDBC, and MVC architecture. Practical coding demonstrations made concepts very easy to digest.')," +
                    "(3, 'Rohan Gupta', 'AI202615', 'AI & Machine Learning', 'Deep Learning & Neural Networks', 4, 'Great theoretical depth. Would appreciate a few more hands-on PyTorch assignments for computer vision.')," +
                    "(4, 'Ananya Iyer', 'DS202633', 'Data Science', 'Big Data Analytics', 4, 'Very engaging curriculum. Spark and Hadoop distributed data processing exercises were thoroughly planned.')," +
                    "(5, 'Vikram Singh', 'IT202644', 'Information Technology', 'Cloud Computing & DevOps', 3, 'Content is good but the cloud sandbox lab environment was occasionally slow during peak practical hours.')," +
                    "(1, 'Aarav Sharma', 'CS202601', 'Computer Science & Engineering', 'Database Management Systems', 5, 'Query optimization and transaction ACID property sessions were top tier! Highly recommended.')"
                );

                System.out.println("[DBConnection] Database schema and initial seed data created successfully!");
            }
        } catch (SQLException e) {
            System.err.println("[DBConnection] Schema initialization error: " + e.getMessage());
        }
    }
}
