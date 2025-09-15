object BodyInfoForm: TBodyInfoForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Body Info'
  ClientHeight = 314
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
  object Label1: TLabel
    Left = 9
    Top = 75
    Width = 36
    Height = 19
    Caption = 'Name'
  end
  object Label26: TLabel
    Left = 8
    Top = 108
    Width = 59
    Height = 19
    Caption = 'Comment'
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
    Width = 238
    Height = 19
    Caption = '----------------------'
    OnClick = SystemLabelClick
  end
  object Label2: TLabel
    Left = 8
    Top = 141
    Width = 123
    Height = 19
    Caption = 'Signals - biological'
  end
  object Label3: TLabel
    Left = 229
    Top = 141
    Width = 75
    Height = 19
    Alignment = taRightJustify
    Caption = '- geological'
  end
  object Label4: TLabel
    Left = 422
    Top = 141
    Width = 55
    Height = 19
    Caption = '- human'
  end
  object Label5: TLabel
    Left = 8
    Top = 174
    Width = 121
    Height = 19
    Caption = 'Total slots - orbital'
  end
  object Label6: TLabel
    Left = 8
    Top = 204
    Width = 127
    Height = 19
    Caption = 'Total slots - surface'
  end
  object Label7: TLabel
    Left = 147
    Top = 237
    Width = 408
    Height = 16
    AutoSize = False
    Caption = 'Enter number of all construction slots, including already used'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -13
    Font.Name = 'Bahnschrift SemiCondensed'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 8
    Top = 39
    Width = 28
    Height = 19
    Caption = 'Type'
  end
  object TypeLabel: TLabel
    Left = 147
    Top = 39
    Width = 238
    Height = 19
    Caption = '----------------------'
    OnClick = SystemLabelClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 273
    Width = 563
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 546
    object OKButton: TButton
      Left = 310
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
      Left = 391
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Next'
      TabOrder = 2
      OnClick = NextButtonClick
    end
  end
  object CommentEdit: TEdit
    Left = 147
    Top = 105
    Width = 393
    Height = 27
    ParentColor = True
    TabOrder = 1
    OnChange = CommentEditChange
  end
  object NameEdit: TEdit
    Left = 147
    Top = 72
    Width = 393
    Height = 27
    ParentColor = True
    TabOrder = 2
    OnChange = CommentEditChange
  end
  object BioEdit: TEdit
    Left = 147
    Top = 138
    Width = 54
    Height = 27
    NumbersOnly = True
    ParentColor = True
    TabOrder = 3
    OnChange = CommentEditChange
  end
  object GeoEdit: TEdit
    Left = 310
    Top = 138
    Width = 54
    Height = 27
    NumbersOnly = True
    ParentColor = True
    TabOrder = 4
    OnChange = CommentEditChange
  end
  object HumEdit: TEdit
    Left = 486
    Top = 138
    Width = 54
    Height = 27
    NumbersOnly = True
    ParentColor = True
    TabOrder = 5
    OnChange = CommentEditChange
  end
  object OrbSlotsEdit: TEdit
    Left = 147
    Top = 171
    Width = 54
    Height = 27
    NumbersOnly = True
    ParentColor = True
    TabOrder = 6
    OnChange = CommentEditChange
  end
  object SurfSlotsEdit: TEdit
    Left = 147
    Top = 204
    Width = 54
    Height = 27
    NumbersOnly = True
    ParentColor = True
    TabOrder = 7
    OnChange = CommentEditChange
  end
end
