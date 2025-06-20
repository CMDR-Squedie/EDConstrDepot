object MarketsForm: TMarketsForm
  Left = 0
  Top = 0
  Caption = 'Manage Markets'
  ClientHeight = 462
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
    Height = 428
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clSilver
    Columns = <
      item
        Caption = 'Station Name'
      end
      item
        Caption = 'Station Type'
        Tag = 3
      end
      item
        Caption = 'System'
        Tag = 2
      end
      item
        Caption = 'Body'
      end
      item
        Caption = 'Last Visit (UTC)'
        Tag = 3
      end
      item
        Alignment = taRightJustify
        Caption = 'Dist. (Ly)'
        Tag = 2
      end
      item
        Alignment = taRightJustify
        Caption = 'Dist. (Ls)'
        Tag = 9
      end
      item
        Alignment = taRightJustify
        Caption = 'Stock'
        Tag = 14
      end
      item
        Alignment = taCenter
        Caption = 'Ign.'
        MaxWidth = 50
        Tag = 4
      end
      item
        Alignment = taCenter
        Caption = 'Fav.'
        MaxWidth = 50
        Tag = 5
      end
      item
        Caption = 'Comment'
        Tag = 6
      end
      item
        Caption = 'Economies'
        Tag = 14
      end
      item
        Caption = 'Task Group'
        Tag = 8
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
    object MarketsCheck: TCheckBox
      Left = 272
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Markets'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 0
      OnClick = MarketsCheckClick
    end
    object ConstrCheck: TCheckBox
      Left = 367
      Top = 8
      Width = 115
      Height = 17
      Caption = 'Constructions'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = MarketsCheckClick
    end
    object InclIgnoredCheck: TCheckBox
      Left = 488
      Top = 8
      Width = 114
      Height = 17
      Caption = 'Include Ignored'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = MarketsCheckClick
    end
    object FilterEdit: TComboBox
      Left = 40
      Top = 5
      Width = 194
      Height = 24
      DropDownCount = 20
      Sorted = True
      TabOrder = 3
      OnChange = FilterEditChange
    end
    object InclPartialCheck: TCheckBox
      Left = 608
      Top = 8
      Width = 129
      Height = 17
      Caption = 'Include Partial Info'
      TabOrder = 4
      OnClick = MarketsCheckClick
    end
    object ClearFilterButton: TButton
      Left = 235
      Top = 5
      Width = 20
      Height = 24
      Caption = 'X'
      TabOrder = 5
      OnClick = ClearFilterButtonClick
    end
    object InclSnapshotsCheck: TCheckBox
      Left = 743
      Top = 8
      Width = 129
      Height = 17
      Caption = 'Include Snapshots'
      TabOrder = 6
      OnClick = MarketsCheckClick
    end
    object CompareCheck: TCheckBox
      Left = 987
      Top = 8
      Width = 111
      Height = 17
      Caption = 'Alt. Select Mode'
      TabOrder = 7
      OnClick = CompareCheckClick
    end
    object Button1: TButton
      Left = 961
      Top = 4
      Width = 20
      Height = 24
      Caption = 'OK'
      TabOrder = 8
      Visible = False
      OnClick = CompareMarketsMenuItemClick
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 648
    Top = 232
    object SelectCurrentMenuItem: TMenuItem
      Tag = 1
      Caption = 'Set As Active'
      OnClick = ListViewAction
    end
    object EditCommentMenuItem: TMenuItem
      Tag = 6
      Caption = 'Edit Comment'
      OnClick = ListViewAction
    end
    object ToggleFavoriteMenuItem: TMenuItem
      Tag = 5
      Caption = 'Toggle Favorite'
      OnClick = ListViewAction
    end
    object ToggleIgnoredMenuItem: TMenuItem
      Tag = 4
      Caption = 'Toggle Ignore'
      OnClick = ListViewAction
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object ConstructionsSubMenu: TMenuItem
      Caption = 'Constructions'
      object GroupDepotGroupMenuItem: TMenuItem
        Tag = 16
        Caption = 'Create Depot Group'
        OnClick = GroupDepotGroupMenuItemClick
      end
      object AddToDepotGroupMenuItem: TMenuItem
        Tag = 11
        Caption = 'Group Add/Remove'
        OnClick = ListViewAction
      end
    end
    object MarketsSubMenu: TMenuItem
      Caption = 'Markets'
      object MarketInfoMenuItem: TMenuItem
        Tag = 14
        Caption = 'Market Info'
        OnClick = ListViewAction
      end
      object MarketSnapshotMenuItem: TMenuItem
        Caption = 'Create Snapshot'
        OnClick = MarketSnapshotMenuItemClick
      end
      object RemoveSnapshotMenuItem: TMenuItem
        Caption = 'Remove Snapshot'
        OnClick = RemoveSnapshotMenuItemClick
      end
      object CompareMarketsMenuItem: TMenuItem
        Caption = 'Compare Markets'
        OnClick = CompareMarketsMenuItemClick
      end
    end
    object FleetCarrierSubMenu: TMenuItem
      Caption = 'Fleet Carrier'
      object SetAsStockMenuItem: TMenuItem
        Tag = 13
        Caption = 'Set As Active'
        OnClick = ListViewAction
      end
      object SetAsConstrDepotMenuItem: TMenuItem
        Tag = 12
        Caption = 'Set As Construction Depot'
        OnClick = ListViewAction
      end
    end
    object TaskGroupSubMenu: TMenuItem
      Caption = 'Task Group'
      object askGroup2: TMenuItem
        Caption = '-'
      end
      object OtherGroupMenuItem: TMenuItem
        Caption = 'New...'
        OnClick = OtherGroupMenuItemClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Clear1: TMenuItem
        Caption = 'Clear'
        OnClick = TaskGroupMenuItemClick
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
    object N2: TMenuItem
      Caption = '-'
    end
    object CopySystemNameMenuItem: TMenuItem
      Tag = 15
      Caption = 'Copy System Name'
      OnClick = ListViewAction
    end
  end
end
