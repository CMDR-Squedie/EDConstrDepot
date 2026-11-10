unit BodyInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DataSource, Settings,
  System.StrUtils, System.DateUtils, Vcl.ComCtrls, Vcl.Menus, System.Math;

type
  TBodyInfoForm = class(TForm)
    Panel1: TPanel;
    CommentEdit: TEdit;
    Label1: TLabel;
    OKButton: TButton;
    CancelButton: TButton;
    NameEdit: TEdit;
    Label26: TLabel;
    NextButton: TButton;
    Label20: TLabel;
    SystemLabel: TLabel;
    Label2: TLabel;
    BioEdit: TEdit;
    Label3: TLabel;
    GeoEdit: TEdit;
    Label4: TLabel;
    HumEdit: TEdit;
    Label5: TLabel;
    OrbSlotsEdit: TEdit;
    Label6: TLabel;
    SurfSlotsEdit: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    TypeLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure CommentEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure SystemLabelClick(Sender: TObject);
  private
    { Private declarations }
    FCurrentBody: TSystemBody;
    FCurrentSystem: TStarSystem;
    FDataChanged: Boolean;
    procedure Save;
  public
    { Public declarations }
    procedure SetBody(b: TSystemBody);
    procedure ApplySettings;
    procedure RestoreAndShow;
    property CurrentBody: TSystemBody read FCurrentBody;
  end;

var
  BodyInfoForm: TBodyInfoForm;

implementation

{$R *.dfm}

uses SystemInfo, Main, MaterialList, ConstrTypes, Splash, Clipbrd;

procedure TBodyInfoForm.RestoreAndShow;
begin
  if WindowState = wsMinimized then WindowState := wsNormal;
  Show;
end;

procedure TBodyInfoForm.Save;
begin
  if FDataChanged then
  begin
    DataSrc.BeginUpdate;
    try

      FCurrentBody.BodyName := NameEdit.Text;
      FCurrentBody.Comment := CommentEdit.Text;
      FCurrentBody.BiologicalSignals := StrToIntDef(BioEdit.Text,0);
      FCurrentBody.GeologicalSignals := StrToIntDef(GeoEdit.Text,0);
      FCurrentBody.HumanSignals := StrToIntDef(HumEdit.Text,0);
      FCurrentBody.OrbSlots := StrToIntDef(OrbSlotsEdit.Text,0);
      FCurrentBody.SurfSlots := StrToIntDef(SurfSlotsEdit.Text,0);

      FCurrentBody.FeaturesModified := True;
      FCurrentBody.SysData.ResetEconomies;
      FCurrentBody.SysData.Save;
      FDataChanged := False;
    finally
      DataSrc.EndUpdate;
    end;
  end;
end;

procedure TBodyInfoForm.OKButtonClick(Sender: TObject);
begin
  Save;
  Close;
end;

procedure TBodyInfoForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TBodyInfoForm.CommentEditChange(Sender: TObject);
begin
  FDataChanged := True;
end;

procedure TBodyInfoForm.FormCreate(Sender: TObject);
begin
  ApplySettings;
end;

procedure TBodyInfoForm.FormShow(Sender: TObject);
begin
  CommentEdit.SetFocus;
end;

procedure TBodyInfoForm.SetBody(b: TSystemBody);
var i: Integer;
begin
  FCurrentBody := b;
  FCurrentSystem := b.SysData;
  SystemLabel.Caption := FCurrentSystem.StarSystem;
  if FCurrentSystem <> nil then
    if FCurrentSystem.AlterName <> '' then
      SystemLabel.Caption := FCurrentSystem.StarSystem + ' (' + FCurrentSystem.AlterName + ')';
  TypeLabel.Caption := FCurrentBody.BodyType;
  NameEdit.Text := FCurrentBody.BodyName;
  CommentEdit.Text := FCurrentBody.Comment;
  BioEdit.Text := IfThen(FCurrentBody.BiologicalSignals>0,FCurrentBody.BiologicalSignals.ToString,'');
  GeoEdit.Text := IfThen(FCurrentBody.GeologicalSignals>0,FCurrentBody.GeologicalSignals.ToString,'');
  HumEdit.Text := IfThen(FCurrentBody.HumanSignals>0,FCurrentBody.HumanSignals.ToString,'');
  OrbSlotsEdit.Text := IfThen(FCurrentBody.OrbSlots>0,FCurrentBody.OrbSlots.ToString,'');
  SurfSlotsEdit.Text := IfThen(FCurrentBody.SurfSlots>0,FCurrentBody.SurfSlots.ToString,'');
  FDataChanged := False;
end;

procedure TBodyInfoForm.SystemLabelClick(Sender: TObject);
begin
  Clipboard.AsText := SystemLabel.Caption;
  SplashForm.ShowInfo('System name copied...',1000);
end;

procedure TBodyInfoForm.NextButtonClick(Sender: TObject);
var b: TSystemBody;
    idx: Integer;
begin
  if not SystemInfoForm.Visible then Exit;
  if SystemInfoForm.CurrentSystem <> FCurrentSystem then Exit;
  idx := FCurrentSystem.Bodies.IndexOf(FCurrentBody.BodyID);
  if idx < 0 then Exit;
  idx := idx + 1;
  if idx >= FCurrentSystem.Bodies.Count then idx := 0;
  b := TSystemBody(FCurrentSystem.Bodies.Objects[idx]);
  if b <> nil then
  begin
    Save;
    SetBody(b);
  end;
end;

procedure TBodyInfoForm.ApplySettings;
var i,fs: Integer;
    fn: string;
    clr: TColor;
begin
  ShowInTaskBar := Opts.Flags['ShowInTaskbar'];
  if not Opts.Flags['DarkMode'] then
  begin
    Color := clSilver;
    Font.Color := clBlack;
  end
  else
  begin
    clr := EDCDForm.TextColLabel.Font.Color;
    Color := $4A4136 - $202020;
    Font.Color := clr;
  end;
  Font.Name := Opts['FontName2'];
//  Font.Size := Opts.Int['FontSize2'];

end;


end.
