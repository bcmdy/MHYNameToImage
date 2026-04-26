using TextToImage;

var baseDir = AppDomain.CurrentDomain.BaseDirectory;
var fontPath = Path.Combine(baseDir, "HYW.ttf");

// Parse arguments
string? nameArg = null;
bool generateMark = false;

for (int i = 0; i < args.Length; i++)
{
    var a = args[i].ToLower();
    if (a == "-m" || a == "--mark")
        generateMark = true;
    else if (!a.StartsWith("-"))
        nameArg = args[i];
}

// No argument - interactive mode
if (string.IsNullOrEmpty(nameArg))
{
    Console.WriteLine("文字转图片工具");
    Console.WriteLine();
    Console.Write("请输入文字: ");
    nameArg = Console.ReadLine();

    if (string.IsNullOrWhiteSpace(nameArg))
        return;

    // Parse input for -m flag
    var parts = nameArg.Split(' ', StringSplitOptions.RemoveEmptyEntries);
    nameArg = parts[0];
    if (parts.Length > 1 && (parts[1].ToLower() == "-m" || parts[1].ToLower() == "--mark"))
        generateMark = true;

    Console.WriteLine();
    Console.WriteLine("正在生成图片...");
    Console.WriteLine();

    var generator = new ImageGenerator(fontPath, baseDir, generateMark);
    generator.GenerateImages(nameArg);

    Console.WriteLine();
    Console.WriteLine("完成！");
    Console.WriteLine("3秒后将自动退出...");
    Thread.Sleep(3000);
    return;
}

// Command line mode
var generator2 = new ImageGenerator(fontPath, baseDir, generateMark);
generator2.GenerateImages(nameArg);