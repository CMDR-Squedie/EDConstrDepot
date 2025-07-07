object StationInfoForm: TStationInfoForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Construction Info'
  ClientHeight = 565
  ClientWidth = 563
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
    Top = 350
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
    Top = 326
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
    Top = 254
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
    Top = 278
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
    Top = 302
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
    Top = 19
    Width = 36
    Height = 19
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 173
    Top = 52
    Width = 51
    Height = 19
    Caption = 'Planned'
    FocusControl = PlannedStatus
    OnClick = Label2Click
  end
  object Label3: TLabel
    Left = 285
    Top = 52
    Width = 72
    Height = 19
    Caption = 'In Progress'
    FocusControl = StatusRadio2
    OnClick = Label2Click
  end
  object Label4: TLabel
    Left = 506
    Top = 63
    Width = 49
    Height = 19
    Caption = 'On Hold'
    Visible = False
  end
  object Label5: TLabel
    Left = 408
    Top = 52
    Width = 53
    Height = 19
    Caption = 'Finished'
    FocusControl = FinishedStatus
    OnClick = Label2Click
  end
  object Label6: TLabel
    Left = 8
    Top = 310
    Width = 52
    Height = 19
    Caption = 'Security'
  end
  object SecPosLabel: TLabel
    Left = 224
    Top = 302
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
    Top = 122
    Width = 28
    Height = 19
    Caption = 'Type'
  end
  object SecNegLabel: TLabel
    Left = 147
    Top = 302
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
    Top = 286
    Width = 69
    Height = 19
    Caption = 'Technology'
  end
  object TechNegLabel: TLabel
    Left = 147
    Top = 278
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
    Top = 278
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
    Top = 262
    Width = 81
    Height = 19
    Caption = 'Development'
  end
  object DevNegLabel: TLabel
    Left = 147
    Top = 254
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
    Top = 254
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
    Top = 358
    Width = 42
    Height = 19
    Caption = 'Wealth'
  end
  object WealthNegLabel: TLabel
    Left = 147
    Top = 350
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
    Top = 350
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
    Top = 335
    Width = 118
    Height = 19
    Caption = 'Standard of Living'
  end
  object LivNegLabel: TLabel
    Left = 147
    Top = 327
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
    Top = 327
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
    Top = 387
    Width = 79
    Height = 19
    Caption = 'Base Market'
  end
  object EconomyLabel: TLabel
    Left = 146
    Top = 387
    Width = 154
    Height = 19
    Caption = '----------------------'
  end
  object EconomyInflLabel: TLabel
    Left = 146
    Top = 412
    Width = 154
    Height = 19
    Caption = '----------------------'
  end
  object Label25: TLabel
    Left = 8
    Top = 412
    Width = 118
    Height = 19
    Caption = 'Economy Influence'
  end
  object Label26: TLabel
    Left = 8
    Top = 220
    Width = 59
    Height = 19
    Caption = 'Comment'
  end
  object Label27: TLabel
    Left = 8
    Top = 89
    Width = 31
    Height = 19
    Caption = 'Body'
  end
  object Label28: TLabel
    Left = 8
    Top = 437
    Width = 47
    Height = 19
    Caption = 'CP Cost'
  end
  object CPCostLabel: TLabel
    Left = 146
    Top = 437
    Width = 154
    Height = 19
    Caption = '----------------------'
  end
  object Label30: TLabel
    Left = 8
    Top = 462
    Width = 107
    Height = 19
    Caption = 'Est./Req. Haul (t)'
  end
  object EstHaulLabel: TLabel
    Left = 146
    Top = 462
    Width = 154
    Height = 19
    Caption = '----------------------'
    OnClick = EstHaulLabelClick
  end
  object CPRewardLabel: TLabel
    Left = 424
    Top = 437
    Width = 154
    Height = 19
    Caption = '----------------------'
  end
  object Label33: TLabel
    Left = 329
    Top = 437
    Width = 73
    Height = 19
    Caption = ' CP Reward'
  end
  object SecLabel: TLabel
    Left = 422
    Top = 310
    Width = 35
    Height = 19
    Caption = '-----'
  end
  object TechLabel: TLabel
    Left = 422
    Top = 286
    Width = 35
    Height = 19
    Caption = '-----'
  end
  object DevLabel: TLabel
    Left = 422
    Top = 263
    Width = 35
    Height = 19
    Caption = '-----'
  end
  object WealthLabel: TLabel
    Left = 422
    Top = 360
    Width = 35
    Height = 19
    Caption = '-----'
  end
  object LivLabel: TLabel
    Left = 422
    Top = 335
    Width = 35
    Height = 19
    Caption = '-----'
  end
  object Label7: TLabel
    Left = 8
    Top = 52
    Width = 41
    Height = 19
    Caption = 'Status'
  end
  object Label9: TLabel
    Left = 9
    Top = 187
    Width = 91
    Height = 19
    Caption = 'Linked Station'
  end
  object Label11: TLabel
    Left = 9
    Top = 487
    Width = 88
    Height = 19
    Caption = 'Requirements'
  end
  object ReqLabel: TLabel
    Left = 147
    Top = 487
    Width = 154
    Height = 19
    Caption = '----------------------'
  end
  object Label12: TLabel
    Left = 333
    Top = 462
    Width = 80
    Height = 19
    Caption = 'Primary Port'
    OnClick = Label12Click
  end
  object Label14: TLabel
    Left = 333
    Top = 487
    Width = 73
    Height = 19
    Caption = 'Build Order'
  end
  object Label15: TLabel
    Left = 8
    Top = 154
    Width = 43
    Height = 19
    Caption = 'Layout'
  end
  object Panel1: TPanel
    Left = 0
    Top = 524
    Width = 563
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object OKButton: TButton
      Left = 288
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = OKButtonClick
    end
    object CancelButton: TButton
      Left = 472
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = CancelButtonClick
    end
    object NextButton: TButton
      Left = 381
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Next'
      TabOrder = 2
      OnClick = NextButtonClick
    end
  end
  object CommentEdit: TEdit
    Left = 146
    Top = 217
    Width = 393
    Height = 27
    ParentColor = True
    TabOrder = 1
    OnChange = CommentEditChange
  end
  object PlannedStatus: TRadioButton
    Left = 146
    Top = 54
    Width = 24
    Height = 17
    TabOrder = 2
    OnClick = PlannedStatusClick
  end
  object StatusRadio2: TRadioButton
    Left = 260
    Top = 54
    Width = 24
    Height = 17
    TabOrder = 3
    OnClick = PlannedStatusClick
  end
  object StatusRadio3: TRadioButton
    Left = 476
    Top = 65
    Width = 24
    Height = 17
    TabOrder = 4
    Visible = False
  end
  object FinishedStatus: TRadioButton
    Left = 381
    Top = 54
    Width = 24
    Height = 17
    TabOrder = 5
    OnClick = PlannedStatusClick
  end
  object TypeCombo: TComboBox
    Left = 146
    Top = 119
    Width = 393
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
    Top = 16
    Width = 393
    Height = 27
    ParentColor = True
    TabOrder = 7
    OnChange = NameEditChange
  end
  object BodyCombo: TComboBox
    Left = 146
    Top = 86
    Width = 393
    Height = 27
    DropDownCount = 20
    ParentColor = True
    TabOrder = 8
    OnChange = BodyComboChange
  end
  object LinkedStationCombo: TComboBox
    Left = 147
    Top = 184
    Width = 393
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
    Top = 464
    Width = 17
    Height = 17
    TabOrder = 10
    OnClick = PrimaryCheckClick
  end
  object BuildOrderEdit: TEdit
    Left = 424
    Top = 485
    Width = 64
    Height = 27
    NumbersOnly = True
    ParentColor = True
    TabOrder = 11
    OnChange = CommentEditChange
  end
  object BuildOrderUpDown: TUpDown
    Left = 487
    Top = 486
    Width = 17
    Height = 25
    Max = 1000
    TabOrder = 12
    OnClick = BuildOrderUpDownClick
  end
  object LayoutCombo: TComboBox
    Left = 146
    Top = 151
    Width = 393
    Height = 27
    DropDownCount = 20
    ParentColor = True
    TabOrder = 13
    OnChange = LayoutComboChange
  end
end
