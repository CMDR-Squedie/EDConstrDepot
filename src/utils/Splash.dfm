object SplashForm: TSplashForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'SplashForm'
  ClientHeight = 21
  ClientWidth = 236
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object InfoLabel: TLabel
    Left = 8
    Top = 0
    Width = 220
    Height = 24
    AutoSize = False
    Caption = 'Reading journal files ...'
    Color = clBackground
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clGoldenrod
    Font.Height = -13
    Font.Name = 'Bahnschrift Condensed'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = False
    StyleElements = [seFont, seClient]
  end
  object HideTimer: TTimer
    OnTimer = HideTimerTimer
    Left = 176
    Top = 8
  end
end
