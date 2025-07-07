unit Toolbar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Math;

type
  TToolbarForm = class(TForm)
    PlannedLabel: TLabel;
    ConstructionsLabel: TLabel;
    MarketsLabel: TLabel;
    SystemLabel: TLabel;
    InfoLabel: TLabel;
    ColoniesLabel: TLabel;
    SettingsLabel: TLabel;
    InProgressLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InfoLabelClick(Sender: TObject);
    procedure SystemLabelClick(Sender: TObject);
    procedure ColoniesLabelClick(Sender: TObject);
    procedure MarketsLabelClick(Sender: TObject);
    procedure ConstructionsLabelClick(Sender: TObject);
    procedure InProgressLabelClick(Sender: TObject);
    procedure PlannedLabelClick(Sender: TObject);
    procedure SettingsLabelClick(Sender: TObject);
    procedure InfoLabelMouseEnter(Sender: TObject);
    procedure PlannedLabelMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ApplySettings;
    procedure UpdatePosition;
  end;

var
  ToolbarForm: TToolbarForm;

implementation

{$R *.dfm}

uses Main;

procedure TToolbarForm.ApplySettings;
var i: Integer;
begin
  Font.Color := EDCDForm.TextColLabel.Font.Color;
  Font.Size := EDCDForm.TextColLabel.Font.Size + 6;

  Width := EDCDForm.Width;
  Height := Max(Font.Size + 12,Canvas.TextHeight('Wq') + 2);
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TLabel then
      TLabel(Components[i]).Width := self.Width div ComponentCount;

  UpdatePosition;
end;

procedure TToolbarForm.UpdatePosition;
begin
  self.Left := EDCDForm.Left;
  self.Top := EDCDForm.Top + EDCDForm.Height; // - self.Height;
end;

procedure TToolbarForm.ColoniesLabelClick(Sender: TObject);
begin
  EDCDForm.ManageColoniesMenuItemClick(Sender);
end;

procedure TToolbarForm.ConstructionsLabelClick(Sender: TObject);
begin
  EDCDForm.ActiveConstrMenuItemClick(Sender);
end;

procedure TToolbarForm.FormCreate(Sender: TObject);
begin
  ApplySettings;
end;

procedure TToolbarForm.FormShow(Sender: TObject);
begin
  UpdatePosition;
end;

procedure TToolbarForm.InfoLabelClick(Sender: TObject);
begin
  EDCDForm.AddDepotInfoMenuItemClick(Sender);
end;

procedure TToolbarForm.InfoLabelMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Color := $303030;
end;

procedure TToolbarForm.InProgressLabelClick(Sender: TObject);
begin
  EDCDForm.ActiveConstrMenuItemClick(Sender);
end;

procedure TToolbarForm.MarketsLabelClick(Sender: TObject);
begin
  EDCDForm.ManageMarketsMenuItemClick(Sender);
end;

procedure TToolbarForm.PlannedLabelClick(Sender: TObject);
begin
  EDCDForm.ActiveConstrMenuItemClick(Sender);
end;

procedure TToolbarForm.PlannedLabelMouseLeave(Sender: TObject);
begin
   TLabel(Sender).Color := clBlack;
end;

procedure TToolbarForm.SettingsLabelClick(Sender: TObject);
begin
  EDCDForm.SettingsMenuItemClick(Sender);
end;

procedure TToolbarForm.SystemLabelClick(Sender: TObject);
begin
  EDCDForm.SystemInfoCurrentMenuItemClick(Sender);
end;

end.


