object EDCDForm: TEDCDForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  BorderWidth = 1
  Caption = 'ED ConstrDepot'
  ClientHeight = 513
  ClientWidth = 231
  Color = clBackground
  TransparentColor = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  TextHeight = 15
  object DividerTop: TShape
    Left = -3
    Top = 16
    Width = 242
    Height = 1
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Brush.Style = bsClear
    Pen.Color = clDarkgoldenrod
  end
  object TitleLabel: TLabel
    Left = 0
    Top = -1
    Width = 231
    Height = 17
    AutoSize = False
    Caption = 'No construction depot found'
    Color = clBackground
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clGoldenrod
    Font.Height = -13
    Font.Name = 'Bahnschrift Condensed'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    PopupMenu = PopupMenu
    Transparent = False
    StyleElements = [seFont, seClient]
    OnDblClick = TextColLabelDblClick
    OnMouseDown = TextColLabelMouseDown
    OnMouseMove = TextColLabelMouseMove
  end
  object TextColLabel: TLabel
    Left = 39
    Top = 16
    Width = 146
    Height = 487
    AutoSize = False
    Caption = 'No construction depot found'
    Color = clBackground
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clGoldenrod
    Font.Height = -13
    Font.Name = 'Bahnschrift Condensed'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    PopupMenu = PopupMenu
    Transparent = True
    StyleElements = [seFont, seClient]
    OnDblClick = TextColLabelDblClick
    OnMouseDown = TextColLabelMouseDown
    OnMouseMove = TextColLabelMouseMove
  end
  object ReqQtyColLabel: TLabel
    Left = 0
    Top = 16
    Width = 34
    Height = 487
    Alignment = taRightJustify
    AutoSize = False
    Color = clBackground
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clKhaki
    Font.Height = -13
    Font.Name = 'Bahnschrift Condensed'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    StyleElements = [seFont, seClient]
    OnDblClick = TextColLabelDblClick
    OnMouseDown = TextColLabelMouseDown
    OnMouseMove = TextColLabelMouseMove
  end
  object StockColLabel: TLabel
    Left = 185
    Top = 16
    Width = 24
    Height = 487
    Alignment = taRightJustify
    AutoSize = False
    Color = clBackground
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clYellowgreen
    Font.Height = -13
    Font.Name = 'Bahnschrift Condensed'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    StyleElements = [seFont, seClient]
    OnDblClick = TextColLabelDblClick
    OnMouseDown = TextColLabelMouseDown
    OnMouseMove = TextColLabelMouseMove
  end
  object StatusColLabel: TLabel
    Left = 215
    Top = 16
    Width = 14
    Height = 487
    AutoSize = False
    Color = clBackground
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clSeashell
    Font.Height = -13
    Font.Name = 'Bahnschrift Condensed'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    StyleElements = [seFont, seClient]
    OnDblClick = TextColLabelDblClick
    OnMouseDown = TextColLabelMouseDown
    OnMouseMove = TextColLabelMouseMove
  end
  object DividerBottom: TShape
    Left = -11
    Top = 507
    Width = 242
    Height = 1
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Brush.Style = bsClear
    Pen.Color = clDarkgoldenrod
  end
  object CloseLabel: TLabel
    Left = 221
    Top = -2
    Width = 9
    Height = 16
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
  object UpdTimer: TTimer
    Enabled = False
    Interval = 1500
    OnTimer = UpdTimerTimer
    Left = 96
    Top = 362
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 152
    Top = 362
    object SelectDepotSubMenu: TMenuItem
      Caption = 'Select Construction'
      object SwitchDepotMenuItem: TMenuItem
        Caption = '(placeholder)'
        OnClick = SwitchDepotMenuItemClick
      end
    end
    object AddDepotInfoMenuItem: TMenuItem
      Caption = 'Construction Info'
      OnClick = AddDepotInfoMenuItemClick
    end
    object ExternalCargoMenu: TMenuItem
      Caption = 'External Cargo'
      object ToggleExtCargoMenuItem: TMenuItem
        Caption = 'Toggle'
        OnClick = ToggleExtCargoMenuItemClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object AddMarketToExtCargoMenuItem: TMenuItem
        Caption = 'Use Recent Market'
        OnClick = AddMarketToExtCargoMenuItemClick
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object BackdropMenuItem: TMenuItem
      Caption = 'Toggle Backdrop'
      OnClick = TextColLabelDblClick
    end
    object MinimizeMenuItem: TMenuItem
      Caption = 'Minimize'
      OnClick = MinimizeMenuItemClick
    end
    object ExitMenuItem: TMenuItem
      Caption = 'Exit'
      OnClick = ExitMenuItemClick
    end
  end
end
