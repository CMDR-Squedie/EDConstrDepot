object MaterialListForm: TMaterialListForm
  Left = 0
  Top = 0
  Caption = 'Constructions Materials'
  ClientHeight = 588
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Bahnschrift SemiCondensed'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 47
    Align = alTop
    BevelOuter = bvNone
    Color = 12105912
    ParentBackground = False
    TabOrder = 0
    object StationLabel: TLabel
      Left = 8
      Top = 6
      Width = 291
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object EstCargoLabel: TLabel
      Left = 8
      Top = 26
      Width = 137
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object CalcCargoLabel: TLabel
      Left = 170
      Top = 26
      Width = 137
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object CopyButton: TButton
      Left = 329
      Top = 4
      Width = 56
      Height = 20
      Caption = 'Copy'
      TabOrder = 0
      OnClick = CopyButtonClick
    end
    object PasteButton: TButton
      Left = 267
      Top = 4
      Width = 56
      Height = 20
      Caption = 'Paste'
      TabOrder = 1
      Visible = False
      OnClick = PasteButtonClick
    end
    object JSONButton: TButton
      Left = 329
      Top = 25
      Width = 56
      Height = 20
      Caption = 'JSON'
      TabOrder = 2
      Visible = False
      OnClick = JSONButtonClick
    end
  end
  object ListView: TListView
    Left = 0
    Top = 47
    Width = 393
    Height = 541
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clSilver
    Columns = <
      item
        Caption = 'Name'
        MinWidth = 200
        Width = 200
      end
      item
        Alignment = taRightJustify
        Caption = 'Request'
      end
      item
        Alignment = taRightJustify
        Caption = 'Min'
        MinWidth = 50
      end
      item
        Alignment = taRightJustify
        Caption = 'Max'
        MinWidth = 50
      end>
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = ListViewDblClick
    OnKeyUp = ListViewKeyUp
    ExplicitTop = 57
    ExplicitHeight = 531
  end
end
