unit DataSource;

interface

uses Winapi.Windows, Winapi.Messages, Winapi.PsAPI, System.Classes, System.SysUtils,
  System.JSON, System.IOUtils, System.IniFiles, System.DateUtils, System.StrUtils,
  System.Types, Settings, Vcl.ExtCtrls,Vcl.Dialogs, System.Net.HttpClient,
  System.Net.HttpClientComponent,  System.Generics.Collections, System.Math;

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

type TEconomy = (
//do not change order!
  ecoAgri,
  ecoExtr,
  ecoHigh,
  ecoIndu,
  ecoMili,
  ecoRefi,
  ecoServ,
  ecoTour,
  ecoTerr,
  ecoColo,
  ecoInhe );

type TEconomyArray = array [Low(TEconomy)..High(TEconomy)] of Extended;

procedure ClearEconomies(var a: TEconomyArray);
procedure AddEconomies(var a: TEconomyArray; b: TEconomyArray);
procedure SubEconomies(var a: TEconomyArray; b: TEconomyArray);
function FormatEconomies(Economies: TEconomyArray): string;
function EconomiesMatch(e1,e2: string): Boolean;
function GetStationTypeAbbrev(name: string): string;
function GetFactionAbbrev(name: string): string;
function GetStarSystemAbbrev(name: string; const addEllipsis: Boolean = true): string;

const cEconomyNames: array [Low(TEconomy)..High(TEconomy)] of string = (
  'Agricultural',
  'Extraction',
  'Hightech',
  'Industrial',
  'Military',
  'Refinery',
  'Service',
  'Tourism',
  'Terraforming',
  'Colony',
  'Inherent');



type TEconomySet = class
  SetType: string;
  Condition: string;
  Exclude: string;
  Economies: TEconomyArray;
end;

type TConstructionType = class
  Id: string;
  Tier: string;
  Location: string;
  Category: string;
  StationType: string;
  Size: string;
  Layouts: string;
  Economy: string;
  Influence: string;
  Requirements: string;
  Score: Integer;
  CP2: Integer;
  CP3: Integer;
  MaxPad: string;
  InitPop: Integer;
  MaxPop: Integer;
  SecLev: Integer;
  TechLev: Integer;
  WealthLev: Integer;
  StdLivLev: Integer;
  DevLev: Integer;
  InitPopInc: Integer;
  EstCargo: Integer;
  ResourcesRequired: TStock;
  MinResources: TStock;
  MaxResources: TStock;
  function StationType_full: string;
  function StationType_abbrev: string;
  function IsOrbital: Boolean;
  function IsPort: Boolean; //a 'port' in economy meaning, ie. accepts weak links and uplinks
  constructor Create;
end;

type TConstructionTypes = class (THashedStringList)
  function GetTypeById(const Id: string): TConstructionType;
  function GetTypeByIdx(const Idx: Integer): TConstructionType;
public
  property TypeById[const Id: string]: TConstructionType read GetTypeById;
  property TypeByIdx[const Idx: Integer]: TConstructionType read GetTypeByIdx;
  procedure PopulateList(sl: TStrings);
  procedure Load;
end;

type
TStarSystem = class;
TConstructionDepot = class;
TMarket = class;

TSystemBody = class
private
  FBaseEconomies: TEconomyArray;
  FEconomyBonuses: TEconomyArray;
  FEconomiesUpdated: Boolean;
  FParentBody: TSystemBody;
public
  SysData: TStarSystem;
  BodyName: string;
  BodyID: string;
  BodyType: string; //StarType or PlanetClass
  DistanceFromArrivalLS: Extended;
  TidalLock: Boolean;
  Terraformable: Boolean;
  Landable: Boolean;
  IsRing: Boolean;
  HasRings: Boolean;
  Atmosphere: string;
  AtmosphereType: string;
  Volcanism: string;
  SurfaceGravity: Extended;
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
  ReserveLevel: string;
  Scan: string;
  FeaturesModified: Boolean;
  Parent: string;
  Rings: TList;
  Constructions: TList; //this is only populated on demand, eg. in System View;
  SurfLinkHub: TConstructionDepot;
  OrbLinkHub: TConstructionDepot;
  Comment: string;
  PrimaryLoc: Boolean;
  procedure UpdateEconomies;
  function Economies: TEconomyArray;
  function BaseEconomies: TEconomyArray;
  function EconomyBonuses: TEconomyArray;
  function Economies_nice: string;
  function ParentBody: TSystemBody;
  constructor Create;
end;

TStarSystem = class
private
  FFactions: string;
  FArchitect: string;
  FAlterName: string;
  FBodies: TStringList;
  FResourceReserve: string;
  FShared: Boolean;
  function GetFactions_short: string;
  function GetFactions_full: string;
  function GetArchitectName: string;
  procedure SetArchitectByName(s: string);
  procedure SetArchitect(s: string);
  procedure SetAlterName(s: string);
  procedure Delete;
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
  SystemScan_EDSM: string;
  ClaimDate: string;
  PrimaryDone: Boolean;
  PrimaryPortId: string;
  LastCmdr: string;
  Comment: string;
  CurrentGoals: string;
  Objectives: string;
  Ignored: Boolean;
  NavBeaconScan: Boolean;
  OrbitalSlots: Integer;
  SurfaceSlots: Integer;
  TaskGroup: string;
  MapKey: Integer;
  Constructions: TList; //on demand, eg. in Map View;
  Stations: TList; //on demand, eg. in Map View;
  NearestColony: TStarSystem; //on demand, Map View only
  function ResourceReserve: string;
  function DistanceTo(s: TStarSystem): Double;
  function PopForTimeStamp(tms: string): Int64;
  procedure AddPopToHistory(tms: string; pop: Int64);
  function TryAddBodyFromId(orgBodyId: string): TSystemBody;
  procedure AddScan(js: string; j: TJSONObject);
  procedure AddSignals(js: string; j: TJSONObject);
  function BodyByName(name: string): TSystemBody;
  function BodyById(id: string): TSystemBody;
  function GetFactions(abbrevf: Boolean; majorf: Boolean): string;
  function GetScore: Integer;
  procedure UpdateBodies_EDSM;
  procedure UpdateFromScan_EDSM;
  procedure ResetEconomies;
  function ImagePath: string;
  procedure UpdateSave;
  procedure Save(const sharedf: Boolean = false);
  procedure SaveToShared;
  constructor Create;
  destructor Destroy;
published
  property Factions: string read GetFactions_short;
  property Bodies: TStringList read FBodies;
  property Factions_full: string read GetFactions_full;
  property ArchitectName: string read GetArchitectName write SetArchitectByName;
  property Architect: string read FArchitect write SetArchitect;
  property AlterName: string read FAlterName write SetAlterName;
end;

TBaseMarket = class
private
  FSysData: TStarSystem;
  FConstrType: TConstructionType;
  FLinkedMarket: TMarket;
  FOrbital_JRNL: Integer;
  FLinkChecked: Boolean;  //session only for auto link detection
public
  MarketID: string;
  StationName: string;
  StationName2: string; //eg. full name for carriers
  StationType: string;
  StarSystem: string;
  Body: string;
  Faction: string;
  Services: string;
  FirstUpdate: string;
  LastUpdate: string;
  LastDock: string;
  Status: string;
  Stock: TStock;
  DistFromStar: Integer;
  DockToDockTimes: TDockToDockTimes;
  MarketLevel: TMarketLevel;
  Comment: string;
  ConstructionType: string;
  Modified: Boolean;
  LinkedMarketId: string;
  BuildOrder: Integer;
  Layout: string;
  NameModified: Boolean;
  IsOrphan: Boolean;  //body not found in system
  MPads: Integer;
  LPads: Integer;
  function GetSys: TStarSystem;
  function Faction_short: string;
  function FullName: string;
  function StationName_full: string;
  function StationName_abbrev(const addLink: Boolean = false): string;
  function StarSystem_nice: string;
  function DistanceTo(m: TBaseMarket): Extended;
  function DistanceTo_string(m: TBaseMarket): string;
  function GetComment: string;
  function GetConstrType: TConstructionType;
  function IsPrimary: Boolean;
  function IsOrbital: Boolean;
  function GetLinkedMarket: TMarket;
  function GetMarketLevel: TMarketLevel;
  procedure Clear;
  constructor Create;
  destructor Destroy;
end;

TMarket = class (TBaseMarket)
  Economies: string; //this changes on dock
  MarketEconomies: string; //this changes on market visit
  HoldSnapshots: Boolean;
  Snapshot: Boolean;
end;

TConstructionDepot = class (TBaseMarket)
  Finished: Boolean;
  DepotComplete: Boolean; //player actually docked and finished the construction?
  Planned: Boolean;
  Simulated: Boolean;
  ActualHaul: Integer;
  LinkHub: Boolean; //true if a port is collecting links; irrelevant for facilities
  CustomRequest: string;
  ReplacedWith: string; //session only, when player's construction is replaced with actual one by name
  procedure UpdateHaul;
  procedure PasteRequest;
  function InProgress: Boolean;
end;

type TEconomySets = class
  Bodies: TStringList;
  Stations: TStringList;
  Bonuses: TStringList;
  Links: TStringList;
  WeakLinks: TStringList;
  UpLinks: TStringList;
//  function GetEcoSet(sl: TStringList; idx: Integer): TEconomySet;
  function GetStationEconomies(cd: TConstructionDepot; b: TSystemBody): TEconomyArray;
  function GetStationEconomies_nice(cd: TConstructionDepot; b: TSystemBody): string;
  function GetLinkEconomies(cd: TConstructionDepot; b: TSystemBody): TEconomyArray;
  function GetWeakLinkEconomies(cd: TConstructionDepot): TEconomyArray;
  function GetUpLinkEconomies(cd: TConstructionDepot; b: TSystemBody): TEconomyArray;
  function GetLinkEconomies_nice(cd: TConstructionDepot; b: TSystemBody): string;
  procedure Load;
  constructor Create;
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
  function AddFromName(name: string): Boolean;
  function AddNeighbours_EDSM(origin: string): Integer; //15Ly
  function AddNeighbours2_EDSM(originSys: TStarSystem): Integer; //two-hop max
  procedure RemoveFromName(name: string; const delf: Boolean = true);
  constructor Create;
end;

type TStarRoute = class (TStringList)
public
  Active: Boolean;
  procedure StartRoute(sl: TStringList);
  procedure StopRoute;
end;

type TConstructionList = class (THashedStringList)
  function GetConstrByName(const Sys,Name: string): TConstructionDepot;
  function GetConstrByIdx(const idx: Integer): TConstructionDepot;
public
  function FindCustomConstr(Sys,Name,Body: string; ActHaul: Integer): TConstructionDepot;
  property ConstrByName[const Sys,Name: string]: TConstructionDepot read GetConstrByName;
  property ConstrByIdx[const idx: Integer]: TConstructionDepot read GetConstrByIdx; default;
//  constructor Create;
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
    FConstructions: TConstructionList;
    FCargoExt: TMarket;
    FSimDepot: TConstructionDepot;
//    FMissions: TConstructionDepot;  //test
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
    FLastBody: string;
    FDoingBackup: Boolean;
    FBackupFile: string;
    FLastConstructionDone: string;
    FConstructionTypes: TConstructionTypes;
    FEconomySets: TEconomySets;
    FEconomyList: THashedStringList;
    FPreventNotify: Boolean; //todo: change to counter!
    FCurrentRoute: TStarRoute;
    FRoutes: TStringList;
    FDocked: Boolean;
    FProcessedEvents: THashedStringList;

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

    property Constructions: TConstructionList read FConstructions;
    property StarSystems: TSystemList read FStarSystems;
    property Commanders: TStringList read FCommanders;
    property RecentMarkets: THashedStringList read FRecentMarkets;
    property MarketSnapshots: THashedStringList read FMarketSnapshots;
    property LastConstrTimes: THashedStringList read FLastConstrTimes;

    //todo: gradually move all to TBaseMarket
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
    property ConstructionTypes: TConstructionTypes read FConstructionTypes;
    property EconomySets: TEconomySets read FEconomySets;
    property CurrentRoute: TStarRoute read FCurrentRoute;
    property Routes: TStringList read FRoutes;
    property Docked: Boolean read FDocked;
    procedure MarketToSimDepot(mID: string);
    procedure MarketToCargoExt(mID: string);
    procedure CreateMarketSnapshot(mID: string);
    procedure RemoveMarketSnapshot(mID: string);
    function MarketFromID(id: string): TMarket;
    function LastFC: TMarket;
    function CurrentSystem: TStarSystem;
    function DepotFromID(id: string): TConstructionDepot;
    procedure UpdateSecondaryMarket(forcef: Boolean);
    procedure RemoveSecondaryMarket(m: TMarket);
    procedure RemoveConstruction(cd: TConstructionDepot);
    procedure UpdateSystemStations;
    procedure SetMarketLevel(mID: string; level: TMarketLevel);
    function GetMarketLevel(mID: string): TMarketLevel;
    procedure UpdateMarketComment(mID: string; s: string);
    procedure UpdateMarketGroup(mID: string; s: string; delf: Boolean);
    procedure AddListener(Sender: IEDDataListener);
    procedure RemoveListener(Sender: IEDDataListener);
    procedure GetUniqueGroups(sl: TStringList);
    procedure ResetDockTimes;
    function EcoFromName(s: string): TEconomy;
    procedure SetRoute(name,systems:string);
//    property DataChanged: Boolean read FDataChanged;
    procedure Load;
    procedure BeginUpdate;
    procedure EndUpdate(const forceNotifyf: Boolean = True);
    procedure DoBackup;
    constructor Create(Owner: TComponent); override;
end;

procedure __log_except(fname: string;info: string);

const cMinDockToDockTime: Integer = 3; //minutes
      cMaxDockToDockTime: Integer = 60;

var DataSrc: TEDDataSource;
    JSONFrmt: TFormatSettings;

implementation

{$R *.dfm}

uses Main,Clipbrd;


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

function GetFactionAbbrev(name: string): string;
var i: Integer;
    sarr: TStringDynArray;
begin
  Result := '';
  if name = '' then Exit;
  sarr := SplitString(name,' ');
  for i := 0 to High(sarr) - 1 do
    Result := Result + Copy(sarr[i],1,1);
  Result := Result + Copy(sarr[High(sarr)],1,3);
end;

function StripTrailVowel(s: string): string;
begin
  Result := s;
  if Result = '' then Exit;
  if s[Length(s)] in ['a','e','i','o','u','y'] then
    Result := Copy(s,1,Length(s)-1);
end;

function GetStationTypeAbbrev(name: string): string;
var i: Integer;
    sarr: TStringDynArray;
begin
  Result := '';
  if name = '' then Exit;
  sarr := SplitString(Trim(name),' ');
  for i := 0 to Min(High(sarr),1) do
  begin
    if Length(sarr[i]) <= 4 then
      Result := Result + sarr[i]
    else
      Result := Result + StripTrailVowel(Copy(sarr[i],1,4-i));
  end;
end;

function GetStarSystemAbbrev(name: string; const addEllipsis: Boolean = true): string;
var i: Integer;
    sarr: TStringDynArray;
begin
  Result := name;
  if Length(Result) <= 10 then Exit;
  Result := '';
  if Pos('-',name) > 0 then
    Result := IfThen(addEllipsis,'…','') + Trim(RightStr(name,10))
  else
  begin
    sarr := SplitString(name,' ');
    for i := 0 to High(sarr) do
      if Length(sarr[i]) <= 4 then
        Result := Result + sarr[i]
      else
        Result := Result + Copy(sarr[i],1,3);
  end;
end;

procedure ClearEconomies(var a: TEconomyArray);
var ei: TEconomy;
begin
  for ei := Low(TEconomy) to High(TEconomy) do
    a[ei] := 0;
end;

procedure AddEconomies(var a: TEconomyArray; b: TEconomyArray);
var ei: TEconomy;
begin
  for ei := Low(TEconomy) to High(TEconomy) do
    a[ei] := a[ei] + b[ei];
end;

procedure SubEconomies(var a: TEconomyArray; b: TEconomyArray);
var ei: TEconomy;
begin
  for ei := Low(TEconomy) to High(TEconomy) do
  begin
    a[ei] := a[ei] - b[ei];
    if a[ei] < 0 then a[ei] := 0;
  end;
end;

function TConstructionType.StationType_full: string;
var s: string;

  function _short(s: string): string;
  begin
    Result := s;
    if Result = 'Orbital' then Result := 'Orb.';
    if Result = 'Surface' then Result := 'Surf.';
    if Result = 'Planetary Port' then Result := 'Planet. Port';
    if Result = 'Installation' then Result := 'Inst.';
    if Result = 'Settlement' then Result := 'Settl.';
  end;

begin
  s := Size;
  if s <> '' then s := ', ' + s;
  Result := StationType;
  if Pos(Category,Result) <= 0 then
    Result := Result + ' ' + _short(Category);

  Result := Result + ' (T' + Tier + ' ' + _short(Location) + s + ')';
end;

constructor TConstructionType.Create;
begin
  ResourcesRequired := TStock.Create;
  MinResources := TStock.Create;
  MaxResources := TStock.Create;
end;

function TConstructionType.StationType_abbrev: string;
begin
  Result := GetStationTypeAbbrev(StationType + ' ' + Category);
end;

function TConstructionType.IsOrbital: Boolean;
begin
  Result := Location = 'Orbital';
end;

function TConstructionType.IsPort: Boolean;
begin
  Result := (Category = 'Planetary Port') or
           (Category = 'Outpost') or
           (Category = 'Starport');
end;


function TConstructionTypes.GetTypeById(const Id: string): TConstructionType;
var idx: Integer;
begin
  Result := nil;
  idx := IndexOf(Id);
  if idx > -1 then
    Result := TConstructionType(Objects[idx]);
end;

function TConstructionTypes.GetTypeByIdx(const Idx: Integer): TConstructionType;
begin
  Result := TConstructionType(Objects[Idx]);
end;

procedure TConstructionTypes.PopulateList(sl: TStrings);
var i: Integer;
begin
  sl.Clear;
  for i := 0 to Count - 1 do
    with TConstructionType(Objects[i]) do
    begin
      sl.AddObject(StationType_full,self.Objects[i]);
    end;
end;


procedure TConstructionTypes.Load;
var ct: TConstructionType;
    jarr,jarr2: TJSONArray;
    i,i2,q: Integer;
    sl: TStringList;
    s: string;
begin
  sl := TStringList.Create;
  try
    try
      sl.LoadFromFile(DataSrc.FWorkingDir + 'construction_types.json');
    except
      ShowMessage('Unable to load: construction_types.json');
      Exit;
    end;
    jarr := TJSONObject.ParseJSONValue(sl.Text) as TJSONArray;
    if jarr = nil then
    begin
      ShowMessage('Error in file: construction_types.json');
      Exit;
    end;
    try
      for i := 0 to jarr.Count - 1 do
      begin
        ct := TConstructionType.Create;
        jarr[i].TryGetValue<string>('Id',ct.Id);
        jarr[i].TryGetValue<string>('Tier',ct.Tier);
        jarr[i].TryGetValue<string>('Location',ct.Location);
        jarr[i].TryGetValue<string>('Category',ct.Category);
        jarr[i].TryGetValue<string>('Type',ct.StationType);
        jarr[i].TryGetValue<string>('Size',ct.Size);
        jarr[i].TryGetValue<string>('Layouts',ct.Layouts);
        jarr[i].TryGetValue<string>('Economy',ct.Economy);
        jarr[i].TryGetValue<string>('Influence',ct.Influence);
        jarr[i].TryGetValue<string>('Requirements',ct.Requirements);
        jarr[i].TryGetValue<string>('MaxPad',ct.MaxPad);
        jarr[i].TryGetValue<string>('Influence',ct.Influence);
        jarr[i].TryGetValue<Integer>('Score',ct.Score);
        jarr[i].TryGetValue<Integer>('CP2',ct.CP2);
        jarr[i].TryGetValue<Integer>('CP3',ct.CP3);
        jarr[i].TryGetValue<Integer>('InitPop',ct.InitPop);
        jarr[i].TryGetValue<Integer>('MaxPop',ct.MaxPop);
//        jarr[i].TryGetValue<Integer>('InitPopInc',ct.InitPopInc);
        jarr[i].TryGetValue<Integer>('SecLev',ct.SecLev);
        jarr[i].TryGetValue<Integer>('TechLev',ct.TechLev);
        jarr[i].TryGetValue<Integer>('WealthLev',ct.WealthLev);
        jarr[i].TryGetValue<Integer>('StdLivLev',ct.StdLivLev);
        jarr[i].TryGetValue<Integer>('DevLev',ct.DevLev);
        jarr[i].TryGetValue<Integer>('EstCargo',ct.EstCargo);

        jarr2 := nil;
        jarr[i].TryGetValue<TJSONArray>('ResourcesRequired',jarr2);
        if jarr2 <> nil then
          for i2 := 0 to jarr2.Count - 1 do
          begin
            jarr2[i2].TryGetValue<string>('Name',s);
            jarr2[i2].TryGetValue<Integer>('Quantity',q);
            ct.ResourcesRequired.Qty[s] := q;
          end;

        AddObject(ct.Id,ct);
      end;

    finally
      jarr.Free;
    end;
  finally
    sl.Free;
  end;
end;

constructor TSystemBody.Create;
begin
  Rings := TList.Create;
end;

function TSystemBody.ParentBody: TSystemBody;
begin
  Result := FParentBody;
  if Result <> nil then Exit;
  if Parent = '' then Exit;
  if SysData = nil then Exit;
  FParentBody := SysData.BodyById(Parent);
  Result := FParentBody;
end;

procedure TSystemBody.UpdateEconomies;
var features: TStringList;
    ei: TEconomy;
    i,j,idx: Integer;
    es: TEconomySet;
    s,s2: string;
    foundf,tlockf: Boolean;
    parentBody,b: TSystemBody;
begin
  parentBody := self.ParentBody;

  if self.IsRing and (parentBody <> nil) then
  begin
    FBaseEconomies := parentBody.BaseEconomies;
    FEconomyBonuses := parentBody.EconomyBonuses;
    Exit;
  end;

  for ei := Low(TEconomy) to High(TEconomy) do
  begin
    FBaseEconomies[ei] := 0;
    FEconomyBonuses[ei] := 0;
  end;

  features := TStringList.Create;

  s := LowerCase(BodyType);
  if Pos('star',s) > 0 then
  begin
    if LeftStr(s,1) = 'D' then s := s + 'white dwarf';

    for i := 0 to DataSrc.FEconomySets.Bodies.Count - 1 do
    begin
      foundf := false;
      es := TEconomySet(DataSrc.FEconomySets.Bodies.Objects[i]);
      if es.SetType = 'Star' then
        if Pos(es.Condition,s) > 0 then
        begin
          foundf := true;
          break;
        end;
      if not foundf then s := 'other star';
    end;
  end;
  features.Add(s);

  if TidalLock then
  begin
    tlockf := true;
    if parentBody <> nil then
      if (parentBody.Parent <> '') and not parentBody.TidalLock then
        tlockf := false;
    if tlockf then
      features.Add('tidally locked');
  end;
  if Terraformable then features.Add('terraformable');
  if GeologicalSignals > 0  then features.Add('geologicals');
  if BiologicalSignals > 0  then features.Add('biologicals');
  if HasRings  then features.Add('rings');
  if Volcanism <> ''  then features.Add('volcanism');
  s := self.SysData.ResourceReserve;
  if ReserveLevel <> ''  then
    s := ReserveLevel
  else
  begin
    b := parentBody;
    while b <> nil do
    begin
      if b.ReserveLevel <> '' then
      begin
        s := b.ReserveLevel;
        break;
      end
      else
        b := b.ParentBody;
    end;
  end;
  if s <> '' then
    features.Add(LowerCase(s) + ' resource');

  for i := 0 to DataSrc.FEconomySets.Bodies.Count - 1 do
  begin
    es := TEconomySet(DataSrc.FEconomySets.Bodies.Objects[i]);
    for j := 0 to features.Count - 1 do
      if Pos(es.Condition,features[j]) > 0 then
        for ei := Low(TEconomy) to High(TEconomy) do
          //body economies should NOT stack! but sometimes they do...
          if FBaseEconomies[ei] = 0 then   
            FBaseEconomies[ei] := FBaseEconomies[ei] +  es.Economies[ei];
  end;

  for i := 0 to DataSrc.FEconomySets.Bonuses.Count - 1 do
  begin
    es := TEconomySet(DataSrc.FEconomySets.Bonuses.Objects[i]);
    for j := 0 to features.Count - 1 do
      if Pos(es.Condition,features[j]) > 0 then
      begin
        for ei := Low(ei) to High(ei) do
          FEconomyBonuses[ei] := FEconomyBonuses[ei] + es.Economies[ei];
        if es.Exclude <> '' then
        begin
          idx := features.IndexOf(es.Exclude);
          if idx <> -1 then
             features[idx] := '$excluded';
        end;
      end;
  end;
  features.Free;
  FEconomiesUpdated := True;
end;

function TSystemBody.BaseEconomies: TEconomyArray;
begin
  if not FEconomiesUpdated then UpdateEconomies;
  Result := FBaseEconomies;
end;

function TSystemBody.EconomyBonuses: TEconomyArray;
begin
  if not FEconomiesUpdated then UpdateEconomies;
  Result := FEconomyBonuses;
end;

function TSystemBody.Economies: TEconomyArray;
var ei: TEconomy;
begin
  if not FEconomiesUpdated then UpdateEconomies;
  Result := FBaseEconomies;
  for ei := Low(TEconomy) to High(TEconomy) do
    if Result[ei] <> 0 then
      Result[ei] := Result[ei] + FEconomyBonuses[ei];
end;

function FormatEconomies(Economies: TEconomyArray): string;
var ei: TEconomy;
    maxv: Extended;
    s: string;
    l: TList<Integer>;
    i: Integer;
begin
  Result := '';
  l := TList<Integer>.Create;
  for ei := Low(TEconomy) to High(TEconomy) do
    if Economies[ei] <> 0 then
      l.Add(1000*Trunc(100*Economies[ei]) + Integer(ei)); //
  l.Sort;
  for i := 0 to l.Count - 1 do
  begin
    ei := TEconomy(l[i] mod 100);
    s := Copy(cEconomyNames[ei],1,4) + ' ' + FloatToStrF(Economies[ei],ffFixed,7,2,JSONFrmt) + '; ';
    Result := s + Result;
  end;
  l.Free;
end;


function EconomiesMatch(e1,e2: string): Boolean;
var sl: TStringList;
    i: Integer;
    e1s,e2s: string;
begin
  Result := (e1 = e2);
  if not Result then
  begin
    sl := TStringList.Create;
    sl.Text := e1.Replace('; ',Chr(13));
    sl.Sort;
    e1s := sl.Text;
    sl.Text := e2.Replace('; ',Chr(13));
    sl.Sort;
    e2s := sl.Text;
    Result := (e1s = e2s);
    sl.Free;
  end;
end;

function TSystemBody.Economies_nice: string;
begin
  Result := FormatEconomies(Economies);
end;


constructor TEconomySets.Create;
begin
  Bodies := TStringList.Create;
  Stations := TStringList.Create;
  Bonuses := TStringList.Create;
  Links := TStringList.Create;
  WeakLinks := TStringList.Create;
  UpLinks := TStringList.Create;
end;

function TEconomySets.GetStationEconomies(cd: TConstructionDepot; b: TSystemBody): TEconomyArray;
var ei: TEconomy;
    ct: TConstructionType;
    ecos: string;
    es: TEconomySet;
    ts: string;
    i: Integer;
begin
  for ei := Low(TEconomy) to High(TEconomy) do Result[ei] := 0;
  ct := cd.GetConstrType;
  if ct = nil then Exit;
  ecos := ct.Economy;
  if ecos = '' then Exit;
  if ecos = 'Colony' then Exit;
  ei := DataSrc.EcoFromName(ecos);

  ts := LowerCase('T' + ct.Tier + ' ' + ct.Category);
  for i := 0 to DataSrc.FEconomySets.Stations.Count - 1 do
  begin
    es := TEconomySet(DataSrc.FEconomySets.Stations.Objects[i]);
    if Pos(es.Condition,ts) > 0 then
      Result[ei] := Result[ei] + es.Economies[ecoInhe];
  end;
  if b <> nil then
  for ei := Low(TEconomy) to High(TEconomy) do
    if Result[ei] <> 0 then
      Result[ei] := Result[ei] + b.EconomyBonuses[ei];
end;

function TEconomySets.GetLinkEconomies(cd: TConstructionDepot; b: TSystemBody): TEconomyArray;
var ei: TEconomy;
    ct: TConstructionType;
    ecos: string;
    es: TEconomySet;
    ts: string;
    i: Integer;
begin
  for ei := Low(TEconomy) to High(TEconomy) do Result[ei] := 0;
  ct := cd.GetConstrType;
  if ct = nil then Exit;
  ecos := ct.Influence;
  if ecos = '' then ecos := ct.Economy;
  if ecos = '' then Exit;
  if ecos = 'Colony' then Exit;
  ei := DataSrc.EcoFromName(ecos);

  ts := LowerCase('T' + ct.Tier + ' ' + ct.Category);
  for i := 0 to DataSrc.FEconomySets.Links.Count - 1 do
  begin
    es := TEconomySet(DataSrc.FEconomySets.Links.Objects[i]);
    if Pos(es.Condition,ts) > 0 then
      Result[ei] := Result[ei] + es.Economies[ecoInhe];
  end;
  if b <> nil then
  for ei := Low(TEconomy) to High(TEconomy) do
    if Result[ei] <> 0 then
      Result[ei] := Result[ei] + b.EconomyBonuses[ei];
end;

function TEconomySets.GetUpLinkEconomies(cd: TConstructionDepot; b: TSystemBody): TEconomyArray;
var ei: TEconomy;
    ct: TConstructionType;
    ecos: string;
    es: TEconomySet;
    ts: string;
    i: Integer;
begin
  ClearEconomies(Result);
  ct := cd.GetConstrType;
  if ct = nil then Exit;
  if ct.Economy <> 'Colony' then Exit;
  ts := LowerCase('T' + ct.Tier + ' ' + ct.Category);
  for i := 0 to DataSrc.FEconomySets.UpLinks.Count - 1 do
  begin
    es := TEconomySet(DataSrc.FEconomySets.UpLinks.Objects[i]);
    if Pos(es.Condition,ts) > 0 then
      for ei := Low(TEconomy) to High(TEconomy) do
        if b.BaseEconomies[ei] > 0 then
          Result[ei] := Result[ei] + es.Economies[ecoInhe];
  end;
  if b <> nil then
  for ei := Low(TEconomy) to High(TEconomy) do
    if Result[ei] <> 0 then
      Result[ei] := Result[ei] + b.EconomyBonuses[ei];
end;

function TEconomySets.GetWeakLinkEconomies(cd: TConstructionDepot): TEconomyArray;
var ei: TEconomy;
    ct: TConstructionType;
    ecos: string;
    es: TEconomySet;
    ts: string;
    i: Integer;
begin
  for ei := Low(TEconomy) to High(TEconomy) do Result[ei] := 0;
  ct := cd.GetConstrType;
  if ct = nil then Exit;
  ecos := ct.Influence;
  if ecos = '' then
    if ct.IsPort then
      if not cd.LinkHub then
         ecos := ct.Economy; //ports that are up-linking to other ports work like facilities
  if ecos = '' then Exit;
  if ecos = 'Colony' then Exit;
  ei := DataSrc.EcoFromName(ecos);

  ts := LowerCase('T' + ct.Tier + ' ' + ct.Category);
  for i := 0 to DataSrc.FEconomySets.WeakLinks.Count - 1 do
  begin
    es := TEconomySet(DataSrc.FEconomySets.WeakLinks.Objects[i]);
    if (es.Condition = '') or (Pos(es.Condition,ts) > 0) then
      Result[ei] := Result[ei] + es.Economies[ecoInhe];
  end;
end;

function TEconomySets.GetStationEconomies_nice(cd: TConstructionDepot; b: TSystemBody): string;
var earr: TEconomyArray;
begin
  earr := GetStationEconomies(cd,b);
  Result := FormatEconomies(earr);
end;

function TEconomySets.GetLinkEconomies_nice(cd: TConstructionDepot; b: TSystemBody): string;
var earr: TEconomyArray;
begin
  earr := GetLinkEconomies(cd,b);
  Result := FormatEconomies(earr);
end;

{
function TEconomySets.GetEcoSet(sl: TStringList;idx: Integer): TEconomySet;
begin
  Result := TEconomySet(sl.Objects[idx]);
end;
}

procedure TEconomySets.Load;
var bs,bs2: TEconomySet;
    jarr: TJSONArray;
    i,i2: Integer;
    sl: TStringList;
    sarr: TStringDynArray;
    ei: TEconomy;
    dlist: TStringList;
begin
  sl := TStringList.Create;
  try
    try
      sl.LoadFromFile(DataSrc.FWorkingDir + 'economy_sets.json');
    except
      ShowMessage('Unable to load: economy_sets.json');
      Exit;
    end;
    jarr := TJSONObject.ParseJSONValue(sl.Text) as TJSONArray;
    if jarr = nil then
    begin
      ShowMessage('Error in file: economy_sets.json');
      Exit;
    end;
    try
      for i := 0 to jarr.Count - 1 do
      begin
        bs := TEconomySet.Create;
        jarr[i].TryGetValue<string>('Type',bs.SetType);
        jarr[i].TryGetValue<string>('Condition',bs.Condition);
        jarr[i].TryGetValue<string>('Exclude',bs.Exclude);
        bs.Condition := LowerCase(bs.Condition);
        bs.Exclude := LowerCase(bs.Exclude);
        for ei := Low(TEconomy) to High(TEconomy) do
          jarr[i].TryGetValue<Extended>(cEconomyNames[ei],bs.Economies[ei]);
        dlist := nil;
        if (bs.SetType = 'Star') or (bs.SetType = 'Body') then dlist := Bodies;
        if bs.SetType = 'Station' then dlist := Stations;
        if bs.SetType = 'Bonus' then dlist := Bonuses;
        if bs.SetType = 'Link' then dlist := Links;
        if bs.SetType = 'WeakLink' then dlist := WeakLinks;
        if bs.SetType = 'BodyUpLink' then dlist := UpLinks;
        if dlist = nil then continue;

        sarr := SplitString(bs.Condition,'/');
        if bs.Condition <> '' then bs.Condition := sarr[0];
        dlist.AddObject(bs.SetType + bs.Condition,bs);
        for i2 := 1 to High(sarr) do
        begin
          bs2 := TEconomySet.Create;
          bs2.SetType := bs.SetType;
          bs2.Economies := bs.Economies;
          bs2.Condition := sarr[i2];
          dlist.AddObject(bs2.SetType + sarr[i2],bs2);
        end;
      end;
    finally
      jarr.Free;
    end;
  finally
    sl.Free;
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

function TBaseMarket.GetConstrType: TConstructionType;
begin
  if (FConstrType = nil) or (ConstructionType <> FConstrType.Id) then
    FConstrType := DataSrc.ConstructionTypes.TypeById[ConstructionType];
  Result := FConstrType;
end;

function TBaseMarket.GetLinkedMarket: TMarket;
begin
  if (FLinkedMarket = nil) or (LinkedMarketId <> FLinkedMarket.MarketId) then
    if LinkedMarketId = '' then
      FLinkedMarket := nil
    else
      FLinkedMarket := DataSrc.MarketFromId(LinkedMarketId);
  Result := FLinkedMarket;
end;

function TBaseMarket.IsPrimary: Boolean;
begin
  Result := False;
  if GetSys <> nil then
    Result := (FSysData.PrimaryPortId = MarketId);
end;

function TBaseMarket.IsOrbital: Boolean;
begin
  Result := (FOrbital_JRNL = 1);
  if GetConstrType <> nil then
    Result := FConstrType.IsOrbital;
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

function TBaseMarket.GetComment: string;
begin
  Result := Comment;
  if Comment = '' then
    Result := DataSrc.FMarketComments.Values[MarketId];
end;

function TBaseMarket.GetMarketLevel: TMarketLevel;
begin
//  Result := FMarketLevel;
//  if FMarketLevel = -1 then
  Result := DataSrc.GetMarketLevel(MarketId);
end;

function TBaseMarket.StarSystem_nice: string;
var p: Integer;
begin
  Result := StarSystem;
//looks nice... but not just yet
//  p := Pos('Col 285 Sector ',Result); //custom list here?
//  if p > 0 then Result := Copy(Result,p+15,200);
end;

function TBaseMarket.StationName_full: string;
begin
  Result := StationName;
  if StationName2 <> '' then Result := StationName2;
  if Result = '' then
    if ConstructionType <> '' then
      try Result := '(' + self.GetConstrType.StationType + ')'; except end;
end;

function TBaseMarket.StationName_abbrev(const addLink: Boolean = false): string;
var link: string;
    maxlen: Integer;
begin
  Result := StationName;
  if StationName2 <> '' then Result := StationName2;
  link := Result + '/' + StarSystem;

  maxlen := Length(Opts['BaseWidthText']) * 3;
  if Length(Result) > maxlen then
    Result := Trim(Copy(Result,1,maxlen-2)) + '…';

  Result := Result + '/' + GetStarSystemAbbrev(StarSystem,false);
  if addLink then
    Result := Result + link.PadLeft(100);

end;

function TBaseMarket.GetSys: TStarSystem;
begin
  if (FSysData = nil) {or (FSysData.StarSystem <> self.StarSystem)} then
    FSysData := DataSrc.StarSystems.SystemByName[self.StarSystem];
  Result := FSysData;
end;

function TBaseMarket.Faction_short: string;
begin
  Result := GetFactionAbbrev(Faction);
end;

function TBaseMarket.DistanceTo_string(m: TBaseMarket): string;
begin
  Result := '';
  if self.GetSys <> nil then
    if m.GetSys <> nil then
      Result := FloatToStrF(GetSys.DistanceTo(m.GetSys),ffFixed,7,2);
end;

function TBaseMarket.DistanceTo(m: TBaseMarket): Extended;
begin
  Result := 0;
  if self.GetSys <> nil then
    if m.GetSys <> nil then
      Result := GetSys.DistanceTo(m.GetSys);
end;

constructor TBaseMarket.Create;
begin
  Stock := TStock.Create;
  DockToDockTimes := TDockToDockTimes.Create;
  DistFromStar := -1;
  LPads := -1;
  MPads := -1;
end;

destructor TBaseMarket.Destroy;
begin
  Stock.Free;
  DockToDockTimes.Free;
end;

procedure TConstructionDepot.PasteRequest;
var sl,sl2: TStringList;
    s: string;
    i: Integer;
    sarr: TStringDynArray;
begin
  if Status <> '' then Exit;
  if not Clipboard.HasFormat(CF_TEXT) then Exit;
  sl := TStringList.Create;
  sl2 := TStringList.Create;
  sl2.Text := CustomRequest;
  sl.Text := Clipboard.AsText;
  try
    if sl.Count > 60 then Exit;
    for i := 0 to sl.Count - 1 do
    begin
      s := Trim(sl[i]);
      sarr := SplitString(s,Chr(9));
      if High(sarr) < 1 then continue;
      sarr[1] := sarr[1].Replace('.','');
      sarr[1] := sarr[1].Replace(',','');
      sarr[1] := sarr[1].Replace(' ','');
      sl2.Values[sarr[0]] := sarr[1];
    end;
    if sl2.Count > 60 then Exit;
    CustomRequest := sl2.Text;
  finally
    sl.Free;
    sl2.Free;
  end;
end;

procedure TConstructionDepot.UpdateHaul;
var j: TJSONObject;
    resReq: TJSONArray;
    i,q,cq: Integer;
    ct: TConstructionType;
    nm,s: string;
begin
  ActualHaul := 0;
  try
    j := TJSONObject.ParseJSONValue(Status) as TJSONObject;
    try
      resReq := j.GetValue<TJSONArray>('ResourcesRequired');
      for i := 0 to resReq.Count - 1 do
      begin
        resReq.Items[i].TryGetValue<string>('Name_Localised',nm);
        resReq.Items[i].TryGetValue<Integer>('RequiredAmount',q);
        ActualHaul := ActualHaul + q;
        ct := GetConstrType;
        if ct <> nil then
        begin
          cq := ct.MinResources.Qty[nm];
          if (cq = 0) or (q < cq) then ct.MinResources.Qty[nm] := q;
          cq := ct.MaxResources.Qty[nm];
          if (cq = 0) or (q > cq) then ct.MaxResources.Qty[nm] := q;
        end;
      end;
    finally
      j.Free;
    end;
  except
  end;
end;

function TConstructionDepot.InProgress: Boolean;
begin
  Result := not Planned and not Finished;
end;

function TStarSystem.ResourceReserve: string;
var i: Integer;
begin
  Result := FResourceReserve;
  if Result <> '' then Exit;
  if FBodies.Count > 0 then
    with TSystemBody(FBodies.Objects[0]) do
      Result := ReserveLevel;
end;

function TStarSystem.DistanceTo(s: TStarSystem): Double;
begin
  Result := Sqrt(Sqr(StarPosX-s.StarPosX) + Sqr(StarPosY-s.StarPosY) + Sqr(StarPosZ-s.StarPosZ));
end;

function TStarSystem.ImagePath: string;
begin
  Result := DataSrc.FWorkingDir + 'colonies\' + StarSystem + '.png';
end;

procedure TStarSystem.ResetEconomies;
var i: Integer;
begin
  for i := 0 to FBodies.Count - 1 do
    TSystemBody(FBodies.Objects[i]).FEconomiesUpdated := False;
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
  if tms = '' then Exit;
  if PopHistory.Count > 0 then
    if pop = StrToInt64(PopHistory.ValueFromIndex[PopHistory.Count-1]) then Exit;
  PopHistory.AddPair(tms,IntToStr(pop));
end;

function TStarSystem.GetScore: Integer;
var i: Integer;
    ct: TConstructionType;
begin
  Result := 0;
  if Constructions = nil then Exit;
  for i := 0 to Constructions.Count - 1 do
    with TConstructionDepot(Constructions[i]) do
    if Finished then
    begin
      ct := GetConstrType;
      if ct <> nil then
         Result := Result+ ct.Score;
    end;
end;

function TStarSystem.GetFactions(abbrevf: Boolean; majorf: Boolean): string;
var j: TJSONObject;
    jarr: TJSONArray;
    i,i2: Integer;
    s,s2,name: string;
    infl,previnfl: Extended;
    sl,sl2: TStringList;
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
        s := GetFactionAbbrev(name);

        if not abbrevf then
          s := s + '   ' + name;

        infl := jarr.Items[i].GetValue<Extended>('Influence') * 100;
        s2 := FloatToStrF(infl,ffFixed,7,1 - Ord(majorf));
        sl.Add(s2.PadLeft(10,' ') + s + '=' + s2);
      end;

      sl.Sort;
      previnfl := 0;
      for i := sl.Count - 1 downto 0 do
      begin

        if majorf then
        begin
          infl := sl.ValueFromIndex[i].ToExtended;
          if previnfl <> 0 then
            if previnfl - infl > 10 then
              break;
          previnfl := infl;
        end;


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
  FFactions := GetFactions(true,false);
  Result := FFactions;
end;

function TStarSystem.GetFactions_full: string;
begin
  Result := GetFactions(false,false);
end;

function TStarSystem.TryAddBodyFromId(orgBodyId: string): TSystemBody;
var bodyId: string;
    b: TSystemBody;
    idx: Integer;
begin
  Result := nil;

//remove dummy body
  if FBodies.Count = 1 then
    if FBodies[0] = '?' then
    begin
      TSystemBody(FBodies.Objects[0]).Free;
      FBodies.Delete(0);
    end;

  bodyId := orgBodyId;
  bodyId := bodyId.PadLeft(6,'0');
  idx := FBodies.IndexOf(bodyId);
  if idx = -1 then
  begin
    b := TSystemBody.Create;
    b.SysData := self;
    b.BodyID := bodyId;
    FBodies.AddObject(bodyId,b);
  end
  else
    b := TSystemBody(FBodies.Objects[idx]);
  Result := b;
end;

function TStarSystem.BodyByName(name: string): TSystemBody;
var i: Integer;
begin
  Result := nil;
  for i := 0 to FBodies.Count - 1 do
    if TSystemBody(FBodies.Objects[i]).BodyName = name then
    begin
      Result := TSystemBody(FBodies.Objects[i]);
      Exit;
    end;
end;

function TStarSystem.BodyById(id: string): TSystemBody;
var idx: Integer;
begin
  Result := nil;
  idx := FBodies.IndexOf(id);
  if idx > -1 then
    Result := TSystemBody(FBodies.Objects[idx]);
end;


procedure TStarSystem.AddScan(js: string; j: TJSONObject);
var curId,curNm,s: string;
    b,b2: TSystemBody;
    i,idx: Integer;
    jarr: TJSONArray;
begin
  curId := '';
  j.TryGetValue<string>('BodyID',curId);
  curNm := '';
  j.TryGetValue<string>('BodyName',curNm);
  if Pos('Belt Cluster',curNm) > 0 then Exit;

  j.TryGetValue<string>('ScanType',s);
  if s = 'NavBeaconDetail' then NavBeaconScan := True;

  b := TryAddBodyFromId(curId);
  if b = nil then Exit;
  with b do
  begin
    Scan := js;
    BodyName := curNm;
    if LeftStr(BodyName,Length(StarSystem)) = StarSystem then
      BodyName := Copy(BodyName,Length(StarSystem) + 2,255);
    BodyType := '';
    j.TryGetValue<string>('StarType',BodyType);
    if BodyType = '' then
      j.TryGetValue<string>('PlanetClass',BodyType)
    else
      BodyType := BodyType + ' Star';
    j.TryGetValue<Extended>('DistanceFromArrivalLS',DistanceFromArrivalLS);
    j.TryGetValue<Boolean>('TidalLock',TidalLock);
    j.TryGetValue<string>('TerraformState',s);
    Terraformable := (s = 'Terraformable');

    j.TryGetValue<Boolean>('Landable',Landable);
    j.TryGetValue<string>('AtmosphereType',AtmosphereType);
    j.TryGetValue<string>('Atmosphere',Atmosphere);
    if Atmosphere.EndsWith('atmosphere') then
      Atmosphere := Copy(Atmosphere,1,Length(Atmosphere) - 11);

    j.TryGetValue<string>('Volcanism',Volcanism);
    if Volcanism.EndsWith('volcanism') then
      Volcanism := Copy(Volcanism,1,Length(Volcanism) - 10);
    if Volcanism.EndsWith('geysers') then
      Volcanism := Copy(Volcanism,1,Length(Volcanism) - 8);

    j.TryGetValue<Extended>('SurfaceGravity',SurfaceGravity);
    SurfaceGravity := SurfaceGravity / 9.80665;
    j.TryGetValue<Extended>('SemiMajorAxis',SemiMajorAxis);
    SemiMajorAxis := SemiMajorAxis / 1000000;
    j.TryGetValue<Extended>('OrbitalInclination',OrbitalInclination);
    j.TryGetValue<Extended>('OrbitalPeriod',OrbitalPeriod);
    OrbitalPeriod := OrbitalPeriod / (60*60*24);
    j.TryGetValue<Extended>('RotationPeriod',RotationPeriod);
    RotationPeriod := RotationPeriod / (60*60*24);
    j.TryGetValue<Extended>('AxialTilt',AxialTilt);

    if ReserveLevel = '' then
    begin
      j.TryGetValue<string>('ReserveLevel',ReserveLevel);
      if ReserveLevel.EndsWith('Resources') then
        ReserveLevel := Copy(ReserveLevel,1,Length(ReserveLevel) - 9);
    end;

    try
      jarr := nil;
      j.TryGetValue<TJSONArray>('Parents',jarr);
      if jarr <> nil then
      begin
        for i := 0 to jarr.Count - 1 do
        begin
          jarr[i].TryGetValue<string>('Planet',Parent);
          if Parent = '' then
            jarr[i].TryGetValue<string>('Star',Parent);
          if Parent <> '' then
          begin
            Parent := Parent.PadLeft(6,'0');
            break;
          end;
        end;
      end;
    except
    end;

    try
      jarr := j.GetValue<TJSONArray>('Rings');
      for i := 0 to jarr.Count - 1 do
      begin
        b2 := TryAddBodyFromId(b.BodyID + '.' + IntToStr(i));
        if b2 = nil then Exit;
        with b2 do
        begin
          Parent := b.BodyID;
          jarr[i].TryGetValue<string>('Name',BodyName);
          if LeftStr(BodyName,Length(StarSystem)) = StarSystem then
            BodyName := Copy(BodyName,Length(StarSystem) + 2,255);
          jarr[i].TryGetValue<string>('RingClass',s);
          idx := Pos('_',s);
          s := Copy(s,idx+1,255);
          BodyType := 'Ring - ' + s;
          IsRing := True;
          b.HasRings := True;
          b.Rings.Add(b2);
          b2.FParentBody := b;
          jarr[i].TryGetValue<Extended>('OuterRad',SemiMajorAxis);
          SemiMajorAxis := SemiMajorAxis / 1000000;
        end;
      end;
    except
    end;
  end;
end;

procedure TStarSystem.UpdateBodies_EDSM;
var req: TNetHTTPClient;
    res: IHTTPResponse;
begin
//  FFullSystemScan_EDSM := '';
//  FBodies.Clear;

  req := TNetHTTPClient.Create(nil);
  try
    res := req.Get('https://www.edsm.net/api-system-v1/bodies?systemName=' + StarSystem);
    if res.StatusCode <> 200 then
      raise Exception.Create(res.StatusText);
    SystemScan_EDSM := res.ContentAsString;
  finally
    req.Free;
  end;
  UpdateFromScan_EDSM;
end;

procedure TStarSystem.UpdateFromScan_EDSM;
var jdata: TJSONObject;
    jarr,jrings: TJSONArray;
    b,b2: TSystemBody;
    i,i2,idx: Integer;
    s,curId,curNm: string;
begin

  try
    jdata := TJSONObject.ParseJSONValue(SystemScan_EDSM) as TJSONObject;
    try
      jarr := jdata.GetValue<TJSONArray>('bodies');
      for i := 0 to jarr.Count - 1 do
      begin
        jarr[i].TryGetValue<string>('bodyId',curId);
        curId := curId.PadLeft(6,'0');
        jarr[i].TryGetValue<string>('name',curNm);
        if Pos('Belt Cluster',curNm) > 0 then continue;
        b := TryAddBodyFromId(curId);
        if b = nil then continue;
        with b do
        begin
          BodyName := curNm;
          if LeftStr(BodyName,Length(StarSystem)) = StarSystem then
            BodyName := Copy(BodyName,Length(StarSystem) + 2,255);
          BodyType := '';
          jarr[i].TryGetValue<string>('subType',BodyType);
          jarr[i].TryGetValue<Extended>('distanceToArrival',DistanceFromArrivalLS);
          jarr[i].TryGetValue<Boolean>('rotationalPeriodTidallyLocked',TidalLock);
          jarr[i].TryGetValue<string>('terraformingState',s);
          if s.StartsWith('Candidate') then Terraformable := True;
          jarr[i].TryGetValue<Boolean>('isLandable',Landable);
    //      j.TryGetValue<string>('AtmosphereType',AtmosphereType);
          jarr[i].TryGetValue<string>('atmosphereType',Atmosphere);
          if Atmosphere = 'No atmosphere' then Atmosphere := '';
          if Atmosphere.EndsWith('atmosphere') then
            Atmosphere := Copy(Atmosphere,1,Length(Atmosphere) - 11);
          jarr[i].TryGetValue<string>('volcanismType',Volcanism);
          if Volcanism = 'No volcanism' then Volcanism := '';
          if Volcanism.EndsWith('volcanism') then
            Volcanism := Copy(Volcanism,1,Length(Volcanism) - 10);
          if Volcanism.EndsWith('geysers') then
            Volcanism := Copy(Volcanism,1,Length(Volcanism) - 8);
          if Volcanism.EndsWith('Geysers') then
            Volcanism := Copy(Volcanism,1,Length(Volcanism) - 8);

          jarr[i].TryGetValue<Extended>('gravity',SurfaceGravity);
          jarr[i].TryGetValue<Extended>('semiMajorAxis',SemiMajorAxis);
          SemiMajorAxis := SemiMajorAxis * 149597.8707;  //Mm
          jarr[i].TryGetValue<Extended>('orbitalInclination',OrbitalInclination);
          jarr[i].TryGetValue<Extended>('orbitalPeriod',OrbitalPeriod);
          //OrbitalPeriod := OrbitalPeriod / (60*60*24);
          jarr[i].TryGetValue<Extended>('rotationalPeriod',RotationPeriod);
          //RotationPeriod := RotationPeriod / (60*60*24);
          jarr[i].TryGetValue<Extended>('axialTilt',AxialTilt);
          if ReserveLevel = '' then
            jarr[i].TryGetValue<string>('reserveLevel',ReserveLevel);

          try
            try
              jrings := jarr[i].GetValue<TJSONArray>('belts');
            except
              jrings := jarr[i].GetValue<TJSONArray>('rings');
            end;
            for i2 := 0 to jrings.Count - 1 do
            begin
              b2 := TryAddBodyFromId(b.BodyId + '.' + IntToStr(i2));
              if b2 = nil then Exit;
              with b2 do
              begin
                Parent := b.BodyID;
                jrings[i2].TryGetValue<string>('name',BodyName);
                if LeftStr(BodyName,Length(StarSystem)) = StarSystem then
                  BodyName := Copy(BodyName,Length(StarSystem) + 2,255);
                jrings[i2].TryGetValue<string>('type',s);
                BodyType := 'Ring - ' + s;
                IsRing := true;
                b.HasRings := True;
                b.Rings.Add(b2);
                b2.FParentBody := b;
                jrings[i2].TryGetValue<Extended>('outerRadius',SemiMajorAxis);
                SemiMajorAxis := SemiMajorAxis / 1000000;
              end;
            end;
          except
          end;
        end;
      end;
    finally
      jdata.Free;
    end;
  except

  end;
end;

procedure TStarSystem.AddSignals(js: string; j: TJSONObject);
var bodyId,s: string;
    b: TSystemBody;
    i,idx,cnt: Integer;
    jarr: TJSONArray;
begin
  if FBodies.Count = 0 then Exit;
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
    b.FEconomiesUpdated := False;
  end;
end;

procedure TStarSystem.UpdateSave;
begin
  DataSrc.BeginUpdate;
  try
    Save;
  finally
    DataSrc.EndUpdate;
  end;
end;

procedure TStarSystem.Save(const sharedf: Boolean = false);
var j: TJSONObject;
    fn,fld: string;
    sarr: TJSONArray;
    st: TJSONObject;
    i: Integer;
begin
  j := TJSONObject.Create;
  j.AddPair(TJSONPair.Create('StarSystem', StarSystem));
  j.AddPair(TJSONPair.Create('SystemAddress', SystemAddress));
  j.AddPair(TJSONPair.Create('Architect', FArchitect));
  j.AddPair(TJSONPair.Create('ArchitectName', ArchitectName));
  j.AddPair(TJSONPair.Create('AlterName', AlterName));
  j.AddPair(TJSONPair.Create('Comment', Comment));
  j.AddPair(TJSONPair.Create('CurrentGoals', CurrentGoals));
  j.AddPair(TJSONPair.Create('Objectives', Objectives));
  j.AddPair(TJSONPair.Create('Ignored', Ignored));
  j.AddPair(TJSONPair.Create('FSystemScan_EDSM', SystemScan_EDSM));
  j.AddPair(TJSONPair.Create('PrimaryPortId', PrimaryPortId));
  j.AddPair(TJSONPair.Create('OrbitalSlots', OrbitalSlots));
  j.AddPair(TJSONPair.Create('SurfaceSlots', SurfaceSlots));
  j.AddPair(TJSONPair.Create('TaskGroup', TaskGroup));
  j.AddPair(TJSONPair.Create('MapKey', MapKey));
  j.AddPair(TJSONPair.Create('StarPosX', StarPosX));
  j.AddPair(TJSONPair.Create('StarPosY', StarPosY));
  j.AddPair(TJSONPair.Create('StarPosZ', StarPosZ));

  j.AddPair(TJSONPair.Create('Population', Population));
  j.AddPair(TJSONPair.Create('SystemSecurity', SystemSecurity));
  j.AddPair(TJSONPair.Create('Factions', FFactions));
  j.AddPair(TJSONPair.Create('LastUpdate', LastUpdate));

  if sharedf then
    j.AddPair(TJSONPair.Create('Shared', True));

  sarr := TJSONArray.Create;
  j.AddPair(TJSONPair.Create('Stations', sarr));

  for i := 0 to DataSrc.Constructions.Count - 1 do
    with TConstructionDepot(DataSrc.Constructions.Objects[i]) do
      if StationType <> 'FleetCarrier' then
      if Modified and (StarSystem = self.StarSystem) then
      begin
        st := TJSONObject.Create;
        st.AddPair(TJSONPair.Create('MarketType', 'depot'));
        st.AddPair(TJSONPair.Create('MarketId', MarketId));
        st.AddPair(TJSONPair.Create('Name', StationName));
        st.AddPair(TJSONPair.Create('Body', Body));
        st.AddPair(TJSONPair.Create('ConstructionType', ConstructionType));
        st.AddPair(TJSONPair.Create('Planned', Planned));
        st.AddPair(TJSONPair.Create('Finished', Finished));
        st.AddPair(TJSONPair.Create('Comment', Comment));
        st.AddPair(TJSONPair.Create('MarketLevel', Integer(MarketLevel)));
        st.AddPair(TJSONPair.Create('LinkedMarketId', LinkedMarketId));
        st.AddPair(TJSONPair.Create('BuildOrder', BuildOrder));
        st.AddPair(TJSONPair.Create('Layout', Layout));
        st.AddPair(TJSONPair.Create('NameModified', NameModified));
        st.AddPair(TJSONPair.Create('CustomRequest', CustomRequest));
        sarr.Add(st);
      end;

  sarr := TJSONArray.Create;
  j.AddPair(TJSONPair.Create('Bodies', sarr));
  for i := 0 to FBodies.Count - 1 do
    if FBodies[i] <> '?' then
    with TSystemBody(FBodies.Objects[i]) do
      if FeaturesModified then
      begin
        st := TJSONObject.Create;
        st.AddPair(TJSONPair.Create('BodyID', BodyID));
        st.AddPair(TJSONPair.Create('BodyName', BodyName));
        st.AddPair(TJSONPair.Create('BiologicalSignals', BiologicalSignals));
        st.AddPair(TJSONPair.Create('GeologicalSignals', GeologicalSignals));
        st.AddPair(TJSONPair.Create('ReserveLevel', ReserveLevel));
        st.AddPair(TJSONPair.Create('Comment', Comment));
        st.AddPair(TJSONPair.Create('PrimaryLoc', PrimaryLoc));
        sarr.Add(st);
      end;
{
  for i := 0 to DataSrc.RecentMarkets.Count - 1 do
    with TMarket(DataSrc.RecentMarkets.Objects[i]) do
      if StationType <> 'FleetCarrier' then
      if Modified and (StarSystem = self.StarSystem) then
      begin
        st := TJSONObject.Create;
        st.AddPair(TJSONPair.Create('MarketType', 'market'));
        st.AddPair(TJSONPair.Create('MarketId', MarketId));
        st.AddPair(TJSONPair.Create('Name', StationName));
        st.AddPair(TJSONPair.Create('Body', Body));
        st.AddPair(TJSONPair.Create('Comment', Comment));
        st.AddPair(TJSONPair.Create('MarketLevel', Integer(MarketLevel)));
        sarr.Add(st);
      end;
}

  fld := 'colonies';
  if sharedf then fld := 'shared\colonies';
  
  fn := DataSrc.FWorkingDir + fld + '\' + StarSystem + '.json';
  if SystemAddress <> '' then
  begin
    DeleteFile(PChar(fn));
    fn := DataSrc.FWorkingDir + fld + '\' + SystemAddress + '.json';
  end;
  TFile.WriteAllText(fn, j.Format());
  j.Free;
end;

procedure TStarSystem.SaveToShared;
var i: Integer;
begin
  try
    CreateDir(DataSrc.FWorkingDir + 'shared');
    CreateDir(DataSrc.FWorkingDir + 'shared\colonies');
    CreateDir(DataSrc.FWorkingDir + 'shared\markets');
  except
  end;
  Save(true);
  CopyFile(
    PChar(DataSrc.FWorkingDir + 'colonies\' + StarSystem + '.png'),
    PChar(DataSrc.FWorkingDir + 'shared\colonies\' + StarSystem + '.png'), false
  );
  for i := 0 to DataSrc.RecentMarkets.Count - 1 do
    with TMarket(DataSrc.RecentMarkets.Objects[i]) do
      if StarSystem = self.StarSystem then
        CopyFile(
          PChar(DataSrc.FWorkingDir + 'markets\' + MarketId + '.json'),
          PChar(DataSrc.FWorkingDir + 'shared\markets\' + MarketId + '.json'), false
        );
end;

procedure TStarSystem.Delete;
var fn: string;
begin
  fn := DataSrc.FWorkingDir + 'colonies\' + StarSystem + '.json';
  if SystemAddress <> '' then
    fn := DataSrc.FWorkingDir + 'colonies\' + SystemAddress + '.json';
  DeleteFile(PChar(fn));
end;

function TStarSystem.GetArchitectName: string;
begin
  Result := DataSrc.Commanders.Values[Architect];
  if Result = '' then Result := Architect;
end;

procedure TStarSystem.SetArchitect(s: string);
var i: Integer;
begin
  FArchitect := s;
  //update name???
end;

procedure TStarSystem.SetArchitectByName(s: string);
var i: Integer;
begin
  FArchitect := s;
  for i := 0 to DataSrc.Commanders.Count - 1 do
    if DataSrc.Commanders.ValueFromIndex[i] = s then
    begin
      FArchitect := DataSrc.Commanders.Names[i];
      break;
    end;
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
var b: TSystemBody;
begin
  PopHistory := TStringList.Create;
  FBodies := TStringList.Create;
  FBodies.Sorted := True;
  FBodies.Duplicates := dupIgnore;

//dummy body for orphan stations
  b := TSystemBody.Create;
  b.SysData := self;
  b.BodyID := '?';
  b.BodyName := '?';
  FBodies.AddObject(b.BodyID,b);
end;

destructor TStarSystem.Destroy;
begin
  PopHistory.Free;
  FBodies.Free;
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
  inherited;
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
    px := StrToFloat(jarr[0].Value,JSONFrmt);
    py := StrToFloat(jarr[1].Value,JSONFrmt);
    pz := StrToFloat(jarr[2].Value,JSONFrmt);
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
      end;
      AddObject(name,sys);
    end;

    if sys.LastUpdate = '' then  //loaded from file or added from name?
    begin
      sys.SystemAddress := j.GetValue<string>('SystemAddress');
      sys.StarPosX := px;
      sys.StarPosY := py;
      sys.StarPosZ := pz;
    end;
    sys.SystemSecurity := j.GetValue<string>('SystemSecurity_Localised');
    try sys.SystemSecurity := SplitString(sys.SystemSecurity,' ')[0]; except end;

    // ? if pop > 0 then //glitch in journals,sometime pop is zero for long colonized systems
    sys.Population := pop;
    sys.LastUpdate := tms;
    sys.LastCmdr := DataSrc.FCurrentCmdr;
    sys.FFactions := ''; //extracted on demand
    sys.Status := js;
    if sys.SystemAddress <> '' then
      FAddresses.AddObject(sys.SystemAddress,sys);
  except
  end;
end;

procedure TSystemList.AddFromJSON(js: string);
var j: TJSONObject;
    jarr: TJSONArray;
    s, tms, mtyp, bodyId: string;
    sys: TStarSystem;
    pop: Int64;
    i,mlev: Integer;
//    cd: TConstructionDepot;
//    m: TMarket;
    bm: TBaseMarket;
    ct: TConstructionType;
    b: TSystemBody;
begin
  try
    j := TJSONObject.ParseJSONValue(js) as TJSONObject;
    try
      sys := TStarSystem.Create;
      with sys do
      begin
        StarSystem := j.GetValue<string>('StarSystem');
        SystemAddress := j.GetValue<string>('SystemAddress');
        try Architect := j.GetValue<string>('Architect'); except end;
  //      try ArchitectName := j.GetValue<string>('ArchitectName'); except end;
        try AlterName := j.GetValue<string>('AlterName'); except end;
        try Comment := j.GetValue<string>('Comment'); except end;
        j.TryGetValue<string>('CurrentGoals',CurrentGoals);
        j.TryGetValue<string>('Objectives',Objectives);
        j.TryGetValue<Boolean>('Ignored',Ignored);
        j.TryGetValue<string>('FSystemScan_EDSM',SystemScan_EDSM);
        j.TryGetValue<string>('PrimaryPortId',PrimaryPortId);
        j.TryGetValue<Integer>('OrbitalSlots',OrbitalSlots);
        j.TryGetValue<Integer>('SurfaceSlots',SurfaceSlots);
        j.TryGetValue<string>('TaskGroup',TaskGroup);
        j.TryGetValue<Integer>('MapKey',MapKey);
        j.TryGetValue<double>('StarPosX',StarPosX);
        j.TryGetValue<double>('StarPosY',StarPosY);
        j.TryGetValue<double>('StarPosZ',StarPosZ);
        j.TryGetValue<Int64>('Population',Population);
        j.TryGetValue<string>('SystemSecurity',SystemSecurity);
        j.TryGetValue<string>('Factions',FFactions);
        j.TryGetValue<Boolean>('Shared',FShared);
        j.TryGetValue<string>('LastUpdate',LastUpdate);

        if SystemScan_EDSM <> '' then
          UpdateFromScan_EDSM;

        jarr := nil;
        j.TryGetValue<TJSONArray>('Stations',jarr);
        if jarr <> nil then
        begin
          for i := 0 to jarr.Count - 1 do
          begin
            jarr[i].TryGetValue<string>('MarketType',mtyp);
            bm := nil;
            if (mtyp = '') or (mtyp = 'depot') then bm := TConstructionDepot.Create;
            //if mtyp = 'market' then bm := TMarket.Create;
            if bm = nil then continue;

            bm.Modified := True;
            jarr[i].TryGetValue<string>('MarketId',bm.MarketId);
            jarr[i].TryGetValue<string>('Name',bm.StationName);
            jarr[i].TryGetValue<string>('Body',bm.Body);
            bm.Body := Trim(bm.Body);
            jarr[i].TryGetValue<string>('Comment',bm.Comment);
            jarr[i].TryGetValue<Integer>('MarketLevel',mlev);
            jarr[i].TryGetValue<string>('Layout',bm.Layout);
            jarr[i].TryGetValue<Boolean>('NameModified',bm.NameModified);
            bm.StarSystem := StarSystem;
            bm.FSysData := sys;

            bm.MarketLevel := TMarketLevel(mlev);
            if (mtyp = '') or (mtyp = 'depot') then
            begin
              jarr[i].TryGetValue<string>('ConstructionType',bm.ConstructionType);
              jarr[i].TryGetValue<string>('LinkedMarketId',bm.LinkedMarketId);
              jarr[i].TryGetValue<Integer>('BuildOrder',bm.BuildOrder);
              jarr[i].TryGetValue<Boolean>('Finished',TConstructionDepot(bm).Finished);
              jarr[i].TryGetValue<Boolean>('Planned',TConstructionDepot(bm).Planned);
              jarr[i].TryGetValue<string>('CustomRequest',TConstructionDepot(bm).CustomRequest);
              DataSrc.FConstructions.AddObject(bm.MarketId,bm);
            end;
            if mtyp = 'market' then
            begin
              DataSrc.FRecentMarkets.AddObject(bm.MarketId,bm);
            end;
          end;
        end;

        jarr := nil;
        j.TryGetValue<TJSONArray>('Bodies',jarr);
        if jarr <> nil then
        begin
          for i := 0 to jarr.Count - 1 do
          begin
            bodyId := '';
            jarr[i].TryGetValue<string>('BodyID',bodyId);
            b := TryAddBodyFromId(bodyId);
            if b = nil then continue;
            with b do
            begin
              jarr[i].TryGetValue<string>('BodyName',b.BodyName);
              jarr[i].TryGetValue<Integer>('BiologicalSignals',b.BiologicalSignals);
              jarr[i].TryGetValue<Integer>('GeologicalSignals',b.GeologicalSignals);
              jarr[i].TryGetValue<string>('ReserveLevel',b.ReserveLevel);
              jarr[i].TryGetValue<string>('Comment',b.Comment);
              jarr[i].TryGetValue<Boolean>('PrimaryLoc',b.PrimaryLoc);
              FeaturesModified := True;
            end;
          end;
        end;
     end;

      AddObject(sys.StarSystem,sys);
      if sys.SystemAddress <> '' then
        FAddresses.AddObject(sys.SystemAddress,sys);
    finally
      j.Free;
    end;
  except
  end;
end;

function TSystemList.AddNeighbours_EDSM(origin: string): Integer;
var req: TNetHTTPClient;
    res: IHTTPResponse;
    i,bcnt: Integer;
    j: TJSONObject;
    jarr: TJSONArray;
    s,radius: string;
    sys: TStarSystem;
begin
  Result := 0;
  req := TNetHTTPClient.Create(nil);
  radius := '15';
  try
    s := origin.Replace(' ','%20');
    res := req.Get('https://www.edsm.net/api-v1/sphere-systems?systemName=' + s +
      '&radius=' + radius + '&showCoordinates=1');
    if res.StatusCode <> 200 then
      raise Exception.Create('EDSM response error: ' + IntToStr(res.StatusCode) + ' ' + res.StatusText);
    s := res.ContentAsString;
    if Copy(s,1,1) <> '[' then
      raise Exception.Create('EDSM response error: no data, try again later');

    jarr := TJSONObject.ParseJSONValue(s) as TJSONArray;
    //DataSrc.BeginUpdate;
    try
//      jarr := j.GetValue<TJSONArray>('');
      for i := 0 to jarr.Count - 1 do
      begin
        s := '';
        jarr[i].TryGetValue<string>('name',s);
        if GetSystemByName(s) <> nil then continue;
        sys := TStarSystem.Create;
        sys.StarSystem := s;
        jarr[i].TryGetValue<double>('coords.x',sys.StarPosX);
        jarr[i].TryGetValue<double>('coords.y',sys.StarPosY);
        jarr[i].TryGetValue<double>('coords.z',sys.StarPosZ);
        bcnt := 0;
        jarr[i].TryGetValue<Integer>('bodyCount',bcnt);
        sys.Comment := 'unvisited, bodies: ' + IntToStr(bcnt) + '; col. from ' + origin;
        sys.Save;
        AddObject(sys.StarSystem,sys);

        Result := Result + 1;
        if Result > 100 then Exit; //just in case things get really bad...
      end;
    finally
      jarr.Free;
      //DataSrc.EndUpdate;
    end;
  finally
    req.Free;
  end;
end;


function TSystemList.AddNeighbours2_EDSM(originSys: TStarSystem): Integer;
var req: TNetHTTPClient;
    res: IHTTPResponse;
    i,i2,bcnt: Integer;
    j: TJSONObject;
    jarr: TJSONArray;
    s,radius: string;
    sys: TStarSystem;
    nearl,farl: TSystemList;
    newf,twohopf: Boolean;
begin
  Result := 0;
  nearl := TSystemList.Create;
  farl := TSystemList.Create;
  req := TNetHTTPClient.Create(nil);
  radius := '30';
  try
    s := originSys.StarSystem.Replace(' ','%20');
    res := req.Get('https://www.edsm.net/api-v1/sphere-systems?systemName=' + s +
      '&radius=' + radius + '&showCoordinates=1');
    if res.StatusCode <> 200 then
      raise Exception.Create('EDSM response error: ' + IntToStr(res.StatusCode) + ' ' + res.StatusText);
    s := res.ContentAsString;
    if Copy(s,1,1) <> '[' then
      raise Exception.Create('EDSM response error: no data, try again later');

    jarr := TJSONObject.ParseJSONValue(s) as TJSONArray;
    try
//      jarr := j.GetValue<TJSONArray>('');
      for i := 0 to jarr.Count - 1 do
      begin
        s := '';
        jarr[i].TryGetValue<string>('name',s);
        newf := false;
        sys := GetSystemByName(s);
        if sys = nil then
        begin
          sys := TStarSystem.Create;
          sys.StarSystem := s;
          jarr[i].TryGetValue<double>('coords.x',sys.StarPosX);
          jarr[i].TryGetValue<double>('coords.y',sys.StarPosY);
          jarr[i].TryGetValue<double>('coords.z',sys.StarPosZ);
          bcnt := 0;
          jarr[i].TryGetValue<Integer>('bodyCount',bcnt);
          sys.Comment := 'unvisited, bodies: ' + IntToStr(bcnt);
          newf := true;
        end;
        if originSys.DistanceTo(sys) <= 15 then
        begin
          s := '';
          if newf then
          begin
            sys.Comment := sys.Comment + '; col. from ' + originSys.StarSystem;
            s := '$new';
          end;
          nearl.AddObject(s,sys);
        end
        else
          if newf then
            farl.AddObject('',sys);

//        if Result > 100 then Exit; //just in case things get really bad...
      end;
    finally
      jarr.Free;
    end;
    for i := farl.Count - 1 downto 0 do
    begin
      twohopf := false;
      for i2 := 0 to nearl.Count - 1 do
         if farl[i].DistanceTo(nearl[i2]) <= 15 then
         begin
           twohopf := true;
           farl[i].Comment := farl[i].Comment + '; col. thru ' + nearl[i2].StarSystem;
           break;
         end;
      if not twohopf then
      begin
        farl[i].Free;
        farl.Delete(i);
      end;
    end;
    //DataSrc.BeginUpdate;
    try
      for i := 0 to nearl.Count - 1 do
        if nearl.Strings[i] = '$new' then
        begin
          nearl[i].Save;
          self.AddObject(nearl[i].StarSystem,nearl[i]);
          Result := Result + 1;
        end;
      for i := 0 to farl.Count - 1 do
      begin
        farl[i].Save;
        self.AddObject(farl[i].StarSystem,farl[i]);
        Result := Result + 1;
      end;
    finally
      //DataSrc.EndUpdate;
    end;
  finally
    req.Free;
    nearl.Free;
    farl.Free;
  end;
end;

function TSystemList.AddFromName(name: string): Boolean;
var s: string;
    sys: TStarSystem;
begin
  Result := False;
  if GetSystemByName(name) <> nil then Exit;

  try
    sys := TStarSystem.Create;
    with sys do
    begin
      StarSystem := name;
      Save;
    end;
    AddObject(sys.StarSystem,sys);
    //FAddresses.AddObject(sys.SystemAddress,sys);
  except
  end;
  Result := True;
end;

procedure TSystemList.RemoveFromName(name: string; const delf: Boolean = true);
var s: string;
    idx: Integer;
    sys: TStarSystem;
begin
  idx := IndexOf(name);
  if idx < 0  then Exit;
  if delf then
  with TStarSystem(Objects[idx]) do
  begin
    Delete;
    Free;
  end;
  self.Delete(idx);
end;

procedure TSystemList.UpdateArchitect(cmdr: string; j: TJSONObject);
var sys: TStarSystem;
    s,tms: string;
begin
  try
    s := j.GetValue<string>('StarSystem');
    tms := j.GetValue<string>('timestamp');
    sys := GetSystemByName(s);

    if sys <> nil then
    begin
      sys.Architect := cmdr;
      if cmdr = '' then
        sys.ClaimDate := ''
      else
        sys.ClaimDate := tms;
    end;
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

procedure TStarRoute.StartRoute(sl: TStringList);
begin
  if sl.Count < 2 then Exit;
  self.Assign(sl);
  if sl[0] = DataSrc.CurrentSystem.StarSystem then
  begin
    Clipboard.AsText := sl[1];
    self.Delete(0);
  end
  else
    Clipboard.AsText := sl[0];
  Active := True;
end;

procedure TStarRoute.StopRoute;
begin
  Active := False;
end;


function TConstructionList.GetConstrByName(const Sys,Name: string): TConstructionDepot;
var i: Integer;
    cd: TConstructionDepot;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    cd := TConstructionDepot(Objects[i]);
    if cd.StarSystem = Sys then
      if cd.StationName = Name then
      begin
        Result := cd;
        break;
      end;
  end;
end;

function TConstructionList.FindCustomConstr(Sys,Name,Body: string; ActHaul: Integer): TConstructionDepot;
var i: Integer;
    cd: TConstructionDepot;
    ct: TConstructionType;
    d: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    cd := TConstructionDepot(Objects[i]);
    //check if this is user-added construction, id being UUID would also be fine
    if cd.LastUpdate = '' then
    if (cd.Planned or not cd.Finished) and (cd.StarSystem = Sys) then
    begin
      if cd.StationName = Name then
      begin
        Result := cd;
        break;
      end;

      if Body <> '' then
        if cd.Body <> body then continue;

      if cd.GetSys <> nil then
        if not cd.GetSys.PrimaryDone then
        begin
          Result := cd;
          break;
        end;


      ct := cd.GetConstrType;
      if ct <> nil then
      begin
        d := Abs(100 * (ActHaul - ct.EstCargo) div ct.EstCargo);
        if (d <= 5) then  //max. 5% dev.
        begin
          if (Result = nil) or not cd.Planned then //active constructions go first
            Result := cd;
        end;
      end;
    end;
  end;
end;

function TConstructionList.GetConstrByIdx(const idx: Integer): TConstructionDepot;
var i: Integer;
begin
  Result := TConstructionDepot(Objects[idx]);
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
  if FPreventNotify then Exit;
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
    js,s,s2,tms,event,orgevent,mID,entryId: string;
    i,i2,cpos,q,idx: Integer;
    cd,cd2: TConstructionDepot;
    m: TMarket;
    sys: TStarSystem;
    newstationf: Boolean;
label LUpdateTms;

    function DepotForMarketId(mID: string): TConstructionDepot;
    var midx: Integer;
    begin
      Result := nil;
      newstationf := False;
      midx := FConstructions.IndexOf(mID);
      if midx < 0 then
      begin
        newstationf := true;
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
      newstationf := False;
      midx := FRecentMarkets.IndexOf(mID);
      if midx < 0 then
      begin
        newstationf := true;
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

//        if FProcessedEvents.IndexOf(s) < 0  then continue; //no significant speed improvement...

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
           (s<>'Location') and
           (s<>'ColonisationSystemClaim') and
           (s<>'ColonisationSystemClaimRelease') and
           (s<>'Scan') and

           (s<>'FSSBodySignals')


//ModuleStore/ModuleRetrieve - to supplement Loadout event?

            then continue;


        event := s;
        orgevent := event;

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
          if not FCommanders.Sorted then //preloaded for testing only!
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
          FLastDropId := '';
          j.TryGetValue<string>('StarSystem',FCurrentSystem);
          StarSystems.UpdateFromFSDJump(js,j);

          if FCurrentRoute.Active then
          begin
            idx := FCurrentRoute.IndexOf(FCurrentSystem);
            if idx > - 1 then
            begin
              FCurrentRoute.Delete(idx);
              if FCurrentRoute.Count > 0 then
                Clipboard.AsText := FCurrentRoute[0];
            end;
            if FCurrentRoute.Count < 1 then
              FCurrentRoute.Active := False;
          end;

          goto LUpdateTms;
        end;

        if event = 'Location' then
        begin
          FLastDropId := '';
          j.TryGetValue<string>('StarSystem',FCurrentSystem);
          try StarSystems.UpdateFromFSDJump(js,j); except end;

          FDocked := false;
          j.TryGetValue<Boolean>('Docked',FDocked);
          if FDocked then
            event := 'Docked'
          else
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
          if FLastDropId <> '' then
          begin
            s := j.GetValue<string>('StarSystem');
            FLastBody := '';
            try
              FLastBody := j.GetValue<string>('Body');
              if not FLastBody.StartsWith(s) then
                FLastBody := ''
              else
                FLastBody := Copy(FLastBody,Length(s)+2,200);
            except end;
            if FLastBody <> '' then
            begin
              cd := DepotFromId(FLastDropId);
              if (cd <> nil) and (cd.Body = '') and (cd.StarSystem = s) then
                cd.Body := FLastBody
              else
              begin
                m := MarketFromId(FLastDropId); //station drops are at 'Station' body after weekly tick! :(((
                if (m <> nil) and (m.Body = '')  and (m.StarSystem = s) then
                  m.Body := FLastBody;
              end;
            end;
            FLastDropId := '';
          end;
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
          if m <> nil then m.FOrbital_JRNL := 1;
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
//          FLastDropId := mID;
          FLastDropId := '';

          s := j.GetValue<string>('SystemAddress');
          sys := FStarSystems.SystemByAddr[s];
          if sys <> nil then
          begin
            FLastBody := '';
            try
              FLastBody := j.GetValue<string>('BodyName');
              if not FLastBody.StartsWith(sys.StarSystem) then
                FLastBody := ''
              else
                FLastBody := Copy(FLastBody,Length(sys.StarSystem)+2,200);
            except end;
            if FLastBody <> '' then
            begin
              cd := DepotFromId(mID);
              if (cd <> nil) and (cd.Body = '') then
                cd.Body := FLastBody
              else
              begin
                m := MarketFromId(mID);
                if (m <> nil) and (m.Body = '') then
                  m.Body := FLastBody;
              end;
            end;
          end;
        end;

        if event = 'Undocked' then
        begin
          FDocked := False;
          if mID = FLastDockDepotId then
            if FLastConstrDockTime <> '' then
              RemoveIdleDockTime(tms);
        end;

        if event = 'Docked' then
        begin
          FDocked := True;
          FLastDropId := '';
          s := j.GetValue<string>('StationType');
          if s = 'FleetCarrier' then FLastFC := mID;
          s2 := j.GetValue<string>('StationName');
          if (Pos('Construction',s) > 0) or (Pos('ColonisationShip',s2) > 0) then
          begin
            cd := DepotForMarketId(mID);
            cd.StarSystem := j.GetValue<string>('StarSystem');
            s := '';
            try s := j.GetValue<string>('StationName_Localised'); except end;
            if s = '' then s := j.GetValue<string>('StationName');
            if newstationf then
              cd.FOrbital_JRNL := Ord((Pos('Orbital ',s) > 0));
            cpos := Pos(': ',s);
            if cpos > 0 then
              s := Copy(s,cpos+2,200);
            cpos := Pos('_ColonisationShip; ',s);
            if cpos > 0 then
            begin
              s := Copy(s,cpos+19,200) + '/Primary';
              cd.FOrbital_JRNL := 1;
              if cd.GetSys <> nil then
                cd.GetSys.PrimaryPortId := mID;
            end;
            if not cd.NameModified then
              cd.StationName := s;
            try
              cd.DistFromStar := Trunc(j.GetValue<single>('DistFromStarLS'));
            except end;
            if cd.Body = '' then cd.Body := FLastBody;

            cd.LastDock := tms;
            cd.LastUpdate := tms;

            //if not FInitialLoad then
            if orgevent <> 'Location' then
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
                  m.StarSystem := j.GetValue<string>('StarSystem');
                  m.StationType := j.GetValue<string>('StationType');
                  s := '';
                  try s := j.GetValue<string>('StationName_Localised'); except end;
                  if s = '' then s := j.GetValue<string>('StationName');
                  if not m.NameModified then
                    m.StationName := s;
                  //some planetary ports have no LandingPands info!
                  if m.StationType.StartsWith('Crater') then
                    if m.LPads = -1 then m.LPads := 1;
                end;

                try
                  m.DistFromStar := Trunc(j.GetValue<single>('DistFromStarLS'));
                  //these should stay with default value of -1 if getValue fails!
                  m.MPads := j.GetValue<Integer>('LandingPads.Medium');
                  m.LPads := j.GetValue<Integer>('LandingPads.Large');
                except
                end;

                m.LastDock := tms;
                if m.StationType = 'FleetCarrier' then
                  //if FCargo.ShipTotal = FCapacity then  //track only full deliveries to FC?
                  begin
                    if mID = FSimDepot.MarketID then
                      UpdateDockTime(tms,FSimDepot);
                  end;

                j.TryGetValue<string>('StationFaction.Name',m.Faction);
                if j.TryGetValue<TJSONArray>('StationServices',jarr) then
                begin
                  m.Services := '';
                  for i2 := 0 to jarr.Count - 1 do
                    m.Services := m.Services + jarr[i2].Value + ',';
                end;
                if j.TryGetValue<TJSONArray>('StationEconomies',jarr) then
                begin
                  s := '';
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

//                if newstationf and not FInitialLoad then

                if not m.FLinkChecked then
                if m.StationType <> 'FleetCarrier' then
                if m.GetSys <> nil then
                if m.GetSys.Architect <> '' then
                begin
                  cd2 := FConstructions.ConstrByName[m.StarSystem,m.StationName];
                  if (cd2 <> nil) and (cd2.LinkedMarketId = '') then
                  begin
                    cd2.LinkedMarketId := m.MarketId;
                    cd2.Modified := True;
                    cd2.GetSys.Save;
                  end;
                end;
                m.FLinkChecked := True;


              end;
            except

            end;
          end;
        end;

        if event = 'ColonisationConstructionDepot' then
        begin
          cd := DepotForMarketId(mID);
          if not cd.DepotComplete then
          begin
            newstationf := (cd.Status = '');
            cd.Status := jrnl[i];
            if cd.ActualHaul = 0 then cd.UpdateHaul;
            if (cd.FirstUpdate = '') or (tms < cd.FirstUpdate) then cd.FirstUpdate := tms;
            cd.LastUpdate := tms;
            s := j.GetValue<string>('ConstructionComplete');
            if s = 'true' then
            begin
              cd.DepotComplete := true;
              cd.Finished := true;
              sys := FStarSystems.SystemByName[cd.StarSystem];
              if sys <> nil then sys.PrimaryDone := True;
              FLastConstructionDone := mID;
              if FLastConstrTimes.Values[cd.StarSystem] < tms  then
                FLastConstrTimes.Values[cd.StarSystem] := tms;
            end;

            if newstationf and not FInitialLoad then
            begin
              //Orbital/Surface flag is not needed as of now because of est.haul differences
              cd2 := FConstructions.FindCustomConstr(cd.StarSystem,cd.StationName,
                cd.Body,cd.ActualHaul);
              if cd2 <> nil then
              begin
                cd.ConstructionType := cd2.ConstructionType;
                cd.Comment := cd2.Comment;
                cd.Modified := True;
                cd2.ReplacedWith := cd.MarketID;
                RemoveConstruction(cd2);
                cd.GetSys.Save;
              end;
            end;

          end;
        end;

        if (event = 'MarketBuy') or (event = 'MarketSell') then
        begin
          m := MarketFromId(mID);
          if m = nil then continue;
          if (event = 'MarketSell') and (m.StationType <> 'FleetCarrier') then continue;
          if m.LastUpdate < tms then
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

function TEDDataSource.CurrentSystem;
begin
  Result := TStarSystem(self.FStarSystems.SystemByName[FCurrentSystem]);
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
  //FRecentMarkets.Objects[idx].Free;
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

  BeginUpdate;
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
    EndUpdate(false);
    sl.Free;
  end;

end;

procedure TEDDataSource.DoBackup;
var sl: TStringList;
    fn,jsd: string;
    res,fnr,fcnt: Integer;
    fa: DWord;
    srec: TSearchRec;
    dt: TDateTime;

    procedure SetBkpFileName;
    begin
      FBackupFile := 'journal.' + DateToISO8601(dt) + '.backup' + IntToStr(fnr).PadLeft(3,'0') + '.log';
      FBackupFile := FBackupFile.Replace(':','');
    end;
begin
  sl := TStringList.Create;
  try
    FDoingBackup := True;
    dt := Now;
    fnr := 1;
    SetBkpFileName;
    fn := '';
    jsd := Opts['JournalStart'];
    res := FindFirst(FJournalDir + 'journal.*.log', faAnyFile, srec);
    fcnt := 0;
    while res = 0 do
    begin
      fn := LowerCase(srec.Name);
      if fn >= ('journal.' + jsd) then
      //if fn <= FBackupFile then
      begin
        sl.Clear;
        try _share_LoadFromFile(sl,FJournalDir + srec.Name); except end;
        UpdateFromJournal(srec.Name,sl);
        fcnt := fcnt + 1;
        if fcnt > 100 then
        begin
          fcnt := 0;
          fnr := fnr + 1;
          SetBkpFileName;
        end;
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
  FPreventNotify := True;
end;

procedure TEDDataSource.EndUpdate(const forceNotifyf: Boolean);
begin
  FPreventNotify := False;
  if forceNotifyf then
    NotifyListeners;
end;

procedure TEDDataSource.RemoveConstruction(cd: TConstructionDepot);
var idx: Integer;
begin
  idx := FConstructions.IndexOf(cd.MarketID);
  if idx > -1 then
  begin
    FConstructions.Delete(idx);
    //FMarketLevels.Values[cd.MarketID] := '';
  end;
  NotifyListeners;
//  cd.Free;
end;

procedure TEDDataSource.UpdateSystemStations;
var i: Integer;
    sys: TStarSystem;
begin
  for i := 0 to DataSrc.StarSystems.Count - 1 do
  begin
    sys := DataSrc.StarSystems[i];
    if sys.Constructions = nil then
      sys.Constructions := TList.Create
    else
      sys.Constructions.Clear;
    if sys.Stations = nil then
      sys.Stations := TList.Create
    else
      sys.Stations.Clear;
  end;

  for i := 0 to DataSrc.Constructions.Count - 1 do
  begin
    sys := DataSrc.Constructions[i].GetSys;
    if sys <> nil then
      if sys.Constructions <> nil then
        if not DataSrc.Constructions[i].Simulated then
          sys.Constructions.Add(DataSrc.Constructions[i]);
  end;

  for i := 0 to DataSrc.RecentMarkets.Count - 1 do
  begin
    sys := TMarket(DataSrc.RecentMarkets.Objects[i]).GetSys;
    if sys <> nil then
      if sys.Stations <> nil then
        sys.Stations.Add(DataSrc.RecentMarkets.Objects[i]);
  end;
  
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
//  FMarketSnapshots.Objects[idx].Free;
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
  for i := 0 to FStarSystems.Count - 1 do
  begin
    if FStarSystems[i].TaskGroup <> '' then sl.Add(FStarSystems[i].TaskGroup);
  end;
  if FTaskGroup <> '' then
    sl.Add(FTaskGroup);
  s := sl.Text;
  sl.Text := s.Replace(',',Chr(13));
end;

procedure TEDDataSource.SetTaskGroup(s: string);
begin
  FTaskGroup := s;
  Opts['SelectedTaskGroup'] := s;
  Opts.Save;
  NotifyListeners;
end;

function TEDDataSource.EcoFromName(s: string): TEconomy;
var idx: Integer;
begin
  Result := ecoInhe;
  idx := FEconomyList.IndexOf(s);
  if idx > -1 then Result := TEconomy(idx);
end;

procedure TEDDataSource.SetRoute(name,systems:string);
begin
  FRoutes.Values[name] := systems;
  FRoutes.SaveToFile(FWorkingDir + 'routes.txt',TEncoding.UTF8);
end;

constructor TEDDataSource.Create(Owner: TComponent);
var ei: TEconomy;
begin
  inherited Create(Owner);

  DataSrc := self;

  FWorkingDir := GetCurrentDir + '\';

  FillChar(JSONFrmt, SizeOf(JSONFrmt), 0);
//  JSONFrmt.ThousandSeparator := '';
  JSONFrmt.DecimalSeparator := '.';

  try CreateDir(FWorkingDir + 'markets'); except end;
  try CreateDir(FWorkingDir + 'colonies'); except end;

  {
  FProcessedEvents := THashedStringList.Create;
   FProcessedEvents.Add('Commander');
//core events
   FProcessedEvents.Add('Loadout');
   FProcessedEvents.Add('Docked');
   FProcessedEvents.Add('ColonisationConstructionDepot');
//delivery time only
   FProcessedEvents.Add('Undocked');
//fleet carrier names, body names
  FProcessedEvents.Add('SupercruiseDestinationDrop');
  FProcessedEvents.Add('SupercruiseExit');
  FProcessedEvents.Add('ApproachSettlement');
//updates to all markets
   FProcessedEvents.Add('MarketBuy');
//updates to fleet carriers only
   FProcessedEvents.Add('MarketSell');
   FProcessedEvents.Add('CarrierTradeOrder');
   FProcessedEvents.Add('CargoTransfer');
//star system info
   FProcessedEvents.Add('FSDJump');
   FProcessedEvents.Add('Location');
   FProcessedEvents.Add('ColonisationSystemClaim');
   FProcessedEvents.Add('ColonisationSystemClaimRelease');
   FProcessedEvents.Add('Scan');
   FProcessedEvents.Add('FSSBodySignals');
}

  FCommanders := TStringList.Create;

  //tests only
  try
    FCommanders.LoadFromFile(FWorkingDir + 'commanders.txt');
    FCommanders.Sorted := True;
  except end;

  FMarket := TMarket.Create;
  FCargo := TStock.Create;
  FSimDepot := TConstructionDepot.Create;
  FSimDepot.Simulated := True;
  FFileDates := THashedStringList.Create;
  FLastConstrTimes := THashedStringList.Create;
  FConstructions := TConstructionList.Create;
  FRecentMarkets := THashedStringList.Create;
  FMarketSnapshots := THashedStringList.Create;
  FMarketComments := THashedStringList.Create;
  FMarketLevels := THashedStringList.Create;
  FMarketGroups := THashedStringList.Create;
  FStarSystems := TSystemList.Create;
  FItemCategories := THashedStringList.Create;
  FItemNames := THashedStringList.Create;
  FLastJrnlTimeStamps := THashedStringList.Create;
  FConstructionTypes := TConstructionTypes.Create;
  FEconomySets := TEconomySets.Create;
  FCurrentRoute := TStarRoute.Create;
  FRoutes := TStringList.Create;
  FDataChanged := false;

  {
  FMissions := TConstructionDepot.Create;
  FMissions.MarketID := '$missions';
  FMissions.StationName := 'Missions';
  FMissions.Simulated := True;
  FConstructions.AddObject(FMissions.MarketID,FMissions);
  }

  FInitialLoad := true;


  FConstructionTypes.Load;
  FEconomyList := THashedStringList.Create;
  for ei := Low(TEconomy) to High(TEconomy) do
    FEconomyList.Add(cEconomyNames[ei]);
  FEconomySets.Load;

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
  try FRoutes.LoadFromFile(FWorkingDir + 'routes.txt',TEncoding.UTF8) except end;


//  UpdTimer.Enabled := True;
end;


end.
