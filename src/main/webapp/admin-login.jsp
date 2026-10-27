<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Admin Login");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String username = (String) request.getAttribute("username");
    if (username == null) username = "";
    String msg = request.getParameter("msg");
%>
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 480px;">

        <% if ("please_login".equals(msg)) { %>
            <div class="alert alert-info">
                <span>&#9432;</span> Administrator login is required to access the faculty evaluation dashboard.
            </div>
        <% } %>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="alert alert-danger">
                <span>&#9888;</span> <%= errorMessage %>
            </div>
        <% } %>

        <div class="card">
            <div class="card-header">
                <div style="display: inline-flex; align-items: center; gap: 8px; padding: 4px 12px; background: rgba(236, 72, 153, 0.15); border: 1px solid rgba(236, 72, 153, 0.3); border-radius: 999px; font-size: 0.75rem; font-weight: 700; color: #f472b6; margin-bottom: 12px;">
                    FACULTY &amp; ADMIN PORTAL
                </div>
                <h2 class="card-title">Administrator Login</h2>
                <p class="card-subtitle">Authenticate to view, filter, and analyze all submitted student feedbacks.</p>
            </div>

            <form action="<%= request.getContextPath() %>/admin-login" method="POST">
                <div class="form-group">
                    <label class="form-label" for="username">Admin Username</label>
                    <input type="text" id="username" name="username" class="form-control" 
                           placeholder="e.g. admin" value="<%= username %>" required autofocus>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Enter admin password" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="background: linear-gradient(135deg, #7c3aed, #ec4899); box-shadow: 0 4px 14px rgba(236, 72, 153, 0.3); margin-top: 10px;">
                    Access Admin Dashboard
                </button>
            </form>

            <!-- Quick Fill Demo Credentials -->
            <div class="demo-box" style="margin-top: 24px;">
                <div class="demo-box-title">
                    <span>Admin Demo Credentials</span>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="fillAdminDemo('admin', 'admin123')">
                        Auto-Fill
                    </button>
                </div>
                <div>Username: <span class="demo-code">admin</span></div>
                <div style="margin-top: 4px;">Password: <span class="demo-code">admin123</span></div>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
