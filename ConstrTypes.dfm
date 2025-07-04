object ConstrTypesForm: TConstrTypesForm
  Left = 0
  Top = 0
  Caption = 'Construction Types'
  ClientHeight = 600
  ClientWidth = 1584
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
    Top = 34
    Width = 1584
    Height = 566
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clSilver
    Columns = <
      item
        Caption = 'Tier'
        Tag = 1
      end
      item
        Caption = 'Location'
        Tag = 2
      end
      item
        Caption = 'Category'
        Tag = 3
      end
      item
        Caption = 'Type'
        Tag = 16
      end
      item
        Caption = 'Size'
        Tag = 4
      end
      item
        Caption = 'Layouts'
        Tag = 7
      end
      item
        Caption = 'Economy'
      end
      item
        Caption = 'Influence'
        Tag = 5
      end
      item
        Caption = 'Requirements'
        Tag = 8
      end
      item
        Alignment = taRightJustify
        Caption = 'CP2'
        Tag = 17
      end
      item
        Alignment = taRightJustify
        Caption = 'CP3'
        Tag = 9
      end
      item
        Alignment = taRightJustify
        Caption = 'Sec.'
        Tag = 10
      end
      item
        Alignment = taRightJustify
        Caption = 'Tech.'
        Tag = 6
        Width = 40
      end
      item
        Alignment = taRightJustify
        Caption = 'Dev.'
      end
      item
        Alignment = taRightJustify
        Caption = 'Wealth'
      end
      item
        Alignment = taRightJustify
        Caption = 'StdLiv.'
      end
      item
        Alignment = taRightJustify
        Caption = 'Est.Haul'
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
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = ListViewColumnClick
    OnCompare = ListViewCompare
    OnCustomDrawItem = ListViewCustomDrawItem
    OnDblClick = ListViewAction
    OnMouseDown = ListViewMouseDown
    ExplicitWidth = 1184
    ExplicitHeight = 346
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1584
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
    ExplicitWidth = 1184
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 27
      Height = 16
      Caption = 'Filter'
    end
    object FilterEdit: TComboBox
      Left = 40
      Top = 5
      Width = 194
      Height = 24
      DropDownCount = 20
      Sorted = True
      TabOrder = 0
      OnChange = FilterEditChange
    end
    object ClearFilterButton: TButton
      Left = 235
      Top = 5
      Width = 20
      Height = 24
      Caption = 'X'
      TabOrder = 1
      OnClick = ClearFilterButtonClick
    end
    object AddToSystemCheck: TCheckBox
      Left = 360
      Top = 8
      Width = 217
      Height = 17
      Caption = 'Add To Current System on Dbl.Click'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
end
