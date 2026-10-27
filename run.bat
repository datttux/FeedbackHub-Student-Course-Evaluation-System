@echo off
REM ====================================================================
REM FeedbackHub - Windows Batch Startup Script
REM ====================================================================

title FeedbackHub - Student Feedback System

echo ==================================================================
echo   Starting FeedbackHub (Windows)
echo ==================================================================
echo.
echo Compiling and starting embedded Tomcat server...
echo.

mvn compile exec:java

pause
