# 账号名称转图片工具

原神账号名称生成PNG图片工具。

## 使用方式

### 命令行模式

```powershell
# 生成普通版
NameToImage.exe 账号名

# 生成普通版 + 备注版
NameToImage.exe 账号名 -m
```

### 交互模式

```
NameToImage.exe
# 按提示输入账号名，输入"退出"结束程序
```

## 输出

图片保存在 exe 同目录下：
- `账号名.png` - 普通版
- `账号名备注.png` - 备注版（仅 `-m` 参数）

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