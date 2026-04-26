# NameToImage-Go-WASM

基于 Go 语言编译的 WebAssembly 版本，可在浏览器中直接运行。

## 使用方式

### 编译

```powershell
.\build.ps1
```

### 运行

启动 HTTP 服务器后访问 www 目录：

```powershell
cd www
python -m http.server 8080
```

访问 http://localhost:8080

## API

### loadFont(fontData)

加载 TTF 字体数据。

```javascript
const fontData = await fetch('HYW.ttf').then(r => r.arrayBuffer());
loadFont(new Uint8Array(fontData));
```

### generateImage(name, generateMark?)

生成图片。

```javascript
const result = generateImage('账号名', false);
// result.image - Base64 编码的普通版图片
// result.imageMark - Base64 编码的备注版图片（如果 generateMark 为 true）
```

## 返回值

```javascript
{
    image: "data:image/png;base64,...",      // 普通版图片
    imageMark: "data:image/png;base64,..."    // 备注版图片（可选）
}
```

## 图片规格

| 属性 | 普通版 | 备注版 |
|------|--------|--------|
| 文字颜色 | RGB(80,87,105) | RGB(100,119,171) |
| 背景颜色 | RGB(245,246,247) | RGB(245,246,247) |
| 高度 | 28px | 28px |
| 字体 | 华文行楷 24px | 华文行楷 24px |

## 项目结构

```
NameToImage-Go-WASM/
├── main.go
├── go.mod
├── build.ps1
├── clean.ps1
├── HYW.ttf
├── www/
│   ├── index.html
│   └── HYW.ttf
├── publish/
│   ├── main.wasm
│   └── HYW.ttf
├── README.md
└── SPEC.md
```