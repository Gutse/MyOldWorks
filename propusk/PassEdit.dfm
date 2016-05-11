object PassFrm: TPassFrm
  Left = 389
  Top = 183
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1055#1088#1086#1087#1091#1089#1082
  ClientHeight = 311
  ClientWidth = 370
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 370
    Height = 311
    Align = alClient
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 176
      Top = 280
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
      Left = 272
      Top = 280
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
      Left = 72
      Top = 56
      Width = 39
      Height = 13
      Caption = #1042#1099#1076#1072#1085
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 72
      Top = 97
      Width = 124
      Height = 13
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1076#1077#1081#1089#1090#1074#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabeledEdit1: TLabeledEdit
      Left = 72
      Top = 32
      Width = 289
      Height = 21
      EditLabel.Width = 40
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1086#1084#1077#1088
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'MS Sans Serif'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 0
    end
    object LabeledEdit3: TLabeledEdit
      Left = 72
      Top = 208
      Width = 289
      Height = 21
      EditLabel.Width = 75
      EditLabel.Height = 13
      EditLabel.Caption = #1050#1090#1086' '#1079#1072#1082#1072#1079#1072#1083
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'MS Sans Serif'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 1
    end
    object LabeledEdit2: TLabeledEdit
      Left = 72
      Top = 160
      Width = 289
      Height = 21
      EditLabel.Width = 42
      EditLabel.Height = 13
      EditLabel.Caption = #1050' '#1082#1086#1084#1091
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'MS Sans Serif'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 2
    end
    object DateTimePicker1: TDateTimePicker
      Left = 72
      Top = 72
      Width = 289
      Height = 21
      Date = 38552.609830636580000000
      Time = 38552.609830636580000000
      TabOrder = 3
    end
    object DateTimePicker2: TDateTimePicker
      Left = 72
      Top = 112
      Width = 289
      Height = 21
      Date = 38552.609830636580000000
      Time = 38552.609830636580000000
      TabOrder = 4
    end
    object LabeledEdit4: TLabeledEdit
      Left = 72
      Top = 251
      Width = 289
      Height = 21
      EditLabel.Width = 64
      EditLabel.Height = 13
      EditLabel.Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'MS Sans Serif'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 5
    end
  end
end
