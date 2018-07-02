namespace DataRecorder
{
    partial class MainWindow
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.btnConnect = new System.Windows.Forms.Button();
            this.btnConnectWithSettings = new System.Windows.Forms.Button();
            this.textBaudrate = new System.Windows.Forms.TextBox();
            this.textPort = new System.Windows.Forms.TextBox();
            this.Baud = new System.Windows.Forms.Label();
            this.port = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.IDNDisplay = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.cmbAvailableAxes = new System.Windows.Forms.ComboBox();
            this.btnCST_q = new System.Windows.Forms.Button();
            this.lblCST_q = new System.Windows.Forms.Label();
            this.btnCST = new System.Windows.Forms.Button();
            this.cmbVST_q = new System.Windows.Forms.ComboBox();
            this.btnSVO_q = new System.Windows.Forms.Button();
            this.btnSVO = new System.Windows.Forms.Button();
            this.lblSVO_q = new System.Windows.Forms.Label();
            this.cmbServo = new System.Windows.Forms.ComboBox();
            this.btnFNL = new System.Windows.Forms.Button();
            this.btnFRF = new System.Windows.Forms.Button();
            this.btnFPL = new System.Windows.Forms.Button();
            this.display = new GraphLib.PlotterDisplayEx();
            this.btnMOV = new System.Windows.Forms.Button();
            this.txtMOV = new System.Windows.Forms.TextBox();
            this.btnDRR_q = new System.Windows.Forms.Button();
            this.txtDRR = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // btnConnect
            // 
            this.btnConnect.Location = new System.Drawing.Point(12, 12);
            this.btnConnect.Name = "btnConnect";
            this.btnConnect.Size = new System.Drawing.Size(138, 23);
            this.btnConnect.TabIndex = 0;
            this.btnConnect.Text = "Connect using Dialog";
            this.btnConnect.UseVisualStyleBackColor = true;
            this.btnConnect.Click += new System.EventHandler(this.btnConnect_Click);
            // 
            // btnConnectWithSettings
            // 
            this.btnConnectWithSettings.Location = new System.Drawing.Point(13, 44);
            this.btnConnectWithSettings.Name = "btnConnectWithSettings";
            this.btnConnectWithSettings.Size = new System.Drawing.Size(136, 23);
            this.btnConnectWithSettings.TabIndex = 1;
            this.btnConnectWithSettings.Text = "Connect using Settings:";
            this.btnConnectWithSettings.UseVisualStyleBackColor = true;
            this.btnConnectWithSettings.Click += new System.EventHandler(this.btnConnectWithSettings_Click);
            // 
            // textBaudrate
            // 
            this.textBaudrate.Location = new System.Drawing.Point(212, 46);
            this.textBaudrate.Name = "textBaudrate";
            this.textBaudrate.Size = new System.Drawing.Size(59, 20);
            this.textBaudrate.TabIndex = 2;
            this.textBaudrate.Text = "115200";
            // 
            // textPort
            // 
            this.textPort.Location = new System.Drawing.Point(309, 47);
            this.textPort.Name = "textPort";
            this.textPort.Size = new System.Drawing.Size(43, 20);
            this.textPort.TabIndex = 3;
            this.textPort.Text = "2";
            // 
            // Baud
            // 
            this.Baud.AutoSize = true;
            this.Baud.Location = new System.Drawing.Point(155, 54);
            this.Baud.Name = "Baud";
            this.Baud.Size = new System.Drawing.Size(50, 13);
            this.Baud.TabIndex = 4;
            this.Baud.Text = "Baudrate";
            // 
            // port
            // 
            this.port.AutoSize = true;
            this.port.Location = new System.Drawing.Point(277, 54);
            this.port.Name = "port";
            this.port.Size = new System.Drawing.Size(26, 13);
            this.port.TabIndex = 5;
            this.port.Text = "Port";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(16, 91);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(74, 13);
            this.label1.TabIndex = 6;
            this.label1.Text = "Connected to:";
            // 
            // IDNDisplay
            // 
            this.IDNDisplay.AutoSize = true;
            this.IDNDisplay.Location = new System.Drawing.Point(155, 91);
            this.IDNDisplay.Name = "IDNDisplay";
            this.IDNDisplay.Size = new System.Drawing.Size(136, 13);
            this.IDNDisplay.TabIndex = 7;
            this.IDNDisplay.Text = "no controller connected yet";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(16, 125);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(62, 13);
            this.label2.TabIndex = 8;
            this.label2.Text = "Active Axis:";
            // 
            // cmbAvailableAxes
            // 
            this.cmbAvailableAxes.FormattingEnabled = true;
            this.cmbAvailableAxes.Location = new System.Drawing.Point(158, 117);
            this.cmbAvailableAxes.Name = "cmbAvailableAxes";
            this.cmbAvailableAxes.Size = new System.Drawing.Size(113, 21);
            this.cmbAvailableAxes.TabIndex = 9;
            // 
            // btnCST_q
            // 
            this.btnCST_q.Location = new System.Drawing.Point(19, 165);
            this.btnCST_q.Name = "btnCST_q";
            this.btnCST_q.Size = new System.Drawing.Size(99, 23);
            this.btnCST_q.TabIndex = 10;
            this.btnCST_q.Text = "CST?";
            this.btnCST_q.UseVisualStyleBackColor = true;
            this.btnCST_q.Click += new System.EventHandler(this.btnCST_q_Click);
            // 
            // lblCST_q
            // 
            this.lblCST_q.AutoSize = true;
            this.lblCST_q.Location = new System.Drawing.Point(157, 165);
            this.lblCST_q.Name = "lblCST_q";
            this.lblCST_q.Size = new System.Drawing.Size(0, 13);
            this.lblCST_q.TabIndex = 11;
            // 
            // btnCST
            // 
            this.btnCST.Location = new System.Drawing.Point(19, 194);
            this.btnCST.Name = "btnCST";
            this.btnCST.Size = new System.Drawing.Size(99, 23);
            this.btnCST.TabIndex = 12;
            this.btnCST.Text = "CST";
            this.btnCST.UseVisualStyleBackColor = true;
            this.btnCST.Click += new System.EventHandler(this.btnCST_Click);
            // 
            // cmbVST_q
            // 
            this.cmbVST_q.FormattingEnabled = true;
            this.cmbVST_q.Location = new System.Drawing.Point(158, 196);
            this.cmbVST_q.Name = "cmbVST_q";
            this.cmbVST_q.Size = new System.Drawing.Size(113, 21);
            this.cmbVST_q.TabIndex = 13;
            // 
            // btnSVO_q
            // 
            this.btnSVO_q.Location = new System.Drawing.Point(19, 257);
            this.btnSVO_q.Name = "btnSVO_q";
            this.btnSVO_q.Size = new System.Drawing.Size(99, 23);
            this.btnSVO_q.TabIndex = 14;
            this.btnSVO_q.Text = "SVO?";
            this.btnSVO_q.UseVisualStyleBackColor = true;
            this.btnSVO_q.Click += new System.EventHandler(this.btnSVO_q_Click);
            // 
            // btnSVO
            // 
            this.btnSVO.Location = new System.Drawing.Point(19, 286);
            this.btnSVO.Name = "btnSVO";
            this.btnSVO.Size = new System.Drawing.Size(99, 23);
            this.btnSVO.TabIndex = 15;
            this.btnSVO.Text = "SVO";
            this.btnSVO.UseVisualStyleBackColor = true;
            this.btnSVO.Click += new System.EventHandler(this.btnSVO_Click);
            // 
            // lblSVO_q
            // 
            this.lblSVO_q.AutoSize = true;
            this.lblSVO_q.Location = new System.Drawing.Point(157, 262);
            this.lblSVO_q.Name = "lblSVO_q";
            this.lblSVO_q.Size = new System.Drawing.Size(0, 13);
            this.lblSVO_q.TabIndex = 16;
            // 
            // cmbServo
            // 
            this.cmbServo.FormattingEnabled = true;
            this.cmbServo.Items.AddRange(new object[] {
            "0",
            "1"});
            this.cmbServo.Location = new System.Drawing.Point(160, 288);
            this.cmbServo.Name = "cmbServo";
            this.cmbServo.Size = new System.Drawing.Size(113, 21);
            this.cmbServo.TabIndex = 17;
            // 
            // btnFNL
            // 
            this.btnFNL.Location = new System.Drawing.Point(19, 334);
            this.btnFNL.Name = "btnFNL";
            this.btnFNL.Size = new System.Drawing.Size(71, 23);
            this.btnFNL.TabIndex = 18;
            this.btnFNL.Text = "FNL";
            this.btnFNL.UseVisualStyleBackColor = true;
            this.btnFNL.Click += new System.EventHandler(this.btnMNL_Click);
            // 
            // btnFRF
            // 
            this.btnFRF.Location = new System.Drawing.Point(109, 334);
            this.btnFRF.Name = "btnFRF";
            this.btnFRF.Size = new System.Drawing.Size(71, 23);
            this.btnFRF.TabIndex = 19;
            this.btnFRF.Text = "FRF";
            this.btnFRF.UseVisualStyleBackColor = true;
            this.btnFRF.Click += new System.EventHandler(this.btnFRF_Click);
            // 
            // btnFPL
            // 
            this.btnFPL.Location = new System.Drawing.Point(199, 334);
            this.btnFPL.Name = "btnFPL";
            this.btnFPL.Size = new System.Drawing.Size(71, 23);
            this.btnFPL.TabIndex = 20;
            this.btnFPL.Text = "FPL";
            this.btnFPL.UseVisualStyleBackColor = true;
            this.btnFPL.Click += new System.EventHandler(this.btnMPL_Click);
            // 
            // display
            // 
            this.display.BackColor = System.Drawing.Color.Transparent;
            this.display.BackgroundColorBot = System.Drawing.Color.White;
            this.display.BackgroundColorTop = System.Drawing.Color.White;
            this.display.DashedGridColor = System.Drawing.Color.DarkGray;
            this.display.DoubleBuffering = false;
            this.display.Location = new System.Drawing.Point(292, 165);
            this.display.Name = "display";
            this.display.PlaySpeed = 0.5F;
            this.display.Size = new System.Drawing.Size(415, 240);
            this.display.SolidGridColor = System.Drawing.Color.DarkGray;
            this.display.TabIndex = 21;
            // 
            // btnMOV
            // 
            this.btnMOV.ImageAlign = System.Drawing.ContentAlignment.BottomRight;
            this.btnMOV.Location = new System.Drawing.Point(19, 382);
            this.btnMOV.Name = "btnMOV";
            this.btnMOV.Size = new System.Drawing.Size(59, 23);
            this.btnMOV.TabIndex = 22;
            this.btnMOV.Text = "MOV";
            this.btnMOV.UseVisualStyleBackColor = true;
            this.btnMOV.Click += new System.EventHandler(this.btnMOV_Click);
            // 
            // txtMOV
            // 
            this.txtMOV.Location = new System.Drawing.Point(84, 385);
            this.txtMOV.Name = "txtMOV";
            this.txtMOV.Size = new System.Drawing.Size(51, 20);
            this.txtMOV.TabIndex = 23;
            // 
            // btnDRR_q
            // 
            this.btnDRR_q.Location = new System.Drawing.Point(148, 383);
            this.btnDRR_q.Name = "btnDRR_q";
            this.btnDRR_q.Size = new System.Drawing.Size(57, 23);
            this.btnDRR_q.TabIndex = 24;
            this.btnDRR_q.Text = "DRR?";
            this.btnDRR_q.UseVisualStyleBackColor = true;
            this.btnDRR_q.Click += new System.EventHandler(this.btnDRR_q_Click);
            // 
            // txtDRR
            // 
            this.txtDRR.Location = new System.Drawing.Point(219, 386);
            this.txtDRR.Name = "txtDRR";
            this.txtDRR.Size = new System.Drawing.Size(51, 20);
            this.txtDRR.TabIndex = 25;
            this.txtDRR.Text = "25";
            // 
            // MainWindow
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(714, 431);
            this.Controls.Add(this.txtDRR);
            this.Controls.Add(this.btnDRR_q);
            this.Controls.Add(this.txtMOV);
            this.Controls.Add(this.btnMOV);
            this.Controls.Add(this.display);
            this.Controls.Add(this.btnFPL);
            this.Controls.Add(this.btnFRF);
            this.Controls.Add(this.btnFNL);
            this.Controls.Add(this.cmbServo);
            this.Controls.Add(this.lblSVO_q);
            this.Controls.Add(this.btnSVO);
            this.Controls.Add(this.btnSVO_q);
            this.Controls.Add(this.cmbVST_q);
            this.Controls.Add(this.btnCST);
            this.Controls.Add(this.lblCST_q);
            this.Controls.Add(this.btnCST_q);
            this.Controls.Add(this.cmbAvailableAxes);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.IDNDisplay);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.port);
            this.Controls.Add(this.Baud);
            this.Controls.Add(this.textPort);
            this.Controls.Add(this.textBaudrate);
            this.Controls.Add(this.btnConnectWithSettings);
            this.Controls.Add(this.btnConnect);
            this.Name = "MainWindow";
            this.Text = "PI_GCS2_DLL Sample";
            this.Load += new System.EventHandler(this.MainWindow_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnConnect;
        private System.Windows.Forms.Button btnConnectWithSettings;
        private System.Windows.Forms.TextBox textBaudrate;
        private System.Windows.Forms.TextBox textPort;
        private System.Windows.Forms.Label Baud;
        private System.Windows.Forms.Label port;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label IDNDisplay;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox cmbAvailableAxes;
        private System.Windows.Forms.Button btnCST_q;
        private System.Windows.Forms.Label lblCST_q;
        private System.Windows.Forms.Button btnCST;
        private System.Windows.Forms.ComboBox cmbVST_q;
        private System.Windows.Forms.Button btnSVO_q;
        private System.Windows.Forms.Button btnSVO;
        private System.Windows.Forms.Label lblSVO_q;
        private System.Windows.Forms.ComboBox cmbServo;
        private System.Windows.Forms.Button btnFNL;
        private System.Windows.Forms.Button btnFRF;
        private System.Windows.Forms.Button btnFPL;
        private GraphLib.PlotterDisplayEx display;
        private System.Windows.Forms.Button btnMOV;
        private System.Windows.Forms.TextBox txtMOV;
        private System.Windows.Forms.Button btnDRR_q;
        private System.Windows.Forms.TextBox txtDRR;
    }
}

