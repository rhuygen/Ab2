using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Threading;
using PI;
namespace DataRecorder
{
    using GraphLib;
    public partial class MainWindow : Form
    {
        private int ID;
        public MainWindow()
        {
            InitializeComponent();
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            ID = PI.GCS2.InterfaceSetupDlg("");
            if (ID > -1)
            {
                CompleteConnectionProces();
            }
        }

        private void btnConnectWithSettings_Click(object sender, EventArgs e)
        {
            int iPort = Convert.ToInt32(textPort.Text);
            int iBaud = Convert.ToInt32(textBaudrate.Text);
            ID = PI.GCS2.ConnectRS232(iPort, iBaud);
            if (ID > -1)
            {
                //MainWindow.Cursor = Cursors.WaitCursor;
                CompleteConnectionProces();
                //MainWindow.Cursor = Cursors.Default; 
            }
        }

        public void CompleteConnectionProces()
        {
            
            StringBuilder IdnBuffer = new StringBuilder(256);
            PI.GCS2.qIDN(ID, IdnBuffer, 255);
            IDNDisplay.Text = IdnBuffer.ToString();
            PI.GCS2.qSAI_ALL(ID, IdnBuffer, IdnBuffer.Capacity);
            string[] words = (IdnBuffer.ToString()).Split('\n');
            foreach (string word in words)
            {
                if(word != "")
                    cmbAvailableAxes.Items.Add(word);
            }
            if (cmbAvailableAxes.Items.Count > 0)
            {
                cmbAvailableAxes.SelectedIndex = 0;
            }
            StringBuilder VSTBuffer = new StringBuilder(4000);
            PI.GCS2.qVST(ID, VSTBuffer, VSTBuffer.Capacity);
            string[] stages = (VSTBuffer.ToString()).Split('\n');
            foreach (string stage in stages)
            {
                if (stage != "")
                    cmbVST_q.Items.Add(stage);
            }
            if (cmbVST_q.Items.Count > 0)
            {
                cmbVST_q.SelectedIndex = 0;
            }
            UpdateReferencingButtons(false);
            btnConnect.Enabled = false;
            btnConnectWithSettings.Enabled = false;
            textPort.Enabled = false;
            textBaudrate.Enabled = false;
        }

        private void btnCST_q_Click(object sender, EventArgs e)
        {
            StringBuilder CSTBuffer = new StringBuilder(400);

            if (PI.GCS2.qCST(ID, cmbAvailableAxes.Text, CSTBuffer, CSTBuffer.Capacity)!=0)
            {
                lblCST_q.Text = CSTBuffer.ToString();
            }

        }

        private void btnCST_Click(object sender, EventArgs e)
        {
            PI.GCS2.CST(ID, cmbAvailableAxes.Text, cmbVST_q.Text);
            UpdateReferencingButtons(false);
        }

        private void btnSVO_q_Click(object sender, EventArgs e)
        {
           bool ServoOn = IsServoOn();
           if(ServoOn)
                lblSVO_q.Text = "1";
           else
                lblSVO_q.Text = "0";
           UpdateReferencingButtons(ServoOn);
        }

        private void btnSVO_Click(object sender, EventArgs e)
        {
            int[] bFlags = new int[1];
            bFlags[0] = cmbServo.SelectedIndex;
            PI.GCS2.SVO(ID, cmbAvailableAxes.Text, bFlags);
            UpdateReferencingButtons(bFlags[0] == 1);
        }

        public bool IsServoOn()
        {
            int[] bFlags = new int[1];
            PI.GCS2.qSVO(ID, cmbAvailableAxes.Text, bFlags);
            return (bFlags[0] == 1);
        }

        public void UpdateReferencingButtons(bool ServoIsDefinitelyOn)
        {
            if((!ServoIsDefinitelyOn) &&(!IsServoOn()))
            {
                btnFRF.Enabled = false;
                btnFNL.Enabled = false;
                btnFPL.Enabled = false;
                return;
            }
            int[] bFlags = new int[1];
            PI.GCS2.qTRS(ID, cmbAvailableAxes.Text, bFlags);
            btnFRF.Enabled = (bFlags[0] == 1);
            PI.GCS2.qLIM(ID, cmbAvailableAxes.Text, bFlags);
            btnFNL.Enabled = (bFlags[0] == 1);
            btnFPL.Enabled = (bFlags[0] == 1);
        }

        private void btnMNL_Click(object sender, EventArgs e)
        {
            PI.GCS2.FNL(ID, cmbAvailableAxes.Text);
        }

        private void btnFRF_Click(object sender, EventArgs e)
        {
            PI.GCS2.FRF(ID, cmbAvailableAxes.Text);
        }

        private void btnMPL_Click(object sender, EventArgs e)
        {
            PI.GCS2.FPL(ID, cmbAvailableAxes.Text);
        }

        private void btnMOV_Click(object sender, EventArgs e)
        {
            int[] iChnl = new int[2];
            iChnl[0] = 0;
            int[] iPar = new int[2];
            iPar[0] = 1;
            PI.GCS2.DRT(ID, iChnl, iPar, "0", 1);
            double[] dVals = new double[1];
            if (txtMOV.Text == "")
                dVals[0] = 0;
            else
                dVals[0] =  Convert.ToDouble(txtMOV.Text);
            PI.GCS2.MOV(ID, cmbAvailableAxes.Text, dVals);
        }

        private void btnDRR_q_Click(object sender, EventArgs e)
        {
            int iNVals = Convert.ToInt32(txtDRR.Text);
            int iNChannels = 1;
            double[] dDataTable = new double[iNVals];
            StringBuilder sHeader = new StringBuilder(1024);
            int size = sizeof(double) * dDataTable.Length * 2;
            IntPtr buffer = Marshal.AllocHGlobal(0); 
            int[] iChnl = new int[2];
            iChnl[0] = 1;
            iChnl[1] = 2;
            if (PI.GCS2.qDRR(ID, iChnl, iNChannels, 1, iNVals, ref buffer, sHeader, sHeader.Capacity) == 0)
            {
                int  iError = PI.GCS2.GetError(ID);
                StringBuilder sErrorMessage = new StringBuilder(1024);
                PI.GCS2.TranslateError(iError, sErrorMessage, sErrorMessage.Capacity);
                MessageBox.Show("ERROR " + iError.ToString() + ": " + sErrorMessage.ToString(), "DRR?");
                return;
            }
            /////////////////////////////////////////////////////////////
            // wait until the read pointer does not increase any more. //
            /////////////////////////////////////////////////////////////

            int iIndex = -1;
            int iOldIndex;
            do
            {
                iOldIndex = iIndex;
                Thread.Sleep(100);
                iIndex = PI.GCS2.GetAsyncBufferIndex(ID);
            } while (iOldIndex < iIndex);

            Marshal.Copy(buffer, dDataTable,0,  dDataTable.Length);
            
            this.SuspendLayout();

            display.DataSources.Clear();
            display.SetDisplayRangeX(0, iNVals);

            display.DataSources.Add(new DataSource());
            int j = 0;
            display.DataSources[j].OnRenderYAxisLabel = RenderYLabel;
            display.DataSources[j].Name = "Position";
            display.DataSources[j].Length = iNVals;
            display.PanelLayout = PlotterGraphPaneEx.LayoutMode.NORMAL;
            //display.DataSources[j].AutoScaleY = true;
            //display.DataSources[j].SetGridDistanceY(1);

            /////////////////////////////////////
            // read the values from the array. //
            /////////////////////////////////////
            for (iIndex = 0; iIndex < (iOldIndex / iNChannels); iIndex++)
            {// print read data
                display.DataSources[j].Samples[iIndex].x = iIndex;
                display.DataSources[j].Samples[iIndex].y = (float)dDataTable[(iIndex * iNChannels)];// dDataTable[(iIndex * 2) + 1];
            }
            if (display.DataSources[j].Samples[iNVals - 1].y > display.DataSources[j].Samples[0].y)
            {
                display.DataSources[j].SetDisplayRangeY(display.DataSources[j].Samples[0].y, display.DataSources[j].Samples[iNVals - 1].y);
            }
            else
            {
                display.DataSources[j].SetDisplayRangeY(display.DataSources[j].Samples[iNVals - 1].y, display.DataSources[j].Samples[0].y);
            }
            this.ResumeLayout();
            display.SetPlayPanelInvisible();
            display.Refresh();

        }

        /// <returns></returns>
        private string RenderYLabel(DataSource s, float v)
        {
            return String.Format("{0:0.0}", v);
        }

        private void MainWindow_Load(object sender, EventArgs e)
        {
            display.SetPlayPanelInvisible();
        }

    }
}