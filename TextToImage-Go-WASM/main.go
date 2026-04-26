package main

import (
	"bytes"
	"encoding/base64"
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
	fontFace    font.Face
	fontLoaded bool
	fontBytes  []byte
)

func main() {
	js.Global().Set("wasmReady", true)
	js.Global().Set("generateTextImage", js.FuncOf(generateTextImage))
	js.Global().Set("loadFont", js.FuncOf(loadFont))

	<-make(chan struct{})
}

func loadFont(this js.Value, args []js.Value) any {
	fontData := args[0]
	if fontData.IsUndefined() || fontData.IsNull() {
		return map[string]any{"error": "no font data"}
	}

	fontDataLen := fontData.Length()
	if fontDataLen == 0 {
		return map[string]any{"error": "font data empty"}
	}

	fontBytes = make([]byte, fontDataLen)
	js.CopyBytesToGo(fontBytes, fontData)

	fontLoaded = false
	return map[string]any{"status": "loaded", "size": fontDataLen}
}

func generateTextImage(this js.Value, args []js.Value) any {
	name := args[0].String()
	generateMark := false
	if len(args) > 1 {
		generateMark = args[1].Bool()
	}

	if len(name) == 0 {
		return map[string]any{"error": "name is empty"}
	}

	if fontBytes == nil {
		return map[string]any{"error": "font not loaded"}
	}

	if fontFace == nil || !fontLoaded {
		collection, err := opentype.ParseCollection(fontBytes)
		if err != nil {
			return map[string]any{"error": err.Error()}
		}

		tt, err := collection.Font(0)
		if err != nil {
			return map[string]any{"error": err.Error()}
		}

		face, err := opentype.NewFace(tt, &opentype.FaceOptions{
			Size:    24.0,
			DPI:     72,
			Hinting: font.HintingFull,
		})
		if err != nil {
			return map[string]any{"error": err.Error()}
		}
		fontFace = face
		fontLoaded = true
	}

	result := make(map[string]any)

	img := createImage(name, [3]uint8{80, 87, 105}, 2)
	result["image"] = imgToDataURL(img)

	if generateMark {
		imgM := createImage(name, [3]uint8{100, 119, 171}, 3)
		result["imageMark"] = imgToDataURL(imgM)
	}

	return result
}

func createImage(name string, textColor [3]uint8, originX int) image.Image {
	// 计算宽度
	dummyImg := image.NewRGBA(image.Rect(0, 0, 1, 1))
	d := &font.Drawer{
		Dst:  dummyImg,
		Face: fontFace,
	}
	textWidth := d.MeasureString(name).Round()

	paddingX := 3
	width := textWidth + paddingX
	height := 28

	img := image.NewRGBA(image.Rect(0, 0, width, height))
	bg := color.RGBA{245, 246, 247, 255}
	draw.Draw(img, img.Bounds(), &image.Uniform{bg}, image.Point{}, draw.Src)

	// 使用与EXE版本相同的定位公式
	d.Dst = img
	d.Src = image.NewUniform(color.RGBA{textColor[0], textColor[1], textColor[2], 255})
	fontSize := 24.0
	y := (height + int(fontSize)) / 2 - 4
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