object DashboardForm: TDashboardForm
  Left = 0
  Top = 0
  Caption = 'Dashboard'
  ClientHeight = 800
  ClientWidth = 1200
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    1200
    800)
  TextHeight = 15
  object GridPanel1: TGridPanel
    Left = 0
    Top = 0
    Width = 1200
    Height = 800
    Align = alClient
    BevelOuter = bvNone
    Color = clBlack
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <>
    ParentBackground = False
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 41
    Height = 23
    BevelOuter = bvNone
    Caption = 'Panel1'
    ParentColor = True
    TabOrder = 1
    object MenuLabel: TLabel
      Left = 0
      Top = 0
      Width = 18
      Height = 23
      Align = alLeft
      Caption = #9776
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
      ExplicitHeight = 25
    end
    object RefreshLabel: TLabel
      Left = 18
      Top = 0
      Width = 21
      Height = 23
      Align = alLeft
      Caption = #55357#56580
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = RefreshLabelClick
      ExplicitHeight = 25
    end
  end
  object ChartPanel: TPanel
    Left = 207
    Top = 179
    Width = 320
    Height = 240
    Anchors = []
    BevelOuter = bvNone
    Caption = 'ChartPanel'
    Color = clBlack
    ParentBackground = False
    TabOrder = 2
    Visible = False
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 320
      Height = 15
      Align = alTop
      Alignment = taRightJustify
      Caption = 'Close  '
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      OnClick = Label1Click
      ExplicitLeft = 285
      ExplicitWidth = 35
    end
    object ChartListBox: TListBox
      Left = 0
      Top = 15
      Width = 320
      Height = 225
      Align = alClient
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ItemHeight = 15
      ParentFont = False
      TabOrder = 0
      OnDblClick = ChartListBoxDblClick
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 336
    Top = 112
    object ChartTypeSubMenu: TMenuItem
      Caption = 'Chart Type'
      object SingleSeries1: TMenuItem
        Tag = -1
        Caption = 'Single Series'
        Enabled = False
      end
      object ChartTypeMenuItem: TMenuItem
        Caption = '   Line'
        OnClick = ChartTypeMenuItemClick
      end
      object Line2: TMenuItem
        Tag = 1
        Caption = '   Column'
        OnClick = ChartTypeMenuItemClick
      end
      object C1: TMenuItem
        Tag = 2
        Caption = '   Bar'
        OnClick = ChartTypeMenuItemClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object DualSeries1: TMenuItem
        Tag = -1
        Caption = 'Dual Series'
        Enabled = False
      end
      object StackedColumn1: TMenuItem
        Tag = 3
        Caption = '   Stacked Column'
        OnClick = ChartTypeMenuItemClick
      end
      object DualSecondary1: TMenuItem
        Tag = 4
        Caption = '   Secondary Column'
        OnClick = ChartTypeMenuItemClick
      end
      object ComboSecondary1: TMenuItem
        Tag = 5
        Caption = '   Combo Stack'
        OnClick = ChartTypeMenuItemClick
      end
      object ScatterPlot1: TMenuItem
        Tag = 6
        Caption = '   Scatter Plot'
        OnClick = ChartTypeMenuItemClick
      end
    end
    object ColorSchemeSubMenu: TMenuItem
      Caption = 'Color Scheme'
      object LinearPalette1: TMenuItem
        Tag = -1
        Caption = 'Color Palette'
        Enabled = False
      end
      object RedToGreen1: TMenuItem
        Tag = 4
        Caption = '   Red To Green'
        OnClick = ColorSchemeMenuItemClick
      end
      object RedToGrayToGreenX1: TMenuItem
        Tag = 7
        Caption = '   Red To Green (w/ Gray)'
        OnClick = ColorSchemeMenuItemClick
      end
      object Gradient1: TMenuItem
        Tag = 6
        Caption = '   Cold To Warm'
        OnClick = ColorSchemeMenuItemClick
      end
      object GradientPurpletoYellowY1: TMenuItem
        Tag = 9
        Caption = '   Purple to Yellow'
        OnClick = ColorSchemeMenuItemClick
      end
      object GradientSkyY1: TMenuItem
        Tag = 13
        Caption = '   Blue Sky'
        OnClick = ColorSchemeMenuItemClick
      end
      object BlueToSand1: TMenuItem
        Tag = 18
        Caption = '   Dawn'
        OnClick = ColorSchemeMenuItemClick
      end
      object GradientHottoColdY1: TMenuItem
        Tag = 11
        Caption = '   Sunset'
        OnClick = ColorSchemeMenuItemClick
      end
      object GradientTealY1: TMenuItem
        Tag = 10
        Caption = '   Cyan'
        OnClick = ColorSchemeMenuItemClick
      end
      object Emerald1: TMenuItem
        Tag = 14
        Caption = '   Emerald'
        OnClick = ColorSchemeMenuItemClick
      end
      object GradientFlameY1: TMenuItem
        Tag = 12
        Caption = '   Flame'
        OnClick = ColorSchemeMenuItemClick
      end
      object ColdToWarm1: TMenuItem
        Tag = 5
        Caption = '   Mechanical'
        OnClick = ColorSchemeMenuItemClick
      end
      object Lavender1: TMenuItem
        Tag = 19
        Caption = '   Lavender'
        OnClick = ColorSchemeMenuItemClick
      end
      object Peppermint1: TMenuItem
        Tag = 16
        Caption = '   Peppermint'
        OnClick = ColorSchemeMenuItemClick
      end
      object RainForest1: TMenuItem
        Tag = 15
        Caption = '   Rain Forest'
        OnClick = ColorSchemeMenuItemClick
      end
      object PurpletoYellow1: TMenuItem
        Tag = 8
        Caption = '   Crimson'
        OnClick = ColorSchemeMenuItemClick
      end
      object PinkToCyan1: TMenuItem
        Tag = 17
        Caption = '   Cyan To Pink'
        OnClick = ColorSchemeMenuItemClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object CategoryColoring1: TMenuItem
        Tag = -1
        Caption = 'Special'
        Enabled = False
      end
      object ColorSchemeMenuItem: TMenuItem
        Caption = '   Fixed (App Color)'
        OnClick = ColorSchemeMenuItemClick
      end
      object CyclicGolden1: TMenuItem
        Tag = 2
        Caption = '   Cyclic - Golden'
        OnClick = ColorSchemeMenuItemClick
      end
      object FixedColor2: TMenuItem
        Tag = 1
        Caption = '   Cyclic'
        OnClick = ColorSchemeMenuItemClick
      end
      object CyclicGolden2: TMenuItem
        Tag = 3
        Caption = '   Red To Green (dark edge)'
        OnClick = ColorSchemeMenuItemClick
      end
      object N7: TMenuItem
        Caption = '-'
        Visible = False
      end
      object NextColorSchemeMenuItem: TMenuItem
        Tag = -1
        Caption = '   Cycle Schemes'
        Visible = False
        OnClick = NextColorSchemeMenuItemClick
      end
      object N8: TMenuItem
        Caption = '-'
      end
    end
    object ColorPolicySubMenu: TMenuItem
      Tag = -1
      Caption = 'Color Policy'
      object CategoryColors1: TMenuItem
        Tag = 8
        Caption = '   Category Colors'
        OnClick = ChartOptionMenuItemClick
      end
      object ValueColors1: TMenuItem
        Tag = 9
        Caption = '   Value Colors'
        OnClick = ChartOptionMenuItemClick
      end
      object RotateGradient901: TMenuItem
        Tag = 3
        Caption = '   Rotate Gradient (90'#186')'
        OnClick = ChartOptionMenuItemClick
      end
      object FlipPalette1: TMenuItem
        Tag = 10
        Caption = '   Flip Palette'
        OnClick = ChartOptionMenuItemClick
      end
    end
    object ChartOptionsSubMenu: TMenuItem
      Caption = 'Chart Options'
      object AxisGrid1: TMenuItem
        Tag = -1
        Caption = 'Axis Grid'
        Enabled = False
      end
      object MoreGridLines1: TMenuItem
        Tag = 5
        Caption = '   More Grid Lines'
        OnClick = ChartOptionMenuItemClick
      end
      object CleanGridSteps1: TMenuItem
        Tag = 7
        Caption = '   Round Grid Steps'
        OnClick = ChartOptionMenuItemClick
      end
      object AverageLine1: TMenuItem
        Tag = 6
        Caption = '   Average Line'
        OnClick = ChartOptionMenuItemClick
      end
      object exludezeros1: TMenuItem
        Tag = 12
        Caption = '      - exlude zeros'
        OnClick = ChartOptionMenuItemClick
      end
      object ReversedAxis1: TMenuItem
        Caption = '   Reversed Axis'
        OnClick = ChartOptionMenuItemClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Values1: TMenuItem
        Tag = -1
        Caption = 'Values'
        Enabled = False
      end
      object ValueLabels1: TMenuItem
        Tag = 2
        Caption = '   Value Labels'
        OnClick = ChartOptionMenuItemClick
      end
      object MilestoneMarkers1: TMenuItem
        Tag = 1
        Caption = '   Milestone Markers'
        OnClick = ChartOptionMenuItemClick
      end
      object LargeLabels1: TMenuItem
        Tag = 16
        Caption = '   Large Labels'
        OnClick = ChartOptionMenuItemClick
      end
      object SharedScaleDual1: TMenuItem
        Tag = 18
        Caption = '   Shared Scale (Dual)'
        OnClick = ChartOptionMenuItemClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Other1: TMenuItem
        Tag = -1
        Caption = 'Other'
        Enabled = False
      end
      object BarSeparation1: TMenuItem
        Tag = 4
        Caption = '   Bar Separation'
        OnClick = ChartOptionMenuItemClick
      end
      object SegmentedBars1: TMenuItem
        Tag = 17
        Caption = '   Segmented Bars'
        OnClick = ChartOptionMenuItemClick
      end
    end
    object AdjustDataSeriesSubMenu: TMenuItem
      Caption = 'Adjust Data Series'
      object Sort1: TMenuItem
        Tag = -1
        Caption = 'Sort'
        Enabled = False
      end
      object AdjustDataSeries1MenuItem: TMenuItem
        Caption = '   Series 1, Ascending'
        OnClick = AdjustDataSeries1MenuItemClick
      end
      object SortAscending1: TMenuItem
        Tag = 7
        Caption = '   All Series, Ascending'
        OnClick = AdjustDataSeries1MenuItemClick
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object ShortenTimeline1: TMenuItem
        Tag = -1
        Caption = 'Shorten Timeline'
        Enabled = False
      end
      object N3months1: TMenuItem
        Tag = 1
        Caption = '   3 months'
        OnClick = AdjustDataSeries1MenuItemClick
      end
      object N6months1: TMenuItem
        Tag = 2
        Caption = '   6 months'
        OnClick = AdjustDataSeries1MenuItemClick
      end
      object N12months1: TMenuItem
        Tag = 3
        Caption = '   12 months'
        OnClick = AdjustDataSeries1MenuItemClick
      end
      object YTD1: TMenuItem
        Tag = 4
        Caption = '   YTD'
        OnClick = AdjustDataSeries1MenuItemClick
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object FilterCategories1: TMenuItem
        Tag = -1
        Caption = 'Filter Categories'
        Enabled = False
      end
      object op121: TMenuItem
        Tag = 5
        Caption = '   Top 12'
        OnClick = AdjustDataSeries1MenuItemClick
      end
      object op241: TMenuItem
        Tag = 6
        Caption = '   Top 24'
        OnClick = AdjustDataSeries1MenuItemClick
      end
      object ExcludeZeros1: TMenuItem
        Tag = 8
        Caption = '   Exclude Zeros'
        OnClick = AdjustDataSeries1MenuItemClick
      end
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object SaveSettingsMenuItem: TMenuItem
      Caption = 'Save Setup'
      OnClick = SaveSettingsMenuItemClick
    end
    object RestoreSetupMenuItem: TMenuItem
      Caption = 'Restore Defaults'
      OnClick = RestoreSetupMenuItemClick
    end
    object SelectChartMenuItem: TMenuItem
      Caption = 'Select Chart...'
      Visible = False
      OnClick = SelectChartMenuItemClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object CopyDataMenuItem: TMenuItem
      Caption = 'Copy Data'
      OnClick = CopyDataMenuItemClick
    end
    object SaveChartMenuItem: TMenuItem
      Caption = 'Save To '#39'chart.svg'#39
      OnClick = SaveChartMenuItemClick
    end
  end
end
