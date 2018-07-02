Imports System
Imports System.Text
Imports System.Threading
Imports System.Runtime.InteropServices
Imports PI
Public Class frmDataRecorder

    Private m_iControllerId As Long

    Private Sub cmdStart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdStart.Click

        Dim sbErrorMessage As New StringBuilder(1024)
        Dim sbAxes As New StringBuilder(1024)
        Dim sAxes As String
        Dim sbHeader As New StringBuilder(1024)
        Dim sTmpAxes As String
        Dim sDataRecorderChannelSources As String
        Dim iError As Long
        Dim iChnl(3) As Integer
        Dim iVal(3) As Integer
        Dim bFlags(3) As Integer
        Dim iDataRecorderOptions(3) As Integer
        Dim dTarget(1) As Double
        Dim dDataTable(2000) As Double
        Dim dDataTablePointer As IntPtr
        Dim iIndex As Long
        Dim iOldIndex As Long
        Dim bMoving(1) As Integer


        '/////////////////////////////////////////
        '// Get the name of the connected axis. //
        '/////////////////////////////////////////
        If GCS2.qSAI(m_iControllerId, sbAxes, 1024) = 0 Then
            iError = GCS2.GetError(m_iControllerId)
            GCS2.TranslateError(iError, sbErrorMessage, 1024)
            MsgBox(sbErrorMessage.ToString(), , "SAI?")
            Exit Sub
        End If
        sAxes = sbAxes.ToString()

        Me.txtDisplay.Text = Me.txtDisplay.Text + "> SAI?:" + vbCrLf + vbTab + AddLinefeedToCarrageReturn(sAxes)
        Me.txtDisplay.Text = Me.txtDisplay.Text + vbCrLf

        '// Use only the first axis
        sAxes = "1"




        '/////////////////////////////////////////
        '// close the servo loop (closed-loop). //
        '/////////////////////////////////////////

        '// Switch on the Servo for all axes
        bFlags(0) = 1 '// servo on for the axis in the string 'axes'.

        '// call the SerVO mode command.
        If GCS2.SVO(m_iControllerId, sAxes, bFlags) = 0 Then
            iError = GCS2.GetError(m_iControllerId)
            GCS2.TranslateError(iError, sbErrorMessage, 1024)
            MsgBox(sbErrorMessage.ToString(), , "SVO")
            Exit Sub
        End If

        Me.txtDisplay.Text = Me.txtDisplay.Text + "> SVO 1 1" + vbCrLf
        Me.txtDisplay.Text = Me.txtDisplay.Text + vbCrLf

        '// call the SerVO mode command.
        If GCS2.FRF(m_iControllerId, sAxes) = 0 Then
            iError = GCS2.GetError(m_iControllerId)
            GCS2.TranslateError(iError, sbErrorMessage, 1024)
            MsgBox(sbErrorMessage.ToString(), , "FRF")
            Exit Sub
        End If

        Me.txtDisplay.Text = Me.txtDisplay.Text + "> FRF 1" + vbCrLf
        Me.txtDisplay.Text = Me.txtDisplay.Text + vbCrLf

        bMoving(0) = 1
        While (bMoving(0))
            GCS2.IsMoving(m_iControllerId, sAxes, bMoving)
        End While

        '////////////////////////////////////////
        '// define the data recorder channels. //
        '////////////////////////////////////////

        '// select the desired record channels to change.
        iChnl(0) = 1

        '// select the corresponding record source id's.
        sDataRecorderChannelSources = "1"

        '// select the corresponding record mode.
        iDataRecorderOptions(0) = 1

        '// Call the data recorder configuration command
        If GCS2.DRC(m_iControllerId, iChnl, sDataRecorderChannelSources, iDataRecorderOptions) = 0 Then
            iError = GCS2.GetError(m_iControllerId)
            GCS2.TranslateError(iError, sbErrorMessage, 1024)
            MsgBox(sbErrorMessage.ToString(), , "DRC")
            Exit Sub
        End If

        Me.txtDisplay.Text = Me.txtDisplay.Text + "> DRC 1 1 1" + vbCrLf
        Me.txtDisplay.Text = Me.txtDisplay.Text + vbCrLf




        '// select the desired record channels to change.
        iChnl(0) = 2

        '// select the corresponding record source id's.
        sDataRecorderChannelSources = "1"

        '// select the corresponding record mode.
        iDataRecorderOptions(0) = 2

        '// Call the data recorder configuration command
        If GCS2.DRC(m_iControllerId, iChnl, sDataRecorderChannelSources, iDataRecorderOptions) = 0 Then
            iError = GCS2.GetError(m_iControllerId)
            GCS2.TranslateError(iError, sbErrorMessage, 1024)
            MsgBox(sbErrorMessage.ToString(), , "DRC")
            Exit Sub
        End If

        Me.txtDisplay.Text = Me.txtDisplay.Text + "> DRC 1 1 2" + vbCrLf
        Me.txtDisplay.Text = Me.txtDisplay.Text + vbCrLf

        '// select the desired record channels to change.
        iChnl(0) = 0

        '// select the corresponding record source id's.
        sDataRecorderChannelSources = "0"

        '// select the corresponding record mode.
        iDataRecorderOptions(0) = 1

        '// Call the data recorder configuration command
        If GCS2.DRT(m_iControllerId, iChnl, iDataRecorderOptions, sDataRecorderChannelSources, 1) = 0 Then
            iError = GCS2.GetError(m_iControllerId)
            GCS2.TranslateError(iError, sbErrorMessage, 1024)
            MsgBox(sbErrorMessage.ToString(), , "DRT")
            Exit Sub
        End If

        Me.txtDisplay.Text = Me.txtDisplay.Text + "> DRT 0 1 0" + vbCrLf
        Me.txtDisplay.Text = Me.txtDisplay.Text + vbCrLf







        '// command relative motion
        dTarget(0) = 1

        If GCS2.MVR(m_iControllerId, sAxes, dTarget) = 0 Then
            iError = GCS2.GetError(m_iControllerId)
            GCS2.TranslateError(iError, sbErrorMessage, 1024)
            MsgBox(sbErrorMessage.ToString(), , "MVR")
            Exit Sub
        End If

        Me.txtDisplay.Text = Me.txtDisplay.Text + "> MVR 1 0.1" + vbCrLf
        Me.txtDisplay.Text = Me.txtDisplay.Text + vbCrLf
        bMoving(0) = 1
        While (bMoving(0))
            GCS2.IsMoving(m_iControllerId, sAxes, bMoving)
        End While
        '///////////////////////////////////
        '// start reading asynchronously. //
        '///////////////////////////////////

        '// select the desired record channels to change.
        iChnl(0) = 1
        iChnl(1) = 2
        dDataTablePointer = Marshal.AllocHGlobal(0)
        '  dDataTablePointer = Marshal.AllocCoTaskMem(Marshal.SizeOf(dDataTable(0)) * dDataTable.Length)
        ' Marshal.Copy(dDataTable, 0, dDataTablePointer, dDataTable.Length)

        If GCS2.qDRR(m_iControllerId, iChnl, 2, 1, 10, dDataTablePointer, sbHeader, 1024) = 0 Then
            iError = GCS2.GetError(m_iControllerId)
            GCS2.TranslateError(iError, sbErrorMessage, 1024)
            MsgBox(sbErrorMessage.ToString(), , "DRR?")
            Exit Sub
        End If

        Me.txtDisplay.Text = Me.txtDisplay.Text + "> DRR? 1 100 1 2" + vbCrLf + vbTab
        Me.txtDisplay.Text = Me.txtDisplay.Text + AddLinefeedToCarrageReturn(sbHeader.ToString())




        '/////////////////////////////////////////////////////////////
        '// wait until the read pointer does not increase any more. //
        '/////////////////////////////////////////////////////////////

        iIndex = -1
        Do
            iOldIndex = iIndex
            Thread.Sleep(100)
            iIndex = GCS2.GetAsyncBufferIndex(m_iControllerId)
            Application.DoEvents()
        Loop While iOldIndex < iIndex

        Marshal.Copy(dDataTablePointer, dDataTable, 0, dDataTable.Length)
        ' Marshal.FreeCoTaskMem(dDataTablePointer)


        '/////////////////////////////////////
        '// read the values from the array. //
        '/////////////////////////////////////
        For iIndex = 0 To (iOldIndex / 2) - 1
            '// print read data
            '// the data columns
            '// c1_1 c2_1 c3_1 c4_1
            '// c1_2 c2_2 c3_2 c4_2
            '// ...
            '// c1_n c2_n c3_n c4_n
            '// are aligned as follows:
            '// dDataTable:
            '// {c1_1,c2_1,c3_1,c4_1,c1_2,c2_2,...,c4_n}

            Me.txtDisplay.Text = Me.txtDisplay.Text + vbTab + CStr(dDataTable(iIndex * 2)) + vbTab + CStr(dDataTable((iIndex * 2) + 1)) + vbCrLf
            Application.DoEvents()
        Next iIndex
        Me.txtDisplay.Text = Me.txtDisplay.Text + vbCrLf



    End Sub

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

        Dim iError As Long
        Dim sbErrorMessage As New StringBuilder(1024)
        Dim sbIdn As New StringBuilder(1024)
        Dim sbUsbController As New StringBuilder(1024)

        '/////////////////////////////////////////
        '// connect to the Controller over USB. //
        '/////////////////////////////////////////
        GCS2.EnumerateUSB(sbUsbController, 1024, "PI E-861")
        m_iControllerId = GCS2.ConnectUSB(sbUsbController.ToString())

        If m_iControllerId < 0 Then
            iError = GCS2.GetError(m_iControllerId)
            GCS2.TranslateError(iError, sbErrorMessage, 1024)
            MsgBox(sbErrorMessage.ToString(), , "ConnectUSB")
            Application.Exit()
        End If



        '////////////////////////////////////
        '// Get the IDeNtification string. //
        '////////////////////////////////////
        If GCS2.qIDN(m_iControllerId, sbIdn, 1024) = 0 Then
            iError = GCS2.GetError(m_iControllerId)
            GCS2.TranslateError(iError, sbErrorMessage, 1024)
            MsgBox(sbErrorMessage.ToString(), , "IDN?")
            Application.Exit()
        End If

        Me.txtDisplay.Text = Me.txtDisplay.Text + "> IDN?:" + vbCrLf + vbTab + AddLinefeedToCarrageReturn(sbIdn.ToString())
        Me.txtDisplay.Text = Me.txtDisplay.Text + vbCrLf

    End Sub

    Protected Overrides Sub Finalize()

        If m_iControllerId >= 0 Then
            GCS2.CloseConnection(m_iControllerId)
            m_iControllerId = -1
        End If

        MyBase.Finalize()
    End Sub


    Public Function AddLinefeedToCarrageReturn(ByVal sString As String) As String

        Dim sTmpStringCrLf As String
        Dim sTmpStringCrLfTab As String
        Dim iStartPosition As Integer
        Dim iTargetPosition As Integer

        ' Syntax of the kommandoset seperates lines only with a linefeed.
        ' to display eache answer in a new line, a carrage return hase to be attaced to
        ' eache linefeed.
        sTmpStringCrLf = ""
        iStartPosition = 1
        Do
            iTargetPosition = InStr(iStartPosition, sString, vbLf, vbTextCompare)
            If iTargetPosition <> 0 Then

                sTmpStringCrLf = sTmpStringCrLf & Mid(sString, iStartPosition, iTargetPosition - iStartPosition) & vbCrLf '" (LF)" & vbCrLf
                iStartPosition = iTargetPosition + 1
            Else
                sTmpStringCrLf = sTmpStringCrLf & Mid(sString, iStartPosition, Len(sString) - iStartPosition + 1)
            End If

            Application.DoEvents()

        Loop While iTargetPosition <> 0


        iStartPosition = 1
        sTmpStringCrLfTab = ""
        Do

            iTargetPosition = InStr(iStartPosition, sTmpStringCrLf, " " + vbCrLf, vbTextCompare)
            If iTargetPosition <> 0 Then
                sTmpStringCrLfTab = sTmpStringCrLfTab & Mid(sTmpStringCrLf, iStartPosition, iTargetPosition - iStartPosition + 3) & vbTab '" (CR)" & vbCrLf
                iStartPosition = iTargetPosition + 3
            Else
                sTmpStringCrLfTab = sTmpStringCrLfTab & Mid(sTmpStringCrLf, iStartPosition, Len(sTmpStringCrLf) - iStartPosition + 1)
            End If

            Application.DoEvents()

        Loop While iTargetPosition <> 0

        AddLinefeedToCarrageReturn = sTmpStringCrLfTab

    End Function

End Class
