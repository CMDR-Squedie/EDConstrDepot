unit Markets;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, DataSource,
  Vcl.StdCtrls, Vcl.Menus;

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
    AddComment1: TMenuItem;
    AddComment2: TMenuItem;
    AddToFavorite1: TMenuItem;
    Select1: TMenuItem;
    AddToDepotGroup1: TMenuItem;
    N1: TMenuItem;
    CopyMenuItem: TMenuItem;
    CopyAllMenuItem: TMenuItem;
    ClearFilterButton: TButton;
    N2: TMenuItem;
    FleetCarrierSubMenu: TMenuItem;
    SetAsConstrDepotMenuItem: TMenuItem;
    SetAsStockMenuItem: TMenuItem;
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
  private
    { Private declarations }
    SortColumn: Integer;
    ClickedColumn: Integer;
    SortAscending: Boolean;
  public
    { Public declarations }
    procedure OnEDDataUpdate;
    procedure ApplySettings;
  end;

var
  MarketsForm: TMarketsForm;

implementation

uses Main,Clipbrd,Settings;

{$R *.dfm}

const cMarketIgnoreInd: array [miNormal..miLast] of string = ('','●','','','','');
const cMarketFavInd: array [miNormal..miLast] of string = ('','','','●','●●','');

procedure TMarketsForm.OnEDDataUpdate;
begin
  if Visible then UpdateItems;
end;

procedure TMarketsForm.PopupMenuPopup(Sender: TObject);
var cdf,mf: Boolean;
    m: TBaseMarket;
begin
  cdf := False;
  mf := False;
  m :=  TBaseMarket(ListView.Selected.Data);
  if m <> nil then
  begin
    cdf := m is TConstructionDepot;
    mf := m is TMarket;
  end;
  FleetCarrierSubMenu.Enabled := (m<>nil) and (m.StationType='FleetCarrier');
end;

procedure TMarketsForm.MarketsCheckClick(Sender: TObject);
begin
  UpdateItems;
end;

procedure TMarketsForm.ClearFilterButtonClick(Sender: TObject);
begin
   FilterEdit.Text := '';
   UpdateItems;
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
      if not ListView.Items[i].Selected then continue;
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
    end;
  end
  else
  begin
    clr := EDCDForm.TextColLabel.Font.Color;
    {
    for i := 0 to Panel1.ControlCount - 1 do
    begin
      if Panel1.Controls[i] is TLabel then
        with TLabel(Panel1.Controls[i]) do
        begin
          Color := clBlack;
          Font.Color := clr;
        end;
      if Panel1.Controls[i] is TCheckBox then
        with TCheckBox(Panel1.Controls[i]) do
        begin
          Color := clBlack;
          Font.Color := clr;
        end;
    end;
    Panel1.Color := clBlack;
    }
    with ListView do
    begin
      Color := clBlack;
      Font.Color := clr;
      //GridLines := False;
    end;

  end;

end;

procedure TMarketsForm.FormCreate(Sender: TObject);
begin
  SortColumn := 3;
  SortAscending := False;

  DataSrc.AddListener(self);
  ApplySettings;
end;

procedure TMarketsForm.FormShow(Sender: TObject);
begin
  UpdateItems;
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
      item.Caption := cd.StationName;
      if cd.Finished then
        item.SubItems.Add('FinishedConstruction')
      else
        if cd.StationType = 'FleetCarrier' then
          item.SubItems.Add('SimulatedDepot')
        else
          item.SubItems.Add('ConstructionDepot');
      item.SubItems.Add(cd.StarSystem);
      s := cd.LastDock;
      if s < cd.LastUpdate then s := cd.LastUpdate;
      item.SubItems.Add(niceTime(s));
      item.SubItems.Add(cMarketIgnoreInd[DataSrc.GetMarketLevel(cd.MarketId)]);
      item.SubItems.Add('');
      item.SubItems.Add(DataSrc.MarketComments.Values[cd.MarketID]);
      item.SubItems.Add('');
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
      item.Caption := m.StationName;
      item.SubItems.Add(m.StationType);
      item.SubItems.Add(m.StarSystem);
      s := m.LastDock;
      if s < m.LastUpdate then s := m.LastUpdate;
      s := niceTime(s);
      if m.StationType <> 'FleetCarrier' then
        if DataSrc.LastConstrTimes.Values[m.StarSystem] > m.LastDock then
          s := s + '  *';
      item.SubItems.Add(s);
      item.SubItems.Add(cMarketIgnoreInd[lev]);
      item.SubItems.Add(cMarketFavInd[lev]);
//      item.SubItems.Add(s);
      item.SubItems.Add(DataSrc.MarketComments.Values[m.MarketID]);
      item.SubItems.Add(m.Economies);
      for j := 0 to m.Stock.Count - 1 do
        items.Add(m.Stock.Names[j]);
      if not CheckFilter then item.Delete;

    end;


    FilterEdit.Items.AddStrings(items);

    for i := 0 to ListView.Columns.Count - 1 do
       ListView.Column[i].Width := -2;
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
begin
  if SortColumn <= 0 then
  begin
    Compare := CompareText(Item1.Caption, Item2.Caption);
  end
  else
  begin
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
  if Sender is TListView then action := ClickedColumn;
  if Sender is TMenuItem then action := TMenuItem(Sender).Tag;
  if action = -1 then Exit;
  mid := TBaseMarket(ListView.Selected.Data).MarketId;
  case action  of
  2:
    begin
      FilterEdit.Text := TBaseMarket(ListView.Selected.Data).StarSystem;
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
        EDCDForm.MarketAsExtCargoDlg(TMarket(ListView.Selected.Data),1);
    end;
  else
    begin
      if TBaseMarket(ListView.Selected.Data) is TConstructionDepot then
        EDCDForm.SetDepot(mid,false);
      if TBaseMarket(ListView.Selected.Data) is TMarket then
        EDCDForm.SetSecondaryMarket(mid);
    end;
  end;

  ClickedColumn := -1;
end;

procedure TMarketsForm.ListViewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  l: TListItem;
  i: integer;
  w: integer;
begin
  ClickedColumn := -1;
  w := 0;
  for i := 0 to ListView.Columns.Count -1  do
  begin
    w := w + ListView.Column[i].Width;
    if w >= X then
    begin
      ClickedColumn := i;
      break;
    end;
  end;
end;

end.
