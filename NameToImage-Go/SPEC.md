# NameToImage-Go - 需求文档

## 1. 项目概述

- **项目名称**：NameToImage-Go
- **项目类型**：WebAssembly 库
- **核心功能**：在浏览器环境中生成账号名称 PNG 图片
- **目标用户**：需要集成到 Web 应用中的开发者

## 2. 功能需求

### 2.1 核心功能

| 功能编号 | 功能描述 | 优先级 |
|---------|---------|--------|
| F1 | 加载 TTF 字体数据 | P0 |
| F2 | 解析字体并创建 FontFace | P0 |
| F3 | 测量输入文字的宽度 | P0 |
| F4 | 生成自适应宽度的 PNG 图片 | P0 |
| F5 | 绘制文字和背景 | P0 |
| F6 | 输出 Base64 编码的图片 | P0 |
| F7 | 生成备注版图片（不同颜色） | P1 |

### 2.2 JavaScript API

#### loadFont(fontData: Uint8Array)

加载 TTF 字体数据。

Parameters:
- `fontData` - 字体文件的字节数组

Returns:
```javascript
{ status: "loaded", size: number }
```

#### generateImage(name: string, generateMark?: boolean)

生成图片。

Parameters:
- `name` - 账号名称
- `generateMark` - 是否生成备注版（可选，默认 false）

Returns:
```javascript
{
    image: "data:image/png;base64,...",      // 普通版
    imageMark: "data:image/png;base64,..."    // 备注版（如果 generateMark 为 true）
}
```

### 2.3 图片规格

| 属性 | 普通版 | 备注版 |
|------|--------|--------|
| 文字颜色 | RGB(80, 87, 105) | RGB(100, 119, 171) |
| 背景颜色 | RGB(245, 246, 247) | RGB(245, 246, 247) |
| 图片高度 | 28px | 28px |
| 图片宽度 | 自适应 | 自适应 |
| 字体大小 | 24px | 24px |

## 3. 技术方案

### 3.1 技术栈

- **语言**：Go
- **编译目标**：JavaScript / WebAssembly
- **图片处理**：golang.org/x/image

### 3.2 项目结构

```
NameToImage-Go/
├── main.go
├── go.mod
├── HYW.ttf
├── README.md
└── SPEC.md
```

## 4. 验收标准

### 4.1 功能验收

- [x] 能正常编译为 WASM
- [x] loadFont 能加载字体数据
- [x] generateImage 能生成 PNG 图片
- [x] 图片文字颜色符合规格
- [x] 图片背景色为 RGB(245,246,247)
- [x] 图片宽度能根据文字长度自适应
- [x] 图片高度固定为 28px

### 4.2 格式验收

- [x] 返回 Base64 编码的 PNG 图片
- [x] 返回 data URL 格式（data:image/png;base64,...）
- [x] 支持生成备注版图片