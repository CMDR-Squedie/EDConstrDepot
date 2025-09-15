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
  Position = poDesigned
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 0
    Top = 500
    Width = 1384
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = 8
    ExplicitTop = 468
    ExplicitWidth = 1184
  end
  object NextPictLabel: TLabel
    Left = 0
    Top = 81
    Width = 1384
    Height = 19
    Align = alTop
    Alignment = taCenter
    Caption = '( next picture label )'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -16
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = []
    ParentFont = False
    Visible = False
    ExplicitWidth = 129
  end
  object ListView: TListView
    Left = 0
    Top = 597
    Width = 1384
    Height = 264
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
        Caption = 'Features'
      end
      item
        Alignment = taRightJustify
        Caption = 'Dist. (Ls)'
      end
      item
        Alignment = taCenter
        Caption = 'Land.'
      end
      item
        Caption = 'Atmosphere'
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
        Caption = 'Radius'
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
    OnCompare = ListViewCompare
    OnCustomDrawItem = ListViewCustomDrawItem
    OnDblClick = ListViewDblClick
    OnMouseDown = ListViewMouseDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1384
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    object SystemNameLabel: TLabel
      Left = 8
      Top = 4
      Width = 214
      Height = 27
      Alignment = taCenter
      AutoSize = False
      Caption = '--------------------'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -19
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      OnClick = SystemNameLabelClick
    end
    object FactionsLabel: TLabel
      Left = 228
      Top = 7
      Width = 335
      Height = 20
      AutoSize = False
      Caption = '----------------------'
      OnDblClick = FactionsLabelDblClick
    end
    object LastUpdateLabel: TLabel
      Left = 301
      Top = 34
      Width = 195
      Height = 20
      AutoSize = False
      Caption = '-----------------------'
    end
    object SystemAddrLabel: TLabel
      Left = 1230
      Top = 48
      Width = 154
      Height = 20
      AutoSize = False
      Caption = '-------------------'
      OnDblClick = SystemAddrLabelDblClick
    end
    object ArchitectLabel: TLabel
      Left = 301
      Top = 55
      Width = 136
      Height = 20
      AutoSize = False
      Caption = '--------------------'
      OnClick = ArchitectLabelClick
    end
    object PopulationLabel: TLabel
      Left = 95
      Top = 33
      Width = 106
      Height = 20
      AutoSize = False
      Caption = '--------------------'
    end
    object SecurityLabel: TLabel
      Left = 95
      Top = 55
      Width = 106
      Height = 20
      AutoSize = False
      Caption = '------------------------'
    end
    object Label3: TLabel
      Left = 596
      Top = 7
      Width = 58
      Height = 18
      Alignment = taRightJustify
      Caption = 'Comment:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 569
      Top = 31
      Width = 85
      Height = 18
      Alignment = taRightJustify
      Caption = 'Current Goals:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 590
      Top = 55
      Width = 64
      Height = 18
      Alignment = taRightJustify
      Caption = 'Objectives:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label15: TLabel
      Left = 815
      Top = 55
      Width = 46
      Height = 21
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Groups:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      OnDblClick = SystemAddrLabelDblClick
    end
    object EDSMScanLabel: TLabel
      Left = 1104
      Top = 48
      Width = 129
      Height = 20
      AutoSize = False
      Caption = '[ Clear EDSM Scan ]'
      OnClick = EDSMScanLabelClick
      OnDblClick = SystemAddrLabelDblClick
    end
    object IgnoredLabel: TLabel
      Left = 502
      Top = 55
      Width = 50
      Height = 20
      AutoSize = False
      Caption = 'Ignored'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      OnClick = IgnoredLabelClick
    end
    object Label26: TLabel
      Left = 217
      Top = 55
      Width = 80
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Architect:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      OnClick = ArchitectLabelClick
    end
    object Label27: TLabel
      Left = 217
      Top = 33
      Width = 80
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Last Update:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label28: TLabel
      Left = 9
      Top = 33
      Width = 80
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Population:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object Label29: TLabel
      Left = 9
      Top = 55
      Width = 80
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Security:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object EDSMScanButton: TButton
      Left = 1011
      Top = 46
      Width = 75
      Height = 25
      Caption = 'EDSM Scan'
      TabOrder = 0
      OnClick = EDSMScanButtonClick
    end
    object CommentEdit: TEdit
      Left = 660
      Top = 7
      Width = 325
      Height = 26
      BevelEdges = [beBottom]
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Ctl3D = True
      ParentColor = True
      ParentCtl3D = False
      TabOrder = 1
      Text = 'Aa'
      OnChange = CommentEditChange
    end
    object SaveDataButton: TButton
      Left = 1011
      Top = 15
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 2
      OnClick = SaveDataButtonClick
    end
    object GoalsEdit: TEdit
      Left = 660
      Top = 31
      Width = 325
      Height = 22
      BorderStyle = bsNone
      ParentColor = True
      TabOrder = 3
      Text = 'Aa'
      OnChange = CommentEditChange
    end
    object ObjectivesEdit: TEdit
      Left = 660
      Top = 55
      Width = 149
      Height = 26
      BorderStyle = bsNone
      ParentColor = True
      TabOrder = 4
      Text = 'Aa'
      OnChange = CommentEditChange
    end
    object TaskGroupEdit: TEdit
      Left = 867
      Top = 55
      Width = 118
      Height = 26
      BorderStyle = bsNone
      ParentColor = True
      TabOrder = 5
      Text = 'Aa'
      OnChange = CommentEditChange
    end
    object IgnoredCheck: TCheckBox
      Left = 480
      Top = 56
      Width = 19
      Height = 17
      TabOrder = 6
      OnClick = IgnoredCheckClick
    end
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 100
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
    object NoLabelsLabel: TLabel
      Left = 3
      Top = 5
      Width = 166
      Height = 16
      Caption = 'No body labels, click here to add.'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Visible = False
      OnClick = AddLabelsMenuItemClick
    end
    object BodyInfoPanel: TPanel
      Left = 94
      Top = 168
      Width = 337
      Height = 161
      BevelOuter = bvNone
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object BodyInfoFrame: TShape
        Left = 0
        Top = 0
        Width = 337
        Height = 161
        Align = alClient
        Brush.Color = clBlack
        Pen.Color = clSilver
        ExplicitLeft = 1
      end
      object BodyInfoLabel: TLabel
        Left = 2
        Top = 2
        Width = 60
        Height = 13
        Caption = 'BodyInfoLabel'
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Bahnschrift SemiCondensed'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
      end
      object BodyStationsLabel: TLabel
        Left = 51
        Top = 80
        Width = 78
        Height = 13
        Caption = 'BodyStationsLabel'
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Bahnschrift SemiCondensed'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
      end
      object BodySlotsPanel: TPanel
        Left = 1
        Top = 79
        Width = 61
        Height = 39
        BevelOuter = bvNone
        Color = 2105376
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -15
        Font.Name = 'Bahnschrift SemiCondensed'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        object Label23: TLabel
          Left = 1
          Top = 0
          Width = 30
          Height = 18
          Caption = ' '#9898#8226' '
          OnClick = OrbSlotsLabelClick
        end
        object OrbSlotsLabel: TLabel
          Left = 30
          Top = 0
          Width = 14
          Height = 18
          AutoSize = False
          Caption = '0'
          OnClick = OrbSlotsLabelClick
        end
        object SurfSlotsLabel: TLabel
          Left = 30
          Top = 20
          Width = 15
          Height = 18
          AutoSize = False
          Caption = '0'
          OnClick = OrbSlotsLabelClick
        end
        object Label18: TLabel
          Left = 2
          Top = 20
          Width = 26
          Height = 18
          Caption = ' '#55356#57325' '
          OnClick = OrbSlotsLabelClick
        end
        object Label16: TLabel
          Left = 48
          Top = 0
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '0'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label16Click
        end
        object Label19: TLabel
          Left = 64
          Top = 0
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '1'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label16Click
        end
        object Label21: TLabel
          Left = 80
          Top = 0
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '2'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label16Click
        end
        object Label24: TLabel
          Left = 96
          Top = 0
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '3'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label16Click
        end
        object Label30: TLabel
          Left = 112
          Top = 0
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '4'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label16Click
        end
        object Label33: TLabel
          Left = 128
          Top = 0
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '5'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label16Click
        end
        object Label34: TLabel
          Left = 144
          Top = 0
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '6'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label16Click
        end
        object Label35: TLabel
          Left = 160
          Top = 0
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '7'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label16Click
        end
        object Label36: TLabel
          Left = 176
          Top = 0
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '8'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label16Click
        end
        object Label37: TLabel
          Left = 48
          Top = 20
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '0'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label37Click
        end
        object Label38: TLabel
          Left = 64
          Top = 20
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '1'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label37Click
        end
        object Label39: TLabel
          Left = 80
          Top = 20
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '2'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label37Click
        end
        object Label40: TLabel
          Left = 96
          Top = 20
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '3'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label37Click
        end
        object Label41: TLabel
          Left = 112
          Top = 20
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '4'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label37Click
        end
        object Label42: TLabel
          Left = 128
          Top = 20
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '5'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label37Click
        end
        object Label43: TLabel
          Left = 144
          Top = 20
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '6'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label37Click
        end
        object Label44: TLabel
          Left = 160
          Top = 20
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '7'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label37Click
        end
        object Label45: TLabel
          Left = 176
          Top = 20
          Width = 14
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '8'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = Label37Click
        end
        object HideSlotEditLabel: TLabel
          Left = 192
          Top = 10
          Width = 9
          Height = 18
          Alignment = taCenter
          AutoSize = False
          Caption = '<'
          Color = clGray
          ParentColor = False
          Transparent = False
          OnClick = HideSlotEditLabelClick
        end
      end
    end
  end
  object InfoPanel2: TPanel
    Left = 0
    Top = 505
    Width = 1384
    Height = 59
    Align = alTop
    BevelOuter = bvNone
    Color = clBlack
    ParentBackground = False
    TabOrder = 3
    object Label1: TLabel
      Left = 125
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
      Left = 169
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current (Current +in progress / +planned)'
      Caption = '00 (00/00)'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCrimson
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Transparent = True
    end
    object Label2: TLabel
      Left = 242
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
      Left = 285
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current (Current +in progress / +planned)'
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
      Left = 358
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
      Left = 395
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current (Current +in progress / +planned)'
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
      Left = 468
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
      Left = 516
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current (Current +in progress / +planned)'
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
      Left = 589
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
      Left = 637
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current (Current +in progress / +planned)'
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
      Left = 1047
      Top = 1
      Width = 91
      Height = 27
      AutoSize = False
      Caption = 'T2/T3 Primary'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -12
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = [fsItalic]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label11: TLabel
      Left = 832
      Top = 3
      Width = 44
      Height = 19
      Alignment = taRightJustify
      Caption = ' CP:  T2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
    object CP2Label: TLabel
      Left = 882
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current (Current +in progress / +planned)'
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
      Left = 959
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
      Hint = 'Current (Current +in progress / +planned)'
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
      Left = 4
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
      OnDblClick = MiliLinksLabel1DblClick
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
      OnDblClick = MiliLinksLabel1DblClick
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
      OnDblClick = MiliLinksLabel1DblClick
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
      OnDblClick = MiliLinksLabel1DblClick
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
      OnDblClick = MiliLinksLabel1DblClick
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
      OnDblClick = MiliLinksLabel1DblClick
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
      OnDblClick = MiliLinksLabel1DblClick
    end
    object SlotsLabel: TLabel
      Left = 711
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
    object Label0: TLabel
      Left = 4
      Top = 3
      Width = 35
      Height = 19
      Hint = 'Free construction slots, click to change'
      Caption = 'Score'
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
    object ScoreLabel: TLabel
      Left = 44
      Top = 3
      Width = 68
      Height = 19
      Hint = 'Current (Current +in progress / +planned)'
      Caption = '00 (00/00)'
      Color = clGold
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGold
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = SlotsLabelClick
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
    Top = 564
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
    object Label25: TLabel
      Left = 1026
      Top = 0
      Width = 304
      Height = 33
      AutoSize = False
      Caption = 
        'Hint: You can use col. headers in filters, eg. "atmo+rings", use' +
        ' '#39'~'#39' sign to exclude text, '#39'+'#39' to join filters'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift Light SemiCondensed'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
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
    object FreeSlotsCheck: TCheckBox
      Left = 721
      Top = 8
      Width = 90
      Height = 17
      Caption = 'Free Slots'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
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
      OnClick = PastePictureMenuItemClick
    end
    object SavePictureMenuItem: TMenuItem
      Caption = 'Save Picture'
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
    object LabelsSubMenu: TMenuItem
      Caption = 'Body Labels'
      object AddLabelsMenuItem: TMenuItem
        Caption = 'Edit Mode'
        OnClick = AddLabelsMenuItemClick
      end
      object UndoBodyLabelMenuItem: TMenuItem
        Caption = 'Undo (Shift+Click)'
        OnClick = UndoBodyLabelMenuItemClick
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object ClearAllLabelsMenuItem: TMenuItem
        Caption = 'Clear All'
        OnClick = ClearAllLabelsMenuItemClick
      end
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
    object N9: TMenuItem
      Caption = '-'
    end
    object ConstructionTypesMenuItem: TMenuItem
      Caption = 'Construction Types'
      OnClick = ConstructionTypesMenuItemClick
    end
    object SolverMenuItem: TMenuItem
      Caption = 'Colony Planner...'
      OnClick = SolverMenuItemClick
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
    object BodyCommentMenuItem: TMenuItem
      Caption = 'Comment...'
      OnClick = BodyCommentMenuItemClick
    end
    object SetPrimaryLocationMenuItem: TMenuItem
      Caption = 'Set Primary Location'
      OnClick = SetPrimaryLocationMenuItemClick
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
  object PopupMenu3: TPopupMenu
    OnPopup = PopupMenu3Popup
    Left = 472
    Top = 64
  end
end
