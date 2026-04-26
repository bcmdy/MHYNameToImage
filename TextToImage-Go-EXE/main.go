package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	"golang.org/x/image/draw"
	"golang.org/x/image/font"
	"golang.org/x/image/font/opentype"
	"golang.org/x/image/math/fixed"
	"image"
	"image/color"
	"image/png"
)

func main() {
	name := flag.String("name", "", "文字")
	mark := flag.Bool("mark", false, "生成备注版")
	flag.Parse()

	if *name == "" {
		fmt.Print("请输入文字: ")
		fmt.Scan(name)
	}

	if *name == "" {
		log.Fatal("文字不能为空")
	}

	err := GenerateTextImage(*name)
	if err != nil {
		log.Fatal(err)
	}

	if *mark {
		err = GenerateTextImageMark(*name)
		if err != nil {
			log.Fatal(err)
		}
	}

	fmt.Println("完成！")
}

func GenerateTextImage(text string) error {
	fontBytes, err := os.ReadFile("HYW.ttf")
	if err != nil {
		return err
	}

	collection, err := opentype.ParseCollection(fontBytes)
	if err != nil {
		return err
	}

	tt, err := collection.Font(0)
	if err != nil {
		return err
	}

	fontSize := 24.0
	face, err := opentype.NewFace(tt, &opentype.FaceOptions{
		Size:    fontSize,
		DPI:     72,
		Hinting: font.HintingFull,
	})
	if err != nil {
		return err
	}

	dummyImg := image.NewRGBA(image.Rect(0, 0, 1, 1))
	d := &font.Drawer{
		Dst:  dummyImg,
		Src:  image.NewUniform(color.RGBA{80, 87, 105, 255}),
		Face: face,
	}
	textWidth := d.MeasureString(text).Round()

	paddingX := 3
	width := textWidth + paddingX
	height := 28

	img := image.NewRGBA(image.Rect(0, 0, width, height))
	bg := color.RGBA{245, 246, 247, 255}
	draw.Draw(img, img.Bounds(), &image.Uniform{bg}, image.Point{}, draw.Src)

	d.Dst = img
	y := (height + int(fontSize)) / 2 - 4
	d.Dot = fixed.P(paddingX, y)
	d.DrawString(text)

	outFile, err := os.Create(text + ".png")
	if err != nil {
		return err
	}
	defer outFile.Close()

	if err := png.Encode(outFile, img); err != nil {
		return err
	}

	fmt.Printf("图片已保存到: %s\n", text+".png")
	return nil
}

func GenerateTextImageMark(text string) error {
	fontBytes, err := os.ReadFile("HYW.ttf")
	if err != nil {
		return err
	}

	collection, err := opentype.ParseCollection(fontBytes)
	if err != nil {
		return err
	}

	tt, err := collection.Font(0)
	if err != nil {
		return err
	}

	fontSize := 24.0
	face, err := opentype.NewFace(tt, &opentype.FaceOptions{
		Size:    fontSize,
		DPI:     72,
		Hinting: font.HintingFull,
	})
	if err != nil {
		return err
	}

	dummyImg := image.NewRGBA(image.Rect(0, 0, 1, 1))
	d := &font.Drawer{
		Dst:  dummyImg,
		Src:  image.NewUniform(color.RGBA{100, 119, 171, 255}),
		Face: face,
	}
	textWidth := d.MeasureString(text).Round()

	paddingX := 3
	width := textWidth + paddingX
	height := 28

	img := image.NewRGBA(image.Rect(0, 0, width, height))
	bg := color.RGBA{245, 246, 247, 255}
	draw.Draw(img, img.Bounds(), &image.Uniform{bg}, image.Point{}, draw.Src)

	d.Dst = img
	y := (height + int(fontSize)) / 2 - 4
	d.Dot = fixed.P(paddingX, y)
	d.DrawString(text)

	outFile, err := os.Create(text + "备注.png")
	if err != nil {
		return err
	}
	defer outFile.Close()

	if err := png.Encode(outFile, img); err != nil {
		return err
	}

	fmt.Printf("图片已保存到: %s\n", text+"备注.png")
	return nil
}