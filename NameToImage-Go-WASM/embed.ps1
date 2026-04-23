$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$OriginalDir = Get-Location
Set-Location $ScriptDir
Write-Host "========================================"

$wasmPath = Join-Path $ScriptDir "www\main.wasm"
$wasmBytes = [System.IO.File]::ReadAllBytes($wasmPath)
$wasmBase64 = [Convert]::ToBase64String($wasmBytes)

$jsPath = Join-Path $ScriptDir "www\wasm_exec.js"
$jsContent = [System.IO.File]::ReadAllText($jsPath)
# 将 JS 转为 data URL
$jsDataUrl = "data:text/javascript;base64," + [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($jsContent))

$fontPath = Join-Path $ScriptDir "www\HYW.ttf"
$fontBytes = [System.IO.File]::ReadAllBytes($fontPath)
$fontBase64 = [Convert]::ToBase64String($fontBytes)

$OutputFile = Join-Path $ScriptDir "www\index_all.html"

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>NameToImage WASM</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Microsoft YaHei',sans-serif;background:#f5f6f7;padding:20px}
.container{max-width:600px;margin:0 auto}
h1{text-align:center;color:#323a45;margin-bottom:30px}
.card{background:#fff;border-radius:8px;padding:20px;box-shadow:0 2px 8px rgba(0,0,0,0.06);margin-bottom:20px}
label{display:block;margin-bottom:8px;color:#323a45;font-weight:500}
input[type="text"]{width:100%;padding:12px 16px;border:1px solid #dfe1e6;border-radius:6px;font-size:16px;margin-bottom:15px}
.checkbox-group{margin-bottom:15px}
.checkbox-group label{display:flex;align-items:center;font-weight:normal;cursor:pointer}
.checkbox-group input{margin-right:8px}
button{width:100%;padding:12px;background:#4c6ef5;color:#fff;border:none;border-radius:6px;font-size:16px;cursor:pointer}
button:disabled{background:#a2a2a2;cursor:not-allowed}
.result-item{margin-bottom:15px}
.result-item label{margin-bottom:5px;font-size:14px}
.result-item img{max-width:100%;border:1px solid #dfe1e6;border-radius:4px}
.error{color:#dc3545;padding:10px;background:#f8d7da;border-radius:4px}
</style>
</head>
<body>
<div class="container">
<h1>NameToImage WASM</h1>
<div class="card">
<label for="name">Account Name</label>
<input type="text" id="name" placeholder="Enter name">
<div class="checkbox-group">
<label><input type="checkbox" id="mark"> Generate Mark</label>
</div>
<button id="generate" disabled>Loading...</button>
</div>
<div class="card" id="result"></div>
</div>
<script src="__JS_DATA_URL__"></script>
<script>
var wasmBase64 = "__WASM_BASE64__";
var fontBase64 = "__FONT_BASE64__";

async function init() {
  try {
    var binary = Uint8Array.from(atob(wasmBase64), c => c.charCodeAt(0));
    var module = await WebAssembly.compile(binary);
    var instance = await WebAssembly.instantiate(module, go.importObject);
    go.run(instance);

    var fontBinary = Uint8Array.from(atob(fontBase64), c => c.charCodeAt(0));
    loadFont(fontBinary);

    var btn = document.getElementById('generate');
    btn.disabled = false;
    btn.textContent = 'Generate';
  } catch(e) {
    document.getElementById('result').innerHTML = '<div class="error">Init failed: ' + e.message + '</div>';
  }
}

document.getElementById('generate').onclick = function() {
  var name = document.getElementById('name').value.trim();
  var mark = document.getElementById('mark').checked;
  if (!name) {
    document.getElementById('result').innerHTML = '<div class="error">Please enter name</div>';
    return;
  }
  var btn = this;
  btn.disabled = true;
  btn.textContent = 'Generating...';
  try {
    var result = generateImage(name, mark);
    var html = '<div class="result-item"><label>Normal</label><img src="' + result.image + '"></div>';
    if (result.imageMark) {
      html += '<div class="result-item"><label>Mark</label><img src="' + result.imageMark + '"></div>';
    }
    document.getElementById('result').innerHTML = html;
  } catch(e) {
    document.getElementById('result').innerHTML = '<div class="error">Generate failed: ' + e.message + '</div>';
  }
  btn.disabled = false;
  btn.textContent = 'Generate';
};

init();
</script>
</body>
</html>
"@

$html = $html -replace '__WASM_BASE64__', $wasmBase64
$html = $html -replace '__JS_DATA_URL__', $jsDataUrl
$html = $html -replace '__FONT_BASE64__', $fontBase64

$Utf8BOM = New-Object System.Text.UTF8Encoding $true
$writer = [System.IO.StreamWriter]::new($OutputFile, $false, $Utf8BOM)
$writer.Write($html)
$writer.Close()

Write-Host "Generated: $OutputFile"
Set-Location $OriginalDir