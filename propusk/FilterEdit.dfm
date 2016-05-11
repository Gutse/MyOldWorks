object FilterFrm: TFilterFrm
  Left = 0
  Top = 128
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1060#1080#1083#1100#1090#1088
  ClientHeight = 314
  ClientWidth = 792
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
    Width = 792
    Height = 314
    Align = alClient
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 0
    object SpeedButton3: TSpeedButton
      Left = 304
      Top = 283
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
    object SpeedButton4: TSpeedButton
      Left = 48
      Top = 283
      Width = 89
      Height = 22
      AllowAllUp = True
      GroupIndex = 1
      Caption = #1055#1088#1086#1087#1091#1089#1082
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton4Click
    end
    object SpeedButton1: TSpeedButton
      Left = 208
      Top = 283
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
    object LabeledEdit1: TLabeledEdit
      Left = 16
      Top = 32
      Width = 377
      Height = 21
      EditLabel.Width = 57
      EditLabel.Height = 13
      EditLabel.Caption = #1060#1072#1084#1080#1083#1080#1103
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'MS Sans Serif'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '*'
    end
    object LabeledEdit2: TLabeledEdit
      Left = 16
      Top = 72
      Width = 377
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #1048#1084#1103
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'MS Sans Serif'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 1
      Text = '*'
    end
    object LabeledEdit3: TLabeledEdit
      Left = 16
      Top = 112
      Width = 377
      Height = 21
      EditLabel.Width = 56
      EditLabel.Height = 13
      EditLabel.Caption = #1054#1090#1095#1077#1089#1090#1074#1086
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'MS Sans Serif'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 2
      Text = '*'
    end
    object LabeledEdit4: TLabeledEdit
      Left = 16
      Top = 160
      Width = 377
      Height = 21
      EditLabel.Width = 99
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1086#1084#1077#1088' '#1087#1072#1089#1087#1086#1088#1090#1072
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'MS Sans Serif'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 3
      Text = '*'
    end
    object LabeledEdit5: TLabeledEdit
      Left = 16
      Top = 208
      Width = 377
      Height = 21
      EditLabel.Width = 96
      EditLabel.Height = 13
      EditLabel.Caption = #1057#1077#1088#1080#1103' '#1087#1072#1089#1087#1086#1088#1090#1072
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'MS Sans Serif'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 4
      Text = '*'
    end
    object LabeledEdit6: TLabeledEdit
      Left = 18
      Top = 251
      Width = 377
      Height = 21
      EditLabel.Width = 79
      EditLabel.Height = 13
      EditLabel.Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'MS Sans Serif'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 5
      Text = '*'
    end
    object GroupBox1: TGroupBox
      Left = 400
      Top = 8
      Width = 390
      Height = 273
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      object LabeledEdit7: TLabeledEdit
        Left = 8
        Top = 24
        Width = 377
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
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = '*'
      end
      object LabeledEdit8: TLabeledEdit
        Left = 8
        Top = 64
        Width = 377
        Height = 21
        EditLabel.Width = 42
        EditLabel.Height = 13
        EditLabel.Caption = #1057' '#1076#1072#1090#1099
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'MS Sans Serif'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = '*'
      end
      object LabeledEdit9: TLabeledEdit
        Left = 8
        Top = 104
        Width = 377
        Height = 21
        EditLabel.Width = 47
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1086' '#1076#1072#1090#1091
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'MS Sans Serif'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Text = '*'
      end
      object LabeledEdit10: TLabeledEdit
        Left = 8
        Top = 152
        Width = 377
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
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = '*'
      end
      object LabeledEdit11: TLabeledEdit
        Left = 8
        Top = 192
        Width = 377
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
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        Text = '*'
      end
      object LabeledEdit12: TLabeledEdit
        Left = 8
        Top = 242
        Width = 377
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
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        Text = '*'
      end
    end
  end
end
