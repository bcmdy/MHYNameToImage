# 获取脚本所在目录并切换到该目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$OriginalDir = Get-Location
Set-Location $ScriptDir

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TextToImage Go WASM Clean Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Clean build output
Write-Host "Cleaning build output..." -ForegroundColor Yellow
if (Test-Path "publish") {
    Remove-Item -Recurse -Force "publish"
    Write-Host "  - Deleted publish/" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Clean completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# 恢复原来目录
Set-Location $OriginalDir