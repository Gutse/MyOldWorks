object MainFrm: TMainFrm
  Left = 148
  Top = 17
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'XLS Link'
  ClientHeight = 680
  ClientWidth = 767
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'System'
  Font.Style = [fsBold]
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 761
    Height = 281
    Align = alCustom
    Caption = 'Main file'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 17
      Width = 68
      Height = 16
      Caption = 'File name:'
    end
    object SpeedButton1: TSpeedButton
      Left = 248
      Top = 33
      Width = 71
      Height = 24
      Caption = 'change'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object Label2: TLabel
      Left = 336
      Top = 17
      Width = 45
      Height = 16
      Caption = 'Sheet: '
    end
    object Label3: TLabel
      Left = 8
      Top = 64
      Width = 87
      Height = 16
      Caption = 'Data header: '
    end
    object Label4: TLabel
      Left = 8
      Top = 224
      Width = 69
      Height = 16
      Caption = 'ID column:'
    end
    object Label5: TLabel
      Left = 104
      Top = 224
      Width = 108
      Height = 16
      Caption = 'Insert in column:'
    end
    object Label6: TLabel
      Left = 224
      Top = 224
      Width = 61
      Height = 16
      Caption = 'Start row:'
    end
    object Label7: TLabel
      Left = 304
      Top = 224
      Width = 56
      Height = 16
      Caption = 'End row:'
    end
    object Edit1: TEdit
      Left = 16
      Top = 34
      Width = 223
      Height = 24
      Enabled = False
      TabOrder = 0
      Text = 'none'
    end
    object ComboBox1: TComboBox
      Left = 344
      Top = 32
      Width = 225
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 1
      OnChange = ComboBox1Change
    end
    object ComboBox2: TComboBox
      Left = 16
      Top = 241
      Width = 81
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 2
    end
    object ComboBox3: TComboBox
      Left = 112
      Top = 241
      Width = 81
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 3
    end
    object CheckBox1: TCheckBox
      Left = 384
      Top = 248
      Width = 209
      Height = 17
      Caption = 'Stop on null in ID'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = CheckBox1Click
    end
    object StringGrid1: TStringGrid
      Left = 16
      Top = 88
      Width = 729
      Height = 120
      ColCount = 2
      RowCount = 4
      TabOrder = 5
    end
    object Edit4: TEdit
      Left = 224
      Top = 240
      Width = 57
      Height = 24
      TabOrder = 6
      Text = '1'
      OnChange = Edit4Change
      OnKeyPress = Edit4KeyPress
    end
    object Edit5: TEdit
      Left = 304
      Top = 240
      Width = 57
      Height = 24
      Enabled = False
      TabOrder = 7
      Text = '100'
      OnChange = Edit4Change
      OnKeyPress = Edit4KeyPress
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 288
    Width = 761
    Height = 273
    Align = alCustom
    Caption = 'Linked data file'
    TabOrder = 1
    object Label8: TLabel
      Left = 8
      Top = 17
      Width = 68
      Height = 16
      Caption = 'File name:'
    end
    object SpeedButton2: TSpeedButton
      Left = 248
      Top = 33
      Width = 71
      Height = 24
      Caption = 'change'
      Flat = True
      OnClick = SpeedButton2Click
    end
    object Label9: TLabel
      Left = 336
      Top = 17
      Width = 45
      Height = 16
      Caption = 'Sheet: '
    end
    object Label10: TLabel
      Left = 8
      Top = 64
      Width = 87
      Height = 16
      Caption = 'Data header: '
    end
    object Label11: TLabel
      Left = 8
      Top = 217
      Width = 69
      Height = 16
      Caption = 'ID column:'
    end
    object Label12: TLabel
      Left = 104
      Top = 217
      Width = 88
      Height = 16
      Caption = 'From column:'
    end
    object Label13: TLabel
      Left = 384
      Top = 208
      Width = 61
      Height = 16
      Caption = 'Start row:'
    end
    object Label14: TLabel
      Left = 464
      Top = 208
      Width = 56
      Height = 16
      Caption = 'End row:'
    end
    object Label15: TLabel
      Left = 208
      Top = 217
      Width = 71
      Height = 16
      Caption = 'To column:'
    end
    object Edit2: TEdit
      Left = 16
      Top = 34
      Width = 223
      Height = 24
      Enabled = False
      TabOrder = 0
      Text = 'none'
    end
    object ComboBox4: TComboBox
      Left = 344
      Top = 32
      Width = 225
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 1
      OnChange = ComboBox4Change
    end
    object ComboBox5: TComboBox
      Left = 16
      Top = 233
      Width = 81
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 2
    end
    object ComboBox6: TComboBox
      Left = 112
      Top = 233
      Width = 81
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 3
    end
    object CheckBox2: TCheckBox
      Left = 544
      Top = 240
      Width = 209
      Height = 17
      Caption = 'Stop on null in ID'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = CheckBox2Click
    end
    object ComboBox7: TComboBox
      Left = 216
      Top = 233
      Width = 81
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 5
    end
    object Edit6: TEdit
      Left = 384
      Top = 231
      Width = 57
      Height = 24
      TabOrder = 6
      Text = '1'
      OnChange = Edit4Change
      OnKeyPress = Edit4KeyPress
    end
    object Edit7: TEdit
      Left = 464
      Top = 231
      Width = 57
      Height = 24
      Enabled = False
      TabOrder = 7
      Text = '100'
      OnChange = Edit4Change
      OnKeyPress = Edit4KeyPress
    end
    object StringGrid2: TStringGrid
      Left = 16
      Top = 88
      Width = 729
      Height = 120
      ColCount = 2
      RowCount = 4
      TabOrder = 8
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 563
    Width = 763
    Height = 114
    Align = alCustom
    BevelInner = bvRaised
    TabOrder = 2
    object SpeedButton3: TSpeedButton
      Left = 624
      Top = 72
      Width = 129
      Height = 35
      Caption = 'Link!'
      Flat = True
      OnClick = SpeedButton3Click
    end
    object RadioGroup1: TRadioGroup
      Left = 8
      Top = 8
      Width = 185
      Height = 97
      Caption = 'Compare as'
      ItemIndex = 0
      Items.Strings = (
        'Like strings'
        'By type')
      TabOrder = 0
      OnClick = RadioGroup1Click
    end
    object RadioGroup2: TRadioGroup
      Left = 200
      Top = 8
      Width = 185
      Height = 97
      Caption = 'String compare'
      ItemIndex = 0
      Items.Strings = (
        'MainID = DataID'
        'DataID in MainID'
        'MainID in DataID')
      TabOrder = 1
    end
    object SkipExisted: TCheckBox
      Left = 392
      Top = 16
      Width = 97
      Height = 17
      Caption = 'SkipExisted'
      TabOrder = 2
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.xls'
    Filter = '*.xls|*.xls'
    Left = 616
    Top = 96
  end
end
