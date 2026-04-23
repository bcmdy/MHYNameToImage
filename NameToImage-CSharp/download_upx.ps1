$upxPath = Join-Path $PSScriptRoot "upx.exe"
if (-not (Test-Path $upxPath)) {
    Write-Host "Downloading UPX..."
    $urls = @(
        "https://gh.sevencdn.com/https://github.com/upx/upx/releases/download/v3.96/upx-3.96-win64.exe",
        "https://mirror.ghproxy.com/https://github.com/upx/upx/releases/download/v3.96/upx-3.96-win64.exe",
        "https://ghproxy.com/https://github.com/upx/upx/releases/download/v3.96/upx-3.96-win64.exe"
    )
    foreach ($url in $urls) {
        try {
            Invoke-WebRequest -Uri $url -OutFile $upxPath -UseBasicParsing -TimeoutSec 30 -ErrorAction Stop
            Write-Host "Downloaded UPX successfully"
            break
        } catch {
            continue
        }
    }
}
Write-Host "Done"