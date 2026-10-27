<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.feedback.model.Student, com.feedback.model.Admin" %>
<%
    Student currentStudent = (Student) session.getAttribute("currentStudent");
    Admin currentAdmin = (Admin) session.getAttribute("currentAdmin");
    String userRole = (String) session.getAttribute("userRole");
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "Student Feedback System";
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> | Student Feedback System</title>
    <!-- Stylesheets -->
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <!-- Favicon -->
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🎓</text></svg>">
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar">
    <div class="container nav-container">
        <a href="<%= contextPath %>/index.jsp" class="nav-brand">
            <div class="brand-icon">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                </svg>
            </div>
            <span>FeedbackHub</span>
            <span class="brand-badge">MVC</span>
        </a>

        <ul class="nav-menu">
            <li><a href="<%= contextPath %>/index.jsp" class="nav-link">Home</a></li>

            <% if (currentStudent != null) { %>
                <li><a href="<%= contextPath %>/feedback" class="nav-link">Give Feedback</a></li>
                <li><a href="<%= contextPath %>/my-feedback" class="nav-link">My History</a></li>
                <li>
                    <div class="user-pill">
                        <div class="user-avatar"><%= currentStudent.getName().substring(0, 1).toUpperCase() %></div>
                        <span><%= currentStudent.getName() %> (<%= currentStudent.getRollNo() %>)</span>
                    </div>
                </li>
                <li><a href="<%= contextPath %>/logout" class="btn btn-secondary btn-sm">Logout</a></li>
            <% } else if (currentAdmin != null) { %>
                <li><a href="<%= contextPath %>/admin/dashboard" class="nav-link">Admin Dashboard</a></li>
                <li>
                    <div class="user-pill">
                        <div class="user-avatar" style="background: linear-gradient(135deg, #ec4899, #8b5cf6);">A</div>
                        <span><%= currentAdmin.getFullName() %> (Admin)</span>
                    </div>
                </li>
                <li><a href="<%= contextPath %>/logout" class="btn btn-secondary btn-sm">Logout</a></li>
            <% } else { %>
                <li><a href="<%= contextPath %>/student-login" class="nav-link">Student Login</a></li>
                <li><a href="<%= contextPath %>/student-register" class="nav-link">Register</a></li>
                <li><a href="<%= contextPath %>/admin-login" class="btn btn-primary btn-sm">Admin Portal</a></li>
            <% } %>
        </ul>
    </div>
</nav>
