object MainFrm: TMainFrm
  Left = 117
  Top = 106
  Width = 863
  Height = 486
  Caption = #1055#1088#1086#1087#1091#1089#1082
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
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 209
    Height = 440
    Align = alLeft
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 0
    object TreeView1: TTreeView
      Left = 2
      Top = 2
      Width = 205
      Height = 436
      Align = alClient
      BevelInner = bvLowered
      Color = clWhite
      Indent = 19
      PopupMenu = catalog_menu
      ReadOnly = True
      TabOrder = 0
      OnChange = TreeView1Change
      OnDblClick = TreeView1DblClick
      OnDragDrop = TreeView1DragDrop
      OnDragOver = TreeView1DragOver
      Items.Data = {
        01000000210000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
        08CAE0F2E0EBEEE3E8}
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 440
    Width = 855
    Height = 19
    Panels = <>
    ParentColor = True
    SimplePanel = True
  end
  object Panel2: TPanel
    Left = 209
    Top = 0
    Width = 646
    Height = 440
    Align = alClient
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 2
      Top = 307
      Width = 642
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 2
      Width = 642
      Height = 305
      Align = alClient
      Caption = #1055#1086#1089#1077#1090#1080#1090#1077#1083#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object DBGridEh1: TDBGridEh
        Left = 2
        Top = 15
        Width = 638
        Height = 288
        Align = alClient
        Color = clWhite
        DataSource = DM.perons_s
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        FooterColor = clSilver
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = [fsBold]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghIncSearch, dghPreferIncSearch, dghDialogFind]
        ParentFont = False
        PopupMenu = person_menu
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = [fsBold]
        OnDblClick = DBGridEh1DblClick
        OnDrawColumnCell = DBGridEh1DrawColumnCell
        OnGetCellParams = DBGridEh1GetCellParams
        OnMouseDown = DBGridEh1MouseDown
        OnTitleClick = DBGridEh1TitleClick
        Columns = <
          item
            EditButtons = <>
            FieldName = 'FAMILY'
            Footers = <>
            Title.Caption = #1060#1072#1084#1080#1083#1080#1103
            Width = 95
          end
          item
            EditButtons = <>
            FieldName = 'F_NAME'
            Footers = <>
            Title.Caption = #1048#1084#1103
            Width = 82
          end
          item
            EditButtons = <>
            FieldName = 'L_NAME'
            Footers = <>
            Title.Caption = #1054#1090#1095#1077#1089#1090#1074#1086
            Width = 67
          end
          item
            EditButtons = <>
            FieldName = 'P_SERIAL'
            Footers = <>
            Title.Caption = #1055#1072#1089#1087#1086#1088#1090': '#1089#1077#1088#1080#1103
            Width = 63
          end
          item
            EditButtons = <>
            FieldName = 'P_NUMBER'
            Footers = <>
            Title.Caption = #1055#1072#1089#1087#1086#1088#1090': '#1085#1086#1084#1077#1088
            Width = 60
          end
          item
            EditButtons = <>
            FieldName = 'ORG'
            Footers = <>
            Title.Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
            Width = 82
          end
          item
            EditButtons = <>
            FieldName = 'BIRTH_DATE'
            Footers = <>
            Title.Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
            Width = 94
            OnCheckDrawRequiredState = DBGridEh1Columns6CheckDrawRequiredState
          end
          item
            EditButtons = <>
            FieldName = 'PROFF'
            Footers = <>
            Title.Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            Width = 146
          end
          item
            EditButtons = <>
            FieldName = 'ADDR'
            Footers = <>
            Title.Caption = #1040#1076#1088#1077#1089
            Width = 108
          end>
      end
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 310
      Width = 642
      Height = 128
      Align = alBottom
      Caption = #1055#1088#1086#1087#1091#1089#1082#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object DBGrid2: TDBGrid
        Left = 2
        Top = 15
        Width = 638
        Height = 111
        Align = alClient
        Color = clWhite
        DataSource = DM.ACCESS_S
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        PopupMenu = access_menu
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDblClick = DBGrid2DblClick
        Columns = <
          item
            Expanded = False
            FieldName = 'NUMB'
            Title.Caption = #1053#1086#1084#1077#1088
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 67
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'B_DATE'
            Title.Caption = #1053#1072#1095#1072#1083#1086' '#1076#1077#1081#1089#1090#1074#1080#1103
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 109
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'E_DATE'
            Title.Caption = #1044#1072#1090#1072' '#1079#1072#1082#1088#1099#1090#1080#1103
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 102
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'S_TARGET'
            Title.Caption = #1050' '#1082#1086#1084#1091
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 72
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'S_CALLER'
            Title.Caption = #1050#1090#1086' '#1079#1072#1082#1072#1079#1072#1083
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 82
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MOBILE'
            Title.Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 71
            Visible = True
          end>
      end
    end
  end
  object catalog_menu: TPopupMenu
    Left = 168
    Top = 8
    object N5: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = N5Click
    end
    object N7: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      OnClick = N7Click
    end
  end
  object person_menu: TPopupMenu
    Left = 397
    Top = 121
    object N8: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = N8Click
    end
    object N9: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = N9Click
    end
    object N10: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      OnClick = N10Click
    end
    object N15: TMenuItem
      Caption = #1060#1080#1083#1100#1090#1088
      OnClick = N15Click
    end
  end
  object access_menu: TPopupMenu
    Left = 485
    Top = 377
    object N12: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = N12Click
    end
    object N13: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = N13Click
    end
    object N14: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      OnClick = N14Click
    end
  end
end
