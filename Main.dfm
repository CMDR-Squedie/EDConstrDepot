object EDCDForm: TEDCDForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  BorderWidth = 1
  Caption = 'ED ConstrDepot'
  ClientHeight = 513
  ClientWidth = 231
  Color = 3158064
  TransparentColor = True
  TransparentColorValue = 3158064
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Bahnschrift SemiCondensed'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 16
  object DividerTop: TShape
    Left = 0
    Top = 17
    Width = 231
    Height = 1
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Brush.Style = bsClear
    Pen.Color = clDarkgoldenrod
    ExplicitTop = 16
    ExplicitWidth = 232
  end
  object TitleLabel: TLabel
    Left = 0
    Top = 0
    Width = 231
    Height = 17
    Align = alTop
    AutoSize = False
    Caption = 'No construction depot found'
    Color = 3158064
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = 41215
    Font.Height = -13
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    PopupMenu = PopupMenu
    Transparent = False
    StyleElements = [seFont, seClient]
    OnDblClick = TitleLabelDblClick
    OnMouseDown = TextColLabelMouseDown
    OnMouseMove = TextColLabelMouseMove
    ExplicitTop = -1
  end
  object TextColLabel: TLabel
    AlignWithMargins = True
    Left = 40
    Top = 18
    Width = 136
    Height = 493
    Margins.Left = 2
    Margins.Top = 0
    Margins.Right = 2
    Margins.Bottom = 1
    Align = alClient
    AutoSize = False
    Caption = 'No construction depot found'
    Color = 3158064
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 41215
    Font.Height = -13
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    PopupMenu = PopupMenu
    ShowHint = False
    Transparent = True
    StyleElements = [seFont, seClient]
    OnDblClick = TextColLabelDblClick
    OnMouseDown = TextColLabelMouseDown
    OnMouseMove = TextColLabelMouseMove
    ExplicitTop = 16
    ExplicitWidth = 146
    ExplicitHeight = 487
  end
  object ReqQtyColLabel: TLabel
    AlignWithMargins = True
    Left = 2
    Top = 18
    Width = 34
    Height = 493
    Margins.Left = 2
    Margins.Top = 0
    Margins.Right = 2
    Margins.Bottom = 1
    Align = alLeft
    Alignment = taRightJustify
    AutoSize = False
    Color = 3158064
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clKhaki
    Font.Height = -13
    Font.Name = 'Bahnschrift Condensed'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
    StyleElements = [seFont, seClient]
    OnDblClick = ReqQtyColLabelDblClick
    OnMouseDown = TextColLabelMouseDown
    OnMouseMove = TextColLabelMouseMove
    ExplicitLeft = 0
    ExplicitTop = 15
    ExplicitHeight = 494
  end
  object StockColLabel: TLabel
    AlignWithMargins = True
    Left = 180
    Top = 18
    Width = 24
    Height = 493
    Margins.Left = 2
    Margins.Top = 0
    Margins.Right = 2
    Margins.Bottom = 1
    Align = alRight
    Alignment = taRightJustify
    AutoSize = False
    Color = 3158064
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellowgreen
    Font.Height = -13
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
    StyleElements = [seFont, seClient]
    OnMouseDown = TextColLabelMouseDown
    OnMouseMove = TextColLabelMouseMove
  end
  object DividerBottom: TShape
    Left = 0
    Top = 512
    Width = 231
    Height = 1
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    Brush.Style = bsClear
    Pen.Color = clDarkgoldenrod
    ExplicitTop = 513
  end
  object CloseLabel: TLabel
    Left = 220
    Top = 0
    Width = 12
    Height = 16
    Align = alCustom
    Alignment = taCenter
    AutoSize = False
    Caption = 'X'
    Color = clFirebrick
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Bahnschrift SemiBold Condensed'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = False
    OnClick = ExitMenuItemClick
  end
  object StatusPaintBox: TPaintBox
    Left = 206
    Top = 18
    Width = 25
    Height = 494
    Align = alRight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -13
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = []
    ParentFont = False
    OnPaint = StatusPaintBoxPaint
    ExplicitLeft = 209
    ExplicitTop = 15
  end
  object PopupMenu: TPopupMenu
    OwnerDraw = True
    OnPopup = PopupMenuPopup
    Left = 152
    Top = 362
    object CurrentTGMenuItem: TMenuItem
      Caption = '(placeholder)'
      Enabled = False
      Visible = False
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object SelectDepotSubMenu: TMenuItem
      Caption = 'Constructions'
      object SwitchDepotMenuItem: TMenuItem
        Caption = '(placeholder)'
        Visible = False
        OnClick = SwitchDepotMenuItemClick
      end
    end
    object SelectMarketSubMenu: TMenuItem
      Caption = 'Markets'
      object SwitchMarketMenuItem: TMenuItem
        Caption = '(placeholder)'
        Visible = False
        OnClick = SwitchMarketMenuItemClick
      end
    end
    object FleetCarrierSubMenu: TMenuItem
      Caption = 'Fleet Carrier'
      object N3: TMenuItem
        Caption = '-'
      end
      object UseAsStockMenuItem: TMenuItem
        Caption = 'Use As Stock'
        Visible = False
        OnClick = UseAsStockMenuItemClick
      end
      object MarketAsDepotMenuItem: TMenuItem
        Caption = 'Use as Construction Depot'
        OnClick = MarketAsDepotMenuItemClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object ToggleExtCargoMenuItem: TMenuItem
        Caption = 'Show Stock'
        OnClick = ToggleExtCargoMenuItemClick
      end
      object IncludeExtCargoinRequestMenuItem: TMenuItem
        Caption = 'Fulfill Request with Stock'
        OnClick = IncludeExtCargoinRequestMenuItemClick
      end
      object ComparePurchaseOrderMenuItem: TMenuItem
        Caption = 'Compare with Purchase Order'
        OnClick = ComparePurchaseOrderMenuItemClick
      end
    end
    object TaskGroupSubMenu: TMenuItem
      Caption = 'Task Group'
      object TaskGroupSeparator: TMenuItem
        Caption = '-'
      end
      object NewTaskGroupMenuItem: TMenuItem
        Caption = 'New...'
        OnClick = NewTaskGroupMenuItemClick
      end
      object NoTaskGroupMenuItem: TMenuItem
        Caption = 'Clear Selection'
        OnClick = SwitchTaskGroupMenuItemClick
      end
    end
    object DeliveriesSubMenu: TMenuItem
      Caption = 'Deliveries'
      object ResetDockTimeMenuItem: TMenuItem
        Caption = 'Reset Dock Times'
        OnClick = ResetDockTimeMenuItemClick
      end
      object FlightHistoryMenuItem: TMenuItem
        Caption = 'Delivery History'
        OnClick = FlightHistoryMenuItemClick
      end
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object AddDepotInfoMenuItem: TMenuItem
      Caption = 'Construction Info'
      OnClick = AddDepotInfoMenuItemClick
    end
    object SystemInfoMenuItem: TMenuItem
      Caption = 'System Info'
      OnClick = SystemInfoMenuItemClick
    end
    object SystemInfoCurrentMenuItem: TMenuItem
      Caption = 'Current System'
      OnClick = SystemInfoCurrentMenuItemClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object ManageColoniesMenuItem: TMenuItem
      Caption = 'Manage Colonies'
      OnClick = ManageColoniesMenuItemClick
    end
    object ManageMarketsMenuItem: TMenuItem
      Caption = 'Manage Markets'
      OnClick = ManageMarketsMenuItemClick
    end
    object ManageAllMenuItem: TMenuItem
      Caption = 'Manage All'
      OnClick = ManageAllMenuItemClick
    end
    object SettingsMenuItem: TMenuItem
      Caption = 'Settings'
      OnClick = SettingsMenuItemClick
    end
    object Wiki1: TMenuItem
      Caption = 'Wiki'
      Visible = False
      OnClick = Wiki1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object BackdropMenuItem: TMenuItem
      Caption = 'Toggle Backdrop'
      OnClick = TitleLabelDblClick
    end
    object NewWindowMenuItem: TMenuItem
      Caption = 'New Window'
      OnClick = NewWindowMenuItemClick
    end
    object MinimizeMenuItem: TMenuItem
      Caption = 'Minimize'
      OnClick = MinimizeMenuItemClick
    end
    object ExitMenuItem: TMenuItem
      Caption = 'Close'
      OnClick = ExitMenuItemClick
    end
  end
  object UpdTimer: TTimer
    Interval = 200
    OnTimer = UpdTimerTimer
    Left = 152
    Top = 296
  end
end
