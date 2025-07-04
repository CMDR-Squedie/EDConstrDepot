unit ConstrTypes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, DataSource,
  Vcl.StdCtrls, Vcl.Menus, System.Math, System.IniFiles, System.StrUtils;

type
  TConstrTypesForm = class(TForm)
    ListView: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    FilterEdit: TComboBox;
    ClearFilterButton: TButton;
    ConstrTypesCheck: TCheckBox;
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
  private
    { Private declarations }
    SortColumn: Integer;
    ClickedColumn: Integer;
    SortAscending: Boolean;
  public
    { Public declarations }
    procedure ApplySettings;
    procedure UpdateItems(const _autoSizeCol: Boolean = false);
  end;

var
  ConstrTypesForm: TConstrTypesForm;

implementation

uses Main,Clipbrd,Settings,Splash, Markets, SystemPict, SystemInfo;

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

  if Visible then UpdateItems(true);
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
  SortAscending := False;
  self.Width := Min(self.Width,Screen.Width);
  ApplySettings;
end;


procedure TConstrTypesForm.FormShow(Sender: TObject);
begin
  UpdateItems(true);
end;

procedure TConstrTypesForm.UpdateItems(const _autoSizeCol: Boolean = false);
var
  i,j,curCol: Integer;
  s: string;
  item: TListItem;
  ct: TConstructionType;
  fs,orgfs,cs,sups: string;
  items: THashedStringList;
  colMaxLen: array [0..100] of Integer;
  colMaxTxt: array [0..100] of string;
  autoSizeCol: Boolean;

  procedure addCaption(s: string);
  var ln: Integer;
  begin
    curCol := 0;
    item.Caption := s;
    ln := Length(s);
    if ln > colMaxLen[curCol] then
    begin
      colMaxLen[curCol] := ln;
      colMaxTxt[curCol] := s;
    end;
  end;

 procedure addSubItem(s: string);
  var ln: Integer;
  begin
    curCol := curCol + 1;
    item.SubItems.Add(s);
    ln := Length(s);
    if ln > colMaxLen[curCol] then
    begin
      colMaxLen[curCol] := ln;
      colMaxTxt[curCol] := s;
    end;
  end;

  function CheckFilter: Boolean;
  var i: Integer;
  begin
    Result := True;
    sups := '';
    if fs <> '' then
    begin
      Result := False;
      if Pos(fs,LowerCase(item.Caption)) > 0 then
        Result := true
      else
        for i := 0 to item.SubItems.Count - 1 do
          if Pos(fs,LowerCase(item.SubItems[i])) > 0 then
          begin
            Result := true;
            break;
          end;
    end;
  end;

  function tostr(i: Integer): string;
  begin
    Result := '';
    if i <> 0 then Result := i.ToString;
  end;

begin
  autoSizeCol := _autoSizeCol;
  if ListView.Items.Count = 0 then autoSizeCol := True;
  autoSizeCol := autoSizeCol and Opts.Flags['AutoSizeColumns'];

  items := THashedStringList.Create;
  items.Sorted := True;
  items.Duplicates := dupIgnore;

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

    for i := 0 to DataSrc.ConstructionTypes.Count - 1 do
    begin
      ct := TConstructionType(DataSrc.ConstructionTypes.TypeByIdx[i]);


      item := ListView.Items.Add;
      item.Data := ct;
      addCaption('T' + ct.Tier);
      addSubItem(ct.Location);
      addSubItem(ct.Category);
      addSubItem(ct.StationType);
      addSubItem(ct.Size);
      addSubItem(ct.Layouts);
      addSubItem(ct.Economy);
      addSubItem(ct.Influence);
      addSubItem(ct.Requirements);
      addSubItem(tostr(ct.CP2));
      addSubItem(tostr(ct.CP3));
      addSubItem(tostr(ct.SecLev));
      addSubItem(tostr(ct.TechLev));
      addSubItem(tostr(ct.DevLev));
      addSubItem(tostr(ct.WealthLev));
      addSubItem(tostr(ct.StdLivLev));
      addSubItem(tostr(ct.EstCargo));

      if not CheckFilter then item.Delete;
    end;

    if autoSizeCol then
    begin
      for i := 0 to ListView.Columns.Count - 1 do
        ListView.Column[i].Width := ListView.Canvas.TextWidth(colMaxTxt[i]) + 15; //margins
    end;

    ListView.SortType := stText;
  finally
    ListView.Items.EndUpdate;
    items.Free;
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
        Item1.SubItems[SortColumn-1] + '    ' + Item1.Caption,
        Item2.SubItems[SortColumn-1] + '    ' + Item2.Caption);
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
  for i := 0 to ListView.Columns.Count -1  do
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
