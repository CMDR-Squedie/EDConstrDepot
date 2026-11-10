object TooltipForm: TTooltipForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 18
  ClientWidth = 223
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object InfoLabel: TLabel
    Left = 0
    Top = 0
    Width = 223
    Height = 18
    Align = alClient
    Alignment = taCenter
    Caption = 'InfoLabel'
    ExplicitWidth = 49
    ExplicitHeight = 15
  end
end
