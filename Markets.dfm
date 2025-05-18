object MarketsForm: TMarketsForm
  Left = 0
  Top = 0
  Caption = 'Manage Markets'
  ClientHeight = 555
  ClientWidth = 968
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object ListView: TListView
    Left = 0
    Top = 41
    Width = 968
    Height = 514
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
      end
      item
        Caption = 'System'
      end
      item
        Caption = 'Last Visit (UTC)'
      end
      item
        Alignment = taCenter
        Caption = 'Ign.'
        MaxWidth = 50
      end
      item
        Alignment = taCenter
        Caption = 'Fav.'
        MaxWidth = 50
      end
      item
        Caption = 'Comment'
      end
      item
        Caption = 'Economies'
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
    Width = 968
    Height = 41
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
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 648
    Top = 232
    object Select1: TMenuItem
      Tag = 1
      Caption = 'Set As Current'
      OnClick = ListViewAction
    end
    object AddToDepotGroup1: TMenuItem
      Tag = 11
      Caption = 'Add To Group'
      OnClick = ListViewAction
    end
    object AddComment1: TMenuItem
      Tag = 6
      Caption = 'Edit Comment'
      OnClick = ListViewAction
    end
    object AddToFavorite1: TMenuItem
      Tag = 5
      Caption = 'Toggle Favorite'
      OnClick = ListViewAction
    end
    object AddComment2: TMenuItem
      Tag = 4
      Caption = 'Toggle Ignore'
      OnClick = ListViewAction
    end
    object N2: TMenuItem
      Caption = '-'
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
  end
end
