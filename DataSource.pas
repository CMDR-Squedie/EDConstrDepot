unit DataSource;


interface

uses Winapi.Windows, Winapi.Messages, Winapi.PsAPI, System.Classes, System.SysUtils, System.JSON, System.IOUtils, Settings,
  Vcl.ExtCtrls;

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

type TBaseMarket = class
  MarketID: string;
  StationName: string;
  StationType: string;
  StarSystem: string;
  LastUpdate: string;
  Status: string;
  procedure Clear;
  function FullName: string;
end;

type TStock = class(TStringList)
    procedure SetQty(const Name: string; v: Integer);
    function GetQty(const Name: string): Integer;
  public
    property Qty[const Name: string]: Integer read GetQty write SetQty; default;
end;

type TMarket = class (TBaseMarket)
  Stock: TStock;
  Economies: string;
  procedure Clear;
  constructor Create;
  destructor Destroy;
end;

type TConstructionDepot = class (TBaseMarket)
  Finished: Boolean;
  Simulated: Boolean;
end;


const cDefaultCapacity: Integer = 784;

type TEDDataSource = class (TDataModule)
    UpdTimer: TTimer;
    procedure UpdTimerTimer(Sender: TObject);
  private
    FListeners: array of IEDDataListener;
    FCargo: TStock;
    FFileDates: TStringList;
    FSystemUpdates: TStringList;
    FItemCategories: TStringList;
    FRecentMarkets: TStringList;
    FConstructions: TStringList;
    FCargoExt: TMarket;
    FMarket: TMarket;
    FSimDepot: TConstructionDepot;
    FMarketComments: TStringList;
    FMarketLevels: TStringList;
    FWorkingDir,FJournalDir: string;
    FMarketJSON,FCargoJSON,FCargoExtJSON,FModuleInfoJSON,FSimDepotJSON: string;
    FCapacity: Integer;
    FLastJrnlTimeStamps: TStringList;
    FDataChanged: Boolean;
    FLoadCategories: Boolean;
    procedure SetDataChanged;
    function CheckLoadFromFile(var sl: TStringList; fn: string): Boolean;
    procedure MarketFromJSON(m: TMarket; js: string);
    procedure LoadMarket(fn: string);
    procedure LoadAllMarkets;
    procedure UpdateCargo;
    procedure UpdateCargoExternal;
    procedure UpdateSimDepot;
    procedure UpdateMarket;
    procedure UpdateCapacity;    //not used
    procedure UpdateFromJournal(fn: string; jrnl: TStringList);
    procedure NotifyListeners;
  public
    property Constructions: TStringList read FConstructions;
    property RecentMarkets: TStringList read FRecentMarkets;
    property SystemUpdates: TStringList read FSystemUpdates;
    property SimDepot: TConstructionDepot read FSimDepot;
    property MarketComments: TStringList read FMarketComments;
    property MarketLevels: TStringList read FMarketLevels;
    property Market: TMarket read FMarket;
    property ItemCategories: TStringList read FItemCategories;
    property Cargo: TStock read FCargo;
    property CargoExt: TMarket read FCargoExt;
    property Capacity: Integer read FCapacity;
    procedure MarketToSimDepot;
    procedure MarketToCargoExt;
    function MarketFromID(id: string): TMarket;
    procedure UpdateSecondaryMarket(forcef: Boolean);
    procedure RemoveSecondaryMarket(m: TMarket);
    procedure SetMarketLevel(mID: string; level: TMarketLevel);
    function GetMarketLevel(mID: string): TMarketLevel;
    procedure UpdateMarketComment(mID: string; s: string);
    procedure AddListener(Sender: IEDDataListener);
    procedure RemoveListener(Sender: IEDDataListener);
//    property DataChanged: Boolean read FDataChanged;
    procedure Update; //for forced updates only
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
    if Opts.FLags['Debug'] then
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
end;

function TBaseMarket.FullName: string;
begin
  Result := StationName + '/' + StarSystem;
end;

constructor TMarket.Create;
begin
  Stock := TStock.Create;
end;

destructor TMarket.Destroy;
begin
  Stock.Free;
end;

procedure TMarket.Clear;
begin
  Stock.Clear;
  inherited;
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
      m.Status := js;
      try
        m.StationName := j.GetValue<string>('StationName');
        m.StationType := j.GetValue<string>('StationType');
        m.StarSystem := j.GetValue<string>('StarSystem');
        m.LastUpdate := j.GetValue<string>('timestamp');
        m.Stock.Clear;
        jarr := j.GetValue<TJSONArray>('Items');
        for i := 0 to jarr.Count - 1 do
        begin
          s := jarr.Items[i].GetValue<string>('Stock');
          if s > '0' then
           m.Stock.AddPair(LowerCase(jarr.Items[i].GetValue<string>('Name_Localised')), s);

          if FLoadCategories then
          begin
            FItemCategories.Values[LowerCase(jarr.Items[i].GetValue<string>('Name_Localised'))] :=
              jarr.Items[i].GetValue<string>('Category_Localised');
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
    if FMarket.MarketID = FCargoExt.MarketID then
      CopyFile(PChar(FMarketJSON),PChar(FCargoExtJSON),false);
    if FMarket.MarketID = FSimDepot.MarketID then
      CopyFile(PChar(FMarketJSON),PChar(FSimDepotJSON),false);

    UpdateSecondaryMarket(false);

{
      s := FWorkingDir + 'markets\' + FMarket.Values['$MarketID'];
      if FileExists(s) then
        CopyFile(PChar(FMarketJSON),PChar(s),false);
}
  except
  end;
  FLoadCategories := false;
  SetDataChanged;
  sl.Free;
end;

procedure TEDDataSource.UpdateCargoExternal;
var sl: TStringList;
    s: string;
    i: Integer;
begin
  if CheckLoadFromFile(sl,FCargoExtJSON) = false then Exit;
  FCargoExt.Clear;
  try
    MarketFromJSON(FCargoExt,sl.Text);
  except
  end;
  SetDataChanged;
  sl.Free;
end;

procedure TEDDataSource.UpdateSimDepot;
var j: TJSONObject;
    jarr: TJSONArray;
    sl: TStringList;
    s: string;
    i,midx: Integer;
begin
  if CheckLoadFromFile(sl,FSimDepotJSON) = false then Exit;
  if FSimDepot.MarketID <> '' then
  begin
    midx := FConstructions.IndexOf(FSimDepot.MarketID);
    if midx >= 0 then
      FConstructions.Delete(midx);
    FSimDepot.Clear;
  end;
  try
    j := TJSONObject.ParseJSONValue(sl.Text) as TJSONObject;
    try
      FSimDepot.MarketID := j.GetValue<string>('MarketID');
      FSimDepot.StationName := j.GetValue<string>('StationName');
      FSimDepot.StarSystem := j.GetValue<string>('StarSystem');
      FSimDepot.Status := sl.Text;
      FSimDepot.LastUpdate := j.GetValue<string>('timestamp');

      FConstructions.AddObject(FSimDepot.MarketID,FSimDepot);
    finally
      j.Free;
    end;
  except
  end;
  SetDataChanged;
  sl.Free;
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
    js,s,s2,tms,event,mID: string;
    i,i2,cpos: Integer;
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
      end;
      Result := TMarket(FRecentMarkets.Objects[midx]);
    end;

begin
  for i := 0 to jrnl.Count - 1 do
  begin
    j := nil;
    try

      try
        js := jrnl[i];
        //skip irrelevant entries to speed up JSON processing
        cpos := Pos('"event":"',js);
        s := Copy(js,cpos+9,100);
        s := Copy(s,1,Pos('"',s)-1);
        if (s<>'Loadout') and (s<>'Docked') and (s<>'ColonisationConstructionDepot') then continue;
        event := s;

        j := TJSONObject.ParseJSONValue(jrnl[i]) as TJSONObject;
        tms := j.GetValue<string>('timestamp');
        if tms < FLastJrnlTimeStamps.Values[fn] then continue;

//        event := j.GetValue<string>('event');
        if event = 'Loadout' then
          FCapacity := j.GetValue<Integer>('CargoCapacity');

        mID := '';
        try mID := j.GetValue<string>('MarketID'); except end;
        if mID = '' then continue;

        if event = 'Docked' then
        begin
          s := j.GetValue<string>('StationType');
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
            cd.StationName := s;
            cd.StarSystem := j.GetValue<string>('StarSystem');
            cd.LastUpdate := tms;
          end
          else
          begin
            try
              m := MarketForMarketId(mID);
//              m := MarketFromId(mID);

              if m <> nil then
              begin


                if m.Status = '' then //markets with no stored data
                begin
                  s := '';
                  try s := j.GetValue<string>('StationName_Localised'); except end;
                  if s = '' then s := j.GetValue<string>('StationName');
                  m.StationName := s;
                  m.StationType := j.GetValue<string>('StationType');
                  m.StarSystem := j.GetValue<string>('StarSystem');
                  m.LastUpdate := tms;
                end;

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
          cd.Status := jrnl[i];
          cd.LastUpdate := tms;
          s := j.GetValue<string>('ConstructionComplete');
          if s = 'true' then
          begin
            cd.Finished := true;
            if FSystemUpdates.Values[cd.StarSystem] < tms  then
              FSystemUpdates.Values[cd.StarSystem] := tms;
          end;
        end;

        FLastJrnlTimeStamps[fn] := tms;
      except
        __log_except('UpdateFromJournal',tms);
      end;

    finally
      j.Free;
    end;

  end;
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
end;

procedure TEDDataSource.Update;
var sl: TStringList;
    fn: string;
    res: Integer;
    fa: DWord;
    srec: TSearchRec;

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


  sl := TStringList.Create;

//  FDataChanged := False;

  try

//  UpdateCapacity;
  UpdateCargo;
  UpdateMarket;
  UpdateCargoExternal;

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
        SetDataChanged;
        //FLastJrnlFile := srec.Name;
      end;
    end;
    res := FindNext(srec);
  end;
  FindClose(srec);

  UpdateSimDepot;



  finally
    sl.Free;
  end;

end;

procedure TEDDataSource.MarketToSimDepot;
begin
  CopyFile(PChar(FMarketJSON),PChar(FSimDepotJSON),false);
  SetDataChanged;
end;

procedure TEDDataSource.MarketToCargoExt;
begin
//  FCargoExt.Clear;
  CopyFile(PChar(FMarketJSON),PChar(FCargoExtJSON),false);
  SetDataChanged;
end;

function TEDDataSource.MarketFromID(id: string): TMarket;
var idx: Integer;
begin
  Result := nil;
  idx := FRecentMarkets.IndexOf(id);
  if idx >=0 then
    Result := TMarket(FRecentMarkets.Objects[idx]);
end;

procedure TEDDataSource.SetDataChanged;
begin
  FDataChanged := true;
end;

procedure TEDDataSource.UpdateMarketComment(mID: string; s: string);
begin
  FMarketComments.Values[mID] := s;
  try FMarketComments.SaveToFile(FWorkingDir + 'market_info.txt'); except end;
//  SetDataChanged;
  NotifyListeners;
end;

constructor TEDDataSource.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FWorkingDir := GetCurrentDir + '\';

  try CreateDir(FWorkingDir + 'markets'); except end;

  FMarket := TMarket.Create;
  FCargo := TStock.Create;
  FCargoExt := TMarket.Create;
  FSimDepot := TConstructionDepot.Create;
  FSimDepot.Simulated := true;
  FFileDates := TStringList.Create;
  FSystemUpdates := TStringList.Create;
  FConstructions := TStringList.Create;
  FRecentMarkets := TStringList.Create;
  FMarketComments := TStringList.Create;
  FMarketLevels := TStringList.Create;
  FItemCategories := TStringList.Create;
  FLastJrnlTimeStamps := TStringList.Create;
  FDataChanged := false;

  LoadAllMarkets;

  FLoadCategories := true; //categories are always updated from market.json

  FJournalDir := System.SysUtils.GetEnvironmentVariable('USERPROFILE') +
       '\Saved Games\Frontier Developments\Elite Dangerous\';
  if Opts['JournalDir'] <> '' then
    FJournalDir := Opts['JournalDir'];
//  SetCurrentDir(FJournalDir);
//  FJournalDir :=  GetCurrentDir + '\';

  FMarketJSON := FJournalDir + 'market.json';
  FCargoJSON := FJournalDir + 'cargo.json';
  FModuleInfoJSON := FJournalDir + 'modulesinfo.json';
  FCargoExtJSON := FWorkingDir + 'market_cargoext.json';
  FSimDepotJSON := FWorkingDir + 'market_simdepot.json';

  try FMarketComments.LoadFromFile(FWorkingDir + 'market_info.txt') except end;
  try FMarketLevels.LoadFromFile(FWorkingDir + 'market_level.txt') except end;


//  UpdTimer.Enabled := True;
end;


end.
