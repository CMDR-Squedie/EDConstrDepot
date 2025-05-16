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
  FormStyle = fsStayOnTop
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
    Width = 143
    Height = 493
    Margins.Left = 2
    Margins.Top = 0
    Margins.Right = 2
    Margins.Bottom = 1
    Align = alClient
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
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clKhaki
    Font.Height = -13
    Font.Name = 'Bahnschrift Condensed'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
    StyleElements = [seFont, seClient]
    OnMouseDown = TextColLabelMouseDown
    OnMouseMove = TextColLabelMouseMove
    ExplicitLeft = 0
    ExplicitTop = 15
    ExplicitHeight = 494
  end
  object StockColLabel: TLabel
    AlignWithMargins = True
    Left = 187
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
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clYellowgreen
    Font.Height = -13
    Font.Name = 'Bahnschrift Condensed'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    StyleElements = [seFont, seClient]
    OnMouseDown = TextColLabelMouseDown
    OnMouseMove = TextColLabelMouseMove
    ExplicitLeft = 158
    ExplicitTop = 23
    ExplicitHeight = 494
  end
  object StatusColLabel: TLabel
    AlignWithMargins = True
    Left = 215
    Top = 18
    Width = 14
    Height = 493
    Margins.Left = 2
    Margins.Top = 0
    Margins.Right = 2
    Margins.Bottom = 1
    Align = alRight
    AutoSize = False
    Color = 3158064
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clSilver
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    StyleElements = [seFont, seClient]
    OnMouseDown = TextColLabelMouseDown
    OnMouseMove = TextColLabelMouseMove
    ExplicitLeft = 219
    ExplicitTop = 17
    ExplicitHeight = 494
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
    ExplicitTop = 507
    ExplicitWidth = 232
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
  object IndicatorsPaintBox: TPaintBox
    Left = 185
    Top = 23
    Width = 25
    Height = 164
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = []
    ParentFont = False
    Visible = False
    OnPaint = IndicatorsPaintBoxPaint
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 152
    Top = 362
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
    object ExternalCargoMenu: TMenuItem
      Caption = 'Fleet Carrier'
      object IncludeExtCargoinRequestMenuItem: TMenuItem
        Caption = 'Include Stock in Request'
        OnClick = IncludeExtCargoinRequestMenuItemClick
      end
      object ToggleExtCargoMenuItem: TMenuItem
        Caption = 'Show Stock As Cargo'
        OnClick = ToggleExtCargoMenuItemClick
      end
      object AddMarketToExtCargoMenuItem: TMenuItem
        Caption = 'Use Recent Market'
        OnClick = AddMarketToExtCargoMenuItemClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object MarketAsDepotMenuItem: TMenuItem
        Caption = 'Use as Construction Depot'
        OnClick = MarketAsDepotMenuItemClick
      end
    end
    object AddDepotInfoMenuItem: TMenuItem
      Caption = 'Add Construction Info'
      OnClick = AddDepotInfoMenuItemClick
    end
    object ManageMarketsMenuItem: TMenuItem
      Caption = 'Manage All'
      OnClick = ManageMarketsMenuItemClick
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
    object SettingsMenuItem: TMenuItem
      Caption = 'Settings'
      Visible = False
      OnClick = SettingsMenuItemClick
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
