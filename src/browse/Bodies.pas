unit Bodies;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, DataSource,
  Vcl.StdCtrls, Vcl.Menus, System.Types, System.Math, System.IniFiles, System.StrUtils;

type
  TBodiesForm = class(TForm, IEDDataListener)
    ListView: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    InclIgnoredCheck: TCheckBox;
    FilterEdit: TComboBox;
    ClearFilterButton: TButton;
    SelectModeCheck: TCheckBox;
    ColoniesCheck: TCheckBox;
    ColonTargetsCheck: TCheckBox;
    OtherSystemsCheck: TCheckBox;
    ColonCandidatesCheck: TCheckBox;
    PopupMenu: TPopupMenu;
    CopyAllMenuItem: TMenuItem;
    CopySystemNameMenuItem: TMenuItem;
    N2: TMenuItem;
    EditTimer: TTimer;
    SystemInfoMenuItem: TMenuItem;
    ShowOnMapMenuItem: TMenuItem;
    Label2: TLabel;
    N1: TMenuItem;
    N3: TMenuItem;
    SetReferenceSystemMenuItem: TMenuItem;
    RefSystemLabel: TLabel;
    ShowSpecialsMenuItem: TMenuItem;
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormShow(Sender: TObject);
    procedure FilterEditChange(Sender: TObject);
    procedure ListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListViewAction(Sender: TObject);
    procedure CopyMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearFilterButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ColoniesCheckClick(Sender: TObject);
    procedure SelectModeCheckClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure EditTimerTimer(Sender: TObject);
    procedure ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ShowOnMapMenuItemClick(Sender: TObject);
    procedure ShowSpecialsMenuItemClick(Sender: TObject);
  private
    { Private declarations }
    FColonies: TSystemList;
    FHoldUpdate: Boolean;
    FHighlightColor: TColor;
    SortColumn: Integer;
    ClickedColumn: Integer;
    SortAscending: Boolean;
    FSelectedItems: TStringList;
    FReferenceSystem: TStarSystem;
    function IsSelected(item: TListItem): Boolean;
    procedure SaveSelection;
    procedure RestoreSelection;
    procedure SetReferenceSystem(sys: TStarSystem);
  public
    { Public declarations }
    procedure BeginFilterChange;
    procedure EndFilterChange;
    procedure OnEDDataUpdate;
    procedure ApplySettings;
    procedure UpdateItems(const _autoSizeCol: Boolean = true);
    procedure UpdateAndShow;
  end;

var
  BodiesForm: TBodiesForm;

implementation

uses Main,Clipbrd,Settings,Splash, Markets, SystemPict, SystemInfo, StarMap,
  Summary;

{$R *.dfm}

procedure TBodiesForm.BeginFilterChange;
begin
  FHoldUpdate := True;

  //this is only needed because changing checkboxes immediately trigger their Clicked event
  //not the case with edits
end;

procedure TBodiesForm.EndFilterChange;
begin
  FHoldUpdate := False;
end;


procedure TBodiesForm.OnEDDataUpdate;
begin
{
  if Visible then
  if ListView.Items.Count < 1000 then
  begin
    SaveSelection;
    UpdateItems;
    RestoreSelection;
  end;
}
end;


procedure TBodiesForm.UpdateAndShow;
begin
  if Visible then
    UpdateItems
  else
    Show;
  if WindowState = wsMinimized then WindowState := wsNormal;
  BringToFront;
end;



procedure TBodiesForm.PopupMenuPopup(Sender: TObject);
var b: TSystemBody;
    sys: TStarSystem;
begin
  b := nil;
  sys := nil;
  if ListView.Selected <> nil then
  begin
    b := TSystemBody(ListView.Selected.Data);
    sys := b.SysData;
  end;
  ShowOnMapMenuItem.Enabled := sys <> nil;
  SetReferenceSystemMenuItem.Enabled := sys <> nil;
//  CopyMenuItem.Enabled := sys <> nil;
  CopySystemNameMenuItem.Enabled := sys <> nil;
  ShowSpecialsMenuItem.Visible := Opts.Flags['DevMode'];
end;

procedure TBodiesForm.ClearFilterButtonClick(Sender: TObject);
begin
   FilterEdit.Text := '';
   UpdateItems;
end;


procedure TBodiesForm.SelectModeCheckClick(Sender: TObject);
begin
  ListView.Checkboxes := SelectModeCheck.Checked;
end;

function TBodiesForm.IsSelected(item: TListItem): Boolean;
begin
  if SelectModeCheck.Checked then
    Result := item.Checked
  else
    Result := item.Selected;
end;

procedure TBodiesForm.ColoniesCheckClick(Sender: TObject);
begin
  UpdateItems;
end;

procedure TBodiesForm.CopyMenuItemClick(Sender: TObject);
var s: string;
    i,j: Integer;
    selonlyf: Boolean;
begin
  selonlyf := false; //(Sender = CopyMenuItem);
  s := '';
  for i := 0 to ListView.Columns.Count -1 do
  begin
    if ListView.Columns[i].Caption <> '' then
      s := s + ListView.Columns[i].Caption + Chr(9);
  end;
  s := s + Chr(13);

  for i := 0 to ListView.Items.Count -1 do
  begin
    if selonlyf then
      if not IsSelected(ListView.Items[i]) then continue;
    s := s + ListView.Items[i].Caption + Chr(9);
    for j := 0 to ListView.Items[i].SubItems.Count - 1 do
      if j < ListView.Columns.Count - 1 then
        if ListView.Columns[j+1].Caption <> '' then
          s := s + ListView.Items[i].SubItems[j] + Chr(9);
    s := s + Chr(13);
  end;
  Clipboard.SetTextBuf(PChar(s));
end;

procedure TBodiesForm.EditTimerTimer(Sender: TObject);
begin
  try
    UpdateItems;
  finally
    EditTimer.Enabled := False;
  end;
end;

procedure TBodiesForm.FilterEditChange(Sender: TObject);
begin
  EditTimer.Enabled := False;
  EditTimer.Enabled := True;
end;


procedure TBodiesForm.ApplySettings;
var i,fs: Integer;
    fn: string;
    clr: TColor;
    crec: System.UITypes.TColorRec;
begin
  ShowInTaskBar := Opts.Flags['ShowInTaskbar'];
  FHighlightColor := clBlack;

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

    crec.Color := clr;
    crec.R := Min(255,48 + crec.R);
    crec.G := Min(255,48 + crec.G);
    crec.B := Min(255,48 + crec.B);
    FHighlightColor := crec.Color;
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

procedure TBodiesForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 ;
end;

procedure TBodiesForm.FormCreate(Sender: TObject);
var i: Integer;
begin
  SortColumn := 0;
  SortAscending := False;
  FSelectedItems := TStringList.Create;
  FColonies := TSystemList.Create;
  DataSrc.AddListener(self);
  ApplySettings;

  if Opts['Markets.AlphaBlend'] <> '' then
  begin
    AlphaBlendValue := StrToIntDef(Opts['Markets.AlphaBlend'],255);
    AlphaBlend := True;
  end;
end;

procedure TBodiesForm.FormShow(Sender: TObject);
var i: Integer;
begin
  UpdateItems;
  FilterEdit.SetFocus;
end;

procedure TBodiesForm.SaveSelection;
var i: Integer;
begin
  FSelectedItems.Clear;
  for i := 0 to ListView.Items.Count - 1 do
    if IsSelected(ListView.Items[i]) then
      FSelectedItems.Add(TStarSystem(ListView.Items[i].Data).StarSystem);
end;

procedure TBodiesForm.RestoreSelection;
var i: Integer;
begin
  for i := 0 to ListView.Items.Count - 1 do
  begin
    if ListView.Items[i].Data <> nil then
    if FSelectedItems.IndexOf(TStarSystem(ListView.Items[i].Data).StarSystem) > -1 then
      if SelectModeCheck.Checked then
        ListView.Items[i].Checked := True
      else
        ListView.Items[i].Selected := True;
  end;
end;

procedure TBodiesForm.UpdateItems(const _autoSizeCol: Boolean = true);
var
  i,i2,j,curCol: Integer;
  b: TSystemBody;
  sys: TStarSystem;
  s: string;
  row: TStringList;
  hsysl: TList;
  fs,orgfs,cs,sups,dist: string;
  items: THashedStringList;
  coloniesf,targetf,candidf,otherf,okf,ignf,specialsf: Boolean;
  d: Extended;
  colMaxLen: array [0..100] of Integer;
  colMaxTxt: array [0..100] of string;
  autoSizeCol: Boolean;
  fsarr: TStringDynArray;

  procedure addRow(data: TObject);
  var i,ln,idx: Integer;
      item: TListItem;
      s: string;
  begin
    for i := 0 to row.Count - 1 do
    begin
      idx := Pos('|',row[i]);
      if idx > 0 then
        row[i] := Copy(row[i],1,idx-1);
      ln := Min(Length(row[i]),35);
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
    row.Clear;
    row.Add(s);
  end;

  procedure addSubItem(s: string; const addColCapf: Boolean = false);
  var curCol: Integer;
  begin
    if addColCapf and (s <> '') then
    begin
      curCol := row.Count;
      row.Add(s + '|' + ListView.Columns[curCol].Caption);
    end
    else
      row.Add(s);

  end;

  function CheckFilter: Boolean;
  var i,i2,mcnt: Integer;
      s: string;
      negf: Boolean;
  begin
    Result := True;
    if fs <> '' then
    begin
      for i2 := 0 to High(fsarr) do
        if fsarr[i2] <> '' then
        begin
          s := fsarr[i2];
          negf := false;
          if Copy(s,1,1) = '~' then
          begin
            negf := True;
            s := Copy(s,2,100);
          end;
          Result := negf;
          for i := 0 to row.Count - 1 do
          if Pos(s,LowerCase(row[i])) > 0 then
          begin
            Result := not negf;
            break;
          end;
          if not Result then break;
        end;
    end;
  end;

  function niceTime(tms: string): string;
  begin
    Result := Copy(tms,1,10) + ' ' + Copy(tms,12,8);
  end;

begin
  if FHoldUpdate then Exit;

  autoSizeCol := _autoSizeCol;
  if ListView.Items.Count = 0 then autoSizeCol := True;
  //autoSizeCol := autoSizeCol and Opts.Flags['AutoSizeColumns'];

  row := TStringList.Create;
  hsysl := TList.Create;

  coloniesf := ColoniesCheck.Checked;
  targetf := ColonTargetsCheck.Checked;
  candidf := ColonCandidatesCheck.Checked;
  otherf := OtherSystemsCheck.Checked;
  ignf := InclIgnoredCheck.Checked;
  specialsf := ShowSpecialsMenuItem.Checked;

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

//stress test
//for j := 1 to 100 do
{
    FColonies.Clear;
    for i := 0 to DataSrc.StarSystems.Count - 1 do
    begin
      sys := DataSrc.StarSystems[i];
      if sys.IsOwnColony then FColonies.AddObject(sys.StarSystem,sys);
    end;
}

    for i := 0 to DataSrc.StarSystems.Count - 1 do
    begin
      sys := DataSrc.StarSystems[i];

      if not ignf and sys.Ignored then continue;

      okf := false;
      if coloniesf then
        if (sys.Architect <> '') and ((sys.Population > 0) or sys.PrimaryDone) then okf := True;
      if targetf then
        if (sys.Architect <> '') and (sys.Population = 0) and not sys.PrimaryDone then okf := True;
      if candidf then
        if (sys.Architect = '') and (sys.Population = 0) and (sys.Factions = '') then okf := True;
      if otherf then
        if (sys.Architect = '') and ((sys.Population > 0) or (sys.Factions <> '')) then okf := True;
      if not okf then continue;

      sys.UpdateMoons;

      dist := '';
      if FReferenceSystem <> nil then
        if (sys.LastUpdate = '') and (sys.StarPosX = 0) then
          dist := '?'
        else
        begin
          d := sys.DistanceTo(FReferenceSystem);
          if d > 0 then
            dist := FloatToStrF(d,ffFixed,7,2);
        end;

      for i2 := 0 to sys.Bodies.Count -1 do
      if sys.Bodies[i2] <> '?' then
      begin
        b := TSystemBody(sys.Bodies.Objects[i2]);

        addCaption(sys.StarSystem);
        addSubItem(dist);
        s := b.BodyName;
        if b.PrimaryLoc then s := s + ' ⚑ (prim.)';
        addSubItem(s);
        addSubItem(b.BodyType);
        s := '';
        s := s + b.ReserveLevel + '  ' + b.Comment;
        addSubItem(s);
        {
        s := '';
        if FShowEconomies then
          s := b.Economies_nice;
        addSubItem(s);
        }
        addSubItem(FloatToStrF(b.DistanceFromArrivalLS,ffFixed,7,1));
        addSubItem(IfThen(b.Landable,'Yes',''),true);
        addSubItem(b.Atmosphere,true);
        addSubItem(IfThen(b.HasRings,'Yes',''),true);
        s := '';
        if b.BiologicalSignals > 0 then s := s + 'Bio: ' + IntToStr(b.BiologicalSignals) + '; ';
        if b.GeologicalSignals > 0 then s := s + 'Geo: ' + IntToStr(b.GeologicalSignals) + '; ';
        if b.HumanSignals > 0 then s := s + 'Hum: ' + IntToStr(b.HumanSignals) + '; ';
        if b.OtherSignals > 0 then s := s + 'Oth: ' + IntToStr(b.OtherSignals) + '; ';
        addSubItem(s,true);
        addSubItem(b.Volcanism,true);
        addSubItem(FloatToStrF(b.SurfaceGravity,ffFixed,7,2));
        addSubItem(IfThen(b.TidalLock,'Yes',''),true);
        addSubItem(IfThen(b.Terraformable,'Yes',''),true);
        s := '';
        if (b.OrbitalInclination > 0.1) or (b.OrbitalInclination < -0.1) then
          s := FloatToStrF(b.OrbitalInclination,ffFixed,7,1);
        addSubItem(s,true);
        {
        addSubItem(FloatToStrF(b.RotationPeriod,ffFixed,7,1));
        addSubItem(FloatToStrF(b.OrbitalPeriod,ffFixed,7,1));
        addSubItem(FloatToStrF(b.SemiMajorAxis,ffFixed,12,1));
        }
        addSubItem(FloatToStrF(b.Radius,ffFixed,7,2));
        addSubItem(FloatToStrF(b.SemiMajorAxis,ffFixed,7,2));
        addSubItem(IfThen(b.HasMoons,'Yes',''),true);


        s := '';
        if specialsf then
        begin
          if b.IsMoon then s := s + 'IsMoon;';
          if b.ParentBody  <> nil then
          begin
            if Pos('earth',LowerCase(b.ParentBody.BodyType)) > 0 then s := s + 'EarthParent;';
            if Pos('giant',LowerCase(b.ParentBody.BodyType)) > 0 then s := s + 'GiantParent;';
            if b.ParentBody.HasRings then s := s + 'ParentHasRings;';
          end;
        end;
        if (b.Radius > 0) and (b.Radius < 250) then s := s + 'Tiny;';
        addSubItem(s);


        if CheckFilter then
          addRow(b);
      end;

    end;

    if autoSizeCol then
    begin
      for i := 0 to ListView.Columns.Count - 1 do
        ListView.Column[i].Width := ListView.Canvas.TextWidth(colMaxTxt[i]) +
          15 + ListView.Font.Size div 6; //margins
    end;

    ListView.SortType := stText;
  finally
    ListView.Items.EndUpdate;
    row.Free;
  end;
end;

procedure TBodiesForm.ListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
   TListView(Sender).SortType := stNone;
  if SortColumn = Column.Index then
    SortAscending := not SortAscending
  else
    SortColumn := Column.Index;
  TListView(Sender).SortType := stText;
end;

procedure TBodiesForm.ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
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
    if SortColumn = 5 then
      Compare := CompareValue(TSystemBody(Item1.Data).DistanceFromArrivalLS,
        TSystemBody(Item2.Data).DistanceFromArrivalLS)
    else
    if SortColumn = 11 then
      Compare := CompareValue(TSystemBody(Item1.Data).SurfaceGravity,
        TSystemBody(Item2.Data).SurfaceGravity)
    else
    if SortColumn = 14 then
      Compare := CompareValue(TSystemBody(Item1.Data).OrbitalInclination,
        TSystemBody(Item2.Data).OrbitalInclination)
    else
    if SortColumn = 15 then
      Compare := CompareValue(TSystemBody(Item1.Data).Radius,
        TSystemBody(Item2.Data).Radius)
    else
    if SortColumn = 16 then
      Compare := CompareValue(TSystemBody(Item1.Data).SemiMajorAxis,
        TSystemBody(Item2.Data).SemiMajorAxis)
    else
    if SortColumn = 1 then
      Compare := CompareText(
        Item1.SubItems[SortColumn-1].PadLeft(10),
        Item2.SubItems[SortColumn-1].PadLeft(10))
    else
      Compare := CompareText(
        Item1.SubItems[SortColumn-1] + '    ' + Item1.Caption,
        Item2.SubItems[SortColumn-1] + '    ' + Item2.Caption);
  end;

  if not SortAscending then Compare := -Compare;
end;

procedure TBodiesForm.ListViewCustomDrawItem(Sender: TCustomListView;
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

procedure TBodiesForm.SetReferenceSystem(sys: TStarSystem);
begin
  if (sys.LastUpdate = '') and (sys.StarPosX = 0) then Exit; //no xyz
  FReferenceSystem := sys;
  RefSystemLabel.Caption := 'Dist. from: ' + sys.StarSystem;
  SortColumn := 1;
  SortAscending := True;
  UpdateItems;
end;


procedure TBodiesForm.ShowOnMapMenuItemClick(Sender: TObject);
begin
  if ListView.Selected = nil then Exit;
  StarMapForm.SelectSystem(TSystemBody(ListView.Selected.Data).SysData);
  StarMapForm.RestoreAndShow;
end;

procedure TBodiesForm.ShowSpecialsMenuItemClick(Sender: TObject);
begin
  UpdateItems;
end;

procedure TBodiesForm.ListViewAction(Sender: TObject);
var sid: string;
    s,orgs: string;
    action: Integer;
    sys: TStarSystem;
    b: TSystemBody;
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
  b := TSystemBody(ListView.Selected.Data);
  sys := b.SysData;
  sid := sys.StarSystem;
  case action of
  8:
    begin
      s := Vcl.Dialogs.InputBox('Body', 'Comment', b.Comment);
      if s <> b.Comment then
      begin
        b.FeaturesModified := True;
        b.Comment := s;
        sys.Save;
        self.UpdateItems;
      end;
    end;
  15:
      Clipboard.SetTextBuf(PChar(sys.StarSystem));
  16:
    begin
      SetReferenceSystem(sys);
    end;
  17:
    begin
      SystemPictForm.SetSystem(sid);
      SystemPictForm.Show;
    end;
  else
    begin
      //if MarketsForm.Visible then MarketsForm.SetColony(sid);
      SystemInfoForm.SetSystem(sys,b);
      SystemInfoForm.RestoreAndShow;
    end;

  end;
end;

procedure TBodiesForm.ListViewMouseDown(Sender: TObject; Button: TMouseButton;
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
