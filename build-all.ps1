param(
    [string]$Version = "1.0.0"
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$OriginalDir = Get-Location
Set-Location $ScriptDir

$OUTPUT_DIR = "publish"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TextToImage Build All Script v$Version" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create output directory
if (Test-Path $OUTPUT_DIR) {
    Remove-Item -Recurse -Force $OUTPUT_DIR
}
New-Item -ItemType Directory -Path $OUTPUT_DIR | Out-Null

# Build TextToImage-CSharp
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "[1/5] Building TextToImage-CSharp..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Push-Location TextToImage-CSharp
try {
    if (Test-Path "publish") { Remove-Item -Recurse -Force "publish" }
    dotnet publish TextToImage.csproj -c Release -p:SelfContained=false -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:DebugType=none -p:DebugSymbols=false -p:Version=$Version -p:AssemblyVersion=$Version -p:FileVersion=$Version -o publish
    if ($LASTEXITCODE -ne 0) { throw "Build failed" }
} finally {
    Pop-Location
}
Write-Host "Done" -ForegroundColor Green

# Build TextToImage-CSharp-UI
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "[2/5] Building TextToImage-CSharp-UI..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Push-Location TextToImage-CSharp-UI
try {
    if (Test-Path "publish") { Remove-Item -Recurse -Force "publish" }
    dotnet publish TextToImage-CSharp-UI.csproj -c Release -p:SelfContained=false -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:DebugType=none -p:DebugSymbols=false -p:Version=$Version -p:AssemblyVersion=$Version -p:FileVersion=$Version -o publish
    if ($LASTEXITCODE -ne 0) { throw "Build failed" }
} finally {
    Pop-Location
}
Write-Host "Done" -ForegroundColor Green

# Build TextToImage-Go-EXE
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "[3/5] Building TextToImage-Go-EXE..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
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
Push-Location TextToImage-Go-EXE
try {
    if (Test-Path "publish") { Remove-Item -Recurse -Force "publish" }
    New-Item -ItemType Directory -Path publish | Out-Null
    go build -ldflags "-s -w" -trimpath -o publish/TextToImage.exe .
    if ($LASTEXITCODE -ne 0) { throw "Build failed" }
    Copy-Item "HYW.ttf" -Destination publish -Force
} finally {
    Pop-Location
}
Write-Host "Done" -ForegroundColor Green

# Build TextToImage-Go-WASM
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "[4/5] Building TextToImage-Go-WASM..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Push-Location TextToImage-Go-WASM
try {
    if (Test-Path "publish") { Remove-Item -Recurse -Force "publish" }
    New-Item -ItemType Directory -Path publish | Out-Null
    $env:GOOS = "js"
    $env:GOARCH = "wasm"
    go build -ldflags "-s -w" -trimpath -o publish/main.wasm .
    if ($LASTEXITCODE -ne 0) { throw "Build failed" }
    $env:GOOS = ""
    $env:GOARCH = ""
    Copy-Item "HYW.ttf" -Destination publish -Force
    Copy-Item "publish/main.wasm" -Destination www -Force
    Copy-Item "HYW.ttf" -Destination www -Force
} finally {
    Pop-Location
}
Write-Host "Done" -ForegroundColor Green

# Copy HTML files
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "[5/5] Copying TextToImage-HTML..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
$htmlDir = "TextToImage-HTML"
$htmlDest = Join-Path $OUTPUT_DIR "TextToImage-HTML"
if (-not (Test-Path $htmlDest)) {
    New-Item -ItemType Directory -Path $htmlDest | Out-Null
}
Copy-Item "$htmlDir\index_*.html" -Destination $htmlDest
Write-Host "Done" -ForegroundColor Green

# Copy all publish folders to root
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Copying to output directory..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow

# Copy TextToImage-CSharp
$csdir = Join-Path $OUTPUT_DIR "TextToImage-CSharp"
if (-not (Test-Path $csdir)) { New-Item -ItemType Directory -Path $csdir | Out-Null }
Copy-Item "TextToImage-CSharp\publish\*" -Destination $csdir -Recurse -Force
Copy-Item "TextToImage-CSharp\README.md" -Destination $csdir -Force
Write-Host "  - TextToImage-CSharp copied" -ForegroundColor Green

# Copy TextToImage-CSharp-UI
$csuidir = Join-Path $OUTPUT_DIR "TextToImage-CSharp-UI"
if (-not (Test-Path $csuidir)) { New-Item -ItemType Directory -Path $csuidir | Out-Null }
Copy-Item "TextToImage-CSharp-UI\publish\*" -Destination $csuidir -Recurse -Force
Copy-Item "TextToImage-CSharp-UI\README.md" -Destination $csuidir -Force
Copy-Item "TextToImage-CSharp-UI\SPEC.md" -Destination $csuidir -Force
Write-Host "  - TextToImage-CSharp-UI copied" -ForegroundColor Green

# Copy TextToImage-Go-EXE
$goexedir = Join-Path $OUTPUT_DIR "TextToImage-Go-EXE"
if (-not (Test-Path $goexedir)) { New-Item -ItemType Directory -Path $goexedir | Out-Null }
Copy-Item "TextToImage-Go-EXE\publish\*" -Destination $goexedir -Recurse -Force
Copy-Item "TextToImage-Go-EXE\README.md" -Destination $goexedir -Force
Write-Host "  - TextToImage-Go-EXE copied" -ForegroundColor Green

# Copy TextToImage-Go-WASM (only HTML, wasm and font are loaded from CDN)
$wasmdir = Join-Path $OUTPUT_DIR "TextToImage-Go-WASM"
if (-not (Test-Path $wasmdir)) { New-Item -ItemType Directory -Path $wasmdir | Out-Null }
Get-ChildItem "TextToImage-Go-WASM\www" -Filter "*.html" | Copy-Item -Destination $wasmdir -Force
Copy-Item "TextToImage-Go-WASM\README.md" -Destination $wasmdir -Force
Write-Host "  - TextToImage-Go-WASM copied" -ForegroundColor Green

# Copy TextToImage-HTML
$htmlDest = Join-Path $OUTPUT_DIR "TextToImage-HTML"
Copy-Item "TextToImage-HTML\README.md" -Destination $htmlDest -Force
Write-Host "  - TextToImage-HTML copied" -ForegroundColor Green

# Copy root README and SPEC to output
Copy-Item "README.md" -Destination $OUTPUT_DIR -Force
Copy-Item "SPEC.md" -Destination $OUTPUT_DIR -Force
Write-Host "  - Root README and SPEC copied" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "Output: ./$OUTPUT_DIR/" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host ""
Write-Host "Files in output directory:" -ForegroundColor Yellow
Get-ChildItem $OUTPUT_DIR | ForEach-Object {
    Write-Host "  $($_.Name)" -ForegroundColor White
    if ($_.PSIsContainer) {
        Get-ChildItem $_.FullName | ForEach-Object {
            Write-Host "    - $($_.Name)" -ForegroundColor Gray
        }
    }
}

# Restore original directory
Set-Location $OriginalDir