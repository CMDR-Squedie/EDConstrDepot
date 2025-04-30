unit DataSource;


interface

uses Winapi.Windows, Winapi.Messages, Winapi.PsAPI, System.Classes, System.SysUtils, System.JSON, System.IOUtils, Settings;

type TMarket = class
  MarketID: string;
  StationName: string;
  StarSystem: string;
  LastUpdate: string;
  Status: string;
  procedure Clear;
end;

type TConstructionDepot = class (TMarket)
  Finished: Boolean;
  Simulated: Boolean;
end;


const cDefaultCapacity: Integer = 784;

type TEDDataSource = class
  private
    FMarket,FCargo,FFileDates,FCargoExt: TStringList;
    FConstructions: TStringList;
    FSimDepot: TConstructionDepot;
    FMarketComments: TStringList;
    FWorkingDir,FJournalDir: string;
    FMarketJSON,FCargoJSON,FCargoExtJSON,FModuleInfoJSON,FSimDepotJSON: string;
    FCapacity: Integer;
    FLastJrnlTimeStamp: string;
    function CheckLoadFromFile(var sl: TStringList; fn: string): Boolean;
    procedure UpdateCargo;
    procedure UpdateCargoExternal;
    procedure UpdateSimDepot;
    procedure UpdateMarket;
    procedure UpdateCapacity;
    procedure UpdateFromJournal(jrnl: TStringList);
  public
    property Constructions: TStringList read FConstructions;
    property SimDepot: TConstructionDepot read FSimDepot;
    property MarketComments: TStringList read FMarketComments;
    property Market: TStringList read FMarket;
    property Cargo: TStringList read FCargo;
    property CargoExt: TStringList read FCargoExt;
    property Capacity: Integer read FCapacity;
    procedure MarketToSimDepot;
    procedure MarketToCargoExt;
    procedure Update;
    constructor Create;
end;

var DataSrc: TEDDataSource;

implementation

procedure TMarket.Clear;
begin
  MarketID := '';
  Status := '';
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
    end;
  end;
end;

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
  end;
  sl.Free;
end;

procedure TEDDataSource.UpdateMarket;
var j: TJSONObject;
    jarr: TJSONArray;
    sl: TStringList;
    s: string;
    i: Integer;
begin
  if CheckLoadFromFile(sl,FMarketJSON) = false then Exit;
  FMarket.Clear;
  try
    j := TJSONObject.ParseJSONValue(sl.Text) as TJSONObject;
    try
      FMarket.AddPair('$MarketID',j.GetValue<string>('MarketID'));
      FMarket.AddPair('$MarketName',j.GetValue<string>('StationName') + '/' +
                      j.GetValue<string>('StarSystem'));
      FMarket.AddPair('$MarketType',j.GetValue<string>('StationType'));
      jarr := j.GetValue<TJSONArray>('Items');
      for i := 0 to jarr.Count - 1 do
      begin
        s := jarr.Items[i].GetValue<string>('Stock');
        if s > '0' then
         FMarket.AddPair(LowerCase(jarr.Items[i].GetValue<string>('Name_Localised')), s);
      end;
      if FMarket.Values['$MarketID'] = FCargoExt.Values['$MarketID'] then
        CopyFile(PChar(FMarketJSON),PChar(FCargoExtJSON),false);
      if FMarket.Values['$MarketID'] = FSimDepot.MarketID then
        CopyFile(PChar(FMarketJSON),PChar(FSimDepotJSON),false);

{
      s := FWorkingDir + 'markets\' + FMarket.Values['$MarketID'];
      if FileExists(s) then
        CopyFile(PChar(FMarketJSON),PChar(s),false);
}

    finally
      j.Free;
    end;
  except
  end;
  sl.Free;
end;

procedure TEDDataSource.UpdateCargoExternal;
var j: TJSONObject;
    jarr: TJSONArray;
    sl: TStringList;
    s: string;
    i: Integer;
begin
  if CheckLoadFromFile(sl,FCargoExtJSON) = false then Exit;
  FCargoExt.Clear;
  try
    j := TJSONObject.ParseJSONValue(sl.Text) as TJSONObject;
    try
      FCargoExt.AddPair('$MarketID',j.GetValue<string>('MarketID'));
      try
        FCargoExt.AddPair('$MarketName',j.GetValue<string>('StationName') + '/' +
          j.GetValue<string>('StationName'));
        FCargoExt.AddPair('$MarketType',j.GetValue<string>('StationType'));
      except
      end;
      jarr := j.GetValue<TJSONArray>('Items');
      for i := 0 to jarr.Count - 1 do
      begin
        s := jarr.Items[i].GetValue<string>('Stock');
        if s > '0' then
         FCargoExt.AddPair(LowerCase(jarr.Items[i].GetValue<string>('Name_Localised')), s);
      end;
    finally
      j.Free;
    end;
  except
  end;
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
      FSimDepot.LastUpdate := j.GetValue<string>('timestamp');
      FSimDepot.StationName := j.GetValue<string>('StationName');
      FSimDepot.StarSystem := j.GetValue<string>('StarSystem');
      FSimDepot.Status := sl.Text;

      FConstructions.AddObject(FSimDepot.MarketID,FSimDepot);
    finally
      j.Free;
    end;
  except
  end;
  sl.Free;
end;

procedure TEDDataSource.UpdateFromJournal(jrnl: TStringList);
var j: TJSONObject;
    jarr: TJSONArray;
    js,s,tms,event,mID: string;
    i,cpos: Integer;
    cd: TConstructionDepot;

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
        if tms < FLastJrnlTimeStamp then continue;

//        event := j.GetValue<string>('event');
        if event = 'Loadout' then
          FCapacity := j.GetValue<Integer>('CargoCapacity');

        mID := '';
        try mID := j.GetValue<string>('MarketID'); except end;
        if mID = '' then continue;

        if event = 'Docked' then
        begin
          s := j.GetValue<string>('StationType');
          if Pos('Construction',s) > 0 then
          begin
            cd := DepotForMarketId(mID);
            s := j.GetValue<string>('StationName');
            cpos := Pos(': ',s);
            if cpos > 0 then
              s := Copy(s,cpos+2,200);
            cd.StationName := s;
            cd.StarSystem := j.GetValue<string>('StarSystem');
            cd.LastUpdate := tms;
          end;
        end;

        if event = 'ColonisationConstructionDepot' then
        begin
          cd := DepotForMarketId(mID);
          cd.Status := jrnl[i];
          cd.LastUpdate := tms;
          s := j.GetValue<string>('ConstructionComplete');
          if s = 'true' then
            cd.Finished := true;
        end;

        FLastJrnlTimeStamp := tms;
      except

      end;

    finally
      j.Free;
    end;

  end;
end;

procedure TEDDataSource.Update;
var sl: TStringList;
    s,s2,fn: string;
    i,res: Integer;
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

  try

//  UpdateCapacity;
  UpdateCargo;
  UpdateMarket;
  UpdateCargoExternal;

  fn := '';
  res := FindFirst(FJournalDir + 'journal*.log', faAnyFile, srec);
  while res = 0 do
  begin
    if LowerCase(srec.Name) >= ('journal.' + FSettings.Values['JournalStart']) then
    begin
      fa := srec.FindData.ftLastWriteTime.dwLowDateTime;
      if FFileDates.Values[srec.Name] <> IntToStr(fa) then
      begin
        sl.Clear;
        try _share_LoadFromFile(sl,FJournalDir + srec.Name); except end;
        UpdateFromJournal(sl);
        FFileDates.Values[srec.Name] := IntToStr(fa);
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
end;

procedure TEDDataSource.MarketToCargoExt;
begin
//  FCargoExt.Clear;
  CopyFile(PChar(FMarketJSON),PChar(FCargoExtJSON),false);
end;

constructor TEDDataSource.Create;
begin
  FWorkingDir := GetCurrentDir + '\';

  FMarket := TStringList.Create;
  FCargo := TStringList.Create;
  FCargoExt := TStringList.Create;
  FSimDepot := TConstructionDepot.Create;
  FSimDepot.Simulated := true;
  FFileDates := TStringList.Create;
  FConstructions := TStringList.Create;
  FMarketComments := TStringList.Create;

  try FMarketComments.LoadFromFile(FWorkingDir + 'market_info.txt') except end;

  FJournalDir := System.SysUtils.GetEnvironmentVariable('USERPROFILE') +
       '\Saved Games\Frontier Developments\Elite Dangerous\';
  if FSettings['JournalDir'] <> '' then
    FJournalDir := FSettings['JournalDir'];
//  SetCurrentDir(FJournalDir);
//  FJournalDir :=  GetCurrentDir + '\';

  FMarketJSON := FJournalDir + 'market.json';
  FCargoJSON := FJournalDir + 'cargo.json';
  FModuleInfoJSON := FJournalDir + 'modulesinfo.json';
  FCargoExtJSON := FWorkingDir + 'market_cargoext.json';
  FSimDepotJSON := FWorkingDir + 'market_simdepot.json';
end;


end.
