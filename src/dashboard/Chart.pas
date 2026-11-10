unit Chart;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Skia, Vcl.Skia, System.StrUtils, System.TypInfo,
  System.IniFiles, System.DateUtils, System.Math, Vcl.Menus, Vcl.StdCtrls, System.IOUtils,
  Datasource;

type
  //ctDual and ctCombo are special charts for displaying secondary values
  //ctDual displays a second thin column as an overlay
  //csCombo is a stacked column chart, 2nd column has its own scaling, maxed at 16% of chart height
  TChartType = (ctLine, ctColumn, ctBar, ctStacked, ctDual, ctCombo, ctScatter);
  TChartColorScheme = (csNone, csCyclic, csGolden, csRedGreen, csRedToGreen,
  csMechanical, csColdToWarm, csRedToGreen2, csCrimson, csPurYel,
  csCyan, csSunset, csFlame, csSky,
  csEmerald,csRainForest,csPeppermint,csPinkToCyan,csDawn,csLavender
 );
  TChartOption = (coReversed,coMarkers,coValLabels,coGradientX,coExtraBarSep, coMoreGridLines , {5}
                  coAvgLine,coCleanGridStep,coCategoryColors,coValueColors, coFlipColors , {10}
                  coStackColors,coAvgSkipZero, coNoTitle,coNoBackground,coNoEmpty, {15}
                  coLargeLabels,coSegmentedBar,coSharedScale,coAuxLine);
  TChartOptions = set of TChartOption;
  TDataAdjustment = (daSort, daTime3m, daTime6m, daTime12m, daTimeYTD, daTop12, daTop24, daSumSort, daExcludeZero);
  TDataAdjustments = set of TDataAdjustment;

  TChartData = class
    id: string;
    src: string; //[D]ashboard/[C]olonies/[S]ummary/[M]inicharts
    baseTitle: string;
    title: string;
//    mode: Integer;
    cmdr: string;
    sysList: TStringList;
    taskGroup: string;

    dataSeries: THashedStringList;
    chartOptions: TChartOptions;
    dataAdjustments: TDataAdjustments;
    labStep: Integer;
    topCnt: Integer;
    chartType: TChartType;
    colorScheme: TChartColorScheme;
    barThickness: Double;
    svgSource: string;
    isShared: Boolean;
    isCustom: Boolean;
    orgDataSeries: THashedStringList;
    chartObject: TObject;
    procedure InitData(chartOptions: TChartOptions; dataAdjustments: TDataAdjustments;
      labStep: Integer; chartType: TChartType; colorScheme: TChartColorScheme; const barThickness: Double = 1.0);
    constructor Create(id: string; src: string);
    destructor Destroy;
    procedure Update;
    procedure AdjustDataSeries;
    procedure ToggleDataAdj(da: TDataAdjustment);
    procedure UpdateSvg;
    procedure LoadSetup;
    procedure ResetSetup;
    procedure SaveSetup;
    procedure Assign(cd: TChartData);
  end;

  TChartForm = class(TForm)
    SvgArea: TSkSvg;
    MenuLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuLabelClick(Sender: TObject);
    procedure SvgAreaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }

//predefined charts
    FChartData: TChartData;

//custom/modified charts
{
    FDataSeries: TStringList;
    FTitle: string;
    FLabelStep: Integer;
    FChartType: TChartType;
    FColorScheme: TChartColorScheme;
    FBarThickness: Double;
    FSeriesColor: string;
    FChartOptions: TChartOptions;
    FDataAdjustments: TDataAdjustments;
}
    procedure UpdateChart;
  public
    { Public declarations }
    procedure CreateChart(chartData: TChartData);
    procedure CreateChartById(id: string; src: string; const cmdr: string = '';
      const taskGroup: string = ''; const sysList: TStringList = nil);
  end;

var
  ChartList: TStringList;

const cChartColorModes = [coGradientX,coCategoryColors,coValueColors];
const cChartTimeLines = [daTime3m,daTime6m,daTime12m,daTimeYTD];
const cChartCategoryFilters = [daTop12,daTop24];
const cChartSortModes = [daSort,daSumSort];
const cTransientOptions = [coNoTitle,coNoBackground,coNoEmpty];

procedure GetContribData(mode: Integer; cmdr: string; taskGroup: string; var dataSeries: THashedStringList);
procedure GetFinishedConstrData(mode: Integer; cmdr: string; taskGroup: string; sysList: TStringList; var dataSeries: THashedStringList);
procedure GetPopHistoryData(mode: Integer; cmdr: string; taskGroup: string; sysList: TStringList; var dataSeries: THashedStringList);
procedure GetSystemStatData(mode: Integer; groupBy: Integer; cmdr: string; taskGroup: string; sysList: TStringList; topCnt: Integer;
  var dataSeries: THashedStringList);
procedure GetScoreHistoryData(mode: Integer; cmdr: string; taskGroup: string; maxDays: Integer; sysList: TStringList; var dataSeries: THashedStringList);
procedure GetConstrTypesData(mode: Integer; cmdr: string; taskGroup: string;  sysList: TStringList; var dataSeries: THashedStringList);
procedure GetMarketData(mode: Integer; topCnt: Integer; var dataSeries: THashedStringList);
procedure GetConstrContrib(mode: Integer; cd: TConstructionDepot; cmdr: string; var dataSeries: THashedStringList);


function GenerateSVG(
  DataList: TStringList;
  const FileName, Title: string;
  const ChartOptions: TChartOptions = [];
  const LabelStep: Integer = 4;
  const ChartType: TChartType = ctLine;
  const ColorScheme: TChartColorScheme = csNone;
  const DefBarThickness: Double = 1.0;
  const DefColor: string = ''): string;

implementation

uses Settings, Clipbrd, Dashboard, Main;

{$R *.dfm}

function RainbowColor(t, Steps: Integer; const Brightness: Double = 1.0): string;
var
  p: Double;
  r, g, b: Double;
  rr, gg, bb: Integer;
begin
  if Steps <= 0 then
    Exit('#000');
  if Brightness <= 0 then
    Exit('#000');
  p := t / (Steps - 1);

  r := 0.5 + 0.5 * Sin(2 * Pi * p);
  g := 0.5 + 0.5 * Sin(2 * Pi * p + 2 * Pi / 3);
  b := 0.5 + 0.5 * Sin(2 * Pi * p + 4 * Pi / 3);

  r := r * Brightness;
  g := g * Brightness;
  b := b * Brightness;

  rr := Round(r * 255);
  gg := Round(g * 255);
  bb := Round(b * 255);

  Result := Format('#%.2x%.2x%.2x', [rr, gg, bb]);
end;

function RoundUpMaxVal(Value: Double; const Step: Double = 0.5; const Divisor: Integer = 4): Int64;
var
  Digits: Integer;
  Base: Int64;
  Normalized: Double;
begin
  if Value <= 0 then
    Exit(1);
  Digits := Trunc(Log10(Value)) + 1;
  Base := Max(Trunc(Power(10, Digits - 1) * Step),1);
  if Divisor > 1 then
    Base := ((Base + Divisor - 1) div Divisor) * Divisor;
  Normalized := Value / Base;
  Normalized := Ceil(Normalized);
  Result := Trunc(Normalized * Base);
end;

function RedToGreen(t: Double): string;
const
  MaxC = 255;
  MinC = 128;
  HiLoCompress = 0.1;
var
  r, g, b: Integer;
  p: Double;
begin
  if t < 0 then t := 0;
  if t > 1 then t := 1;
  b := 0;
  if t < HiLoCompress then
  begin
    p := t / HiLoCompress; // 0..1
    r := Round(MinC + (MaxC - MinC) * p);
    g := 0;
  end
  else if t < (1-HiLoCompress) then
  begin
    if t < 0.5 then
    begin
      p := (t - HiLoCompress) / (0.5 - HiLoCompress);
      r := MaxC;
      g := Round(MaxC * p);
    end
    else
    begin
      p := (t - 0.5) / (0.5 - HiLoCompress);
      g := MaxC;
      r := Round(MaxC * (1 - p));
    end;
  end
  else
  begin
    p := (t - (1 - HiLoCompress)) / HiLoCompress;
    r := 0;
    g := Round(MaxC - (MaxC - MinC) * p);
  end;

  Result := Format('#%.2x%.2x%.2x', [r, g, b]);
end;

function LerpColor(c1, c2: Integer; t: Double): Integer;
begin
  Result := Round(c1 + (c2 - c1) * t);
end;

function Color3Stop(t: Double; lowColor, midColor, highColor: string): string;
var
  r1, g1, b1: Integer;
  r2, g2, b2: Integer;
  r3, g3, b3: Integer;
  r, g, b: Integer;
  function HexToRGB(const C: string; out r, g, b: Integer): Boolean;
  begin
    Result := False;
    if Length(C) <> 7 then Exit;
    if C[1] <> '#' then Exit;

    r := StrToInt('$' + Copy(C, 2, 2));
    g := StrToInt('$' + Copy(C, 4, 2));
    b := StrToInt('$' + Copy(C, 6, 2));

    Result := True;
  end;
begin
  if t < 0 then t := 0;
  if t > 1 then t := 1;

  HexToRGB(lowColor, r1, g1, b1);
  HexToRGB(midColor, r2, g2, b2);
  HexToRGB(highColor, r3, g3, b3);

  if midColor = '' then
  begin
    r := LerpColor(r1, r3, t);
    g := LerpColor(g1, g3, t);
    b := LerpColor(b1, b3, t);
  end
  else
  if t < 0.5 then
  begin
    t := t * 2; // 0..1
    r := LerpColor(r1, r2, t);
    g := LerpColor(g1, g2, t);
    b := LerpColor(b1, b2, t);
  end
  else
  begin
    t := (t - 0.5) * 2; // 0..1
    r := LerpColor(r2, r3, t);
    g := LerpColor(g2, g3, t);
    b := LerpColor(b2, b3, t);
  end;

  Result := Format('#%.2x%.2x%.2x', [r, g, b]);
end;

function Normalize(Value, MinVal, MaxVal: Double): Double;
begin
  if MaxVal = MinVal then
    Exit(0);

  Result := (Value - MinVal) / (MaxVal - MinVal);

  if Result < 0 then Result := 0;
  if Result > 1 then Result := 1;
end;

procedure GetColorRange(ColorScheme: TChartColorScheme; var lowColor,midColor,hiColor: string);
begin
  hiColor := '';
  midColor := '';
  lowColor := '';
  case ColorScheme of
    csColdToWarm:     begin lowColor := '#19547b'; hiColor := '#ffd89b'; end;
//    csColdToWarm:      begin lowColor := '#3b82f6'; midColor := '#9ca3af'; hiColor := '#f59e0b'; end;
    csRedToGreen:      begin lowColor := '#d00000'; midColor := '#ffff00'; hiColor := '#00a000'; end;
    csRedToGreen2:     begin lowColor := '#800000'; midColor := '#a0a0a0'; hiColor := '#008000'; end;
    csMechanical:      begin lowColor := '#2c3e50'; hiColor := '#bdc3c7'; end;
    csCrimson:         begin lowColor := '#60035e'; hiColor := '#af0b71'; end;
    csPurYel:          begin lowColor := '#1a2a6c'; midColor := '#b21f1f'; hiColor := '#fdd32d'; end;
    csSunset:          begin lowColor := '#ff1e56'; midColor := '#f9c942'; hiColor := '#1e90ff'; end;
    csCyan:            begin lowColor := '#1f4037'; hiColor := '#99f2c8'; end;
    csFlame:           begin lowColor := '#ff0000'; hiColor := '#fdcf58'; end;
    csSky:             begin lowColor := '#005aa7'; hiColor := '#eeede4'; end;
    csEmerald:         begin lowColor := '#05386b'; hiColor := '#5cdb95'; end;
    csRainForest:      begin lowColor := '#061700'; hiColor := '#52c234'; end;
    csPeppermint:      begin lowColor := '#215f00'; hiColor := '#e4e4d9'; end;
    csPinkToCyan:      begin lowColor := '#0abfbc'; hiColor := '#fc354c'; end;
    csDawn:   begin lowColor := '#3d7eaa'; hiColor := '#ffe47a'; end;
    csLavender:        begin lowColor := '#1d2b64'; hiColor := '#f8cdda'; end;
  end;
end;


function SegmentedBar(X, Y, BarHeight, BarWidth: Double; Color: string;
  FS: TFormatSettings; StartingY: Double): string;
const
  SegmentSize = 15;
  RectSize = 10;
var
  RemainingHeight: Double;
  CurrentY: Double;
  SegmentTop: Double;
  DrawHeight: Double;
  RectStyle: string;
begin
  Result := '';
  //RectStyle := 'fill="%s"';

  Result := Format('<g fill="%s">', [ Color ]);
  RemainingHeight := BarHeight;
  CurrentY := Y;

  while RemainingHeight > 0 do
  begin
    SegmentTop :=
      StartingY - Floor((StartingY - CurrentY) / SegmentSize) * SegmentSize;

    // "rect" part of segment
    if (CurrentY > SegmentTop - RectSize) then
    begin
      DrawHeight := Min(RemainingHeight, RectSize);

      Result := Result + Format(
        '<rect x="%s" y="%s" width="%s" height="%s" />',
        [
          FormatFloat('0.##', X, FS),
          FormatFloat('0.##', CurrentY - DrawHeight, FS),
          FormatFloat('0.##', BarWidth, FS),
          FormatFloat('0.##', DrawHeight, FS) {,
          Color                                }
        ]
      );
    end
    else
    begin
      // gap
      DrawHeight := 0;
      CurrentY := SegmentTop;
    end;

    RemainingHeight := RemainingHeight - SegmentSize;
    CurrentY := CurrentY - SegmentSize;
  end;
  Result := Result + '</g>';
end;


function GenerateSVG(
  DataList: TStringList;
  const FileName, Title: string;
  const ChartOptions: TChartOptions = [];
  const LabelStep: Integer = 4;
  const ChartType: TChartType = ctLine;
  const ColorScheme: TChartColorScheme = csNone;
  const DefBarThickness: Double = 1.0;
  const DefColor: string = ''): string;
const
  OrigWidth = 710;
  OrigHeight = 400;
  AxisOffset = 2;
var
  i, idx, avgCnt: Integer;
  MinVal, MaxVal, MaxVal2, MaxValC, MaxValUp, MaxVal2Up, GridStep, GradY: Double;
  ScaleX, ScaleY, ScaleY2, BarWidth, LabXOffset, LabYOffset: Double;
  X, Y, BarThickness, BarHeight, Bar2Height, BarMargin, LabelX, LabelY, lastLabelY: Double;
  PathData, Path2Data, PathColor, Bars, Plot, LabAnchor, s: string;
  Labels, Grid, SL: TStringList;
  Value,Value2,ValueSum,Value2Sum: Int64;
  LastValue: Int64;
  HasLastValue: Boolean;
  GridY, GridX, GridValue, GridValue2: Double;
  FS: TFormatSettings;
  Width, Height, ClientWidth, ClientHeight, YBottom: Integer;
  Margins: TRect;
  LabAngle, LabelIdx, Radius, LabFontSize, TickSize: Integer;
  Values: TArray<string>;
  SeriesColor,Color,hiColor,midColor,lowColor: string;
  LabelBelow: Boolean;
  GridLines: Integer;
  BaseMargin,ExtraLeft,ExtraBottom,ExtraTop: Integer;

label LNoData;

  function fsize(orgsz: Integer): Integer;
  begin
    Result := orgsz;
    if coLargeLabels in ChartOptions then
      Result := Result * 2;
  end;
begin
  Result := '';
  if coNoEmpty in ChartOptions then
    if DataList.Count = 0 then Exit;
  if LabelStep <= 0 then Exit;



  FS := TFormatSettings.Create;
  FS.DecimalSeparator := '.';
  FS.ThousandSeparator := ' ';

  BaseMargin := 50;
  ExtraLeft := 30;
  ExtraBottom := 50;
  ExtraTop := 30;

  Width := OrigWidth + ExtraLeft;
  Height := OrigHeight + ExtraBottom + ExtraTop;

  Margins.Left := BaseMargin + ExtraLeft;
  Margins.Right := BaseMargin;
  Margins.Bottom := BaseMargin + ExtraBottom;
  Margins.Top := BaseMargin + ExtraTop;

  ClientWidth := Width - Margins.Left - Margins.Right;
  ClientHeight := Height - Margins.Bottom - Margins.Top;

  YBottom := Height - Margins.Bottom;

  SL := TStringList.Create;
  Labels := TStringList.Create;
  Grid := TStringList.Create;
  try

      SL.Add(Format('<svg width="%d" height="%d" xmlns="http://www.w3.org/2000/svg">',
        [Width, Height]));

    if not (coNoBackground in ChartOptions) then
      SL.Add(Format('<rect x="0" y="0" width="%d" height="%d" fill="black"/>',
        [Width, Height]));

    if not (coNoTitle in ChartOptions) then
      SL.Add(Format(
        '<text x="%d" y="20" font-size="16" font-style="italic" text-anchor="middle" fill="white">%s</text>',
        [Width div 2, Title]
      ));

    if DataList.Count = 0 then
    begin
      SL.Add(Format(
        '<text x="%d" y="%d" font-size="12" font-style="italic" text-anchor="middle" fill="white">%s</text>',
        [Width div 2, Height div 2, '(no data)']
      ));
      goto LNoData;
    end;
    BarThickness := DefBarThickness;
    if coExtraBarSep in ChartOptions then
      BarThickness := BarThickness - 0.2;
    if BarThickness > 1.0 then BarThickness := 1.0;
    if BarThickness <= 0 then BarThickness := 0.05;

    GridLines := 4;
    if coMoreGridLines in ChartOptions then
      GridLines := 8;

    GetColorRange(ColorScheme,lowColor,midColor,hiColor);
    SeriesColor := DefColor;
    if SeriesColor = '' then
      SeriesColor := '#' + Opts['Color'];


    if coFlipColors in ChartOptions then
    begin
      s := lowColor;
      lowColor := hiColor;
      hiColor := s;
    end;


    // min/max
    MinVal := 0;
    MaxVal := 0;
    MaxVal2 := 0;
    MaxValC := 0;
    ValueSum := 0;
    Value2Sum := 0;

    avgCnt := 0;
    for i := 0 to DataList.Count - 1 do
    begin
      Value := 0;
      Value2 := 0;
      Values := SplitString(DataList.ValueFromIndex[i], '|');
      if Length(Values) > 0 then
      begin
        Value := StrToInt64Def(Values[0], 0);
        if Length(Values) > 1 then
          Value2 := StrToInt64Def(Values[1], 0);
      end;
      ValueSum := ValueSum + Value;
      Value2Sum := Value2Sum + Value2;
      if Value > MaxVal then MaxVal := Value;
      if Value2 > MaxVal2 then MaxVal2 := Value2;
      if Value + Value2 > MaxValC then MaxValC := Value + Value2;
      if coAvgSkipZero in ChartOptions then
      begin
        if Value <> 0 then Inc(avgCnt);
      end else
        Inc(avgCnt);
    end;

    GridStep := 0.2;
    if coCleanGridStep in ChartOptions then
      GridStep := 2.0;

    MaxValUp := RoundUpMaxVal(Round(MaxVal),GridStep,GridLines);
    MaxVal2Up := RoundUpMaxVal(Round(MaxVal2),GridStep,GridLines);

    if ChartType = ctStacked then
      MaxValUp := RoundUpMaxVal(Round(MaxValC),GridStep);

    if coSharedScale in ChartOptions then
      MaxValUp := Max(MaxValUp,MaxVal2Up);

    // scaling
    ScaleX := 1;
    ScaleY := 1;
    ScaleY2 := 1;

    BarMargin := 0;
    if ChartType in [ctColumn, ctStacked, ctDual, ctCombo] then
    begin
      BarWidth := ClientWidth / DataList.Count;
      BarWidth := Min(BarWidth, ClientWidth / 3);
      BarMargin := (1.0 - BarThickness) * BarWidth / 2;
    end
    else
    if ChartType = ctLine then
    begin
      if DataList.Count > 1 then
        ScaleX := ClientWidth / (DataList.Count - 1);
    end else
    if ChartType = ctScatter then
    begin
      if MaxVal2 > 0 then
        ScaleX := ClientWidth / MaxVal2Up;
    end else
    if ChartType = ctBar then
    begin
      BarHeight := ClientHeight / DataList.Count;
      BarMargin := (1.0 - BarThickness) * BarHeight / 2;
      if MaxVal > 0 then
        ScaleX := ClientWidth / MaxValUp;
    end;


    LabelIdx := 0; //for legend below chart
    LabXOffset := 0;
    if ChartType in [ctColumn, ctStacked, ctDual, ctCombo] then
      LabXOffset := BarWidth / 2;  //or 3 for multiline labels

    LabAngle := 45;
    if DataList.Count div LabelStep > 40 then  LabAngle := 90;

  //cool but hard to read
    if DataList.Count div LabelStep <= 8 then
      LabAngle := 0;


    if ChartType <> ctBar then
    begin
      if MaxValUp > 0 then
        ScaleY := ClientHeight / MaxValUp;

      if MaxVal2 > 0 then
        ScaleY2 := ClientHeight / MaxVal2Up;
    end;

    if coSharedScale in ChartOptions then
      ScaleY2 := ScaleY;

    PathData := '';
    Path2Data := '';
    Bars := '';
    Plot := '';
    HasLastValue := False;

    // grid
    for i := 1 to GridLines do
    begin
      if ChartType <> ctBar then
      begin
        GridValue := i * MaxValUp / GridLines;
        GridY := YBottom - GridValue * ScaleY;
        LabFontSize := fsize(10);


        Grid.Add(Format(
          '<line x1="%d" y1="%s" x2="%d" y2="%s" stroke="#555555" stroke-width="1"/>',
          [Margins.Left,
           FormatFloat('0.##', GridY, FS),
           Width - Margins.Right,
           FormatFloat('0.##', GridY, FS)]
        ));

        Grid.Add(Format(
          '<text x="%d" y="%s" font-size="%d" text-anchor="end" fill="white">%s</text>',
          [Margins.Left - 5,
           FormatFloat('0.##', GridY + 4, FS),
           LabFontSize,
           FormatFloat('#,##0', GridValue, FS)]
        ));

        if (ChartType = ctDual) or (coAuxLine in ChartOptions) then
        if not (coSharedScale in ChartOptions) then
        begin
          GridValue2 := i * MaxVal2Up / GridLines;
          Grid.Add(Format(
            '<text x="%d" y="%s" font-size="%d" text-anchor="start" fill="white">%s</text>',
            [Width - Margins.Right + 5,
             FormatFloat('0.##', GridY + 4, FS),
             LabFontSize,
             '(' + FormatFloat('#,##0', GridValue2, FS) + ')']
          ));
        end;
      end;

      if ChartType in [ctBar,ctScatter] then
      begin
        if ChartType = ctBar then
          GridValue := i * MaxValUp / GridLines
        else
          GridValue := i * MaxVal2Up / GridLines;
        GridX := Margins.Left + GridValue * ScaleX;
        Grid.Add(Format(
          '<line x1="%s" y1="%s" x2="%s" y2="%s" stroke="#555555" stroke-width="1" stroke-dasharray="2,4"/>',
          [FormatFloat('0.##', GridX, FS),
           FormatFloat('0.##', YBottom, FS),
           FormatFloat('0.##', GridX, FS),
           FormatFloat('0.##', Margins.Top, FS)]
        ));

        Grid.Add(Format(
          '<text x="%s" y="%s" font-size="%d" text-anchor="middle" fill="white">%s</text>',
          [FormatFloat('0.##', GridX, FS),
           FormatFloat('0.##', Height- Margins.Bottom + 12, FS),
           LabFontSize,
           FormatFloat('#,##0', GridValue, FS)]
        ));

      end;
    end;

    lastLabelY := -100;
    LabelBelow := false;

    // data series
    for i := 0 to DataList.Count - 1 do
    begin
      if coReversed in ChartOptions then
        idx := DataList.Count - 1 - i
      else
        idx := i;

      Values := SplitString(DataList.ValueFromIndex[idx], '|');
      if Length(Values) = 0 then Continue;

      Value := StrToInt64Def(Values[0], 0);
      Value2 := 0;
      if ChartType in [ctStacked, ctDual, ctCombo, ctScatter] then
        if Length(Values) > 1 then
          Value2 := StrToInt64Def(Values[1], 0);

      if ChartType in [ctColumn, ctStacked, ctDual, ctCombo] then
        X := Margins.Left + i * BarWidth
      else
      if ChartType = ctScatter then
        X := Margins.Left + Value2 * ScaleX
      else
      if ChartType = ctLine then
        X := Margins.Left + i * ScaleX;

      if ChartType = ctBar then
        Y := YBottom - (i + 1) * BarHeight
      else
        Y := YBottom - Value * ScaleY;

      case ColorScheme of
         csNone: Color := SeriesColor;
        //non-gradient color palettes
        csCyclic: Color := RainbowColor(i mod 12, 12, 0.3 + i/DataList.Count/2);
        csGolden: Color := RainbowColor(Round((i * 0.6180339887) * 12) mod 12, 12, 0.3 + i/DataList.Count/2);
        csRedGreen: Color := RedToGreen(Normalize(Value,MinVal,MaxVal)); //darker edge values
      else
        if coCategoryColors in ChartOptions then
          Color := Color3Stop(i/DataList.Count,lowColor,midColor,hiColor)
        else
        if coValueColors in ChartOptions then
          Color := Color3Stop(Normalize(Value,MinVal,MaxVal),lowColor,midColor,hiColor)
        else
          Color := 'url(#grad)';
      end;


      if ChartType  = ctLine then
      begin
        if (not HasLastValue) or (Value <> LastValue) then
        begin
          if not HasLastValue then
            PathData := Format('M %s %s ',
              [FormatFloat('0.##', X, FS), FormatFloat('0.##', Y, FS)])
          else
            PathData := PathData + Format('L %s %s ',
              [FormatFloat('0.##', X, FS), FormatFloat('0.##', Y, FS)]);

          LastValue := Value;
          HasLastValue := True;

          if (coMarkers in ChartOptions) and (Length(Values) > 1) then
//          if i mod 4 = 0 then
          begin
            s := Values[1];
            LabelX := X - 8;
            LabelY := Y - 8;
            if Abs(LabelY-lastLabelY) > 8 then
            begin
              Labels.Add(Format(
                '<line x1="%s" y1="%s" x2="%s" y2="%s" stroke="#888888" stroke-width="1"/>',
                [FormatFloat('0.##', X - 2, FS),
                 FormatFloat('0.##', Y - 2, FS),
                 FormatFloat('0.##', LabelX, FS),
                 FormatFloat('0.##', LabelY, FS)]
              ));

              Labels.Add(Format(
                '<text x="%s" y="%s" font-size="8" font-style="italic" text-anchor="end" fill="white">%s</text>',
                [FormatFloat('0.##', LabelX, FS),
                 FormatFloat('0.##', LabelY, FS),
                 s]
              ));
              lastLabelY := LabelY;
              LabelBelow := true;
              s := '';
              if Length(Values) > 2 then
                s := Values[2];
            end;
            //else
            if LabelBelow and (s <> '') then
            begin
              LabelX := X + 8;
              LabelY := Y + 8;

              if LabelY + 10 < YBottom then
              begin
                Labels.Add(Format(
                  '<line x1="%s" y1="%s" x2="%s" y2="%s" stroke="#888888" stroke-width="1"/>',
                  [FormatFloat('0.##', X + 2, FS),
                   FormatFloat('0.##', Y + 2, FS),
                   FormatFloat('0.##', LabelX, FS),
                   FormatFloat('0.##', LabelY, FS)]
                ));

                 Labels.Add(Format(
                  '<text x="%s" y="%s" font-size="8" font-style="italic" text-anchor="begin" fill="white">%s</text>',
                  [FormatFloat('0.##', LabelX, FS),
                   FormatFloat('0.##', LabelY + 8, FS),
                   s]
                ));
                LabelBelow := false;
              end;
            end;
          end;
        end;
      end;

      if coAuxLine in ChartOptions then
      begin
        Y := YBottom - Value2 * ScaleY2;
        if Path2Data = '' then
          Path2Data := Format('M %s %s ',
            [FormatFloat('0.##', X, FS), FormatFloat('0.##', Y, FS)])
        else
          Path2Data := Path2Data + Format('L %s %s ',
            [FormatFloat('0.##', X, FS), FormatFloat('0.##', Y, FS)]);
      end;


      if ChartType = ctScatter then
      begin
        Radius := 3;
        if (Value > MaxVal / 2) or (Value2 > MaxVal2 / 2) then
          Radius := 5;
        Plot := Plot + Format(
          '<circle cx="%s" cy="%s" r="%d" fill="%s"><title>%s: %s / %s</title></circle>',
          [FormatFloat('0.##', X, FS),
           FormatFloat('0.##', Y, FS),
           Radius,
           Color,
           DataList.Names[idx],
           FormatFloat('#,##0.##', Value, FS),
           FormatFloat('#,##0.##', Value2, FS)]
        );

        if (Value > MaxVal / 2) or (Value2 > MaxVal2 / 2) then
        begin
          LabelX := X - 12;
          LabelY := Y - 12;

          Labels.Add(Format(
            '<line x1="%s" y1="%s" x2="%s" y2="%s" stroke="#888888" stroke-width="1"/>',
            [FormatFloat('0.##', X - 4, FS),
             FormatFloat('0.##', Y - 4, FS),
             FormatFloat('0.##', LabelX, FS),
             FormatFloat('0.##', LabelY, FS)]
          ));

          Labels.Add(Format(
            '<text x="%s" y="%s" font-size="7" font-style="italic" text-anchor="end" fill="white">%s</text>',
            [FormatFloat('0.##', LabelX, FS),
             FormatFloat('0.##', LabelY, FS),
             DataList.Names[idx]]
          ));
        end
        else
        if LabelIdx < 19 then
        begin

          LabelX := X - 3;
          LabelY := Y - 3;

          s := Chr(Ord('a') + LabelIdx);
          Labels.Add(Format(
            '<text x="%s" y="%s" font-size="7" font-style="italic" text-anchor="end" fill="white">%s</text>',
            [FormatFloat('0.##', LabelX, FS),
             FormatFloat('0.##', LabelY, FS),
             s]
          ));

          LabelX := Margins.Left + (LabelIdx mod 4) * ScaleX * MaxVal2Up / 4 ;
          LabelY := YBottom + (LabelIdx div 4) * 12 + 24;
          Labels.Add(Format(
            '<text x="%s" y="%s" font-size="7" font-style="italic" text-anchor="begin" fill="white">%s</text>',
            [FormatFloat('0.##', LabelX, FS),
             FormatFloat('0.##', LabelY, FS),
             s + '. ' + DataList.Names[idx]]
          ));
          Inc(LabelIdx);
        end;
      end;


      if ChartType = ctBar then
      begin
        BarWidth := Value * ScaleX;

        Bars := Bars + Format(
          '<rect x="%s" y="%s" width="%s" height="%s" fill="%s">' +
          '<title>%d</title></rect>',
          [FormatFloat('0.##', Margins.Left, FS),
           FormatFloat('0.##', Y + BarMargin, FS),
           FormatFloat('0.##', BarWidth, FS), //BarWidth * FillRatio or - Padding
           FormatFloat('0.##', BarHeight * BarThickness, FS),
           Color,
           Value]
          );

      end;

      if ChartType in [ctColumn, ctStacked, ctDual, ctCombo] then
      begin
        BarHeight := Value * ScaleY;
        Bar2Height := 0;

        if coSegmentedBar in ChartOptions then
          Bars := Bars + SegmentedBar(X + BarMargin, YBottom,
            BarHeight, BarWidth * BarThickness, Color,FS, YBottom)
        else
          Bars := Bars + Format(
            '<rect x="%s" y="%s" width="%s" height="%s" fill="%s">' +
            '<title>%d</title></rect>',
            [FormatFloat('0.##', X + BarMargin, FS),
             FormatFloat('0.##', YBottom - BarHeight, FS),
             FormatFloat('0.##', BarWidth * BarThickness, FS), //BarWidth * FillRatio or - Padding
             FormatFloat('0.##', BarHeight, FS),
             Color,
             Value]
            );

        if ChartType = ctDual then
        begin
          Bar2Height := Value2 * ScaleY2;
          if coSegmentedBar in ChartOptions then
           Bars := Bars + SegmentedBar(X + BarWidth  - BarWidth/6, YBottom,
             Bar2Height, BarWidth/6, 'url(#grad2)',FS, YBottom)
          else
            Bars := Bars + Format(
              '<rect x="%s" y="%s" width="%s" height="%s" fill="%s">' +
              '<title>%d</title></rect>',
              [FormatFloat('0.##', X + BarWidth - BarWidth/6, FS),
               FormatFloat('0.##', YBottom - Bar2Height, FS),
               FormatFloat('0.##', BarWidth/6, FS),
               FormatFloat('0.##', Bar2Height, FS),
               'url(#grad2)', //'#a0a0a0',
               Value2]
              );
        end;

        if ChartType = ctCombo then
        begin
          Bar2Height := (Value2 * ScaleY2) / 6;
          Bars := Bars + Format(
            '<rect x="%s" y="%s" width="%s" height="%s" fill="%s">' +
            '<title>%d</title></rect>',
            [FormatFloat('0.##', X + BarMargin, FS),
             FormatFloat('0.##', YBottom - BarHeight - Bar2Height, FS),
             FormatFloat('0.##', BarWidth * BarThickness, FS),
             FormatFloat('0.##', Bar2Height, FS),
             'url(#grad3)', //'#a0a0a0',
             Value2]
            );
        end;

        if ChartType = ctStacked then
        begin
          Bar2Height := Value2 * ScaleY;

          if coSegmentedBar in ChartOptions then
           Bars := Bars + SegmentedBar(X + BarMargin,YBottom - BarHeight,
             Bar2Height, BarWidth * BarThickness, 'url(#grad3)',FS, YBottom)
          else
            Bars := Bars + Format(
              '<rect x="%s" y="%s" width="%s" height="%s" fill="%s">' +
              //'<rect x="%s" y="%s" width="%s" height="%s" fill="none" stroke="%s" stroke-width="2">' +
              '<title>%d</title></rect>',
              [FormatFloat('0.##', X + BarMargin, FS),
               FormatFloat('0.##', YBottom - BarHeight - Bar2Height, FS),
               FormatFloat('0.##', BarWidth * BarThickness, FS),
               FormatFloat('0.##', Bar2Height, FS),
               'url(#grad3)', //'#a0a0a0',
               Value2]
              );
        end;

        if coValLabels in ChartOptions then
        begin
          LabFontSize := fsize(7);

          if ChartType in [ctStacked,ctCombo] then
            LabelY := YBottom - BarHeight + 10
          else
            LabelY := YBottom - BarHeight {- Bar2Height} - 10;

          if LabelY > YBottom - 10 then
            LabelY := YBottom - 10;

          Labels.Add(Format(
                '<text x="%s" y="%s" font-size="%d" font-style="italic" text-anchor="middle" fill="white">%s</text>',
                [FormatFloat('0.##', X + BarWidth / 2, FS),
                 FormatFloat('0.##', LabelY, FS),
                 LabFontSize,
                 FormatFloat('#,##0', Value, FS)]
              ));

          if (Value2 > 0) and (ChartType in [ctStacked,ctCombo]) then
          begin
            LabelY := YBottom - BarHeight - Bar2Height - 10;
            if LabelY > YBottom - 20 then
              LabelY := YBottom - 20;
            Labels.Add(Format(
                  '<text x="%s" y="%s" font-size="%d" font-style="italic" text-anchor="middle" fill="white">%s</text>',
                  [FormatFloat('0.##', X + BarWidth / 2, FS),
                   FormatFloat('0.##', LabelY, FS),
                   LabFontSize,
                   FormatFloat('#,##0', Value2, FS)]
                ));
          end;
        end;
      end;


      // Y categories & labels
      if ChartType = ctBar then
      begin
        LabAnchor := 'end';
        LabFontSize := fsize(8);

        Labels.Add(Format(
          '<text x="%s" y="%s" font-size="%d" text-anchor="%s" fill="white">%s</text>',
          [FormatFloat('0.##', Margins.Left - AxisOffset - 2, FS),
           FormatFloat('0.##', Y + BarHeight / 2 + 4, FS),
           LabFontSize,
           LabAnchor,
           DataList.Names[idx]]
        ));

        if coValLabels in ChartOptions then
        begin
          LabAnchor := 'start';
          LabFontSize := fsize(7);
          LabelX := Margins.Left + BarWidth + 4;

          //if Value > MaxValUp * 0.9 then
          //  LabAnchor := 'end';

          Labels.Add(Format(
                '<text x="%s" y="%s" font-size="%d" font-style="italic" text-anchor="%s" fill="white">%s</text>',
                [FormatFloat('0.##', LabelX, FS),
                 FormatFloat('0.##', Y + BarHeight / 2 + 4, FS),
                 LabFontSize,
                 LabAnchor,
                 FormatFloat('#,##0', Value, FS)]
            ));
       end;
      end;

      // X categories
      if ChartType in [ctLine,ctColumn,ctStacked,ctDual,ctCombo] then
      if i mod LabelStep = 0 then
      begin
        LabAnchor := 'end';
        LabFontSize := fsize(10);
        LabYOffset := 0;
        TickSize := 4;

        if LabAngle = 0 then
        begin
          LabAnchor := 'middle';

          if DataList.Count > 4 then
          if (i div LabelStep) mod 2 = 1 then
          begin
            LabYOffset := LabFontSize + TickSize;
          end;
        end;

        if ChartType = ctLine then
        if Y + 2 < YBottom - 2 then
        if (i div LabelStep) mod 2 = 1 then
          Labels.Add(Format('<line x1="%s" y1="%s" x2="%s" y2="%s" stroke="#555" stroke-dasharray="2,4"/>',
            [FormatFloat('0.##', X + LabXOffset, FS),
             FormatFloat('0.##', YBottom  + AxisOffset - 2),
             FormatFloat('0.##', X + LabXOffset, FS),
             FormatFloat('0.##', Y + 2)]));

        Labels.Add(Format('<line x1="%s" y1="%s" x2="%s" y2="%s" stroke="white"/>',
          [FormatFloat('0.##', X + LabXOffset, FS),
           FormatFloat('0.##', YBottom + AxisOffset),
           FormatFloat('0.##', X + LabXOffset, FS),
           FormatFloat('0.##', YBottom + AxisOffset + TickSize + LabYOffset)]));

        Labels.Add(Format(
          '<text x="%s" y="%s" font-size="%d" text-anchor="%s" fill="white" transform="rotate(-%d %s,%s)">%s</text>',
          [FormatFloat('0.##', X + LabXOffset, FS),
           FormatFloat('0.##', YBottom + LabFontSize + TickSize + LabYOffset, FS),
           LabFontSize,
           LabAnchor,
           LabAngle,
           FormatFloat('0.##', X + LabXOffset, FS),
           FormatFloat('0.##', YBottom + LabFontSize + TickSize + LabYOffset, FS),
           DataList.Names[idx]]
        ));
      end;
    end;

    {
    // SVG
    SL.Add(Format('<svg width="%d" height="%d" xmlns="http://www.w3.org/2000/svg">',
      [Width, Height]));

    SL.Add(Format('<rect x="0" y="0" width="%d" height="%d" fill="black"/>',
      [Width, Height]));

    SL.Add(Format(
      '<text x="%d" y="20" font-size="16" font-style="italic" text-anchor="middle" fill="white">%s</text>',
      [Width div 2, Title]
    ));
}

    SL.AddStrings(Grid);

    //X Axis
    SL.Add(Format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="white"/>',
      [Margins.Left - AxisOffset, YBottom + AxisOffset,
        Width - Margins.Right, YBottom + AxisOffset]));

    //Y Axis
    SL.Add(Format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="white"/>',
      [Margins.Left - AxisOffset, Margins.Top, Margins.Left - AxisOffset, YBottom + AxisOffset]));

    SL.Add('<defs>');
    PathColor := SeriesColor;

    if hiColor <> '' then
    begin
      PathColor := 'url(#grad)';

      if coGradientX in ChartOptions then
        SL.Add('<linearGradient id="grad" ' +
          Format('x1="%d" y1="0" x2="%d" y2="0" gradientUnits="userSpaceOnUse">',[Margins.Left, Width - Margins.Right]) +
          '<stop offset="0%" stop-color="' + lowColor + '"/>' +
          IfThen(midColor<>'','<stop offset="50%" stop-color="' + midColor + '"/>','') +
          '<stop offset="100%" stop-color="' + hiColor + '"/>' +
          '</linearGradient>')
      else
      begin
        GradY := MaxVal;
        if coStackColors in ChartOptions then
          GradY := MaxValC;
        SL.Add('<linearGradient id="grad" ' +
          Format('x1="0" y1="%d" x2="0" y2="%d" gradientUnits="userSpaceOnUse">',
//            [Margins.Top,YBottom]) +
            [Trunc(YBottom - GradY*ScaleY),YBottom]) +
          '<stop offset="0%" stop-color="' + hiColor + '"/>' +
          IfThen(midColor<>'','<stop offset="50%" stop-color="' + midColor + '"/>','') +
          '<stop offset="100%" stop-color="' + lowColor + '"/>' +
          '</linearGradient>');
      end;
    end;
    if (ChartType = ctDual) or (coAuxLine in ChartOptions) then
       SL.Add('<linearGradient id="grad2" ' +
        Format('x1="0" y1="%d" x2="0" y2="%d" gradientUnits="userSpaceOnUse">',
//          [Margins.Top,YBottom]) +
          [Trunc(YBottom - MaxVal2*ScaleY2),YBottom]) +
        '<stop offset="0%" stop-color="white"/>' +
        '<stop offset="100%" stop-color="#606060"/>' +
        '</linearGradient>');

    if ChartType in [ctStacked, ctCombo] then
       SL.Add('<linearGradient id="grad3" ' +
        'x1="0%" y1="0%" x2="0%" y2="100%"' +
          IfThen(coSegmentedBar in ChartOptions, ' gradientUnits="userSpaceOnUse"','') + '>' +
        '<stop offset="0%" stop-color="#606060"/>' +
        '<stop offset="100%" stop-color="white"/>' +
        '</linearGradient>');

    SL.Add('</defs>');

    if ChartType = ctLine then
      SL.Add(Format('<path d="%s" fill="none" stroke="%s" stroke-width="2"/>',
        [PathData,PathColor]))
    else
    if ChartType in [ctColumn,ctBar,ctStacked,ctDual,ctCombo] then
      SL.Add('<g>' + Bars + '</g>')
    else
    if ChartType = ctScatter then
      SL.Add(Plot);

    if coAuxLine in ChartOptions then
      SL.Add(Format('<path d="%s" fill="none" stroke="%s" stroke-width="2"/>',
        [Path2Data,'url="grad2"']));


    if (coAvgLine in ChartOptions) and (avgCnt > 0) then
    begin
      GridValue := ValueSum div avgCnt;
      if ChartType <> ctBar then
      begin
        GridY := YBottom - GridValue * ScaleY;

        SL.Add(Format(
          '<line x1="%d" y1="%s" x2="%d" y2="%s" opacity="0.5" stroke="white" stroke-width="1" stroke-dasharray="4,2"/>',
          [Margins.Left,
           FormatFloat('0.##', GridY, FS),
           Width - Margins.Right,
           FormatFloat('0.##', GridY, FS)]
        ));

        SL.Add(Format(
          '<text x="%d" y="%s" font-size="10" text-anchor="start" fill="white">%s</text>',
          [Width - Margins.Right + 5,
           FormatFloat('0.##', GridY + 4, FS),
           FormatFloat('#,##0', GridValue, FS)]
        ));
      end;

      if ChartType in [ctBar,ctScatter] then
      begin
        if ChartType = ctBar then
          GridValue := ValueSum div avgCnt
        else
          GridValue := Value2Sum div avgCnt;
        GridX := Margins.Left + GridValue * ScaleX;
        SL.Add(Format(
          '<line x1="%s" y1="%s" x2="%s" y2="%s" opacity="0.5" stroke="white" stroke-width="1"/>',
          [FormatFloat('0.##', GridX, FS),
           FormatFloat('0.##', YBottom, FS),
           FormatFloat('0.##', GridX, FS),
           FormatFloat('0.##', Margins.Top, FS)]
        ));

        SL.Add(Format(
          '<text x="%s" y="%s" font-size="10" text-anchor="middle" fill="white">%s</text>',
          [FormatFloat('0.##', GridX, FS),
           FormatFloat('0.##', Margins.Top - 12, FS),
           FormatFloat('#,##0', GridValue, FS)]
        ));

      end;
    end;

    SL.AddStrings(Labels);

LNoData:;
    SL.Add('</svg>');

    Result := SL.Text;

    if FileName <> '' then
      SL.SaveToFile(FileName);

  finally
    Labels.Free;
    Grid.Free;
    SL.Free;
  end;
end;

procedure TChartForm.FormCreate(Sender: TObject);
begin
  ShowInTaskBar := Opts.Flags['ShowInTaskbar'];
  //FChartData := TChartData.Create('');
  SvgArea.PopupMenu := DashboardForm.PopupMenu;
end;

procedure TChartForm.FormDestroy(Sender: TObject);
begin
  FChartData.Free;
end;

procedure TChartForm.MenuLabelClick(Sender: TObject);
var pt: TPoint;
begin
  pt.X := MenuLabel.Left;
  pt.Y := MenuLabel.Top + MenuLabel.Height;
  pt := self.ClientToScreen(pt);
  SvgArea.PopupMenu.PopupComponent := SvgArea;
  SvgArea.PopupMenu.Popup(pt.X,pt.Y);
end;


function CompareByValue(List: TStringList; Index1, Index2: Integer): Integer;
var
  V1, V2: Double;
begin
  V1 := StrToFloatDef(List.ValueFromIndex[Index1].Split(['|'])[0], 0);
  V2 := StrToFloatDef(List.ValueFromIndex[Index2].Split(['|'])[0], 0);
  Result := CompareValue(V1, V2); // asc
end;

function SumFirstTwo(const S: string): Double;
var
  Parts: TArray<string>;
begin
  Parts := S.Split(['|']);
  Result := 0;
  if Length(Parts) > 0 then
    Result := Result + StrToFloatDef(Parts[0], 0);
  if Length(Parts) > 1 then
    Result := Result + StrToFloatDef(Parts[1], 0);
end;

function CompareByValueSum(List: TStringList; Index1, Index2: Integer): Integer;
var
  V1, V2: Double;
begin
  V1 := SumFirstTwo(List.ValueFromIndex[Index1]);
  V2 := SumFirstTwo(List.ValueFromIndex[Index2]);
  Result := CompareValue(V1, V2);
end;

procedure TChartForm.SvgAreaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_NCLBUTTONDOWN, HTCAPTION, 0);

end;

procedure TChartForm.UpdateChart;
begin
  //SvgArea.Svg.Source := '';
  with FChartData do
  begin
    UpdateSvg;
    SvgArea.Svg.Source := svgSource;
    SvgArea.Tag := NativeInt(FChartData);
  end;
  //   GenerateSVG(dataSeries,'', title,chartOptions,labStep,
  //    chartType,colorScheme,barThickness,'red');
end;

procedure TChartForm.CreateChart(ChartData: TChartData);
begin
//  FChartData.Assign(ChartData);
  if (FChartData <> nil) and not FChartData.isShared then
    FChartData.Free;
  FChartData := ChartData;
  UpdateChart;
  Show;
end;


procedure TChartForm.CreateChartById(id: string; src: string; const cmdr: string = ''; const taskGroup: string = '';
  const sysList: TStringList = nil);
begin
  if (FChartData <> nil) and not FChartData.isShared then
    FChartData.Free;

  FChartData := TChartData.Create(id,src);
  FChartData.cmdr := cmdr;
  FChartData.taskGroup := taskGroup;
  FChartData.sysList := sysList;
  FChartData.Update;

  SvgArea.Svg.Source := FChartData.svgSource;
  SvgArea.Tag := NativeInt(FChartData);
  Show;
end;


procedure SetWeekStartDate(var dt: TDateTime);
var
  isoDoW,offset,wsd: Integer;
begin
  wsd := Opts.Int['WeekStartDay'];
  if (wsd < 1) or (wsd > 7) then
    Exit;
  isoDoW := DayOfTheWeek(dt); // 1 = Monday ... 7 = Sunday (ISO)
  offset := (isoDoW - wsd + 7) mod 7;
  dt := Trunc(dt - offset);
end;

procedure SetWeekEndDate(var dt: TDateTime);
var
  isoDoW,offset,wsd: Integer;
begin
  wsd := Opts.Int['WeekStartDay'];
  if (wsd < 1) or (wsd > 7) then
    Exit;
  isoDoW := DayOfTheWeek(dt); // 1 = Monday ... 7 = Sunday (ISO)
  offset := (isoDoW - wsd + 7) mod 7;
  dt := Trunc(dt - offset) + 6;
end;

procedure GetContribData(mode: Integer; cmdr: string; taskGroup: string; var dataSeries: THashedStringList);
var cd: TConstructionDepot;
    sys: TStarSystem;
    s,lastdts: string;
    i,i2,idx: Integer;
    dt,mindt: TDateTime;
    v: Int64;
    maxdays,d: Integer;
    Values: TArray<string>;
begin
  dataSeries := THashedStringList.Create;

  case mode of
    1: begin maxdays := 30; d := 1; end;
    2: begin maxdays := 90; d := 1; end;
    3: begin maxdays := 90; d := 7; end;
    4: begin maxdays := 360; d := 7; end;
  else
    Exit;
  end;

  dt := NowUTC;
  if d = 7 then
    SetWeekEndDate(dt);
  mindt := dt-(maxdays+1);
  s := Copy(DateToISO8601(dt),1,10);
  while dt > mindt do
  begin
    dataSeries.AddPair(s,'0');
    dt := dt - d;
    s := Copy(DateToISO8601(dt),1,10);
  end;
  lastdts := dataSeries.Names[dataSeries.Count-1];
  dataSeries.Sort;

  for i := 0 to DataSrc.Constructions.Count - 1 do
  begin
    cd := DataSrc.Constructions.ConstrByIdx[i];
    sys := cd.GetSys;
    if sys = nil then continue;
    if taskGroup <> '' then
      if sys.TaskGroup <> taskGroup then continue;


    for i2 := cd.TransactionHistory.Count - 1 downto 0 do
    begin
      s := Copy(cd.TransactionHistory.Names[i2],1,10);
      if s < lastdts then break;
      Values := SplitString(cd.TransactionHistory.ValueFromIndex[i2], '|');
      if cmdr <> '' then
        if Values[0] <> cmdr then continue;
      dataSeries.Find(s,idx);
      if (idx >= 0) and (idx < dataSeries.Count) then
      begin
        dataSeries.ValueFromIndex[idx] :=
          (StrToInt64Def(dataSeries.ValueFromIndex[idx],0) + StrToInt64Def(Values[2],0)).ToString;
      end;
    end;
  end;

end;

procedure GetConstrContrib(mode: Integer; cd: TConstructionDepot; cmdr: string; var dataSeries: THashedStringList);
var s,lastdts,nowdts: string;
    i,idx: Integer;
    dt,maxdt: TDateTime;
    v,vsum,quota,avg,contrib,dq: Int64;
    cnt: Integer;
    Values: TArray<string>;
begin
  dataSeries := THashedStringList.Create;
  if cd = nil then Exit;
  if cd.Simulated then Exit;
  if cd.TransactionHistory.Count = 0 then Exit;

  dt := ISO8601ToDate(cd.TransactionHistory.Names[0]);
  if cd.Finished then
    maxdt := ISO8601ToDate(cd.LastUpdate) + 1
  else
    maxdt := NowUTC + 14;
  s := Copy(DateToISO8601(dt),1,10);
  while dt < maxdt do
  begin
    dataSeries.AddPair(s,'0');
    dt := dt + 1;
    s := Copy(DateToISO8601(dt),1,10);
  end;
  lastdts := dataSeries.Names[dataSeries.Count-1];

  contrib := 0;
  for i := 0 to cd.TransactionHistory.Count - 1 do
  begin
    s := Copy(cd.TransactionHistory.Names[i],1,10);
    Values := SplitString(cd.TransactionHistory.ValueFromIndex[i], '|');
    v := StrToInt64Def(Values[2],0);
    contrib := contrib + v;
    if cmdr <> '' then
      if Values[0] <> cmdr then continue;
    dataSeries.Find(s,idx);
    if (idx >= 0) and (idx < dataSeries.Count) then
    begin
      dataSeries.ValueFromIndex[idx] :=
        (StrToInt64Def(dataSeries.ValueFromIndex[idx],0) + v).ToString;
    end;
  end;

  if not cd.Finished then
  begin
    cnt := 0;
    vsum := 0;
    nowdts := Copy(DateToISO8601(NowUTC),1,10);
    for i := 0 to dataSeries.Count - 1 do
    begin
      v := StrToInt64Def(dataSeries.ValueFromIndex[i],0);
      if v <> 0 then
      begin
        vsum := vsum + v;
        cnt := cnt + 1;
      end;
    end;

    if vsum > 0 then
      quota := vsum div cnt;   //avg

    if Opts.Int['QuotaMode'] = 0 then
      quota := Opts.Int['DailyQuota'];

    if Opts.Int['QuotaMode'] = 2 then
      if quota < Opts.Int['DailyQuota'] then
        quota := Opts.Int['DailyQuota'];


    if quota > 0 then
    begin
      for i := 0 to dataSeries.Count - 1 do
        if dataSeries.Names[i] >= nowdts then
        begin
          s := dataSeries.ValueFromIndex[i];
          v := StrToInt64Def(s,0);
          dq := quota;
          if dataSeries.Names[i] = nowdts then
            dq := Max(quota - (DataSrc.CurrentContribution - v),0);
          v := dq - v;
          if v > 0 then
          begin
            if contrib + v > cd.ActualHaul then
              v := cd.ActualHaul - contrib;
            if v > 0 then
            begin
              dataSeries.ValueFromIndex[i] := s + '|' + v.ToString;
              contrib := contrib + v;
            end;
          end;
        end;
    end;
  end;
  while (dataSeries.Count > 0) and (dataSeries.ValueFromIndex[dataSeries.Count-1] = '0') do
    dataSeries.Delete(dataSeries.Count-1);

end;

procedure GetFinishedConstrData(mode: Integer; cmdr: string; taskGroup: string; sysList: TStringList; var dataSeries: THashedStringList);
var cd: TConstructionDepot;
    ct: TConstructionType;
    sys: TStarSystem;
    s: string;
    i,i2: Integer;
    dt: TDateTime;
    v: Int64;
begin
  dataSeries := THashedStringList.Create;

  dt := NowUTC;
  SetWeekEndDate(dt);
  s := Copy(DateToISO8601(dt),1,7);
  while s > '2025-03' do  //Trailblazers start , todo: switch to journals start
  begin
    dataSeries.Values[s] := '0';
    dt := IncMonth(dt,-1);
    s := Copy(DateToISO8601(dt),1,7);
  end;

  for i := 0 to DataSrc.Constructions.Count - 1 do
  begin
    cd := DataSrc.Constructions.ConstrByIdx[i];
    if not cd.Finished then continue;
    ct := cd.GetConstrType;
    if ct = nil then continue;
    sys := cd.GetSys;
    if sys = nil then continue;
    if (sysList = nil) or (sysList.Count = 0) then
    begin
      if not sys.IsOwnColony then continue
    end
    else
      if sysList.IndexOf(sys.StarSystem) = -1 then continue;
    if cmdr <> '' then
      if sys.Architect <> cmdr then continue;
    if taskGroup <> '' then
      if sys.TaskGroup <> taskGroup then continue;

//    if cd.Contribution > 0 then
    if cd.LastUpdate <> '' then
      s := Copy(cd.LastUpdate,1,7)
    else
      s := '2025-03';

    v := 0;
    case mode of
      1: v := cd.ActualHaul;
      2: v := ct.Score;
    end;
    dataSeries.Values[s] := (StrToInt64Def(dataSeries.Values[s],0) + v).ToString;
  end;

  while (dataSeries.Count > 0) and (dataSeries.ValueFromIndex[dataSeries.Count-1] = '0') do
    dataSeries.Delete(dataSeries.Count-1);

end;

procedure GetPopHistoryData(mode: Integer; cmdr: string; taskGroup: string; sysList: TStringList; var dataSeries: THashedStringList);
var cd: TConstructionDepot;
    ct: TConstructionType;
    sys: TStarSystem;
    s: string;
    i,i2,idx: Integer;
    pop: Int64;
    dt: TDateTime;
begin
  dataSeries := THashedStringList.Create;

  dt := NowUTC;
  //SetWeekEndDate(dt);
  s := Copy(DateToISO8601(dt),1,10);
  while s > '2025-03' do  //Trailblazers start , todo: switch to journals start
  begin
    dataSeries.AddPair(s,'0');
    //dt := IncMonth(dt,-1);
    dt := dt - 7;
    s := Copy(DateToISO8601(dt),1,10);
  end;

  for i2 := 0 to DataSrc.StarSystems.Count - 1 do
  begin
    sys := DataSrc.StarSystems[i2];
    if (sysList = nil) or (sysList.Count = 0) then
    begin
      if not sys.IsOwnColony then continue
    end
    else
    begin
      if sysList.IndexOf(sys.StarSystem) = -1 then continue;

{
      if title <> '' then
        title := title + ',  ';
      title := title + sys.StarSystem;
}
    end;
    if cmdr <> '' then
      if sys.Architect <> cmdr then continue;
    if taskGroup <> '' then
      if sys.TaskGroup <> taskGroup then continue;

    for i := 0 to dataSeries.Count - 1 do
    begin
      s := dataSeries.Names[i];
      pop := sys.PopForTimeStamp(s + 'ZZZ');
      if pop = 0 then  break;
      dataSeries.ValueFromIndex[i] := (StrToInt64Def(dataSeries.ValueFromIndex[i],0) + pop).ToString;
    end;

  end;

//find T3 milestones
  dataSeries.Sort;
  for i := 0 to DataSrc.Constructions.Count - 1 do
  begin
    cd := DataSrc.Constructions.ConstrByIdx[i];
    if not cd.Finished  then continue;
    if cd.LastUpdate = '' then continue;
    ct := cd.GetConstrType;
    if ct = nil then continue;

    sys := cd.GetSys;
    if sys = nil then continue;
    if cmdr <> '' then
      if sys.Architect <> cmdr then continue;
    if taskGroup <> '' then
      if sys.TaskGroup <> taskGroup then continue;

    if (sysList = nil) or (sysList.Count = 0) then
    begin
      if not sys.IsOwnColony then continue
    end
    else
      if sysList.IndexOf(sys.StarSystem) = -1 then continue;

    if ct.Tier = '3' then
    begin
      s := Copy(cd.LastUpdate,1,10);
      dataSeries.Find(s,idx);
      if (idx >= 0) and (idx < dataSeries.Count) then
      begin
        s := cd.StationName_abbrev(false);
        dataSeries.ValueFromIndex[idx] := dataSeries.ValueFromIndex[idx] + '|' + s;
      end;
    end;

  end;

  while (dataSeries.Count > 0) and (dataSeries.ValueFromIndex[0] = '0') do
    dataSeries.Delete(0);

//  while dataSeries.ValueFromIndex[dataSeries.Count-1] = '0' do
//    dataSeries.Delete(dataSeries.Count-1);
end;

procedure GetSystemStatData(mode: Integer; groupBy: Integer; cmdr: string; taskGroup: string; sysList: TStringList; topCnt: Integer;
  var dataSeries: THashedStringList);
var sys: TStarSystem;
    s,groups,ctrlFac: string;
    i,i2: Integer;
    v,v2: Int64;
    sl: TStringList;
begin
  dataSeries := THashedStringList.Create;
  sl := TStringList.Create;

  for i := 0 to DataSrc.StarSystems.Count - 1 do
  begin
    sys := DataSrc.StarSystems[i];
    if (sysList = nil) or (sysList.Count = 0) then
    begin
      if not sys.IsOwnColony then continue
    end
    else
    begin
      if sysList.IndexOf(sys.StarSystem) = -1 then continue;
    end;
    if cmdr <> '' then
      if sys.Architect <> cmdr then continue;
    if taskGroup <> '' then
      if sys.TaskGroup <> taskGroup then continue;


    v := 0; v2 := -1;
    case mode of
      1: v := sys.Population;
      2: v := sys.PopDailyChange;
      3: v := sys.GetScore;
      4: begin v := sys.Population; v2 := sys.PopDailyChange; end;
      5: v := sys.GetRawStat(sDev);
      6: v := sys.GetRawStat(sTech);
      7: begin v := sys.GetRawStat(sDev); v2 := sys.GetRawStat(sTech); end;
      8: begin v := sys.Population; v2 := sys.PopMonthlyChange; end;
      9: v := 1;
      10: v := sys.PopChangeEstimate(-1);
    end;

    groups := '';
    case groupBy of
      1: groups := sys.StarSystem;
      2: groups := sys.TaskGroup;
      3: groups := sys.GetControllingFaction;
      4:
        begin
          try
            sl.Text := sys.GetFactionList(Chr(13));
            for i2 := 0 to sl.Count - 1 do
              dataSeries.Values[sl[i2]] := (StrToInt64Def(dataSeries.Values[sl[i2]],0) + v).ToString;
          except
          end;
        end;
      5:
        begin
          try
            ctrlFac := sys.GetControllingFaction;
            sl.Text := sys.GetFactionList(Chr(13));
            for i2 := 0 to sl.Count - 1 do
            begin
              groups := sl[i2];
              v := 0; v2 := 0;
              if groups = ctrlFac then
                v := 1
              else
                v2 := 1;
              s := dataSeries.Values[groups];
              dataSeries.Values[groups] :=
                 (StrToInt64Def(s.Split(['|'])[0],0) + v).ToString + '|' +
                 (StrToInt64Def(s.Split(['|'])[1],0) + v2).ToString;
            end;
            groups := '';
          except
          end;
        end;
     end;

     if groups <> '' then
     begin
       s := dataSeries.Values[groups];
       if v2 = -1 then
         dataSeries.Values[groups] := (StrToInt64Def(s,0) + v).ToString
       else
       begin
         if s = '' then s := '|';
         dataSeries.Values[groups] :=
           (StrToInt64Def(s.Split(['|'])[0],0) + v).ToString + '|' +
           (StrToInt64Def(s.Split(['|'])[1],0) + v2).ToString;
       end;
     end;
{
    case groupBy of
      1:
        begin
          s := v.ToString;
          if v2 > -1 then
            s := s + '|' + v2.ToString;
          dataSeries.Values[sys.StarSystem] := s;
        end;
      2:
        begin
          s := dataSeries.Values[sys.TaskGroup];
          if v2 = -1 then
            dataSeries.Values[sys.TaskGroup] := (StrToInt64Def(s,0) + v).ToString
          else
          begin
            if s = '' then s := '|';
            dataSeries.Values[sys.TaskGroup] :=
              (StrToInt64Def(s.Split(['|'])[0],0) + v).ToString + '|' +
              (StrToInt64Def(s.Split(['|'])[1],0) + v2).ToString
          end;

        end;
      3:
        begin
          try
            s := sys.GetControllingFaction;
            dataSeries.Values[s] := (StrToInt64Def(dataSeries.Values[s],0) + v).ToString;
          except
          end;
        end;
      4:
        begin
          try
            sl.Text := sys.GetFactionList(Chr(13));
            for i2 := 0 to sl.Count - 1 do
              dataSeries.Values[sl[i2]] := (StrToInt64Def(dataSeries.Values[sl[i2]],0) + v).ToString;
          except
          end;
        end;
    end;
}
  end;

  if topCnt > 0 then
  if mode = 8 then
    dataSeries.CustomSort(CompareByValueSum)
  else
    dataSeries.CustomSort(CompareByValue);

  if topCnt > 1 then
  begin
    while (dataSeries.Count > 0) and (dataSeries.Count > topCnt) do
      dataSeries.Delete(0);
  end;
  sl.Free;
end;


procedure GetScoreHistoryData(mode: Integer; cmdr: string; taskGroup: string; maxDays: Integer; sysList: TStringList; var dataSeries: THashedStringList);
var cd: TConstructionDepot;
    ct: TConstructionType;
    sys: TStarSystem;
    s,mindts: string;
    i,i2,idx: Integer;
    dt: TDateTime;
    v: Int64;
    mileStones: THashedStringList;
begin
  dataSeries := THashedStringList.Create;
  mileStones := THashedStringList.Create;
  dt := NowUTC;
  SetWeekEndDate(dt);
  mindts := '';
  if maxDays > 0 then
    mindts := Copy(DateToISO8601(dt-maxdays),1,10);

  s := Copy(DateToISO8601(dt),1,10);
  while s > '2025-03' do  //Trailblazers start , todo: switch to journals start
  begin
    dataSeries.Values[s] := '0';
    dt := dt - 7;
    s := Copy(DateToISO8601(dt),1,10);
    if s < mindts then break;
  end;
  dataSeries.Sort;

  for i := 0 to DataSrc.Constructions.Count - 1 do
  begin
    cd := DataSrc.Constructions.ConstrByIdx[i];
    if not cd.Finished then continue;
    ct := cd.GetConstrType;
    if ct = nil then continue;
    sys := cd.GetSys;
    if sys = nil then continue;
    if (sysList = nil) or (sysList.Count = 0) then
    begin
      if not sys.IsOwnColony then continue
    end
    else
    begin
      if sysList.IndexOf(sys.StarSystem) = -1 then continue;
    end;

    if cmdr <> '' then
      if sys.Architect <> cmdr then continue;
    if taskGroup <> '' then
      if sys.TaskGroup <> taskGroup then continue;


    s := '2025-03-31';
    if cd.LastUpdate <> '' then
      s := Copy(cd.LastUpdate,1,10)
    else
      if mode = 2 then continue;
    if s < mindts then continue;
    dataSeries.Find(s,idx);
    if idx < dataSeries.Count then
      dataSeries.ValueFromIndex[idx] :=
        (StrToInt64Def(dataSeries.ValueFromIndex[idx],0) + ct.Score).ToString;

    //milestones = most investment in systems, by months
    s := Copy(s,1,7) + sys.StarSystem;
    mileStones.Values[s] :=
        (StrToInt64Def(mileStones.Values[s],0) + ct.Score).ToString;

  end;


  if mode = 1 then
  begin
    while (dataSeries.Count > 0) and (dataSeries.ValueFromIndex[dataSeries.Count-1] = '0') do
      dataSeries.Delete(dataSeries.Count-1);

    for i := 1 to dataSeries.Count - 1 do
    begin
      dataSeries.ValueFromIndex[i] :=
        (StrToInt64Def(dataSeries.ValueFromIndex[i],0) +
        StrToInt64Def(dataSeries.ValueFromIndex[i-1],0)).ToString;
    end;
  end;

  for i := 0 to mileStones.Count - 1 do
    mileStones[i] := mileStones.ValueFromIndex[i].PadLeft(5) + mileStones.Names[i];
  mileStones.Sort;
  for i := mileStones.Count - 1 downto Max(0,mileStones.Count - 24) do
  begin
    s := Copy(mileStones[i],6,7);
    dataSeries.Find(s,idx);
    if idx < dataSeries.Count then
      dataSeries.ValueFromIndex[idx] :=
        dataSeries.ValueFromIndex[idx] + '|' + Copy(mileStones[i],13,255);
  end;


  mileStones.Free;
end;

procedure GetConstrTypesData(mode: Integer; cmdr: string; taskGroup: string; sysList: TStringList; var dataSeries: THashedStringList);
var cd: TConstructionDepot;
    ct: TConstructionType;
    sys: TStarSystem;
    s: string;
    i,i2: Integer;
    dt: TDateTime;
    v: Int64;
begin
  dataSeries := THashedStringList.Create;

  for i := 0 to DataSrc.Constructions.Count - 1 do
  begin
    cd := DataSrc.Constructions.ConstrByIdx[i];
    if not cd.Finished  then  continue;
    ct := cd.GetConstrType;
    if ct = nil then continue;
    sys := cd.GetSys;
    if sys = nil then continue;
    if (sysList = nil) or (sysList.Count = 0) then
    begin
      if not sys.IsOwnColony then continue
    end
    else
    begin
      if sysList.IndexOf(sys.StarSystem) = -1 then continue;
    end;
    if cmdr <> '' then
      if sys.Architect <> cmdr then continue;
    if taskGroup <> '' then
      if sys.TaskGroup <> taskGroup then continue;

    s := 'T' + ct.Tier + ' ' + Copy(ct.Location,1,3) + ' ' + ct.Category;
    dataSeries.Values[s] := (StrToInt64Def(dataSeries.Values[s],0) + 1).ToString;
  end;

  while (dataSeries.Count > 0) and (dataSeries.ValueFromIndex[dataSeries.Count-1] = '0') do
    dataSeries.Delete(dataSeries.Count-1);

  dataSeries.Sort;

end;

procedure GetMarketData(mode: Integer; topCnt: Integer; var dataSeries: THashedStringList);
var m: TMarket;
    s: string;
    i,i2: Integer;
begin
  dataSeries := THashedStringList.Create;

  for i := 0 to DataSrc.RecentMarkets.Count - 1 do
  begin
    m := TMarket(DataSrc.RecentMarkets.Objects[i]);
    if m.PurchaseQty = 0 then continue;

    case mode of
      1: dataSeries.Values[m.StationName_abbrev(false)] := m.PurchaseQty.ToString;
    end;

  end;

  if topCnt > 0 then
  begin
    dataSeries.CustomSort(CompareByValue);
    while (dataSeries.Count > 0) and (dataSeries.Count > topCnt) do
      dataSeries.Delete(0);
  end;
end;

constructor TChartData.Create(id: string; src: string);
begin
  self.id := id;
  self.src := src;
  dataSeries := THashedStringList.Create;
  orgDataSeries := THashedStringList.Create;
  sysList := TSystemList.Create;
  LoadSetup;
end;

destructor TChartData.Destroy;
begin
  dataSeries.Free;
  orgDataSeries.Free;
  sysList.Free;
end;

procedure BuildChartList(var sl: TStringList);
begin
  sl := TStringList.Create;
  sl.AddPair('SCOREHIST','Total Score');
  sl.AddPair('SCOREWEEKLY','Weekly Score');
  sl.AddPair('SCOREW90','Weekly Score');
  sl.AddPair('POPHIST','Total Population');
  sl.AddPair('POPHISTM','Total Population');
  sl.AddPair('CONTRIBD30','Daily Contribution');
  sl.AddPair('CONTRIBD90','Daily Contribution');
  sl.AddPair('CONTRIBW90','Weekly Contribution');
  sl.AddPair('CONTRIBWYR','Weekly Contribution');
  sl.AddPair('FINCONHAUL','Finished Constructions (Tonage)');
  sl.AddPair('FINCONSCORE','Finished Constructions (Score)');
  sl.AddPair('FINCONTYPE','Finished Constructions (Types)');
  sl.AddPair('SYSPOP','System Population');
  sl.AddPair('TOP12POP','System Population');
  sl.AddPair('SYSPOPINC','System Population Growth');
  sl.AddPair('TOP12POPINC','System Population Growth');
  sl.AddPair('POPUPD','Population Update Candidates');
  sl.AddPair('SYSSCORE','System Score');
  sl.AddPair('TOP12SCORE','System Score');
  sl.AddPair('SYSPOPC','System Population and Daily Growth (scaled)');
  sl.AddPair('TOP12POPC','System Population and Daily Growth (scaled)');
  sl.AddPair('SYSPOPS','System Population and 30-day Growth');
  sl.AddPair('TOP12POPS','System Population and 30-day Growth');
  sl.AddPair('DEVELOP','System Development (raw)');
  sl.AddPair('TECHLEV','System Tech Level (raw)');
  sl.AddPair('TOP24DEVTECH','System Development/Tech Level (raw)');
  sl.AddPair('TGSCORE','Task Group Score');
  sl.AddPair('TGPOP','Task Group Population');
  sl.AddPair('TGPOPINC','Task Group Population Growth');
  sl.AddPair('TGPOPS','Task Group Population and 30-day Growth');
  sl.AddPair('FACSCORE','Faction Score');
  sl.AddPair('FACPOP','Faction Population');
  sl.AddPair('FACPOPS','Faction Population and 30-day Growth');
  sl.AddPair('FACPOPINC','Faction Population Growth');
  sl.AddPair('FACCTRL','Faction Controlled Systems');
  sl.AddPair('FACPRESENCE','Faction Presence');
  sl.AddPair('FACPRESCTRL','Faction Presence/Control');
  sl.AddPair('MARKETS','Markets by Purchases');
  sl.AddPair('CONSTRHIST','Construction Contribution');
  sl.AddPair('','(no chart)');
end;


procedure TChartData.LoadSetup;
var cvals,copts: TArray<string>;
    i: Integer;
begin
  if id = 'CONTRIBD30' then
  begin
    InitData([coAvgLine,coExtraBarSep],[],1,ctColumn,csRedGreen);
  end else
  if id = 'SCOREHIST' then
  begin
    InitData([coMarkers],[],4,ctLine,csColdToWarm);
  end else
  if id = 'SCOREWEEKLY' then
  begin
    InitData([coValLabels],[],1,ctColumn,csRedGreen);
  end else
  if id = 'SCOREW90' then
  begin
    InitData([coValLabels],[],1,ctColumn,csRedGreen);
  end else
  if id = 'CONTRIBD90' then
  begin
    InitData([coAvgLine],[],1,ctColumn,csRedGreen);
  end else
  if id = 'CONTRIBW90' then
  begin
    InitData([coValLabels,coAvgLine],[],1,ctColumn,csRedGreen);
  end else
  if id = 'CONTRIBWYR' then
  begin
    InitData([coAvgLine],[],1,ctColumn,csRedGreen);
  end else
  if id = 'FINCONHAUL' then
  begin
    InitData([coReversed,coAvgLine],[],1,ctColumn,csCyclic);
  end else
  if id = 'FINCONSCORE' then
  begin
    InitData([coReversed,coValLabels,coAvgLine],[],1,ctColumn,csCyclic);
  end else
  if id = 'FINCONTYPE' then
  begin
    InitData([coReversed,coValLabels],[],1,ctColumn,csCyclic);
  end else
  if id = 'POPHIST' then
  begin
    InitData([],[],4,ctLine,csRedToGreen);
  end else
  if id = 'POPHISTM' then
  begin
    InitData([coMarkers],[],4,ctLine,csRedToGreen);
  end else
  if (id = 'SYSPOP') or (id = 'TOP12POP') then
  begin
    InitData([],[],1,ctColumn,csColdToWarm);
  end else
  if (id = 'SYSPOPINC') or (id = 'TOP12POPINC') then
  begin
    InitData([coValLabels,coGradientX],[],1,ctBar,csSunset,0.95);
  end else
  if id = 'POPUPD' then
  begin
    InitData([coValLabels,coExtraBarSep],[daTop12],1,ctColumn,csSunset);
  end else
  if (id = 'SYSSCORE') or (id = 'TOP12SCORE') then
  begin
    InitData([coValLabels,coExtraBarSep,coCategoryColors],[],1,ctColumn,csRedToGreen2);
  end else
  if (id = 'SYSPOPC') or (id = 'TOP12POPC') then
  begin
    InitData([],[],1,ctCombo,csColdToWarm);
  end else
  if (id = 'SYSPOPS') or (id = 'TOP12POPS') then
  begin
    InitData([coGradientX,coValLabels],[],1,ctStacked,csSunset);
  end else
  if id = 'DEVELOP' then
  begin
    InitData([coValLabels,coExtraBarSep,coCategoryColors],[],1,ctColumn,csRedToGreen2);
  end else
  if id = 'TECHLEV' then
  begin
    InitData([coValLabels,coExtraBarSep,coCategoryColors],[],1,ctColumn,csRedToGreen2);
  end else
  if id = 'TOP24DEVTECH' then
  begin
    InitData([],[],1,ctScatter,csCyclic);
  end else
  if id = 'TGSCORE' then
  begin
    InitData([coValLabels],[],1,ctColumn,csGolden);
  end else
  if id = 'TGPOP' then
  begin
    InitData([coValLabels],[],1,ctColumn,csGolden);
  end else
  if id = 'TGPOPINC' then
  begin
    InitData([coValLabels],[],1,ctColumn,csRedToGreen);
  end else
  if id = 'TGPOPS' then
  begin
    InitData([coGradientX,coValLabels],[],1,ctStacked,csSunset);
  end else
  if id = 'FACSCORE' then
  begin
    InitData([coValLabels],[],1,ctColumn,csGolden);
  end else
  if id = 'FACPOP' then
  begin
    InitData([coValLabels],[],1,ctColumn,csGolden);
  end else
  if id = 'FACPOPS' then
  begin
    InitData([coGradientX,coValLabels],[],1,ctStacked,csSunset);
  end else
  if id = 'FACPOPINC' then
  begin
    InitData([],[],1,ctColumn,csRedToGreen);
  end else
  if id = 'FACCTRL' then
  begin
    InitData([coValLabels],[],1,ctColumn,csGolden);
  end else
  if id = 'FACPRESENCE' then
  begin
    InitData([coValLabels],[],1,ctColumn,csGolden);
  end else
  if id = 'FACPRESCTRL' then
  begin
    InitData([coGradientX,coValLabels],[],1,ctStacked,csSunset);
  end else
  if id = 'MARKETS' then
  begin
    InitData([],[],1,ctColumn,csRedToGreen);
  end else
  if id = 'CONSTRHIST' then
  begin
    InitData([coAvgLine,coValLabels,coExtraBarSep,coStackColors,coAvgSkipZero,
      coSegmentedBar,coSharedScale],[daExcludeZero],1,ctDual,csSunset);
  end else
    self.id := '';

  IsCustom := false;

  try
  if id <> '' then
  begin
    cvals := SplitString(Opts.Val['Chart.' + id + '.' + src], '|');
    if Length(cvals) > 0 then
    begin
      isCustom := true;
      chartType := TChartType(GetEnumValue(TypeInfo(TChartType), cvals[0]));
      colorScheme := TChartColorScheme(GetEnumValue(TypeInfo(TChartColorScheme), cvals[1]));
      chartOptions := [];
      copts := SplitString(cvals[2], ',');
      for i := 0 to Length(copts) - 1 do
        if copts[i] <> '' then
          chartOptions := chartOptions +
            [TChartOption(GetEnumValue(TypeInfo(TChartOption), copts[i]))];
      dataAdjustments := [];
      copts := SplitString(cvals[3], ',');
      for i := 0 to Length(copts) - 1 do
        if copts[i] <> '' then
          dataAdjustments := dataAdjustments +
            [TDataAdjustment(GetEnumValue(TypeInfo(TDataAdjustment), copts[i]))];
    end;
      //
  end;
  except
    ShowMessage('Failed to load settings for chart: ' + id);
  end;
end;

procedure TChartData.Assign(cd: TChartData);
begin
  id := cd.id;
  src := cd.src;
  baseTitle := cd.baseTitle;
  title := cd.title;
  cmdr := cd.cmdr;
  sysList.Assign(cd.sysList);
  taskGroup := cd.taskGroup;

  dataSeries.Assign(cd.dataSeries);
  chartType := cd.chartType;
  chartOptions := cd.chartOptions;
  colorScheme := cd.colorScheme;
  dataAdjustments := cd.dataAdjustments;
  labStep := cd.labStep;
  topCnt := cd.topCnt;
  barThickness := cd.barThickness;
  chartObject := cd.chartObject;
end;

procedure TChartData.SaveSetup;
var s: string;
    co: TChartOption;
    da: TDataAdjustment;
    storedOptions: TChartOptions;
begin
  if id = '' then Exit;
  
  s := GetEnumName(TypeInfo(TChartType), Ord(chartType)) + '|' +
       GetEnumName(TypeInfo(TChartColorScheme), Ord(colorScheme)) + '|';
  storedOptions := chartOptions - cTransientOptions;
  for co := Low(TChartOption) to High(TChartOption) do
    if co in chartOptions then
      s := s + GetEnumName(TypeInfo(TChartOption), Ord(co)) + ',';
  s := s + '|';
  for da := Low(TDataAdjustment) to High(TDataAdjustment) do
    if da in dataAdjustments then
      s := s + GetEnumName(TypeInfo(TDataAdjustment), Ord(da)) + ',';

  Opts.Val['Chart.' + id + '.' + src] := s;
  Opts.Save;
end;

procedure TChartData.ResetSetup;
begin
  try
    Opts.Delete(Opts.IndexOfName('Chart.' + id + '.' + src));
    Opts.Save;
  except end;
  LoadSetup;
end;

procedure TChartData.InitData(chartOptions: TChartOptions; dataAdjustments: TDataAdjustments;
  labStep: Integer; chartType: TChartType; colorScheme: TChartColorScheme;
  const barThickness: Double = 1.0);
begin
  self.baseTitle := ChartList.Values[id];
  self.chartOptions := chartOptions;
  self.dataAdjustments := dataAdjustments;
  self.labStep := labStep;
  self.chartType := chartType;
  self.colorScheme := colorScheme;
  self.barThickness := barThickness;
end;

procedure TChartData.Update;
var cd: TConstructionDepot;
begin
  orgDataSeries.Clear;
//  if id = '' then Exit;
  dataSeries.Free;
  dataSeries := nil;

  title := baseTitle;
  if cmdr <> '' then
    title := title + ' - ' + DataSrc.Commanders.Values[cmdr];
  if taskGroup <> '' then
    title := title + ' / ' + taskGroup;
  if (sysList <> nil) and (sysList.Count > 0) then
    if sysList.Count = 1 then
      title := title + ' / ' + sysList[0]
    else
      title := title + ' / multiple systems';
  if isCustom then
    title := title + ' *';

  if id = 'CONTRIBD30' then
  begin
    GetContribData(1, cmdr, taskGroup, dataSeries);
    labStep := 1 + dataseries.Count div 45;
  end else
  if id = 'SCOREHIST' then
  begin
    GetScoreHistoryData(1, cmdr, taskGroup,  0, sysList, dataSeries);
  end else
  if id = 'SCOREWEEKLY' then
  begin
    GetScoreHistoryData(2, cmdr, taskGroup, 0, sysList,  dataSeries);
    labStep := 1 + dataseries.Count div 45;
  end else
  if id = 'SCOREW90' then
  begin
    GetScoreHistoryData(2, cmdr, taskGroup, 90, sysList,  dataSeries);
    labStep := 1;
  end else
  if id = 'CONTRIBD90' then
  begin
    GetContribData(2, cmdr, taskGroup, dataSeries);
    labStep := 1 + dataseries.Count div 45;
  end else
  if id = 'CONTRIBW90' then
  begin
    GetContribData(3, cmdr, taskGroup, dataSeries);
    labStep := 1 + dataseries.Count div 45;
  end else
  if id = 'CONTRIBWYR' then
  begin
    GetContribData(4, cmdr, taskGroup, dataSeries);
    labStep := 1 + dataseries.Count div 45;
  end else
  if id = 'FINCONHAUL' then
  begin
    GetFinishedConstrData(1, cmdr, taskGroup, sysList, dataSeries);
  end else
  if id = 'FINCONSCORE' then
  begin
    GetFinishedConstrData(2, cmdr, taskGroup, sysList, dataSeries);
  end else
  if id = 'FINCONTYPE' then
  begin
    GetConstrTypesData(1, cmdr, taskGroup, sysList, dataSeries);
  end else
  if (id = 'POPHIST') or (id = 'POPHISTM') then
  begin
    GetPopHistoryData(1, cmdr, taskGroup, sysList, dataSeries);
  end else
  if id = 'SYSPOP' then
  begin
    GetSystemStatData(1, 1, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'TOP12POP' then
  begin
    GetSystemStatData(1, 1, cmdr, taskGroup, nil, 12, dataSeries);
  end else
  if id = 'SYSPOPINC' then
  begin
    GetSystemStatData(2, 1, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'TOP12POPINC' then
  begin
    GetSystemStatData(2, 1, cmdr, taskGroup, nil, 12, dataSeries);
  end else
  if id = 'POPUPD' then
  begin
    GetSystemStatData(10, 1, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'SYSSCORE' then
  begin
    GetSystemStatData(3, 1, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'TOP12SCORE' then
  begin
    GetSystemStatData(3, 1, cmdr, taskGroup, nil, 12, dataSeries);
  end else
  if id = 'SYSPOPC' then
  begin
    GetSystemStatData(4, 1, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'TOP12POPC' then
  begin
    GetSystemStatData(4, 1, cmdr, taskGroup, nil, 12, dataSeries);
  end else
  if id = 'SYSPOPS' then
  begin
    GetSystemStatData(8, 1, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'TOP12POPS' then
  begin
    GetSystemStatData(8, 1, cmdr, taskGroup, nil, 12, dataSeries);
  end else
  if id = 'DEVELOP' then
  begin
    GetSystemStatData(5, 1, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'TECHLEV' then
  begin
    GetSystemStatData(6, 1, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'TOP24DEVTECH' then
  begin
    GetSystemStatData(7, 1, cmdr, taskGroup, sysList, 24, dataSeries);
  end else
  if id = 'TGSCORE' then
  begin
    GetSystemStatData(3, 2, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'TGPOP' then
  begin
    GetSystemStatData(1, 2, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'TGPOPINC' then
  begin
    GetSystemStatData(2, 2, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'TGPOPS' then
  begin
    GetSystemStatData(8, 2, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'FACSCORE' then
  begin
    GetSystemStatData(3, 3, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'FACPOP' then
  begin
    GetSystemStatData(1, 3, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'FACPOPS' then
  begin
    GetSystemStatData(8, 3, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'FACPOPINC' then
  begin
    GetSystemStatData(2, 3, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'FACCTRL' then
  begin
    GetSystemStatData(9, 3, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'FACPRESENCE' then
  begin
    GetSystemStatData(9, 4, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'FACPRESCTRL' then
  begin
    GetSystemStatData(9, 5, cmdr, taskGroup, sysList, 1, dataSeries);
  end else
  if id = 'MARKETS' then
  begin
    GetMarketData(1, 24, dataSeries);
  end else
  if id = 'CONSTRHIST' then
  begin
    cd := TConstructionDepot(chartObject);
    if cd = nil then
      cd := EDCDForm.CurrentDepot;
    GetConstrContrib(1, cd, cmdr, dataSeries);
    if cd <> nil then
      title := baseTitle + ' / ' + cd.StationName_abbrev;
  end else
    ;


  if dataSeries = nil then
    svgSource := ''
  else
  begin
    AdjustDataSeries;
    UpdateSvg;
  end;
end;

procedure TChartData.UpdateSvg;
var co: TChartOptions;
begin
  co := chartOptions;
//  if src = 'M' then
//    co := co + [coNoTitle, coNoBackground, coNoEmpty]; //minicharts
  svgSource := GenerateSVG(dataSeries,'',title,co,labStep,chartType,colorScheme,barThickness);
end;

procedure TChartData.AdjustDataSeries;
var s: string;
    dt: TDateTime;
    i,timeline,topcnt: Integer;
    sorted: Boolean;
begin
  if orgDataSeries.Count = 0 then
  begin
    if dataAdjustments = [] then Exit;
    orgDataSeries.Assign(dataSeries);
  end
  else
    dataSeries.Assign(orgDataSeries);

  if daExcludeZero in dataAdjustments then
  begin
    for i := dataSeries.Count - 1 downto 0 do
      if SumFirstTwo(dataSeries.ValueFromIndex[i]) = 0 then
        dataSeries.Delete(i);
  end;


  sorted := False;
  if daSort in dataAdjustments then
  begin
    dataSeries.CustomSort(CompareByValue);
    sorted := True;
  end;
  if daSumSort in dataAdjustments then
  begin
    dataSeries.CustomSort(CompareByValueSum);
    sorted := True;
  end;

  timeline := 0;
  if daTime3m in dataAdjustments then timeline := 1;
  if daTime6m in dataAdjustments then timeline := 2;
  if daTime12m in dataAdjustments then timeline := 3;
  if daTimeYTD in dataAdjustments then timeline := 4;
  if timeline > 0 then
    if (dataSeries.Count = 0) or (not dataSeries.Names[0].StartsWith('20')) then
      timeline := 0;
  if timeline > 0 then
  begin
    dataSeries.Sort;
    dt := NowUTC;
    case timeline of
      1: dt := IncMonth(dt,-3);
      2: dt := IncMonth(dt,-6);
      3: dt := IncMonth(dt,-12);
      4: dt := EncodeDate(YearOf(dt), 1, 1);
    end;
    s := Copy(DateToISO8601(dt),1,10);
    while (dataSeries.Count > 0) and (dataSeries.Names[0] < s) do
      dataSeries.Delete(0);
  end;

  topcnt := 0;
  if daTop12 in dataAdjustments then topcnt := 12;
  if daTop24 in dataAdjustments then topcnt := 24;
  if topcnt > 0 then
  begin
    if not sorted then
      dataSeries.CustomSort(CompareByValue);
    while (dataSeries.Count > 0) and (dataSeries.Count > topcnt) do
      dataSeries.Delete(0);
  end;

  if sorted then
    chartOptions := chartOptions - [coReversed];

end;

procedure TChartData.ToggleDataAdj(da: TDataAdjustment);
begin
  if da in dataAdjustments then
    dataAdjustments := dataAdjustments - [da]
  else
  begin
    if da in cChartSortModes then
      dataAdjustments := dataAdjustments - cChartSortModes;
    if da in cChartTimeLines then
      dataAdjustments := dataAdjustments - cChartTimeLines;
    if da in cChartCategoryFilters then
      dataAdjustments := dataAdjustments - cChartCategoryFilters;

    dataAdjustments := dataAdjustments + [da];
  end;
  AdjustDataSeries;
  UpdateSvg;
end;

initialization

BuildChartList(ChartList);

end.
