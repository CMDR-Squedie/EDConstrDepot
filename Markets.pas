unit Markets;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, DataSource,
  Vcl.StdCtrls, Vcl.Menus, System.Math, System.IniFiles, System.StrUtils;

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
    CompareCheck: TCheckBox;
    Button1: TButton;
    GroupDepotGroupMenuItem: TMenuItem;
    N5: TMenuItem;
    ConstructionsSubMenu: TMenuItem;
    MarketsSubMenu: TMenuItem;
    N2: TMenuItem;
    EditTimer: TTimer;
    SystemInfoMenuItem: TMenuItem;
    N4: TMenuItem;
    ConstructionInfoMenuItem: TMenuItem;
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
    procedure CompareCheckClick(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GroupDepotGroupMenuItemClick(Sender: TObject);
    procedure EditTimerTimer(Sender: TObject);
    procedure ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }
    SortColumn: Integer;
    ClickedColumn: Integer;
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
    procedure SetMarketFilter(fs: string);
    procedure UpdateItems(const _autoSizeCol: Boolean = false);
  end;

var
  MarketsForm: TMarketsForm;

implementation

uses Main,Clipbrd,Settings, MarketInfo, Splash, SystemInfo, StationInfo;

{$R *.dfm}

const cMarketIgnoreInd: array [miNormal..miLast] of string = ('','●','','','','');
const cMarketFavInd: array [miNormal..miLast] of string = ('','','','●','●●','');

procedure TMarketsForm.OnEDDataUpdate;
begin
  if Visible then UpdateItems;
end;

procedure TMarketsForm.SetColony(sid: string);
begin
  MarketsCheck.Checked := True;
  ConstrCheck.Checked := True;
  FilterEdit.Text := sid;
  SortColumn := 6;
  SortAscending := True;
  UpdateAndShow;
end;

procedure TMarketsForm.SetMarketFilter(fs: string);
begin
  MarketsCheck.Checked := True;
  ConstrCheck.Checked := False;
  FilterEdit.Text := fs;
  SortColumn := 5;
  SortAscending := True;
  UpdateAndShow;
end;


procedure TMarketsForm.UpdateAndShow;
begin
  if Visible then
    UpdateItems
  else
    Show;
  if WindowState = wsMinimized then WindowState := wsNormal;
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

  FleetCarrierSubMenu.Enabled := (m <> nil) and (m.StationType = 'FleetCarrier');
  MarketsSubMenu.Enabled := mf or snapf;
  ConstructionsSubMenu.Enabled := cdf;

  TaskGroupSubMenu.Enabled := mf or cdf;
  AddToDepotGroupMenuItem.Enabled := cdf;
  GroupDepotGroupMenuItem.Enabled := cdf;
  MarketInfoMenuItem.Enabled := mf or snapf;
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
  UpdateItems(true);
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

procedure TMarketsForm.CompareCheckClick(Sender: TObject);
begin
  ListView.Checkboxes := CompareCheck.Checked;
end;

function TMarketsForm.IsSelected(item: TListItem): Boolean;
begin
  if CompareCheck.Checked then
    Result := item.Checked
  else
    Result := item.Selected;
end;

procedure TMarketsForm.CompareMarketsMenuItemClick(Sender: TObject);
var i,cw,x: Integer;
    mi: TMarketInfoForm;
begin
  MarketInfoForm.CloseComparison;
  x := 0;
  mi := nil;
  for i := 0 to ListView.Items.Count -1 do
    if IsSelected(ListView.Items[i]) then
      if TBaseMarket(ListView.Items[i].Data) is TMarket then
      begin
        if mi <> nil then mi.CloseComparisonButton.Visible := False;


        mi := TMarketInfoForm.Create(Application);
         mi.SetMarket(TMarket(ListView.Items[i].Data),true);
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
    UpdateItems;
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
begin
  if not Opts.Flags['MarketsDarkMode'] then
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

  end;
  with ListView do
  begin
    Font.Name := Opts['FontName2'];
    Font.Size := Opts.Int['FontSize2'];
  end;

end;

procedure TMarketsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Opts['Markets.Left'] := IntToStr(self.Left);
  Opts['Markets.Top'] := IntToStr(self.Top);
  Opts['Markets.Height'] := IntToStr(self.Height);
  Opts['Markets.Width'] := IntToStr(self.Width);
  Opts.Save;

end;

procedure TMarketsForm.FormCreate(Sender: TObject);
begin
  SortColumn := 4; //last visit
  SortAscending := False;
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
    s: string;
begin
  s := '';
  for i := 0 to ListView.Items.Count -1 do
    if IsSelected(ListView.Items[i]) then
      if TBaseMarket(ListView.Items[i].Data) is TConstructionDepot then
        s := s + TBaseMarket(ListView.Items[i].Data).MarketID + Chr(13);
  if s <> '' then
    EDCDForm.SetDepotGroup(s);
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
      if CompareCheck.Checked then
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

procedure TMarketsForm.UpdateItems(const _autoSizeCol: Boolean = false);
var
  i,j: Integer;
  cd: TConstructionDepot;
  m: TMarket;
  s: string;
  item: TListItem;
  fs,orgfs,cs,sups: string;
  items: THashedStringList;
  lev: TMarketLevel;
  ignoredf,partialf,findcmdtyf: Boolean;
  d: Extended;
  colSz: array [0..100] of Integer;
  autoSizeCol: Boolean;

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

      if not Result then
        if TBaseMarket(item.Data) is TMarket then
        begin
//          Result := TMarket(item.Data).Stock.IndexOfName(fs) >= 0;
          sups := TMarket(item.Data).Stock.Values[fs];
          Result := sups > '0';
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


  SaveSelection;

  items := THashedStringList.Create;
  items.Sorted := True;
  items.Duplicates := dupIgnore;

  try
    ignoredf := InclIgnoredCheck.Checked;
    partialf := InclPartialCheck.Checked;

    ListView.Items.BeginUpdate;

    ListView.Items.Clear;
    ListView.SortType := stNone;

    for i := 0 to ListView.Columns.Count - 1 do
    begin
      colSz[i] := ListView.Column[i].Width;
      ListView.Column[i].Width := 0;
    end;

    orgfs := FilterEdit.Text;
    fs := LowerCase(orgfs);
    findcmdtyf := FilterEdit.Items.IndexOf(fs) <> -1;

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

      item := ListView.Items.Add;
      item.Data := cd;
      item.Caption := cd.StationName_full;
      if cd.LinkedMarketId <> '' then
      begin
        m := DataSrc.MarketFromID(cd.LinkedMarketId);
        if m <> nil then
          item.Caption := m.StationName_full;
      end;
      if cd.Finished then
        item.SubItems.Add('FinishedConstruction')
      else
        if cd.Planned then
          item.SubItems.Add('PlannedConstruction')
        else
          if cd.Simulated then
            item.SubItems.Add('SimulatedDepot')
          else
            item.SubItems.Add('ConstructionDepot');
      item.SubItems.Add(cd.StarSystem_nice);
      item.SubItems.Add(cd.Body);
      s := cd.LastDock;
      if s < cd.LastUpdate then s := cd.LastUpdate;
      item.SubItems.Add(niceTime(s));
      item.SubItems.Add('');
      s := '';
      if cd.DistFromStar >= 0 then
        s := Format('%.0n', [double(cd.DistFromStar)]);
      item.SubItems.Add(s);
      item.SubItems.Add('');
      item.SubItems.Add(cMarketIgnoreInd[DataSrc.GetMarketLevel(cd.MarketId)]);
      item.SubItems.Add('');
      item.SubItems.Add(DataSrc.MarketComments.Values[cd.MarketID]);
      item.SubItems.Add('');
      item.SubItems.Add(DataSrc.MarketGroups.Values[cd.MarketID]);

      if not CheckFilter then item.Delete;
    end;

    if MarketsCheck.Checked then
    for i := 0 to DataSrc.RecentMarkets.Count - 1 do
    begin
      m := TMarket(DataSrc.RecentMarkets.Objects[i]);
      if m.Status = '' then
        if not partialf then continue; //docked but no market info
      lev := DataSrc.GetMarketLevel(m.MarketId);
      if not ignoredf then
        if lev = miIgnore then continue;
      item := ListView.Items.Add;
      item.Data := m;
      item.Caption := m.StationName_full;
      item.SubItems.Add(m.StationType);
      item.SubItems.Add(m.StarSystem_nice);
      item.SubItems.Add(m.Body);
      s := m.LastDock;
      if s < m.LastUpdate then s := m.LastUpdate;
      s := niceTime(s);
      if m.StationType <> 'FleetCarrier' then
        if DataSrc.LastConstrTimes.Values[m.StarSystem] > m.LastDock then
          s := s + '  *';
      item.SubItems.Add(s);
      s := '';
      try
        if EDCDForm.CurrentDepot <> nil then
        begin
          d := m.DistanceTo(EDCDForm.CurrentDepot);
          if d > 0 then
            s := FloatToStrF(d,ffFixed,7,2);
        end
        else
        begin
          d := m.GetSys.DistanceTo(DataSrc.CurrentSystem);
          if d > 0 then
            s := FloatToStrF(d,ffFixed,7,2);
        end;
      except
      end;

      item.SubItems.Add(s);
      s := '';
      if m.DistFromStar >= 0 then
        s := Format('%.0n', [double(m.DistFromStar)]);
      item.SubItems.Add(s);
      s := '';
      if findcmdtyf then
        s := Format('%.0n', [double(m.Stock.Qty[fs])]);
      item.SubItems.Add(s);
      item.SubItems.Add(cMarketIgnoreInd[lev]);
      item.SubItems.Add(cMarketFavInd[lev]);
//      item.SubItems.Add(s);
      item.SubItems.Add(DataSrc.MarketComments.Values[m.MarketID]);
      item.SubItems.Add(m.Economies);
      item.SubItems.Add(DataSrc.MarketGroups.Values[m.MarketID]);

      for j := 0 to m.Stock.Count - 1 do
      begin
        s := m.Stock.Names[j];
        if LeftStr(s,1) <> '$' then
          if FilterEdit.Items.IndexOf(s) = -1 then
            items.Add(s);
      end;

      if not CheckFilter then item.Delete;

    end;

    if MarketsCheck.Checked and InclSnapshotsCheck.Checked then
    for i := 0 to DataSrc.MarketSnapshots.Count - 1 do
    begin
      m := TMarket(DataSrc.MarketSnapshots.Objects[i]);
      item := ListView.Items.Add;
      item.Data := m;
      item.Caption := m.StationName;
      item.SubItems.Add(m.StationType);
      item.SubItems.Add(m.StarSystem_nice);
      item.SubItems.Add('');
      s := niceTime(m.LastUpdate);
      item.SubItems.Add(s);
      item.SubItems.Add('');
      item.SubItems.Add('');
      s := '';
      if findcmdtyf then
        s := Format('%.0n', [double(m.Stock.Qty[fs])]);
      item.SubItems.Add(s);
      item.SubItems.Add('');
      item.SubItems.Add('');
      item.SubItems.Add(DataSrc.MarketComments.Values[m.MarketID]);
      item.SubItems.Add(m.Economies);
      item.SubItems.Add('');
      if not CheckFilter then item.Delete;
    end;

    FilterEdit.Items.AddStrings(items);

    //set columns to auto-size;  nice, but ListView is EXTREMELY slow with this!!!
    //todo: set the column widths and add "auto-size" option for user to decide
    if autoSizeCol then
    begin
      for i := 0 to ListView.Columns.Count - 2 do
         ListView.Column[i].Width := -2;
      ListView.Column[ListView.Columns.Count - 1].Width := -1;

      for i := 0 to ListView.Columns.Count - 1 do
        colSz[i] := ListView.Column[i].Width;
    end;

    for i := 0 to ListView.Columns.Count - 1 do
      ListView.Column[i].Width := colSz[i];

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

    RestoreSelection;
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
    if SortColumn = 5 then
      Compare := CompareText(
        Item1.SubItems[SortColumn-1].PadLeft(10),
        Item2.SubItems[SortColumn-1].PadLeft(10))
    else
    if SortColumn = 6 then
      Compare := CompareValue(TBaseMarket(Item1.Data).DistFromStar,TBaseMarket(Item2.Data).DistFromStar)
    else
    if SortColumn = 7 then
    begin
      s := FilterEdit.Text;
      Compare := CompareValue(
        TBaseMarket(Item1.Data).Stock.Qty[s],TBaseMarket(Item2.Data).Stock.Qty[s])
    end
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
  if (action = 21) then
    if bm is TMarket then action := 14;

  case action  of
  2:
    begin
      FilterEdit.Text := bm.StarSystem_nice;
      UpdateItems;
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
      orgs := DataSrc.MarketComments.Values[mid];
      s := Vcl.Dialogs.InputBox(bm.StationName, 'Info', orgs);
      if s <> orgs then
      begin
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
        EDCDForm.SetDepot(mid,true);
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
  14:
    begin
      if bm is TMarket then
      begin
//        with MarketInfoForm do
        with TMarketInfoForm.Create(Application) do
        begin
          SetMarket(TMarket(bm),false);
          FormStyle := fsStayOnTop;
          Show;
        end;
      end;
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
        SystemInfoForm.SetSystem(sys);
        SystemInfoForm.Show;
      end;
    end;
  21:
    begin
      if bm is TConstructionDepot then
      begin
        StationInfoForm.SetStation(bm);
        StationInfoForm.Show;
      end;
    end;
  else
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

end.
