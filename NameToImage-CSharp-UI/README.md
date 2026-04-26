# NameToImage-CSharp-UI

基于 WinForms 的原神账号名称转图片工具，提供图形界面支持。

## 技术栈

- .NET 8.0 | C# | WinForms
- SixLabors.ImageSharp（图片生成）

## 功能特性

- 单名称输入生成
- 批量处理（支持逗号或换行分隔）
- CSV/TXT 导入
- 自定义普通版和备注版文字颜色
- 自定义背景颜色
- 图片预览
- 可自定义导出目录

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
.\publish\NameToImage-CSharp-UI.exe
```

### 编译发布

```powershell
.\build.ps1
```

编译后的文件位于 `publish` 目录。

## 界面说明

### 单名称输入
在文本框中输入账号名称，点击"生成"按钮生成图片。

### 批量处理
- 在文本框中输入多个名称（逗号或换行分隔）
- 点击"导入CSV"或"导入TXT"导入文件
- 点击"批量生成"生成所有图片

### 颜色自定义
- 勾选"自定义"启用手动输入 RGB 值
- 分别设置普通版文字、备注版文字、背景颜色

### 导出目录
- 点击"浏览"选择导出目录
- 生成的图片将保存在指定目录

## 系统要求

- Windows 10/11
- .NET 8.0 Runtime

## 相关项目

- [NameToImage-CSharp](../NameToImage-CSharp) - 命令行版本
- [NameToImage-Go-EXE](../NameToImage-Go-EXE) - Go 语言版本
- [NameToImage-Go-WASM](../NameToImage-Go-WASM) - WebAssembly 版本
- [NameToImage-HTML](../NameToImage-HTML) - 纯前端版本