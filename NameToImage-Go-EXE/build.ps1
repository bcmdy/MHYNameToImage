param(
    [string]$Version = "1.0.0"
)

# 获取脚本所在目录并切换到该目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$OriginalDir = Get-Location
Set-Location $ScriptDir

# 添加Go到PATH
$GoPathsToCheck = @(
    "D:\Program Files\Go\bin",
    "C:\Program Files\Go\bin",
    "C:\Go\bin"
)
foreach ($path in $GoPathsToCheck) {
    if (Test-Path $path) {
        $env:PATH = "$path;$env:PATH"
        break
    }
}

$OUTPUT_DIR = "publish"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NameToImage Go EXE Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Clean old files
Write-Host "Cleaning old files..." -ForegroundColor Yellow
if (Test-Path $OUTPUT_DIR) {
    Remove-Item -Recurse -Force $OUTPUT_DIR
}
Remove-Item -Recurse -Force "bin" -ErrorAction SilentlyContinue
Remove-Item -Force "go.sum" -ErrorAction SilentlyContinue

# Create output directory
if (-not (Test-Path $OUTPUT_DIR)) {
    New-Item -ItemType Directory -Path $OUTPUT_DIR | Out-Null
}

# Initialize go.mod if needed
if (-not (Test-Path "go.mod")) {
    Write-Host "Initializing go.mod..." -ForegroundColor Yellow
    go mod init name-to-image
}

# Download and tidy dependencies
Write-Host ""
Write-Host "Downloading and tidying dependencies..." -ForegroundColor Yellow
go get golang.org/x/image@v0.18.0
go mod tidy

# Build for Windows
Write-Host ""
Write-Host "Building for Windows..." -ForegroundColor Yellow
go build -ldflags "-s -w -buildvcs=false" -trimpath -o "$OUTPUT_DIR/NameToImage.exe" .

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

# 恢复原来目录
Set-Location $OriginalDir