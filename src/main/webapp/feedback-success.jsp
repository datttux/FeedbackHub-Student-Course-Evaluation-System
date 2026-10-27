<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.feedback.model.Feedback" %>
<%
    Feedback fb = (Feedback) request.getAttribute("submittedFeedback");
    request.setAttribute("pageTitle", "Feedback Submitted Successfully");
%>
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 640px;">

        <div class="card" style="text-align: center; padding: 48px 36px;">
            <!-- Success Icon -->
            <div style="width: 72px; height: 72px; border-radius: 50%; background: rgba(16, 185, 129, 0.15); border: 2px solid #10b981; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 24px; color: #10b981;">
                <svg width="36" height="36" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"></path>
                </svg>
            </div>

            <h2 style="font-size: 2rem; font-weight: 800; margin-bottom: 8px;">Feedback Submitted!</h2>
            <p style="color: var(--text-secondary); margin-bottom: 28px;">
                Thank you for contributing. Your response has been securely saved to the database using JDBC PreparedStatement.
            </p>

            <% if (fb != null) { %>
                <div style="text-align: left; background: rgba(15, 23, 42, 0.7); border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; margin-bottom: 28px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; border-bottom: 1px solid var(--border-color); padding-bottom: 10px;">
                        <div>
                            <span style="font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted);">Subject</span>
                            <div style="font-size: 1.1rem; font-weight: 700; color: var(--text-primary);"><%= fb.getSubject() %></div>
                        </div>
                        <div>
                            <span class="badge badge-<%= fb.getRating() %>">
                                &#9733; <%= fb.getRating() %> / 5 Stars
                            </span>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; font-size: 0.9rem; margin-bottom: 16px;">
                        <div>
                            <span style="color: var(--text-muted);">Student:</span> 
                            <strong style="color: var(--text-primary);"><%= fb.getStudentName() %></strong>
                        </div>
                        <div>
                            <span style="color: var(--text-muted);">Roll No:</span> 
                            <strong style="color: var(--text-primary);"><%= fb.getRollNo() %></strong>
                        </div>
                        <div style="grid-column: span 2;">
                            <span style="color: var(--text-muted);">Course:</span> 
                            <span style="color: var(--text-primary);"><%= fb.getCourse() %></span>
                        </div>
                    </div>

                    <div>
                        <span style="font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted);">Feedback Comments</span>
                        <div style="margin-top: 6px; font-size: 0.95rem; color: #cbd5e1; font-style: italic; background: rgba(0,0,0,0.25); padding: 12px; border-radius: 8px;">
                            "<%= fb.getComments() %>"
                        </div>
                    </div>
                </div>
            <% } %>

            <div style="display: flex; gap: 14px; justify-content: center; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/feedback" class="btn btn-primary">
                    Submit Another Feedback
                </a>
                <a href="<%= request.getContextPath() %>/my-feedback" class="btn btn-secondary">
                    View My Feedback History
                </a>
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-outline">
                    Return Home
                </a>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
