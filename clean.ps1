Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NameToImage Clean Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Clean build output
Write-Host "Cleaning build output..." -ForegroundColor Yellow
if (Test-Path "bin") {
    Remove-Item -Recurse -Force "bin"
    Write-Host "  - Deleted bin/" -ForegroundColor Green
}
if (Test-Path "obj") {
    Remove-Item -Recurse -Force "obj"
    Write-Host "  - Deleted obj/" -ForegroundColor Green
}
if (Test-Path "publish") {
    Remove-Item -Recurse -Force "publish"
    Write-Host "  - Deleted publish/" -ForegroundColor Green
}

# Clean runtime output
Write-Host ""
Write-Host "Cleaning runtime output..." -ForegroundColor Yellow
if (Test-Path "output") {
    Remove-Item -Recurse -Force "output"
    Write-Host "  - Deleted output/" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Clean completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green