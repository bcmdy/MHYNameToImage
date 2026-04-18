using NameToImage;

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

var generator = new ImageGenerator(fontPath, baseDir, generateMark);

// No argument - show usage
if (string.IsNullOrEmpty(nameArg))
{
    Console.WriteLine("账号名称转图片工具");
    Console.WriteLine();
    Console.WriteLine("用法:");
    Console.WriteLine("  NameToImage.exe 账号名       - 生成普通版");
    Console.WriteLine("  NameToImage.exe 账号名 -m    - 生成普通版+备注版");
    Console.WriteLine();
    Console.WriteLine("按任意键退出...");
    Console.ReadKey(true);
    return;
}

generator.GenerateImages(nameArg);