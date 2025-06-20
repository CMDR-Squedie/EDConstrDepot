unit DataSource;


interface

uses Winapi.Windows, Winapi.Messages, Winapi.PsAPI, System.Classes, System.SysUtils,
  System.JSON, System.IOUtils, System.IniFiles, System.DateUtils, System.StrUtils,
  System.Types, Settings, Vcl.ExtCtrls,Vcl.Dialogs;

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

type TStock = class(THashedStringList)
    procedure SetQty(const Name: string; v: Integer);
    function GetQty(const Name: string): Integer;
  public
    ShipTotal: Integer; //this is only updated from cargo.json!
    property Qty[const Name: string]: Integer read GetQty write SetQty; default;
end;

type TFlightData = record
  Time: Extended;
  Destination: string;
end;

type TDockToDockTimes = class
  Last: Extended;
  AddIdx: Integer;
  fdata: array [0..5] of TFlightData;
  procedure Clear;
  procedure Add(t: Extended; dest: string);
  function GetAvg: Extended;
end;

type TSystemBody = class
  BodyName: string;
  BodyID: string;
  BodyType: string; //StarType or PlanetClass
  DistanceFromArrivalLS: Extended;
  TidalLock: Boolean;
  Landable: Boolean;
  AtmosphereType: string;
  Volcanism: string;
  SurfaceGravity: string;
//  Composition: string;
  SemiMajorAxis: Extended;
  OrbitalInclination: Extended;
  OrbitalPeriod: Extended;
  RotationPeriod: Extended;
  AxialTilt: Extended;
  GeologicalSignals: Integer;
  BiologicalSignals: Integer;
  HumanSignals: Integer;
  OtherSignals: Integer;
  Scan: string;
end;

type TStarSystem = class
private
  FFactions: string;
  FAlterName: string;
  FBodies: TStringList;
  function GetFactions(abbrevf: Boolean): string;
  function GetFactions_short: string;
  function GetFactions_full: string;
  function GetArchitectName: string;
  procedure SetArchitectByName(s: string);
  procedure SetAlterName(s: string);
public
  StarSystem: string;
  SystemAddress: string;
  StarPosX: Double;
  StarPosY: Double;
  StarPosZ: Double;
  SystemSecurity: string;
  Population: Int64;
  PopHistory: TStringList;
  LastUpdate: string;
  Status: string;
  FSSData: string;
  Architect: string;
  PrimaryDone: Boolean;
  LastCmdr: string;
  Comment: string;
  CurrentGoals: string;
  Objectives: string;
  Ignored: Boolean;
  function DistanceTo(s: TStarSystem): Double;
  function PopForTimeStamp(tms: string): Int64;
  procedure AddPopToHistory(tms: string; pop: Int64);
  function TryAddBodyFromId(orgBodyId: string): TSystemBody;
  procedure AddScan(js: string; j: TJSONObject);
  procedure AddSignals(js: string; j: TJSONObject);
  function ImagePath: string;
  procedure Save;
  constructor Create;
  destructor Destroy;
published
  property Factions: string read GetFactions_short;
  property Factions_full: string read GetFactions_full;
  property ArchitectName: string read GetArchitectName write SetArchitectByName;
  property AlterName: string read FAlterName write SetAlterName;
end;


type TBaseMarket = class
private
  FSysData: TStarSystem;
public
  MarketID: string;
  StationName: string;
  StationName2: string; //eg. full name for carriers
  StationType: string;
  StarSystem: string;
  Body: string;
  LastUpdate: string;
  LastDock: string;
  Status: string;
  Stock: TStock;
  DistFromStar: Integer;
  DockToDockTimes: TDockToDockTimes;
  function System: TStarSystem;
  function FullName: string;
  function StationName_full: string;
  function StarSystem_nice: string;
  function DistanceTo(m: TBaseMarket): Extended;
  function DistanceTo_string(m: TBaseMarket): string;
  procedure Clear;
  constructor Create;
  destructor Destroy;
end;

type TMarket = class (TBaseMarket)
  Economies: string; //this changes on dock
  MarketEconomies: string; //this changes on market visit
  HoldSnapshots: Boolean;
  Snapshot: Boolean;
end;

type TConstructionDepot = class (TBaseMarket)
  Finished: Boolean;
  Simulated: Boolean;
end;

type TSystemList = class (THashedStringList)
//  FFirstColony: TStarSystem;
//  FLastColony: TStarSystem;
  FAlterNames: THashedStringList;
  FAddresses: THashedStringList;
  function GetSystemByAlterName(const Name: string): TStarSystem;
  function GetSystemByName(const Name: string): TStarSystem;
  function GetSystemByAddr(const Addr: string): TStarSystem;
  function GetSystemByIdx(const idx: Integer): TStarSystem;
public
  property SystemByName[const Name: string]: TStarSystem read GetSystemByName;
  property SystemByIdx[const idx: Integer]: TStarSystem read GetSystemByIdx; default;
  property SystemByAlterName[const Name: string]: TStarSystem read GetSystemByAlterName;
  property SystemByAddr[const Addr: string]: TStarSystem read GetSystemByAddr;
  procedure UpdateFromFSDJump(js: string; j: TJSONObject);
  procedure AddFromJSON(js: string);
  procedure UpdateArchitect(cmdr: string; j: TJSONObject);
  procedure UpdateBodyScan(js: string; j: TJSONObject);
  procedure UpdateBodySignals(js: string; j: TJSONObject);
  constructor Create;
end;

//not used
const cDefaultCapacity: Integer = 784;

type TEDDataSource = class (TDataModule)
    UpdTimer: TTimer;
    procedure UpdTimerTimer(Sender: TObject);
  private
    FListeners: array of IEDDataListener;
    FCommanders: TStringList;
    FCurrentCmdr: string;
    FCurrentSystem: string;
    FCargo: TStock;
    FFileDates: THashedStringList;
    FLastConstrTimes: THashedStringList;
    FItemCategories: THashedStringList;
    FItemNames: THashedStringList;
    FRecentMarkets: THashedStringList;
    FMarketSnapshots: THashedStringList;
    FConstructions: THashedStringList;
    FCargoExt: TMarket;
    FSimDepot: TConstructionDepot;
    FMarket: TMarket;
    FMarketComments: THashedStringList;
    FMarketLevels: THashedStringList;
    FMarketGroups: THashedStringList;
    FStarSystems: TSystemList;
    FWorkingDir,FJournalDir: string;
    FMarketJSON,FCargoJSON,FModuleInfoJSON: string;
    FCapacity: Integer;
    FMaxJumpRange: Extended;
    FHullMass: Extended;
    FLadenJumpRange: Extended;
    FBaseJumpRange: Extended;
    FFuelMass: Extended;
    FLastJrnlTimeStamps: THashedStringList;
    FDataChanged: Boolean;
    FInitialLoad: Boolean;
    FLastFC: string;
    FTaskGroup: string;
    FLastConstrDockTime: string;
    FLastDockDepotId: string;
    FLastMarketId: string;
    FLastDropId: string;
    FDoingBackup: Boolean;
    FBackupFile: string;
    FLastConstructionDone: string;
    procedure SetDataChanged;
    function CheckLoadFromFile(var sl: TStringList; fn: string): Boolean;
    procedure MarketFromJSON(m: TMarket; js: string);
    procedure LoadMarket(fn: string);
    procedure LoadAllMarkets;
    procedure LoadColony(fn: string);
    procedure LoadAllColonies;
    procedure UpdateCargo;
    procedure UpdateMarket;
    procedure UpdateCapacity;
    procedure UpdateSimDepot;
    procedure UpdateFromJournal(fn: string; jrnl: TStringList);
    procedure NotifyListeners;
    procedure Update;
    procedure SetTaskGroup(s: string);
    procedure UpdateDockTime(tms: string; m: TBaseMarket);
    procedure RemoveIdleDockTime(tms: string);
    procedure CalcShipRanges(j: TJSONObject);
  public
    //todo: switch to THashedStringList and TDictionary
    property Constructions: THashedStringList read FConstructions;
    property StarSystems: TSystemList read FStarSystems;
    property Commanders: TStringList read FCommanders;
    property RecentMarkets: THashedStringList read FRecentMarkets;
    property MarketSnapshots: THashedStringList read FMarketSnapshots;
    property LastConstrTimes: THashedStringList read FLastConstrTimes;
    property MarketComments: THashedStringList read FMarketComments;
    property MarketLevels: THashedStringList read FMarketLevels;
    property MarketGroups: THashedStringList read FMarketGroups;
    property Market: TMarket read FMarket;
    property ItemNames: THashedStringList read FItemNames;
    property ItemCategories: THashedStringList read FItemCategories;
    property Cargo: TStock read FCargo;
    property CargoExt: TMarket read FCargoExt;
    property Capacity: Integer read FCapacity;
    property MaxJumpRange: Extended read FMaxJumpRange;
    property JumpRange: Extended read FLadenJumpRange;
    property TaskGroup: string read FTaskGroup write SetTaskGroup;
    property LastDockDepotId: string read FLastDockDepotId;
    property LastMarketId: string read FLastMarketId;
    property LastConstructionDone: string read FLastConstructionDone;
    property WorkingDir: string read FWorkingDir;
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
    procedure ResetDockTimes;
//    property DataChanged: Boolean read FDataChanged;
    procedure Load;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure DoBackup;
    constructor Create(Owner: TComponent); override;
end;

procedure __log_except(fname: string;info: string);

const cMinDockToDockTime: Integer = 3; //minutes
      cMaxDockToDockTime: Integer = 60;

var DataSrc: TEDDataSource;

implementation

{$R *.dfm}

uses Main;

var JSONFormatSettings: TFormatSettings;


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

procedure TDockToDockTimes.Clear;
var i: Integer;
begin
  AddIdx := 0;
  Last := 0;
  for i := 0 to High(fdata) do fdata[i].Time := 0;
end;

procedure TDockToDockTimes.Add(t: Extended; dest: string);
var i: Integer;
begin
  if t < cMinDockToDockTime then Exit;
  if t > cMaxDockToDockTime then Exit;
  fdata[AddIdx].Time := t;
  fdata[AddIdx].Destination := dest;
  Last := t;
  AddIdx := AddIdx + 1;
  if AddIdx > High(fdata) then AddIdx := 0;
end;

{
//this one ignore min and max values
function TDockToDockTimes.GetAvg: Extended;
var MinVal,MaxVal,Sum: Extended;
    i,Count: Integer;
begin
  Result := 0;
  MinVal := 0;
  MaxVal := 0;
  Sum := 0;
  Count := 0;
  for i := 0 to High(varr) do
  begin
    if varr[i] = 0 then break;
    Sum := Sum + varr[i];
    Count := Count + 1;
    if (MinVal = 0) or (varr[i] < MinVal) then MinVal := varr[i];
    if (MaxVal = 0) or (varr[i] > MaxVal) then MaxVal := varr[i];
  end;

  if Count = 0 then Exit;
  if Count < 3 then
  begin
    Result := Sum/Count;
    Exit;
  end;

  Sum := 0;
  Count := 0;
  for i := 0 to High(varr) do
  begin
    if varr[i] = 0 then break;
    if (varr[i] > MinVal) and (varr[i] > MaxVal) then
    begin
      Sum := Sum + varr[i];
      Count := Count + 1;
    end;
    if varr[i] = MinVal then MinVal := 0;
    if varr[i] = MaxVal then MaxVal := 0;
  end;
  Result := Sum/Count;
end;
}

//this one accepts or values not greater than 2 x MinVal
function TDockToDockTimes.GetAvg: Extended;
var MinVal,Sum: Extended;
    i,Count: Integer;
begin
  Result := 0;
  MinVal := 0;
  Sum := 0;
  Count := 0;
  for i := 0 to High(fdata) do
  begin
    if fdata[i].Time = 0 then break;
    Sum := Sum + fdata[i].Time;
    Count := Count + 1;
    if (MinVal = 0) or (fdata[i].Time < MinVal) then MinVal := fdata[i].Time;
  end;

  if Count = 0 then Exit;

  Sum := 0;
  Count := 0;
  for i := 0 to High(fdata) do
  begin
    if fdata[i].Time = 0 then break;
    if fdata[i].Time < 2 * MinVal then
    begin
      Sum := Sum + fdata[i].Time;
      Count := Count + 1;
    end;
  end;
  Result := Sum/Count;
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
  StationName := '';
  StationName2 := '';
  StationType := '';
  StarSystem := '';
  FSysData := nil;
  Status := '';
  LastUpdate := '';
  LastDock := '';
  DistFromStar := 0;
  Stock.Clear;
  DockToDockTimes.Clear;
end;

function TBaseMarket.FullName: string;
begin
  Result := StationName_full + '/' + StarSystem_nice;
end;

function TBaseMarket.StarSystem_nice: string;
var p: Integer;
begin
  Result := StarSystem;
//looks nice... but not just yet
//  p := Pos('Col 285 Sector ',Result); //custom list here
//  if p > 0 then Result := Copy(Result,p+15,200);
end;

function TBaseMarket.StationName_full: string;
begin
  Result := StationName;
  if StationName2 <> '' then Result := StationName2;
end;

function TBaseMarket.System: TStarSystem;
begin
  if FSysData = nil then
    FSysData := DataSrc.StarSystems.SystemByName[self.StarSystem];
  Result := FSysData;
end;

function TBaseMarket.DistanceTo_string(m: TBaseMarket): string;
begin
  Result := '';
  if self.System <> nil then
    if m.System <> nil then
      Result := FloatToStrF(System.DistanceTo(m.System),ffFixed,7,2);
end;

function TBaseMarket.DistanceTo(m: TBaseMarket): Extended;
begin
  Result := 0;
  if self.System <> nil then
    if m.System <> nil then
      Result := System.DistanceTo(m.System);
end;

constructor TBaseMarket.Create;
begin
  Stock := TStock.Create;
  DockToDockTimes := TDockToDockTimes.Create;
  DistFromStar := -1;
end;

destructor TBaseMarket.Destroy;
begin
  Stock.Free;
  DockToDockTimes.Free;
end;

function TStarSystem.DistanceTo(s: TStarSystem): Double;
begin
  Result := Sqrt(Sqr(StarPosX-s.StarPosX) + Sqr(StarPosY-s.StarPosY) + Sqr(StarPosZ-s.StarPosZ));
end;

function TStarSystem.ImagePath: string;
begin
  Result := DataSrc.FWorkingDir + 'colonies\' + StarSystem + '.png';
end;

function TStarSystem.PopForTimeStamp(tms: string): Int64;
var i: Integer;
begin
  Result := Population;
  for i := PopHistory.Count - 1 downto 0 do
  begin
    if PopHistory.Names[i] <= tms then
    begin
      Result := StrToInt64(PopHistory.ValueFromIndex[i]);
      break;
    end;
  end;
end;

procedure TStarSystem.AddPopToHistory(tms: string; pop: Int64);
var i: Integer;
begin
  if PopHistory.Count > 0 then
    if pop = StrToInt64(PopHistory.ValueFromIndex[PopHistory.Count-1]) then Exit;
  PopHistory.AddPair(tms,IntToStr(pop));
end;

function TStarSystem.GetFactions(abbrevf: Boolean): string;
var j: TJSONObject;
    jarr: TJSONArray;
    i,i2: Integer;
    s,s2,name: string;
    infl: Extended;
    sl,sl2: TStringList;
    sarr: TStringDynArray;
begin
  Result := '';
  sl := TStringList.Create;
  sl2 := TStringList.Create;
  try
    j := TJSONObject.ParseJSONValue(Status) as TJSONObject;
    try
      jarr := j.GetValue<TJSONArray>('Factions');
      for i := 0 to jarr.Count - 1 do
      begin
        name := jarr.Items[i].GetValue<string>('Name');
        sarr := SplitString(name,' ');
        s := '';
        for i2 := 0 to High(sarr) - 1 do
          s := s + Copy(sarr[i2],1,1);
        s := s + Copy(sarr[High(sarr)],1,3);

        if not abbrevf then
          s := s + '   ' + name;

        infl := jarr.Items[i].GetValue<Extended>('Influence');
        s2 := FloatToStrF(infl*100,ffFixed,7,1);
        sl.Add(s2.PadLeft(10,' ') + s + '=' + s2);
      end;

      sl.Sort;
      for i := sl.Count - 1 downto 0 do
      begin
        if Result <> '' then
          if abbrevf then
            Result := Result + '; '
          else
            Result := Result + Chr(13);
        Result := Result + Copy(sl.Names[i],11,200) + ' ' + sl.ValueFromIndex[i] + '%';
      end;

    finally
      j.Free;
    end;
  except
  end;
  sl.Free;
  sl2.Free;
end;

function TStarSystem.GetFactions_short: string;
begin
  Result := FFactions;
  if Result <> '' then Exit;
  FFactions := GetFactions(true);
  Result := FFactions;
end;

function TStarSystem.GetFactions_full: string;
begin
  Result := GetFactions(false);
end;

function TStarSystem.TryAddBodyFromId(orgBodyId: string): TSystemBody;
var bodyId: string;
    b: TSystemBody;
    idx: Integer;
begin
  Result := nil;
  if FBodies = nil then
  begin
    FBodies := TStringList.Create;
    FBodies.Sorted := True;
    FBodies.Duplicates := dupIgnore;
  end;

  bodyId := orgBodyId;
  bodyId := bodyId.PadLeft(6,'0');
  idx := FBodies.IndexOf(bodyId);
  if idx = -1 then
  begin
    b := TSystemBody.Create;
    b.BodyID := bodyId;
    FBodies.AddObject(bodyId,b);
  end
  else
    b := TSystemBody(FBodies.Objects[idx]);
  Result := b;
end;

procedure TStarSystem.AddScan(js: string; j: TJSONObject);
var bodyId,s: string;
    b: TSystemBody;
    idx: Integer;
begin
  bodyId := '';
  j.TryGetValue<string>('BodyID',bodyId);
  b := TryAddBodyFromId(bodyId);
  if b = nil then Exit;
  with b do
  begin
    Scan := js;
    j.TryGetValue<string>('BodyName',BodyName);
    BodyType := '';
    j.TryGetValue<string>('StarType',BodyType);
    if BodyType = '' then
      j.TryGetValue<string>('PlanetClass',BodyType);
    j.TryGetValue<Extended>('DistanceFromArrivalLS',DistanceFromArrivalLS);
    j.TryGetValue<Boolean>('TidalLock',TidalLock);
    j.TryGetValue<Boolean>('Landable',Landable);
    j.TryGetValue<string>('AtmosphereType',AtmosphereType);
    j.TryGetValue<string>('Volcanism',Volcanism);
    j.TryGetValue<string>('SurfaceGravity',SurfaceGravity);
    j.TryGetValue<Extended>('SemiMajorAxis',SemiMajorAxis);
    j.TryGetValue<Extended>('OrbitalInclination',OrbitalInclination);
    j.TryGetValue<Extended>('OrbitalPeriod',OrbitalPeriod);
    j.TryGetValue<Extended>('RotationPeriod',RotationPeriod);
    j.TryGetValue<Extended>('AxialTilt',AxialTilt);
  end;
end;

procedure TStarSystem.AddSignals(js: string; j: TJSONObject);
var bodyId,s: string;
    b: TSystemBody;
    i,idx,cnt: Integer;
    jarr: TJSONArray;
begin
  if FBodies = nil then Exit;
  bodyId := '';
  j.TryGetValue<string>('BodyID',bodyId);
  if bodyId = '' then Exit;
  b := TryAddBodyFromId(bodyId);
  if b = nil then Exit;

  jarr := j.GetValue<TJSONArray>('Signals');
  for i := 0 to jarr.Count - 1 do
  begin
    s := '';
    jarr[i].TryGetValue<string>('Type_Localised',s);
    jarr[i].TryGetValue<Integer>('Count',cnt);
    if s = 'Geological' then
      b.GeologicalSignals := cnt
    else
    if s = 'Biological' then
      b.BiologicalSignals := cnt
    else
    if s = 'Human' then
      b.HumanSignals := cnt
    else
      b.OtherSignals := cnt;
  end;
end;

procedure TStarSystem.Save;
var j: TJSONObject;
    fn: string;
begin
  j := TJSONObject.Create;
  j.AddPair(TJSONPair.Create('StarSystem', StarSystem));
  j.AddPair(TJSONPair.Create('SystemAddress', SystemAddress));
  j.AddPair(TJSONPair.Create('Architect', Architect));
  j.AddPair(TJSONPair.Create('ArchitectName', ArchitectName));
  j.AddPair(TJSONPair.Create('AlterName', AlterName));
  j.AddPair(TJSONPair.Create('Comment', Comment));
  j.AddPair(TJSONPair.Create('CurrentGoals', CurrentGoals));
  j.AddPair(TJSONPair.Create('Objectives', Objectives));
  j.AddPair(TJSONPair.Create('Ignored', Ignored));
  fn := DataSrc.FWorkingDir + 'colonies\' + SystemAddress + '.json';
  TFile.WriteAllText(fn, j.Format());
  j.Free;
end;

function TStarSystem.GetArchitectName: string;
begin
  Result := DataSrc.Commanders.Values[Architect];
  if Result = '' then Result := Architect;
end;

procedure TStarSystem.SetArchitectByName(s: string);
var i: Integer;
begin
  Architect := s;
  for i := 0 to DataSrc.Commanders.Count - 1 do
    if DataSrc.Commanders.ValueFromIndex[i] = s then
      Architect := DataSrc.Commanders.Names[i];
end;

procedure TStarSystem.SetAlterName(s: string);
var i,idx: Integer;
begin
  if s = FAlterName then Exit;

  if FAlterName <> '' then
  begin
    idx := DataSrc.FStarSystems.FAlterNames.IndexOf(FAlterName);
    if idx <> -1 then
      DataSrc.FStarSystems.FAlterNames.Delete(idx);
  end;
  FAlterName := s;
  DataSrc.FStarSystems.FAlterNames.AddObject(FAlterName,self);
end;


constructor TStarSystem.Create;
begin
  PopHistory := TStringList.Create;
end;

destructor TStarSystem.Destroy;
begin
  PopHistory.Free;
end;

function TSystemList.GetSystemByAlterName(const Name: string): TStarSystem;
var idx: Integer;
begin
  Result := nil;
  idx := FAlterNames.IndexOf(Name);
  if idx > -1 then
    Result := TStarSystem(FAlterNames.Objects[idx]);
end;

function TSystemList.GetSystemByAddr(const Addr: string): TStarSystem;
var idx: Integer;
begin
  Result := nil;
  idx := FAddresses.IndexOf(Addr);
  if idx > -1 then
    Result := TStarSystem(FAddresses.Objects[idx]);
end;

function TSystemList.GetSystemByName(const Name: string): TStarSystem;
var idx: Integer;
begin
  Result := nil;
  idx := IndexOf(Name);
  if idx > -1 then
    Result := TStarSystem(Objects[idx]);
end;

function TSystemList.GetSystemByIdx(const idx: Integer): TStarSystem;
var i: Integer;
begin
  Result := TStarSystem(Objects[idx]);
end;

constructor TSystemList.Create;
begin
  FAlterNames := THashedStringList.Create;
  FAddresses := THashedStringList.Create;
end;

procedure TSystemList.UpdateFromFSDJump(js: string; j: TJSONObject);
var jarr: TJSONArray;
    name,s, tms: string;
    sys: TStarSystem;
    pop: Int64;
    px,py,pz: Extended;
begin
  try
    jarr := j.GetValue<TJSONArray>('StarPos');
    px := StrToFloat(jarr[0].Value,JSONFormatSettings);
    py := StrToFloat(jarr[1].Value,JSONFormatSettings);
    pz := StrToFloat(jarr[2].Value,JSONFormatSettings);
    if Abs(px) > Opts.MaxColonyDist then Exit;
    if Abs(py) > Opts.MaxColonyDist then Exit;
    if Abs(pz) > Opts.MaxColonyDist then Exit;

    tms := j.GetValue<string>('timestamp');
    name := j.GetValue<string>('StarSystem');
    pop := j.GetValue<Int64>('Population');
    sys := GetSystemByName(name);
    if sys <> nil then
    begin
      sys.AddPopToHistory(tms,pop);
      if tms < sys.LastUpdate then Exit;
    end
    else
    begin
      sys := TStarSystem.Create;
      with sys do
      begin
        StarSystem := name;
        SystemAddress := j.GetValue<string>('SystemAddress');
      end;
      AddObject(name,sys);
      FAddresses.AddObject(sys.SystemAddress,sys);
    end;

    if sys.LastUpdate = '' then  //loaded from file?
    begin
      sys.StarPosX := px;
      sys.StarPosY := py;
      sys.StarPosZ := pz;
    end;
    sys.SystemSecurity := j.GetValue<string>('SystemSecurity_Localised');
    try sys.SystemSecurity := SplitString(sys.SystemSecurity,' ')[0]; except end;

    sys.Population := pop;
    sys.LastUpdate := tms;
    sys.LastCmdr := DataSrc.FCurrentCmdr;
    sys.FFactions := ''; //extracted on demand
    sys.Status := js;
  except
  end;
end;

procedure TSystemList.AddFromJSON(js: string);
var j: TJSONObject;
    jarr: TJSONArray;
    s, tms: string;
    sys: TStarSystem;
    pop: Int64;
begin
  try
    j := TJSONObject.ParseJSONValue(js) as TJSONObject;
    sys := TStarSystem.Create;
    with sys do
    begin
      StarSystem := j.GetValue<string>('StarSystem');
      SystemAddress := j.GetValue<string>('SystemAddress');
      try Architect := j.GetValue<string>('Architect'); except end;
      try AlterName := j.GetValue<string>('AlterName'); except end;
      try Comment := j.GetValue<string>('Comment'); except end;
      j.TryGetValue<string>('CurrentGoals',CurrentGoals);
      j.TryGetValue<string>('Objectives',Objectives);
      j.TryGetValue<Boolean>('Ignored',Ignored);
 {
      jarr := j.GetValue<TJSONArray>('StarPos');
      StarPosX := StrToFloat(jarr[0].Value,JSONFormatSettings);
      StarPosY := StrToFloat(jarr[1].Value,JSONFormatSettings);
      StarPosZ := StrToFloat(jarr[2].Value,JSONFormatSettings);
      SystemSecurity := j.GetValue<string>('SystemSecurity_Localised');
      Population := j.GetValue<Int64>('Population');
      LastUpdate := j.GetValue<string>('timestamp');
      Status := js;
}
      //FJSONObj := j;
    end;
    AddObject(sys.StarSystem,sys);
    FAddresses.AddObject(sys.SystemAddress,sys);
  except
  end;
end;

procedure TSystemList.UpdateArchitect(cmdr: string; j: TJSONObject);
var sys: TStarSystem;
    s: string;
begin
  try
    s := j.GetValue<string>('StarSystem');
    sys := GetSystemByName(s);
    if sys <> nil then
      sys.Architect := cmdr;
  except
  end;
end;

procedure TSystemList.UpdateBodyScan(js: string; j: TJSONObject);
var sys: TStarSystem;
    s: string;
begin
  try
    s := j.GetValue<string>('StarSystem');
    sys := GetSystemByName(s);
    if sys <> nil then
      sys.AddScan(js,j);
  except
  end;
end;

procedure TSystemList.UpdateBodySignals(js: string; j: TJSONObject);
var sys: TStarSystem;
    s: string;
begin
  try
    s := j.GetValue<string>('SystemAddress');
    sys := GetSystemByAddr(s);
    if sys <> nil then
      sys.AddSignals(js,j);
  except
  end;
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

procedure TEDDataSource.UpdateCapacity;
var j: TJSONObject;
    jarr: TJSONArray;
    sl: TStringList;
    s: string;
    i,orgCapacity: Integer;
begin
  if CheckLoadFromFile(sl,FModuleInfoJSON) = false then Exit;
  orgCapacity := FCapacity;
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
    FCapacity := orgCapacity;
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
      FCargo.ShipTotal := StrToInt(j.GetValue<string>('Count'));
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
     additemf: Boolean;
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
          if s <> '' then 
          begin
            m.Economies := s;
            m.MarketEconomies := s;
          end;
        except end;
        m.LastUpdate := j.GetValue<string>('timestamp');
        m.Stock.Clear;
        jarr := j.GetValue<TJSONArray>('Items');
        for i := 0 to jarr.Count - 1 do
        begin
          additemf := False;
          s := jarr.Items[i].GetValue<string>('Stock');
          if s > '0' then
          begin
            m.Stock.AddPair(LowerCase(jarr.Items[i].GetValue<string>('Name_Localised')), s);
            additemf := True;
          end;

          if m.StationType = 'FleetCarrier' then
          begin
            s := jarr.Items[i].GetValue<string>('Demand');
            if s > '0' then
             m.Stock.AddPair('$' + LowerCase(jarr.Items[i].GetValue<string>('Name_Localised')), s);
             additemf := True;
          end;

          //if not FInitialLoad then additemf = False;
          if additemf then
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
  FSimDepot.StationName2 := m.StationName2;
  FSimDepot.StarSystem := m.StarSystem;
  FSimDepot.Status := m.Status;
  FSimDepot.LastUpdate := m.LastUpdate;
  FSimDepot.Stock.Assign(m.Stock);
  SetDataChanged;
end;

procedure TEDDataSource.UpdTimerTimer(Sender: TObject);
begin
  //would be a good idea to turn off the timer, but it also renews
  //the timer resource altogether...
  if gTimersSuspended then Exit;

  try
    Update;
    if FDataChanged then
      NotifyListeners;
    FDataChanged := False;
  except
    //suppress all errors on timers!
  end;
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
  FLastConstructionDone := '';
end;

procedure TEDDataSource.UpdateDockTime(tms: string; m: TBaseMarket);
var s: string;
    d: Extended;
begin
  s := Copy(tms,12,8);
  if m.MarketId = FLastDockDepotId then
    if FLastConstrDockTime <> '' then
    begin
      d := (StrToDateTime(s) - StrToDateTime(FLastConstrDockTime)) * 1440;
      if d < 0 then d := d + 1;
      m.DockToDockTimes.Add(d,FLastMarketId);
    end;
  FLastConstrDockTime := s;
  FLastDockDepotId := m.MarketId;
end;

procedure TEDDataSource.RemoveIdleDockTime(tms: string);
var s: string;
    d: Extended;
begin
  if Opts.MaxIdleDockTime <= 0 then Exit;
  s := Copy(tms,12,8);
  d := (StrToDateTime(s) - StrToDateTime(FLastConstrDockTime)) * 86400;
  if d > Opts.MaxIdleDockTime then //60 seconds for checking missions, news etc.
  begin
    d := StrToDateTime(s) - Opts.DockToUndockTime/86400;  //15 seconds dock-to-undock
    FLastConstrDockTime := Copy(DateToISO8601(d),12,8);
  end;
end;

procedure TEDDataSource.CalcShipRanges(j: TJSONObject);
var jarr: TJSONArray;
    i: Integer;
    nominalRange,rangeBoost, minFuel: Extended;
    s: string;
begin
  //MaxJumpRange seems to be calculated with fuel tank filled to one jump...
  //all subsequent calculations match perfectly in-game calculations
  //if FHullMass is increased by minFuel
  // eg. ~12t for Cutter which is minimum fuel for 7A SCO FSD
  nominalRange := j.GetValue<Extended>('MaxJumpRange');
  minFuel := 0;  //max fuel per one jump
  rangeBoost := 0;

  try
    jarr := j.GetValue<TJSONArray>('Modules');
    for i := 0 to jarr.Count - 1 do
    begin
      s := '';
      jarr[i].TryGetValue('Item',s);
      if s = 'int_guardianfsdbooster_size1' then rangeBoost := 4.00 else
      if s = 'int_guardianfsdbooster_size2' then rangeBoost := 6.00 else
      if s = 'int_guardianfsdbooster_size3' then rangeBoost := 7.75 else
      if s = 'int_guardianfsdbooster_size4' then rangeBoost := 9.25 else
      if s = 'int_guardianfsdbooster_size5' then rangeBoost := 10.50 else
      if s = 'int_hyperdrive_overcharge_size7_class5' then minFuel := 12.00;

    end;
  except
  end;

  FBaseJumpRange := nominalRange - rangeBoost;
  FHullMass := j.GetValue<Extended>('UnladenMass');
  FFuelMass := j.GetValue<Extended>('FuelCapacity.Main');

  FMaxJumpRange := FBaseJumpRange * (FHullMass + minFuel)/ (FHullMass + FFuelMass) + rangeBoost;
  FLadenJumpRange := FBaseJumpRange * (FHullMass  + minFuel) / (FHullMass + FFuelMass + FCapacity) + rangeBoost;
end;


procedure TEDDataSource.UpdateFromJournal(fn: string; jrnl: TStringList);
var j: TJSONObject;
    jarr: TJSONArray;
    js,s,s2,tms,event,mID,entryId: string;
    i,i2,cpos,q: Integer;
    cd: TConstructionDepot;
    m: TMarket;
    sys: TStarSystem;
label LUpdateTms;

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

        if (s<>'Commander') and

//core events
           (s<>'Loadout') and
           (s<>'Docked') and
           (s<>'ColonisationConstructionDepot') and

//delivery time only
           (s<>'Undocked') and

//fleet carrier names, body names
          (s<>'SupercruiseDestinationDrop') and
          (s<>'SupercruiseExit') and
          (s<>'ApproachSettlement') and

//updates to all markets
           (s<>'MarketBuy') and
//updates to fleet carriers only
           (s<>'MarketSell') and
           (s<>'CarrierTradeOrder') and
           (s<>'CargoTransfer') and
//star system info
           (s<>'FSDJump') and
           (s<>'ColonisationSystemClaim') and
           (s<>'ColonisationSystemClaimRelease') {and
           (s<>'Scan') and
           (s<>'FSSBodySignals')   }
           //Location ???

//ModuleStore/ModuleRetrieve - to supplement Loadout event?

            then continue;
        event := s;

        if FDoingBackup then
        begin
          System.IOUtils.TFile.AppendAllText(FWorkingDir + FBackupFile,js+Chr(13),TEncoding.ASCII);
          continue;
        end;

        j := TJSONObject.ParseJSONValue(jrnl[i]) as TJSONObject;
        tms := j.GetValue<string>('timestamp');
        //line index should be enough to track new events, tms is added to be 100% sure...
        entryId := tms + '.' + IntToStr(i).PadLeft(6);
        if entryId <= FLastJrnlTimeStamps.Values[fn] then continue;

//        event := j.GetValue<string>('event');
        if event = 'Commander' then
        begin
          s := j.GetValue<string>('FID');
          FCommanders.Values[s] := j.GetValue<string>('Name');
          FCurrentCmdr := s;
          goto LUpdateTms;
        end;

        if event = 'Loadout' then
        begin
          FCapacity := j.GetValue<Integer>('CargoCapacity');
          CalcShipRanges(j);
          goto LUpdateTms;
        end;


        if event = 'FSDJump' then
        begin
          j.TryGetValue<string>('StarSystem',FCurrentSystem);
          StarSystems.UpdateFromFSDJump(js,j);
          goto LUpdateTms;
        end;

        if event = 'ColonisationSystemClaim' then
        begin
          StarSystems.UpdateArchitect(FCurrentCmdr,j);
          goto LUpdateTms;
        end;

        if event = 'ColonisationSystemClaimRelease' then
        begin
          StarSystems.UpdateArchitect('',j);
          goto LUpdateTms;
        end;

        if event = 'Scan' then
        begin
          StarSystems.UpdateBodyScan(js,j);
          goto LUpdateTms;
        end;

        if event = 'FSSBodySignals' then
        begin
          StarSystems.UpdateBodySignals(js,j);
          goto LUpdateTms;
        end;

        if event = 'SupercruiseExit' then
        begin
          s:= j.GetValue<string>('StarSystem');
          cd := DepotFromId(FLastDropId);
          if cd <> nil then
            cd.Body := Copy(j.GetValue<string>('Body'),Length(s)+1,200);
          {
          m := MarketFromId(FLastDropId);
          if m <> nil then
            m.Body := Copy(j.GetValue<string>('Body'),Length(s)+1,200);
          }
          FLastDropId := '';
          goto LUpdateTms;
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
              m.StationName2 := s;
              if FSimDepot.MarketID = mID then
                FSimDepot.StationName2 := m.StationName2;
            end;
          end;
          FLastDropId := mID;
        end;

        if event = 'ApproachSettlement' then
        begin
          FLastDropId := mID;
        end;

        if event = 'Undocked' then
        begin
          if mID = FLastDockDepotId then
            if FLastConstrDockTime <> '' then
              RemoveIdleDockTime(tms);
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
              s := Copy(s,cpos+19,200) + '/Primary';
            cd.StationName := s;
            cd.StarSystem := j.GetValue<string>('StarSystem');
            try
              cd.DistFromStar := Trunc(j.GetValue<single>('DistFromStarLS')); 
            except end;
            cd.LastDock := tms;
            cd.LastUpdate := tms;

            //if not FInitialLoad then
              UpdateDockTime(tms,cd);
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
                if m.StationType = 'FleetCarrier' then
                  //if FCargo.ShipTotal = FCapacity then  //track only full deliveries to FC?
                  begin
                    if mID = FSimDepot.MarketID then
                      UpdateDockTime(tms,FSimDepot);
                  end;

                s := '';
                jarr := j.GetValue<TJSONArray>('StationEconomies');
                for i2 := 0 to jarr.Count - 1 do
                begin
                  s := s +
                    Copy(jarr.Items[i2].GetValue<string>('Name_Localised'),1,4) + ' ' +
                    Copy(jarr.Items[i2].GetValue<string>('Proportion'),1,4) + '; ';
                end;
                m.Economies := s;
                if tms <= m.LastUpdate then
                  m.MarketEconomies := s;

                if FMarket.MarketID = mID then
                  FMarket.MarketEconomies := s;

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
              sys := FStarSystems.SystemByName[cd.StarSystem];
              if sys <> nil then sys.PrimaryDone := True;
              FLastConstructionDone := mID;
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

          if (event = 'MarketBuy') then
            FLastMarketId := mID;
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
            if FMarket.MarketID = mID then
            begin
              FMarket.Stock.Assign(m.Stock);
              FMarket.LastUpdate := tms;
            end;

          end;
        end;

LUpdateTms:;
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

procedure TEDDataSource.ResetDockTimes;
begin
  FLastConstrDockTime := '';
  FLastDockDepotId := '';
  FLastMarketId := '';
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
          begin
            m.MarketEconomies := m.Economies;
            FRecentMarkets.AddObject(m.MarketID,m);
          end
          else
          begin
            with TMarket(FRecentMarkets.Objects[idx]) do
            begin
              Status := m.Status;
              LastUpdate := m.LastUpdate;
              MarketEconomies := Economies; //copy from station
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
    ams: TMarket;
begin
  if FInitialLoad then Exit;

  ams := nil;
  if Opts.Flags['AutoSnapshots'] then
  begin
    ams := MarketFromId(FMarket.MarketID);
    if ams <> nil then
//      if DataSrc.LastConstrTimes.Values[m.StarSystem] > m.LastUpdate then
      if not ams.HoldSnapshots and (ams.MarketEconomies <> '') and (ams.Economies <> ams.MarketEconomies) then
      begin
        ams.HoldSnapshots := True; //prevent further auto snapshots in case market update fails
        CreateMarketSnapshot(ams.MarketId);
      end;
  end;

  fn := FWorkingDir + 'markets\' + FMarket.MarketID + '.json';
  if forcef or FileExists(fn) or Opts.Flags['TrackMarkets'] then
  begin
    CopyFile(PChar(FMarketJSON),PChar(fn),false);
    LoadMarket(fn);
    if ams <> nil then
      if ams.MarketEconomies = ams.Economies then
        ams.HoldSnapshots := False;
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
var i,res: Integer;
    srec: TSearchRec;
begin
  res := FindFirst(FWorkingDir + 'markets\*.json', faAnyFile, srec);
  while res = 0 do
  begin
    LoadMarket(FWorkingDir + 'markets\' + srec.Name);
    res := FindNext(srec);
  end;
  FindClose(srec);

end;

procedure TEDDataSource.LoadColony(fn: string);
var sl: TStringList;
    js: string;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile(fn);
    js := sl.Text;
    StarSystems.AddFromJSON(js);
  finally
    sl.Free;
  end;
end;

procedure TEDDataSource.LoadAllColonies;
var i,res: Integer;
    srec: TSearchRec;
begin
  res := FindFirst(FWorkingDir + 'colonies\*.json', faAnyFile, srec);
  while res = 0 do
  begin
    LoadColony(FWorkingDir + 'colonies\' + srec.Name);
    res := FindNext(srec);
  end;
  FindClose(srec);

end;

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


procedure TEDDataSource.Update;
var sl: TStringList;
    fn,jsd: string;
    res: Integer;
    fa: DWord;
    srec: TSearchRec;
    tc: DWORD;
begin

//  tc := GetTickCount;

  sl := TStringList.Create;

//  FDataChanged := False;

  try

//  tc := GetTickCount;

    UpdateCargo;
    UpdateMarket;

//  tc := GetTickCount - tc;
//  tc := GetTickCount;

    fn := '';
    jsd := Opts['JournalStart'];
    //this full folder scan supports multiple game clients on one machine
    //todo: optimize the loop to scan only latest files
    res := FindFirst(FJournalDir + 'journal.*.log', faAnyFile, srec);
    while res = 0 do
    begin
      if LowerCase(srec.Name) >= ('journal.' + jsd) then
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

//  tc := GetTickCount - tc;
//  tc := GetTickCount;

    UpdateSimDepot;
    //UpdateCapacity; //if Loadout event turns out to be not enough

  finally
    sl.Free;
  end;

end;

procedure TEDDataSource.DoBackup;
var sl: TStringList;
    fn,jsd: string;
    res: Integer;
    fa: DWord;
    srec: TSearchRec;
begin
  sl := TStringList.Create;
  try
    FDoingBackup := True;
    FBackupFile := 'journal.' + DateToISO8601(Date-2) + '.log';
    FBackupFile := FBackupFile.Replace(':','');
    fn := '';
    jsd := Opts['JournalStart'];
    res := FindFirst(FJournalDir + 'journal.*.log', faAnyFile, srec);
    while res = 0 do
    begin
      fn := LowerCase(srec.Name);
      if fn >= ('journal.' + jsd) then
      if fn <= FBackupFile then
      begin
        sl.Clear;
        try _share_LoadFromFile(sl,FJournalDir + srec.Name); except end;
        UpdateFromJournal(srec.Name,sl);
      end;
      res := FindNext(srec);
    end;
    FindClose(srec);
  finally
    sl.Free;
    FDoingBackup := False;
  end;
end;

procedure TEDDataSource.Load;
var sl: TStringList;
begin
  DataSrc.Update;

  {
  sl := TStringList.Create;
  try
    sl.LoadFromFile(FWorkingDir + 'journal_backup.json');
    UpdateFromJournal'journal_backup.json',sl);

    sl.LoadFromFile(FWorkingDir + 'journal_custom.json');
    UpdateFromJournal'journal_custom.json',sl);
  except end;
  sl.Free;
   }

  FInitialLoad := False;
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
        ', "sEconomies":"' + m.MarketEconomies + '"' +
        Copy(s,p,Length(s));
      sl.Text := s;
      sl.SaveToFile(fn2);
      LoadMarket(fn2);
      SetDataChanged;
    finally
      sl.Free;
    end;
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

  DataSrc := self;

  FWorkingDir := GetCurrentDir + '\';

  FillChar(JSONFormatSettings, SizeOf(JSONFormatSettings), 0);
//  JSONFormatSettings.ThousandSeparator := '';
  JSONFormatSettings.DecimalSeparator := '.';

  try CreateDir(FWorkingDir + 'markets'); except end;
  try CreateDir(FWorkingDir + 'colonies'); except end;

  FCommanders := TStringList.Create;

  FMarket := TMarket.Create;
  FCargo := TStock.Create;
  FSimDepot := TConstructionDepot.Create;
  FSimDepot.Simulated := True;
  FFileDates := THashedStringList.Create;
  FLastConstrTimes := THashedStringList.Create;
  FConstructions := THashedStringList.Create;
  FRecentMarkets := THashedStringList.Create;
  FMarketSnapshots := THashedStringList.Create;
  FMarketComments := THashedStringList.Create;
  FMarketLevels := THashedStringList.Create;
  FMarketGroups := THashedStringList.Create;
  FStarSystems := TSystemList.Create;
  FItemCategories := THashedStringList.Create;
  FItemNames := THashedStringList.Create;
  FLastJrnlTimeStamps := THashedStringList.Create;
  FDataChanged := false;

  FInitialLoad := true;

  LoadAllColonies;
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
