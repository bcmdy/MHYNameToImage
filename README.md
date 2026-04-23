# NameToImage - 原神账号名称转图片工具

这是一个将游戏账号名称转换为 PNG 图片的工具，主要服务于原神玩家。

## 项目概述

本项目提供了多种不同技术栈的实现方式，用于生成带有账号名称的 PNG 图片。图片采用与游戏内相同的字体和配色确保生成的名片图片与游戏风格一致。

## 技术实现

### NameToImage-CSharp（命令行工具）

基于 .NET 8.0 开发的命令行工具，支持 Windows 平台。通过 SixLabors.ImageSharp 库处理图片生成，适合需要本地快速生成图片的用户。

技术栈：.NET 8.0 | C# | SixLabors.ImageSharp

### NameToImage-Go-EXE（命令行工具）

基于 Go 语言开发的命令行工具，可编译为原生可执行文件。适合跨平台使用或集成到其他 Go 项目中。

技术栈：Go | golang.org/x/image

### NameToImage-Go-WASM（WebAssembly）

基于 Go 语言编译的 WebAssembly 版本，可直接在浏览器中运行。适合集成到 Web 应用中。

技术栈：Go | WebAssembly

### NameToImage-HTML（在线工具）

纯前端实现的在线工具，无需后端服务，直接在浏览器中运行。使用 Canvas API 进行图片绘制，提供便捷的在线生成体验。

技术栈：HTML5 | JavaScript | Canvas API

## 图片规格

所有版本生成的图片遵循统一的规格标准：

| 属性 | 普通版 | 备注版 |
|------|--------|--------|
| 文字颜色 | RGB(80, 87, 105) | RGB(100, 119, 171) |
| 背景颜色 | RGB(245, 246, 247) | RGB(245, 246, 247) |
| 图片高度 | 28px | 28px |
| 图片宽度 | 自适应 | 自适应 |
| 字体 | 华文行楷 24px | 华文行楷 24px |

## 目录结构

```
MHYNameToImage/
├── NameToImage-CSharp/     # C# 版 (.NET 8.0)
├── NameToImage-Go-EXE/     # Go 版（命令行）
├── NameToImage-Go-WASM/     # Go 版（WebAssembly）
├── NameToImage-HTML/       # HTML 版
├── README.md
└── SPEC.md
```

## 编译脚本

### C# 版

```powershell
cd NameToImage-CSharp
dotnet publish NameToImage.csproj -c Release -p:PublishSingleFile=true -o ./publish
```

### Go EXE 版

```bat
cd NameToImage-Go-EXE
go build -o NameToImage.exe main.go
```

### Go WASM 版

```bat
set GOOS=js
set GOARCH=wasm
go build -o main.wasm main.go
```

### HTML 版

无需编译，直接在浏览器中打开 index.html 即可。

## 相关文档

各版本的详细需求文档和使用说明请参见对应子项目的 README.md 文件。