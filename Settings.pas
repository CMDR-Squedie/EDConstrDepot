unit Settings;

interface

uses Winapi.Windows, System.SysUtils, System.Classes;

type TSettings = class (TStringList)
  private
    FDefaults: TStringList;
    FFileName: string;
    procedure SetFlag(const Name: string; v: Boolean);
    function GetFlag(const Name: string): Boolean;
    procedure SetVal(const Name: string; v: string);
    function GetVal(const Name: string): string;
    procedure SetDefaults(const Name: string; v: string);
    function GetDefaults(const Name: string): string;
  public
    property Flags[const Name: string]: Boolean read GetFlag write SetFlag;
    property Val[const Name: string]: string read GetVal write SetVal; default;
//    property Defaults[const Name: string]: string read GetDefaults write SetDefaults;
    procedure Load;
    procedure Save;
    procedure GetUserSettings(sl: TStringList);
    constructor Create(fn: string);
end;

var Opts: TSettings;

implementation

function TSettings.GetDefaults(const Name: string): string;
begin
  Result := FDefaults.Values[Name];
end;

procedure TSettings.SetDefaults(const Name: string; v: string);
begin
  FDefaults.Values[Name] := v;
end;

function TSettings.GetVal(const Name: string): string;
begin
  Result := Values[Name];
  if Result = '' then
    Result := FDefaults.Values[Name];
end;

procedure TSettings.SetVal(const Name: string; v: string);
begin
  Values[Name] := v;
end;

function TSettings.GetFlag(const Name: string): Boolean;
begin
  Result := GetVal(Name) > '0';
end;

procedure TSettings.SetFlag(const Name: string; v: Boolean);
begin
  Values[Name] := IntToStr(Ord(v));
end;

procedure TSettings.Load;
begin
  try LoadFromFile(FFileName); except end;
end;

procedure TSettings.Save;
begin
  CopyFile(PChar(FFileName),PChar(FFileName + '.bkp'),false);
  try SaveToFile(FFileName); except end;
end;

procedure TSettings.GetUserSettings(sl: TStringList);
var i: Integer;
    s: string;
begin
  sl.Clear;
  for i := 0 to FDefaults.Count - 1 do
  begin
    s := FDefaults.Names[i];
    sl.Values[s] := GetVal(s);
  end;
end;

constructor TSettings.Create(fn: string);
begin
  FDefaults := TStringList.Create;

  FDefaults.Values['FontName'] := 'Bahnschrift SemiCondensed';
  FDefaults.Values['FontSize'] := '10';
  FDefaults.Values['Color'] := 'FFA000';
  FDefaults.Values['ShowUnderCapacity'] := '1';
  FDefaults.Values['ShowProgress'] := '1';
  FDefaults.Values['ShowFlightsLeft'] := '1';
  FDefaults.Values['ShowRecentMarket'] := '1';
  FDefaults.Values['ShowBestMarket'] := '1';
  FDefaults.Values['ShowDividers'] := '1';
  FDefaults.Values['ShowIndicators'] := '1';
  FDefaults.Values['IndicatorsPadding'] := '1';
  FDefaults.Values['IncludeSupply'] := '1';
  FDefaults.Values['ShowCloseBox'] := '0';
  FDefaults.Values['TransparentTitle'] := '0';
  FDefaults.Values['ScanMenuKey'] := '0';
  FDefaults.Values['AlwaysOnTop'] := '2';
  FDefaults.Values['Backdrop'] := '0';
  FDefaults.Values['AlphaBlend'] := '64';
  FDefaults.Values['AutoHeight'] := '1';
  FDefaults.Values['AutoWidth'] := '1';
  FDefaults.Values['AutoSort'] := '2';
  FDefaults.Values['IncludeFinished'] := '1';
  FDefaults.Values['KeepSelected'] := '1';
  FDefaults.Values['TrackMarkets'] := '1';
  FDefaults.Values['AllowMoreWindows'] := '0';
  FDefaults.Values['MarketsDarkMode'] := '0';
  FDefaults.Values['AnyMarketAsDepot'] := '0'; //this enables using any market type as FC
  FDefaults.Values['BaseWidthText'] := '00000';
  FDefaults.Values['FontGlow'] := '48';
  FDefaults.Values['JournalStart'] := '2025-04-14';    //trailblazers journals start


  FFileName := fn;
  inherited Create;
end;

end.
