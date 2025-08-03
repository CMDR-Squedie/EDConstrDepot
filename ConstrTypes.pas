unit ConstrTypes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, DataSource,
  Vcl.StdCtrls, Vcl.Menus, System.Math, System.IniFiles, System.StrUtils, System.Types;

type
  TConstrTypesForm = class(TForm)
    ListView: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    FilterEdit: TComboBox;
    ClearFilterButton: TButton;
    AddToSystemCheck: TCheckBox;
    ServiceUnlocksButton: TButton;
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListViewAction(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure TaskGroupMenuItemClick(Sender: TObject);
//    procedure OtherGroupMenuItemClick(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormShow(Sender: TObject);
    procedure ClearFilterButtonClick(Sender: TObject);
    procedure FilterEditChange(Sender: TObject);
    procedure ServiceUnlocksButtonClick(Sender: TObject);
  private
    { Private declarations }
    SortColumn: Integer;
    ClickedColumn: Integer;
    SortAscending: Boolean;
  public
    { Public declarations }
    procedure ApplySettings;
    procedure UpdateItems(const _autoSizeCol: Boolean = true);
  end;

var
  ConstrTypesForm: TConstrTypesForm;

implementation

uses Main,Clipbrd,Settings,Splash, Markets, SystemPict, SystemInfo,
  MaterialList, Memo;

{$R *.dfm}


procedure TConstrTypesForm.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  gLastCursorPos := Mouse.CursorPos;
end;

procedure TConstrTypesForm.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var pt: TPoint;
begin
  Exit;
  if ssLeft in Shift then
  begin
    pt := Mouse.CursorPos;
    self.Left := self.Left + pt.X - gLastCursorPos.X;
    self.Top := self.Top + pt.Y - gLastCursorPos.Y;
    gLastCursorPos := pt;
  end;
end;

procedure TConstrTypesForm.ServiceUnlocksButtonClick(Sender: TObject);
begin
  MemoForm.Memo.Lines.LoadFromFile('station_services.txt',TEncoding.UTF8);
  MemoForm.Show;
end;

procedure TConstrTypesForm.ApplySettings;
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
      GridLines := True;
    end;
  end
  else
  begin
    clr := EDCDForm.TextColLabel.Font.Color;
    with ListView do
    begin
      Color := $4A4136; //$484848;
      Font.Color := clr;
      GridLines := False;
      //GridLines := False;
    end;

  end;
  with ListView do
  begin
    Font.Name := Opts['FontName2'];
    Font.Size := Opts.Int['FontSize2'];
    try
      Canvas.Font.Name := Opts['FontName2'];
      Canvas.Font.Size := Opts.Int['FontSize2'];
    except
    end;
  end;

  if Visible then UpdateItems;
end;


procedure TConstrTypesForm.ClearFilterButtonClick(Sender: TObject);
begin
  FilterEdit.Text := '';
  UpdateItems;
end;

procedure TConstrTypesForm.FilterEditChange(Sender: TObject);
begin
  UpdateItems;
end;

procedure TConstrTypesForm.FormCreate(Sender: TObject);
var i: Integer;
begin
  SortColumn := 0;
  SortAscending := True;
  self.Width := Min(self.Width,Screen.Width);
  ApplySettings;
end;


procedure TConstrTypesForm.FormShow(Sender: TObject);
begin
  UpdateItems;
end;

procedure TConstrTypesForm.UpdateItems(const _autoSizeCol: Boolean = true);
var
  i,j,curCol: Integer;
  s: string;
  item: TListItem;
  ct: TConstructionType;
  row: TStringList;
  ctcnt: TStock;
  fs,orgfs,cs: string;
  items: THashedStringList;
  colMaxLen: array [0..100] of Integer;
  colMaxTxt: array [0..100] of string;
  autoSizeCol,addingStats: Boolean;
  stats: string;
  fsarr: TStringDynArray;

  procedure addRow(data: TObject);
  var i,ln: Integer;
  begin
    for i := 0 to row.Count - 1 do
    begin
      ln := Length(row[i]);
      if ln > colMaxLen[i] then
      begin
        colMaxLen[i] := ln;
        colMaxTxt[i] := row[i];
      end;
    end;

    item := ListView.Items.Add;
    item.Data := data;
    item.Caption := row[0];
    row.Delete(0);
    item.SubItems.Assign(row);
  end;

  procedure addCaption(s: string);
  begin
    curCol := 0;
    row.Clear;
    row.Add(s);
  end;

  procedure addSubItem(s: string);
  begin
    curCol := curCol + 1;
    row.Add(s);

    if addingStats then
      if StrToIntDef(s,0) > 0 then
        stats := stats + ListView.Columns[curCol].Caption + ',';
  end;

  function CheckFilter: Boolean;
  var i,i2,mcnt: Integer;
      s: string;
  begin
    Result := True;
    if fs <> '' then
    begin
      for i2 := 0 to High(fsarr) do
        if fsarr[i2] <> '' then
        begin
          Result := False;
          for i := 0 to row.Count - 1 do
          if Pos(fsarr[i2],LowerCase(row[i])) > 0 then
          begin
            Result := true;
            break;
          end;
          if not Result then break;
        end;
    end;
  end;

  function tostr(i: Integer; const addsignf: Boolean = False): string;
  begin
    Result := '';
    if i <> 0 then Result := i.ToString;
    if addsignf then
      if i > 0  then
        Result := '+' + Result;
  end;

begin
  autoSizeCol := _autoSizeCol;
  if ListView.Items.Count = 0 then autoSizeCol := True;
//  autoSizeCol := autoSizeCol and Opts.Flags['AutoSizeColumns'];

  row := TStringList.Create;
  ctcnt := TStock.Create;

  for i := 0 to ListView.Columns.Count - 1 do
  begin
    colMaxLen[i] := Length(ListView.Columns[i].Caption);
    colMaxTxt[i] := ListView.Columns[i].Caption;
  end;

  ListView.Items.BeginUpdate;
  try
    ListView.Items.Clear;
    ListView.SortType := stNone;


    orgfs := FilterEdit.Text;
    fs := LowerCase(orgfs);
    fsarr := SplitString(fs,'+');

    for i := 0 to DataSrc.Constructions.Count - 1 do
      with DataSrc.Constructions.ConstrByIdx[i] do
        if Finished then
        if (GetSys <> nil) and (DataSrc.Commanders.Values[GetSys.Architect] <> '') then
          ctcnt.Qty[ConstructionType] := ctcnt.Qty[ConstructionType] + 1;

    for i := 0 to DataSrc.ConstructionTypes.Count - 1 do
    begin
      ct := TConstructionType(DataSrc.ConstructionTypes.TypeByIdx[i]);

      stats := '';

      addCaption('T' + ct.Tier);
      addingStats := False;
      addSubItem(ct.Location);
      addSubItem(ct.Category);
      addSubItem(ct.StationType);
      addSubItem(ct.Size);
      addSubItem(ct.Layouts);
      addSubItem(ct.Economy);
      addSubItem(ct.Influence);
      addSubItem(ct.Requirements);

      addingStats := True;
      addSubItem(tostr(ct.CP2,true));
      addSubItem(tostr(ct.CP3,true));
      addSubItem(tostr(ct.SecLev));
      addSubItem(tostr(ct.TechLev));
      addSubItem(tostr(ct.DevLev));
      addSubItem(tostr(ct.WealthLev));
      addSubItem(tostr(ct.StdLivLev));
      addingStats := False;
      addSubItem(tostr(ct.Score));
      addSubItem(tostr(ct.EstCargo));
      addSubItem(ctcnt.Values[ct.Id]);

      //this is hidden, actually equivalent to sorting but nice anyways
      addSubItem(stats);

      if CheckFilter then addRow(ct);
    end;

    if autoSizeCol then
    begin
      colMaxTxt[5] := Copy(colMaxTxt[5],1,35); //layouts
      for i := 0 to ListView.Columns.Count - 1 do
        ListView.Column[i].Width := ListView.Canvas.TextWidth(colMaxTxt[i]) + 15; //margins
    end;

    ListView.SortType := stText;
  finally
    ListView.Items.EndUpdate;
    row.Free;
  end;
end;

procedure TConstrTypesForm.ListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
   TListView(Sender).SortType := stNone;
  if SortColumn = Column.Index then
    SortAscending := not SortAscending
  else
    SortColumn := Column.Index;
  TListView(Sender).SortType := stText;
end;

procedure TConstrTypesForm.ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var s: string;
begin
  Compare := 0;
  if SortColumn <= 0 then
  begin
    Compare := CompareText(Item1.Caption, Item2.Caption);
  end
  else
  begin
    if SortColumn > 8 then
      Compare := CompareValue(StrToIntDef(Item1.SubItems[SortColumn-1],0),
        StrToIntDef(Item2.SubItems[SortColumn-1],0))
    else
      Compare := CompareText(
        Item1.SubItems[SortColumn-1] + '    ' + Item1.SubItems[6],
        Item2.SubItems[SortColumn-1] + '    ' + Item2.SubItems[6]);
  end;

  if not SortAscending then Compare := -Compare;
end;

procedure TConstrTypesForm.ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if cdsSelected in State then
  begin
    Sender.Canvas.Brush.Color := clHighLight;
  end
  else
  begin
    Sender.Canvas.Brush.Color := ListView.Color;
    if Item.Index mod 2 = 0 then
      Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color - $202020;
  end;

end;

procedure TConstrTypesForm.ListViewAction(Sender: TObject);
var sid: string;
    s,orgs: string;
    action: Integer;
    ct: TConstructionType;
    cd: TConstructionDepot;
    UUID: TGUID;
begin
  if ListView.Selected = nil then Exit;
  action := -1;
  if Sender is TListView then
  begin
    if ClickedColumn = -1 then Exit;
    action := ListView.Columns[ClickedColumn].Tag;
  end;
  ClickedColumn := -1;
  if Sender is TMenuItem then action := TMenuItem(Sender).Tag;
  if action = -1 then Exit;
  ct := TConstructionType(ListView.Selected.Data);

  if not AddToSystemCheck.Checked then
  begin
    MaterialListForm.SetConstructionType(ct);
    MaterialListForm.Show;
    Exit;
  end;

  if AddToSystemCheck.Checked then
  if SystemInfoForm.Visible then
  if SystemInfoForm.CurrentSystem.Bodies.Count > 0 then
  begin
    cd := TConstructionDepot.Create;
    cd.StarSystem := SystemInfoForm.CurrentSystem.StarSystem;
    cd.Body := TSystemBody(SystemInfoForm.CurrentSystem.Bodies.Objects[0]).BodyName;
    cd.ConstructionType := ct.Id;
    cd.Planned := True;
    cd.Modified := True;

    CreateGUID(UUID);
    cd.MarketId := GUIDToString(UUID);
    DataSrc.Constructions.AddObject(cd.MarketID,cd);
    SystemInfoForm.CurrentSystem.Save;
    SystemInfoForm.UpdateView;
    SystemInfoForm.BringToFront;
    self.BringToFront;
  end;

end;

procedure TConstrTypesForm.ListViewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  l: TListItem;
  i: integer;
  w,xm: integer;
begin
  ClickedColumn := -1;
  w := 0;
  xm := x + GetScrollPos(ListView.Handle,SB_HORZ);
  for i := 0 to ListView.Columns.Count - 1  do
  begin
    w := w + ListView.Column[i].Width;
    if w >= xm then
    begin
      ClickedColumn := i;
      break;
    end;
  end;
end;

end.
