<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.feedback.model.Admin, com.feedback.model.Feedback, com.feedback.model.FeedbackStats, java.util.List, java.util.Map, java.text.SimpleDateFormat" %>
<%
    Admin currentAdmin = (Admin) session.getAttribute("currentAdmin");
    if (currentAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login?msg=please_login");
        return;
    }

    request.setAttribute("pageTitle", "Admin Dashboard");

    @SuppressWarnings("unchecked")
    List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedbackList");
    FeedbackStats stats = (FeedbackStats) request.getAttribute("stats");

    // If accessed directly without servlet routing, redirect to servlet
    if (feedbackList == null || stats == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }

    String selectedCourse = (String) request.getAttribute("selectedCourse");
    Integer selectedRating = (Integer) request.getAttribute("selectedRating");
    String searchQuery = (String) request.getAttribute("searchQuery");
    if (selectedCourse == null) selectedCourse = "";
    if (selectedRating == null) selectedRating = 0;
    if (searchQuery == null) searchQuery = "";

    String msg = request.getParameter("msg");
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="container">

        <!-- Top Header & Welcome Banner -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; flex-wrap: wrap; gap: 16px;">
            <div>
                <div style="display: inline-flex; align-items: center; gap: 6px; font-size: 0.8rem; font-weight: 700; color: #f472b6; margin-bottom: 6px;">
                    <span>🛡️</span> ADMINISTRATOR CONSOLE
                </div>
                <h1 style="font-size: 2.2rem; font-weight: 800; letter-spacing: -0.02em;">
                    Student Feedback <span class="gradient-text">Analytics</span>
                </h1>
                <p style="color: var(--text-secondary);">
                    Welcome back, <strong><%= currentAdmin.getFullName() %></strong>. Reviewing live student evaluations retrieved via JDBC PreparedStatement queries.
                </p>
            </div>
            <div style="display: flex; gap: 10px;">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-secondary btn-sm">
                    ↻ Refresh Data
                </a>
            </div>
        </div>

        <% if ("deleted".equals(msg)) { %>
            <div class="alert alert-success">
                <span>&#10003;</span> Feedback record was removed successfully.
            </div>
        <% } %>

        <!-- KPI Summary Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon indigo">
                    <svg width="28" height="28" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                </div>
                <div>
                    <div class="stat-value"><%= stats.getTotalFeedback() %></div>
                    <div class="stat-label">Total Submissions</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon amber">
                    <svg width="28" height="28" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                    </svg>
                </div>
                <div>
                    <div class="stat-value"><%= stats.getAverageRating() %> <span style="font-size: 1rem; color: var(--text-muted); font-weight: 500;">/ 5.0</span></div>
                    <div class="stat-label">Average Rating</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon emerald">
                    <svg width="28" height="28" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 10h4.764a2 2 0 011.789 2.894l-3.5 7A2 2 0 0115.263 21h-4.017c-.163 0-.326-.02-.485-.06L7 20m7-10V5a2 2 0 00-2-2h-.095c-.5 0-.905.405-.905.905 0 .714-.211 1.412-.608 2.006L7 11v9m7-10h-2m-7 0H4a2 2 0 00-2 2v7a2 2 0 002 2h3"></path>
                    </svg>
                </div>
                <div>
                    <div class="stat-value"><%= stats.getFiveStarCount() %></div>
                    <div class="stat-label">5-Star Outstanding</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon cyan">
                    <svg width="28" height="28" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"></path>
                    </svg>
                </div>
                <div>
                    <div class="stat-value"><%= stats.getFourStarCount() %></div>
                    <div class="stat-label">4-Star Positive</div>
                </div>
            </div>
        </div>

        <!-- Filter & Search Bar -->
        <div class="filter-bar">
            <form action="<%= request.getContextPath() %>/admin/dashboard" method="GET" style="display: contents;">
                <!-- Filter by Course -->
                <div style="min-width: 220px;">
                    <select name="course" class="form-control" onchange="this.form.submit()">
                        <option value="">All Academic Programs</option>
                        <option value="Computer Science & Engineering" <%= "Computer Science & Engineering".equals(selectedCourse) ? "selected" : "" %>>Computer Science & Engineering</option>
                        <option value="AI & Machine Learning" <%= "AI & Machine Learning".equals(selectedCourse) ? "selected" : "" %>>AI & Machine Learning</option>
                        <option value="Data Science" <%= "Data Science".equals(selectedCourse) ? "selected" : "" %>>Data Science</option>
                        <option value="Information Technology" <%= "Information Technology".equals(selectedCourse) ? "selected" : "" %>>Information Technology</option>
                        <option value="Electronics & Communication" <%= "Electronics & Communication".equals(selectedCourse) ? "selected" : "" %>>Electronics & Communication</option>
                    </select>
                </div>

                <!-- Filter by Rating -->
                <div style="min-width: 170px;">
                    <select name="rating" class="form-control" onchange="this.form.submit()">
                        <option value="0">All Ratings (1 - 5)</option>
                        <option value="5" <%= selectedRating == 5 ? "selected" : "" %>>5 Stars Only</option>
                        <option value="4" <%= selectedRating == 4 ? "selected" : "" %>>4 Stars Only</option>
                        <option value="3" <%= selectedRating == 3 ? "selected" : "" %>>3 Stars Only</option>
                        <option value="2" <%= selectedRating == 2 ? "selected" : "" %>>2 Stars Only</option>
                        <option value="1" <%= selectedRating == 1 ? "selected" : "" %>>1 Star Only</option>
                    </select>
                </div>

                <!-- Search Query -->
                <div class="search-box">
                    <input type="text" name="search" class="form-control" 
                           placeholder="Search student, roll no, subject, or keywords..." 
                           value="<%= searchQuery %>">
                </div>

                <button type="submit" class="btn btn-primary btn-sm">
                    Apply Filter
                </button>

                <% if (!selectedCourse.isEmpty() || selectedRating != 0 || !searchQuery.isEmpty()) { %>
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-outline btn-sm">
                        Clear Filters
                    </a>
                <% } %>
            </form>
        </div>

        <!-- Feedback Data Table -->
        <div class="card" style="padding: 0; overflow: hidden;">
            <div style="padding: 20px 24px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                <div style="font-weight: 700; font-size: 1.1rem; display: flex; align-items: center; gap: 8px;">
                    <span>Submitted Feedback Records</span>
                    <span style="font-size: 0.85rem; padding: 2px 8px; background: var(--primary-light); color: var(--primary); border-radius: 999px;">
                        <%= feedbackList.size() %> entries
                    </span>
                </div>
                <!-- Instant client-side quick filter -->
                <div>
                    <input type="text" id="liveTableSearch" class="form-control" style="padding: 6px 12px; font-size: 0.85rem; width: 220px;" placeholder="Quick filter rows...">
                </div>
            </div>

            <% if (feedbackList.isEmpty()) { %>
                <div style="text-align: center; padding: 60px 20px;">
                    <div style="font-size: 3rem; margin-bottom: 12px;">🔍</div>
                    <h3 style="font-size: 1.25rem; margin-bottom: 6px;">No Feedback Matches Found</h3>
                    <p style="color: var(--text-secondary); margin-bottom: 20px;">
                        Try resetting your search query or selected course/rating filter.
                    </p>
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-secondary btn-sm">
                        Reset All Filters
                    </a>
                </div>
            <% } else { %>
                <div class="table-responsive" style="border: none;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 50px;">#</th>
                                <th>Student Details</th>
                                <th>Course / Department</th>
                                <th>Subject</th>
                                <th>Rating</th>
                                <th style="min-width: 280px;">Student Comments</th>
                                <th>Submitted On</th>
                                <th style="text-align: center;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% int idx = 1; for (Feedback fb : feedbackList) { %>
                                <tr>
                                    <td style="color: var(--text-muted);"><%= idx++ %></td>
                                    <td>
                                        <div style="font-weight: 700; color: var(--text-primary);"><%= fb.getStudentName() %></div>
                                        <div style="font-size: 0.8rem; color: #a5b4fc; font-family: 'JetBrains Mono', monospace;"><%= fb.getRollNo() %></div>
                                    </td>
                                    <td>
                                        <span style="font-size: 0.875rem; color: var(--text-secondary);"><%= fb.getCourse() %></span>
                                    </td>
                                    <td>
                                        <strong style="color: var(--text-primary);"><%= fb.getSubject() %></strong>
                                    </td>
                                    <td>
                                        <div class="stars-display" style="font-size: 0.85rem; margin-bottom: 2px;">
                                            <% for (int s = 0; s < fb.getRating(); s++) { %>&#9733;<% } %>
                                            <% for (int s = fb.getRating(); s < 5; s++) { %><span style="color: #475569;">&#9733;</span><% } %>
                                        </div>
                                        <span class="badge badge-<%= fb.getRating() %>">
                                            <%= fb.getRating() %> / 5 Stars
                                        </span>
                                    </td>
                                    <td>
                                        <div style="font-size: 0.9rem; line-height: 1.5; color: #e2e8f0; background: rgba(15, 23, 42, 0.4); padding: 8px 12px; border-radius: 8px; border-left: 3px solid #6366f1;">
                                            "<%= fb.getComments() %>"
                                        </div>
                                    </td>
                                    <td style="color: var(--text-muted); font-size: 0.85rem; white-space: nowrap;">
                                        <%= fb.getSubmittedAt() != null ? sdf.format(fb.getSubmittedAt()) : "Recent" %>
                                    </td>
                                    <td style="text-align: center;">
                                        <form action="<%= request.getContextPath() %>/admin/delete-feedback" method="POST" onsubmit="return confirm('Are you sure you want to delete this feedback record?');" style="margin: 0;">
                                            <input type="hidden" name="id" value="<%= fb.getId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm" title="Delete record">
                                                Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
