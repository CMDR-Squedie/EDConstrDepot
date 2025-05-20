unit MarketInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  DataSource, System.JSON;

type
  TMarketInfoForm = class(TForm, IEDDataListener)
    ListView: TListView;
    Panel1: TPanel;
    MarketNameLabel: TLabel;
    MarketEconomyLabel: TLabel;
    LastUpdateLabel: TLabel;
    MarketIDLabel: TLabel;
    procedure ListViewDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCurrentMarket: string;
    procedure Update;
  public
    { Public declarations }
    procedure SetMarket(m: TMarket);
    procedure ApplySettings;
    procedure OnEDDataUpdate;
  end;

var
  MarketInfoForm: TMarketInfoForm;

implementation

{$R *.dfm}

uses Markets, Main, Settings;

procedure TMarketInfoForm.FormCreate(Sender: TObject);
begin
  DataSrc.AddListener(self);
  ApplySettings;
end;

procedure TMarketInfoForm.ListViewDblClick(Sender: TObject);
begin
  if ListView.Selected = nil then Exit;
  MarketsForm.FilterEdit.Text := LowerCase(ListView.Selected.Caption);
  if MarketsForm.Visible then
    MarketsForm.UpdateItems
  else
    MarketsForm.Show;
end;

procedure TMarketInfoForm.OnEDDataUpdate;
begin
  if Visible then Update;
end;

procedure TMarketInfoForm.SetMarket(m: TMarket);
begin
  FCurrentMarket := m.MarketId;
  Update;
end;

procedure TMarketInfoForm.Update;
var  j: TJSONObject;
     jarr: TJSONArray;
     i: Integer;
     s,normItem: string;
     item: TListItem;
     group: TListGroup;
     sl: TStringList;
     p,q,mean: Integer;
     m: TMarket;
begin
  ListView.Items.Clear;

  if FCurrentMarket = '' then Exit;

  m := DataSrc.MarketFromId(FCurrentMarket);
  if m = nil then Exit;
  

  MarketNameLabel.Caption := m.StationName + '/' + m.StarSystem + ' (' + m.StationType +')';
  MarketEconomyLabel.Caption := m.Economies;
  LastUpdateLabel.Caption := 'Last Update: ' + Copy(m.LastUpdate,1,10) + ' ' + Copy(m.LastUpdate,12,8);
  MarketIDLabel.Caption := '#' + m. MarketID;


  sl := TStringList.Create;
  sl.Sorted := True;
  sl.Duplicates := dupIgnore;
  for i := 0 to DataSrc.ItemCategories.Count - 1 do
    sl.Add(DataSrc.ItemCategories.ValueFromIndex[i]);
  for i := 0 to sl.Count - 1 do
  begin
    group := ListView.Groups.Add;
    group.Header := sl[i];
    group.GroupID := i;
  end;

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

        item := ListView.Items.Add;
        item.Caption := jarr.Items[i].GetValue<string>('Name_Localised');
        item.SubItems.Add(Format('%.0n', [double(q)]));
        s := jarr.Items[i].GetValue<string>('SellPrice');
        p := StrToInt(s);
        item.SubItems.Add(Format('%.0n', [double(p)]));
        mean := StrToInt(jarr.Items[i].GetValue<string>('MeanPrice'));
        s := IntToStr((100*(p-mean) div mean)) + '%';
        if p > mean then s := '+' + s;
        item.SubItems.Add(s);
        item.GroupID := sl.IndexOf(jarr.Items[i].GetValue<string>('Category_Localised'));
      end;
    finally
      ListView.Items.EndUpdate;
      j.Free;
    end;
  except
  end;
  for i := 0 to ListView.Columns.Count - 1 do
  begin
     ListView.Column[i].Width := -2;
  end;
  sl.Free;
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
      Color := $484848;
      Font.Color := clr;
    end;
  end;

end;

end.
