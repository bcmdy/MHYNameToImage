using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;
using SixLabors.ImageSharp.Processing;
using SixLabors.Fonts;
using SixLabors.ImageSharp.Drawing.Processing;
using Path = System.IO.Path;

namespace TextToImage;

public class ImageGenerator
{
    private readonly FontFamily _fontFamily;
    private readonly string _outputDir;
    private readonly bool _generateMark;

    public ImageGenerator(string fontPath, string outputDir, bool generateMark = false)
    {
        var collection = new FontCollection();
        collection.Add(fontPath);
        _fontFamily = collection.Families.First();
        _outputDir = outputDir;
        _generateMark = generateMark;
    }

    public void GenerateImages(string name)
    {
        var font = _fontFamily.CreateFont(24f, FontStyle.Regular);

        var textWidth = (int)Math.Ceiling(MeasureTextWidth(name, font));
        var paddingX = 3;
        var width = textWidth + paddingX + 2;
        var height = 28;

        GenerateNormalImage(name, width, height, font);
        if (_generateMark)
            GenerateMarkImage(name, width, height, font);
    }

    private float MeasureTextWidth(string text, Font font)
    {
        var textOptions = new TextOptions(font)
        {
            Dpi = 72,
        };

        var measured = TextMeasurer.MeasureSize(text, textOptions);
        return measured.Width;
    }

    private void GenerateNormalImage(string name, int width, int height, Font font)
    {
        using var img = new Image<Rgba32>(width, height);

        img.Mutate(ctx => ctx.Fill(Color.FromRgb(245, 246, 247)));

        var renderOptions = new RichTextOptions(font)
        {
            Origin = new PointF(2, (height - (int)font.Size) / 2 - 0),
            Dpi = 72,
        };

        img.Mutate(ctx => ctx.DrawText(renderOptions, name, Color.FromRgb(80, 87, 105)));

        var outputPath = Path.Combine(_outputDir, $"{name}.png");
        img.SaveAsPng(outputPath);

        Console.WriteLine($"图片已保存到：{outputPath}");
    }

    private void GenerateMarkImage(string name, int width, int height, Font font)
    {
        using var img = new Image<Rgba32>(width, height);

        img.Mutate(ctx => ctx.Fill(Color.FromRgb(245, 246, 247)));

        var renderOptions = new RichTextOptions(font)
        {
            Origin = new PointF(3, (height - (int)font.Size) / 2 - 0),
            Dpi = 72,
        };

        img.Mutate(ctx => ctx.DrawText(renderOptions, name, Color.FromRgb(100, 119, 171)));

        var outputPath = Path.Combine(_outputDir, $"{name}备注.png");
        img.SaveAsPng(outputPath);

        Console.WriteLine($"图片已保存到：{outputPath}");
    }
}