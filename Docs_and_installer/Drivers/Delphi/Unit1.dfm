object Form1: TForm1
  Left = 240
  Top = 45
  Width = 610
  Height = 371
  Caption = 'E-861 Sample Program'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 232
    Top = 64
    Width = 54
    Height = 13
    Caption = 'Stagename'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 602
    Height = 129
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label4: TLabel
      Left = 32
      Top = 8
      Width = 4
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Button1: TButton
      Left = 32
      Top = 48
      Width = 145
      Height = 25
      Caption = 'Connect'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 88
    Width = 593
    Height = 241
    TabOrder = 1
    DesignSize = (
      593
      241)
    object Label6: TLabel
      Left = 24
      Top = 8
      Width = 88
      Height = 24
      Caption = 'Command'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object CmdComboBox: TComboBox
      Left = 24
      Top = 32
      Width = 169
      Height = 21
      Hint = 'enter command'
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      Sorted = True
      TabOrder = 0
      Text = '*IDN?'
    end
    object Button7: TButton
      Left = 224
      Top = 32
      Width = 65
      Height = 25
      Hint = 'send command'
      Caption = 'SendCmd'
      Default = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 296
      Top = 32
      Width = 65
      Height = 25
      Caption = 'ERR?'
      TabOrder = 2
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 488
      Top = 32
      Width = 65
      Height = 25
      Caption = 'ClrWindow'
      TabOrder = 3
      OnClick = Button9Click
    end
    object Memo1: TMemo
      Left = 24
      Top = 64
      Width = 529
      Height = 153
      Hint = 'Response'
      Anchors = [akLeft, akTop, akRight, akBottom]
      ParentShowHint = False
      ReadOnly = True
      ScrollBars = ssBoth
      ShowHint = True
      TabOrder = 4
    end
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 520
    Top = 16
  end
end
