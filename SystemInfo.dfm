object SystemInfoForm: TSystemInfoForm
  Left = 0
  Top = 0
  Caption = 'System Info'
  ClientHeight = 861
  ClientWidth = 1384
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Bahnschrift SemiCondensed'
  Font.Style = []
  PopupMenu = PopupMenu
  Position = poDesigned
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 0
    Top = 473
    Width = 1384
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = 8
    ExplicitTop = 468
    ExplicitWidth = 1184
  end
  object ListView: TListView
    Left = 0
    Top = 570
    Width = 1384
    Height = 291
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clSilver
    Columns = <
      item
        Caption = 'Body'
      end
      item
        Caption = 'Type'
      end
      item
        Caption = 'Comment'
      end
      item
        Caption = 'Economy'
      end
      item
        Alignment = taCenter
        Caption = 'Land.'
      end
      item
        Caption = 'Atmosphere'
      end
      item
        Alignment = taRightJustify
        Caption = 'Dist. (Ls)'
      end
      item
        Caption = 'Signals'
      end
      item
        Caption = 'Volcanism'
      end
      item
        Alignment = taRightJustify
        Caption = 'Grav.'
      end
      item
        Alignment = taCenter
        Caption = 'T.Lock'
      end
      item
        Alignment = taCenter
        Caption = 'Terr.'
      end
      item
        Alignment = taRightJustify
        Caption = ' Orb.Incl.'
        Width = 70
      end
      item
        Alignment = taRightJustify
        Caption = 'Rot.Per.'
      end
      item
        Alignment = taRightJustify
        Caption = 'Orb.Per.'
      end
      item
        Alignment = taRightJustify
        Caption = 'S/Axis  (Mm)'
      end>
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu2
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = ListViewClick
    OnCustomDrawItem = ListViewCustomDrawItem
    OnDblClick = ListViewDblClick
    OnMouseDown = ListViewMouseDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1384
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    object SystemNameLabel: TLabel
      Left = 8
      Top = 8
      Width = 351
      Height = 16
      AutoSize = False
      Caption = '--------------------'
      OnClick = SystemNameLabelClick
    end
    object FactionsLabel: TLabel
      Left = 217
      Top = 30
      Width = 313
      Height = 16
      AutoSize = False
      Caption = '----------------------'
    end
    object LastUpdateLabel: TLabel
      Left = 217
      Top = 53
      Width = 209
      Height = 16
      AutoSize = False
      Caption = '-----------------------'
    end
    object SystemAddrLabel: TLabel
      Left = 408
      Top = 8
      Width = 153
      Height = 16
      AutoSize = False
      Caption = '-------------------'
      OnDblClick = SystemAddrLabelDblClick
    end
    object ArchitectLabel: TLabel
      Left = 217
      Top = 8
      Width = 185
      Height = 16
      AutoSize = False
      Caption = '--------------------'
    end
    object PopulationLabel: TLabel
      Left = 8
      Top = 30
      Width = 161
      Height = 16
      AutoSize = False
      Caption = '--------------------'
    end
    object SecurityLabel: TLabel
      Left = 8
      Top = 51
      Width = 161
      Height = 16
      AutoSize = False
      Caption = '------------------------'
    end
    object Label3: TLabel
      Left = 584
      Top = 8
      Width = 49
      Height = 16
      Caption = 'Comment'
    end
    object Label5: TLabel
      Left = 584
      Top = 30
      Width = 70
      Height = 16
      Caption = 'Current Goals'
    end
    object Label7: TLabel
      Left = 584
      Top = 51
      Width = 53
      Height = 16
      Caption = 'Objectives'
    end
    object EDSMScanButton: TButton
      Left = 1011
      Top = 42
      Width = 75
      Height = 25
      Caption = 'EDSM Scan'
      TabOrder = 0
      OnClick = EDSMScanButtonClick
    end
    object CommentEdit: TEdit
      Left = 660
      Top = 5
      Width = 325
      Height = 24
      ParentColor = True
      TabOrder = 1
      OnChange = CommentEditChange
    end
    object SaveDataButton: TButton
      Left = 1011
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 2
      OnClick = SaveDataButtonClick
    end
    object GoalsEdit: TEdit
      Left = 660
      Top = 26
      Width = 325
      Height = 24
      ParentColor = True
      TabOrder = 3
      OnChange = CommentEditChange
    end
    object ObjectivesEdit: TEdit
      Left = 660
      Top = 49
      Width = 325
      Height = 24
      ParentColor = True
      TabOrder = 4
      OnChange = CommentEditChange
    end
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 73
    Width = 1384
    Height = 400
    HorzScrollBar.Smooth = True
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alTop
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clBlack
    Ctl3D = False
    ParentColor = False
    ParentCtl3D = False
    PopupMenu = PopupMenu
    TabOrder = 2
    UseWheelForScrolling = True
    object NoPictureLabel: TLabel
      Left = 22
      Top = 16
      Width = 413
      Height = 16
      Caption = 
        'No picture. Use Windows Snipping Tool to capture (Win + Shift + ' +
        'S) and paste here.'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object SysImage: TImage
      Left = 0
      Top = 0
      Width = 481
      Height = 145
      AutoSize = True
      PopupMenu = PopupMenu
      OnClick = SysImageClick
      OnDblClick = SysImageDblClick
      OnMouseDown = SysImageMouseDown
      OnMouseMove = SysImageMouseMove
      OnMouseUp = SysImageMouseUp
    end
  end
  object InfoPanel2: TPanel
    Left = 0
    Top = 478
    Width = 1384
    Height = 59
    Align = alTop
    BevelOuter = bvNone
    Color = clBlack
    ParentBackground = False
    TabOrder = 3
    object Label1: TLabel
      Left = 6
      Top = 3
      Width = 38
      Height = 19
      Caption = 'Secur.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object SecLabel: TLabel
      Left = 50
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Caption = '00 (00/00)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCrimson
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label2: TLabel
      Left = 132
      Top = 3
      Width = 37
      Height = 19
      Caption = 'Devel.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object DevLabel: TLabel
      Left = 175
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Caption = '00 (00/00)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlueviolet
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label4: TLabel
      Left = 257
      Top = 3
      Width = 31
      Height = 19
      Caption = 'Tech.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object TechLabel: TLabel
      Left = 294
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Caption = '00 (00/00)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRoyalblue
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label6: TLabel
      Left = 376
      Top = 3
      Width = 42
      Height = 19
      Caption = 'Wealth'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object WealthLabel: TLabel
      Left = 424
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Caption = '00 (00/00)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clDarkgoldenrod
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label8: TLabel
      Left = 506
      Top = 3
      Width = 42
      Height = 19
      Caption = 'StdLiv.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object LivLabel: TLabel
      Left = 554
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Caption = '00 (00/00)'
      Color = clNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object PrimaryLabel: TLabel
      Left = 1056
      Top = 6
      Width = 66
      Height = 14
      Caption = 'T2/T3 Primary'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -12
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label11: TLabel
      Left = 802
      Top = 3
      Width = 56
      Height = 19
      Alignment = taRightJustify
      Caption = ' CP:     T2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object CP2Label: TLabel
      Left = 867
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Caption = '00 (00/00)'
      Color = clNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object T2Label: TLabel
      Left = 955
      Top = 3
      Width = 14
      Height = 19
      Caption = 'T3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object CP3Label: TLabel
      Left = 978
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Caption = '00 (00/00)'
      Color = clNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clDeepskyblue
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label10: TLabel
      Left = 6
      Top = 32
      Width = 120
      Height = 19
      Caption = 'System weak links:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object InduLinksLabel1: TLabel
      Left = 272
      Top = 33
      Width = 140
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Alignment = taCenter
      AutoSize = False
      Caption = 'Indu: 0 (0/0)'
      Color = clBlueviolet
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Transparent = False
    end
    object HighLinksLabel1: TLabel
      Left = 412
      Top = 33
      Width = 140
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Alignment = taCenter
      AutoSize = False
      Caption = 'High: 0 (0/0)'
      Color = clRoyalblue
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Transparent = False
    end
    object RefiLinksLabel1: TLabel
      Left = 548
      Top = 33
      Width = 140
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Alignment = taCenter
      AutoSize = False
      Caption = 'Refi: 0 (0/0)'
      Color = clDarkorange
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Transparent = False
    end
    object AgriLinksLabel1: TLabel
      Left = 825
      Top = 33
      Width = 140
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Alignment = taCenter
      AutoSize = False
      Caption = 'Agri: 0 (0/0)'
      Color = clYellowgreen
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Transparent = False
    end
    object ExtrLinksLabel1: TLabel
      Left = 685
      Top = 33
      Width = 140
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Alignment = taCenter
      AutoSize = False
      Caption = 'Extr: 0 (0/0)'
      Color = clSaddlebrown
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Transparent = False
    end
    object TourLinksLabel1: TLabel
      Left = 965
      Top = 33
      Width = 140
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Alignment = taCenter
      AutoSize = False
      Caption = 'Tour: 0 (0/0)'
      Color = clGold
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Transparent = False
    end
    object MiliLinksLabel1: TLabel
      Left = 132
      Top = 33
      Width = 140
      Height = 19
      Hint = 'Current / incl. In Progress / incl. Planned'
      Alignment = taCenter
      AutoSize = False
      Caption = 'Mili: 0 (0/0)'
      Color = clFirebrick
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Transparent = False
    end
    object SlotsLabel: TLabel
      Left = 634
      Top = 3
      Width = 109
      Height = 19
      Hint = 'Free construction slots, click to change'
      Caption = 'Slots '#8226#9898'-- '#55356#57325'--'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = SlotsLabelClick
    end
    object Label12: TLabel
      Left = 1161
      Top = 6
      Width = 55
      Height = 16
      Caption = 'Economies'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      OnClick = Label12Click
    end
    object Label13: TLabel
      Left = 1250
      Top = 6
      Width = 33
      Height = 16
      Caption = 'Filters'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      OnClick = Label13Click
    end
    object Label14: TLabel
      Left = 1162
      Top = 34
      Width = 43
      Height = 16
      Caption = 'Up Links'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      OnClick = Label14Click
    end
    object EconomiesCheck: TCheckBox
      Left = 1141
      Top = 6
      Width = 19
      Height = 17
      TabOrder = 0
      OnClick = EconomiesCheckClick
    end
    object FiltersCheck: TCheckBox
      Left = 1230
      Top = 6
      Width = 19
      Height = 17
      TabOrder = 1
      OnClick = FiltersCheckClick
    end
    object ShowUpLinksCheck: TCheckBox
      Left = 1141
      Top = 34
      Width = 19
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = ShowUpLinksCheckClick
    end
  end
  object FiltersPanel: TPanel
    Left = 0
    Top = 537
    Width = 1384
    Height = 33
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
    TabOrder = 4
    Visible = False
    object Label9: TLabel
      Left = 8
      Top = 8
      Width = 27
      Height = 16
      Caption = 'Filter'
    end
    object PlannedCheck: TCheckBox
      Left = 634
      Top = 8
      Width = 72
      Height = 17
      Caption = 'planned'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = BodiesCheckClick
    end
    object FilterEdit: TComboBox
      Left = 40
      Top = 5
      Width = 194
      Height = 24
      DropDownCount = 20
      Sorted = True
      TabOrder = 1
      OnChange = FilterEditChange
    end
    object ClearFilterButton: TButton
      Left = 235
      Top = 5
      Width = 20
      Height = 24
      Caption = 'X'
      TabOrder = 2
      OnClick = ClearFilterButtonClick
    end
    object BodiesCheck: TCheckBox
      Left = 272
      Top = 8
      Width = 81
      Height = 17
      Caption = 'Bodies'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 3
      OnClick = BodiesCheckClick
    end
    object StationsCheck: TCheckBox
      Left = 359
      Top = 8
      Width = 90
      Height = 17
      Caption = 'Stations:'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 4
      OnClick = BodiesCheckClick
    end
    object InProgressCheck: TCheckBox
      Left = 532
      Top = 8
      Width = 89
      Height = 17
      Caption = '- in progress'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 5
      OnClick = BodiesCheckClick
    end
    object FinishedCheck: TCheckBox
      Left = 449
      Top = 8
      Width = 75
      Height = 17
      Caption = '- finished'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 6
      OnClick = BodiesCheckClick
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 712
    Top = 136
    object FullPictureMenuItem: TMenuItem
      Caption = 'Full Window'
      OnClick = SysImageDblClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PastePictureMenuItem: TMenuItem
      Caption = 'Paste Picture'
      ShortCut = 16470
      OnClick = PastePictureMenuItemClick
    end
    object SavePictureMenuItem: TMenuItem
      Caption = 'Save Picture'
      ShortCut = 16467
      OnClick = SavePictureMenuItemClick
    end
    object EditPictureMenuItem: TMenuItem
      Caption = 'Edit Picture'
      OnClick = EditPictureMenuItemClick
    end
    object ReloadPictureMenuItem: TMenuItem
      Caption = 'Refresh'
      OnClick = ReloadPictureMenuItemClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ClearPictureMenuItem: TMenuItem
      Caption = 'Clear Picture'
      OnClick = ClearPictureMenuItemClick
    end
  end
  object PopupMenu2: TPopupMenu
    OnPopup = PopupMenu2Popup
    Left = 1000
    Top = 560
    object AddConstructionMenuItem: TMenuItem
      Caption = 'Add Construction'
      OnClick = AddConstructionMenuItemClick
    end
    object QuickAddOrbitalSubMenu: TMenuItem
      Caption = 'Quick Add Orbital'
    end
    object QuickAddSurfaceSubMenu: TMenuItem
      Caption = 'Quick Add Surface'
    end
    object QuickAddAsSubMenu: TMenuItem
      Caption = 'Quick Add as'
      object QuickAddAsPlannedMenuItem: TMenuItem
        AutoCheck = True
        Caption = 'Planned'
        Checked = True
        RadioItem = True
      end
      object QuickAddAsInProgressMenuItem: TMenuItem
        AutoCheck = True
        Caption = 'In Progress'
        RadioItem = True
      end
      object QuickAddAsFinishedMenuItem: TMenuItem
        AutoCheck = True
        Caption = 'Finished'
        RadioItem = True
      end
    end
    object SetTypeSubMenu: TMenuItem
      Caption = 'Set Type'
    end
    object DeleteConstructionMenuItem: TMenuItem
      Caption = 'Delete Construction'
      OnClick = DeleteConstructionMenuItemClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object AddSignalsSubMenu: TMenuItem
      Caption = 'Signals'
      object AddBioSignalsMenuItem: TMenuItem
        Caption = 'Add Biological'
        OnClick = AddBioSignalsMenuItemClick
      end
      object AddGeoSignalsMenuItem: TMenuItem
        Tag = 1
        Caption = 'Add Geological'
        OnClick = AddBioSignalsMenuItemClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Reset1: TMenuItem
        Tag = -1
        Caption = 'Clear'
        OnClick = AddBioSignalsMenuItemClick
      end
    end
    object ResourceReserveSubMenu: TMenuItem
      Caption = 'Resource Reserve'
      object PristineReserveMenuItem: TMenuItem
        Caption = 'Pristine'
        OnClick = PristineReserveMenuItemClick
      end
      object Major1: TMenuItem
        Tag = 1
        Caption = 'Major'
        OnClick = PristineReserveMenuItemClick
      end
      object Low1: TMenuItem
        Tag = 2
        Caption = 'Low'
        OnClick = PristineReserveMenuItemClick
      end
      object Depleted1: TMenuItem
        Tag = 3
        Caption = 'Depleted'
        OnClick = PristineReserveMenuItemClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Reset2: TMenuItem
        Tag = -1
        Caption = 'Clear'
        OnClick = PristineReserveMenuItemClick
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object SetAsActiveMenuItem: TMenuItem
      Caption = 'Set As Active'
      OnClick = SetAsActiveMenuItemClick
    end
    object GroupAddRemoveMenuItem: TMenuItem
      Caption = 'Group Add/Remove'
      OnClick = GroupAddRemoveMenuItemClick
    end
    object MarketInfoMenuItem: TMenuItem
      Caption = 'Market Info'
      OnClick = MarketInfoMenuItemClick
    end
    object MarketHistoryMenuItem: TMenuItem
      Caption = 'Market History'
      OnClick = MarketHistoryMenuItemClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object CopyAllMenuItem: TMenuItem
      Caption = 'Copy All'
      OnClick = CopyAllMenuItemClick
    end
  end
end
