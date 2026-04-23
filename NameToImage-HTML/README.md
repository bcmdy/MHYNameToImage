# NameToImage-HTML

纯前端实现的在线工具，无需后端服务，直接在浏览器中运行。

## 使用方式

### 本地运行

直接用浏览器打开 `index.html`，或者使用 HTTP 服务器：

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
├── index.html
├── HYW.ttf
├── README.md
└── SPEC.md
```