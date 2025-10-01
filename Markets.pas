unit Markets;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, DataSource,
  Vcl.StdCtrls, Vcl.Menus, System.Math, System.IniFiles, System.StrUtils, System.Types;

type
  TMarketsForm = class(TForm, IEDDataListener)
    ListView: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    MarketsCheck: TCheckBox;
    ConstrCheck: TCheckBox;
    InclIgnoredCheck: TCheckBox;
    FilterEdit: TComboBox;
    InclPartialCheck: TCheckBox;
    PopupMenu: TPopupMenu;
    EditCommentMenuItem: TMenuItem;
    ToggleIgnoredMenuItem: TMenuItem;
    ToggleFavoriteMenuItem: TMenuItem;
    SelectCurrentMenuItem: TMenuItem;
    AddToDepotGroupMenuItem: TMenuItem;
    N1: TMenuItem;
    CopyMenuItem: TMenuItem;
    CopyAllMenuItem: TMenuItem;
    ClearFilterButton: TButton;
    FleetCarrierSubMenu: TMenuItem;
    SetAsConstrDepotMenuItem: TMenuItem;
    SetAsStockMenuItem: TMenuItem;
    TaskGroupSubMenu: TMenuItem;
    askGroup2: TMenuItem;
    OtherGroupMenuItem: TMenuItem;
    N3: TMenuItem;
    Clear1: TMenuItem;
    MarketInfoMenuItem: TMenuItem;
    CopySystemNameMenuItem: TMenuItem;
    CompareMarketsMenuItem: TMenuItem;
    MarketSnapshotMenuItem: TMenuItem;
    InclSnapshotsCheck: TCheckBox;
    RemoveSnapshotMenuItem: TMenuItem;
    AltSelCheck: TCheckBox;
    GroupDepotGroupMenuItem: TMenuItem;
    N5: TMenuItem;
    ConstructionsSubMenu: TMenuItem;
    MarketsSubMenu: TMenuItem;
    N2: TMenuItem;
    EditTimer: TTimer;
    SystemInfoMenuItem: TMenuItem;
    N4: TMenuItem;
    ConstructionInfoMenuItem: TMenuItem;
    InclPlannedCheck: TCheckBox;
    MarketHistoryMenuItem: TMenuItem;
    ShowOnMapMenuItem: TMenuItem;
    ConstrTypesButton: TButton;
    InclOtherColCheck: TCheckBox;
    N6: TMenuItem;
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormShow(Sender: TObject);
    procedure FilterEditChange(Sender: TObject);
    procedure ListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListViewAction(Sender: TObject);
    procedure MarketsCheckClick(Sender: TObject);
    procedure CopyMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearFilterButtonClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure TaskGroupMenuItemClick(Sender: TObject);
    procedure OtherGroupMenuItemClick(Sender: TObject);
    procedure CompareMarketsMenuItemClick(Sender: TObject);
    procedure MarketSnapshotMenuItemClick(Sender: TObject);
    procedure RemoveSnapshotMenuItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AltSelCheckClick(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GroupDepotGroupMenuItemClick(Sender: TObject);
    procedure EditTimerTimer(Sender: TObject);
    procedure ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure MarketHistoryMenuItemClick(Sender: TObject);
    procedure ConstrTypesButtonClick(Sender: TObject);
  private
    { Private declarations }
    FHighlightColor: Integer;
    FHoldUpdate: Boolean;
    ClickedColumn: Integer;
    SortColumn: Integer;
    SortAscending: Boolean;
    FSelectedItems: TStringList;
    function IsSelected(item: TListItem): Boolean;
    procedure SaveSelection;
    procedure RestoreSelection;
  public
    { Public declarations }
    procedure OnEDDataUpdate;
    procedure ApplySettings;
    procedure UpdateAndShow;
    procedure SetColony(sid: string);
    procedure SetMarketFilter(fs: string; const cmdtyf: Boolean = false);
    procedure BeginFilterChange;
    procedure EndFilterChange;
    procedure UpdateItems(const _autoSizeCol: Boolean = true);
    procedure ShowComparison(ml: TStringList);
    procedure ShowMarketHistory(m: TMarket);
    procedure SetRecentSort;
  end;

var
  MarketsForm: TMarketsForm;

implementation

uses Main,Clipbrd,Settings, MarketInfo, Splash, SystemInfo, StationInfo,
  StarMap, ConstrTypes;

{$R *.dfm}

const cMarketIgnoreInd: array [miNormal..miLast] of string = ('','●','','','','');
const cMarketFavInd: array [miNormal..miLast] of string = ('','','','●','●●','');

procedure TMarketsForm.OnEDDataUpdate;
begin
  if Visible then
  if ListView.Items.Count < 1000 then
  begin
    SaveSelection;
    UpdateItems;
    RestoreSelection;
  end;
end;

procedure TMarketsForm.SetColony(sid: string);
begin
  BeginFilterChange;
  try
    MarketsCheck.Checked := True;
    ConstrCheck.Checked := True;
//    InclPlannedCheck.Checked := True;
    FilterEdit.Text := sid;
    SortColumn := 6;
    SortAscending := True;
  finally
    EndFilterChange;
  end;
  UpdateAndShow;
end;

procedure TMarketsForm.SetMarketFilter(fs: string; const cmdtyf: Boolean);
begin
  BeginFilterChange;
  try
    MarketsCheck.Checked := True;
    ConstrCheck.Checked := False;
    FilterEdit.Text := fs;
    if cmdtyf then
      if FilterEdit.Items.IndexOf(fs) = -1 then
        FilterEdit.Items.Add(fs);
    SortColumn := 5;
    SortAscending := True;
  finally
    EndFilterChange;
  end;
  UpdateAndShow;
end;


procedure TMarketsForm.UpdateAndShow;
begin
  if Visible then
    UpdateItems
  else
    Show;
  if WindowState = wsMinimized then WindowState := wsNormal;
  BringToFront;
end;

procedure TMarketsForm.OtherGroupMenuItemClick(Sender: TObject);
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

procedure TMarketsForm.TaskGroupMenuItemClick(Sender: TObject);
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

procedure TMarketsForm.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  gLastCursorPos := Mouse.CursorPos;
end;

procedure TMarketsForm.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
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

procedure TMarketsForm.PopupMenuPopup(Sender: TObject);
var cdf,mf,snapf: Boolean;
    m: TBaseMarket;
    sl: TStringList;
    i: Integer;
    mitem: TMenuItem;
begin
  cdf := False;
  mf := False;
  snapf := False;
  m := nil;
  if ListView.Selected <> nil then
  begin
    m :=  TBaseMarket(ListView.Selected.Data);
    cdf := m is TConstructionDepot;
    mf := (m is TMarket) and not TMarket(m).Snapshot;
    snapf := (m is TMarket) and TMarket(m).Snapshot;
  end;
  EditCommentMenuItem.Enabled := m <> nil;
  SelectCurrentMenuItem.Enabled := mf or cdf;
  ShowOnMapMenuItem.Enabled := mf or cdf;

  FleetCarrierSubMenu.Enabled := (m <> nil) and (m.StationType = 'FleetCarrier');
  MarketsSubMenu.Enabled := mf or snapf;
  ConstructionsSubMenu.Enabled := cdf;

  TaskGroupSubMenu.Enabled := mf or cdf;
  AddToDepotGroupMenuItem.Enabled := cdf;
  GroupDepotGroupMenuItem.Enabled := cdf;
  MarketInfoMenuItem.Enabled := mf or snapf;
  MarketHistoryMenuItem.Enabled := mf;
  MarketSnapshotMenuItem.Enabled := mf;
  RemoveSnapshotMenuItem.Enabled := snapf;
  CompareMarketsMenuItem.Enabled := mf or snapf;
  ToggleFavoriteMenuItem.Enabled := mf or cdf;
  ToggleIgnoredMenuItem.Enabled := mf or cdf;
  CopyMenuItem.Enabled := m <> nil;
  CopySystemNameMenuItem.Enabled := m <> nil;

  for i := TaskGroupSubMenu.Count - 1 downto 0 do
  begin
    if TaskGroupSubMenu.Items[i].Tag > 0 then
      TaskGroupSubMenu.Delete(i);
  end;
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
end;

procedure TMarketsForm.RemoveSnapshotMenuItemClick(Sender: TObject);
var mid: string;
begin
  if ListView.Selected = nil then Exit;
  if not (TBaseMarket(ListView.Selected.Data) is TMarket) then Exit;
  if not TMarket(ListView.Selected.Data).Snapshot then Exit;

  if Vcl.Dialogs.MessageDlg('Delete this snapshot?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  mid := TBaseMarket(ListView.Selected.Data).MarketId;
  DataSrc.RemoveMarketSnapshot(mid);
//  UpdateItems;
end;

procedure TMarketsForm.MarketsCheckClick(Sender: TObject);
begin
  UpdateItems;
end;

procedure TMarketsForm.MarketSnapshotMenuItemClick(Sender: TObject);
var mid: string;
begin
  if ListView.Selected = nil then Exit;
  if not (TBaseMarket(ListView.Selected.Data) is TMarket) then Exit;
  if TMarket(ListView.Selected.Data).Snapshot then Exit;
  mid := TBaseMarket(ListView.Selected.Data).MarketId;
  InclSnapshotsCheck.Checked := True;
  DataSrc.CreateMarketSnapshot(mid);
//  UpdateItems;
end;

procedure TMarketsForm.ClearFilterButtonClick(Sender: TObject);
begin
   FilterEdit.Text := '';
   UpdateItems;
end;

procedure TMarketsForm.AltSelCheckClick(Sender: TObject);
begin
  ListView.Checkboxes := AltSelCheck.Checked;
end;

function TMarketsForm.IsSelected(item: TListItem): Boolean;
begin
  if AltSelCheck.Checked then
    Result := item.Checked
  else
    Result := item.Selected;
end;

procedure TMarketsForm.ShowComparison(ml: TStringList);
var i,cw,x: Integer;
    mi: TMarketInfoForm;
begin
  MarketInfoForm.CloseComparison;
  x := 0;
  mi := nil;
  for i := 0 to ml.Count -1 do
    if TBaseMarket(ml.Objects[i]) is TMarket then
    begin
      if mi <> nil then mi.CloseComparisonButton.Visible := False;
      mi := TMarketInfoForm.Create(Application);
      mi.SetMarket(TMarket(ml.Objects[i]),true);
      mi.FormStyle := fsStayOnTop;
      mi.Position := poDesigned;
      mi.BorderStyle := bsNone;
      mi.Left := x;
      mi.Top := 0;
      mi.Height := Screen.Height - 40;
      mi.CloseComparisonButton.Visible := true;
      mi.VertDivider1.Visible := True;
      mi.VertDivider2.Visible := True;
      mi.Show;
      mi.BringToFront;
      x := x + mi.Width;
      if (x + mi.Width) > Screen.Width then Exit;
    end;
end;

procedure TMarketsForm.CompareMarketsMenuItemClick(Sender: TObject);
var i: Integer;
    ml: TStringList;
begin
  ml := TStringList.Create;
  for i := 0 to ListView.Items.Count -1 do
    if IsSelected(ListView.Items[i]) then
      if TBaseMarket(ListView.Items[i].Data) is TMarket then
        ml.AddObject('',ListView.Items[i].Data);
  ShowComparison(ml);
  ml.Free;
end;

procedure TMarketsForm.ConstrTypesButtonClick(Sender: TObject);
begin
  ConstrTypesForm.Show;
end;

procedure TMarketsForm.MarketHistoryMenuItemClick(Sender: TObject);
begin
  if ListView.Selected = nil then Exit;
  if not (TObject(ListView.Selected.Data) is TMarket) then Exit;
  ShowMarketHistory(TMarket(ListView.Selected.Data));
end;

procedure TMarketsForm.ShowMarketHistory(m: TMarket);
var i: Integer;
    ml: TStringList;
    mID: string;
    ms: TMarket;
begin
  ml := TStringList.Create;
  ml.AddObject(m.LastUpdate,m);
  mID := m.MarketId + '.';
  for i := 0 to DataSrc.MarketSnapshots.Count - 1 do
  begin
    ms := TMarket(DataSrc.MarketSnapshots.Objects[i]);
    if ms.MarketId.StartsWith(mID) then
      ml.AddObject(ms.LastUpdate,ms);
  end;
  ml.Sort;
  ShowComparison(ml);
  ml.Free;
end;

procedure TMarketsForm.CopyMenuItemClick(Sender: TObject);
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

procedure TMarketsForm.EditTimerTimer(Sender: TObject);
begin
  try
    if AltSelCheck.Checked then SaveSelection;
    UpdateItems;
    if AltSelCheck.Checked then RestoreSelection;
  finally
    EditTimer.Enabled := False;
  end;
end;

procedure TMarketsForm.FilterEditChange(Sender: TObject);
begin
  EditTimer.Enabled := False;
  EditTimer.Enabled := True;
end;

procedure TMarketsForm.ApplySettings;
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

  if Visible then UpdateItems(true);
end;

procedure TMarketsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if WindowState = wsNormal then
  begin
    Opts['Markets.Left'] := IntToStr(self.Left);
    Opts['Markets.Top'] := IntToStr(self.Top);
    Opts['Markets.Height'] := IntToStr(self.Height);
    Opts['Markets.Width'] := IntToStr(self.Width);
    Opts.Save;
  end;
end;

procedure TMarketsForm.SetRecentSort;
begin
  SortColumn := 4; //last visit
  SortAscending := False;
end;

procedure TMarketsForm.FormCreate(Sender: TObject);
var i: Integer;
begin
  SetRecentSort;
  FSelectedItems := TStringList.Create;

  DataSrc.AddListener(self);
  ApplySettings;

  self.Width := StrToIntDef(Opts['Markets.Width'],self.Width);
  self.Height := StrToIntDef(Opts['Markets.Height'],self.Height);
  self.Left := StrToIntDef(Opts['Markets.Left'],(Screen.Width - self.Width) div 2);
  self.Top := StrToIntDef(Opts['Markets.Top'],Screen.Height div 2);


  if Opts['Markets.AlphaBlend'] <> '' then
  begin
    AlphaBlendValue := StrToIntDef(Opts['Markets.AlphaBlend'],255);
    AlphaBlend := True;
  end;
end;

procedure TMarketsForm.FormShow(Sender: TObject);
begin
  UpdateItems(true);
  FilterEdit.SetFocus;
end;

procedure TMarketsForm.GroupDepotGroupMenuItemClick(Sender: TObject);
var i: Integer;
    s, errstr: string;
begin
  s := '';
  errstr := '';
  for i := 0 to ListView.Items.Count -1 do
    if IsSelected(ListView.Items[i]) then
      if TBaseMarket(ListView.Items[i].Data) is TConstructionDepot then
      with TConstructionDepot(ListView.Items[i].Data) do
      begin
        s := s + MarketID + Chr(13);
        if (Status = '') and (CustomRequest = '') then
          errstr := errstr + Chr(13) + StationName_full;
      end;
  if s <> '' then
  begin
    EDCDForm.SetDepotGroup(s);
    if errstr <> '' then
     ShowMessage('WARNING: Constructions in group with no material list:' + errstr);
  end;

end;

procedure TMarketsForm.SaveSelection;
var i: Integer;
begin
  FSelectedItems.Clear;
  for i := 0 to ListView.Items.Count - 1 do
    if IsSelected(ListView.Items[i]) then
      FSelectedItems.Add(TBaseMarket(ListView.Items[i].Data).MarketID);
end;

procedure TMarketsForm.RestoreSelection;
var i: Integer;
    scrollf: Boolean;
begin
  scrollf := true;
  for i := 0 to ListView.Items.Count - 1 do
  begin
    if ListView.Items[i].Data <> nil then
    if FSelectedItems.IndexOf(TBaseMarket(ListView.Items[i].Data).MarketID) > -1 then
    begin
      if AltSelCheck.Checked then
        ListView.Items[i].Checked := True
      else
        ListView.Items[i].Selected := True;
      if scrollf then
      begin
        ListView.ItemIndex := i;
        ListView.Items[i].MakeVisible(false);
        scrollf := false;
      end;
    end;
  end;
end;

procedure TMarketsForm.UpdateItems(const _autoSizeCol: Boolean = true);
var
  i,j,curCol: Integer;
  cd: TConstructionDepot;
  m: TMarket;
  s: string;
  fs,orgfs,cs,sups: string;
  items: THashedStringList;
  row: TStringList;
  lev: TMarketLevel;
  ignoredf,partialf,plannedf,allsysf,findcmdtyf: Boolean;
  d: Extended;
  colSz: array [0..100] of Integer;
  colMaxLen: array [0..100] of Integer;
  colMaxTxt: array [0..100] of string;
  autoSizeCol: Boolean;
  fsarr: TStringDynArray;
  fscmdty: TBooleanDynArray;

  procedure addRow(data: TObject);
  var i,ln: Integer;
      item: TListItem;
  begin
    for i := 0 to row.Count - 1 do
    begin
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

  procedure addSubItem(s: string);
  begin
    row.Add(s);
  end;

{  function CheckFilter(bm: TBaseMarket): Boolean;
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

      if not Result then
        if bm is TMarket then
        begin
//          Result := TMarket(item.Data).Stock.IndexOfName(fs) >= 0;
          sups := TMarket(bm).Stock.Values[fs];
          Result := sups > '0';
        end;
    end;
  end;
 }
  function CheckFilter(bm: TBaseMarket): Boolean;
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
          if not Result then
            if bm is TMarket then
              if fscmdty[i2] then
                Result := bm.Stock.Qty[fsarr[i2]] > 0
              else
              begin
                s := TMarket(bm).Stock.Text;
                Result := Pos(fsarr[i2],s) > 0;
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

  items := THashedStringList.Create;
  items.Sorted := True;
  items.Duplicates := dupIgnore;
  row := TStringList.Create;

  try
    ignoredf := InclIgnoredCheck.Checked;
    partialf := InclPartialCheck.Checked;
    plannedf := InclPlannedCheck.Checked;
    allsysf := InclOtherColCheck.Checked;

    ListView.Items.BeginUpdate;

    ListView.Items.Clear;
    ListView.SortType := stNone;

    for i := 0 to ListView.Columns.Count - 1 do
    begin
      colMaxLen[i] := Length(ListView.Columns[i].Caption);
      colMaxTxt[i] := ListView.Columns[i].Caption;
    end;

    orgfs := FilterEdit.Text;
    fs := LowerCase(orgfs);

    fsarr := SplitString(fs,'+');
    SetLength(fscmdty,High(fsarr)+1);
    for i := 0 to High(fsarr) do
      fscmdty[i] := (FilterEdit.Items.IndexOf(fsarr[i]) <> -1);
    findcmdtyf := (FilterEdit.Items.IndexOf(fs) <> -1) or (Pos('+',fs) > 0);

  //  cs := CommodityCombo.Text;

    if ConstrCheck.Checked {and (cs = '')} then
    for i := 0 to DataSrc.Constructions.Count - 1 do
    begin
      cd := TConstructionDepot(DataSrc.Constructions.Objects[i]);
      //if cd.Status = '' then
      //  if not partialf then continue; //docked but no depot info? user-added depots work like this
      lev := DataSrc.GetMarketLevel(cd.MarketId);
      if not ignoredf then
        if lev = miIgnore then continue;
      if not plannedf then
        if cd.Planned then continue; //docked but no market info
      if not allsysf then
        if cd.GetSys <> nil then
          if not cd.GetSys.IsOwnColony then continue;


      s := cd.StationName_full;
      if cd.LinkedMarketId <> '' then
      begin
        m := DataSrc.MarketFromID(cd.LinkedMarketId);
        if m <> nil then
          s := m.StationName_full;
      end;
      addCaption(s);
      s := '';
      if cd.Simulated then
        s := '(Simul.)'
      else
        case cd.ConstrStatus of
          csInProgress: s := '(Active)';
          csFinished: s := '(Finished)';
          csCancelled: s := '(Cancelled)';
          csTentative: ;
          csPlanned: s := '(Planned)';
        end;
      if cd.GetConstrType <> nil then
        s := s + ' ' + cd.GetConstrType.StationType_full;
      addSubItem(s);
      addSubItem(cd.StarSystem_nice);
      addSubItem(cd.Body);
      s := cd.LastDock;
      if s < cd.LastUpdate then s := cd.LastUpdate;
      addSubItem(niceTime(s));
      addSubItem('');
      s := '';
      if cd.DistFromStar >= 0 then
        s := Format('%.0n', [double(cd.DistFromStar)]);
      addSubItem(s);

      addSubItem('');
//      s := Format('%.0n', [double(cd.Contribution)]);
//      addSubItem(s);

      addSubItem(cMarketIgnoreInd[DataSrc.GetMarketLevel(cd.MarketId)]);
      addSubItem('');
      s := cd.GetComment;
//      s := DataSrc.MarketComments.Values[cd.MarketID];
      {if s = '' then
        if (cd.ConstructionType <> '') and (cd.GetConstrType <> nil) then
          s := '(' + cd.GetConstrType.StationType + ')'; }
      addSubItem(s);
      addSubItem('');
      addSubItem(DataSrc.MarketGroups.Values[cd.MarketID]);

      if CheckFilter(cd) then addRow(cd);
    end;

    if MarketsCheck.Checked then
    for i := 0 to DataSrc.RecentMarkets.Count - 1 do
    begin
      m := TMarket(DataSrc.RecentMarkets.Objects[i]);
      if m.Status = '' then
        if not partialf then continue; //docked but no market info
      if not allsysf then
        if m.GetSys <> nil then
          if not m.GetSys.IsOwnColony then continue;

      lev := DataSrc.GetMarketLevel(m.MarketId);
      if not ignoredf then
        if lev = miIgnore then continue;
      addCaption(m.StationName_full);
      addSubItem(m.StationType);
      addSubItem(m.StarSystem_nice);
      addSubItem(m.Body);
      s := m.LastDock;
      if s < m.LastUpdate then s := m.LastUpdate;
      s := niceTime(s);
      if m.StationType <> 'FleetCarrier' then
        if DataSrc.LastConstrTimes.Values[m.StarSystem] > m.LastDock then
          s := s + '  *';
      addSubItem(s);
      s := '';
      try
        if EDCDForm.CurrentDepot <> nil then
        begin
          d := m.DistanceTo(EDCDForm.CurrentDepot);
          if d > 0 then
            s := FloatToStrF(d,ffFixed,7,2);
        end
        else
        if DataSrc.CurrentSystem <> nil then
        begin
          d := m.GetSys.DistanceTo(DataSrc.CurrentSystem);
          if d > 0 then
            s := FloatToStrF(d,ffFixed,7,2);
        end;
      except
      end;

      addSubItem(s);
      s := '';
      if m.DistFromStar >= 0 then
        s := Format('%.0n', [double(m.DistFromStar)]);
      addSubItem(s);
      s := '';
      if findcmdtyf then
        if High(fsarr) > 0 then
          s := '(' + IntToStr(High(fsarr)+1) + ' items)'
        else
          s := Format('%.0n', [double(m.Stock.Qty[fs])]);
      addSubItem(s);
      addSubItem(cMarketIgnoreInd[lev]);
      addSubItem(cMarketFavInd[lev]);
//      addSubItem(s);
      //addSubItem(DataSrc.MarketComments.Values[m.MarketID]);
      addSubItem(m.GetComment);
      addSubItem(m.Economies);
      addSubItem(DataSrc.MarketGroups.Values[m.MarketID]);

      for j := 0 to m.Stock.Count - 1 do
      begin
        s := m.Stock.Names[j];
        if LeftStr(s,1) <> '$' then
          if FilterEdit.Items.IndexOf(s) = -1 then
            items.Add(s);
      end;

      if CheckFilter(m) then addRow(m);

    end;

    if MarketsCheck.Checked and InclSnapshotsCheck.Checked then
    for i := 0 to DataSrc.MarketSnapshots.Count - 1 do
    begin
      m := TMarket(DataSrc.MarketSnapshots.Objects[i]);
      if not allsysf then
        if m.GetSys <> nil then
          if not m.GetSys.IsOwnColony then continue;
      addCaption(m.StationName);
      addSubItem(m.StationType);
      addSubItem(m.StarSystem_nice);
      addSubItem('');
      s := niceTime(m.LastUpdate);
      addSubItem(s);
      addSubItem('');
      addSubItem('');
      s := '';
      if findcmdtyf then
        s := Format('%.0n', [double(m.Stock.Qty[fs])]);
      addSubItem(s);
      addSubItem('');
      addSubItem('');
//      addSubItem(DataSrc.MarketComments.Values[m.MarketID]);
      addSubItem(m.GetComment);
      addSubItem(m.Economies);
      addSubItem('');
      if CheckFilter(m) then addRow(m);
    end;

    FilterEdit.Items.AddStrings(items);

    if autoSizeCol then
    begin
      //for i := 0 to ListView.Columns.Count - 2 do
      //   ListView.Column[i].Width := -2;  //this is EXTREMELY slow!
      //ListView.Column[ListView.Columns.Count - 1].Width := -1;  //this stays at -1

      for i := 0 to ListView.Columns.Count - 1 do
        ListView.Column[i].Width := ListView.Canvas.TextWidth(colMaxTxt[i]) +
          15 + ListView.Font.Size div 6; //margins
    end;

    if findcmdtyf then
    begin
      ListView.Columns[7].Caption := 'Stock';
      ListView.Columns[7].Width := -2;
    end
    else
    begin
      ListView.Columns[7].Caption := '';
      ListView.Columns[7].Width := 0;
    end;

    ListView.SortType := stText;
    ListView.Items.EndUpdate;

  finally
    items.Free;
  end;
end;

procedure TMarketsForm.ListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
   TListView(Sender).SortType := stNone;
  if SortColumn = Column.Index then
    SortAscending := not SortAscending
  else
    SortColumn := Column.Index;
  TListView(Sender).SortType := stText;
end;

procedure TMarketsForm.ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
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
    if (SortColumn = 5) or (SortColumn = 7)  then
      Compare := CompareText(
        Item1.SubItems[SortColumn-1].PadLeft(10),
        Item2.SubItems[SortColumn-1].PadLeft(10))
    else
    if SortColumn = 6 then
      Compare := CompareValue(TBaseMarket(Item1.Data).DistFromStar,TBaseMarket(Item2.Data).DistFromStar)
{    else

    if SortColumn = 7 then
    begin
      s := FilterEdit.Text;
      Compare := CompareValue(
        TBaseMarket(Item1.Data).Stock.Qty[s],TBaseMarket(Item2.Data).Stock.Qty[s])
    end
 }
    else
      Compare := CompareText(
        Item1.SubItems[SortColumn-1] + '    ' + Item1.Caption,
        Item2.SubItems[SortColumn-1] + '    ' + Item2.Caption);
  end;

  if not SortAscending then Compare := -Compare;
end;

procedure TMarketsForm.ListViewCustomDrawItem(Sender: TCustomListView;
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

  if Opts.Flags['HighlightGoals'] then
  if TObject(Item.Data) is TConstructionDepot then
  if not TConstructionDepot(Item.Data).Finished then
  if TConstructionDepot(Item.Data).GetSys <> nil then
    if (Pos('!',TConstructionDepot(Item.Data).Comment) > 0) or
       (TConstructionDepot(Item.Data).GetSys.CurrentGoals <> '') then
    begin
      if (Pos('!',TConstructionDepot(Item.Data).Comment) > 0) or
         (Pos('!',TConstructionDepot(Item.Data).GetSys.CurrentGoals) > 0)  then
      begin
        if not Opts.Flags['DarkMode'] then
          Sender.Canvas.Font.Color := clBlue
        else
          Sender.Canvas.Font.Color := clWhite;
      end
      else
        if not Opts.Flags['DarkMode'] then
          Sender.Canvas.Font.Color := clNavy
        else
          Sender.Canvas.Font.Color := FHighlightColor;
    end
    else
      Sender.Canvas.Font.Color := ListView.Font.Color;
end;

procedure TMarketsForm.ListViewAction(Sender: TObject);
var mid: string;
    lev: TMarketLevel;
    s,orgs: string;
    action: Integer;
    sys: TStarSystem;
    bm: TBaseMarket;
begin
  if ListView.Selected = nil then Exit;
  action := -1;
  if Sender is TListView then
  begin
    if ClickedColumn = -1 then Exit;
    action := ListView.Columns[ClickedColumn].Tag;
  end;
  if Sender is TMenuItem then action := TMenuItem(Sender).Tag;
  if action = -1 then Exit;
  bm := TBaseMarket(ListView.Selected.Data);
  mid := bm.MarketId;
  case action  of
  2:
    begin
      sys := bm.GetSys;
      if sys <> nil then
      begin
        SystemInfoForm.SetSystem(sys,bm,true);
        SystemInfoForm.RestoreAndShow;
      end;
//      FilterEdit.Text := bm.StarSystem_nice;
//      UpdateItems;
    end;
  3:
    begin
      FilterEdit.Text := ListView.Selected.SubItems[ClickedColumn-1];
      UpdateItems;
    end;
  4:
    begin
      if DataSrc.GetMarketLevel(mid) = miIgnore then
        DataSrc.SetMarketLevel(mid,miNormal)
      else
        DataSrc.SetMarketLevel(mid,miIgnore);
     end;
  5:
    begin
      lev := DataSrc.GetMarketLevel(mid);
      if lev = miPriority then
        lev := miNormal
      else
        if lev = miFavorite then
          lev := miPriority
        else
          lev := miFavorite;
      DataSrc.SetMarketLevel(mid,lev);
    end;
  6:
    begin
      orgs := bm.GetComment;
      s := Vcl.Dialogs.InputBox(bm.StationName, 'Info', orgs);
      if s <> orgs then
      begin
        if (bm is TConstructionDepot) and (bm.GetSys <> nil) then
        begin
          bm.Comment := s;
          bm.GetSys.UpdateSave;
          //remove old solution entry for construction depots
          DataSrc.UpdateMarketComment(mid,'');
        end
        else
          DataSrc.UpdateMarketComment(mid,s);
      end;
    end;
  8:
    begin
      orgs := DataSrc.MarketGroups.Values[mid];
      s := Vcl.Dialogs.InputBox(bm.StationName, 'Group', orgs);
      if s <> orgs then
      begin
        DataSrc.UpdateMarketGroup(mid,s,false);
        UpdateItems;
      end;
    end;
  11:
    begin
      if bm is TConstructionDepot then
        EDCDForm.AddDepotToGroup(TConstructionDepot(bm));
    end;
  12:
    begin
      if bm is TMarket then
        EDCDForm.MarketAsDepotDlg(TMarket(bm));
    end;
  13:
    begin
      if bm is TMarket then
        EDCDForm.MarketAsExtCargoDlg(TMarket(bm),-1);
    end;
  15:
    begin
       Clipboard.SetTextBuf(PChar(bm.StarSystem));
    end;
  20:
    begin
      sys := bm.GetSys;
      if sys <> nil then
      begin
        SystemInfoForm.SetSystem(sys,bm);
        SystemInfoForm.RestoreAndShow;
      end;
    end;
  22:
    begin
      sys := bm.GetSys;
      if sys <> nil then
      begin
        StarMapForm.SelectSystem(sys);
        StarMapForm.RestoreAndShow;
      end;
    end;
  1:
    begin
      if bm is TConstructionDepot then
      begin
        SplashForm.ShowInfo('Switching construction depot...',1000);
        EDCDForm.SetDepot(mid,false);
      end;
      if bm is TMarket then
        if not TMarket(bm).Snapshot then
        begin
          SplashForm.ShowInfo('Switching market...',1000);
          EDCDForm.SetSecondaryMarket(mid);
        end;
    end;
  else //21
    begin
      if bm is TConstructionDepot then
      begin
        StationInfoForm.SetStation(bm);
        StationInfoForm.RestoreAndShow;
      end;
      if bm is TMarket then
      begin
//        with MarketInfoForm do
        with TMarketInfoForm.Create(Application) do
        begin
          SetMarket(TMarket(bm),false,LowerCase(FilterEdit.Text));
          FormStyle := fsStayOnTop;
          Show;
        end;
      end;
    end;

  end;

  ClickedColumn := -1;
end;

procedure TMarketsForm.ListViewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  l: TListItem;
  i: integer;
  w,xm: integer;
begin
  ClickedColumn := -1;
  w := 0;
  xm := x;
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

procedure TMarketsForm.BeginFilterChange;
begin
  FHoldUpdate := True;

  //this is only needed because changing checkboxes immediately trigger their Clicked event
  //not the case with edits
end;

procedure TMarketsForm.EndFilterChange;
begin
  FHoldUpdate := false;
//  UpdateItems;
end;

end.
