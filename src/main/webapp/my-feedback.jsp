<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.feedback.model.Student, com.feedback.model.Feedback, java.util.List, java.text.SimpleDateFormat" %>
<%
    Student currentStudent = (Student) session.getAttribute("currentStudent");
    if (currentStudent == null) {
        response.sendRedirect(request.getContextPath() + "/student-login?msg=please_login");
        return;
    }

    request.setAttribute("pageTitle", "My Feedback History");
    @SuppressWarnings("unchecked")
    List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");

    // If accessed directly without servlet routing, redirect to servlet
    if (feedbacks == null) {
        response.sendRedirect(request.getContextPath() + "/my-feedback");
        return;
    }

    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="container">

        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; flex-wrap: wrap; gap: 16px;">
            <div>
                <h1 style="font-size: 2rem; font-weight: 800; letter-spacing: -0.02em;">My Feedback Submissions</h1>
                <p style="color: var(--text-secondary); margin-top: 4px;">
                    Review all feedback entries submitted by <%= currentStudent.getName() %> (<%= currentStudent.getRollNo() %>)
                </p>
            </div>
            <div>
                <a href="<%= request.getContextPath() %>/feedback" class="btn btn-primary">
                    + Submit New Feedback
                </a>
            </div>
        </div>

        <% if (feedbacks.isEmpty()) { %>
            <div class="card" style="text-align: center; padding: 48px 24px;">
                <div style="font-size: 3rem; margin-bottom: 16px;">📝</div>
                <h3 style="font-size: 1.3rem; margin-bottom: 8px;">No Feedback Submitted Yet</h3>
                <p style="color: var(--text-secondary); max-width: 450px; margin: 0 auto 24px;">
                    You haven't submitted any course evaluations yet. Share your thoughts to help improve academic delivery!
                </p>
                <a href="<%= request.getContextPath() %>/feedback" class="btn btn-primary">
                    Submit Your First Feedback &rarr;
                </a>
            </div>
        <% } else { %>

            <div class="card" style="padding: 0; overflow: hidden;">
                <div style="padding: 20px 24px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
                    <span style="font-weight: 700; font-size: 1rem;">
                        Total Submissions: <span style="color: var(--primary);"><%= feedbacks.size() %></span>
                    </span>
                    <span style="font-size: 0.85rem; color: var(--text-muted);">
                        Course: <%= currentStudent.getCourse() %>
                    </span>
                </div>

                <div class="table-responsive" style="border: none;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 60px;">#</th>
                                <th>Subject / Module</th>
                                <th>Rating</th>
                                <th>Comments</th>
                                <th>Submission Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% int index = 1; for (Feedback f : feedbacks) { %>
                                <tr>
                                    <td style="color: var(--text-muted);"><%= index++ %></td>
                                    <td>
                                        <strong style="color: var(--text-primary);"><%= f.getSubject() %></strong>
                                    </td>
                                    <td>
                                        <span class="badge badge-<%= f.getRating() %>">
                                            &#9733; <%= f.getRating() %> Stars
                                        </span>
                                    </td>
                                    <td style="max-width: 380px; color: #cbd5e1;">
                                        "<%= f.getComments() %>"
                                    </td>
                                    <td style="color: var(--text-muted); font-size: 0.85rem; white-space: nowrap;">
                                        <%= f.getSubmittedAt() != null ? sdf.format(f.getSubmittedAt()) : "Recent" %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        <% } %>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
