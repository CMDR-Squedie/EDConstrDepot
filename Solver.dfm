object SolverForm: TSolverForm
  Left = 0
  Top = 0
  Caption = 'Colony Planner'
  ClientHeight = 761
  ClientWidth = 968
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
    Top = 313
    Width = 968
    Height = 448
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clSilver
    Columns = <
      item
        Caption = 'No.'
        Width = 35
      end
      item
        Caption = ' '
        Width = 35
      end
      item
        Caption = 'Construction'
        Width = 250
      end
      item
        Alignment = taCenter
        Caption = 'CP2'
      end
      item
        Alignment = taCenter
        Caption = 'CP3'
      end
      item
        Alignment = taRightJustify
        Caption = 'Dev.'
      end
      item
        Alignment = taRightJustify
        Caption = 'Tech.'
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
        Caption = 'Sec.'
      end
      item
        Alignment = taRightJustify
        Caption = 'Score'
      end
      item
        Caption = 'Economy Infl.'
        Width = 100
      end
      item
        Caption = ' '
        Width = 100
      end>
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawItem = ListViewCustomDrawItem
    OnDblClick = ListViewDblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 968
    Height = 313
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 30
      Top = 75
      Width = 60
      Height = 16
      Alignment = taRightJustify
      Caption = 'Ports Goal *'
    end
    object Label2: TLabel
      Left = 156
      Top = 148
      Width = 71
      Height = 16
      Alignment = taRightJustify
      Caption = '- ports added:'
    end
    object NewPortsLabel: TLabel
      Left = 233
      Top = 146
      Width = 7
      Height = 18
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 13
      Top = 201
      Width = 409
      Height = 32
      AutoSize = False
      Caption = 
        '* Ports are priority, T3 ports are built before T2 (cost increas' +
        'es faster), orbital installations are preferred for CP2, settlem' +
        'ents are preferred for CP3.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiLight SemiConde'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object WarnLabel: TLabel
      Left = 96
      Top = 173
      Width = 334
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFirebrick
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 40
      Top = 173
      Width = 50
      Height = 16
      Alignment = taRightJustify
      Caption = 'Warnings:'
    end
    object Label5: TLabel
      Left = -1
      Top = 148
      Width = 91
      Height = 16
      Alignment = taRightJustify
      Caption = 'No. of T2/T3 ports:'
    end
    object AllPortsLabel: TLabel
      Left = 97
      Top = 146
      Width = 7
      Height = 18
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 468
      Top = 34
      Width = 66
      Height = 16
      Caption = 'Development'
    end
    object Label8: TLabel
      Left = 468
      Top = 64
      Width = 55
      Height = 16
      Caption = 'Technology'
    end
    object Label9: TLabel
      Left = 468
      Top = 156
      Width = 43
      Height = 16
      Caption = 'Security'
    end
    object Label13: TLabel
      Left = 468
      Top = 95
      Width = 33
      Height = 16
      Caption = 'Wealth'
    end
    object Label14: TLabel
      Left = 468
      Top = 126
      Width = 63
      Height = 16
      Caption = 'Std of Living'
    end
    object Label10: TLabel
      Left = 13
      Top = 277
      Width = 417
      Height = 35
      AutoSize = False
      Caption = 
        'Hint: Add primary port, vital industries and station service unl' +
        'ocks (eg. UC) as planned constructions before using this solver.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiLight SemiConde'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label11: TLabel
      Left = 700
      Top = 12
      Width = 32
      Height = 16
      Caption = 'Result'
    end
    object DevLabel: TLabel
      Left = 723
      Top = 34
      Width = 11
      Height = 16
      Alignment = taRightJustify
      Caption = ' - '
    end
    object TechLabel: TLabel
      Left = 723
      Top = 62
      Width = 11
      Height = 16
      Alignment = taRightJustify
      Caption = ' - '
    end
    object WealthLabel: TLabel
      Left = 723
      Top = 94
      Width = 11
      Height = 16
      Alignment = taRightJustify
      Caption = ' - '
    end
    object StdLivLabel: TLabel
      Left = 723
      Top = 125
      Width = 11
      Height = 16
      Alignment = taRightJustify
      Caption = ' - '
    end
    object SecLabel: TLabel
      Left = 723
      Top = 155
      Width = 11
      Height = 16
      Alignment = taRightJustify
      Caption = ' - '
    end
    object Label6: TLabel
      Left = 96
      Top = 127
      Width = 361
      Height = 11
      AutoSize = False
      Caption = 'Hint: Use '#39'99'#39' to maximize specific ports number.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiLight SemiConde'
      Font.Style = [fsItalic]
      ParentFont = False
      Visible = False
      WordWrap = True
    end
    object Label12: TLabel
      Left = 466
      Top = 221
      Width = 113
      Height = 16
      Alignment = taRightJustify
      Caption = 'Missing Requirements'
    end
    object Label15: TLabel
      Left = 329
      Top = 148
      Width = 33
      Height = 16
      Alignment = taRightJustify
      Caption = 'Score:'
    end
    object ScoreLabel: TLabel
      Left = 369
      Top = 146
      Width = 7
      Height = 18
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label16: TLabel
      Left = 13
      Top = 239
      Width = 409
      Height = 32
      AutoSize = False
      Caption = 
        '** Continuous stats balancing solver, no operations research sol' +
        'ver is used. You may get suboptimal results if you aim to maximi' +
        'ze multiple system stats.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiLight SemiConde'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label17: TLabel
      Left = 734
      Top = 219
      Width = 60
      Height = 16
      Alignment = taRightJustify
      Caption = 'Slots Usage'
    end
    object SurfSlotsEdit: TLabeledEdit
      Left = 360
      Top = 11
      Width = 41
      Height = 26
      Alignment = taRightJustify
      EditLabel.Width = 69
      EditLabel.Height = 26
      EditLabel.Caption = 'Surface Slots'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      LabelPosition = lpLeft
      ParentFont = False
      TabOrder = 2
      Text = ''
    end
    object GoalT3OrbEdit: TLabeledEdit
      Left = 97
      Top = 101
      Width = 25
      Height = 26
      Alignment = taRightJustify
      EditLabel.Width = 59
      EditLabel.Height = 26
      EditLabel.Caption = '- Orbital: T3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      LabelPosition = lpLeft
      ParentFont = False
      TabOrder = 7
      Text = ''
      OnChange = GoalT3SurfEditChange
    end
    object SolveButton: TButton
      Left = 882
      Top = 274
      Width = 68
      Height = 25
      Caption = 'Solve'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiBold SemiConden'
      Font.Style = []
      ParentFont = False
      TabOrder = 17
      OnClick = SolveButtonClick
    end
    object GoalCombo: TComboBox
      Left = 96
      Top = 72
      Width = 305
      Height = 24
      Style = csDropDownList
      ItemIndex = 3
      TabOrder = 5
      Text = 'no specific goal'
      Items.Strings = (
        'maximize no. of T3 Orbital Ports'
        'maximize no. of T2 Orbital Ports'
        'specific no. of ports:'
        'no specific goal')
    end
    object GoalT2OrbEdit: TLabeledEdit
      Left = 147
      Top = 101
      Width = 25
      Height = 26
      Alignment = taRightJustify
      EditLabel.Width = 11
      EditLabel.Height = 26
      EditLabel.Caption = 'T2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      LabelPosition = lpLeft
      ParentFont = False
      TabOrder = 8
      Text = ''
      OnChange = GoalT3SurfEditChange
    end
    object OrbSlotsEdit: TLabeledEdit
      Left = 97
      Top = 12
      Width = 41
      Height = 26
      Alignment = taRightJustify
      EditLabel.Width = 63
      EditLabel.Height = 26
      EditLabel.Caption = 'Orbital Slots'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      LabelPosition = lpLeft
      ParentFont = False
      TabOrder = 0
      Text = ''
    end
    object AsterSlotsEdit: TLabeledEdit
      Left = 224
      Top = 11
      Width = 41
      Height = 26
      Alignment = taRightJustify
      EditLabel.Width = 74
      EditLabel.Height = 26
      EditLabel.Caption = '- asteroid only'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      LabelPosition = lpLeft
      ParentFont = False
      TabOrder = 1
      Text = ''
    end
    object GoalT3SurfEdit: TLabeledEdit
      Left = 325
      Top = 102
      Width = 25
      Height = 26
      Alignment = taRightJustify
      EditLabel.Width = 68
      EditLabel.Height = 26
      EditLabel.Caption = ' - Surface: T3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      LabelPosition = lpLeft
      ParentFont = False
      TabOrder = 6
      Text = ''
      OnChange = GoalT3SurfEditChange
    end
    object InitialCP2Edit: TLabeledEdit
      Left = 97
      Top = 42
      Width = 41
      Height = 26
      Alignment = taRightJustify
      EditLabel.Width = 61
      EditLabel.Height = 26
      EditLabel.Caption = 'Initial CP: T2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      LabelPosition = lpLeft
      ParentFont = False
      TabOrder = 3
      Text = ''
    end
    object InitialCP3Edit: TLabeledEdit
      Left = 224
      Top = 40
      Width = 42
      Height = 26
      Alignment = taRightJustify
      EditLabel.Width = 19
      EditLabel.Height = 26
      EditLabel.Caption = '- T3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      LabelPosition = lpLeft
      ParentFont = False
      TabOrder = 4
      Text = ''
    end
    object DevTrackBar: TTrackBar
      Left = 540
      Top = 34
      Width = 150
      Height = 30
      Ctl3D = True
      Max = 20
      ParentCtl3D = False
      TabOrder = 10
      OnChange = TechTrackBarChange
    end
    object TechTrackBar: TTrackBar
      Left = 540
      Top = 61
      Width = 150
      Height = 28
      Max = 20
      TabOrder = 11
      OnChange = TechTrackBarChange
    end
    object SecTrackBar: TTrackBar
      Left = 540
      Top = 153
      Width = 150
      Height = 32
      Max = 20
      TabOrder = 14
      OnChange = TechTrackBarChange
    end
    object WealthTrackBar: TTrackBar
      Left = 540
      Top = 92
      Width = 150
      Height = 32
      Max = 20
      TabOrder = 12
      OnChange = TechTrackBarChange
    end
    object StdLivTrackBar: TTrackBar
      Left = 540
      Top = 123
      Width = 150
      Height = 32
      Max = 20
      TabOrder = 13
      OnChange = TechTrackBarChange
    end
    object BalStatsCheck: TCheckBox
      Left = 461
      Top = 11
      Width = 169
      Height = 17
      Caption = 'Balance System Stats **:'
      TabOrder = 9
    end
    object AllowOutpostsCheck: TCheckBox
      Left = 558
      Top = 191
      Width = 85
      Height = 17
      Caption = '- T1 Ports'
      TabOrder = 15
    end
    object AllowHubsCheck: TCheckBox
      Left = 468
      Top = 191
      Width = 76
      Height = 18
      Caption = 'Allow Hubs'
      TabOrder = 16
    end
    object EcoInflCheckList: TCheckListBox
      Left = 797
      Top = 34
      Width = 153
      Height = 147
      AllowGrayed = True
      ItemHeight = 17
      TabOrder = 18
      OnClickCheck = EcoInflCheckListClickCheck
    end
    object EcoInflCheck: TCheckBox
      Left = 797
      Top = 11
      Width = 169
      Height = 17
      Caption = 'Limit Econ. Influences To:'
      TabOrder = 19
    end
    object ResetButton: TButton
      Left = 734
      Top = 274
      Width = 60
      Height = 25
      Caption = 'Reset'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      TabOrder = 20
      OnClick = ResetButtonClick
    end
    object SaveButton: TButton
      Left = 808
      Top = 274
      Width = 64
      Height = 25
      Caption = 'Save'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      TabOrder = 21
      OnClick = SaveButtonClick
    end
    object MaxInflEdit: TLabeledEdit
      Left = 917
      Top = 186
      Width = 33
      Height = 24
      Alignment = taRightJustify
      EditLabel.Width = 112
      EditLabel.Height = 24
      EditLabel.Caption = #55357#57237' - max. infl. in a type'
      LabelPosition = lpLeft
      TabOrder = 22
      Text = ''
    end
    object GoalT1SurfEdit: TLabeledEdit
      Left = 376
      Top = 102
      Width = 25
      Height = 26
      Alignment = taRightJustify
      EditLabel.Width = 9
      EditLabel.Height = 26
      EditLabel.Caption = 'T1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      LabelPosition = lpLeft
      ParentFont = False
      TabOrder = 23
      Text = ''
      OnChange = GoalT3SurfEditChange
    end
    object GoalT1OrbEdit: TLabeledEdit
      Left = 198
      Top = 102
      Width = 25
      Height = 26
      Alignment = taRightJustify
      EditLabel.Width = 9
      EditLabel.Height = 26
      EditLabel.Caption = 'T1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      LabelPosition = lpLeft
      ParentFont = False
      TabOrder = 24
      Text = ''
      OnChange = GoalT3SurfEditChange
    end
    object DependCombo: TComboBox
      Left = 586
      Top = 217
      Width = 122
      Height = 24
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 25
      Text = 'display only'
      Items.Strings = (
        'display only'
        'automatically add'
        'exclude stations')
    end
    object AllowPortsCheck: TCheckBox
      Left = 649
      Top = 191
      Width = 96
      Height = 17
      Caption = '- T2/T3 Ports'
      TabOrder = 26
    end
    object SlotsCombo: TComboBox
      Left = 797
      Top = 216
      Width = 153
      Height = 24
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 27
      Text = 'no policy'
      Items.Strings = (
        'no policy'
        'balance orb./surf.'
        'alternate orb./surf.'
        'orbital first'
        'surface first'
        '')
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 616
    Top = 408
    object AddToSystemMenuItem: TMenuItem
      Caption = 'Add To System'
      OnClick = AddToSystemMenuItemClick
    end
    object Alternatives1: TMenuItem
      Caption = 'Alternatives'
      OnClick = ListViewDblClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object CopyAllMenuItem: TMenuItem
      Caption = 'Copy All'
      OnClick = CopyAllMenuItemClick
    end
  end
end
