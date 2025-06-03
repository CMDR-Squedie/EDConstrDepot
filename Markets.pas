unit Markets;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, DataSource,
  Vcl.StdCtrls, Vcl.Menus, System.Math;

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
    N2: TMenuItem;
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
    N4: TMenuItem;
    CompareMarketsMenuItem: TMenuItem;
    MarketSnapshotMenuItem: TMenuItem;
    InclSnapshotsCheck: TCheckBox;
    RemoveSnapshotMenuItem: TMenuItem;
    CompareCheck: TCheckBox;
    Button1: TButton;
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormShow(Sender: TObject);
    procedure UpdateItems;
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
  end;

var
  MarketsForm: TMarketsForm;

implementation

uses Main,Clipbrd,Settings, MarketInfo, Splash;

{$R *.dfm}

const cMarketIgnoreInd: array [miNormal..miLast] of string = ('','●','','','','');
const cMarketFavInd: array [miNormal..miLast] of string = ('','','','●','●●','');

procedure TMarketsForm.OnEDDataUpdate;
begin
  if Visible then UpdateItems;
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
  TaskGroupSubMenu.Enabled := mf or cdf;
  AddToDepotGroupMenuItem.Enabled := cdf;
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

  if Vcl.Dialogs.MessageDlg('Are you sure you want to delete this snapshot?',
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
        s := s + ListView.Items[i].SubItems[j] + Chr(9);
    s := s + Chr(13);
  end;
  Clipboard.SetTextBuf(PChar(s));
end;

procedure TMarketsForm.FilterEditChange(Sender: TObject);
begin
  UpdateItems;
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
      //GridLines := False;
    end;

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
  SortColumn := 3; //last visit
  SortAscending := False;
  FSelectedItems := TStringList.Create;

  DataSrc.AddListener(self);
  ApplySettings;

  self.Width := StrToIntDef(Opts['Markets.Width'],self.Width);
  self.Height := StrToIntDef(Opts['Markets.Height'],self.Height);
  self.Left := StrToIntDef(Opts['Markets.Left'],Screen.Width - self.Width);
  self.Top := StrToIntDef(Opts['Markets.Top'],(Screen.Height - self.Height) div 2);

  if Opts['Markets.AlphaBlend'] <> '' then
  begin
    AlphaBlendValue := StrToIntDef(Opts['Markets.AlphaBlend'],255);
    AlphaBlend := True;
  end;
end;

procedure TMarketsForm.FormShow(Sender: TObject);
begin
  UpdateItems;
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
begin
  for i := 0 to ListView.Items.Count - 1 do
  begin
    if FSelectedItems.IndexOf(TBaseMarket(ListView.Items[i].Data).MarketID) > -1 then
      if CompareCheck.Checked then
        ListView.Items[i].Checked := True
      else
        ListView.Items[i].Selected := True;
  end;
end;

procedure TMarketsForm.UpdateItems;
var
  i,j: Integer;
  cd: TConstructionDepot;
  m: TMarket;
  s: string;
  item: TListItem;
  fs,cs: string;
  items: TStringList;
  lev: TMarketLevel;
  ignoredf,partialf: Boolean;

  function CheckFilter: Boolean;
  var i: Integer;
  begin
    Result := True;
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
          Result := TMarket(item.Data).Stock.IndexOfName(fs) >= 0;
    end;
  end;

  function niceTime(tms: string): string;
  begin
    Result := Copy(tms,1,10) + ' ' + Copy(tms,12,8);
  end;

begin

  SaveSelection;

  items := TStringList.Create;
  items.Sorted := True;
  items.Duplicates := dupIgnore;

  try
    ignoredf := InclIgnoredCheck.Checked;
    partialf := InclPartialCheck.Checked;

    ListView.SortType := stNone;
    ListView.Items.Clear;

    ListView.Items.BeginUpdate;

    fs := LowerCase(FilterEdit.Text);
  //  cs := CommodityCombo.Text;

    if ConstrCheck.Checked {and (cs = '')} then
    for i := 0 to DataSrc.Constructions.Count - 1 do
    begin
      cd := TConstructionDepot(DataSrc.Constructions.Objects[i]);
      if cd.Status = '' then
        if not partialf then continue; //docked but no depot info
      lev := DataSrc.GetMarketLevel(cd.MarketId);
      if not ignoredf then
        if lev = miIgnore then continue;
      item := ListView.Items.Add;
      item.Data := cd;
      item.Caption := cd.StationName_full;
      if cd.Finished then
        item.SubItems.Add('FinishedConstruction')
      else
        if cd.Simulated then
          item.SubItems.Add('SimulatedDepot')
        else
          item.SubItems.Add('ConstructionDepot');
      item.SubItems.Add(cd.StarSystem_nice);
      s := cd.LastDock;
      if s < cd.LastUpdate then s := cd.LastUpdate;
      item.SubItems.Add(niceTime(s));
      s := '';
      if cd.DistFromStar >= 0 then
        s := Format('%.0n', [double(cd.DistFromStar)]);
      item.SubItems.Add(s);
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
      s := m.LastDock;
      if s < m.LastUpdate then s := m.LastUpdate;
      s := niceTime(s);
      if m.StationType <> 'FleetCarrier' then
        if DataSrc.LastConstrTimes.Values[m.StarSystem] > m.LastDock then
          s := s + '  *';
      item.SubItems.Add(s);
      s := '';
      if m.DistFromStar >= 0 then
        s := Format('%.0n', [double(m.DistFromStar)]);
      item.SubItems.Add(s);
      item.SubItems.Add(cMarketIgnoreInd[lev]);
      item.SubItems.Add(cMarketFavInd[lev]);
//      item.SubItems.Add(s);
      item.SubItems.Add(DataSrc.MarketComments.Values[m.MarketID]);
      item.SubItems.Add(m.Economies);
      item.SubItems.Add(DataSrc.MarketGroups.Values[m.MarketID]);
      for j := 0 to m.Stock.Count - 1 do
        items.Add(m.Stock.Names[j]);
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
      s := niceTime(m.LastUpdate);
      item.SubItems.Add(s);
      item.SubItems.Add('');
      item.SubItems.Add('');
      item.SubItems.Add('');
      item.SubItems.Add(DataSrc.MarketComments.Values[m.MarketID]);
      item.SubItems.Add(m.Economies);
      item.SubItems.Add(DataSrc.MarketGroups.Values[m.MarketID]);
      if not CheckFilter then item.Delete;
    end;

    FilterEdit.Items.AddStrings(items);

    for i := 0 to ListView.Columns.Count - 1 do
       ListView.Column[i].Width := -2;
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
begin
  if SortColumn <= 0 then
  begin
    Compare := CompareText(Item1.Caption, Item2.Caption);
  end
  else
  begin
    if SortColumn = 4 then
      Compare := CompareValue(TBaseMarket(Item1.Data).DistFromStar,TBaseMarket(Item2.Data).DistFromStar)
    else
      Compare := CompareText(
        Item1.SubItems[SortColumn-1] + '    ' + Item1.Caption,
        Item2.SubItems[SortColumn-1] + '    ' + Item2.Caption);
  end;

  if not SortAscending then Compare := -Compare;
end;

procedure TMarketsForm.ListViewAction(Sender: TObject);
var mid: string;
    lev: TMarketLevel;
    s,orgs: string;
    action: Integer;
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
  mid := TBaseMarket(ListView.Selected.Data).MarketId;
  case action  of
  2:
    begin
      FilterEdit.Text := TBaseMarket(ListView.Selected.Data).StarSystem_nice;
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
      s := Vcl.Dialogs.InputBox(TBaseMarket(ListView.Selected.Data).StationName, 'Info', orgs);
      if s <> orgs then
      begin
        DataSrc.UpdateMarketComment(mid,s);
      end;
    end;
  8:
    begin
      orgs := DataSrc.MarketGroups.Values[mid];
      s := Vcl.Dialogs.InputBox(TBaseMarket(ListView.Selected.Data).StationName, 'Group', orgs);
      if s <> orgs then
      begin
        DataSrc.UpdateMarketGroup(mid,s,false);
        UpdateItems;
      end;
    end;
  11:
    begin
      if TBaseMarket(ListView.Selected.Data) is TConstructionDepot then
        EDCDForm.SetDepot(mid,true);
    end;
  12:
    begin
      if TBaseMarket(ListView.Selected.Data) is TMarket then
        EDCDForm.MarketAsDepotDlg(TMarket(ListView.Selected.Data));
    end;
  13:
    begin
      if TBaseMarket(ListView.Selected.Data) is TMarket then
        EDCDForm.MarketAsExtCargoDlg(TMarket(ListView.Selected.Data),-1);
    end;
  14:
    begin
      if TBaseMarket(ListView.Selected.Data) is TMarket then
      begin
//        with MarketInfoForm do
        with TMarketInfoForm.Create(Application) do
        begin
          SetMarket(TMarket(self.ListView.Selected.Data),false);
          FormStyle := fsStayOnTop;
          Show;
        end;
      end;
    end;
  15:
    begin
      with TBaseMarket(ListView.Selected.Data) do
        Clipboard.SetTextBuf(PChar(StarSystem));
    end;
  else
    begin
      if TBaseMarket(ListView.Selected.Data) is TConstructionDepot then
      begin
        EDCDForm.SetDepot(mid,false);
        SplashForm.ShowInfo('Switching construction depot...',1000);
      end;
      if TBaseMarket(ListView.Selected.Data) is TMarket then
        if not TMarket(ListView.Selected.Data).Snapshot then
        begin
          EDCDForm.SetSecondaryMarket(mid);
          SplashForm.ShowInfo('Switching market...',1000);
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
