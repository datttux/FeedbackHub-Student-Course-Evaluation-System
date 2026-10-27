# ====================================================================
# FeedbackHub - Windows PowerShell Startup Script
# ====================================================================

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  Starting FeedbackHub: Student Feedback System" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Compiling and launching server on port 8080..." -ForegroundColor Yellow

mvn compile exec:java
