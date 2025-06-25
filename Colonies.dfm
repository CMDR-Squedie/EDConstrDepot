object ColoniesForm: TColoniesForm
  Left = 0
  Top = 0
  Caption = 'Manage Colonies'
  ClientHeight = 380
  ClientWidth = 1184
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object ListView: TListView
    Left = 0
    Top = 34
    Width = 1184
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
        Caption = 'Architect'
        Tag = 2
      end
      item
        Alignment = taRightJustify
        Caption = 'Population'
        Tag = 3
      end
      item
        Alignment = taRightJustify
        Caption = 'Dist. (Ly)'
        Tag = 16
      end
      item
        Caption = 'Last Visit (UTC)'
        Tag = 4
      end
      item
        Caption = 'Alter. Name'
        Tag = 7
      end
      item
        Caption = 'Security'
      end
      item
        Caption = 'Factions'
        Tag = 5
      end
      item
        Caption = 'Comment'
        Tag = 8
      end
      item
        Alignment = taCenter
        Caption = 'Pic.'
        Tag = 17
      end
      item
        Caption = 'Current Goals'
        Tag = 9
      end
      item
        Caption = 'Objectives'
        Tag = 10
      end
      item
        Alignment = taCenter
        Caption = 'Ign.'
        Tag = 6
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
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1184
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
    OnMouseDown = Panel1MouseDown
    OnMouseMove = Panel1MouseMove
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 27
      Height = 16
      Caption = 'Filter'
    end
    object DistFromLabel: TLabel
      Left = 756
      Top = 8
      Width = 225
      Height = 16
      AutoSize = False
      Caption = '(Set Reference System to see distances)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
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
      Left = 987
      Top = 8
      Width = 111
      Height = 17
      Caption = 'Alt. Select Mode'
      TabOrder = 3
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
    object SystemPictureMenuItem: TMenuItem
      Tag = 17
      Caption = 'System Picture'
      OnClick = ListViewAction
    end
    object SystemInfoMenuItem: TMenuItem
      Tag = 1
      Caption = 'System Info'
      OnClick = ListViewAction
    end
    object DistancesFromMenuItem: TMenuItem
      Tag = 16
      Caption = 'Set As Reference System'
      OnClick = ListViewAction
    end
    object AddToTargetsMenuItem: TMenuItem
      Caption = 'Add To Targets'
      OnClick = AddToTargetsMenuItemClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object EditArchitectMenuItem: TMenuItem
      Tag = 2
      Caption = 'Architect...'
      OnClick = ListViewAction
    end
    object EditAlterNameMenuItem: TMenuItem
      Tag = 7
      Caption = 'Alternative Name...'
      OnClick = ListViewAction
    end
    object EditCommentMenuItem: TMenuItem
      Tag = 8
      Caption = 'Comment...'
      OnClick = ListViewAction
    end
    object CurrentGoalsMenuItem: TMenuItem
      Tag = 9
      Caption = 'Current Goals...'
      OnClick = ListViewAction
    end
    object LongtermObjectivesMenuItem: TMenuItem
      Tag = 10
      Caption = 'Long-term Objectives...'
      OnClick = ListViewAction
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object AddSystemToScanMenuItem: TMenuItem
      Caption = 'Add System To Scan...'
      OnClick = AddSystemToScanMenuItemClick
    end
    object AddNeighboursMenuItem: TMenuItem
      Caption = 'Add Neighbours (EDSM)'
      OnClick = AddNeighboursMenuItemClick
    end
    object RemoveSystemToScanMenuItem: TMenuItem
      Caption = 'Remove System To Scan'
      OnClick = RemoveSystemToScanMenuItemClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object TaskGroupSubMenu: TMenuItem
      Caption = 'Task Group'
      Visible = False
      object askGroup2: TMenuItem
        Caption = '-'
      end
      object OtherGroupMenuItem: TMenuItem
        Caption = 'New...'
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Clear1: TMenuItem
        Caption = 'Clear'
      end
    end
    object ToggleIgnoredMenuItem: TMenuItem
      Tag = 4
      Caption = 'Toggle Ignored'
      OnClick = ToggleIgnoredMenuItemClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object CopyMenuItem: TMenuItem
      Caption = 'Copy'
      OnClick = CopyMenuItemClick
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
