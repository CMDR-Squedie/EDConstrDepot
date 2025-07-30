object BodiesForm: TBodiesForm
  Left = 0
  Top = 0
  Caption = 'Bodies'
  ClientHeight = 380
  ClientWidth = 1187
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object ListView: TListView
    Left = 0
    Top = 34
    Width = 1187
    Height = 346
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clSilver
    Columns = <
      item
        Caption = 'System'
        Tag = 1
      end
      item
        Caption = 'Body'
        Tag = 2
      end
      item
        Caption = 'Body Name'
      end
      item
        Caption = 'Comment'
        Tag = 8
      end
      item
        Alignment = taRightJustify
        Caption = 'Dist. (Ls)'
        Tag = 16
      end
      item
        Alignment = taCenter
        Caption = 'Land.'
      end
      item
        Caption = 'Atmosphere'
      end
      item
        Alignment = taCenter
        Caption = 'Rings'
      end
      item
        Caption = 'Signals'
      end
      item
        Caption = 'Volcanism'
      end
      item
        Alignment = taRightJustify
        Caption = 'Grav.'
      end
      item
        Alignment = taCenter
        Caption = 'T.Lock'
      end
      item
        Alignment = taCenter
        Caption = 'Terr.'
      end
      item
        Alignment = taRightJustify
        Caption = ' Orb.Incl.'
        Width = 70
      end>
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = []
    GridLines = True
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    PopupMenu = PopupMenu
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = ListViewColumnClick
    OnCompare = ListViewCompare
    OnCustomDrawItem = ListViewCustomDrawItem
    OnDblClick = ListViewAction
    OnMouseDown = ListViewMouseDown
    ExplicitWidth = 907
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1187
    Height = 34
    Align = alTop
    BevelEdges = []
    BevelOuter = bvNone
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    ExplicitWidth = 907
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 27
      Height = 16
      Caption = 'Filter'
    end
    object Label2: TLabel
      Left = 874
      Top = 0
      Width = 304
      Height = 33
      AutoSize = False
      Caption = 
        'Hint: You can use col. headers in filters, eg. "atmo+rings", use' +
        ' '#39'~'#39' sign to exclude text, '#39'+'#39' to join filters'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift Light SemiCondensed'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object InclIgnoredCheck: TCheckBox
      Left = 678
      Top = 8
      Width = 72
      Height = 17
      Caption = 'Incl. Ign.'
      TabOrder = 0
      OnClick = ColoniesCheckClick
    end
    object FilterEdit: TComboBox
      Left = 40
      Top = 5
      Width = 194
      Height = 24
      DropDownCount = 20
      Sorted = True
      TabOrder = 1
      OnChange = FilterEditChange
    end
    object ClearFilterButton: TButton
      Left = 235
      Top = 5
      Width = 20
      Height = 24
      Caption = 'X'
      TabOrder = 2
      OnClick = ClearFilterButtonClick
    end
    object SelectModeCheck: TCheckBox
      Left = 756
      Top = 8
      Width = 111
      Height = 17
      Caption = 'Alt. Select Mode'
      TabOrder = 3
      Visible = False
      OnClick = SelectModeCheckClick
    end
    object ColoniesCheck: TCheckBox
      Left = 272
      Top = 8
      Width = 81
      Height = 17
      Caption = 'Colonies'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 4
      OnClick = ColoniesCheckClick
    end
    object ColonTargetsCheck: TCheckBox
      Left = 359
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Col. Targets'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = ColoniesCheckClick
    end
    object OtherSystemsCheck: TCheckBox
      Left = 567
      Top = 8
      Width = 105
      Height = 17
      Caption = 'Other Systems'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = ColoniesCheckClick
    end
    object ColonCandidatesCheck: TCheckBox
      Left = 455
      Top = 8
      Width = 106
      Height = 17
      Caption = 'Col. Candidates'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = ColoniesCheckClick
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 648
    Top = 232
    object SystemInfoMenuItem: TMenuItem
      Tag = 1
      Caption = 'System Info'
      OnClick = ListViewAction
    end
    object ShowOnMapMenuItem: TMenuItem
      Caption = 'Show On Map'
      OnClick = ShowOnMapMenuItemClick
    end
    object N3: TMenuItem
      Tag = 8
      Caption = 'Comment...'
      OnClick = ListViewAction
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object CopyAllMenuItem: TMenuItem
      Caption = 'Copy All'
      OnClick = CopyMenuItemClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object CopySystemNameMenuItem: TMenuItem
      Tag = 15
      Caption = 'Copy System Name'
      OnClick = ListViewAction
    end
  end
  object EditTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = EditTimerTimer
    Left = 88
    Top = 136
  end
end
