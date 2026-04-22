package main

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/binary"
	"golang.org/x/image/draw"
	"golang.org/x/image/font"
	"golang.org/x/image/font/opentype"
	"golang.org/x/image/math/fixed"
	"image"
	"image/color"
	"image/png"
	"syscall/js"
)

var (
	fontFace     font.Face
	fontLoaded  bool
	fontBytes   []byte
)

func main() {
	js.Global().Set("wasmReady", true)
	js.Global().Set("generateImage", js.FuncOf(generateImage))
	js.Global().Set("loadFont", js.FuncOf(loadFont))

	<-make(chan struct{})
}

func loadFont(ctx context.Context, args []js.Value) interface{} {
	fontData := args[0]
	if fontData.IsUndefined() || fontData.IsNull() {
		return map[string]interface{}{"error": "no font data"}
	}

	// 创建 Uint8Array 并复制到 Go
	fontDataLen := fontData.Length()
	if fontDataLen == 0 {
		return map[string]interface{}{"error": "font data empty"}
	}

	fontBytes = make([]byte, fontDataLen)
	js.CopyBytesToGo(fontBytes, fontData)

	fontLoaded = false // 标记需要重新解析
	return map[string]interface{}{"status": "loaded", "size": fontDataLen}
}

func generateImage(ctx context.Context, args []js.Value) interface{} {
	name := args[0].String()
	generateMark := false
	if len(args) > 1 {
		generateMark = args[1].Bool()
	}

	if len(name) == 0 {
		return map[string]interface{}{"error": "name is empty"}
	}

	if fontBytes == nil {
		return map[string]interface{}{"error": "font not loaded"}
	}

	// 解析字体（只需要一次）
	if fontFace == nil || !fontLoaded {
		collection, err := opentype.ParseCollection(fontBytes)
		if err != nil {
			return map[string]interface{}{"error": err.Error()}
		}

		tt, err := collection.Font(0)
		if err != nil {
			return map[string]interface{}{"error": err.Error()}
		}

		face, err := opentype.NewFace(tt, &opentype.FaceOptions{
			Size:    24.0,
			DPI:     72,
			Hinting: font.HintingFull,
		})
		if err != nil {
			return map[string]interface{}{"error": err.Error()}
		}
		fontFace = face
		fontLoaded = true
	}

	result := make(map[string]interface{})

	// 普通版 (RGB 80, 87, 105)
	img := createImage(name, [3]uint8{80, 87, 105}, 2)
	result["image"] = imgToDataURL(img)

	if generateMark {
		// 备注版 (RGB 100, 119, 171)
		imgM := createImage(name, [3]uint8{100, 119, 171}, 3)
		result["imageMark"] = imgToDataURL(imgM)
	}

	return result
}

func createImage(name string, textColor [3]uint8, originX int) image.Image {
	dummyImg := image.NewRGBA(image.Rect(0, 0, 1, 1))
	d := &font.Drawer{
		Dst:  dummyImg,
		Src:  image.NewUniform(color.RGBA{textColor[0], textColor[1], textColor[2], 255}),
		Face: fontFace,
	}
	textWidth := d.MeasureString(name).Round()

	paddingX := 3
	width := textWidth + paddingX + 2
	height := 28

	img := image.NewRGBA(image.Rect(0, 0, width, height))
	bg := color.RGBA{245, 246, 247, 255}
	draw.Draw(img, img.Bounds(), &image.Uniform{bg}, image.Point{}, draw.Src)

	d.Dst = img
	y := (height + int(fontFace.Metrics().Height.Round())) / 2
	d.Dot = fixed.P(originX, y)
	d.DrawString(name)

	return img
}

func imgToDataURL(img image.Image) string {
	var buf bytes.Buffer
	if err := png.Encode(&buf, img); err != nil {
		return ""
	}
	return "data:image/png;base64," + base64.StdEncoding.EncodeToString(buf.Bytes())
}