object SummaryForm: TSummaryForm
  Left = 0
  Top = 0
  Caption = 'Summary'
  ClientHeight = 628
  ClientWidth = 394
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
    Top = 24
    Width = 394
    Height = 604
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
  end
  object CmdrComboBox: TComboBox
    Left = 0
    Top = 0
    Width = 394
    Height = 24
    Align = alTop
    Style = csDropDownList
    TabOrder = 1
    OnChange = CmdrComboBoxChange
    Items.Strings = (
      '(all local commanders)')
    ExplicitLeft = 112
    ExplicitTop = 48
    ExplicitWidth = 145
  end
  object PopupMenu: TPopupMenu
    Left = 264
    Top = 160
    object CopyMenuItem: TMenuItem
      Caption = 'Copy'
      OnClick = CopyMenuItemClick
    end
  end
end
