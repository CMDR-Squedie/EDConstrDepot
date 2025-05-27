unit MarketInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  DataSource, System.JSON, System.StrUtils, Vcl.Menus;

type
  TMarketInfoForm = class(TForm, IEDDataListener)
    ListView: TListView;
    Panel1: TPanel;
    MarketNameLabel: TLabel;
    MarketEconomyLabel: TLabel;
    LastUpdateLabel: TLabel;
    MarketIDLabel: TLabel;
    CloseComparisonButton: TButton;
    VertDivider2: TShape;
    VertDivider1: TShape;
    PopupMenu: TPopupMenu;
    CopyMenuItem: TMenuItem;
    N1: TMenuItem;
    CompareSelectedMenuItem: TMenuItem;
    RemoveAllFiltersMenuItem: TMenuItem;
    CompareAllMenuItem: TMenuItem;
    ShowDifferencesSubMenu: TMenuItem;
    N2: TMenuItem;
    ShowDiffIgnoreStockLevelMenuItem: TMenuItem;
    ShowDiffIgnoreStockLevel2MenuItem: TMenuItem;
    procedure ListViewDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CloseComparisonButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CompareSelectedMenuItemClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure RemoveAllFiltersMenuItemClick(Sender: TObject);
    procedure CompareAllMenuItemClick(Sender: TObject);
    procedure CopyMenuItemClick(Sender: TObject);
    procedure ShowDifferences1MenuItemClick(Sender: TObject);
  private
    { Private declarations }
    FCurrentMarket: string;
    FCurrentCategory: string;
    FCompareSelected: Boolean;
    FSharedItems: TStringList;
    FSelectedCommodities: TStringList;
    FLastScrollBarPos: Integer;
    procedure Update;
    procedure InternalSetCategory(s: string; sl: TStringList; clearself: Boolean);
    procedure FillCommodities(sl: TStringList);
    procedure SetCategory(s: string;  sl: TStringList; clearself: Boolean);
  public
    { Public declarations }
    Comparing: Boolean;
    procedure SetMarket(m: TMarket);
    procedure ApplySettings;
    procedure OnEDDataUpdate;
    procedure CloseComparison;
    procedure SyncComparison;
  end;

var
  MarketInfoForm: TMarketInfoForm;

implementation

{$R *.dfm}

uses Markets, Main, Settings;

const cSelectedMark: string = '●'; //●

procedure TMarketInfoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if self <> MarketInfoForm then
  begin
    Action := caFree;
    DataSrc.RemoveListener(self);
    FSelectedCommodities.Free;
    FSharedItems.Free;
  end;
end;

procedure TMarketInfoForm.FormCreate(Sender: TObject);
begin
  FSelectedCommodities := TStringList.Create;
  FSharedItems := TStringList.Create;
  DataSrc.AddListener(self);
  ApplySettings;
end;

procedure TMarketInfoForm.ListViewDblClick(Sender: TObject);
var i,j: Integer;
    sel,s: string;
    pt: TPoint;
    r: TRect;
begin
  pt := Mouse.CursorPos;
  pt := ListView.ScreenToClient(pt);

  for i := 0 to ListView.Groups.Count - 1 do
  begin
    if ListView.Groups[i].Subtitle = '' then //non-empty, see below
      if ListView_GetGroupRect(ListView.Handle,i,LVGGR_HEADER,r) = 1 then
        if PtInRect(r,pt) then
        begin
          s := ListView.Groups[i].Header;
          if FCurrentCategory = s then s := '';
          SetCategory(s,nil,false);
          Exit;
        end;
  end;

  if ListView.Selected = nil then
  begin
    if FCurrentCategory <> '' then
      SetCategory('',nil,false);
    Exit;
  end;

  if not Comparing then
  begin
    MarketsForm.MarketsCheck.Checked := True;
    MarketsForm.FilterEdit.Text := LowerCase(ListView.Selected.Caption);
    if MarketsForm.Visible then
      MarketsForm.UpdateItems
    else
      MarketsForm.Show;
  end
  else
  begin
    sel := ListView.Selected.Caption;
    if LeftStr(sel,Length(cSelectedMark)) = cSelectedMark then Exit;
    for i := Application.ComponentCount - 1 downto 0 do
      if Application.Components[i] is TMarketInfoForm then
        if TMarketInfoForm(Application.Components[i]).Comparing then
          with TMarketInfoForm(Application.Components[i]) do
          begin
            FSelectedCommodities.Add(sel);
            for j := 0 to ListView.Items.Count - 1 do
            begin
              if ListView.Items[j].Caption = sel then
//                ListView.Items[j].Caption := cSelectedMark + ListView.Items[j].Caption;
                ListView.Items[j].SubItems[3] := cSelectedMark;
            end;
          end;

  end;
end;

procedure TMarketInfoForm.OnEDDataUpdate;
begin
  if Comparing then Exit;
  if Visible then Update;
end;

procedure TMarketInfoForm.PopupMenuPopup(Sender: TObject);
begin
  CompareSelectedMenuItem.Enabled := FSelectedCommodities.Count > 0;
  CompareSelectedMenuItem.Visible := Comparing;
  CompareSelectedMenuItem.Checked := FCompareSelected;
  CompareAllMenuItem.Visible := Comparing;
  CompareSelectedMenuItem.Checked := FCompareSelected;
  RemoveAllFiltersMenuItem.Visible := Comparing;
end;

procedure TMarketInfoForm.RemoveAllFiltersMenuItemClick(Sender: TObject);
begin
  if Comparing then
    SetCategory('',nil,true);
end;

procedure TMarketInfoForm.SetMarket(m: TMarket);
begin
  FCurrentMarket := m.MarketId;
  FCurrentCategory := '';
  FSelectedCommodities.Clear;
  FSharedItems.Clear;
  Update;
end;

procedure TMarketInfoForm.ShowDifferences1MenuItemClick(Sender: TObject);
var i,j,fcnt,mode: Integer;
    sl,asl: TStringList;
begin
  if not Comparing then Exit;
  sl := TStringList.Create;
  asl := TStringList.Create;

  mode := TMenuItem(Sender).Tag;

  if (FSharedItems.Count > 0) or (FSelectedCommodities.Count > 0) then
    SetCategory('',nil,true);    //remove all filters first


  FillCommodities(asl);


//get commodities not shared by compared markets
  fcnt := 0;  
  for i := Application.ComponentCount - 1 downto 0 do
    if (Application.Components[i] is TMarketInfoForm) then
      if TMarketInfoForm(Application.Components[i]).Comparing then
        with TMarketInfoForm(Application.Components[i]) do
        begin
          for j := 0 to ListView.Items.Count - 1 do
            sl.Values[ListView.Items[j].Caption] := sl.Values[ListView.Items[j].Caption] + '*';
          fcnt := fcnt + 1;    
        end;
        
  for i := sl.Count - 1 downto 0 do
    if Length(sl.ValueFromIndex[i]) <> fcnt then
      sl.Delete(i)
    else
      sl[i] := sl.Names[i];  
      
  for i := Application.ComponentCount - 1 downto 0 do
    if (Application.Components[i] is TMarketInfoForm) then
      if TMarketInfoForm(Application.Components[i]).Comparing then
        with TMarketInfoForm(Application.Components[i]) do
        begin
          if mode = 1 then
          begin
            FCompareSelected := True;
            FSelectedCommodities.Assign(asl);
          end;
          if mode = 2 then
          begin
            FCompareSelected := False;
            FSelectedCommodities.Clear;
          end;
          FSharedItems.Assign(sl);
          Update;
        end;
  sl.Free;
  asl.Free;
end;

procedure TMarketInfoForm.Update;
var  j: TJSONObject;
     jarr: TJSONArray;
     i: Integer;
     s,normItem: string;
     item: TListItem;
     group: TListGroup;
     sl,cmpsl: TStringList;
     p,q,mean,groupid: Integer;
     m: TMarket;
begin
  ListView.Items.Clear;
  ListView.Groups.Clear;

  if FCurrentMarket = '' then Exit;
  
  m := DataSrc.MarketFromId(FCurrentMarket);
  if m = nil then
  begin
    FCurrentMarket := '';
    Close;
    Exit;
  end;

  MarketNameLabel.Caption := m.StationName + '/' + m.StarSystem + ' (' + m.StationType +')';
  MarketEconomyLabel.Caption := m.Economies;
  LastUpdateLabel.Caption := 'Last Update: ' +
    Copy(m.LastUpdate,1,10) + ' ' + Copy(m.LastUpdate,12,8) + ' UTC';
  MarketIDLabel.Caption := '#' + m. MarketID;


  sl := TStringList.Create;
  cmpsl := TStringList.Create;
  cmpsl.Assign(FSelectedCommodities);
  
  if FCurrentCategory <> '' then
    sl.Add(FCurrentCategory)
  else
  begin
    sl.Sorted := True;
    sl.Duplicates := dupIgnore;
    for i := 0 to DataSrc.ItemCategories.Count - 1 do
    begin
      s := DataSrc.ItemCategories.ValueFromIndex[i];
      sl.Add(s);
    end;
  end;
  for i := 0 to sl.Count - 1 do
  begin
    group := ListView.Groups.Add;
    group.Header := sl[i];
    group.GroupID := i;
    group.Subtitle := '(empty)';
  end;

  if m.Status = '' then
  begin
    for i := 0 to m.Stock.Count - 1 do
    begin
      s := m.Stock.Names[i];
      q := m.Stock.Qty[s];
      if q = 0 then continue;
      groupid := sl.IndexOf(DataSrc.ItemCategories.Values[s]);
      if groupid = -1 then continue;

      item := ListView.Items.Add;
      item.Caption := DataSrc.ItemNames.Values[s];
      item.SubItems.Add(Format('%.0n', [double(q)]));
      item.SubItems.Add('?');
      item.SubItems.Add('?');
      item.SubItems.Add('');
      item.GroupID := groupid;
      ListView.Groups[groupid].Subtitle := '';
    end;
  end
  else
  try
    j := TJSONObject.ParseJSONValue(m.Status) as TJSONObject;
    ListView.Items.BeginUpdate;
    try
      jarr := j.GetValue<TJSONArray>('Items');

      for i := 0 to jarr.Count - 1 do
      begin
        s := jarr.Items[i].GetValue<string>('Stock');
        q := StrToInt(s);
        if q = 0 then continue;
        
        groupid := sl.IndexOf(jarr.Items[i].GetValue<string>('Category_Localised'));
        if groupid = -1 then continue;

        s := jarr.Items[i].GetValue<string>('Name_Localised');
        if FCompareSelected then
        begin
          if FSelectedCommodities.IndexOf(s) = -1 then continue;
          cmpsl.Delete(cmpsl.IndexOf(s));
        end;
        if FSharedItems.IndexOf(s) > -1 then continue;

        item := ListView.Items.Add;
        item.Caption := s;
        item.GroupID := groupid;
        ListView.Groups[groupid].Subtitle := '';
       
        item.SubItems.Add(Format('%.0n', [double(q)]));
        s := jarr.Items[i].GetValue<string>('SellPrice');
        p := StrToInt(s);
        item.SubItems.Add(Format('%.0n', [double(p)]));
        mean := StrToInt(jarr.Items[i].GetValue<string>('MeanPrice'));
        s := IntToStr((100*(p-mean) div mean)) + '%';
        if p > mean then s := '+' + s;
        item.SubItems.Add(s);
        s := '';
        if FSelectedCommodities.IndexOf(item.Caption) > -1 then
           s := cSelectedMark;
        item.SubItems.Add(s);
      end;

      if FCompareSelected then
        for i := 0 to cmpsl.Count - 1 do
        begin
          groupid := sl.IndexOf(DataSrc.ItemCategories.Values[LowerCase(cmpsl[i])]);
          if groupid = -1 then continue;
          item := ListView.Items.Add;
          item.Caption := cmpsl[i];
          item.GroupID := groupid;
          ListView.Groups[groupid].Subtitle := '';
          item.SubItems.Add(''); 
          item.SubItems.Add(''); 
          item.SubItems.Add(''); 
          item.SubItems.Add(''); 
        end;

      
    finally
      ListView.Items.EndUpdate;
      j.Free;
    end;
  except
  end;
  for i := 0 to 1 do  //last 3 columns not auto-scaled!
  begin
     ListView.Column[i].Width := -2;
  end;
  sl.Free;
  cmpsl.Free;
end;

procedure TMarketInfoForm.ApplySettings;
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
    with ListView do
    begin
      Color := $6B5E4F; //$484848; $585140
      Font.Color := clr;
    end;
  end;

end;

procedure TMarketInfoForm.CloseComparison;
var i: Integer;
begin
  for i := Application.ComponentCount - 1 downto 0 do
    if Application.Components[i] is TMarketInfoForm then
      if TMarketInfoForm(Application.Components[i]).Comparing then
        TMarketInfoForm(Application.Components[i]).Close;
end;

procedure TMarketInfoForm.InternalSetCategory(s: string;  sl: TStringList; clearself: Boolean);
var i: Integer;
begin
  FCurrentCategory := s;
  if sl <> nil then
  begin
    FSelectedCommodities.Assign(sl);
    FCompareSelected := True;
  end;
  if clearself then
  begin
    FCompareSelected := False;
    FSelectedCommodities.Clear;
    FSharedItems.Clear;
  end;
  Update;
end;

procedure TMarketInfoForm.SetCategory(s: string;  sl: TStringList; clearself: Boolean);
var i: Integer;
begin
  if not Comparing then
    InternalSetCategory(s,sl,clearself)
  else
    for i := Application.ComponentCount - 1 downto 0 do
      if (Application.Components[i] is TMarketInfoForm) then
        if TMarketInfoForm(Application.Components[i]).Comparing then
          TMarketInfoForm(Application.Components[i]).InternalSetCategory(s,sl,clearself);
end;

procedure TMarketInfoForm.CloseComparisonButtonClick(Sender: TObject);
begin
  CloseComparison;
end;

procedure TMarketInfoForm.FillCommodities(sl: TStringList);
var i,j: Integer;
begin
//this routine collects all items from current comparison
//be sure to turn off the filters if you need all items

  sl.Clear;
  sl.Sorted := True;
  sl.Duplicates := dupIgnore;

  for i := Application.ComponentCount - 1 downto 0 do
    if (Application.Components[i] is TMarketInfoForm) then
      if TMarketInfoForm(Application.Components[i]).Comparing then
        with TMarketInfoForm(Application.Components[i]) do
        begin
          for j := 0 to ListView.Items.Count - 1 do
            sl.Add(ListView.Items[j].Caption);
//          FCompareSelected := True;
        end;
end;

procedure TMarketInfoForm.CompareAllMenuItemClick(Sender: TObject);
var i,j: Integer;
    sl: TStringList;
begin
  if not Comparing then Exit;

  sl := TStringList.Create;
  FillCommodities(sl);
  SetCategory('',sl,false);
  sl.Free;
end;

procedure TMarketInfoForm.CompareSelectedMenuItemClick(Sender: TObject);
var i: Integer;
begin
  if not Comparing then Exit;
  if FSelectedCommodities.Count = 0 then Exit;
  for i := Application.ComponentCount - 1 downto 0 do
    if (Application.Components[i] is TMarketInfoForm) then
      if TMarketInfoForm(Application.Components[i]).Comparing then
        with TMarketInfoForm(Application.Components[i]) do
        begin
          FCompareSelected := not FCompareSelected;
          Update;
        end;
end;

procedure TMarketInfoForm.CopyMenuItemClick(Sender: TObject);
begin
;
end;

procedure TMarketInfoForm.SyncComparison;
var i,sy,sy2: Integer; 
    f: TMarketInfoForm;
begin
  if not (Screen.ActiveForm is TMarketInfoForm) then Exit;
  f := TMarketInfoForm(Screen.ActiveForm);
  if not f.Comparing or not f.FCompareSelected then Exit;
  sy := GetScrollPos(f.ListView.Handle,SB_VERT);
  if sy = FLastScrollBarPos then Exit;
  FLastScrollBarPos := sy;
  for i := Application.ComponentCount - 1 downto 0 do
    if (Application.Components[i] is TMarketInfoForm) and (Application.Components[i] <> f) then
      with TMarketInfoForm(Application.Components[i]) do
        if Comparing and FCompareSelected then
        begin
          sy2 := GetScrollPos(ListView.Handle,SB_VERT);
          ListView.Scroll(0,sy-sy2);
        end;
end;

end.
