param(
    [string]$Version = "1.0.1"
)

$CONFIG = "Release"
$OUTPUT_DIR = "publish"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NameToImage Build Script v$Version" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Clean old files
Write-Host "Cleaning old files..." -ForegroundColor Yellow

# Kill process if running
$exePath = Join-Path $OUTPUT_DIR "NameToImage.exe"
if (Test-Path $exePath) {
    $process = Get-Process -Name "NameToImage" -ErrorAction SilentlyContinue
    if ($process) {
        Stop-Process -Name "NameToImage" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
    }
}

# Retry deletion
$retryCount = 3
for ($i = 0; $i -lt $retryCount; $i++) {
    try {
        if (Test-Path $OUTPUT_DIR) {
            Remove-Item -Recurse -Force $OUTPUT_DIR -ErrorAction Stop
        }
        if (Test-Path "bin") {
            Remove-Item -Recurse -Force "bin" -ErrorAction Stop
        }
        break
    } catch {
        if ($i -lt ($retryCount - 1)) {
            Start-Sleep -Milliseconds 500
        } else {
            Write-Host "[ERROR] Cannot clean output directory. Is the exe file still running?" -ForegroundColor Red
            exit 1
        }
    }
}

# Build project (single file, requires .NET 8 runtime)
Write-Host ""
Write-Host "Building project (single file)..." -ForegroundColor Yellow
dotnet publish NameToImage.csproj -c $CONFIG -p:PublishSingleFile=true -p:PublishTrimmed=true --self-contained false -p:DebugType=none -p:DebugSymbols=false -p:Version=$Version -p:AssemblyVersion=$Version -p:FileVersion=$Version -o ./$OUTPUT_DIR

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Build failed!" -ForegroundColor Red
    exit 1
}

# Delete bin directory
if (Test-Path "bin") {
    Remove-Item -Recurse -Force "bin"
    Write-Host "Deleted bin directory" -ForegroundColor Yellow
}

# Note: UPX compression broken .NET single-file apps, disabled
# $upxPath = Join-Path $PSScriptRoot "upx.exe"
# if (Test-Path $upxPath) { ... }

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "Output: ./$OUTPUT_DIR/" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host ""
Write-Host "Files in output directory:" -ForegroundColor Yellow
Get-ChildItem $OUTPUT_DIR | ForEach-Object { Write-Host "  $($_.Name)" }

# Copy documentation
Write-Host ""
Write-Host "Copying documentation..." -ForegroundColor Yellow
Copy-Item "README.md" -Destination $OUTPUT_DIR -ErrorAction SilentlyContinue
Copy-Item "SPEC.md" -Destination $OUTPUT_DIR -ErrorAction SilentlyContinue

# Package as zip
Write-Host ""
Write-Host "Packaging..." -ForegroundColor Yellow
$zipName = "NameToImage-v$Version"
if (Test-Path $zipName) { Remove-Item -Recurse -Force $zipName }
New-Item -ItemType Directory -Path $zipName | Out-Null
Copy-Item "$OUTPUT_DIR\*" -Destination $zipName -Recurse
Compress-Archive -Path "$zipName\*" -DestinationPath "$OUTPUT_DIR\$zipName.zip" -Force
Remove-Item -Recurse -Force $zipName

Write-Host ""
Write-Host "Package: $OUTPUT_DIR\$zipName.zip" -ForegroundColor Green