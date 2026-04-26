using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;
using SixLabors.ImageSharp.Processing;
using SixLabors.Fonts;
using SixLabors.ImageSharp.Drawing.Processing;
using Path = System.IO.Path;

namespace TextToImage_UI;

public class ImageGenerator
{
    private readonly SixLabors.Fonts.FontFamily _fontFamily;
    private readonly string _outputDir;

    public ImageGenerator(string fontPath, string outputDir)
    {
        var collection = new FontCollection();
        collection.Add(fontPath);
        _fontFamily = collection.Families.First();
        _outputDir = outputDir;
    }

    public void GenerateImages(string name, ImageOptions options)
    {
        var font = _fontFamily.CreateFont(24f, SixLabors.Fonts.FontStyle.Regular);

        var textWidth = (int)Math.Ceiling(MeasureTextWidth(name, font));
        var paddingX = 3;
        var width = textWidth + paddingX + 2;
        var height = 28;

        if (options.GenerateNormal)
            GenerateNormalImage(name, width, height, font, options.NormalTextColor, options.BackgroundColor);

        if (options.GenerateMark)
            GenerateMarkImage(name, width, height, font, options.MarkTextColor, options.BackgroundColor);
    }

    private float MeasureTextWidth(string text, SixLabors.Fonts.Font font)
    {
        var textOptions = new TextOptions(font)
        {
            Dpi = 72,
        };

        var measured = TextMeasurer.MeasureSize(text, textOptions);
        return measured.Width;
    }

    private void GenerateNormalImage(string name, int width, int height, SixLabors.Fonts.Font font, SixLabors.ImageSharp.Color textColor, SixLabors.ImageSharp.Color backgroundColor)
    {
        using var img = new Image<Rgba32>(width, height);

        img.Mutate(ctx => ctx.Fill(backgroundColor));

        var renderOptions = new RichTextOptions(font)
        {
            Origin = new SixLabors.ImageSharp.PointF(2, (height - (int)font.Size) / 2 - 0),
            Dpi = 72,
        };

        img.Mutate(ctx => ctx.DrawText(renderOptions, name, textColor));

        var outputPath = Path.Combine(_outputDir, $"{name}.png");
        img.SaveAsPng(outputPath);
    }

    private void GenerateMarkImage(string name, int width, int height, SixLabors.Fonts.Font font, SixLabors.ImageSharp.Color textColor, SixLabors.ImageSharp.Color backgroundColor)
    {
        using var img = new Image<Rgba32>(width, height);

        img.Mutate(ctx => ctx.Fill(backgroundColor));

        var renderOptions = new RichTextOptions(font)
        {
            Origin = new SixLabors.ImageSharp.PointF(3, (height - (int)font.Size) / 2 - 0),
            Dpi = 72,
        };

        img.Mutate(ctx => ctx.DrawText(renderOptions, name, textColor));

        var outputPath = Path.Combine(_outputDir, $"{name}备注.png");
        img.SaveAsPng(outputPath);
    }
}

public class ImageOptions
{
    public bool GenerateNormal { get; set; } = true;
    public bool GenerateMark { get; set; } = true;

    public SixLabors.ImageSharp.Color NormalTextColor { get; set; } = SixLabors.ImageSharp.Color.FromRgb(80, 87, 105);
    public SixLabors.ImageSharp.Color MarkTextColor { get; set; } = SixLabors.ImageSharp.Color.FromRgb(100, 119, 171);
    public SixLabors.ImageSharp.Color BackgroundColor { get; set; } = SixLabors.ImageSharp.Color.FromRgb(245, 246, 247);
}