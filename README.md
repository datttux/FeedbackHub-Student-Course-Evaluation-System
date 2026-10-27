# Student Feedback System (Java + JSP + JDBC + MVC)

An academic mini-project designed and implemented following the **Model-View-Controller (MVC)** architectural pattern, **Jakarta Servlets**, **JSP Presentation Views**, **JDBC PreparedStatements**, and **HttpSession** session tracking.

---

## 📌 Project Overview

- **Title**: Student Feedback System
- **Technologies**: Java 17+, Jakarta Servlets 6.0, JSP, JDBC, MySQL 8.x (with automated fallback), CSS3 Glassmorphism, Embedded Apache Tomcat.
- **Objective**: Develop a secure, modular web application that allows authenticated students to submit structured course feedback and enables administrators/faculty to analyze submitted responses with aggregate metrics and filters.

---

## 🏛️ MVC Architecture Implementation

The application strictly separates presentation, business/request dispatching logic, and data access into distinct layers:

```
                      +---------------------------------------+
                      |         Browser (HTTP Client)         |
                      +---------------------------------------+
                             |                         ^
                  HTTP POST  |                         | HTML / JSP
                  /feedback  v                         | Rendering
             +---------------------------------------------------+
             |                CONTROLLER (Servlets)              |
             |  • StudentLoginServlet    • FeedbackServlet        |
             |  • StudentRegisterServlet  • AdminDashboardServlet |
             |  • AdminLoginServlet      • LogoutServlet         |
             +---------------------------------------------------+
                       |                               |
             Populates | Invokes DAO                   | Forwards Model
             JavaBeans | Operations                    | to View
                       v                               v
             +--------------------+          +--------------------+
             |   MODEL (Beans)    |          |   VIEW (JSP Pages) |
             |  • Student.java    |          |  • index.jsp       |
             |  • Feedback.java   |          |  • feedback-form   |
             |  • Admin.java      |          |  • my-feedback.jsp |
             |  • FeedbackStats   |          |  • admin-dashboard |
             +--------------------+          +--------------------+
                       ^
                       | JDBC PreparedStatement
                       v
             +--------------------+
             |    DAO LAYER       |
             |  • StudentDAO.java |
             |  • FeedbackDAO     |
             |  • AdminDAO.java   |
             |  • DBConnection    |
             +--------------------+
                       |
                       v
             +--------------------+
             |   MySQL Database   |
             | (student_feedback) |
             +--------------------+
```

### 1. Model (Data & JavaBeans)
Encapsulates form inputs and database records into reusable, serializable Java objects following JavaBean specifications (private attributes, no-argument constructor, public getters/setters):
- [`Student.java`](file:///Users/dattathreyachari/Desktop/MERN/src/main/java/com/feedback/model/Student.java): Encapsulates `id`, `rollNo`, `name`, `email`, `course`, `password`, `createdAt`.
- [`Feedback.java`](file:///Users/dattathreyachari/Desktop/MERN/src/main/java/com/feedback/model/Feedback.java): Encapsulates `studentId`, `studentName`, `rollNo`, `course`, `subject`, `rating` (1–5), `comments`, `submittedAt`.
- [`Admin.java`](file:///Users/dattathreyachari/Desktop/MERN/src/main/java/com/feedback/model/Admin.java): Encapsulates administrator credentials and profile.
- [`FeedbackStats.java`](file:///Users/dattathreyachari/Desktop/MERN/src/main/java/com/feedback/model/FeedbackStats.java): Encapsulates aggregate dashboard analytics (total count, average rating, star distributions, course breakdown).

### 2. View (Presentation Layer)
Dynamic JSP templates styled with modern Glassmorphic CSS:
- [`index.jsp`](file:///Users/dattathreyachari/Desktop/MERN/src/main/webapp/index.jsp): Hero landing page with quick portal links and architectural breakdown.
- [`student-login.jsp`](file:///Users/dattathreyachari/Desktop/MERN/src/main/webapp/student-login.jsp): Student login with 1-click demo credential filler.
- [`student-register.jsp`](file:///Users/dattathreyachari/Desktop/MERN/src/main/webapp/student-register.jsp): Account creation form for new students.
- [`feedback-form.jsp`](file:///Users/dattathreyachari/Desktop/MERN/src/main/webapp/feedback-form.jsp): Core feedback form containing required fields: **Student Name**, **Roll No**, **Course**, **Subject**, **Rating (1–5 Stars)**, and **Feedback Comments**.
- [`feedback-success.jsp`](file:///Users/dattathreyachari/Desktop/MERN/src/main/webapp/feedback-success.jsp): Submission confirmation and receipt card.
- [`my-feedback.jsp`](file:///Users/dattathreyachari/Desktop/MERN/src/main/webapp/my-feedback.jsp): Table of all feedback submitted by the logged-in student.
- [`admin-login.jsp`](file:///Users/dattathreyachari/Desktop/MERN/src/main/webapp/admin-login.jsp): Admin authentication screen.
- [`admin-dashboard.jsp`](file:///Users/dattathreyachari/Desktop/MERN/src/main/webapp/admin-dashboard.jsp): Full administrative console with real-time KPI cards, course dropdown filter, star rating filter, keyword search, and deletion action.

### 3. Controller (Jakarta Servlets)
Manages request routing, validation, business transactions, and session lifecycle:
- [`FeedbackServlet.java`](file:///Users/dattathreyachari/Desktop/MERN/src/main/java/com/feedback/controller/FeedbackServlet.java):
  - `doGet()`: Enforces student session and forwards to `feedback-form.jsp`.
  - `doPost()`: Extracts parameters, validates inputs, instantiates `Feedback` JavaBean, invokes `FeedbackDAO.insertFeedback(feedback)`, and forwards to `feedback-success.jsp`.
- [`StudentLoginServlet.java`](file:///Users/dattathreyachari/Desktop/MERN/src/main/java/com/feedback/controller/StudentLoginServlet.java): Authenticates student via `StudentDAO`, creates `HttpSession`, stores `currentStudent` bean.
- [`AdminDashboardServlet.java`](file:///Users/dattathreyachari/Desktop/MERN/src/main/java/com/feedback/controller/AdminDashboardServlet.java): Protects admin routes, queries data using `PreparedStatement` with course/rating criteria, passes model to `admin-dashboard.jsp`.
- [`LogoutServlet.java`](file:///Users/dattathreyachari/Desktop/MERN/src/main/java/com/feedback/controller/LogoutServlet.java): Calls `session.invalidate()` and redirects to home.

---

## 🗄️ Database Design & JDBC

The system utilizes MySQL with normalized tables and foreign key constraints:

### 1. Table Schema (`database_setup.sql`)

```sql
CREATE DATABASE IF NOT EXISTS student_feedback_db;
USE student_feedback_db;

-- Students Table
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_no VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    course VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Feedback Table
CREATE TABLE IF NOT EXISTS feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    roll_no VARCHAR(50) NOT NULL,
    course VARCHAR(100) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comments TEXT NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_feedback_student FOREIGN KEY (student_id) 
        REFERENCES students(id) ON DELETE CASCADE
);

-- Admin Table
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) DEFAULT 'ADMIN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. PreparedStatement Examples Used in DAO

#### Insert Query (`FeedbackDAO.java`):
```java
String query = "INSERT INTO feedback (student_id, student_name, roll_no, course, subject, rating, comments) " +
               "VALUES (?, ?, ?, ?, ?, ?, ?)";
PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
pstmt.setInt(1, feedback.getStudentId());
pstmt.setString(2, feedback.getStudentName());
pstmt.setString(3, feedback.getRollNo());
pstmt.setString(4, feedback.getCourse());
pstmt.setString(5, feedback.getSubject());
pstmt.setInt(6, feedback.getRating());
pstmt.setString(7, feedback.getComments());
pstmt.executeUpdate();
```

#### Filtered Select Query with Dynamic Binding (`FeedbackDAO.java`):
```java
StringBuilder sql = new StringBuilder("SELECT * FROM feedback WHERE 1=1");
if (courseFilter != null && !courseFilter.isEmpty()) {
    sql.append(" AND course = ?");
    params.add(courseFilter);
}
if (ratingFilter > 0) {
    sql.append(" AND rating = ?");
    params.add(ratingFilter);
}
PreparedStatement pstmt = conn.prepareStatement(sql.toString());
for (int i = 0; i < params.size(); i++) {
    pstmt.setObject(i + 1, params.get(i));
}
ResultSet rs = pstmt.executeQuery();
```

---

## 🔐 Session Management

- **Login**: When credentials match, `HttpSession session = request.getSession(true);` is instantiated.
- **Attributes Stored**:
  - `session.setAttribute("currentStudent", student);`
  - `session.setAttribute("userRole", "STUDENT");`
- **Timeout**: Set to 30 minutes in `web.xml` and programmatic inactivity checks.
- **Logout**: Handled by `LogoutServlet`:
  ```java
  HttpSession session = request.getSession(false);
  if (session != null) {
      session.invalidate();
  }
  response.sendRedirect(request.getContextPath() + "/index.jsp?msg=logged_out");
  ```

---

## 🚀 How to Run the Application

### Option A: Using the Control Script (Recommended)
```bash
# Start the server (runs on port 8080)
./run.sh start

# Check status
./run.sh status

# Stop server
./run.sh stop
```

### Option B: Using Maven Directly
```bash
# Compile and start embedded Tomcat runner
mvn compile exec:java
```

Once started, access the application in your browser:
- **Home**: `http://localhost:8080/`
- **Student Login**: `http://localhost:8080/student-login`
- **Admin Portal**: `http://localhost:8080/admin-login`

---

## 🔑 Demo Credentials

| Role | Username / Roll No | Password | Notes |
|---|---|---|---|
| **Student 1** | `CS202601` | `student123` | Aarav Sharma (CS Department) |
| **Student 2** | `CS202602` | `student123` | Diya Patel (CS Department) |
| **Student 3** | `AI202615` | `student123` | Rohan Gupta (AI & ML) |
| **Admin** | `admin` | `admin123` | Prof. Robert Vance (Faculty Admin) |

*(Quick Auto-Fill buttons are also provided on both login screens for 1-click demonstration!)*
