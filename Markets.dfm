object MarketsForm: TMarketsForm
  Left = 0
  Top = 0
  Caption = 'Manage Markets'
  ClientHeight = 555
  ClientWidth = 790
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object ListView: TListView
    Left = 0
    Top = 41
    Width = 790
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
        Caption = 'Last Visited'
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
      end>
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = []
    GridLines = True
    MultiSelect = True
    RowSelect = True
    ParentFont = False
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = ListViewColumnClick
    OnCompare = ListViewCompare
    OnDblClick = ListViewDblClick
    OnMouseDown = ListViewMouseDown
    ExplicitTop = 47
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 790
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
      State = cbChecked
      TabOrder = 0
      OnClick = MarketsCheckClick
    end
    object ConstrCheck: TCheckBox
      Left = 367
      Top = 8
      Width = 130
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
      Width = 129
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
  end
end
