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
  private
    { Private declarations }
    SortColumn: Integer;
    ClickedColumn: Integer;
    SortAscending: Boolean;
  public
    { Public declarations }
    procedure OnEDDataUpdate;
  end;

var
  MarketsForm: TMarketsForm;

implementation

uses Main,Clipbrd;

{$R *.dfm}

const cMarketIgnoreInd: array [miNormal..miLast] of string = ('','●','','','','');
const cMarketFavInd: array [miNormal..miLast] of string = ('','','','●','●●','');

procedure TMarketsForm.OnEDDataUpdate;
begin
  UpdateItems;
end;

procedure TMarketsForm.MarketsCheckClick(Sender: TObject);
begin
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

procedure TMarketsForm.FormCreate(Sender: TObject);
begin
  SortColumn := 3;
  SortAscending := False;
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
      item.SubItems.Add(cd.LastUpdate);
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
      item.SubItems.Add(m.LastUpdate);
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
  if action = 4 then
  begin
    if DataSrc.GetMarketLevel(mid) = miIgnore then
      DataSrc.SetMarketLevel(mid,miNormal)
    else
      DataSrc.SetMarketLevel(mid,miIgnore);
    ListView.Selected.SubItems[3] :=
      cMarketIgnoreInd[DataSrc.GetMarketLevel(mid)];
    ListView.Selected.SubItems[4] := '';
  end
  else
  if action = 5 then
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
    ListView.Selected.SubItems[3] := '';
    ListView.Selected.SubItems[4] := cMarketFavInd[DataSrc.GetMarketLevel(mid)];
  end
  else
  if action = 6 then
  begin
    orgs := DataSrc.MarketComments.Values[mid];
    s := Vcl.Dialogs.InputBox(TBaseMarket(ListView.Selected.Data).StationName, 'Info', orgs);
    if s <> orgs then
    begin
      DataSrc.UpdateMarketComment(mid,s);
      ListView.Selected.SubItems[5] := s;
    end;
  end
  else
  if action = 2 then
  begin
    if TBaseMarket(ListView.Selected.Data) is TConstructionDepot then
      EDCDForm.SetDepot(mid,true);
  end
  else
  begin
    if TBaseMarket(ListView.Selected.Data) is TConstructionDepot then
      EDCDForm.SetDepot(mid,false);
    if TBaseMarket(ListView.Selected.Data) is TMarket then
      EDCDForm.SetSecondaryMarket(mid);
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
