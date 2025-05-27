unit DataSource;


interface

uses Winapi.Windows, Winapi.Messages, Winapi.PsAPI, System.Classes, System.SysUtils, System.JSON, System.IOUtils, Settings,
  Vcl.ExtCtrls,Vcl.Dialogs;

type IEDDataListener = interface
  ['{C506D770-04B5-408D-99A0-261AC008D422}']
  procedure OnEDDataUpdate;
end;

type TMarketLevel = (
  miNormal = 0,
  miIgnore = 1,
  miForget = 2, //not used; 'forget market' removes all market data
  miFavorite = 3,
  miPriority = 4, //favorite Tier 2
  miLast
);

type TStock = class(TStringList)
    procedure SetQty(const Name: string; v: Integer);
    function GetQty(const Name: string): Integer;
  public
    property Qty[const Name: string]: Integer read GetQty write SetQty; default;
end;

type TBaseMarket = class
  MarketID: string;
  StationName: string;
  StationType: string;
  StarSystem: string;
  LastUpdate: string;
  LastDock: string;
  Status: string;
  Stock: TStock;
  DistFromStar: Integer;
  function FullName: string;
  procedure Clear;
  constructor Create;
  destructor Destroy;
end;

type TMarket = class (TBaseMarket)
  Economies: string;
  Snapshot: Boolean;
end;

type TConstructionDepot = class (TBaseMarket)
  Finished: Boolean;
  Simulated: Boolean;
end;

{
type TStarSystem = class
  StarSystem: string;
  SystemAddress: string;
  StarPosX: string;
  StarPosY: string;
  StarPosZ: string;
  SystemSecurity: string;
  Population: string;
  Status: string;
end;
}

//not used
const cDefaultCapacity: Integer = 784;

type TEDDataSource = class (TDataModule)
    UpdTimer: TTimer;
    procedure UpdTimerTimer(Sender: TObject);
  private
    FListeners: array of IEDDataListener;
    FCargo: TStock;
    FFileDates: TStringList;
    FLastConstrTimes: TStringList;
    FItemCategories: TStringList;
    FItemNames: TStringList;
    FRecentMarkets: TStringList;
    FMarketSnapshots: TStringList;
    FConstructions: TStringList;
    FCargoExt: TMarket;
    FSimDepot: TConstructionDepot;
    FMarket: TMarket;
    FMarketComments: TStringList;
    FMarketLevels: TStringList;
    FMarketGroups: TStringList;
    FWorkingDir,FJournalDir: string;
    FMarketJSON,FCargoJSON,FModuleInfoJSON: string;
    FCapacity: Integer;
    FLastJrnlTimeStamps: TStringList;
    FDataChanged: Boolean;
    FLoadCategories: Boolean;
    FLastFC: string;
    FTaskGroup: string;
    procedure SetDataChanged;
    function CheckLoadFromFile(var sl: TStringList; fn: string): Boolean;
    procedure MarketFromJSON(m: TMarket; js: string);
    procedure LoadMarket(fn: string);
    procedure LoadAllMarkets;
    procedure UpdateCargo;
    procedure UpdateMarket;
    procedure UpdateCapacity;    //not used
    procedure UpdateSimDepot;
    procedure UpdateFromJournal(fn: string; jrnl: TStringList);
    procedure NotifyListeners;
    procedure Update;
    procedure SetTaskGroup(s: string);
  public
    property Constructions: TStringList read FConstructions;
    property RecentMarkets: TStringList read FRecentMarkets;
    property MarketSnapshots: TStringList read FMarketSnapshots;
    property LastConstrTimes: TStringList read FLastConstrTimes;
    property MarketComments: TStringList read FMarketComments;
    property MarketLevels: TStringList read FMarketLevels;
    property MarketGroups: TStringList read FMarketGroups;
    property Market: TMarket read FMarket;
    property ItemNames: TStringList read FItemNames;
    property ItemCategories: TStringList read FItemCategories;
    property Cargo: TStock read FCargo;
    property CargoExt: TMarket read FCargoExt;
    property Capacity: Integer read FCapacity;
    property TaskGroup: string read FTaskGroup write SetTaskGroup;
    procedure MarketToSimDepot(mID: string);
    procedure MarketToCargoExt(mID: string);
    procedure CreateMarketSnapshot(mID: string);
    procedure RemoveMarketSnapshot(mID: string);
    function MarketFromID(id: string): TMarket;
    function LastFC: TMarket;
    function DepotFromID(id: string): TConstructionDepot;
    procedure UpdateSecondaryMarket(forcef: Boolean);
    procedure RemoveSecondaryMarket(m: TMarket);
    procedure SetMarketLevel(mID: string; level: TMarketLevel);
    function GetMarketLevel(mID: string): TMarketLevel;
    procedure UpdateMarketComment(mID: string; s: string);
    procedure UpdateMarketGroup(mID: string; s: string; delf: Boolean);
    procedure AddListener(Sender: IEDDataListener);
    procedure RemoveListener(Sender: IEDDataListener);
    procedure GetUniqueGroups(sl: TStringList);
//    property DataChanged: Boolean read FDataChanged;
    procedure Load;
    procedure BeginUpdate;
    procedure EndUpdate;
    constructor Create(Owner: TComponent); override;
end;

procedure __log_except(fname: string;info: string);


var DataSrc: TEDDataSource;

implementation

{$R *.dfm}

uses Main;

procedure __log_except(fname: string;info: string);
begin
  if ExceptObject is Exception then
    if Opts.Flags['Debug'] then
    begin
      System.IOUtils.TFile.AppendAllText(DataSrc.FWorkingDir + 'EDConstrDepot.log',
        DateTimeToStr(Now) + Chr(9) + fname + Chr(9) + info + Chr(9) +
        Exception(ExceptObject).Message + Chr(9) +
        Exception(ExceptObject).StackTrace + Chr(13),
        TEncoding.ASCII);
    end;
end;

function TStock.GetQty(const Name: string): Integer;
begin
  Result := StrToIntDef(Values[Name],0);
end;

procedure TStock.SetQty(const Name: string; v: Integer);
begin
  Values[Name] := IntToStr(v);
end;

procedure TBaseMarket.Clear;
begin
  MarketID := '';
  Status := '';
  LastUpdate := '';
  Stock.Clear;
end;

function TBaseMarket.FullName: string;
begin
  Result := StationName + '/' + StarSystem;
end;

constructor TBaseMarket.Create;
begin
  Stock := TStock.Create;
  DistFromStar := -1;
end;

destructor TBaseMarket.Destroy;
begin
  Stock.Free;
end;


function TEDDataSource.CheckLoadFromFile(var sl: TStringList; fn: string): Boolean;
var fa: Integer;
begin
  Result := False;
  fa := FileAge(fn);
  if fa <= 0  then Exit;
  if FFileDates.Values[fn] <> IntToStr(fa) then
  begin
    sl := TStringList.Create;
    try
      sl.LoadFromFile(fn);
      FFileDates.Values[fn] := IntToStr(fa);
      Result := true;
    except
      __log_except('CheckLoadFromFile',fn);
    end;
  end;
end;


//not used
procedure TEDDataSource.UpdateCapacity;
var j: TJSONObject;
    jarr: TJSONArray;
    sl: TStringList;
    s: string;
    i: Integer;
begin
  if CheckLoadFromFile(sl,FModuleInfoJSON) = false then Exit;
  FCapacity := 0;
  try
    j := TJSONObject.ParseJSONValue(sl.Text) as TJSONObject;
    jarr := j.GetValue<TJSONArray>('Modules');
    for i := 0 to jarr.Count - 1 do
    begin
      s := jarr.Items[i].GetValue<string>('Item');
      if Copy(s,1,18) = 'int_cargorack_size' then
      begin
        s := Copy(s,19,1);
        FCapacity := FCapacity + (1 shl StrToInt(s));
      end;
    end;
    j.Free;
  except
    FCapacity := cDefaultCapacity;
  end;
  sl.Free;
end;

procedure TEDDataSource.UpdateCargo;
var j: TJSONObject;
    jarr: TJSONArray;
    sl: TStringList;
    s: string;
    i: Integer;
begin
  if CheckLoadFromFile(sl,FCargoJSON) = false then Exit;
  FCargo.Clear;
  try
    j := TJSONObject.ParseJSONValue(sl.Text) as TJSONObject;
    try
      jarr := j.GetValue<TJSONArray>('Inventory');
      for i := 0 to jarr.Count - 1 do
      begin
        s := '';
        try s := jarr.Items[i].GetValue<string>('Name_Localised'); except end;
        if s = '' then s := jarr.Items[i].GetValue<string>('Name');
          FCargo.AddPair(LowerCase(s),jarr.Items[i].GetValue<string>('Count'));
      end;
    finally
      j.Free;
    end;
  except
    __log_except('UpdateCargo','');
  end;
  SetDataChanged;
  sl.Free;
end;


procedure TEDDataSource.MarketFromJSON(m: TMarket; js: string);
var  j: TJSONObject;
     jarr: TJSONArray;
     i: Integer;
     s,normItem: string;
begin
  try
    j := TJSONObject.ParseJSONValue(js) as TJSONObject;
    try
      m.MarketID := j.GetValue<string>('MarketID');
      if Pos('.',m.MarketID) > 0 then m.Snapshot := True;

      m.Status := js;
      try
        m.StationName := j.GetValue<string>('StationName');
        if m.Snapshot then
          m.StationName := m.StationName + ' (S)';
        m.StationType := j.GetValue<string>('StationType');
        m.StarSystem := j.GetValue<string>('StarSystem');
        try
          s := j.GetValue<string>('sEconomies'); //snapshots
          if s <> '' then m.Economies := s;
        except end;
        m.LastUpdate := j.GetValue<string>('timestamp');
        m.Stock.Clear;
        jarr := j.GetValue<TJSONArray>('Items');
        for i := 0 to jarr.Count - 1 do
        begin
          s := jarr.Items[i].GetValue<string>('Stock');
          if s > '0' then
           m.Stock.AddPair(LowerCase(jarr.Items[i].GetValue<string>('Name_Localised')), s);

          if m.StationType = 'FleetCarrier' then
          begin
            s := jarr.Items[i].GetValue<string>('Demand');
            if s > '0' then
             m.Stock.AddPair('$' + LowerCase(jarr.Items[i].GetValue<string>('Name_Localised')), s);
          end;

          if FLoadCategories then
          begin
            s := LowerCase(jarr.Items[i].GetValue<string>('Name_Localised'));
            FItemNames.Values[s] := jarr.Items[i].GetValue<string>('Name_Localised');
            FItemCategories.Values[s] := jarr.Items[i].GetValue<string>('Category_Localised');
          end;
        end;
      except
        __log_except('MarketFromJSON',m.MarketID);
      end;
    finally
      j.Free;
    end;
  except
    __log_except('MarketFromJSON','');
  end;
end;

procedure TEDDataSource.UpdateMarket;
var sl: TStringList;
    s: string;
    i: Integer;
begin
  if CheckLoadFromFile(sl,FMarketJSON) = false then Exit;
  FMarket.Clear;
  try
    MarketFromJSON(FMarket,sl.Text);
    UpdateSecondaryMarket(false);
  except
  end;
//  FLoadCategories := false;
  SetDataChanged;
  sl.Free;
end;

procedure TEDDataSource.UpdateSimDepot;
var m: TMarket;
    sl: TStringList;
    s: string;
    i: Integer;
begin
  if FSimDepot.MarketID = '' then Exit;
  m := MarketFromId(FSimDepot.MarketID);
  if m = nil then Exit;
  if FSimDepot.LastUpdate = m.LastUpdate then Exit;
  FSimDepot.Stock.Clear; //temporary updates
  FSimDepot.StationName := m.StationName;
  FSimDepot.StarSystem := m.StarSystem;
  FSimDepot.Status := m.Status;
  FSimDepot.LastUpdate := m.LastUpdate;
  FSimDepot.Stock.Assign(m.Stock);
  SetDataChanged;
end;

procedure TEDDataSource.UpdTimerTimer(Sender: TObject);
begin
  Update;
  if FDataChanged then
    NotifyListeners;
  FDataChanged := False;
end;

procedure TEDDataSource.AddListener(Sender: IEDDataListener);
begin
  SetLength(FListeners,Length(FListeners)+1);
  FListeners[High(FListeners)] := Sender;
end;

procedure TEDDataSource.RemoveListener(Sender: IEDDataListener);
var i: Integer;
begin
  for i := 0 to High(FListeners) do
    if FListeners[i] = Sender then
    begin
      FListeners[i] := FListeners[High(FListeners)];
      SetLength(FListeners, Length(FListeners)-1);
      break;
    end;

end;

var Cnt1,Cnt2: Integer;

procedure TEDDataSource.NotifyListeners;
var i: Integer;
begin
  for i := 0 to High(FListeners) do
  begin
    FListeners[i].OnEDDataUpdate;
  end;
end;
procedure TEDDataSource.UpdateFromJournal(fn: string; jrnl: TStringList);
var j: TJSONObject;
    jarr: TJSONArray;
    js,s,s2,tms,event,mID,entryId: string;
    i,i2,cpos,q: Integer;
    cd: TConstructionDepot;
    m: TMarket;

    function DepotForMarketId(mID: string): TConstructionDepot;
    var midx: Integer;
    begin
      Result := nil;
      midx := FConstructions.IndexOf(mID);
      if midx < 0 then
      begin
        Result := TConstructionDepot.Create;
        Result.MarketID := mID;
        Result.StationName := '#' + mID;
        midx := FConstructions.AddObject(mID,Result);
        if FTaskGroup <> '' then
          UpdateMarketGroup(mID,FTaskGroup,false);
      end;
      Result := TConstructionDepot(FConstructions.Objects[midx]);
    end;

    function MarketForMarketId(mID: string): TMarket;
    var midx: Integer;
    begin
      Result := nil;
      midx := FRecentMarkets.IndexOf(mID);
      if midx < 0 then
      begin
        Result := TMarket.Create;
        Result.MarketID := mID;
        Result.StationName := '#' + mID;
        midx := FRecentMarkets.AddObject(mID,Result);
        if FTaskGroup <> '' then
          UpdateMarketGroup(mID,FTaskGroup,false);
      end;
      Result := TMarket(FRecentMarkets.Objects[midx]);
    end;

    function GetEvent(js: string): string;
    var cpos: Integer;
        s: string;
    begin
      cpos := Pos('"event":"',js);
      s := Copy(js,cpos+9,100);
      Result := Copy(s,1,Pos('"',s)-1);
    end;

begin
  for i := 0 to jrnl.Count - 1 do
  begin
    j := nil;
    try

      try
        js := jrnl[i];
        //get event "manually" to skip irrelevant entries and speed up JSON processing
        s := GetEvent(js);

        //automatic ColonisationConstructionDepot event every 15s
        if s = 'ColonisationConstructionDepot' then
          if i < jrnl.Count - 1 then
            if GetEvent(jrnl[i+1]) = 'ColonisationConstructionDepot' then
              continue;

        if (s<>'Loadout') and
           (s<>'Docked') and
           (s<>'ColonisationConstructionDepot') and

//fleet carrier names
          (s<>'SupercruiseDestinationDrop') and

//updates to all markets
           (s<>'MarketBuy') and
//updates to fleet carriers only
           (s<>'MarketSell') and
           (s<>'CarrierTradeOrder') and
           (s<>'CargoTransfer') and
//star system info
           (s<>'FSDJump')

//ModuleStore/ModuleRetrieve - to supplement Loadout event?

            then continue;
        event := s;

        j := TJSONObject.ParseJSONValue(jrnl[i]) as TJSONObject;
        tms := j.GetValue<string>('timestamp');
        //line index should be enough to track new events, tms is added to be 100% sure...
        entryId := tms + '.' + IntToStr(i).PadLeft(6);
        if entryId <= FLastJrnlTimeStamps.Values[fn] then continue;

//        event := j.GetValue<string>('event');
        if event = 'Loadout' then
          FCapacity := j.GetValue<Integer>('CargoCapacity');

        if event = 'FSDJump' then
        begin
{
          s := '';
          try s := j.GetValue<string>('SystemAddress'); except end;
          sys := SystemFromId(s);
          sys.Status := js;
          sys.Ready := False;
          //no further processing here
}
          continue;
        end;

        mID := '';
        try mID := j.GetValue<string>('MarketID'); except end;
        if mID = '' then
          try mID := j.GetValue<string>('CarrierID'); except end;
        if (mID = '') and (event = 'CargoTransfer') then
          mID := FLastFC;
        if mID = '' then continue;

        if event = 'SupercruiseDestinationDrop' then
        begin
          m := MarketFromId(mID);
          if (m <> nil) and (m.StationType = 'FleetCarrier') then
          begin
            s := j.GetValue<string>('Type');
            if s <> '' then
            begin
              m.StationName := s;
              if FSimDepot.MarketID = mID then
                FSimDepot.StationName := m.StationName;
            end;
          end;
        end;

        if event = 'Docked' then
        begin
          s := j.GetValue<string>('StationType');
          if s = 'FleetCarrier' then FLastFC := mID;
          s2 := j.GetValue<string>('StationName');
          if (Pos('Construction',s) > 0) or (Pos('ColonisationShip',s2) > 0) then
          begin
            cd := DepotForMarketId(mID);
            s := '';
            try s := j.GetValue<string>('StationName_Localised'); except end;
            if s = '' then s := j.GetValue<string>('StationName');
            cpos := Pos(': ',s);
            if cpos > 0 then
              s := Copy(s,cpos+2,200);
            cpos := Pos('_ColonisationShip; ',s);
            if cpos > 0 then
              s := Copy(s,cpos+19,200) + ' (Primary Port)';
            cd.StationName := s;
            cd.StarSystem := j.GetValue<string>('StarSystem');
            try
              cd.DistFromStar := Trunc(j.GetValue<single>('DistFromStarLS')); 
            except end;
            cd.LastDock := tms;
            cd.LastUpdate := tms;
          end
          else
          begin
            try
              m := MarketForMarketId(mID);
//              m := MarketFromId(mID);

              if m <> nil then
              begin


                if (m.Status = '') or (tms > m.LastUpdate) then //markets with no stored data
                begin
                  m.StationType := j.GetValue<string>('StationType');
                  m.StarSystem := j.GetValue<string>('StarSystem');
                  s := '';
                  try s := j.GetValue<string>('StationName_Localised'); except end;
                  if s = '' then s := j.GetValue<string>('StationName');
                  m.StationName := s;
                end;

                try
                  m.DistFromStar := Trunc(j.GetValue<single>('DistFromStarLS'));
                except end;
                m.LastDock := tms;
                m.Economies := '';
                jarr := j.GetValue<TJSONArray>('StationEconomies');
                for i2 := 0 to jarr.Count - 1 do
                begin
                  m.Economies := m.Economies +
                    Copy(jarr.Items[i2].GetValue<string>('Name_Localised'),1,4) + ' ' +
                    Copy(jarr.Items[i2].GetValue<string>('Proportion'),1,4) + '; ';
                end;
              end;
            except

            end;
          end;
        end;

        if event = 'ColonisationConstructionDepot' then
        begin
          cd := DepotForMarketId(mID);
          if not cd.Finished then
          begin
            cd.Status := jrnl[i];
            cd.LastUpdate := tms;
            s := j.GetValue<string>('ConstructionComplete');
            if s = 'true' then
            begin
              cd.Finished := true;
              if FLastConstrTimes.Values[cd.StarSystem] < tms  then
                FLastConstrTimes.Values[cd.StarSystem] := tms;
            end;
          end;
        end;

        if (event = 'MarketBuy') or (event = 'MarketSell') then
        begin
          m := MarketFromId(mID);
          if (event = 'MarketSell') and (m.StationType <> 'FleetCarrier') then continue;
          if (m <> nil) and (m.LastUpdate < tms) then
          begin
            s := '';
            try s := j.GetValue<string>('Type_Localised'); except end;
            if s = '' then
              s := j.GetValue<string>('Type');
            s := LowerCase(s);
            q := StrToInt(j.GetValue<string>('Count'));
            if event = 'MarketBuy' then
              m.Stock.Qty[s] := m.Stock.Qty[s] - q
            else
              m.Stock.Qty['$' + s] := m.Stock.Qty['$' + s] - q;
            m.LastUpdate := tms;

            if FMarket.MarketID = mID then
            begin
              FMarket.Stock.Assign(m.Stock);
              FMarket.LastUpdate := tms;
            end;


//            if FCargoExt.MarketID = mID then
//              FCargoExt.Stock.Qty[s] := FCargoExt.Stock.Qty[s] + q;

          end;
        end;

        if event = 'CarrierTradeOrder' then
        begin
          s := '';
          try s := j.GetValue<string>('Commodity_Localised'); except end;
          if s = '' then
            s := j.GetValue<string>('Commodity');
          s := LowerCase(s);
          s2 := '';
          try s2 := j.GetValue<string>('CancelTrade'); except end;

          m := MarketFromId(mID);
          if (m <> nil) and (m.LastUpdate < tms) then
          begin
            m.LastUpdate := tms;
            if s2 = 'true' then
            begin
              m.Stock.Qty[s] := 0;
              m.Stock.Qty['$' + s] := 0;
            end
            else
            begin
              try
                q := StrToInt(j.GetValue<string>('SaleOrder'));
                m.Stock.Qty[s] := q;
              except
              end;
              try
                q := StrToInt(j.GetValue<string>('PurchaseOrder'));
                m.Stock.Qty['$' + s] := q;
              except
              end;
            end;
          end;

        end;

        if event = 'CargoTransfer' then
        begin
          m := MarketFromId(mID);
          if (m <> nil) and (m.LastUpdate < tms) then
          begin

            jarr := j.GetValue<TJSONArray>('Transfers');
            for i2 := 0 to jarr.Count - 1 do
            begin
              s := '';
              try s := jarr.Items[i2].GetValue<string>('Type_Localised'); except end;
              if s = '' then
                s := jarr.Items[i2].GetValue<string>('Type');
              s := LowerCase(s);
              try
                q := StrToInt(jarr.Items[i2].GetValue<string>('Count'));
                if jarr.Items[i2].GetValue<string>('Direction') = 'toship' then
                  q := -q;
                m.Stock.Qty[s] := m.Stock.Qty[s] + q;
              except
              end;
            end;
          end;
        end;


        FLastJrnlTimeStamps.Values[fn] := entryId;
        SetDataChanged;
      except
        __log_except('UpdateFromJournal',tms);
      end;

    finally
      j.Free;
    end;

  end;

end;

function TEDDataSource.LastFC;
begin
  LastFC := MarketFromId(FLastFC);
end;

procedure TEDDataSource.LoadMarket(fn: string);
var sl: TStringList;
    m: TMarket;
    idx,fa: Integer;
begin
  sl := TStringList.Create;
  try
    fa := FileAge(fn);
    if FFileDates.Values[fn] <> IntToStr(fa) then
    begin
      try sl.LoadFromFile(fn); except end;
      m := TMarket.Create;
      try
        MarketFromJSON(m,sl.Text);
      except
         m.Free;
         Exit;
      end;
      if (m.MarketID <> '') and (m.Status <> '') then
      begin
        if not m.Snapshot then
        begin
          idx := FRecentMarkets.IndexOf(m.MarketID);
          if idx = -1 then
            FRecentMarkets.AddObject(m.MarketID,m)
          else
          begin
            with TMarket(FRecentMarkets.Objects[idx]) do
            begin
              Status := m.Status;
              LastUpdate := m.LastUpdate;
              Stock.Assign(m.Stock);
            end;
            m.Free;
          end;
        end
        else
        begin
          FMarketSnapshots.AddObject(m.MarketID,m);
        end;
      end;
      FFileDates.Values[fn] := IntToStr(fa);
    end;
  finally
    sl.Free;
  end;
end;

procedure TEDDataSource.UpdateSecondaryMarket(forcef: Boolean);
var fn: string;
begin
//  if  FRecentMarkets.IndexOf(FMarket.MarketID) >= 0 then Exit;
  fn := FWorkingDir + 'markets\' + FMarket.MarketID + '.json';
  if forcef or FileExists(fn) or Opts.Flags['TrackMarkets'] then
  begin
    CopyFile(PChar(FMarketJSON),PChar(fn),false);
    LoadMarket(fn);
    SetDataChanged;
  end;
end;

procedure TEDDataSource.RemoveSecondaryMarket(m: TMarket);
var fn: string;
    idx: Integer;
begin
  idx := FRecentMarkets.IndexOf(m.MarketID);
  if idx < 0 then Exit;
  fn := FWorkingDir + 'markets\' + m.MarketID + '.json';
  DeleteFile(PChar(fn));
  FFileDates.Values[fn] := '';
  FRecentMarkets.Objects[idx].Free;
  FRecentMarkets.Delete(idx);
  SetDataChanged;
end;

procedure TEDDataSource.SetMarketLevel(mID: string; level: TMarketLevel);
var fn: string;
    idx: Integer;
begin
  FMarketLevels.Values[mID] := IntToStr(Ord(level));
  try FMarketLevels.SaveToFile(FWorkingDir + 'market_level.txt'); except end;
//  SetDataChanged;
  NotifyListeners;
end;

function TEDDataSource.GetMarketLevel(mID: string): TMarketLevel;
var fn: string;
    idx: Integer;
begin
  Result := TMarketLevel(StrToIntDef(FMarketLevels.Values[mID],Ord(miNormal)));
end;

procedure TEDDataSource.LoadAllMarkets;
var sl: TStringList;
    s,s2,fn: string;
    i,res: Integer;
    fa: DWord;
    srec: TSearchRec;
    m: TMarket;
begin
  res := FindFirst(FWorkingDir + 'markets\*.json', faAnyFile, srec);
  while res = 0 do
  begin
    LoadMarket(FWorkingDir + 'markets\' + srec.Name);
    res := FindNext(srec);
  end;
  FindClose(srec);

  FLoadCategories := false;
end;

procedure TEDDataSource.Update;
var sl: TStringList;
    fn: string;
    res: Integer;
    fa: DWord;
    srec: TSearchRec;
    tc: DWORD;

    procedure _share_LoadFromFile(sl: TStringList; const FileName: string);
    var s: TStream;
    begin
      s := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
      try
        sl.LoadFromStream(s, nil);
      finally
        s.Free;
      end;
    end;

begin

  tc := GetTickCount;

  sl := TStringList.Create;

//  FDataChanged := False;

  try

//  UpdateCapacity;
  UpdateCargo;
  UpdateMarket;

  fn := '';
  res := FindFirst(FJournalDir + 'journal.*.log', faAnyFile, srec);
  while res = 0 do
  begin
    if LowerCase(srec.Name) >= ('journal.' + Opts['JournalStart']) then
    begin
      fa := srec.FindData.ftLastWriteTime.dwLowDateTime;  //optimistically assuming it changes :)
      if FFileDates.Values[srec.Name] <> IntToStr(fa) then
      begin
        sl.Clear;
        try _share_LoadFromFile(sl,FJournalDir + srec.Name); except end;
        UpdateFromJournal(srec.Name,sl);
        FFileDates.Values[srec.Name] := IntToStr(fa);
//        SetDataChanged;
      end;
    end;
    res := FindNext(srec);
  end;
  FindClose(srec);

  UpdateSimDepot;


  finally
    sl.Free;
  end;

//  ShowMessage(IntToStr(GetTickCount-tc));
end;

procedure TEDDataSource.Load;
begin
  DataSrc.Update;
  //automatic task group for new stations - after historical data is loaded
  FTaskGroup := Opts['SelectedTaskGroup'];
end;

procedure TEDDataSource.BeginUpdate;
begin
end;

procedure TEDDataSource.EndUpdate;
begin
  NotifyListeners;
end;

procedure TEDDataSource.MarketToSimDepot(mID: string);
var midx: Integer;
begin
  if FSimDepot.MarketID <> '' then
  begin
    midx := FConstructions.IndexOf(FSimDepot.MarketID);
    if midx >= 0 then
      FConstructions.Delete(midx);
    FSimDepot.Clear;
  end;
  FSimDepot.MarketID := mID;
  UpdateSimDepot;
  FConstructions.AddObject(FSimDepot.MarketID,FSimDepot);
  SetDataChanged;
end;

procedure TEDDataSource.MarketToCargoExt(mID: string);
begin
  FCargoExt := MarketFromId(mID);
  Opts['CargoExt'] := mID;
  SetDataChanged;
end;

procedure TEDDataSource.CreateMarketSnapshot(mID: string);
var sID,fn,fn2,s: string;
    snr,p: Integer;
    sl: TStringList;
    m: TMarket;
begin
  m := MarketFromId(mID);
  if m = nil then Exit;
  if m.Snapshot then Exit;
  fn := FWorkingDir + 'markets\' + mID + '.json';
  snr := 1;
  while snr < 100 do
  begin
    sID := mID + '.' + IntToStr(snr);
    if FMarketSnapshots.IndexOf(sID) = -1 then break;
    snr := snr + 1;
  end;
  if FileExists(fn) then
  begin
    fn2 := FWorkingDir + 'markets\' + sID + '_snapshot.json';
    sl := TStringList.Create;
    try
      sl.LoadFromFile(fn);
      s := sl.Text;
      p := Pos(', "StationName"',s);
      if p = 0 then raise Exception.Create('Unable to modify MarketID');
      s := Copy(s,1,p-1) + '.' + IntToStr(snr) +
        ', "sEconomies":"' + m.Economies + '"' +
        Copy(s,p,Length(s));
      sl.Text := s;
      sl.SaveToFile(fn2);
    finally
      sl.Free;
    end;
    LoadMarket(fn2);
    SetDataChanged;
  end;
end;

procedure TEDDataSource.RemoveMarketSnapshot(mID: string);
var fn: string;
    idx: Integer;
begin
  idx := FMarketSnapshots.IndexOf(mID);
  if idx < 0 then Exit;
  fn := FWorkingDir + 'markets\' + mID + '_snapshot.json';
  DeleteFile(PChar(fn));
  FFileDates.Values[fn] := '';
  FMarketSnapshots.Objects[idx].Free;
  FMarketSnapshots.Delete(idx);
  SetDataChanged;
end;

function TEDDataSource.MarketFromID(id: string): TMarket;
var idx: Integer;
begin
  Result := nil;
  idx := FRecentMarkets.IndexOf(id);
  if idx >=0 then
    Result := TMarket(FRecentMarkets.Objects[idx])
  else
  begin
    idx := FMarketSnapshots.IndexOf(id);
    if idx >=0 then
      Result := TMarket(FMarketSnapshots.Objects[idx]);
  end;
end;

function TEDDataSource.DepotFromID(id: string): TConstructionDepot;
var idx: Integer;
begin
  Result := nil;
  idx := FConstructions.IndexOf(id);
  if idx >=0 then
    Result := TConstructionDepot(FConstructions.Objects[idx]);
end;

procedure TEDDataSource.SetDataChanged;
begin
  if not FDataChanged then
  begin
    FDataChanged := true;
    //nothing else for now
  end;
end;

procedure TEDDataSource.UpdateMarketComment(mID: string; s: string);
begin
  FMarketComments.Values[mID] := s;
  try FMarketComments.SaveToFile(FWorkingDir + 'market_info.txt'); except end;
//  SetDataChanged;
  NotifyListeners;
end;

procedure TEDDataSource.UpdateMarketGroup(mID: string; s: string; delf: Boolean);
begin
  FMarketGroups.Values[mID] := s;
  try FMarketGroups.SaveToFile(FWorkingDir + 'market_groups.txt'); except end;
//  SetDataChanged;
//  NotifyListeners;
end;

procedure TEDDataSource.GetUniqueGroups(sl: TStringList);
var i: Integer;
    s: string;
begin
  sl.Clear;
  sl.Sorted := True;
  sl.Duplicates := dupIgnore;
  for i := 0 to FMarketGroups.Count - 1 do
  begin
    s := FMarketGroups.ValueFromIndex[i];
    if s <> '' then sl.Add(s);
  end;
  if FTaskGroup <> '' then
    sl.Add(FTaskGroup);
end;

procedure TEDDataSource.SetTaskGroup(s: string);
begin
  FTaskGroup := s;
  Opts['SelectedTaskGroup'] := s;
  Opts.Save;
  NotifyListeners;
end;

constructor TEDDataSource.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FWorkingDir := GetCurrentDir + '\';

  try CreateDir(FWorkingDir + 'markets'); except end;

  FMarket := TMarket.Create;
  FCargo := TStock.Create;
  FSimDepot := TConstructionDepot.Create;
  FSimDepot.Simulated := True;
  FFileDates := TStringList.Create;
  FLastConstrTimes := TStringList.Create;
  FConstructions := TStringList.Create;
  FRecentMarkets := TStringList.Create;
  FMarketSnapshots := TStringList.Create;
  FMarketComments := TStringList.Create;
  FMarketLevels := TStringList.Create;
  FMarketGroups := TStringList.Create;
  FItemCategories := TStringList.Create;
  FItemNames := TStringList.Create;
  FLastJrnlTimeStamps := TStringList.Create;
  FDataChanged := false;

  FLoadCategories := true; //categories are updated once from all market data

  LoadAllMarkets;
  if Opts['SimDepot'] <> '' then
    MarketToSimDepot(Opts['SimDepot']);
  if Opts['CargoExt'] <> '' then
    MarketToCargoExt(Opts['CargoExt']);

  FJournalDir := System.SysUtils.GetEnvironmentVariable('USERPROFILE') +
       '\Saved Games\Frontier Developments\Elite Dangerous\';
  if Opts['JournalDir'] <> '' then
    FJournalDir := Opts['JournalDir'];
//  SetCurrentDir(FJournalDir);
//  FJournalDir :=  GetCurrentDir + '\';

  FMarketJSON := FJournalDir + 'market.json';
  FCargoJSON := FJournalDir + 'cargo.json';
  FModuleInfoJSON := FJournalDir + 'modulesinfo.json';

  //todo: combine into one file and add attributes to TMarket
  try FMarketComments.LoadFromFile(FWorkingDir + 'market_info.txt') except end;
  try FMarketLevels.LoadFromFile(FWorkingDir + 'market_level.txt') except end;
  try FMarketGroups.LoadFromFile(FWorkingDir + 'market_groups.txt') except end;


//  UpdTimer.Enabled := True;
end;


end.
