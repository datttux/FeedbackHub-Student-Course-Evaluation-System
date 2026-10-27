<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.feedback.model.Student" %>
<%
    Student currentStudent = (Student) session.getAttribute("currentStudent");
    if (currentStudent == null) {
        response.sendRedirect(request.getContextPath() + "/student-login?msg=please_login");
        return;
    }

    request.setAttribute("pageTitle", "Submit Course Feedback");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String subject = (String) request.getAttribute("subject");
    String comments = (String) request.getAttribute("comments");
    Integer ratingVal = (Integer) request.getAttribute("rating");
    if (subject == null) subject = "";
    if (comments == null) comments = "";
    if (ratingVal == null) ratingVal = 5;

    boolean registeredJustNow = "true".equals(request.getParameter("registered"));
%>
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 720px;">

        <% if (registeredJustNow) { %>
            <div class="alert alert-success">
                <span>&#10003;</span> Welcome! Your account was created successfully. You can now submit your course feedback below.
            </div>
        <% } %>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="alert alert-danger">
                <span>&#9888;</span> <%= errorMessage %>
            </div>
        <% } %>

        <div class="card">
            <div class="card-header">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 12px;">
                    <div>
                        <h2 class="card-title">Course Feedback Form</h2>
                        <p class="card-subtitle">
                            Please share your honest feedback to help faculty improve curriculum delivery and pedagogy.
                        </p>
                    </div>
                    <a href="<%= request.getContextPath() %>/my-feedback" class="btn btn-secondary btn-sm">
                        View Past Feedback &rarr;
                    </a>
                </div>
            </div>

            <!-- Handled by FeedbackServlet with doPost() -->
            <form action="<%= request.getContextPath() %>/feedback" method="POST">
                
                <!-- Student Session Identifiers (Read-only / Pre-populated from JavaBean) -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 20px;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="studentName">Student Name</label>
                        <input type="text" id="studentName" name="studentName" class="form-control" 
                               value="<%= currentStudent.getName() %>" readonly title="Pre-filled from active student session">
                    </div>

                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="rollNo">Roll Number</label>
                        <input type="text" id="rollNo" name="rollNo" class="form-control" 
                               value="<%= currentStudent.getRollNo() %>" readonly title="Pre-filled from active student session">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="course">Registered Course / Department</label>
                    <input type="text" id="course" name="course" class="form-control" 
                           value="<%= currentStudent.getCourse() %>" readonly title="Enrolled Program">
                </div>

                <!-- Subject Selection / Input -->
                <div class="form-group">
                    <label class="form-label" for="subject">Course Subject / Module Name *</label>
                    <input type="text" id="subject" name="subject" class="form-control" 
                           placeholder="e.g. Web Technologies (Java & JSP), Data Structures, DBMS" 
                           value="<%= subject %>" required list="commonSubjects">
                    <datalist id="commonSubjects">
                        <option value="Web Technologies (Java + JSP + Servlets)">
                        <option value="Data Structures & Algorithms">
                        <option value="Database Management Systems (MySQL/JDBC)">
                        <option value="Object Oriented Programming in Java">
                        <option value="Computer Networks & Security">
                        <option value="Cloud Computing & DevOps">
                        <option value="Artificial Intelligence & Machine Learning">
                    </datalist>
                </div>

                <!-- Star Rating Field (1 - 5) -->
                <div class="form-group">
                    <label class="form-label">Performance Rating (1 - 5 Stars) *</label>
                    <div class="star-rating-container">
                        <div class="star-rating">
                            <input type="radio" id="star5" name="rating" value="5" <%= ratingVal == 5 ? "checked" : "" %> />
                            <label for="star5" title="5 Stars - Outstanding">&#9733;</label>

                            <input type="radio" id="star4" name="rating" value="4" <%= ratingVal == 4 ? "checked" : "" %> />
                            <label for="star4" title="4 Stars - Very Good">&#9733;</label>

                            <input type="radio" id="star3" name="rating" value="3" <%= ratingVal == 3 ? "checked" : "" %> />
                            <label for="star3" title="3 Stars - Satisfactory">&#9733;</label>

                            <input type="radio" id="star2" name="rating" value="2" <%= ratingVal == 2 ? "checked" : "" %> />
                            <label for="star2" title="2 Stars - Needs Improvement">&#9733;</label>

                            <input type="radio" id="star1" name="rating" value="1" <%= ratingVal == 1 ? "checked" : "" %> />
                            <label for="star1" title="1 Star - Poor">&#9733;</label>
                        </div>
                        <span class="rating-text" id="ratingLabel">5 Stars - Outstanding / Excellent</span>
                    </div>
                </div>

                <!-- Detailed Feedback Comments -->
                <div class="form-group">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                        <label class="form-label" for="comments" style="margin-bottom: 0;">Detailed Feedback & Constructive Comments *</label>
                        <span style="font-size: 0.8rem; color: var(--text-muted);">
                            <span id="charCount">0</span> characters
                        </span>
                    </div>
                    <textarea id="comments" name="comments" class="form-control" 
                              placeholder="Describe your learning experience, lab exercises, clarity of instructor concepts, and suggestions for improvement..." 
                              required minlength="10"><%= comments %></textarea>
                </div>

                <!-- Submission Controls -->
                <div style="display: flex; gap: 16px; margin-top: 24px; align-items: center;">
                    <button type="submit" class="btn btn-primary" style="flex: 1;">
                        Submit Feedback (doPost)
                    </button>
                    <button type="reset" class="btn btn-outline">
                        Reset Form
                    </button>
                </div>

            </form>
        </div>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
