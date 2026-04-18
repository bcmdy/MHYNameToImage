# 账号名称转图片工具

原神账号名称生成PNG图片工具。

## 使用方式

### 交互模式（双击运行）

直接双击运行 exe，提示输入账号名，生成后3秒自动退出。

```powershell
NameToImage.exe
```

### 命令行模式

```powershell
# 生成普通版
NameToImage.exe 账号名

# 生成普通版 + 备注版
NameToImage.exe 账号名 -m
```

## 输出

图片保存在 exe 同目录下：
- `账号名.png` - 普通版，文字颜色 RGB(80,87,105)
- `账号名备注.png` - 备注版，文字颜色 RGB(100,119,171)（仅 `-m` 参数）

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

## 打包

```powershell
.\build.ps1
```

清理：

```powershell
.\clean.ps1
```