<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Student Registration");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String rollNo = (String) request.getAttribute("rollNo");
    String name = (String) request.getAttribute("name");
    String email = (String) request.getAttribute("email");
    String course = (String) request.getAttribute("course");
    if (rollNo == null) rollNo = "";
    if (name == null) name = "";
    if (email == null) email = "";
    if (course == null) course = "";
%>
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 540px;">

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="alert alert-danger">
                <span>&#9888;</span> <%= errorMessage %>
            </div>
        <% } %>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Student Registration</h2>
                <p class="card-subtitle">Create a student account to participate in faculty and course evaluations.</p>
            </div>

            <form action="<%= request.getContextPath() %>/student-register" method="POST">
                <div class="form-group">
                    <label class="form-label" for="rollNo">Roll Number / Student ID</label>
                    <input type="text" id="rollNo" name="rollNo" class="form-control" 
                           placeholder="e.g. CS202650" value="<%= rollNo %>" required autofocus>
                </div>

                <div class="form-group">
                    <label class="form-label" for="name">Full Name</label>
                    <input type="text" id="name" name="name" class="form-control" 
                           placeholder="e.g. Priya Sharma" value="<%= name %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">College Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="e.g. priya.sharma@college.edu" value="<%= email %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="course">Academic Program / Course</label>
                    <select id="course" name="course" class="form-control" required>
                        <option value="" disabled <%= course.isEmpty() ? "selected" : "" %>>Select your course</option>
                        <option value="Computer Science & Engineering" <%= "Computer Science & Engineering".equals(course) ? "selected" : "" %>>Computer Science & Engineering</option>
                        <option value="AI & Machine Learning" <%= "AI & Machine Learning".equals(course) ? "selected" : "" %>>AI & Machine Learning</option>
                        <option value="Data Science" <%= "Data Science".equals(course) ? "selected" : "" %>>Data Science</option>
                        <option value="Information Technology" <%= "Information Technology".equals(course) ? "selected" : "" %>>Information Technology</option>
                        <option value="Electronics & Communication" <%= "Electronics & Communication".equals(course) ? "selected" : "" %>>Electronics & Communication</option>
                    </select>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="form-group">
                        <label class="form-label" for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control" 
                               placeholder="Create password" required minlength="4">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                               placeholder="Repeat password" required minlength="4">
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 12px;">
                    Register & Continue
                </button>
            </form>

            <div style="margin-top: 20px; text-align: center; font-size: 0.9rem; color: var(--text-secondary);">
                Already have an account? <a href="<%= request.getContextPath() %>/student-login" style="color: var(--primary); font-weight: 600; text-decoration: none;">Login here</a>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
