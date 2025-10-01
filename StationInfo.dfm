object StationInfoForm: TStationInfoForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Construction Info'
  ClientHeight = 587
  ClientWidth = 615
  Color = 4866358
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clSilver
  Font.Height = -16
  Font.Name = 'Bahnschrift SemiCondensed'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 19
  object WealthBkgLabel: TLabel
    Left = 147
    Top = 354
    Width = 231
    Height = 33
    Caption = #10096#10096#10096#10096#10096#10096#10096#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LivBkgLabel: TLabel
    Left = 147
    Top = 330
    Width = 231
    Height = 33
    Caption = #10096#10096#10096#10096#10096#10096#10096#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DevBkgLabel: TLabel
    Left = 147
    Top = 258
    Width = 231
    Height = 33
    Caption = #10096#10096#10096#10096#10096#10096#10096#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object TechBkgLabel: TLabel
    Left = 147
    Top = 282
    Width = 231
    Height = 33
    Caption = #10096#10096#10096#10096#10096#10096#10096#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SecBkgLabel: TLabel
    Left = 147
    Top = 306
    Width = 231
    Height = 33
    Caption = #10096#10096#10096#10096#10096#10096#10096#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 9
    Top = 43
    Width = 36
    Height = 19
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 166
    Top = 76
    Width = 74
    Height = 19
    Caption = #9999' Planned'
    FocusControl = PlannedStatus
    OnClick = Label2Click
  end
  object Label3: TLabel
    Left = 277
    Top = 76
    Width = 95
    Height = 19
    Caption = #55357#56999' In Progress'
    FocusControl = StatusRadio2
    OnClick = Label2Click
  end
  object Label4: TLabel
    Left = 517
    Top = 76
    Width = 77
    Height = 19
    Caption = #9746' Cancelled'
    FocusControl = CancelledStatus
    OnClick = Label2Click
  end
  object Label5: TLabel
    Left = 406
    Top = 76
    Width = 75
    Height = 19
    Caption = #55357#57001' Finished'
    FocusControl = FinishedStatus
    OnClick = Label2Click
  end
  object Label6: TLabel
    Left = 8
    Top = 314
    Width = 52
    Height = 19
    Caption = 'Security'
  end
  object SecPosLabel: TLabel
    Left = 224
    Top = 306
    Width = 154
    Height = 33
    Caption = #10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clChartreuse
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 8
    Top = 115
    Width = 28
    Height = 19
    Caption = 'Type'
  end
  object SecNegLabel: TLabel
    Left = 147
    Top = 306
    Width = 77
    Height = 33
    Alignment = taRightJustify
    Caption = #10096#10096#10096#10096#10096#10096#10096
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 8
    Top = 290
    Width = 69
    Height = 19
    Caption = 'Technology'
  end
  object TechNegLabel: TLabel
    Left = 147
    Top = 282
    Width = 77
    Height = 33
    Alignment = taRightJustify
    Caption = #10096#10096#10096#10096#10096#10096#10096
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object TechPosLabel: TLabel
    Left = 224
    Top = 282
    Width = 154
    Height = 33
    Caption = #10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clChartreuse
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label13: TLabel
    Left = 8
    Top = 266
    Width = 81
    Height = 19
    Caption = 'Development'
  end
  object DevNegLabel: TLabel
    Left = 147
    Top = 258
    Width = 77
    Height = 33
    Alignment = taRightJustify
    Caption = #10096#10096#10096#10096#10096#10096#10096
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DevPosLabel: TLabel
    Left = 224
    Top = 258
    Width = 154
    Height = 33
    Caption = #10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clChartreuse
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label16: TLabel
    Left = 8
    Top = 362
    Width = 42
    Height = 19
    Caption = 'Wealth'
  end
  object WealthNegLabel: TLabel
    Left = 147
    Top = 354
    Width = 77
    Height = 33
    Alignment = taRightJustify
    Caption = #10096#10096#10096#10096#10096#10096#10096
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object WealthPosLabel: TLabel
    Left = 224
    Top = 354
    Width = 154
    Height = 33
    Caption = #10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clChartreuse
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label19: TLabel
    Left = 8
    Top = 339
    Width = 118
    Height = 19
    Caption = 'Standard of Living'
  end
  object LivNegLabel: TLabel
    Left = 147
    Top = 331
    Width = 77
    Height = 33
    Alignment = taRightJustify
    Caption = #10096#10096#10096#10096#10096#10096#10096
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LivPosLabel: TLabel
    Left = 224
    Top = 331
    Width = 154
    Height = 33
    Caption = #10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097#10097
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clChartreuse
    Font.Height = -27
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label22: TLabel
    Left = 8
    Top = 391
    Width = 116
    Height = 19
    Caption = 'Base Market Econ.'
  end
  object EconomyLabel: TLabel
    Left = 146
    Top = 391
    Width = 154
    Height = 19
    Caption = '----------------------'
  end
  object EconomyInflLabel: TLabel
    Left = 146
    Top = 416
    Width = 154
    Height = 19
    Caption = '----------------------'
  end
  object Label25: TLabel
    Left = 8
    Top = 416
    Width = 118
    Height = 19
    Caption = 'Economy Influence'
  end
  object Label26: TLabel
    Left = 9
    Top = 218
    Width = 59
    Height = 19
    Caption = 'Comment'
  end
  object Label27: TLabel
    Left = 9
    Top = 150
    Width = 31
    Height = 19
    Caption = 'Body'
  end
  object Label28: TLabel
    Left = 8
    Top = 441
    Width = 47
    Height = 19
    Caption = 'CP Cost'
  end
  object CPCostLabel: TLabel
    Left = 146
    Top = 441
    Width = 154
    Height = 19
    Caption = '----------------------'
  end
  object Label30: TLabel
    Left = 8
    Top = 466
    Width = 107
    Height = 19
    Caption = 'Est./Req. Haul (t)'
  end
  object EstHaulLabel: TLabel
    Left = 146
    Top = 466
    Width = 154
    Height = 19
    Caption = '----------------------'
    OnClick = EstHaulLabelClick
  end
  object CPRewardLabel: TLabel
    Left = 424
    Top = 441
    Width = 154
    Height = 19
    Caption = '----------------------'
  end
  object Label33: TLabel
    Left = 329
    Top = 441
    Width = 73
    Height = 19
    Caption = ' CP Reward'
  end
  object SecLabel: TLabel
    Left = 422
    Top = 314
    Width = 35
    Height = 19
    Caption = '-----'
  end
  object TechLabel: TLabel
    Left = 422
    Top = 290
    Width = 35
    Height = 19
    Caption = '-----'
  end
  object DevLabel: TLabel
    Left = 422
    Top = 267
    Width = 35
    Height = 19
    Caption = '-----'
  end
  object WealthLabel: TLabel
    Left = 422
    Top = 364
    Width = 35
    Height = 19
    Caption = '-----'
  end
  object LivLabel: TLabel
    Left = 422
    Top = 339
    Width = 35
    Height = 19
    Caption = '-----'
  end
  object Label7: TLabel
    Left = 8
    Top = 76
    Width = 41
    Height = 19
    Caption = 'Status'
  end
  object Label9: TLabel
    Left = 9
    Top = 184
    Width = 90
    Height = 19
    Caption = 'Linked Market'
  end
  object Label11: TLabel
    Left = 9
    Top = 491
    Width = 88
    Height = 19
    Caption = 'Requirements'
  end
  object ReqLabel: TLabel
    Left = 147
    Top = 491
    Width = 154
    Height = 19
    Caption = '----------------------'
  end
  object Label12: TLabel
    Left = 333
    Top = 466
    Width = 80
    Height = 19
    Caption = 'Primary Port'
    OnClick = Label12Click
  end
  object Label14: TLabel
    Left = 333
    Top = 491
    Width = 73
    Height = 19
    Caption = 'Build Order'
  end
  object Label15: TLabel
    Left = 352
    Top = 182
    Width = 43
    Height = 19
    Caption = 'Layout'
  end
  object Label17: TLabel
    Left = 590
    Top = 120
    Width = 17
    Height = 19
    Caption = '[...]'
    OnClick = Label17Click
  end
  object Label18: TLabel
    Left = 353
    Top = 148
    Width = 46
    Height = 19
    Caption = 'Faction'
  end
  object Label20: TLabel
    Left = 8
    Top = 8
    Width = 46
    Height = 19
    Caption = 'System'
  end
  object SystemLabel: TLabel
    Left = 147
    Top = 8
    Width = 154
    Height = 19
    Caption = '----------------------'
    OnClick = SystemLabelClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 546
    Width = 615
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 563
    object OKButton: TButton
      Left = 378
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = OKButtonClick
    end
    object CancelButton: TButton
      Left = 540
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = CancelButtonClick
    end
    object NextButton: TButton
      Left = 459
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Next'
      TabOrder = 2
      OnClick = NextButtonClick
    end
    object PasteMatButton: TButton
      Left = 9
      Top = 8
      Width = 106
      Height = 25
      Caption = 'Paste Mat.'
      TabOrder = 3
      OnClick = PasteMatButtonClick
    end
    object SetActiveButton: TButton
      Left = 121
      Top = 8
      Width = 106
      Height = 25
      Caption = 'Set Active'
      TabOrder = 4
      OnClick = SetActiveButtonClick
    end
  end
  object CommentEdit: TEdit
    Left = 147
    Top = 215
    Width = 437
    Height = 27
    ParentColor = True
    TabOrder = 1
    OnChange = CommentEditChange
  end
  object PlannedStatus: TRadioButton
    Left = 146
    Top = 78
    Width = 20
    Height = 17
    TabOrder = 2
    OnClick = PlannedStatusClick
  end
  object StatusRadio2: TRadioButton
    Left = 257
    Top = 78
    Width = 19
    Height = 17
    TabOrder = 3
    OnClick = PlannedStatusClick
  end
  object CancelledStatus: TRadioButton
    Left = 497
    Top = 78
    Width = 20
    Height = 17
    TabOrder = 4
    OnClick = PlannedStatusClick
  end
  object FinishedStatus: TRadioButton
    Left = 385
    Top = 78
    Width = 19
    Height = 17
    TabOrder = 5
    OnClick = PlannedStatusClick
  end
  object TypeCombo: TComboBox
    Left = 147
    Top = 112
    Width = 437
    Height = 27
    Style = csDropDownList
    DropDownCount = 20
    ParentColor = True
    Sorted = True
    TabOrder = 6
    OnChange = TypeComboChange
  end
  object NameEdit: TEdit
    Left = 147
    Top = 40
    Width = 437
    Height = 27
    ParentColor = True
    TabOrder = 7
    OnChange = NameEditChange
  end
  object BodyCombo: TComboBox
    Left = 147
    Top = 147
    Width = 190
    Height = 27
    DropDownCount = 20
    ParentColor = True
    TabOrder = 8
    OnChange = BodyComboChange
  end
  object LinkedStationCombo: TComboBox
    Left = 147
    Top = 181
    Width = 190
    Height = 27
    Style = csDropDownList
    DropDownCount = 20
    ParentColor = True
    Sorted = True
    TabOrder = 9
    OnChange = LinkedStationComboChange
  end
  object PrimaryCheck: TCheckBox
    Left = 423
    Top = 468
    Width = 17
    Height = 17
    TabOrder = 10
    OnClick = PrimaryCheckClick
  end
  object BuildOrderEdit: TEdit
    Left = 424
    Top = 489
    Width = 64
    Height = 27
    NumbersOnly = True
    ParentColor = True
    TabOrder = 11
    OnChange = CommentEditChange
  end
  object BuildOrderUpDown: TUpDown
    Left = 487
    Top = 490
    Width = 17
    Height = 25
    Max = 1000
    TabOrder = 12
    OnClick = BuildOrderUpDownClick
  end
  object LayoutCombo: TComboBox
    Left = 410
    Top = 179
    Width = 174
    Height = 27
    DropDownCount = 20
    ParentColor = True
    TabOrder = 13
    OnChange = LayoutComboChange
  end
  object FactionCombo: TComboBox
    Left = 410
    Top = 145
    Width = 174
    Height = 27
    DropDownCount = 20
    ParentColor = True
    TabOrder = 14
    OnChange = BodyComboChange
  end
  object PopupMenu: TPopupMenu
    Left = 176
    Top = 456
    object PasteRequestMenuItem: TMenuItem
      Caption = 'Paste Request'
      OnClick = PasteRequestMenuItemClick
    end
    object UseAvgRequestMenuItem: TMenuItem
      Caption = 'Use Avg. Request'
      OnClick = UseAvgRequestMenuItemClick
    end
    object UseMaxRequestMenuItem: TMenuItem
      Tag = 1
      Caption = 'Use Max. Request'
      OnClick = UseAvgRequestMenuItemClick
    end
    object PasteRequest2: TMenuItem
      Caption = '-'
    end
    object ClearMatListMenuItem: TMenuItem
      Caption = 'Clear Request'
      OnClick = ClearMatListMenuItemClick
    end
  end
end
