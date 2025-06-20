object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  Caption = 'Settings'
  ClientHeight = 591
  ClientWidth = 623
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Bahnschrift SemiCondensed'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 16
  object ListView: TListView
    Left = 0
    Top = 0
    Width = 623
    Height = 570
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clSilver
    Columns = <
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Alignment = taCenter
        Caption = 'Value'
      end
      item
        Caption = 'Comment'
        Width = 350
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = []
    GridLines = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListViewDblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 570
    Width = 623
    Height = 21
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object VersionLabel: TLabel
      Left = 0
      Top = 0
      Width = 145
      Height = 21
      Align = alLeft
      AutoSize = False
      Color = clBtnFace
      ParentColor = False
      ExplicitTop = 3
      ExplicitHeight = 16
    end
    object UpdLinkLabel: TLinkLabel
      Left = 488
      Top = 0
      Width = 135
      Height = 21
      Align = alRight
      Alignment = taRightJustify
      AutoSize = False
      Caption = 
        '<a href="https://github.com/CMDR-Squedie/EDConstrDepot/releases/' +
        'latest">Check for updates...</a>'
      TabOrder = 0
      OnLinkClick = UpdLinkLabelLinkClick
    end
    object BackupJournalLink: TLinkLabel
      Left = 266
      Top = 0
      Width = 135
      Height = 21
      AutoSize = False
      Caption = '<a>Backup journal...</a>'
      TabOrder = 1
      Visible = False
      OnLinkClick = BackupJournalLinkLinkClick
    end
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Options = [fdNoSizeSel, fdNoStyleSel]
    Left = 392
    Top = 296
  end
end
