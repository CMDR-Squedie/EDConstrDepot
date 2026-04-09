unit TradeRoutes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, System.Types,
  System.StrUtils, System.JSON, DataSource, System.Generics.Collections, System.IniFiles;

type
  TTradeRoutesForm = class(TForm)
    ListView: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    FilterEdit: TComboBox;
    ClearFilterButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ClearFilterButtonClick(Sender: TObject);
    procedure FilterEditChange(Sender: TObject);
  private
    { Private declarations }
    FCurrentCType: TConstructionType;
    FConstructionType: TConstructionType;
    procedure UpdateItems;
  public
    { Public declarations }
    procedure ApplySettings;
  end;

var
  TradeRoutesForm: TTradeRoutesForm;

implementation

{$R *.dfm}

uses Settings, Main, Clipbrd, Markets;

procedure TTradeRoutesForm.ClearFilterButtonClick(Sender: TObject);
begin
  FilterEdit.Text := '';
  UpdateItems;
end;

procedure TTradeRoutesForm.FilterEditChange(Sender: TObject);
begin
  UpdateItems;
end;

procedure TTradeRoutesForm.FormCreate(Sender: TObject);
begin
  ApplySettings;
  ListView.Items.Clear;
end;

procedure TTradeRoutesForm.FormShow(Sender: TObject);
var sl: TStringList;
begin
  sl := TStringList.Create;
  DataSrc.GetUniqueGroups(sl);
  FilterEdit.Items.Assign(sl);
  FilterEdit.Items.Insert(0,'');
  sl.Free;

  UpdateItems;
end;

procedure TTradeRoutesForm.ListViewDblClick(Sender: TObject);
begin
  if ListView.Selected = nil then Exit;
end;

procedure TTradeRoutesForm.UpdateItems;
var  js: TJSONObject;
     jarr: TJSONArray;
     i,j: Integer;
     s,normItem,name,fs: string;
     sl,row: TStringList;
     sprices,bprices: THashedStringList;
     q,p,idx,bp,sp: Integer;
     m: TMarket;
     colSz: array [0..100] of Integer;
     colMaxLen: array [0..100] of Integer;
     colMaxTxt: array [0..100] of string;

  procedure addRow;
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

begin
  ListView.Items.Clear;

  for i := 0 to ListView.Columns.Count - 1 do
  begin
    colMaxLen[i] := Length(ListView.Columns[i].Caption);
    colMaxTxt[i] := ListView.Columns[i].Caption;
  end;

  sl := TStringList.Create;
  row := TStringList.Create;

  fs := LowerCase(FilterEdit.Text);

  sprices := THashedStringList.Create;
  bprices := THashedStringList.Create;

  for i := 0 to DataSrc.RecentMarkets.Count - 1 do
  begin
    m := TMarket(DataSrc.RecentMarkets.Objects[i]);
    if m.Status = '' then  continue;
    if m.GetSys = nil then continue;
    if m.StationType = 'FleetCarrier' then continue;
    if m.LPads <= 0 then continue;
    if not m.GetSys.IsOwnColony then continue;
    if fs <> '' then
      if Pos(fs,LowerCase(m.GetSys.TaskGroup)) <= 0  then continue;



    js := TJSONObject.ParseJSONValue(m.Status) as TJSONObject;
    try
      jarr := js.GetValue<TJSONArray>('Items');
      for j := 0 to jarr.Count - 1 do
      begin
        name := LowerCase(jarr.Items[j].GetValue<string>('Name_Localised'));
        s := jarr.Items[j].GetValue<string>('Stock');
        q := StrToInt(s);
        if q > 0 then
        begin
          p := StrToIntDef(jarr.Items[j].GetValue<string>('BuyPrice'),0);
          s := sprices.Values[name];
          if (p > 0) then
          if (s = '') or (p < StrToIntDef(s,0)) then
          begin
            sprices.Values[name] := p.ToString;
            idx := sprices.IndexOfName(name);
            sprices.Objects[idx] := m;
          end;
        end;
        //else
        begin
          p := StrToIntDef(jarr.Items[j].GetValue<string>('SellPrice'),0);
          s := bprices.Values[name];
          if (p > 0) then
          if (s = '') or (p > StrToIntDef(s,0)) then
          begin
            bprices.Values[name] := p.ToString;
            idx := bprices.IndexOfName(name);
            bprices.Objects[idx] := m;
          end;
        end;
      end;
    except
    end;
  end;

  for i := 0 to DataSrc.ItemNames.Count - 1 do
  begin
    name := DataSrc.ItemNames.Names[i];
    idx := sprices.IndexOfName(name);
    if idx = -1 then continue;

    sp := 0;
    bp := 0;
    addCaption(name);
    if idx >= 0 then
    begin
      m := TMarket(sprices.Objects[idx]);
      addSubItem(m.StationName_full);
      addSubItem(sprices.ValueFromIndex[idx]);
      sp := StrToIntDef(sprices.ValueFromIndex[idx],0)
    end else begin
      addSubItem('?');
      addSubItem('?');
    end;
    idx := bprices.IndexOfName(name);
    if idx >= 0 then
    begin
      m := TMarket(bprices.Objects[idx]);
      addSubItem(m.StationName_full);
      addSubItem(bprices.ValueFromIndex[idx]);
      bp := StrToIntDef(bprices.ValueFromIndex[idx],0)
    end else begin
      addSubItem('?');
      addSubItem('?');
    end;
    addSubItem((bp-sp).ToString);
    addRow;
  end;

end;

procedure TTradeRoutesForm.ApplySettings;
var i,fs: Integer;
    fn: string;
    clr: TColor;
begin

  ShowInTaskBar := Opts.Flags['ShowInTaskbar'];
  if not Opts.Flags['DarkMode'] then
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
  with ListView do
  begin
    Font.Name := Opts['FontName2'];
    Font.Size := Opts.Int['FontSize2'];
  end;

  ApplyWindowOpts(self,'TradeRoutes',true);

end;

end.
