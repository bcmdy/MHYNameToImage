using NameToImage;

var inputArg = args.Length > 0 ? args[0].ToLower() : "";
bool generateMark = inputArg.Contains("m") || inputArg.Contains("-mark");
string? nameArg = args.Length > 0 && !inputArg.StartsWith("-") ? args[0] : null;
if (args.Length > 1 && args[1].ToLower() != "-m")
    nameArg = args[1];
else if (args.Length > 1 && (args[1].ToLower() == "-m" || args[2].ToLower() == "-m"))
    generateMark = true;

var baseDir = AppDomain.CurrentDomain.BaseDirectory;
var fontPath = Path.Combine(baseDir, "HYW.ttf");
var generator = new ImageGenerator(fontPath, baseDir, generateMark);

// Require account name
if (string.IsNullOrEmpty(nameArg))
{
    Console.WriteLine("用法: NameToImage.exe 账号名 [-m]");
    return;
}

generator.GenerateImages(nameArg);