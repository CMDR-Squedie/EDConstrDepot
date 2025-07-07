unit Colonies;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, DataSource,
  Vcl.StdCtrls, Vcl.Menus, System.Math, System.IniFiles, System.StrUtils;

type
  TColoniesForm = class(TForm, IEDDataListener)
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
    EditCommentMenuItem: TMenuItem;
    ToggleIgnoredMenuItem: TMenuItem;
    N5: TMenuItem;
    TaskGroupSubMenu: TMenuItem;
    askGroup2: TMenuItem;
    OtherGroupMenuItem: TMenuItem;
    N3: TMenuItem;
    Clear1: TMenuItem;
    N1: TMenuItem;
    CopyMenuItem: TMenuItem;
    CopyAllMenuItem: TMenuItem;
    CopySystemNameMenuItem: TMenuItem;
    EditAlterNameMenuItem: TMenuItem;
    EditArchitectMenuItem: TMenuItem;
    AddToTargetsMenuItem: TMenuItem;
    DistancesFromMenuItem: TMenuItem;
    DistFromLabel: TLabel;
    SystemPictureMenuItem: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    CurrentGoalsMenuItem: TMenuItem;
    LongtermObjectivesMenuItem: TMenuItem;
    N6: TMenuItem;
    AddSystemToScanMenuItem: TMenuItem;
    RemoveSystemToScanMenuItem: TMenuItem;
    EditTimer: TTimer;
    AddNeighboursMenuItem: TMenuItem;
    SystemInfoMenuItem: TMenuItem;
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
//    procedure TaskGroupMenuItemClick(Sender: TObject);
//    procedure OtherGroupMenuItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ColoniesCheckClick(Sender: TObject);
    procedure SelectModeCheckClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure AddToTargetsMenuItemClick(Sender: TObject);
    procedure ToggleIgnoredMenuItemClick(Sender: TObject);
    procedure AddSystemToScanMenuItemClick(Sender: TObject);
    procedure RemoveSystemToScanMenuItemClick(Sender: TObject);
    procedure EditTimerTimer(Sender: TObject);
    procedure AddNeighboursMenuItemClick(Sender: TObject);
    procedure ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }
    SortColumn: Integer;
    ClickedColumn: Integer;
    SortAscending: Boolean;
    FSelectedItems: TStringList;
    FReferenceSystem: TStarSystem;
    function IsSelected(item: TListItem): Boolean;
    procedure SaveSelection;
    procedure RestoreSelection;
  public
    { Public declarations }
    procedure OnEDDataUpdate;
    procedure ApplySettings;
    procedure UpdateItems(const _autoSizeCol: Boolean = false);
    procedure UpdateAndShow;
  end;

var
  ColoniesForm: TColoniesForm;

implementation

uses Main,Clipbrd,Settings,Splash, Markets, SystemPict, SystemInfo;

{$R *.dfm}


procedure TColoniesForm.OnEDDataUpdate;
begin
  if Visible then
  begin
    SaveSelection;
    UpdateItems;
    RestoreSelection;
  end;
end;


procedure TColoniesForm.UpdateAndShow;
begin
  if Visible then
    UpdateItems
  else
    Show;
  if WindowState = wsMinimized then WindowState := wsNormal;
  BringToFront;
end;

{
procedure TColoniesForm.OtherGroupMenuItemClick(Sender: TObject);
var i: Integer;
    s: string;
begin
  DataSrc.BeginUpdate;
  try
    s := Vcl.Dialogs.InputBox('Task Group', 'Name', '');;
    for i := 0 to ListView.Items.Count -1 do
      if IsSelected(ListView.Items[i]) then
        DataSrc.UpdateMarketGroup(TBaseMarket(ListView.Items[i].Data).MarketID,s,false);
  finally
    DataSrc.EndUpdate;
  end;
end;


procedure TColoniesForm.TaskGroupMenuItemClick(Sender: TObject);
var i: Integer;
    s: string;
begin
  DataSrc.BeginUpdate;
  try
    s := TMenuItem(Sender).Hint;
    for i := 0 to ListView.Items.Count -1 do
      if IsSelected(ListView.Items[i]) then
        DataSrc.UpdateMarketGroup(TBaseMarket(ListView.Items[i].Data).MarketID,s,false);
  finally
    DataSrc.EndUpdate;
  end;
end;
}

procedure TColoniesForm.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  gLastCursorPos := Mouse.CursorPos;
end;

procedure TColoniesForm.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
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

procedure TColoniesForm.PopupMenuPopup(Sender: TObject);
var colf,canf,tf,othf,visitedf: Boolean;
    sys: TStarSystem;
    sl: TStringList;
    i: Integer;
    mitem: TMenuItem;
begin
  colf := False;
  canf := False;
  tf := False;
  othf := False;
  visitedf := True;
  sys := nil;
  if ListView.Selected <> nil then
  begin
    sys :=  TStarSystem(ListView.Selected.Data);
    if (sys.Architect <> '') and ((sys.Population > 0) or sys.PrimaryDone) then colf := True;
    if (sys.Architect <> '') and (sys.Population = 0) and not sys.PrimaryDone then tf := True;
    if (sys.Architect = '') and (sys.Population = 0) and (sys.Factions = '') then canf := True;
    if (sys.Architect = '') and ((sys.Population > 0) or (sys.Factions <> '')) then othf := True;
    visitedf := sys.LastUpdate <> '';
  end;
  EditArchitectMenuItem.Enabled := sys <> nil;
  EditCommentMenuItem.Enabled := sys <> nil;
  EditAlterNameMenuItem.Enabled := sys <> nil;
  CurrentGoalsMenuItem.Enabled := sys <> nil;
  LongTermObjectivesMenuItem.Enabled := sys <> nil;
  AddToTargetsMenuItem.Enabled := canf;
  RemoveSystemToScanMenuItem.Enabled := (sys <> nil) and not visitedf;
{
  TaskGroupSubMenu.Enabled := colf or tf;
  AddToDepotGroupMenuItem.Enabled := colf or tf;
  GroupDepotGroupMenuItem.Enabled := colf or tf;
  ToggleIgnoredMenuItem.Enabled := colf;
}
  CopyMenuItem.Enabled := sys <> nil;
  CopySystemNameMenuItem.Enabled := sys <> nil;

  for i := TaskGroupSubMenu.Count - 1 downto 0 do
  begin
    if TaskGroupSubMenu.Items[i].Tag > 0 then
      TaskGroupSubMenu.Delete(i);
  end;
{
  sl := TStringList.Create;
  DataSrc.GetUniqueGroups(sl);
  for i := sl.Count - 1 downto 0  do
  begin
    mitem := TMenuItem.Create(TaskGroupSubMenu);
    mitem.Caption := sl[i];
    mitem.Hint := sl[i];
    mitem.Tag := 1;
    mitem.OnClick := TaskGroupMenuItemClick;
    TaskGroupSubMenu.Insert(0,mitem);
  end;
  sl.Free;
}
end;

procedure TColoniesForm.ClearFilterButtonClick(Sender: TObject);
begin
   FilterEdit.Text := '';
   UpdateItems;
end;


procedure TColoniesForm.SelectModeCheckClick(Sender: TObject);
begin
  ListView.Checkboxes := SelectModeCheck.Checked;
end;


procedure TColoniesForm.ToggleIgnoredMenuItemClick(Sender: TObject);
var i: Integer;
begin
  if Vcl.Dialogs.MessageDlg('Toggle all selected systems Ignored status?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;
  for i := 0 to ListView.Items.Count -1 do
  begin
    if not IsSelected(ListView.Items[i]) then continue;
    with TStarSystem(ListView.Items[i].Data) do
    begin
      Ignored := not Ignored;
      Save;
    end;
  end;
  UpdateItems;
end;

function TColoniesForm.IsSelected(item: TListItem): Boolean;
begin
  if SelectModeCheck.Checked then
    Result := item.Checked
  else
    Result := item.Selected;
end;

procedure TColoniesForm.ColoniesCheckClick(Sender: TObject);
begin
  UpdateItems(true);
end;

procedure TColoniesForm.CopyMenuItemClick(Sender: TObject);
var s: string;
    i,j: Integer;
    selonlyf: Boolean;
begin
{
  s := '';
  if ListView.Selected = nil then Exit;
  s := ListView.Columns[0].Caption + ': ' + ListView.Selected.Caption + Chr(13);
  for i := 0 to ListView.Selected.SubItems.Count - 1 do
    if i < ListView.Columns.Count - 1 then
      s := s + ListView.Columns[i+1].Caption + ': ' +  ListView.Selected.SubItems[i] + Chr(13);
  Clipboard.SetTextBuf(PChar(s));
}

  selonlyf := (Sender = CopyMenuItem);
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

procedure TColoniesForm.EditTimerTimer(Sender: TObject);
begin
  try
    UpdateItems;
  finally
    EditTimer.Enabled := False;
  end;
end;

procedure TColoniesForm.FilterEditChange(Sender: TObject);
begin
  EditTimer.Enabled := False;
  EditTimer.Enabled := True;
end;

procedure TColoniesForm.AddNeighboursMenuItemClick(Sender: TObject);
var cnt: Integer;
begin
  cnt := DataSrc.StarSystems.AddNeighbours_EDSM(TStarSystem(ListView.Selected.Data).StarSystem);
  ShowMessage('EDSM query successful, ' + IntToStr(cnt) + ' new systems added.');
  if cnt > 0 then UpdateItems;
end;

procedure TColoniesForm.AddSystemToScanMenuItemClick(Sender: TObject);
var s: string;
begin
  s := Vcl.Dialogs.InputBox('Add System To Scan', 'System Name', '');
  if s = '' then Exit;
  if not DataSrc.StarSystems.AddFromName(s) then
  begin
    ShowMessage('System already listed, check filters if not visible.');
    Exit;
  end;
  UpdateItems;
end;

procedure TColoniesForm.AddToTargetsMenuItemClick(Sender: TObject);
var i: Integer;
begin
  DataSrc.BeginUpdate;
  try
    for i := 0 to ListView.Items.Count -1 do
      if IsSelected(ListView.Items[i]) then
        with TStarSystem(ListView.Items[i].Data) do
          if Architect = '' then
          begin
            Architect := '(target)';
            Save;
          end;
  finally
    DataSrc.EndUpdate;
  end;
end;

procedure TColoniesForm.ApplySettings;
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

procedure TColoniesForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Opts['Colonies.Left'] := IntToStr(self.Left);
  Opts['Colonies.Top'] := IntToStr(self.Top);
  Opts['Colonies.Height'] := IntToStr(self.Height);
  Opts['Colonies.Width'] := IntToStr(self.Width);
  Opts.Save;

end;

procedure TColoniesForm.FormCreate(Sender: TObject);
var i: Integer;
begin
  SortColumn := 4; //last visit
  SortAscending := False;
  FSelectedItems := TStringList.Create;

  DataSrc.AddListener(self);
  ApplySettings;

  self.Width := StrToIntDef(Opts['Colonies.Width'],self.Width);
  self.Height := StrToIntDef(Opts['Colonies.Height'],self.Height);
  self.Left := StrToIntDef(Opts['Colonies.Left'],(Screen.Width - self.Width) div 2);
  self.Top := StrToIntDef(Opts['Colonies.Top'],0);

  if Opts['Markets.AlphaBlend'] <> '' then
  begin
    AlphaBlendValue := StrToIntDef(Opts['Markets.AlphaBlend'],255);
    AlphaBlend := True;
  end;
end;

procedure TColoniesForm.FormShow(Sender: TObject);
var i: Integer;
begin
  if FilterEdit.Items.Count = 0 then
    for i := 0 to DataSrc.Commanders.Count - 1 do
      FilterEdit.Items.Add(DataSrc.Commanders.ValueFromIndex[i]);

  UpdateItems(true);
  FilterEdit.SetFocus;
end;

procedure TColoniesForm.SaveSelection;
var i: Integer;
begin
  FSelectedItems.Clear;
  for i := 0 to ListView.Items.Count - 1 do
    if IsSelected(ListView.Items[i]) then
      FSelectedItems.Add(TStarSystem(ListView.Items[i].Data).StarSystem);
end;

procedure TColoniesForm.RemoveSystemToScanMenuItemClick(Sender: TObject);
var i: Integer;
begin
  for i := 0 to ListView.Items.Count - 1 do
    if IsSelected(ListView.Items[i]) then
      DataSrc.StarSystems.RemoveFromName(TStarSystem(ListView.Items[i].Data).StarSystem);
  UpdateItems;
end;

procedure TColoniesForm.RestoreSelection;
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

procedure TColoniesForm.UpdateItems(const _autoSizeCol: Boolean = false);
var
  i,j,curCol: Integer;
  sys: TStarSystem;
  s: string;
  row: TStringList;
  fs,orgfs,cs,sups: string;
  items: THashedStringList;
  coloniesf,targetf,candidf,otherf,okf,ignf: Boolean;
  d: Extended;
  colMaxLen: array [0..100] of Integer;
  colMaxTxt: array [0..100] of string;
  autoSizeCol: Boolean;

  procedure addRow(data: TObject);
  var i,ln: Integer;
      item: TListItem;
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
    row.Clear;
    row.Add(s);
  end;

  procedure addSubItem(s: string);
  begin
    row.Add(s);
  end;

  function CheckFilter: Boolean;
  var i: Integer;
  begin
    Result := True;
    sups := '';
    if fs <> '' then
    begin
      Result := False;
      for i := 0 to row.Count - 1 do
        if Pos(fs,LowerCase(row[i])) > 0 then
        begin
          Result := true;
          break;
        end;
    end;
  end;

  function niceTime(tms: string): string;
  begin
    Result := Copy(tms,1,10) + ' ' + Copy(tms,12,8);
  end;

begin
  autoSizeCol := _autoSizeCol;
  if ListView.Items.Count = 0 then autoSizeCol := True;
  //autoSizeCol := autoSizeCol and Opts.Flags['AutoSizeColumns'];

  row := TStringList.Create;

  coloniesf := ColoniesCheck.Checked;
  targetf := ColonTargetsCheck.Checked;
  candidf := ColonCandidatesCheck.Checked;
  otherf := OtherSystemsCheck.Checked;
  ignf := InclIgnoredCheck.Checked;

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

//stress test
//for j := 1 to 100 do
  
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

      addCaption(sys.StarSystem);
      addSubItem(sys.ArchitectName);
      s := '';
      if sys.Population >= 0 then
        s := Format('%.0n', [double(sys.Population)]);
      addSubItem(s);
      s := '';
      if FReferenceSystem <> nil then
        if (sys.LastUpdate = '') and (sys.StarPosX = 0) then
          s := '?'
        else
        begin
          d := sys.DistanceTo(FReferenceSystem);
          if d > 0 then
            s := FloatToStrF(d,ffFixed,7,2);
        end;
      addSubItem(s);
      addSubItem(niceTime(sys.LastUpdate));
      addSubItem(sys.AlterName);
      addSubItem(sys.SystemSecurity);
      addSubItem(sys.Factions);
      addSubItem(sys.Comment);
      s := '';
      if FileExists(sys.ImagePath) then
        s := '✓';
      addSubItem(s);
      addSubItem(sys.CurrentGoals);
      addSubItem(sys.Objectives);
      s := '';
      if sys.Ignored then s := '●';
      addSubItem(s);


      if CheckFilter then addRow(sys);
    end;

    if autoSizeCol then
    begin
      //for i := 0 to ListView.Columns.Count - 2 do
      //   ListView.Column[i].Width := -2;  //this is EXTREMELY slow!
      //ListView.Column[ListView.Columns.Count - 1].Width := -1;  //this stays at -1

      for i := 0 to ListView.Columns.Count - 1 do
        ListView.Column[i].Width := ListView.Canvas.TextWidth(colMaxTxt[i]) + 15; //margins
    end;


//    if FReferenceSystem = nil then
//      ListView.Column[3].Width := 0;

    ListView.SortType := stText;
  finally
    ListView.Items.EndUpdate;
    row.Free;
  end;
end;

procedure TColoniesForm.ListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
   TListView(Sender).SortType := stNone;
  if SortColumn = Column.Index then
    SortAscending := not SortAscending
  else
    SortColumn := Column.Index;
  TListView(Sender).SortType := stText;
end;

procedure TColoniesForm.ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
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
    if SortColumn = 2 then
      Compare := CompareValue(TStarSystem(Item1.Data).Population,TStarSystem(Item2.Data).Population)
    else
    if SortColumn = 3 then
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

procedure TColoniesForm.ListViewCustomDrawItem(Sender: TCustomListView;
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

procedure TColoniesForm.ListViewAction(Sender: TObject);
var sid: string;
    s,orgs: string;
    action: Integer;
    sys: TStarSystem;
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
  sys := TStarSystem(ListView.Selected.Data);
  sid := sys.StarSystem;
  case action of
  1:
    begin
      if MarketsForm.Visible then MarketsForm.SetColony(sid);
      SystemInfoForm.SetSystem(sys);
      SystemInfoForm.RestoreAndShow;
    end;
  2:
    begin
      orgs := sys.ArchitectName;
      s := Vcl.Dialogs.InputBox(sys.StarSystem, 'Architect', orgs);
      if s <> orgs then
      begin
        sys.ArchitectName := s;
        sys.Save;
        UpdateItems;
      end;
    end;
  5:
    begin
      s := sys.Factions_full;
      if s <> '' then
        ShowMessage(s);
    end;
  6:
    begin
      sys.Ignored := not sys.Ignored;
      sys.Save;
      UpdateItems;
    end;
  7:
    begin
      orgs := sys.AlterName;
      s := Vcl.Dialogs.InputBox(sys.StarSystem, 'Alternative Name', orgs);
      if s <> orgs then
      begin
        sys.AlterName := s;
        sys.Save;
        UpdateItems;
      end;
    end;
  8:
    begin
      orgs := sys.Comment;
      s := Vcl.Dialogs.InputBox(sys.StarSystem, 'Comment', orgs);
      if s <> orgs then
      begin
        sys.Comment := s;
        sys.Save;
        UpdateItems;
      end;
    end;
  9:
    begin
      orgs := sys.CurrentGoals;
      s := Vcl.Dialogs.InputBox(sys.StarSystem, 'Current Goals', orgs);
      if s <> orgs then
      begin
        sys.CurrentGoals := s;
        sys.Save;
        UpdateItems;
      end;
    end;
  10:
    begin
      orgs := sys.Objectives;
      s := Vcl.Dialogs.InputBox(sys.StarSystem, 'Long-term Objectives', orgs);
      if s <> orgs then
      begin
        sys.Objectives := s;
        sys.Save;
        UpdateItems;
      end;
    end;
  15:
      Clipboard.SetTextBuf(PChar(sys.StarSystem));
  16:
    begin
      if (sys.LastUpdate = '') and (sys.StarPosX = 0) then Exit; //no xyz
      FReferenceSystem := sys;
      DistFromLabel.Caption := 'Dist. from: ' + sys.StarSystem;
      SortColumn := 3;
      SortAscending := True;
      UpdateItems;
    end;
  17:
    begin
      SystemPictForm.SetSystem(sid);
      SystemPictForm.Show;
    end;

  end;
end;

procedure TColoniesForm.ListViewMouseDown(Sender: TObject; Button: TMouseButton;
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
