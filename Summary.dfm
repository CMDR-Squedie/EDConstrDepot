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
        Hint = 'POPHISTM'
        OnClick = FactionPopulationMenuItemClick
      end
      object ScoreHistoryMenuItem: TMenuItem
        Caption = '   Score History'
        Hint = 'SCOREHIST'
        OnClick = FactionPopulationMenuItemClick
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
        Hint = 'FINCONHAUL'
        OnClick = FactionPopulationMenuItemClick
      end
      object ConstructionTypesMenuItem: TMenuItem
        Caption = '   Types'
        Hint = 'FINCONTYPE'
        OnClick = FactionPopulationMenuItemClick
      end
      object ConstrHistory2MenuItem: TMenuItem
        Tag = 2
        Caption = '   Monthly Score'
        Hint = 'FINCONSCORE'
        OnClick = FactionPopulationMenuItemClick
      end
      object WeeklyFinishedConstrMenuItem: TMenuItem
        Caption = '   Weekly Score'
        Hint = 'SCOREWEEKLY'
        OnClick = FactionPopulationMenuItemClick
      end
      object WeeklyScore90days1: TMenuItem
        Tag = 1
        Caption = '   Weekly Score (90 days)'
        Hint = 'SCOREW90'
        OnClick = FactionPopulationMenuItemClick
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
        Hint = 'CONTRIBD30'
        OnClick = FactionPopulationMenuItemClick
      end
      object DailyContribution30days1: TMenuItem
        Tag = 2
        Caption = '   Daily Contribution (90 days)'
        Hint = 'CONTRIBD90'
        OnClick = FactionPopulationMenuItemClick
      end
      object DailyContribution90days1: TMenuItem
        Tag = 3
        Caption = '   Weekly Contribution (90 days)'
        Hint = 'CONTRIBW90'
        OnClick = FactionPopulationMenuItemClick
      end
      object WeeklyContribution90days1: TMenuItem
        Tag = 4
        Caption = '   Weekly Contribution (360 days)'
        Hint = 'CONTRIBWYR'
        OnClick = FactionPopulationMenuItemClick
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
        Hint = 'TGPOP'
        OnClick = FactionPopulationMenuItemClick
      end
      object PopulationGrowth2: TMenuItem
        Caption = '   Population Daily Growth'
        Hint = 'TGPOPINC'
        OnClick = FactionPopulationMenuItemClick
      end
      object Populationand30dayGrowth2: TMenuItem
        Caption = '   Population and 30-day Growth'
        Hint = 'TGPOPS'
        OnClick = FactionPopulationMenuItemClick
      end
      object TaskGroupScoreMenuItem: TMenuItem
        Caption = '   Score'
        Hint = 'TGSCORE'
        OnClick = FactionPopulationMenuItemClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object ASKGROUPS2: TMenuItem
        Caption = 'FACTIONS'
        Enabled = False
      end
      object FactionPopulationMenuItem: TMenuItem
        Caption = '   Population'
        Hint = 'FACPOP'
        OnClick = FactionPopulationMenuItemClick
      end
      object PopulationGrowth1: TMenuItem
        Caption = '   Population Daily Growth'
        Hint = 'FACPOPINC'
        OnClick = FactionPopulationMenuItemClick
      end
      object Populationand30dayGrowth1: TMenuItem
        Caption = '   Population and 30-day Growth'
        Hint = 'FACPOPS'
        OnClick = FactionPopulationMenuItemClick
      end
      object FactionScoreMenuItem: TMenuItem
        Caption = '   Score'
        Hint = 'FACSCORE'
        OnClick = FactionPopulationMenuItemClick
      end
      object FactionCtrlMenuItem: TMenuItem
        Caption = '   Controlled Systems'
        Hint = 'FACCTRL'
        OnClick = FactionPopulationMenuItemClick
      end
      object FactionPresenceMenuItem: TMenuItem
        Caption = '   Presence'
        Hint = 'FACPRESENCE'
        OnClick = FactionPopulationMenuItemClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object OTHER1: TMenuItem
        Caption = 'OTHER'
        Enabled = False
        Hint = 'MARKETS'
      end
      object BestMarketsMenuItem: TMenuItem
        Caption = '   Markets by Purchases'
        Hint = 'MARKETS'
        OnClick = FactionPopulationMenuItemClick
      end
    end
  end
end
