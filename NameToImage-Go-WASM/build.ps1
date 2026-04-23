param(
    [string]$Version = "1.0.0"
)

# 获取脚本所在目录并切换到该目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

$OUTPUT_DIR = "publish"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NameToImage Go WASM Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Clean old files
Write-Host "Cleaning old files..." -ForegroundColor Yellow
if (Test-Path $OUTPUT_DIR) {
    Remove-Item -Recurse -Force $OUTPUT_DIR
}

# Create output directory
if (-not (Test-Path $OUTPUT_DIR)) {
    New-Item -ItemType Directory -Path $OUTPUT_DIR | Out-Null
}

# Build for WASM
Write-Host ""
Write-Host "Building for WebAssembly..." -ForegroundColor Yellow
$env:GOOS = "js"
$env:GOARCH = "wasm"
go build -ldflags "-s -w" -o "$OUTPUT_DIR/main.wasm" main.go

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Build failed!" -ForegroundColor Red
    $env:GOOS = ""
    $env:GOARCH = ""
    exit 1
}

# Reset GOOS/GOARCH
$env:GOOS = ""
$env:GOARCH = ""

# Copy font file
Copy-Item "HYW.ttf" -Destination $OUTPUT_DIR -Force

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "Output: ./$OUTPUT_DIR/" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host ""
Write-Host "Files in output directory:" -ForegroundColor Yellow
Get-ChildItem $OUTPUT_DIR | ForEach-Object { Write-Host "  $($_.Name)" }

# Package as zip
Write-Host ""
Write-Host "Packaging..." -ForegroundColor Yellow
$zipName = "NameToImage-WASM-v$Version"
if (Test-Path $zipName) { Remove-Item -Recurse -Force $zipName }
New-Item -ItemType Directory -Path $zipName | Out-Null
Copy-Item "$OUTPUT_DIR/*" -Destination $zipName -Recurse
Compress-Archive -Path "$zipName/*" -DestinationPath "$OUTPUT_DIR/$zipName.zip" -Force
Remove-Item -Recurse -Force $zipName

Write-Host ""
Write-Host "Package: $OUTPUT_DIR/$zipName.zip" -ForegroundColor Green