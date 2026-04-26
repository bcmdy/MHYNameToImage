# TextToImage - 文字转图片工具

这是一个将文字转换为 PNG 图片的工具，支持自定义颜色和背景。

## 项目概述

本项目提供了多种不同技术栈的实现方式，用于生成带有文字的 PNG 图片。

## 技术实现

### TextToImage-CSharp（命令行工具）

基于 .NET 8.0 开发的命令行工具，支持 Windows 平台。通过 SixLabors.ImageSharp 库处理图片生成，适合需要本地快速生成图片的用户。

技术栈：.NET 8.0 | C# | SixLabors.ImageSharp

### TextToImage-CSharp-UI（图形界面工具）

基于 WinForms 的桌面应用，提供图形界面，支持批量处理和颜色自定义。

技术栈：.NET 8.0 | C# | WinForms | SixLabors.ImageSharp

### TextToImage-Go-EXE（命令行工具）

基于 Go 语言开发的命令行工具，可编译为原生可执行文件。适合跨平台使用或集成到其他 Go 项目中。

技术栈：Go | golang.org/x/image

### TextToImage-Go-WASM（WebAssembly）

基于 Go 语言编译的 WebAssembly 版本，可直接在浏览器中运行。适合集成到 Web 应用中。

技术栈：Go | WebAssembly

### TextToImage-HTML（在线工具）

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

## 版本差异

### TextToImage-CSharp

- 支持交互模式和命令行模式
- 命令行参数：`TextToImage.exe 文字 [-m]`
- 输出文件到可执行文件同目录

### TextToImage-CSharp-UI

- 图形界面，操作便捷
- 支持单文字输入和批量处理
- 支持 CSV/TXT 导入
- 自定义普通版和备注版文字颜色
- 自定义背景颜色
- 图片预览和日志记录
- 固定导出到程序目录下的 output 文件夹

### TextToImage-Go-EXE

- 命令行参数：`-name 文字 [-mark]`
- 支持交互模式
- 输出文件到当前目录

### TextToImage-Go-WASM

- 通过 JavaScript 调用生成图片
- 返回 Base64 编码的图片数据
- 支持在浏览器环境中运行

### TextToImage-HTML

- 纯前端实现，无需服务器
- 提供 Web UI 界面
- 支持图片预览和下载

## 目录结构

```
MHYNameToImage/
├── TextToImage-CSharp/      # C# 版命令行工具 (.NET 8.0)
├── TextToImage-CSharp-UI/   # C# 版图形界面工具
├── TextToImage-Go-EXE/      # Go 版命令行工具
├── TextToImage-Go-WASM/      # Go 版 WebAssembly
├── TextToImage-HTML/        # HTML 版在线工具
├── README.md
└── SPEC.md
```

## 编译脚本

### C# 版

```powershell
.\TextToImage-CSharp\build.ps1
```

### C#-UI 版

```powershell
.\TextToImage-CSharp-UI\build.ps1
```

### Go EXE 版

```powershell
.\TextToImage-Go-EXE\build.ps1
```

### Go WASM 版

```powershell
.\TextToImage-Go-WASM\build.ps1
```

### HTML 版

无需编译，直接在浏览器中打开 index.html 即可。

## 系统要求

| 版本 | 系统要求 |
|------|----------|
| TextToImage-CSharp | Windows + .NET 8 Desktop Runtime |
| TextToImage-CSharp-UI | Windows 10/11 + .NET 8 Desktop Runtime |
| TextToImage-Go-EXE | Windows（编译后） |
| TextToImage-Go-WASM | 现代浏览器 |
| TextToImage-HTML | 现代浏览器 |