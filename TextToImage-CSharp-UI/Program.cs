namespace TextToImage_UI;

static class Program
{
    [STAThread]
    static void Main()
    {
        var ver = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version;
        var version = ver != null ? ver.ToString(3) : "1.0.0";
        ApplicationConfiguration.Initialize();
        Application.Run(new Form1(version));
    }
}