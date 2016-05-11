object StrEditFrm: TStrEditFrm
  Left = 301
  Top = 159
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1047#1085#1072#1095#1077#1085#1080#1077
  ClientHeight = 87
  ClientWidth = 351
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 351
    Height = 87
    Align = alClient
    ParentColor = True
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 61
      Height = 13
      Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SpeedButton1: TSpeedButton
      Left = 160
      Top = 56
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
      Left = 256
      Top = 56
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
    object Edit1: TEdit
      Left = 8
      Top = 24
      Width = 337
      Height = 21
      ParentColor = True
      TabOrder = 0
      Text = #1053#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
    end
  end
end
