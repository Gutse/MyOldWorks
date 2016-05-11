object MainFrm: TMainFrm
  Left = 249
  Top = 132
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1054#1094#1077#1085#1082#1080' '#1056#1042#1057#1085#1080#1082#1086#1074' %)'
  ClientHeight = 453
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  Icon.Data = {
    0000010001002020040000000000E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000072
    7272727272727272727272727200002727272727272727272727272727000072
    727272727272727272727272720000272FFFFFFFFFFFFFFFFFFFFFF727000072
    7FFFFFFFFFFFFFFFFFFFFFF2720000272FFFFFFFFFFFFFFFFFFFFFF727000072
    7FFFFFFFFFFFFFFFFFFFFFF2720000272FFFFFFFFFFFFFF2727272F727000072
    7F27272727272727272727F2720000272F727272727272F272727FF727000072
    7FF7272727272F272727FFF2720000272FFF72727272F2727272FFF727000072
    7FFFF727272F272727272FF2720000272FFFFF7272F2727272727FF727000072
    7FFFFFF72F272727FFFFFFF2720000272FFFFFF2F2727272FFFFFFF727000072
    7FFFFF2F272727272FFFFFF2720000272FFFF2F27272727272FFFFF727000072
    7FFF2F2727272727272FFFF2720000272FF2F272727F72727272FFF727000072
    7F2F272727FFF72727272FF2720000272F7272727FFFFF7272727FF727000072
    7FFFFFFFFFFFFFFFFFFFFFF2720000272FFFFFFFFFFFFFFFFFFFFFF727000072
    7FFFFFFFFFFFFFFFFFFFFFF27200002727272727272727272727272727000072
    7272727272727272727272727200002727272727272727272727272727000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFC0000003C0000003C0000003C0000003C0000003C0000003C000
    0003C0000003C0000003C0000003C0000003C0000003C0000003C0000003C000
    0003C0000003C0000003C0000003C0000003C0000003C0000003C0000003C000
    0003C0000003C0000003C0000003C0000003C0000003FFFFFFFFFFFFFFFF}
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 564
    Height = 453
    Align = alClient
    BevelInner = bvRaised
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 416
      Top = 424
      Width = 65
      Height = 22
      Caption = #1054#1090#1095#1077#1090'!'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 488
      Top = 424
      Width = 65
      Height = 22
      Caption = #1042#1099#1093#1086#1076
      Flat = True
      OnClick = SpeedButton2Click
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 8
      Width = 329
      Height = 129
      Caption = 'DB'
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 24
        Width = 37
        Height = 13
        Caption = #1051#1086#1075#1080#1085
      end
      object Label2: TLabel
        Left = 152
        Top = 24
        Width = 45
        Height = 13
        Caption = #1055#1072#1088#1086#1083#1100
      end
      object Label3: TLabel
        Left = 8
        Top = 72
        Width = 44
        Height = 13
        Caption = #1057#1077#1088#1074#1077#1088
      end
      object Label4: TLabel
        Left = 152
        Top = 72
        Width = 77
        Height = 13
        Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
      end
      object Edit1: TEdit
        Left = 16
        Top = 40
        Width = 121
        Height = 21
        TabOrder = 1
        Text = 'sa'
      end
      object Edit2: TEdit
        Left = 160
        Top = 40
        Width = 121
        Height = 21
        PasswordChar = 'X'
        TabOrder = 0
      end
      object Edit3: TEdit
        Left = 16
        Top = 88
        Width = 121
        Height = 21
        TabOrder = 2
        Text = 'sd'
      end
      object Edit4: TEdit
        Left = 160
        Top = 88
        Width = 121
        Height = 21
        TabOrder = 3
        Text = 'sd'
      end
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 144
      Width = 329
      Height = 305
      Caption = #1054#1087#1094#1080#1080' '#1086#1090#1095#1077#1090#1072
      TabOrder = 1
      object Label5: TLabel
        Left = 8
        Top = 24
        Width = 96
        Height = 13
        Caption = #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1076#1072#1090#1072
      end
      object Label6: TLabel
        Left = 8
        Top = 72
        Width = 88
        Height = 13
        Caption = #1050#1086#1085#1077#1095#1085#1072#1103' '#1076#1072#1090#1072
      end
      object DateTimePicker1: TDateTimePicker
        Left = 16
        Top = 40
        Width = 186
        Height = 21
        Date = 39209.365279004630000000
        Time = 39209.365279004630000000
        TabOrder = 0
      end
      object DateTimePicker2: TDateTimePicker
        Left = 16
        Top = 88
        Width = 186
        Height = 21
        Date = 39209.365279004630000000
        Time = 39209.365279004630000000
        TabOrder = 1
      end
      object CheckBox1: TCheckBox
        Left = 8
        Top = 120
        Width = 297
        Height = 17
        Caption = #1054#1094#1077#1085#1082#1080' '#1074#1089#1077#1075#1076#1072' '#1087#1088#1080#1084#1077#1085#1103#1102#1090#1089#1103' '#1082' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1102
        TabOrder = 2
      end
      object RadioGroup1: TRadioGroup
        Left = 8
        Top = 192
        Width = 305
        Height = 105
        Caption = #1055#1088#1080#1084#1077#1085#1103#1090#1100' '#1086#1094#1077#1085#1082#1091' '#1082' '#1085#1072#1088#1103#1076#1072#1084
        ItemIndex = 1
        Items.Strings = (
          #1053#1080#1082#1086#1075#1076#1072
          #1045#1089#1083#1080' '#1091' '#1079#1072#1103#1074#1082#1080' '#1090#1086#1083#1100#1082#1086' '#1086#1076#1080#1085' '#1085#1072#1088#1103#1076
          #1042#1089#1077#1075#1076#1072)
        TabOrder = 3
      end
      object CheckBox2: TCheckBox
        Left = 8
        Top = 144
        Width = 297
        Height = 17
        Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' "'#1057#1087#1072#1084'!"'
        TabOrder = 4
      end
    end
    object RichEdit1: TRichEdit
      Left = 344
      Top = 16
      Width = 209
      Height = 393
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=password;Persist Security Info=True' +
      ';User ID=sa;Initial Catalog=sdDB;Data Source=sd'
    Provider = 'SQLOLEDB.1'
    Left = 256
    Top = 168
  end
  object q1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    SQL.Strings = (
      
        'select distinct ser_ass_per_to_oid as RN from itsm_servicecalls ' +
        'where ser_ass_per_to_oid is not null'
      'union  '
      
        'select distinct ass_per_to_oid as RN from itsm_workorders where ' +
        'ass_per_to_oid is not null')
    Left = 256
    Top = 200
  end
  object q2: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    SQL.Strings = (
      
        'select distinct ser_ass_per_to_oid as RN from itsm_servicecalls ' +
        'where ser_ass_per_to_oid is not null'
      'union  '
      
        'select distinct ass_per_to_oid as RN from itsm_workorders where ' +
        'ass_per_to_oid is not null')
    Left = 256
    Top = 232
  end
end
