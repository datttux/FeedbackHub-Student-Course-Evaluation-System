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

/**
 * Controller handling feedback form presentation (doGet) and
 * submission processing (doPost) using the MVC architecture.
 */
@WebServlet(name = "FeedbackServlet", urlPatterns = {"/feedback"})
public class FeedbackServlet extends HttpServlet {
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

        // Forward to the feedback form view
        request.getRequestDispatcher("/feedback-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentStudent") == null) {
            response.sendRedirect(request.getContextPath() + "/student-login?msg=session_expired");
            return;
        }

        Student currentStudent = (Student) session.getAttribute("currentStudent");

        // 1. Retrieve Form Parameters
        String studentName = request.getParameter("studentName");
        String rollNo = request.getParameter("rollNo");
        String course = request.getParameter("course");
        String subject = request.getParameter("subject");
        String ratingStr = request.getParameter("rating");
        String comments = request.getParameter("comments");

        // Fall back to session values if read-only fields were untouched
        if (studentName == null || studentName.trim().isEmpty()) {
            studentName = currentStudent.getName();
        }
        if (rollNo == null || rollNo.trim().isEmpty()) {
            rollNo = currentStudent.getRollNo();
        }
        if (course == null || course.trim().isEmpty()) {
            course = currentStudent.getCourse();
        }

        // 2. Validate Input
        int rating = 5;
        try {
            if (ratingStr != null) {
                rating = Integer.parseInt(ratingStr.trim());
                if (rating < 1 || rating > 5) {
                    rating = 5;
                }
            }
        } catch (NumberFormatException e) {
            rating = 5;
        }

        if (subject == null || subject.trim().isEmpty() ||
            comments == null || comments.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Subject and Feedback comments are required.");
            request.setAttribute("subject", subject);
            request.setAttribute("rating", rating);
            request.setAttribute("comments", comments);
            request.getRequestDispatcher("/feedback-form.jsp").forward(request, response);
            return;
        }

        // 3. Encapsulate into Feedback JavaBean (Model)
        Feedback feedback = new Feedback();
        feedback.setStudentId(currentStudent.getId());
        feedback.setStudentName(studentName.trim());
        feedback.setRollNo(rollNo.trim().toUpperCase());
        feedback.setCourse(course.trim());
        feedback.setSubject(subject.trim());
        feedback.setRating(rating);
        feedback.setComments(comments.trim());

        // 4. Invoke Business Logic via DAO (Insert into DB using PreparedStatement)
        boolean isSaved = feedbackDAO.insertFeedback(feedback);

        // 5. Route to Presentation View (JSP)
        if (isSaved) {
            request.setAttribute("submittedFeedback", feedback);
            request.getRequestDispatcher("/feedback-success.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Unable to submit feedback. Please try again later.");
            request.setAttribute("subject", subject);
            request.setAttribute("rating", rating);
            request.setAttribute("comments", comments);
            request.getRequestDispatcher("/feedback-form.jsp").forward(request, response);
        }
    }
}
