package com.feedback.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * JavaBean representing a Student entity.
 * Follows standard JavaBean conventions with private properties,
 * no-arg constructor, getters and setters.
 */
public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String rollNo;
    private String name;
    private String email;
    private String course;
    private String password;
    private Timestamp createdAt;

    // No-arg constructor required for JavaBeans
    public Student() {
    }

    // Parameterized constructor for registration
    public Student(String rollNo, String name, String email, String course, String password) {
        this.rollNo = rollNo;
        this.name = name;
        this.email = email;
        this.course = course;
        this.password = password;
    }

    // Full constructor
    public Student(int id, String rollNo, String name, String email, String course, String password, Timestamp createdAt) {
        this.id = id;
        this.rollNo = rollNo;
        this.name = name;
        this.email = email;
        this.course = course;
        this.password = password;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRollNo() {
        return rollNo;
    }

    public void setRollNo(String rollNo) {
        this.rollNo = rollNo;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCourse() {
        return course;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", rollNo='" + rollNo + '\'' +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", course='" + course + '\'' +
                '}';
    }
}
