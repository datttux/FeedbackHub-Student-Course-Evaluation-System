package com.feedback.controller;

import com.feedback.dao.StudentDAO;
import com.feedback.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller handling Student Authentication and Session Management.
 */
@WebServlet(name = "StudentLoginServlet", urlPatterns = {"/student-login", "/login"})
public class StudentLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // If already logged in as student, redirect to feedback form
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentStudent") != null) {
            response.sendRedirect(request.getContextPath() + "/feedback");
            return;
        }
        request.getRequestDispatcher("/student-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String rollNo = request.getParameter("rollNo");
        String password = request.getParameter("password");

        if (rollNo == null || rollNo.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please provide both Roll Number and Password.");
            request.setAttribute("rollNo", rollNo);
            request.getRequestDispatcher("/student-login.jsp").forward(request, response);
            return;
        }

        Student student = studentDAO.validateStudent(rollNo, password);

        if (student != null) {
            // Invalidate any existing session and start a fresh session
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("currentStudent", student);
            session.setAttribute("userRole", "STUDENT");
            // Set 30 minutes session timeout
            session.setMaxInactiveInterval(30 * 60);

            // Redirect to feedback form
            response.sendRedirect(request.getContextPath() + "/feedback");
        } else {
            request.setAttribute("errorMessage", "Invalid Roll Number or Password. Try CS202601 / student123");
            request.setAttribute("rollNo", rollNo);
            request.getRequestDispatcher("/student-login.jsp").forward(request, response);
        }
    }
}
