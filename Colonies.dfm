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
        Caption = 'Task Group'
        Tag = 9
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
    OnDblClick = ListViewAction
    OnMouseDown = ListViewMouseDown
    ExplicitWidth = 1102
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
    ExplicitWidth = 1102
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 27
      Height = 16
      Caption = 'Filter'
    end
    object DistFromLabel: TLabel
      Left = 728
      Top = 8
      Width = 217
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
      Left = 1097
      Top = 8
      Width = 114
      Height = 17
      Caption = 'Include Ignored'
      Checked = True
      State = cbChecked
      TabOrder = 0
      Visible = False
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
    object Button1: TButton
      Left = 961
      Top = 4
      Width = 20
      Height = 24
      Caption = 'OK'
      TabOrder = 4
      Visible = False
    end
    object ColoniesCheck: TCheckBox
      Left = 272
      Top = 8
      Width = 97
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
      TabOrder = 5
      OnClick = ColoniesCheckClick
    end
    object ColonTargetsCheck: TCheckBox
      Left = 375
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
      TabOrder = 6
      OnClick = ColoniesCheckClick
    end
    object OtherSystemsCheck: TCheckBox
      Left = 607
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Other Systems'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = ColoniesCheckClick
    end
    object ColonCandidatesCheck: TCheckBox
      Left = 487
      Top = 8
      Width = 114
      Height = 17
      Caption = 'Col. Candidates'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = ColoniesCheckClick
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 648
    Top = 232
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
    object AddToTargetsMenuItem: TMenuItem
      Caption = 'Add To Targets'
      OnClick = AddToTargetsMenuItemClick
    end
    object DistancesFromMenuItem: TMenuItem
      Tag = 16
      Caption = 'Reference System'
      OnClick = ListViewAction
    end
    object ToggleIgnoredMenuItem: TMenuItem
      Tag = 4
      Caption = 'Toggle Ignore'
      Visible = False
      OnClick = ListViewAction
    end
    object N5: TMenuItem
      Caption = '-'
      Visible = False
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
    object CopySystemNameMenuItem: TMenuItem
      Tag = 15
      Caption = 'Copy System Name'
      OnClick = ListViewAction
    end
  end
end
