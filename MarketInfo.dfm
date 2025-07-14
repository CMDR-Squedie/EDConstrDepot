object MarketInfoForm: TMarketInfoForm
  Left = 0
  Top = 0
  Caption = 'Market Info'
  ClientHeight = 729
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Bahnschrift SemiCondensed'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  TextHeight = 16
  object VertDivider2: TShape
    Left = 367
    Top = 55
    Width = 1
    Height = 674
    Align = alRight
    Visible = False
    ExplicitLeft = 338
    ExplicitHeight = 468
  end
  object ListView: TListView
    Left = 0
    Top = 55
    Width = 367
    Height = 674
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clSilver
    Columns = <
      item
        Caption = 'Commodity'
      end
      item
        Alignment = taRightJustify
        Caption = 'Supply'
      end
      item
        Alignment = taRightJustify
        Caption = 'Price'
      end
      item
        Alignment = taRightJustify
        Caption = '% of avg'
        Width = 64
      end
      item
        Alignment = taCenter
        Caption = ' '
        MinWidth = 28
        Width = 28
      end>
    GridLines = True
    GroupView = True
    ReadOnly = True
    PopupMenu = PopupMenu
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListViewDblClick
    ExplicitHeight = 468
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 368
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    Color = 12105912
    ParentBackground = False
    TabOrder = 1
    object MarketNameLabel: TLabel
      Left = 8
      Top = 2
      Width = 351
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object MarketEconomyLabel: TLabel
      Left = 8
      Top = 19
      Width = 355
      Height = 16
      AutoSize = False
    end
    object LastUpdateLabel: TLabel
      Left = 8
      Top = 33
      Width = 210
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object MarketIDLabel: TLabel
      Left = 208
      Top = 33
      Width = 153
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object VertDivider1: TShape
      Left = 367
      Top = 0
      Width = 1
      Height = 55
      Align = alRight
      Visible = False
      ExplicitLeft = 338
      ExplicitTop = 55
      ExplicitHeight = 468
    end
    object CloseComparisonButton: TButton
      Left = 305
      Top = 7
      Width = 56
      Height = 20
      Caption = 'Close All'
      TabOrder = 0
      Visible = False
      OnClick = CloseComparisonButtonClick
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 176
    Top = 264
    object CompareSelectedMenuItem: TMenuItem
      Caption = 'Compare Selected'
      OnClick = CompareSelectedMenuItemClick
    end
    object CompareAllMenuItem: TMenuItem
      Caption = 'Compare All'
      OnClick = CompareAllMenuItemClick
    end
    object ShowDifferencesSubMenu: TMenuItem
      Caption = 'Show Differences'
      Visible = False
      object ShowDiffIgnoreStockLevel2MenuItem: TMenuItem
        Tag = 2
        Caption = 'Ignore Stock Level'
        OnClick = ShowDifferences1MenuItemClick
      end
      object ShowDiffIgnoreStockLevelMenuItem: TMenuItem
        Tag = 1
        Caption = 'Ignore Stock Level, Sync Lists'
        OnClick = ShowDifferences1MenuItemClick
      end
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object RemoveAllFiltersMenuItem: TMenuItem
      Caption = 'Remove All Filters'
      OnClick = RemoveAllFiltersMenuItemClick
    end
    object N1: TMenuItem
      Caption = '-'
      Visible = False
    end
    object CopyMenuItem: TMenuItem
      Caption = 'Copy'
      Visible = False
      OnClick = CopyMenuItemClick
    end
  end
end
