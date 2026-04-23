# NameToImage-Go-EXE

基于 Go 语言的命令行工具，可编译为 Windows 可执行文件。

## 使用方式

### 编译

```bash
cd NameToImage-Go-EXE
go build -o NameToImage.exe main.go
```

### 运行

```bash
# 生成普通版
./NameToImage.exe -name 账号名

# 生成普通版 + 备注版
./NameToImage.exe -name 账号名 -mark
```

### 交互模式

```bash
./NameToImage.exe
请输入账号名称: 账号名
```

## 输出

图片保存在当前目录下：
- `账号名.png` - 普通版
- `账号名备注.png` - 备注版（仅 -mark 参数）

## 图片规格

| 属性 | 普通版 | 备注版 |
|------|--------|--------|
| 文字颜色 | RGB(80,87,105) | RGB(100,119,171) |
| 背景颜色 | RGB(245,246,247) | RGB(245,246,247) |
| 高度 | 28px | 28px |
| 字体 | 华文行楷 24px | 华文行楷 24px |

## 项目结构

```
NameToImage-Go-EXE/
├── main.go
├── go.mod
├── HYW.ttf
├── README.md
└── SPEC.md
```