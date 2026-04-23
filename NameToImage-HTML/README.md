# NameToImage-HTML

纯前端实现的在线工具，无需后端服务，直接在浏览器中运行。

## 使用方式

### 本地运行

直接用浏览器打开 `index_canvas.html`（完整版）或 `index_opentype.html`（简洁版），或者使用 HTTP 服务器：

```bash
# Python 3
python -m http.server 8080

# Node.js
npx http-server -p 8080
```

然后访问 http://localhost:8080

## 功能

- 输入账号名称生成对应的 PNG 图片
- 支持同时生成普通版和备注版
- 支持图片预览和下载
- 无需服务器，纯客户端运行

## 图片规格

| 属性 | 普通版 | 备注版 |
|------|--------|--------|
| 文字颜色 | RGB(80,87,105) | RGB(100,119,171) |
| 背景颜色 | RGB(245,246,247) | RGB(245,246,247) |
| 高度 | 28px | 28px |
| 字体 | 华文行楷 24px | 华文行楷 24px |

## 项目结构

```
NameToImage-HTML/
├── index_canvas.html   # Canvas API 渲染版
├── index_opentype.html # opentype.js 路径渲染版
├── HYW.ttf
├── README.md
└── SPEC.md
```

## 版本说明

### index_canvas.html - Canvas API 渲染版
- 使用 Canvas API 的 `fillText` 方法渲染文字
- 多 CDN 线路选择（10条线路）
- 字体本地缓存
- 测速选择最优线路
- 支持清除缓存

### index_opentype.html - opentype.js 路径渲染版
- 使用 **opentype.js** 库解析字体，获取字形路径
- 通过 Path 命令绘制（moveTo/lineTo/quadraticCurveTo 等）
- 代码更简洁
- 字体从 jsdelivr CDN 加载
- 与 EXE/WASM 版本位置公式一致：`y = (height + fontSize) / 2 - 4`