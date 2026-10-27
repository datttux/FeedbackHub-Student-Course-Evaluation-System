package com.feedback.dao;

import com.feedback.model.Student;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Data Access Object for Student operations using JDBC PreparedStatement.
 */
public class StudentDAO {

    /**
     * Registers a new student using PreparedStatement.
     * @param student JavaBean containing registration data
     * @return true if successful, false otherwise
     */
    public boolean registerStudent(Student student) {
        String query = "INSERT INTO students (roll_no, name, email, course, password) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, student.getRollNo().trim().toUpperCase());
            pstmt.setString(2, student.getName().trim());
            pstmt.setString(3, student.getEmail().trim().toLowerCase());
            pstmt.setString(4, student.getCourse().trim());
            pstmt.setString(5, student.getPassword());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        student.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("[StudentDAO] Error registering student: " + e.getMessage());
        }
        return false;
    }

    /**
     * Validates student login credentials using PreparedStatement.
     * @param rollNo Student roll number
     * @param password Student password
     * @return Populated Student JavaBean if credentials match, null otherwise
     */
    public Student validateStudent(String rollNo, String password) {
        String query = "SELECT id, roll_no, name, email, course, password, created_at FROM students WHERE UPPER(roll_no) = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, rollNo.trim().toUpperCase());
            pstmt.setString(2, password);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Student student = new Student();
                    student.setId(rs.getInt("id"));
                    student.setRollNo(rs.getString("roll_no"));
                    student.setName(rs.getString("name"));
                    student.setEmail(rs.getString("email"));
                    student.setCourse(rs.getString("course"));
                    student.setPassword(rs.getString("password"));
                    student.setCreatedAt(rs.getTimestamp("created_at"));
                    return student;
                }
            }
        } catch (SQLException e) {
            System.err.println("[StudentDAO] Error validating student: " + e.getMessage());
        }
        return null;
    }

    /**
     * Checks if a roll number is already registered.
     */
    public boolean isRollNoExists(String rollNo) {
        String query = "SELECT id FROM students WHERE UPPER(roll_no) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, rollNo.trim().toUpperCase());
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("[StudentDAO] Error checking roll number: " + e.getMessage());
        }
        return false;
    }

    /**
     * Checks if an email is already registered.
     */
    public boolean isEmailExists(String email) {
        String query = "SELECT id FROM students WHERE LOWER(email) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, email.trim().toLowerCase());
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("[StudentDAO] Error checking email: " + e.getMessage());
        }
        return false;
    }
}
