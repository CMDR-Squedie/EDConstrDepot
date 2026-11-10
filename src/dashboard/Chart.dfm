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
    OnMouseDown = SvgAreaMouseDown
    ExplicitLeft = 3
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
end
