package com.feedback.controller;

import com.feedback.dao.AdminDAO;
import com.feedback.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller handling Admin Login and Session Initiation.
 */
@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/admin-login", "/admin/login"})
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentAdmin") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter both username and password.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
            return;
        }

        Admin admin = adminDAO.validateAdmin(username, password);

        if (admin != null) {
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("currentAdmin", admin);
            session.setAttribute("userRole", "ADMIN");
            session.setMaxInactiveInterval(60 * 60); // 1 hour session

            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid administrator credentials. Try admin / admin123");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
        }
    }
}
