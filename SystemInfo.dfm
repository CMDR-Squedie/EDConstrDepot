object SystemInfoForm: TSystemInfoForm
  Left = 0
  Top = 0
  Caption = 'System Info'
  ClientHeight = 861
  ClientWidth = 1184
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Bahnschrift SemiCondensed'
  Font.Style = []
  PopupMenu = PopupMenu
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 0
    Top = 473
    Width = 1184
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = 8
    ExplicitTop = 468
  end
  object ListView: TListView
    Left = 0
    Top = 511
    Width = 1184
    Height = 350
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clSilver
    Columns = <
      item
        Caption = 'Body'
        MinWidth = 150
      end
      item
        Caption = 'Type'
      end
      item
        Caption = 'Comment'
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
        MinWidth = 100
      end
      item
        Alignment = taRightJustify
        Caption = 'T.Lock'
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
    ExplicitTop = 495
    ExplicitHeight = 366
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1184
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
      Height = 20
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
      Height = 22
      ParentColor = True
      TabOrder = 3
      OnChange = CommentEditChange
    end
    object ObjectivesEdit: TEdit
      Left = 660
      Top = 49
      Width = 325
      Height = 20
      ParentColor = True
      TabOrder = 4
      OnChange = CommentEditChange
    end
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 73
    Width = 1184
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
    ExplicitTop = 57
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
  object Panel2: TPanel
    Left = 0
    Top = 478
    Width = 1184
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    Color = clBlack
    ParentBackground = False
    TabOrder = 3
    ExplicitTop = 457
    object Label1: TLabel
      Left = 6
      Top = 6
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
      Top = 6
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
      Top = 6
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
      Top = 6
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
      Top = 6
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
      Top = 6
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
      Top = 6
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
      Top = 6
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
      Top = 6
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
      Top = 6
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
      Left = 1020
      Top = 9
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
      Left = 742
      Top = 6
      Width = 79
      Height = 19
      Caption = 'Avail. CP:  T2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object CP2Label: TLabel
      Left = 831
      Top = 6
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
      Left = 917
      Top = 6
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
      Left = 942
      Top = 6
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
    Left = 816
    Top = 504
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
    object N3: TMenuItem
      Caption = '-'
    end
    object MarketInfoMenuItem: TMenuItem
      Caption = 'Market Info'
      OnClick = MarketInfoMenuItemClick
    end
    object CopyAllMenuItem: TMenuItem
      Caption = 'Copy All'
      OnClick = CopyAllMenuItemClick
    end
  end
end
