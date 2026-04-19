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
end
