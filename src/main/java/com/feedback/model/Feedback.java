package com.feedback.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * JavaBean encapsulating Student Feedback form data and database records.
 * Fields: Student Name, Roll No, Course, Subject, Rating, Comments.
 */
public class Feedback implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int studentId;
    private String studentName;
    private String rollNo;
    private String course;
    private String subject;
    private int rating; // 1 to 5
    private String comments;
    private Timestamp submittedAt;

    // No-arg constructor
    public Feedback() {
    }

    // Form submission constructor
    public Feedback(int studentId, String studentName, String rollNo, String course, String subject, int rating, String comments) {
        this.studentId = studentId;
        this.studentName = studentName;
        this.rollNo = rollNo;
        this.course = course;
        this.subject = subject;
        this.rating = rating;
        this.comments = comments;
    }

    // Full constructor
    public Feedback(int id, int studentId, String studentName, String rollNo, String course, String subject, int rating, String comments, Timestamp submittedAt) {
        this.id = id;
        this.studentId = studentId;
        this.studentName = studentName;
        this.rollNo = rollNo;
        this.course = course;
        this.subject = subject;
        this.rating = rating;
        this.comments = comments;
        this.submittedAt = submittedAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getRollNo() {
        return rollNo;
    }

    public void setRollNo(String rollNo) {
        this.rollNo = rollNo;
    }

    public String getCourse() {
        return course;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "id=" + id +
                ", rollNo='" + rollNo + '\'' +
                ", studentName='" + studentName + '\'' +
                ", course='" + course + '\'' +
                ", subject='" + subject + '\'' +
                ", rating=" + rating +
                '}';
    }
}
