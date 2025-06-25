unit SystemPict;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.Menus, DataSource, System.Math, Winapi.ShellAPI;

type
  TSystemPictForm = class(TForm)
    SysImage: TImage;
    PopupMenu: TPopupMenu;
    PastePictureMenuItem: TMenuItem;
    SavePictureMenuItem: TMenuItem;
    N1: TMenuItem;
    ClearPictureMenuItem: TMenuItem;
    Panel1: TPanel;
    SysLabel: TLabel;
    InfoLabel: TLabel;
    EditPictureMenuItem: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PastePictureMenuItemClick(Sender: TObject);
    procedure SavePictureMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearPictureMenuItemClick(Sender: TObject);
    procedure EditPictureMenuItemClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
  private
    { Private declarations }
    FCurrentSystem: TStarSystem;
    FImageChanged: Boolean;
    procedure TryPasteImage;
    procedure SavePicture;
    procedure ScaleWindow;
    procedure ApplySettings;
  public
    { Public declarations }
    procedure SetSystem(sid: string);
  end;

var
  SystemPictForm: TSystemPictForm;

implementation

{$R *.dfm}

uses Clipbrd, Main, Colonies, SystemInfo;

procedure TSystemPictForm.ClearPictureMenuItemClick(Sender: TObject);
begin
  if FCurrentSystem = nil then Exit;

  if Vcl.Dialogs.MessageDlg('Delete the system picture?',
     mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  DeleteFile(PChar(FCurrentSystem.ImagePath));
  FImageChanged := False;
  Close;
  if ColoniesForm.Visible then
    ColoniesForm.UpdateItems;
end;

procedure TSystemPictForm.EditPictureMenuItemClick(Sender: TObject);
begin
  if SysImage.Picture.Width = 0 then Exit;
  ShellExecute(0,'edit',PChar(FCurrentSystem.ImagePath),nil,nil,SW_SHOWNORMAL);
end;

procedure TSystemPictForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var res: TMsgDlgBtn;
begin
  CanClose := True;
  if FImageChanged then
  begin
    if Vcl.Dialogs.MessageDlg('Save the system picture?',
      mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes then
      SavePicture;
  end;
end;

procedure TSystemPictForm.FormCreate(Sender: TObject);
begin
  ApplySettings;
end;

procedure TSystemPictForm.PastePictureMenuItemClick(Sender: TObject);
begin
  TryPasteImage;
end;

procedure TSystemPictForm.SavePictureMenuItemClick(Sender: TObject);
begin
  SavePicture;
end;

procedure TSystemPictForm.PopupMenuPopup(Sender: TObject);
var picf: Boolean;
begin
  picf := SysImage.Picture.Width > 0;
  SavePictureMenuItem.Enabled := picf;
  EditPictureMenuItem.Enabled := picf;
end;

procedure TSystemPictForm.TryPasteImage;
var
  bmp: TBitmap;
begin
  if FCurrentSystem = nil then Exit;
  bmp := TBitmap.Create;
  if Clipboard.HasFormat(CF_BITMAP) then
  begin
    bmp.Assign(Clipboard);
    SysImage.Picture.Assign(bmp);
    ScaleWindow;
    FImageChanged := True;
  end;
  bmp.Free;
end;

procedure TSystemPictForm.SavePicture;
var png: TPngImage;
begin
  if FCurrentSystem = nil then Exit;
  if SysImage.Picture = nil then Exit;
  if SysImage.Picture.Width = 0 then Exit;

  png := TPngImage.Create;
  png.Assign(SysImage.Picture.Bitmap);
  png.SaveToFile(FCurrentSystem.ImagePath);
  FImageChanged := False;
  if ColoniesForm.Visible then
    ColoniesForm.UpdateItems;
  if SystemInfoForm.Visible then
    if SystemInfoForm.CurrentSystem = FCurrentSystem then
      SystemInfoForm.UpdateData;
end;

procedure TSystemPictForm.ScaleWindow;
var w,h: Integer;
begin
  w := Min(Screen.Width div 2,600);
  h := Min(Screen.Height div 4,200);
  if SysImage.Picture.Width > 0 then
  begin
    w := SysImage.Picture.Width;
    h := SysImage.Picture.Height
  end;
  SysImage.Width := w;
  SysImage.Height := h;
  ClientWidth := w;
  ClientHeight := h + SysLabel.Height;
end;

procedure TSystemPictForm.SetSystem(sid: string);
var png: TPngImage;
begin
  SysImage.Picture := nil;
  SysLabel.Caption := sid;
  FCurrentSystem := DataSrc.StarSystems.SystemByName[sid];
  if FCurrentSystem = nil then Exit;

  InfoLabel.Caption := 'last visited by: ' + DataSrc.Commanders.Values[FCurrentSystem.LastCmdr];

  png := TPngImage.Create;
  try
    png.LoadFromFile(FCurrentSystem.ImagePath);
    SysImage.Picture.Assign(png);
  except
  end;
  png.Free;
  ScaleWindow;
  FImageChanged := False;
end;

procedure TSystemPictForm.ApplySettings;
var i,fs: Integer;
    fn: string;
    clr: TColor;
begin
  clr := EDCDForm.TextColLabel.Font.Color;
  with SysLabel do
  begin
    Color := $4A4136; //$484848;
    Font.Color := clr;
  end;
end;


end.
