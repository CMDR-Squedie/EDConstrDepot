object StarMapForm: TStarMapForm
  Left = 0
  Top = 0
  Caption = 'Colonies Map (2D Projection)'
  ClientHeight = 861
  ClientWidth = 1184
  Color = 1708294
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Bahnschrift SemiCondensed'
  Font.Style = []
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  TextHeight = 16
  object PaintBox: TPaintBox
    Left = 0
    Top = 35
    Width = 1184
    Height = 826
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -13
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu
    OnClick = PaintBoxClick
    OnDblClick = PaintBoxDblClick
    OnMouseDown = PaintBoxMouseDown
    OnMouseMove = PaintBoxMouseMove
    OnMouseUp = PaintBoxMouseUp
    OnPaint = PaintBoxPaint
    ExplicitLeft = 160
    ExplicitTop = 128
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1184
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    Color = clSilver
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 8
      Width = 57
      Height = 16
      Caption = 'Horz. Proj.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 121
      Top = 8
      Width = 53
      Height = 16
      Caption = 'Vert. Proj.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 716
      Top = 8
      Width = 58
      Height = 16
      Caption = 'Task Group:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 900
      Top = 8
      Width = 22
      Height = 16
      Caption = 'Info:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 1078
      Top = 8
      Width = 58
      Height = 16
      Caption = 'Star Lanes:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object ProjectionXCombo: TComboBox
      Left = 70
      Top = 5
      Width = 41
      Height = 24
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = 'X'
      OnChange = ProjectionXComboChange
      Items.Strings = (
        'X'
        'Y'
        'Z'
        '-X'
        '-Y'
        '-Z')
    end
    object ProjectionYCombo: TComboBox
      Left = 178
      Top = 5
      Width = 41
      Height = 24
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ItemIndex = 5
      ParentFont = False
      TabOrder = 1
      Text = '-Z'
      OnChange = ProjectionXComboChange
      Items.Strings = (
        'X'
        'Y'
        'Z'
        '-X'
        '-Y'
        '-Z')
    end
    object MajorColCheck: TCheckBox
      Left = 240
      Top = 9
      Width = 74
      Height = 17
      Caption = 'Major Col.'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = MajorColCheckClick
    end
    object MinorColCheck: TCheckBox
      Left = 320
      Top = 9
      Width = 74
      Height = 17
      Caption = 'Minor Col.'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = MajorColCheckClick
    end
    object TargetsCheck: TCheckBox
      Left = 400
      Top = 9
      Width = 65
      Height = 17
      Caption = 'Targets'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = MajorColCheckClick
    end
    object OtherSysCheck: TCheckBox
      Left = 471
      Top = 9
      Width = 149
      Height = 17
      Caption = 'Other Systems, min.pop:'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = MajorColCheckClick
    end
    object MinPopCombo: TComboBox
      Left = 626
      Top = 5
      Width = 78
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Text = '1 000 000'
      OnChange = MinPopComboChange
      Items.Strings = (
        '0'
        '1'
        '100 000'
        '1 000 000'
        '10 000 000'
        '100 000 000'
        '1 000 000 000')
    end
    object TaskGroupCombo: TComboBox
      Left = 780
      Top = 5
      Width = 102
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnChange = TaskGroupComboChange
    end
    object InfoCombo: TComboBox
      Left = 928
      Top = 5
      Width = 137
      Height = 24
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnChange = TaskGroupComboChange
      Items.Strings = (
        '( none )'
        'Constructions'
        'Maj. Factions'
        'Earthlike/WW/Rings')
    end
    object LinkStyleCombo: TComboBox
      Left = 1142
      Top = 5
      Width = 40
      Height = 24
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ItemIndex = 0
      ParentFont = False
      TabOrder = 9
      Text = 'A'
      OnChange = LinkStyleComboChange
      Items.Strings = (
        'A'
        'B'
        'C'
        'D'
        'off')
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 632
    Top = 232
    object SystemInfoMenuItem: TMenuItem
      Caption = 'System Info'
      OnClick = PaintBoxDblClick
    end
    object MapKeySubMenu: TMenuItem
      Caption = 'Map Key'
      object MapKey1MenuItem: TMenuItem
        Tag = 1
        Caption = 'Key 1 (gray)'
        OnClick = MapKey1MenuItemClick
      end
      object MapKey2MenuItem: TMenuItem
        Tag = 2
        Caption = 'Key 2 (red)'
        OnClick = MapKey1MenuItemClick
      end
      object MapKey3MenuItem: TMenuItem
        Tag = 3
        Caption = 'Key 3 (orange)'
        OnClick = MapKey1MenuItemClick
      end
      object MapKey4MenuItem: TMenuItem
        Tag = 4
        Caption = 'Key 4 (green)'
        OnClick = MapKey1MenuItemClick
      end
      object MapKey5MenuItem: TMenuItem
        Tag = 5
        Caption = 'Key 5 (blue)'
        OnClick = MapKey1MenuItemClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MapKeyClearMenuItem: TMenuItem
        Tag = -1
        Caption = 'Clear'
        OnClick = MapKey1MenuItemClick
      end
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object CopySystemNameMenuItem: TMenuItem
      Caption = 'Copy System Name'
      OnClick = CopySystemNameMenuItemClick
    end
  end
end
