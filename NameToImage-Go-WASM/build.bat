@echo off
setlocal

echo ========================================
echo NameToImage Go WASM Build Script
echo ========================================
echo.

set OUTPUT_DIR=publish
set VERSION=1.0.0

:: Clean old files
echo Cleaning old files...
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"

:: Create output directory
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:: Build for WASM
echo.
echo Building for WebAssembly...
set GOOS=js
set GOARCH=wasm
go build -ldflags "-s -w" -o "%OUTPUT_DIR%\main.wasm" main.go
if errorlevel 1 (
    echo [ERROR] Build failed!
    exit /b 1
)

:: Copy font file
copy /Y "HYW.ttf" "%OUTPUT_DIR%\" >nul

echo.
echo ========================================
echo Build completed successfully!
echo Output: %OUTPUT_DIR%\
echo ========================================

:: List files
dir /B "%OUTPUT_DIR%"

:: Package as zip
echo.
echo Packaging...
powershell -Command "Compress-Archive -Path '%OUTPUT_DIR%\*' -DestinationPath '%OUTPUT_DIR%\NameToImage-WASM-v%VERSION%.zip' -Force"

echo.
echo Package: %OUTPUT_DIR%\NameToImage-WASM-v%VERSION%.zip

:: Reset GOOS/GOARCH
set GOOS=
set GOARCH=