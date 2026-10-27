<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Student Login");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String rollNo = (String) request.getAttribute("rollNo");
    if (rollNo == null) rollNo = "";
    String msg = request.getParameter("msg");
%>
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 480px;">

        <% if ("please_login".equals(msg)) { %>
            <div class="alert alert-info">
                <span>&#9432;</span> Please log in to submit your course feedback.
            </div>
        <% } else if ("session_expired".equals(msg)) { %>
            <div class="alert alert-danger">
                <span>&#9888;</span> Your session expired. Please log in again.
            </div>
        <% } %>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="alert alert-danger">
                <span>&#9888;</span> <%= errorMessage %>
            </div>
        <% } %>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Student Login</h2>
                <p class="card-subtitle">Enter your roll number and password to access the feedback form.</p>
            </div>

            <form action="<%= request.getContextPath() %>/student-login" method="POST">
                <div class="form-group">
                    <label class="form-label" for="rollNo">Student Roll Number</label>
                    <input type="text" id="rollNo" name="rollNo" class="form-control" 
                           placeholder="e.g. CS202601" value="<%= rollNo %>" required autofocus>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Enter your password" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 10px;">
                    Sign In to Student Portal
                </button>
            </form>

            <div style="margin-top: 20px; text-align: center; font-size: 0.9rem; color: var(--text-secondary);">
                Don't have an account? <a href="<%= request.getContextPath() %>/student-register" style="color: var(--primary); font-weight: 600; text-decoration: none;">Register here</a>
            </div>

            <!-- Demo Credentials Helper -->
            <div class="demo-box" style="margin-top: 24px;">
                <div class="demo-box-title">
                    <span>Quick Fill Demo</span>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="fillStudentDemo('CS202601', 'student123')">
                        Auto-Fill
                    </button>
                </div>
                <div>Roll No: <span class="demo-code">CS202601</span></div>
                <div style="margin-top: 4px;">Password: <span class="demo-code">student123</span></div>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
