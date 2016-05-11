object LogonFrm: TLogonFrm
  Left = 374
  Top = 212
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Connection'
  ClientHeight = 123
  ClientWidth = 328
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000009999900000000000000000
    0000000999999999990000000000000000000999999999999999000000000000
    0009999999999999999999000000000000999999999999999999999000000000
    0099999999999999999999900000000009999999999999999999999900000000
    999999999999999999999999900000009FFFFFFFFFFFFFFFFFFFFFF990000000
    9FFFFFFFFFFFFFFFFFFFFFF9900000099FFFFFFFFFFFFFFFFFFFFFF999000009
    9FFFFF0FFFFFFFF0FFFFFFF9990000099FF00F00F00F00FF0F0000F999000009
    9FF00F00F00F00F0FF0F00F9990000099FFFFFFFFFFFFFFFFFFFFFF999000000
    9FFFFFFFFFFFFFFFFFFFFFF9900000009FFFFFFFFFFFFFFFFFFFFFF990000000
    9999999999999999999999999000000009999999999999999999999900000000
    0099999999999999999999900000000000999999999999999999999000000000
    0009999999999999999999000000000000000999999999999999000000000000
    0000000999999999990000000000000000000000009999900000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFFFFFFFFFC1FFFFFE003FFFF8000FFFE00003FFC00001FFC00
    001FF800000FF0000007F0000007F0000007E0000003E0000003E0000003E000
    0003E0000003F0000007F0000007F0000007F800000FFC00001FFC00001FFE00
    003FFF8000FFFFE003FFFFFC1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 328
    Height = 123
    Align = alClient
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 136
      Top = 96
      Width = 89
      Height = 22
      Caption = 'OK'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 232
      Top = 96
      Width = 89
      Height = 22
      Caption = #1054#1090#1084#1077#1085#1072
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 44
      Height = 13
      Caption = #1057#1077#1088#1074#1077#1088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 86
      Height = 13
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 45
      Height = 13
      Caption = #1055#1072#1088#1086#1083#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 104
      Top = 22
      Width = 217
      Height = 21
      TabOrder = 0
      Text = 'boss'
    end
    object Edit2: TEdit
      Left = 104
      Top = 46
      Width = 217
      Height = 21
      TabOrder = 1
      Text = 'SECURYTI'
    end
    object Edit3: TEdit
      Left = 104
      Top = 70
      Width = 217
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
      Text = 'SECURYTI'
    end
  end
end
