using NameToImage;

Console.WriteLine("欢迎使用账号名称转图片工具！");

var fontPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Resources", "HYW.ttf");
var generator = new ImageGenerator(fontPath);
var config = new ImageGenerator.Config();

while (true)
{
    Console.Write("\n请输入账号名称（或输入\"退出\"结束程序）：");
    var name = Console.ReadLine();

    if (string.IsNullOrWhiteSpace(name))
        continue;

    if (name == "退出")
        break;

    Console.WriteLine("\n正在生成图片...");
    generator.GenerateImages(name, config);
    Console.WriteLine("完成！");
}

Console.WriteLine("\n程序已退出，感谢使用！");