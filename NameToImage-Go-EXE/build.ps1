param(
    [string]$Version = "1.0.0",
    [string]$GoPath = ""
)

# 获取脚本所在目录并切换到该目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

# 尝试将常见Go路径添加到PATH
$GoPathsToCheck = @(
    "D:\Program Files\Go\bin",
    "C:\Program Files\Go\bin",
    "C:\Go\bin",
    "$env:USERPROFILE\AppData\Local\Programs\Go\bin",
    "$env:LOCALAPPDATA\Programs\Go\bin"
)
foreach ($path in $GoPathsToCheck) {
    if (Test-Path $path) {
        $env:PATH = "$path;$env:PATH"
        break
    }
}

$OUTPUT_DIR = "publish"

# 尝试查找 Go
$GoExe = "go"
if ($GoPath) {
    $GoExe = $GoPath
} else {
    # 尝试常见安装路径
    $GoPaths = @(
        "C:\Program Files\Go\bin\go.exe",
        "C:\Go\bin\go.exe",
        "$env:USERPROFILE\AppData\Local\Programs\Go\bin\go.exe",
        "$env:LOCALAPPDATA\Programs\Go\bin\go.exe"
    )
    foreach ($path in $GoPaths) {
        if (Test-Path $path) {
            $GoExe = $path
            break
        }
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NameToImage Go EXE Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Go: $GoExe" -ForegroundColor Gray
Write-Host ""

# Clean old files
Write-Host "Cleaning old files..." -ForegroundColor Yellow
if (Test-Path $OUTPUT_DIR) {
    Remove-Item -Recurse -Force $OUTPUT_DIR
}
if (Test-Path "bin") {
    Remove-Item -Recurse -Force "bin"
}

# Create output directory
if (-not (Test-Path $OUTPUT_DIR)) {
    New-Item -ItemType Directory -Path $OUTPUT_DIR | Out-Null
}

# Download dependencies
Write-Host ""
Write-Host "Downloading dependencies..." -ForegroundColor Yellow
& $GoExe mod download

# Build for Windows
Write-Host ""
Write-Host "Building for Windows..." -ForegroundColor Yellow
& $GoExe build -ldflags "-s -w" -o "$OUTPUT_DIR/NameToImage.exe" main.go

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Build failed!" -ForegroundColor Red
    exit 1
}

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
$zipName = "NameToImage-v$Version"
if (Test-Path $zipName) { Remove-Item -Recurse -Force $zipName }
New-Item -ItemType Directory -Path $zipName | Out-Null
Copy-Item "$OUTPUT_DIR/*" -Destination $zipName -Recurse
Compress-Archive -Path "$zipName/*" -DestinationPath "$OUTPUT_DIR/$zipName.zip" -Force
Remove-Item -Recurse -Force $zipName

Write-Host ""
Write-Host "Package: $OUTPUT_DIR/$zipName.zip" -ForegroundColor Green