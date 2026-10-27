package com.feedback.controller;

import com.feedback.dao.FeedbackDAO;
import com.feedback.model.Feedback;
import com.feedback.model.FeedbackStats;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller for Admin Dashboard.
 * Retrieves feedback records and aggregate statistics using PreparedStatement via FeedbackDAO.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard", "/admin-dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Enforce Admin Session Check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentAdmin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login?msg=please_login");
            return;
        }

        // Read query filter parameters
        String courseFilter = request.getParameter("course");
        String ratingParam = request.getParameter("rating");
        String searchQuery = request.getParameter("search");

        int ratingFilter = 0;
        if (ratingParam != null && !ratingParam.trim().isEmpty()) {
            try {
                ratingFilter = Integer.parseInt(ratingParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        // Retrieve filtered feedback using PreparedStatement via FeedbackDAO
        List<Feedback> feedbackList = feedbackDAO.getFilteredFeedbacks(courseFilter, ratingFilter, searchQuery);

        // Retrieve aggregate analytics
        FeedbackStats stats = feedbackDAO.getFeedbackStats();

        // Forward Model to View
        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("stats", stats);
        request.setAttribute("selectedCourse", courseFilter);
        request.setAttribute("selectedRating", ratingFilter);
        request.setAttribute("searchQuery", searchQuery);

        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
}
