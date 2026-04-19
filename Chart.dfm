object ChartForm: TChartForm
  Left = 0
  Top = 0
  Caption = 'Chart'
  ClientHeight = 600
  ClientWidth = 1000
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object SvgArea: TSkSvg
    Left = 0
    Top = 0
    Width = 1000
    Height = 600
    Align = alClient
    PopupMenu = PopupMenu
    OnMouseDown = SvgAreaMouseDown
    ExplicitLeft = 136
    ExplicitTop = 120
    ExplicitWidth = 50
    ExplicitHeight = 50
  end
  object MenuLabel: TLabel
    Left = 3
    Top = 0
    Width = 18
    Height = 28
    Caption = #9776
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnClick = MenuLabelClick
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 360
    Top = 120
    object ChartType1: TMenuItem
      Caption = 'Chart Type'
      object SingleSeries1: TMenuItem
        Caption = '     Single Series'
        Enabled = False
      end
      object ChartTypeMenuItem: TMenuItem
        Caption = 'Line'
        OnClick = ChartTypeMenuItemClick
      end
      object Line2: TMenuItem
        Tag = 1
        Caption = 'Column'
        OnClick = ChartTypeMenuItemClick
      end
      object C1: TMenuItem
        Tag = 2
        Caption = 'Bar'
        OnClick = ChartTypeMenuItemClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object DualSeries1: TMenuItem
        Caption = '    Dual Series'
        Enabled = False
      end
      object StackedColumn1: TMenuItem
        Tag = 3
        Caption = 'Stacked Column'
        OnClick = ChartTypeMenuItemClick
      end
      object DualSecondary1: TMenuItem
        Tag = 4
        Caption = 'Dual Axis'
        OnClick = ChartTypeMenuItemClick
      end
      object ComboSecondary1: TMenuItem
        Tag = 5
        Caption = 'Combo Stack'
        OnClick = ChartTypeMenuItemClick
      end
      object ScatterPlot1: TMenuItem
        Tag = 6
        Caption = 'Scatter Plot'
        OnClick = ChartTypeMenuItemClick
      end
    end
    object ChartType2: TMenuItem
      Caption = 'Color Scheme'
      object ColorSchemeMenuItem: TMenuItem
        Caption = 'Fixed (Red)'
        OnClick = ColorSchemeMenuItemClick
      end
      object FixedColor2: TMenuItem
        Tag = 1
        Caption = 'Cyclic (X)'
        OnClick = ColorSchemeMenuItemClick
      end
      object CyclicGolden1: TMenuItem
        Tag = 2
        Caption = 'Cyclic - Golden (X)'
        OnClick = ColorSchemeMenuItemClick
      end
      object CyclicGolden2: TMenuItem
        Tag = 3
        Caption = 'Gradient - Red To Green (Y)'
        OnClick = ColorSchemeMenuItemClick
      end
      object Gradient1: TMenuItem
        Tag = 5
        Caption = 'Gradient - Cold To Warm (Y)'
        OnClick = ColorSchemeMenuItemClick
      end
      object RedToGreen1: TMenuItem
        Tag = 4
        Caption = 'Red To Green (Y)'
        OnClick = ColorSchemeMenuItemClick
      end
      object ColdToWarm1: TMenuItem
        Tag = 6
        Caption = 'Cold To Warm (Y)'
        OnClick = ColorSchemeMenuItemClick
      end
      object RedToGrayToGreenX1: TMenuItem
        Tag = 7
        Caption = 'Red To Green (X, Thru Gray)'
        OnClick = ColorSchemeMenuItemClick
      end
    end
    object ChartOptionsSubMenu: TMenuItem
      Caption = 'Chart Options'
      object ChartOptionMenuItem: TMenuItem
        Tag = 2
        Caption = 'Value Labels'
        OnClick = ChartOptionMenuItemClick
      end
      object ReversedAxis1: TMenuItem
        Caption = 'Reversed Axis'
        OnClick = ChartOptionMenuItemClick
      end
      object Markers1: TMenuItem
        Tag = 1
        Caption = 'Milestone Markers'
        OnClick = ChartOptionMenuItemClick
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SortSeriesMenuItem: TMenuItem
      Caption = 'Sort by Y (Ascending)'
      OnClick = SortSeriesMenuItemClick
    end
    object imeline1: TMenuItem
      Caption = 'Timeline'
      object TimelineMenuItem: TMenuItem
        Tag = 1
        Caption = '3 months'
        OnClick = TimelineMenuItemClick
      end
      object N180dni1: TMenuItem
        Tag = 2
        Caption = '12 months'
        OnClick = TimelineMenuItemClick
      end
      object YTD1: TMenuItem
        Tag = 3
        Caption = 'YTD'
        OnClick = TimelineMenuItemClick
      end
    end
    object Top10MenuItem: TMenuItem
      Tag = 10
      Caption = 'Top 10'
      OnClick = Top10MenuItemClick
    end
    object Top20MenuItem: TMenuItem
      Tag = 20
      Caption = 'Top 20'
      OnClick = Top10MenuItemClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object CopyDataMenuItem: TMenuItem
      Caption = 'Copy Data'
      OnClick = CopyDataMenuItemClick
    end
    object SaveChartMenuItem: TMenuItem
      Caption = 'Save (chart.svg)'
      OnClick = SaveChartMenuItemClick
    end
  end
end
