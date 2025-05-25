object MarketInfoForm: TMarketInfoForm
  Left = 0
  Top = 0
  Caption = 'Market Info'
  ClientHeight = 523
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Bahnschrift SemiCondensed'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 16
  object ListView: TListView
    Left = 0
    Top = 55
    Width = 401
    Height = 468
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clSilver
    Columns = <
      item
        Caption = 'Commodity'
        MinWidth = 150
      end
      item
        Alignment = taRightJustify
        Caption = 'Supply'
      end
      item
        Alignment = taRightJustify
        Caption = 'Price'
        MinWidth = 100
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = '+/- of mean'
        MaxWidth = 120
      end>
    GridLines = True
    GroupView = True
    ReadOnly = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListViewDblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 401
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    Color = clSilver
    ParentBackground = False
    TabOrder = 1
    object MarketNameLabel: TLabel
      Left = 8
      Top = 2
      Width = 385
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
      Width = 385
      Height = 16
      AutoSize = False
    end
    object LastUpdateLabel: TLabel
      Left = 8
      Top = 35
      Width = 224
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
      Left = 238
      Top = 35
      Width = 155
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
  end
end
