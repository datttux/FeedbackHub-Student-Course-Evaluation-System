package com.feedback.dao;

import com.feedback.model.Admin;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Data Access Object for Administrator authentication and profile lookup.
 */
public class AdminDAO {

    /**
     * Validates administrator credentials using PreparedStatement.
     */
    public Admin validateAdmin(String username, String password) {
        String query = "SELECT id, username, full_name, role FROM admins WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, username.trim());
            pstmt.setString(2, password);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setId(rs.getInt("id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setFullName(rs.getString("full_name"));
                    admin.setRole(rs.getString("role"));
                    return admin;
                }
            }
        } catch (SQLException e) {
            System.err.println("[AdminDAO] Error validating admin: " + e.getMessage());
        }
        return null;
    }
}
