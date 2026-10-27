<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String footerContextPath = request.getContextPath();
%>
<footer class="footer">
    <div class="container footer-content">
        <div>
            <strong>Student Feedback System</strong> &bull; Mini Project (Java + JSP + JDBC + MVC)
            <div style="font-size: 0.8rem; margin-top: 4px; color: var(--text-muted);">
                Encapsulated with JavaBeans, Servlets (doPost/doGet), PreparedStatements, and Session Tracking.
            </div>
        </div>
        <div class="tech-pills">
            <span class="tech-pill">Java 17/25</span>
            <span class="tech-pill">Jakarta JSP</span>
            <span class="tech-pill">MySQL JDBC</span>
            <span class="tech-pill">MVC Pattern</span>
            <span class="tech-pill">HttpSession</span>
        </div>
    </div>
</footer>

<!-- Scripts -->
<script src="<%= footerContextPath %>/js/main.js"></script>
</body>
</html>
