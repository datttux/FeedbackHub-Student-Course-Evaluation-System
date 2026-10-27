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
 * Controller handling Student Registration.
 * Encapsulates form parameters into a Student JavaBean.
 */
@WebServlet(name = "StudentRegisterServlet", urlPatterns = {"/student-register", "/register"})
public class StudentRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/student-register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String rollNo = request.getParameter("rollNo");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String course = request.getParameter("course");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Simple validation
        if (rollNo == null || rollNo.trim().isEmpty() ||
            name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            course == null || course.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required.");
            retainFormData(request, rollNo, name, email, course);
            request.getRequestDispatcher("/student-register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            retainFormData(request, rollNo, name, email, course);
            request.getRequestDispatcher("/student-register.jsp").forward(request, response);
            return;
        }

        if (studentDAO.isRollNoExists(rollNo)) {
            request.setAttribute("errorMessage", "Roll number '" + rollNo + "' is already registered.");
            retainFormData(request, rollNo, name, email, course);
            request.getRequestDispatcher("/student-register.jsp").forward(request, response);
            return;
        }

        if (studentDAO.isEmailExists(email)) {
            request.setAttribute("errorMessage", "Email address '" + email + "' is already registered.");
            retainFormData(request, rollNo, name, email, course);
            request.getRequestDispatcher("/student-register.jsp").forward(request, response);
            return;
        }

        // Encapsulate into Student JavaBean (MVC data transfer)
        Student student = new Student(rollNo.trim().toUpperCase(), name.trim(), email.trim(), course.trim(), password);

        boolean registered = studentDAO.registerStudent(student);

        if (registered) {
            // Auto-login upon registration
            HttpSession session = request.getSession(true);
            session.setAttribute("currentStudent", student);
            session.setAttribute("userRole", "STUDENT");
            session.setMaxInactiveInterval(30 * 60);

            request.setAttribute("successMessage", "Account created successfully! Welcome, " + student.getName() + ".");
            response.sendRedirect(request.getContextPath() + "/feedback?registered=true");
        } else {
            request.setAttribute("errorMessage", "Registration failed due to a database error. Please try again.");
            retainFormData(request, rollNo, name, email, course);
            request.getRequestDispatcher("/student-register.jsp").forward(request, response);
        }
    }

    private void retainFormData(HttpServletRequest req, String rollNo, String name, String email, String course) {
        req.setAttribute("rollNo", rollNo);
        req.setAttribute("name", name);
        req.setAttribute("email", email);
        req.setAttribute("course", course);
    }
}
