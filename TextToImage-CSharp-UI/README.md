# TextToImage-CSharp-UI

基于 WinForms 的文字转图片工具，提供图形界面支持。

## 技术栈

- .NET 8.0 | C# | WinForms
- SixLabors.ImageSharp（图片生成）

## 功能特性

- 单文字输入生成
- 批量处理（支持逗号或换行分隔）
- CSV/TXT 导入
- 自定义普通版和备注版文字颜色
- 自定义背景颜色
- 图片预览
- 固定导出目录

## 图片规格

| 属性 | 普通版 | 备注版 |
|------|--------|--------|
| 文字颜色 | RGB(80, 87, 105) | RGB(100, 119, 171) |
| 背景颜色 | RGB(245, 246, 247) | RGB(245, 246, 247) |
| 图片高度 | 28px | 28px |
| 图片宽度 | 自适应 | 自适应 |
| 字体 | 华文行楷 24px | 华文行楷 24px |

## 使用方法

### 运行程序

```powershell
# 方式1：直接运行
dotnet run

# 方式2：编译后运行
.\build.ps1
.\publish\TextToImage.exe
```

### 编译发布

```powershell
.\build.ps1
```

编译后的文件位于 `publish` 目录。

## 界面说明

### 单文字输入
在文本框中输入文字，点击"生成"按钮生成图片。

### 批量处理
- 在文本框中输入多个文字（逗号或换行分隔）
- 点击"导入CSV"或"导入TXT"导入文件
- 点击"批量生成"生成所有图片

### 颜色自定义
- 勾选"自定义"启用手动输入 RGB 值
- 分别设置普通版文字、备注版文字、背景颜色

### 导出目录
- 默认使用程序目录下的 `output` 文件夹
- 点击"打开目录"可直接查看输出文件

## 系统要求

- Windows 10/11
- .NET 8.0 Runtime

## 相关项目

- [TextToImage-CSharp](../TextToImage-CSharp) - 命令行版本
- [TextToImage-Go-EXE](../TextToImage-Go-EXE) - Go 语言版本
- [TextToImage-Go-WASM](../TextToImage-Go-WASM) - WebAssembly 版本
- [TextToImage-HTML](../TextToImage-HTML) - 纯前端版本