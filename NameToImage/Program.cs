using NameToImage;

var inputArg = args.Length > 0 ? args[0].ToLower() : "";
bool generateMark = inputArg.Contains("m") || inputArg.Contains("-mark");

Console.WriteLine("欢迎使用账号名称转图片工具！");

var baseDir = AppDomain.CurrentDomain.BaseDirectory;
var fontPath = Path.Combine(baseDir, "HYW.ttf");
var generator = new ImageGenerator(fontPath, baseDir, generateMark);

while (true)
{
    Console.Write("\n请输入账号名称（或输入\"退出\"结束程序）：");
    var name = Console.ReadLine();

    if (string.IsNullOrWhiteSpace(name))
        continue;

    if (name == "退出")
        break;

    Console.WriteLine("\n正在生成图片...");
    generator.GenerateImages(name);
    Console.WriteLine("完成！");
}

Console.WriteLine("\n程序已退出，感谢使用！");