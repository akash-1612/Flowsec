@echo off
echo ========================================
echo   Flowsec Quick Setup for Windows
echo ========================================
echo.
echo This script will help you set up Flowsec.
echo.
echo IMPORTANT: Make sure you have:
echo   1. Forked the repository to your GitHub account
echo   2. Created a Supabase project
echo   3. Have your Supabase URL and anon key ready
echo.
pause
echo.
echo Running PowerShell setup script...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
pause
