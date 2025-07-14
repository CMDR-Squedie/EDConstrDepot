object SystemPictForm: TSystemPictForm
  Left = 0
  Top = 0
  Width = 776
  Height = 480
  AutoScroll = True
  Caption = 'System Picture'
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  PopupMenu = PopupMenu
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 15
  object SysImage: TImage
    Left = 0
    Top = 25
    Width = 760
    Height = 416
    Align = alClient
    PopupMenu = PopupMenu
    ExplicitLeft = 48
    ExplicitTop = 96
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 760
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    Color = clBackground
    ParentBackground = False
    TabOrder = 0
    object SysLabel: TLabel
      Left = 0
      Top = 0
      Width = 520
      Height = 25
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = '()'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAzure
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = PopupMenu
      ExplicitWidth = 537
    end
    object InfoLabel: TLabel
      Left = 520
      Top = 0
      Width = 240
      Height = 25
      Align = alRight
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Bahnschrift SemiCondensed'
      Font.Style = []
      ParentFont = False
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 352
    Top = 136
    object PastePictureMenuItem: TMenuItem
      Caption = 'Paste Picture'
      ShortCut = 16470
      OnClick = PastePictureMenuItemClick
    end
    object SavePictureMenuItem: TMenuItem
      Caption = 'Save Picture'
      ShortCut = 16467
      OnClick = SavePictureMenuItemClick
    end
    object EditPictureMenuItem: TMenuItem
      Caption = 'Edit Picture'
      OnClick = EditPictureMenuItemClick
    end
    object ReloadPictureMenuItem: TMenuItem
      Caption = 'Refresh'
      OnClick = ReloadPictureMenuItemClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ClearPictureMenuItem: TMenuItem
      Caption = 'Clear Picture'
      OnClick = ClearPictureMenuItemClick
    end
  end
end
