object MainFrm: TMainFrm
  Left = 381
  Top = 180
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'BudMail'
  ClientHeight = 152
  ClientWidth = 439
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
  object RzStatusBar1: TRzStatusBar
    Left = 0
    Top = 133
    Width = 439
    Height = 19
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 0
    object RzStatusPane1: TRzStatusPane
      Left = 41
      Top = 1
      Width = 399
      Height = 19
      Align = alClient
    end
    object RzProgressBar1: TRzProgressBar
      Left = -1
      Top = 1
      Width = 42
      Height = 19
      Align = alLeft
      BackColor = clBtnFace
      BorderInner = fsFlat
      BorderOuter = fsNone
      BorderWidth = 1
      InteriorOffset = 0
      PartsComplete = 0
      Percent = 0
      TotalParts = 0
    end
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 439
    Height = 133
    Align = alClient
    Alignment = taLeftJustify
    AlignmentVertical = avTop
    BorderOuter = fsStatus
    TabOrder = 1
    object RzStatusPane2: TRzStatusPane
      Left = 8
      Top = 8
      Width = 65
      Caption = 'File name: '
    end
    object RzStatusPane3: TRzStatusPane
      Left = 8
      Top = 40
      Width = 65
      Caption = 'Mail to: '
    end
    object RzStatusPane4: TRzStatusPane
      Left = 8
      Top = 72
      Width = 65
      Caption = 'Theme:'
    end
    object RzStatusPane5: TRzStatusPane
      Left = 8
      Top = 104
      Width = 65
      Caption = 'Size,mb'
    end
    object RzMRUComboBox1: TRzMRUComboBox
      Left = 80
      Top = 40
      Width = 313
      Height = 21
      MruSection = 'mail_list'
      MruID = 'm'
      RemoveItemCaption = '&Remove item from history list'
      SelectFirstItemOnLoad = True
      ItemHeight = 13
      TabOrder = 0
    end
    object RzMRUComboBox2: TRzMRUComboBox
      Left = 80
      Top = 8
      Width = 313
      Height = 21
      MruSection = 'file_list'
      MruID = 'f'
      RemoveItemCaption = '&Remove item from history list'
      SelectFirstItemOnLoad = True
      ItemHeight = 13
      TabOrder = 1
    end
    object cxButton1: TcxButton
      Left = 400
      Top = 8
      Width = 34
      Height = 20
      Caption = 'Open'
      TabOrder = 2
      OnClick = cxButton1Click
    end
    object cxButton2: TcxButton
      Left = 400
      Top = 104
      Width = 34
      Height = 20
      Caption = 'Go'
      TabOrder = 3
      OnClick = cxButton2Click
    end
    object RzEdit1: TRzEdit
      Left = 80
      Top = 72
      Width = 313
      Height = 21
      Text = 'backup'
      TabOrder = 4
    end
    object RzNumericEdit1: TRzNumericEdit
      Left = 80
      Top = 104
      Width = 81
      Height = 21
      TabOrder = 5
      Value = 3.000000000000000000
      DisplayFormat = ',0;(,0)'
    end
  end
  object RzOpenDialog1: TRzOpenDialog
    Left = 344
    Top = 8
  end
end
