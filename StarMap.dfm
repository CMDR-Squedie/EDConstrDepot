object StarMapForm: TStarMapForm
  Left = 0
  Top = 0
  Caption = 'Colonies Map (2D Projection)'
  ClientHeight = 861
  ClientWidth = 1284
  Color = 1708294
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Bahnschrift SemiCondensed'
  Font.Style = []
  KeyPreview = True
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 16
  object PaintBox: TPaintBox
    Left = 0
    Top = 70
    Width = 1284
    Height = 791
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
    ExplicitTop = 32
    ExplicitWidth = 1184
    ExplicitHeight = 826
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1284
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    Color = clSilver
    ParentBackground = False
    TabOrder = 0
    object InnerPanel1: TPanel
      Left = 0
      Top = 0
      Width = 679
      Height = 35
      BevelOuter = bvNone
      Color = clSilver
      ParentBackground = False
      TabOrder = 0
      object Label1: TLabel
        Left = 5
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
        Left = 114
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
      object ProjectionXCombo: TComboBox
        Left = 63
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
        Left = 169
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
        Left = 226
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
        Left = 304
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
        Left = 382
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
        Left = 451
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
        Left = 598
        Top = 5
        Width = 79
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
    end
    object InnerPanel2: TPanel
      Left = 0
      Top = 35
      Width = 1142
      Height = 35
      BevelOuter = bvNone
      Color = clSilver
      ParentBackground = False
      TabOrder = 1
      object Label3: TLabel
        Left = 4
        Top = 9
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
        Left = 173
        Top = 9
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
        Left = 342
        Top = 9
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
      object TaskGroupCombo: TComboBox
        Left = 64
        Top = 6
        Width = 102
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Bahnschrift SemiCondensed'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = TaskGroupComboChange
      end
      object InfoCombo: TComboBox
        Left = 198
        Top = 6
        Width = 137
        Height = 24
        Style = csDropDownList
        DropDownCount = 15
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Bahnschrift SemiCondensed'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = TaskGroupComboChange
        Items.Strings = (
          '( none )'
          
            #55357#56999' Constructions                                                ' +
            '       C1'
          
            #55357#56999' Constructions+Goals                                          ' +
            '   C2'
          
            #55357#56421' Maj. Factions                                                ' +
            '        MF'
          
            #9203'  Last Visit                                                   ' +
            '             LV'
          
            #9898#8226'Large Ports                                                   ' +
            '        LP'
          
            #55356#57325' Large Refineries                                             ' +
            '      LR'
          
            #55356#57150' Large Agriculture                                            ' +
            '      LA'
          
            #55357#56960' Shipyards                                                    ' +
            '         SY'
          
            #9878' Interstellar Factors                                          ' +
            '    IF'
          
            #55356#57104' Univ. Cartographics                                          ' +
            '   UC'
          
            #55356#57101' Earthlike/WW/Rings                                           ' +
            '  EW'
          
            #55356#57286' System Score                                                 ' +
            '        SC'
          
            #55357#56658' Colonization History                                         ' +
            '        AH'
          '')
      end
      object LinkStyleCombo: TComboBox
        Left = 402
        Top = 6
        Width = 40
        Height = 24
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Bahnschrift SemiCondensed'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnChange = LinkStyleComboChange
        Items.Strings = (
          'A'
          'B'
          'C'
          'D'
          'E'
          'off')
      end
      object ElevationCheck: TCheckBox
        Left = 452
        Top = 10
        Width = 69
        Height = 17
        Caption = 'Elevation'
        TabOrder = 3
        OnClick = ElevationCheckClick
      end
      object ElevFollowSelCheck: TCheckBox
        Left = 639
        Top = 12
        Width = 90
        Height = 17
        Caption = '- follow sel.'
        TabOrder = 4
        Visible = False
        OnClick = ElevationCheckClick
      end
      object ColonModeCheck: TCheckBox
        Left = 527
        Top = 10
        Width = 81
        Height = 17
        Caption = 'Colon.Mode'
        TabOrder = 5
        OnClick = ColonModeCheckClick
      end
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
      object MapKey6MenuItem: TMenuItem
        Tag = 6
        Caption = 'Key 6 (purple)'
        OnClick = MapKey1MenuItemClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MapKeyClearMenuItem: TMenuItem
        Caption = 'Clear'
        OnClick = MapKey1MenuItemClick
      end
    end
    object ColonizationSubMenu: TMenuItem
      Caption = 'Colonization'
      object ShowInListMenuItem: TMenuItem
        Caption = 'List Neighbours'
        OnClick = ShowInListMenuItemClick
      end
      object AddNeighboursEDSMMenuItem: TMenuItem
        Caption = 'Add Neighbours (EDSM)'
        OnClick = AddNeighboursEDSMMenuItemClick
      end
      object Add2HopSystemsEDSMMenuItem: TMenuItem
        Caption = 'Add 2-Hop Systems (EDSM)'
        OnClick = Add2HopSystemsEDSMMenuItemClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object AddToTargetsMenuItem: TMenuItem
        Caption = 'Add To Targets'
        OnClick = AddToTargetsMenuItemClick
      end
    end
    object RouteSubMenu: TMenuItem
      Caption = 'Route'
      object StartRouteMenuItem: TMenuItem
        Caption = 'Start'
        OnClick = StartRouteMenuItemClick
      end
      object StopRouteMenuItem: TMenuItem
        Caption = 'Stop'
        OnClick = StopRouteMenuItemClick
      end
      object ClearRouteMenuItem: TMenuItem
        Caption = 'Clear'
        OnClick = ClearRouteMenuItemClick
      end
      object HideDistancesMenuItem: TMenuItem
        AutoCheck = True
        Caption = 'Hide Distances'
        OnClick = HideDistancesMenuItemClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
    end
    object FindSystemMenuItem: TMenuItem
      Caption = 'Go To System...'
      OnClick = FindSystemMenuItemClick
    end
    object FindBodiesMenuItem: TMenuItem
      Caption = 'Find Bodies...'
      OnClick = FindBodiesMenuItemClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object CopySystemNameMenuItem: TMenuItem
      Caption = 'Copy System Name'
      OnClick = CopySystemNameMenuItemClick
    end
  end
  object HistTimer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = HistTimerTimer
    Left = 304
    Top = 144
  end
end
