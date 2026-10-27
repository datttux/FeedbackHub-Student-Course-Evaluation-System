package com.feedback.dao;

import com.feedback.model.Feedback;
import com.feedback.model.FeedbackStats;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for Feedback operations.
 * Implements JDBC Insert, Select, and Aggregate queries using PreparedStatement.
 */
public class FeedbackDAO {

    /**
     * Inserts new feedback into the database using PreparedStatement.
     * @param feedback The Feedback JavaBean populated from form submission
     * @return true if inserted successfully, false otherwise
     */
    public boolean insertFeedback(Feedback feedback) {
        String query = "INSERT INTO feedback (student_id, student_name, roll_no, course, subject, rating, comments) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, feedback.getStudentId());
            pstmt.setString(2, feedback.getStudentName());
            pstmt.setString(3, feedback.getRollNo());
            pstmt.setString(4, feedback.getCourse());
            pstmt.setString(5, feedback.getSubject());
            pstmt.setInt(6, feedback.getRating());
            pstmt.setString(7, feedback.getComments());

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = pstmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        feedback.setId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] Error inserting feedback: " + e.getMessage());
        }
        return false;
    }

    /**
     * Retrieves all feedback records using PreparedStatement, ordered by latest first.
     */
    public List<Feedback> getAllFeedbacks() {
        return getFilteredFeedbacks(null, 0, null);
    }

    /**
     * Retrieves feedback records with optional filters for Course, Rating, and Search Query.
     * Uses PreparedStatement with dynamic parameter binding.
     */
    public List<Feedback> getFilteredFeedbacks(String courseFilter, int ratingFilter, String searchQuery) {
        List<Feedback> feedbackList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT id, student_id, student_name, roll_no, course, subject, rating, comments, submitted_at FROM feedback WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (courseFilter != null && !courseFilter.trim().isEmpty() && !courseFilter.equalsIgnoreCase("ALL")) {
            sql.append(" AND course = ?");
            params.add(courseFilter.trim());
        }

        if (ratingFilter >= 1 && ratingFilter <= 5) {
            sql.append(" AND rating = ?");
            params.add(ratingFilter);
        }

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (LOWER(student_name) LIKE ? OR LOWER(roll_no) LIKE ? OR LOWER(subject) LIKE ? OR LOWER(comments) LIKE ?)");
            String pattern = "%" + searchQuery.trim().toLowerCase() + "%";
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }

        sql.append(" ORDER BY submitted_at DESC, id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Feedback fb = new Feedback();
                    fb.setId(rs.getInt("id"));
                    fb.setStudentId(rs.getInt("student_id"));
                    fb.setStudentName(rs.getString("student_name"));
                    fb.setRollNo(rs.getString("roll_no"));
                    fb.setCourse(rs.getString("course"));
                    fb.setSubject(rs.getString("subject"));
                    fb.setRating(rs.getInt("rating"));
                    fb.setComments(rs.getString("comments"));
                    fb.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    feedbackList.add(fb);
                }
            }
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] Error querying feedback: " + e.getMessage());
        }
        return feedbackList;
    }

    /**
     * Retrieves all feedbacks submitted by a specific student ID.
     */
    public List<Feedback> getFeedbacksByStudentId(int studentId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT id, student_id, student_name, roll_no, course, subject, rating, comments, submitted_at FROM feedback WHERE student_id = ? ORDER BY submitted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Feedback fb = new Feedback();
                    fb.setId(rs.getInt("id"));
                    fb.setStudentId(rs.getInt("student_id"));
                    fb.setStudentName(rs.getString("student_name"));
                    fb.setRollNo(rs.getString("roll_no"));
                    fb.setCourse(rs.getString("course"));
                    fb.setSubject(rs.getString("subject"));
                    fb.setRating(rs.getInt("rating"));
                    fb.setComments(rs.getString("comments"));
                    fb.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    list.add(fb);
                }
            }
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] Error fetching student feedbacks: " + e.getMessage());
        }
        return list;
    }

    /**
     * Calculates feedback statistics (counts, averages, course breakdowns).
     */
    public FeedbackStats getFeedbackStats() {
        FeedbackStats stats = new FeedbackStats();
        String summarySql = "SELECT COUNT(*) AS total_count, COALESCE(AVG(rating), 0.0) AS avg_rating, " +
                "SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) AS r5, " +
                "SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) AS r4, " +
                "SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) AS r3, " +
                "SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) AS r2, " +
                "SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) AS r1 " +
                "FROM feedback";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(summarySql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                stats.setTotalFeedback(rs.getInt("total_count"));
                stats.setAverageRating(Math.round(rs.getDouble("avg_rating") * 10.0) / 10.0);
                stats.setFiveStarCount(rs.getInt("r5"));
                stats.setFourStarCount(rs.getInt("r4"));
                stats.setThreeStarCount(rs.getInt("r3"));
                stats.setTwoStarCount(rs.getInt("r2"));
                stats.setOneStarCount(rs.getInt("r1"));
            }
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] Error calculating feedback stats: " + e.getMessage());
        }

        // Fetch course distribution
        String courseSql = "SELECT course, COUNT(*) AS count FROM feedback GROUP BY course ORDER BY count DESC";
        Map<String, Integer> courseMap = new HashMap<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(courseSql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                courseMap.put(rs.getString("course"), rs.getInt("count"));
            }
            stats.setCourseDistribution(courseMap);
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] Error fetching course breakdown: " + e.getMessage());
        }

        return stats;
    }

    /**
     * Deletes a feedback record by ID.
     */
    public boolean deleteFeedback(int feedbackId) {
        String sql = "DELETE FROM feedback WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, feedbackId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[FeedbackDAO] Error deleting feedback: " + e.getMessage());
        }
        return false;
    }
}
