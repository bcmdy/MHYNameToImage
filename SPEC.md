# TextToImage - 需求文档

## 1. 项目概述

- **项目名称**：TextToImage（文字转图片工具）
- **项目类型**：多语言实现的图片生成工具
- **核心功能**：将文字转换为 PNG 图片
- **目标用户**：需要生成文字图片的用户

## 2. 功能需求

### 2.1 核心功能

所有实现版本共同支持以下核心功能：

| 功能编号 | 功能描述 | 优先级 |
|---------|---------|--------|
| F1 | 读取 TTF 字体文件 | P0 |
| F2 | 解析字体并创建 FontFace | P0 |
| F3 | 测量输入文字的宽度 | P0 |
| F4 | 生成自适应宽度的 PNG 图片 | P0 |
| F5 | 绘制文字和背景 | P0 |
| F6 | 保存/输出图片 | P0 |
| F7 | 生成备注版图片（不同颜色） | P1 |

### 2.2 图片规格

所有版本生成的图片遵循统一的规格：

| 属性 | 普通版 | 备注版 |
|------|--------|--------|
| 文字颜色 | RGB(80, 87, 105) | RGB(100, 119, 171) |
| 背景颜色 | RGB(245, 246, 247) | RGB(245, 246, 247) |
| 图片高度 | 28px | 28px |
| 图片宽度 | 自适应 | 自适应 |
| 字体大小 | 24px | 24px |
| 字体名称 | 华文行楷 (HYW.ttf) | 华文行楷 (HYW.ttf) |

## 3. 技术方案

### 3.1 实现版本

| 版本 | 技术栈 | 适用场景 |
|------|--------|---------|
| TextToImage-CSharp | .NET 8.0 / C# / SixLabors.ImageSharp | Windows 命令行工具 |
| TextToImage-CSharp-UI | .NET 8.0 / C# / WinForms / SixLabors.ImageSharp | Windows 图形界面工具 |
| TextToImage-Go-EXE | Go / golang.org/x/image | 命令行工具 |
| TextToImage-Go-WASM | Go / WebAssembly / golang.org/x/image | 浏览器 Web 应用 |
| TextToImage-HTML | HTML5 / JavaScript / Canvas API + opentype.js | 在线工具 |

### 3.2 项目结构

```
MHYNameToImage/
├── TextToImage-CSharp/      # C# 版命令行工具
│   ├── Program.cs
│   ├── ImageGenerator.cs
│   ├── TextToImage.csproj
│   ├── build.ps1
│   └── Resources/HYW.ttf
├── TextToImage-CSharp-UI/   # C# 版图形界面工具
│   ├── Program.cs
│   ├── Form1.cs
│   ├── ImageGenerator.cs
│   ├── TextToImage-CSharp-UI.csproj
│   ├── build.ps1
│   └── Resources/HYW.ttf
├── TextToImage-Go-EXE/       # Go 版命令行工具
│   ├── main.go
│   ├── go.mod
│   ├── build.ps1
│   └── HYW.ttf
├── TextToImage-Go-WASM/       # Go 版 WebAssembly
│   ├── main.go
│   ├── go.mod
│   ├── build.ps1
│   ├── www/
│   └── HYW.ttf
├── TextToImage-HTML/         # HTML 版在线工具
│   ├── index_canvas.html
│   ├── index_opentype.html
│   └── HYW.ttf
├── README.md
└── SPEC.md
```

## 4. 验收标准

### 4.1 功能验收

- [x] 各版本能正常启动运行
- [x] 输入文字后能正确生成 PNG 图片
- [x] 图片文字颜色符合规格
- [x] 图片背景色为 RGB(245,246,247)
- [x] 图片宽度能根据文字长度自适应
- [x] 图片高度固定为 28px
- [x] 支持生成备注版图片

### 4.2 规格验收

- [x] 普通版文字颜色 RGB(80,87,105)
- [x] 备注版文字颜色 RGB(100,119,171)
- [x] 字体使用华文行楷 24px

## 5. 版本差异

### 5.1 TextToImage-CSharp

- 支持交互模式和命令行模式
- 命令行参数：`TextToImage.exe 文字 [-m]`
- 输出文件到可执行文件同目录

### 5.2 TextToImage-CSharp-UI

- 图形界面，操作便捷
- 单文字输入和批量处理
- 支持 CSV/TXT 导入
- 自定义普通版和备注版文字颜色
- 自定义背景颜色
- 图片预览和日志记录
- 固定导出到程序目录下的 output 文件夹
- 支持打开输出目录
- 支持清空输出目录

### 5.3 TextToImage-Go-EXE

- 命令行参数：`-name 文字 [-mark]`
- 支持交互模式
- 输出文件到当前目录

### 5.4 TextToImage-Go-WASM

- 通过 JavaScript 调用生成图片
- 返回 Base64 编码的图片数据
- 支持在浏览器环境中运行

### 5.5 TextToImage-HTML

- 纯前端实现，无需服务器
- 提供 Web UI 界面
- 支持图片预览和下载