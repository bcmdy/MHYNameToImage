# TextToImage-CSharp

基于 .NET 8.0 开发的命令行工具，用于将文字转换为 PNG 图片。

## 使用方式

### 交互模式（双击运行）

直接双击运行 exe，提示输入文字，生成后3秒自动退出。

```powershell
TextToImage.exe
```

### 命令行模式

```powershell
# 生成普通版
TextToImage.exe 文字

# 生成普通版 + 备注版
TextToImage.exe 文字 -m
```

## 输出

图片保存在 exe 同目录下：
- `文字.png` - 普通版，文字颜色 RGB(80,87,105)
- `文字备注.png` - 备注版，文字颜色 RGB(100,119,171)（仅 `-m` 参数）

## 图片规格

| 属性 | 普通版 | 备注版 |
|------|--------|--------|
| 文字颜色 | RGB(80,87,105) | RGB(100,119,171) |
| 背景颜色 | RGB(245,246,247) | RGB(245,246,247) |
| 高度 | 28px | 28px |
| 字体 | 华文行楷 24px | 华文行楷 24px |

## 环境要求

- Windows
- .NET 8 Desktop Runtime

## 构建

```powershell
dotnet build
```

发布（单文件）：

```powershell
dotnet publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true
```

## 项目结构

```
TextToImage-CSharp/
├── Program.cs
├── ImageGenerator.cs
├── TextToImage.csproj
├── MHYNameToImage.sln
├── Resources/
│   └── HYW.ttf
├── build.ps1
├── clean.ps1
├── download_upx.ps1
├── README.md
└── SPEC.md
```