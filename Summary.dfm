object SummaryForm: TSummaryForm
  Left = 0
  Top = 0
  Caption = 'Summary'
  ClientHeight = 720
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Bahnschrift SemiCondensed'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 16
  object ListView: TListView
    Left = 0
    Top = 25
    Width = 414
    Height = 695
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clSilver
    Columns = <
      item
        Caption = 'Category'
        MinWidth = 150
        Width = 250
      end
      item
        Alignment = taRightJustify
        MinWidth = 50
        Width = 120
      end>
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawItem = ListViewCustomDrawItem
    OnDblClick = ListViewDblClick
    ExplicitTop = 56
    ExplicitWidth = 400
    ExplicitHeight = 664
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 414
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object CmdrComboBox: TComboBox
      Left = 21
      Top = 0
      Width = 203
      Height = 24
      Align = alClient
      Style = csDropDownList
      TabOrder = 0
      OnChange = CmdrComboBoxChange
      Items.Strings = (
        '(all local commanders)')
      ExplicitWidth = 260
    end
    object MenuButton: TButton
      Left = 0
      Top = 0
      Width = 21
      Height = 25
      Align = alLeft
      Caption = #9776
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = MenuButtonClick
      ExplicitHeight = 20
    end
    object TaskGroupComboBox: TComboBox
      Left = 224
      Top = 0
      Width = 190
      Height = 24
      Align = alRight
      Style = csDropDownList
      TabOrder = 2
      OnChange = TaskGroupComboBoxChange
      Items.Strings = (
        '(all task groups)')
    end
  end
  object PopupMenu: TPopupMenu
    Left = 264
    Top = 160
    object CopyMenuItem: TMenuItem
      Caption = 'Copy'
      OnClick = CopyMenuItemClick
    end
    object CopyPopHistMenuItem: TMenuItem
      Caption = 'Copy Pop. History'
      OnClick = CopyPopHistMenuItemClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Chart1: TMenuItem
      Caption = 'Chart'
      object General1: TMenuItem
        Caption = 'GENERAL'
        Enabled = False
      end
      object PopulationHistoryMenuItem: TMenuItem
        Tag = 1
        Caption = '   Population History'
        OnClick = PopulationHistoryMenuItemClick
      end
      object PopulationHistory1: TMenuItem
        Tag = 2
        Caption = '   Population History (w/ T3 markers)'
        OnClick = PopulationHistoryMenuItemClick
      end
      object ScoreHistoryMenuItem: TMenuItem
        Caption = '   Score History'
        OnClick = ScoreHistoryMenuItemClick
      end
      object PopulationIncHistMenuItem: TMenuItem
        Tag = 2
        Caption = '   Weekly Population Increase'
        Visible = False
        OnClick = PopulationIncHistMenuItemClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object FINISHEDCONSTUCTIONS1: TMenuItem
        Caption = 'FINISHED CONSTRUCTIONS'
        Enabled = False
      end
      object ConstrHistory1MenuItem: TMenuItem
        Tag = 1
        Caption = '   Monthly Tonage'
        OnClick = ConstrHistory2MenuItemClick
      end
      object ConstructionTypesMenuItem: TMenuItem
        Caption = '   Types'
        OnClick = ConstructionTypesMenuItemClick
      end
      object ConstrHistory2MenuItem: TMenuItem
        Tag = 2
        Caption = '   Monthly Score'
        OnClick = ConstrHistory2MenuItemClick
      end
      object WeeklyFinishedConstrMenuItem: TMenuItem
        Caption = '   Weekly Score'
        OnClick = WeeklyFinishedConstrMenuItemClick
      end
      object WeeklyScore90days1: TMenuItem
        Tag = 1
        Caption = '   Weekly Score (90 days)'
        OnClick = WeeklyScore90days1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object CONTIBUTIONt1: TMenuItem
        Caption = 'CONTIBUTION (t)'
        Enabled = False
      end
      object DailyContrib1MenuItem: TMenuItem
        Tag = 1
        Caption = '   Daily Contribution (30 days)'
        OnClick = DailyContrib1MenuItemClick
      end
      object DailyContribution30days1: TMenuItem
        Tag = 2
        Caption = '   Daily Contribution (90 days)'
        OnClick = DailyContrib1MenuItemClick
      end
      object DailyContribution90days1: TMenuItem
        Tag = 3
        Caption = '   Weekly Contribution (90 days)'
        OnClick = DailyContrib1MenuItemClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object ASKGROUPS1: TMenuItem
        Caption = 'TASK GROUPS'
        Enabled = False
      end
      object TaskGroupPopulationMenuItem: TMenuItem
        Caption = '   Population'
        OnClick = TaskGroupPopulationMenuItemClick
      end
      object TaskGroupScoreMenuItem: TMenuItem
        Caption = '   Score'
        OnClick = TaskGroupScoreMenuItemClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object OTHER1: TMenuItem
        Caption = 'OTHER'
        Enabled = False
      end
      object BestMarketsMenuItem: TMenuItem
        Caption = '   Markets by Purchases'
        OnClick = BestMarketsMenuItemClick
      end
    end
  end
end
