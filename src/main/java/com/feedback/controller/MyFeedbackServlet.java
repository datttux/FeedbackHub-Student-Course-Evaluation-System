package com.feedback.controller;

import com.feedback.dao.FeedbackDAO;
import com.feedback.model.Feedback;
import com.feedback.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller allowing logged-in students to view all feedbacks they have submitted.
 */
@WebServlet(name = "MyFeedbackServlet", urlPatterns = {"/my-feedback"})
public class MyFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentStudent") == null) {
            response.sendRedirect(request.getContextPath() + "/student-login?msg=please_login");
            return;
        }

        Student student = (Student) session.getAttribute("currentStudent");
        List<Feedback> myFeedbacks = feedbackDAO.getFeedbacksByStudentId(student.getId());

        request.setAttribute("feedbacks", myFeedbacks);
        request.getRequestDispatcher("/my-feedback.jsp").forward(request, response);
    }
}
