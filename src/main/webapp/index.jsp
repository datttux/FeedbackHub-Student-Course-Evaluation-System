<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Home");
    String msg = request.getParameter("msg");
%>
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="container">

        <% if ("logged_out".equals(msg)) { %>
            <div class="alert alert-info">
                <span>&#10003;</span> You have been securely logged out. Your session has ended.
            </div>
        <% } %>

        <!-- Hero Section -->
        <section class="hero">
            <div class="hero-pill">
                <span>✨</span> Unit II Mini Project Architecture
            </div>
            <h1 class="hero-title">
                Student <span class="gradient-text">Feedback System</span>
            </h1>
            <p class="hero-desc">
                An enterprise-grade Java web application engineered with MVC Architecture, 
                Jakarta Servlets, JSP Views, JDBC PreparedStatement queries, and secure HttpSession tracking.
            </p>

            <div style="display: flex; gap: 16px; justify-content: center; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/student-login" class="btn btn-primary">
                    Student Portal &rarr;
                </a>
                <a href="<%= request.getContextPath() %>/admin-login" class="btn btn-secondary">
                    Admin Dashboard &rarr;
                </a>
            </div>
        </section>

        <!-- Portals Grid -->
        <div class="portal-grid">
            <!-- Student Portal Card -->
            <div class="portal-card">
                <div class="portal-icon student">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                    </svg>
                </div>
                <h3>Student Portal</h3>
                <p>
                    Log in with your college credentials to submit course evaluations, evaluate subjects, and track your past submissions.
                </p>
                <div style="display: flex; gap: 12px;">
                    <a href="<%= request.getContextPath() %>/student-login" class="btn btn-primary btn-sm">Student Login</a>
                    <a href="<%= request.getContextPath() %>/student-register" class="btn btn-outline btn-sm">Register Account</a>
                </div>

                <div class="demo-box">
                    <div class="demo-box-title">
                        <span>Demo Student Credentials</span>
                    </div>
                    <div>Roll No: <span class="demo-code">CS202601</span></div>
                    <div style="margin-top: 4px;">Password: <span class="demo-code">student123</span></div>
                </div>
            </div>

            <!-- Admin Portal Card -->
            <div class="portal-card">
                <div class="portal-icon admin">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                    </svg>
                </div>
                <h3>Administrator Module</h3>
                <p>
                    Faculty and administration dashboard to review all submitted feedback, filter by course and ratings, and view analytical metrics.
                </p>
                <div>
                    <a href="<%= request.getContextPath() %>/admin-login" class="btn btn-secondary btn-sm">Admin Login &rarr;</a>
                </div>

                <div class="demo-box">
                    <div class="demo-box-title">
                        <span>Demo Admin Credentials</span>
                    </div>
                    <div>Username: <span class="demo-code">admin</span></div>
                    <div style="margin-top: 4px;">Password: <span class="demo-code">admin123</span></div>
                </div>
            </div>
        </div>

        <!-- Architecture Feature Breakdown -->
        <div style="margin-top: 60px;">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">MVC Architecture Implementation</h2>
                    <p class="card-subtitle">Complete separation of concerns as mandated by Unit II project requirements:</p>
                </div>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px;">
                    <div style="padding: 20px; background: rgba(15, 23, 42, 0.5); border-radius: 12px; border: 1px solid var(--border-color);">
                        <h4 style="color: #818cf8; margin-bottom: 8px;">1. Model (JavaBeans & DAO)</h4>
                        <p style="font-size: 0.875rem; color: var(--text-secondary);">
                            Encapsulates student and feedback attributes into serializable JavaBeans (<code>Student.java</code>, <code>Feedback.java</code>). 
                            JDBC DAOs manage prepared statements and SQL transactions.
                        </p>
                    </div>
                    <div style="padding: 20px; background: rgba(15, 23, 42, 0.5); border-radius: 12px; border: 1px solid var(--border-color);">
                        <h4 style="color: #38bdf8; margin-bottom: 8px;">2. View (Dynamic JSP)</h4>
                        <p style="font-size: 0.875rem; color: var(--text-secondary);">
                            Clean JSP pages render interactive forms, dashboards, and feedback summaries. Separated from SQL and business logic.
                        </p>
                    </div>
                    <div style="padding: 20px; background: rgba(15, 23, 42, 0.5); border-radius: 12px; border: 1px solid var(--border-color);">
                        <h4 style="color: #34d399; margin-bottom: 8px;">3. Controller (Jakarta Servlets)</h4>
                        <p style="font-size: 0.875rem; color: var(--text-secondary);">
                            Processes incoming HTTP requests using <code>doPost()</code> and <code>doGet()</code>, validates user input, manages <code>HttpSession</code> state, and routes responses.
                        </p>
                    </div>
                </div>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
