unit MaterialList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, System.Types,
  System.StrUtils, System.JSON, DataSource;

type
  TMaterialListForm = class(TForm)
    Panel1: TPanel;
    StationLabel: TLabel;
    CopyButton: TButton;
    ListView: TListView;
    PasteButton: TButton;
    JSONButton: TButton;
    EstCargoLabel: TLabel;
    CalcCargoLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure PasteButtonClick(Sender: TObject);
    procedure ListViewKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure JSONButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
  private
    { Private declarations }
    FCurrentCType: TConstructionType;
    FConstructionType: TConstructionType;
    procedure UpdateList(sl: TStringList);
  public
    { Public declarations }
    procedure ApplySettings;
    procedure SetConstructionType(ct: TConstructionType);
  end;

var
  MaterialListForm: TMaterialListForm;

implementation

{$R *.dfm}

uses Settings, Main, Clipbrd;

procedure TMaterialListForm.CopyButtonClick(Sender: TObject);
var s: string;
    i: Integer;
begin
  s := '';
  for i := 0 to ListView.Items.Count - 1 do
    s := s + ListView.Items[i].Caption + Chr(9) + ListView.Items[i].SubItems[0] + Chr(13);
  Clipboard.AsText := s;
end;

procedure TMaterialListForm.FormCreate(Sender: TObject);
begin
  ApplySettings;
  JSONButton.Visible := Opts.Flags['DevMode'];
  PasteButton.Visible := Opts.Flags['DevMode'];
  ListView.Items.Clear;
end;

procedure TMaterialListForm.JSONButtonClick(Sender: TObject);
var jarr: TJSONArray;
    j,req: TJSONObject;
    s: string;
    i: Integer;
begin
  j := TJSONObject.Create;
  jarr := TJSONArray.Create;
  j.AddPair(TJSONPair.Create('ResourcesRequired', jarr));
  for i := 0 to ListView.Items.Count - 1 do
  begin
    req := TJSONObject.Create;
    req.AddPair('Name',ListView.Items[i].Caption);
    req.AddPair('Quantity',StrToInt(ListView.Items[i].SubItems[0]));
    jarr.Add(req);
  end;
  s := j.Format(0);
  s := s.Replace(Chr(13)+Chr(10),'');
  s := s.Replace(Chr(13),'');
  s := Copy(s,2,Length(s)-2);
  Clipboard.AsText := s;
  j.Free;
end;

procedure TMaterialListForm.ListViewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_DELETE then Exit;
  if ListView.Selected = nil then Exit;
  ListView.DeleteSelected;
end;

procedure TMaterialListForm.UpdateList(sl: TStringList);
var item: TListItem;
    i: Integer;
    totQty: Integer;
    nm,s: string;
begin
  totQty := 0;
  ListView.Items.Clear;
  for i := 0 to sl.Count - 1 do
  begin
    item := ListView.Items.Add;
    nm := sl.Names[i];
    item.Caption := nm;
    item.SubItems.Add(sl.ValueFromIndex[i]);
    if FCurrentCType <> nil then
    begin
      item.SubItems.Add(FCurrentCType.MinResources.Values[nm]);
      item.SubItems.Add(FCurrentCType.MaxResources.Values[nm]);
    end;
    totQty := totQty + StrToIntDef(sl.ValueFromIndex[i],0);
  end;
  for i := 0 to ListView.Columns.Count - 2 do
  begin
     ListView.Column[i].Width := -2;
  end;
  ListView.Column[ListView.Columns.Count - 1].Width := -1;
  CalcCargoLabel.Caption := 'Calc. Cargo: ' + totQty.ToString;
end;

procedure TMaterialListForm.PasteButtonClick(Sender: TObject);
var sl,sl2: TStringList;
    s: string;
    i: Integer;
    sarr,sarr2: TStringDynArray;
    procLines: Integer;
begin
  if not Clipboard.HasFormat(CF_TEXT) then Exit;
  sl := TStringList.Create;
  sl2 := TStringList.Create;
  for i := 0 to ListView.Items.Count - 1 do
    sl2.AddPair(ListView.Items[i].Caption,ListView.Items[i].SubItems[0]);
  sl.Text := Clipboard.AsText;
  procLines := 0;
  try
    if sl.Count > 100 then Exit;
    i := 0;
    while i < sl.Count  do
    begin
      try
        s := Trim(sl[i]);
        sarr := SplitString(s,Chr(9));
        if Opts.Flags['DevMode'] and
          ((High(sarr) = 0) or (StrToIntDef(sarr[1],-1) = -1))  then  //in-game codex table layout
        begin
          i := i + 1;
          s := Trim(sl[i]);
          sarr[0] := DataSrc.ItemNames.Values[LowerCase(sarr[0])];
          sarr2 := SplitString(s,Chr(9));
          sarr2[0] := sarr2[0].Replace(',','');
          sarr2[0] := sarr2[0].Replace(' ','');
          sl2.Values[sarr[0]] := sarr2[0];
          if High(sarr) = 1 then
          begin
            sarr[1] := DataSrc.ItemNames.Values[LowerCase(sarr[1])];
            sarr2[1] := sarr2[1].Replace(',','');
            sarr2[1] := sarr2[1].Replace(' ','');
            sl2.Values[sarr[1]] := sarr2[1];
          end;
          procLines := procLines + 1;
        end
        else
        begin
          if High(sarr) <> 1 then continue;
          sarr[1] := sarr[1].Replace(',','');
          sl2.Values[sarr[0]] := sarr[1];
        end;
        procLines := procLines + 1;
      finally
        i := i + 1;
      end;
    end;
    if procLines <> sl.Count then
      ShowMessage('Skipped Lines: ' + IntToStr(sl.Count - procLines));

    if sl2.Count > 100 then Exit;
    sl2.Sort;
    UpdateList(sl2);
  finally
    sl.Free;
    sl2.Free;
  end;
end;

procedure TMaterialListForm.SetConstructionType(ct: TConstructionType);
var i: Integer;
    s: string;
begin
  StationLabel.Caption := ct.StationType_full;
  EstCargoLabel.Caption := 'Est. Cargo: ' + ct.EstCargo.ToString;
  CalcCargoLabel.Caption := '';
  FCurrentCType := ct;
  UpdateList(ct.ResourcesRequired);
end;

procedure TMaterialListForm.ApplySettings;
var i,fs: Integer;
    fn: string;
    clr: TColor;
begin
  if not Opts.Flags['DarkMode'] then
  begin
    with ListView do
    begin
      Color := clSilver;
      Font.Color := clBlack;
    end;
  end
  else
  begin
    clr := EDCDForm.TextColLabel.Font.Color;
    with ListView do
    begin
      Color := $6B5E4F; //$484848; $585140
      Font.Color := clr;
    end;
  end;
  with ListView do
  begin
    Font.Name := Opts['FontName2'];
    Font.Size := Opts.Int['FontSize2'];
  end;

end;

end.
