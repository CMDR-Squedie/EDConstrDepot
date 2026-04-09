object TradeRoutesForm: TTradeRoutesForm
  Left = 0
  Top = 0
  Caption = 'Trade Routes'
  ClientHeight = 588
  ClientWidth = 893
  Color = clBtnFace
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
    Top = 34
    Width = 893
    Height = 554
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clSilver
    Columns = <
      item
        Caption = 'Commodity'
        Width = 200
      end
      item
        Caption = 'From'
        Width = 200
      end
      item
        Alignment = taRightJustify
        Caption = 'Price'
      end
      item
        Caption = 'To'
        Width = 200
      end
      item
        Alignment = taRightJustify
        Caption = 'Price'
      end
      item
        Alignment = taRightJustify
        Caption = 'Profit'
      end>
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListViewDblClick
    ExplicitTop = 0
    ExplicitHeight = 588
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 893
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
    ExplicitLeft = -691
    ExplicitWidth = 1584
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
  end
end
