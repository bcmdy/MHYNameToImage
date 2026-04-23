@echo off
setlocal

echo ========================================
echo Clean Script
echo ========================================
echo.

:: Clean build outputs
if exist "publish" rmdir /s /q "publish"
if exist "bin" rmdir /s /q "bin"

echo Clean completed!