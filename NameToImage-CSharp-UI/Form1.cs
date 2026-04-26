namespace NameToImage_UI;

public partial class Form1 : Form
{
    private TextBox textBoxSingleName = null!;
    private Button btnGenerateSingle = null!;
    private TextBox textBoxBatchNames = null!;
    private Button btnImportCSV = null!;
    private Button btnImportTXT = null!;
    private Button btnClearBatch = null!;
    private CheckBox checkBoxNormal = null!;
    private CheckBox checkBoxMark = null!;
    private CheckBox checkBoxCustomNormalText = null!;
    private TextBox textBoxNormalHex = null!;
    private Panel panelNormalColorPreview = null!;
    private CheckBox checkBoxCustomMarkText = null!;
    private TextBox textBoxMarkHex = null!;
    private Panel panelMarkColorPreview = null!;
    private CheckBox checkBoxCustomBg = null!;
    private TextBox textBoxBgHex = null!;
    private Panel panelBgColorPreview = null!;
    private Panel panelPreview = null!;
    private TextBox textBoxOutputDir = null!;
    private Button btnBrowseOutput = null!;
    private Button btnGenerateBatch = null!;
    private ToolStripStatusLabel labelStatus = null!;
    private ListView listViewPreview = null!;

    private readonly string _fontPath;
    private readonly string _outputDir;
    private readonly string _version;

    public Form1(string version = "1.0.0")
    {
        _version = version;
        var baseDir = AppDomain.CurrentDomain.BaseDirectory;
        _fontPath = Path.Combine(baseDir, "HYW.ttf");
        _outputDir = Path.Combine(baseDir, "output");

        if (!Directory.Exists(_outputDir))
            Directory.CreateDirectory(_outputDir);

        InitializeComponent();
    }

    private void InitializeComponent()
    {
        this.Text = $"NameToImage-CSharp-UI v{_version}";
        this.Size = new System.Drawing.Size(900, 700);
        this.StartPosition = FormStartPosition.CenterScreen;

        var labelTitle = new Label
        {
            Text = "账号名称转图片工具",
            Font = new System.Drawing.Font("Microsoft YaHei UI", 14F, System.Drawing.FontStyle.Bold),
            Location = new System.Drawing.Point(20, 15),
            AutoSize = true
        };

        // Single name input section
        var groupBoxSingle = new GroupBox
        {
            Text = "单名称输入",
            Location = new System.Drawing.Point(20, 50),
            Size = new System.Drawing.Size(420, 60)
        };

        var labelSingleName = new Label
        {
            Text = "账号名称:",
            Location = new System.Drawing.Point(10, 25),
            AutoSize = true
        };

        textBoxSingleName = new TextBox
        {
            Location = new System.Drawing.Point(80, 22),
            Size = new System.Drawing.Size(230, 23)
        };

        btnGenerateSingle = new Button
        {
            Text = "生成",
            Location = new System.Drawing.Point(320, 20),
            Size = new System.Drawing.Size(80, 25)
        };
        btnGenerateSingle.Click += BtnGenerateSingle_Click;

        groupBoxSingle.Controls.AddRange(new Control[] { labelSingleName, textBoxSingleName, btnGenerateSingle });

        // Batch input section
        var groupBoxBatch = new GroupBox
        {
            Text = "批量处理",
            Location = new System.Drawing.Point(20, 120),
            Size = new System.Drawing.Size(420, 150)
        };

        var labelBatchNames = new Label
        {
            Text = "多个名称(逗号或换行分隔):",
            Location = new System.Drawing.Point(10, 20),
            AutoSize = true
        };

        textBoxBatchNames = new TextBox
        {
            Location = new System.Drawing.Point(10, 45),
            Size = new System.Drawing.Size(390, 60),
            Multiline = true,
            ScrollBars = ScrollBars.Vertical
        };

        btnImportCSV = new Button
        {
            Text = "导入CSV",
            Location = new System.Drawing.Point(10, 112),
            Size = new System.Drawing.Size(80, 25)
        };
        btnImportCSV.Click += BtnImportCSV_Click;

        btnImportTXT = new Button
        {
            Text = "导入TXT",
            Location = new System.Drawing.Point(95, 112),
            Size = new System.Drawing.Size(80, 25)
        };
        btnImportTXT.Click += BtnImportTXT_Click;

        btnClearBatch = new Button
        {
            Text = "清空",
            Location = new System.Drawing.Point(180, 112),
            Size = new System.Drawing.Size(70, 25)
        };
        btnClearBatch.Click += (s, e) => textBoxBatchNames.Clear();

        btnGenerateBatch = new Button
        {
            Text = "批量生成",
            Location = new System.Drawing.Point(270, 112),
            Size = new System.Drawing.Size(130, 25)
        };
        btnGenerateBatch.Click += BtnGenerateBatch_Click;

        groupBoxBatch.Controls.AddRange(new Control[] { labelBatchNames, textBoxBatchNames, btnImportCSV, btnImportTXT, btnClearBatch, btnGenerateBatch });

        // Generate options section
        var groupBoxOptions = new GroupBox
        {
            Text = "生成选项",
            Location = new System.Drawing.Point(20, 280),
            Size = new System.Drawing.Size(420, 100)
        };

        checkBoxNormal = new CheckBox
        {
            Text = "普通版 (RGB: 80,87,105)",
            Location = new System.Drawing.Point(10, 22),
            Checked = true,
            AutoSize = true
        };

        checkBoxMark = new CheckBox
        {
            Text = "备注版 (RGB: 100,119,171)",
            Location = new System.Drawing.Point(10, 45),
            Checked = false,
            AutoSize = true
        };

        groupBoxOptions.Controls.AddRange(new Control[] { checkBoxNormal, checkBoxMark });

        // Custom color section
        var groupBoxColors = new GroupBox
        {
            Text = "颜色自定义",
            Location = new System.Drawing.Point(20, 390),
            Size = new System.Drawing.Size(420, 180)
        };

        // Normal text color
        checkBoxCustomNormalText = new CheckBox
        {
            Text = "自定义",
            Location = new System.Drawing.Point(10, 22),
            AutoSize = true
        };
        checkBoxCustomNormalText.CheckedChanged += (s, e) => ToggleColorInputs(checkBoxCustomNormalText, textBoxNormalHex);

        var labelNormalText = new Label
        {
            Text = "普通版文字:",
            Location = new System.Drawing.Point(80, 22),
            AutoSize = true
        };

        textBoxNormalHex = new TextBox
        {
            Location = new System.Drawing.Point(165, 20),
            Size = new System.Drawing.Size(180, 23),
            Enabled = false,
            Text = "#505755"
        };

        panelNormalColorPreview = new Panel
        {
            Location = new System.Drawing.Point(350, 20),
            Size = new System.Drawing.Size(50, 23),
            BackColor = System.Drawing.ColorTranslator.FromHtml("#505755")
        };

        // Mark text color
        checkBoxCustomMarkText = new CheckBox
        {
            Text = "自定义",
            Location = new System.Drawing.Point(10, 55),
            AutoSize = true
        };
        checkBoxCustomMarkText.CheckedChanged += (s, e) => ToggleColorInputs(checkBoxCustomMarkText, textBoxMarkHex);

        var labelMarkText = new Label
        {
            Text = "备注版文字:",
            Location = new System.Drawing.Point(80, 55),
            AutoSize = true
        };

        textBoxMarkHex = new TextBox
        {
            Location = new System.Drawing.Point(165, 53),
            Size = new System.Drawing.Size(180, 23),
            Enabled = false,
            Text = "#6477AB"
        };

        panelMarkColorPreview = new Panel
        {
            Location = new System.Drawing.Point(350, 53),
            Size = new System.Drawing.Size(50, 23),
            BackColor = System.Drawing.ColorTranslator.FromHtml("#6477AB")
        };

        // Background color
        checkBoxCustomBg = new CheckBox
        {
            Text = "自定义",
            Location = new System.Drawing.Point(10, 88),
            AutoSize = true
        };
        checkBoxCustomBg.CheckedChanged += (s, e) => ToggleColorInputs(checkBoxCustomBg, textBoxBgHex);

        var labelBgText = new Label
        {
            Text = "背景颜色:",
            Location = new System.Drawing.Point(80, 88),
            AutoSize = true
        };

        textBoxBgHex = new TextBox
        {
            Location = new System.Drawing.Point(165, 86),
            Size = new System.Drawing.Size(180, 23),
            Enabled = false,
            Text = "#F5F6F7"
        };

        panelBgColorPreview = new Panel
        {
            Location = new System.Drawing.Point(350, 86),
            Size = new System.Drawing.Size(50, 23),
            BackColor = System.Drawing.ColorTranslator.FromHtml("#F5F6F7")
        };

        groupBoxColors.Controls.AddRange(new Control[]
        {
            checkBoxCustomNormalText, labelNormalText, textBoxNormalHex, panelNormalColorPreview,
            checkBoxCustomMarkText, labelMarkText, textBoxMarkHex, panelMarkColorPreview,
            checkBoxCustomBg, labelBgText, textBoxBgHex, panelBgColorPreview
        });

        var labelColorFormatTip = new Label
        {
            Text = "颜色格式: #RRGGBB 或 R,G,B (如 #505755 或 80,87,105)",
            Location = new System.Drawing.Point(10, 115),
            AutoSize = true,
            ForeColor = System.Drawing.Color.Gray
        };
        groupBoxColors.Controls.Add(labelColorFormatTip);

        // Output directory section
        var groupBoxOutput = new GroupBox
        {
            Text = "导出目录",
            Location = new System.Drawing.Point(460, 50),
            Size = new System.Drawing.Size(400, 60)
        };

        textBoxOutputDir = new TextBox
        {
            Location = new System.Drawing.Point(10, 22),
            Size = new System.Drawing.Size(290, 23),
            Text = _outputDir
        };

        btnBrowseOutput = new Button
        {
            Text = "浏览",
            Location = new System.Drawing.Point(305, 20),
            Size = new System.Drawing.Size(75, 25)
        };
        btnBrowseOutput.Click += (s, e) =>
        {
            using var dialog = new FolderBrowserDialog();
            if (dialog.ShowDialog() == DialogResult.OK)
            {
                textBoxOutputDir.Text = dialog.SelectedPath;
            }
        };

        var btnClearOutput = new Button
        {
            Text = "清空输出",
            Location = new System.Drawing.Point(385, 20),
            Size = new System.Drawing.Size(75, 25)
        };
        btnClearOutput.Click += (s, e) =>
        {
            var outputDir = textBoxOutputDir.Text.Trim();
            if (string.IsNullOrEmpty(outputDir))
                outputDir = _outputDir;

            if (Directory.Exists(outputDir))
            {
                var files = Directory.GetFiles(outputDir, "*.png");
                if (files.Length > 0)
                {
                    var result = MessageBox.Show($"确定要删除输出文件夹中的 {files.Length} 张图片吗？", "确认", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                    if (result == DialogResult.Yes)
                    {
                        foreach (var file in files)
                        {
                            File.Delete(file);
                        }
                        labelStatus.Text = $"已删除 {files.Length} 张图片";
                        RefreshPreview(outputDir);
                    }
                }
                else
                {
                    labelStatus.Text = "输出文件夹为空";
                }
            }
            else
            {
                labelStatus.Text = "输出文件夹不存在";
            }
        };

        groupBoxOutput.Controls.AddRange(new Control[] { textBoxOutputDir, btnBrowseOutput, btnClearOutput });

        // Preview section
        var groupBoxPreview = new GroupBox
        {
            Text = "预览",
            Location = new System.Drawing.Point(460, 120),
            Size = new System.Drawing.Size(400, 450)
        };

        listViewPreview = new ListView
        {
            Location = new System.Drawing.Point(10, 22),
            Size = new System.Drawing.Size(380, 415),
            View = View.LargeIcon,
            Scrollable = true
        };

        groupBoxPreview.Controls.Add(listViewPreview);

        // Status bar
        var statusBar = new StatusStrip();
        labelStatus = new ToolStripStatusLabel { Text = "就绪" };
        statusBar.Items.Add(labelStatus);

        // Add all controls to form
        this.Controls.AddRange(new Control[]
        {
            labelTitle, groupBoxSingle, groupBoxBatch, groupBoxOptions, groupBoxColors,
            groupBoxOutput, groupBoxPreview, statusBar
        });

        textBoxNormalHex.TextChanged += (s, e) => UpdateColorPreview(textBoxNormalHex, panelNormalColorPreview);
        textBoxMarkHex.TextChanged += (s, e) => UpdateColorPreview(textBoxMarkHex, panelMarkColorPreview);
        textBoxBgHex.TextChanged += (s, e) => UpdateColorPreview(textBoxBgHex, panelBgColorPreview);
    }

    private void ToggleColorInputs(CheckBox checkBox, params TextBox[] textBoxes)
    {
        var enabled = checkBox.Checked;
        foreach (var tb in textBoxes)
            tb.Enabled = enabled;
    }

    private void UpdateColorPreview(TextBox textBox, Panel panel)
    {
        try
        {
            var hex = textBox.Text.Trim();
            if (hex.StartsWith("#"))
                hex = hex.Substring(1);
            if (hex.Length == 6)
            {
                panel.BackColor = System.Drawing.ColorTranslator.FromHtml("#" + hex);
            }
        }
        catch { }
    }

    private void BtnGenerateSingle_Click(object? sender, EventArgs e)
    {
        var name = textBoxSingleName.Text.Trim();
        if (string.IsNullOrEmpty(name))
        {
            MessageBox.Show("请输入账号名称", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        GenerateImages(name);
        textBoxSingleName.Clear();
    }

    private void BtnGenerateBatch_Click(object? sender, EventArgs e)
    {
        var namesText = textBoxBatchNames.Text.Trim();
        if (string.IsNullOrEmpty(namesText))
        {
            MessageBox.Show("请输入账号名称", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        var names = namesText.Split(new[] { ',', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries)
            .Select(n => n.Trim())
            .Where(n => !string.IsNullOrEmpty(n))
            .Distinct()
            .ToList();

        if (names.Count == 0)
        {
            MessageBox.Show("请输入有效的账号名称", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        int successCount = 0;
        foreach (var name in names)
        {
            try
            {
                GenerateImages(name);
                successCount++;
            }
            catch (Exception ex)
            {
                labelStatus.Text = $"生成 {name} 失败: {ex.Message}";
            }
        }

        labelStatus.Text = $"批量生成完成: {successCount}/{names.Count} 张图片已生成";
        textBoxBatchNames.Clear();
    }

    private void BtnImportCSV_Click(object? sender, EventArgs e)
    {
        using var dialog = new OpenFileDialog
        {
            Filter = "CSV 文件 (*.csv)|*.csv|所有文件 (*.*)|*.*"
        };
        if (dialog.ShowDialog() == DialogResult.OK)
        {
            var content = File.ReadAllText(dialog.FileName);
            var names = content.Split(new[] { ',', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(n => n.Trim())
                .Where(n => !string.IsNullOrEmpty(n));
            textBoxBatchNames.Text = string.Join(Environment.NewLine, names);
        }
    }

    private void BtnImportTXT_Click(object? sender, EventArgs e)
    {
        using var dialog = new OpenFileDialog
        {
            Filter = "TXT 文件 (*.txt)|*.txt|所有文件 (*.*)|*.*"
        };
        if (dialog.ShowDialog() == DialogResult.OK)
        {
            var content = File.ReadAllText(dialog.FileName);
            var names = content.Split(new[] { '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(n => n.Trim())
                .Where(n => !string.IsNullOrEmpty(n));
            textBoxBatchNames.Text = string.Join(Environment.NewLine, names);
        }
    }

    private void GenerateImages(string name)
    {
        var outputDir = textBoxOutputDir.Text.Trim();
        if (string.IsNullOrEmpty(outputDir))
        {
            outputDir = _outputDir;
            textBoxOutputDir.Text = outputDir;
        }

        if (!Directory.Exists(outputDir))
            Directory.CreateDirectory(outputDir);

        var options = new ImageOptions
        {
            GenerateNormal = checkBoxNormal.Checked,
            GenerateMark = checkBoxMark.Checked,
            NormalTextColor = GetColor(checkBoxCustomNormalText, textBoxNormalHex, "#505755"),
            MarkTextColor = GetColor(checkBoxCustomMarkText, textBoxMarkHex, "#6477AB"),
            BackgroundColor = GetColor(checkBoxCustomBg, textBoxBgHex, "#F5F6F7")
        };

        var generator = new ImageGenerator(_fontPath, outputDir);
        generator.GenerateImages(name, options);

        labelStatus.Text = $"图片已保存到: {outputDir}";
        RefreshPreview(outputDir);
    }

    private SixLabors.ImageSharp.Color GetColor(CheckBox checkBox, TextBox hexTextBox, string defaultHex)
    {
        string colorStr = "";

        if (checkBox.Checked)
        {
            colorStr = hexTextBox.Text.Trim();
        }

        if (string.IsNullOrEmpty(colorStr))
        {
            colorStr = defaultHex.TrimStart('#');
        }
        else
        {
            if (colorStr.StartsWith("#"))
                colorStr = colorStr.Substring(1);
        }

        try
        {
            // 如果包含逗号或空格，解析为 RGB
            if (colorStr.Contains(",") || colorStr.Contains(" "))
            {
                var parts = colorStr.Split(new[] { ',', ' ' }, StringSplitOptions.RemoveEmptyEntries);
                if (parts.Length >= 3)
                {
                    var r = byte.Parse(parts[0].Trim());
                    var g = byte.Parse(parts[1].Trim());
                    var b = byte.Parse(parts[2].Trim());
                    return SixLabors.ImageSharp.Color.FromRgb(r, g, b);
                }
            }
            // 否则解析为16进制
            else if (colorStr.Length == 6)
            {
                var r = System.Convert.ToByte(colorStr.Substring(0, 2), 16);
                var g = System.Convert.ToByte(colorStr.Substring(2, 2), 16);
                var b = System.Convert.ToByte(colorStr.Substring(4, 2), 16);
                return SixLabors.ImageSharp.Color.FromRgb(r, g, b);
            }
        }
        catch { }

        // 解析默认颜色
        try
        {
            var defaultHexClean = defaultHex.TrimStart('#');
            var r = System.Convert.ToByte(defaultHexClean.Substring(0, 2), 16);
            var g = System.Convert.ToByte(defaultHexClean.Substring(2, 2), 16);
            var b = System.Convert.ToByte(defaultHexClean.Substring(4, 2), 16);
            return SixLabors.ImageSharp.Color.FromRgb(r, g, b);
        }
        catch
        {
            return SixLabors.ImageSharp.Color.FromRgb(80, 87, 105);
        }
    }

    private void RefreshPreview(string outputDir)
    {
        listViewPreview.Items.Clear();
        listViewPreview.LargeImageList = new ImageList();

        var files = Directory.GetFiles(outputDir, "*.png");
        foreach (var file in files.OrderByDescending(f => File.GetLastWriteTime(f)).Take(20))
        {
            try
            {
                using var img = System.Drawing.Image.FromFile(file);
                var thumb = img.GetThumbnailImage(80, 80, null, IntPtr.Zero);

                var key = Path.GetFileName(file);
                listViewPreview.LargeImageList.Images.Add(key, thumb);
                listViewPreview.Items.Add(new ListViewItem(Path.GetFileName(file), key));
            }
            catch { }
        }
    }
}