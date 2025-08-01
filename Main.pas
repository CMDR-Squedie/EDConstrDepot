﻿unit Main;


interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.PsAPI, Winapi.ShellAPI, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, System.IOUtils, System.Math, System.StrUtils,
  Vcl.ExtCtrls, Vcl.Menus, Vcl.ComCtrls, System.Types, Settings, DataSource;

type TCDCol = (colReq,colText,colStock,colStatus);

type
  TEDCDForm = class(TForm, IEDDataListener)
    TextColLabel: TLabel;
    ReqQtyColLabel: TLabel;
    StockColLabel: TLabel;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    ExitMenuItem: TMenuItem;
    FleetCarrierSubMenu: TMenuItem;
    ToggleExtCargoMenuItem: TMenuItem;
    SelectDepotSubMenu: TMenuItem;
    SwitchDepotMenuItem: TMenuItem;
    N2: TMenuItem;
    DividerTop: TShape;
    TitleLabel: TLabel;
    DividerBottom: TShape;
    CloseLabel: TLabel;
    MinimizeMenuItem: TMenuItem;
    BackdropMenuItem: TMenuItem;
    AddDepotInfoMenuItem: TMenuItem;
    MarketAsDepotMenuItem: TMenuItem;
    NewWindowMenuItem: TMenuItem;
    SelectMarketSubMenu: TMenuItem;
    SwitchMarketMenuItem: TMenuItem;
    UpdTimer: TTimer;
    ManageAllMenuItem: TMenuItem;
    SettingsMenuItem: TMenuItem;
    StatusPaintBox: TPaintBox;
    IncludeExtCargoinRequestMenuItem: TMenuItem;
    UseAsStockMenuItem: TMenuItem;
    ComparePurchaseOrderMenuItem: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    TaskGroupSubMenu: TMenuItem;
    NoTaskGroupMenuItem: TMenuItem;
    TaskGroupSeparator: TMenuItem;
    NewTaskGroupMenuItem: TMenuItem;
    N5: TMenuItem;
    CurrentTGMenuItem: TMenuItem;
    ResetDockTimeMenuItem: TMenuItem;
    FlightHistoryMenuItem: TMenuItem;
    DeliveriesSubMenu: TMenuItem;
    ManageColoniesMenuItem: TMenuItem;
    ManageMarketsMenuItem: TMenuItem;
    N6: TMenuItem;
    SystemInfoMenuItem: TMenuItem;
    SystemInfoCurrentMenuItem: TMenuItem;
    Wiki1: TMenuItem;
    ManageContructionsMenuItem: TMenuItem;
    StarMapMenuItem: TMenuItem;
    SummaryMenuItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure UpdTimerTimer(Sender: TObject);
    procedure TextColLabelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TextColLabelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Layer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExitMenuItemClick(Sender: TObject);
    procedure ToggleExtCargoMenuItemClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure SwitchDepotMenuItemClick(Sender: TObject);
    procedure SwitchFleetCarrierMenuItemClick(Sender: TObject);
    procedure MinimizeMenuItemClick(Sender: TObject);
    procedure AddDepotInfoMenuItemClick(Sender: TObject);
    procedure MarketAsDepotMenuItemClick(Sender: TObject);
    procedure NewWindowMenuItemClick(Sender: TObject);
    procedure ToggleTitleBar(activef: Boolean);
    procedure AppActivate(Sender: TObject);
    procedure AppDeactivate(Sender: TObject);
    procedure SwitchMarketMenuItemClick(Sender: TObject);
    procedure AddRecentMarketMenuItemClick(Sender: TObject);
    procedure ForgetMarketMenuItemClick(Sender: TObject);
    procedure IgnoreMarketMenuItemClick(Sender: TObject);
    procedure ManageAllMenuItemClick(Sender: TObject);
    procedure SettingsMenuItemClick(Sender: TObject);
    procedure AutoSelectMarketMenuItemClick(Sender: TObject);
    procedure TitleLabelDblClick(Sender: TObject);
    procedure TextColLabelDblClick(Sender: TObject);
    procedure StatusPaintBoxPaint(Sender: TObject);
    procedure IncludeExtCargoinRequestMenuItemClick(Sender: TObject);
    procedure UseAsStockMenuItemClick(Sender: TObject);
    procedure ComparePurchaseOrderMenuItemClick(Sender: TObject);
    procedure Layer1Click(Sender: TObject);
    procedure Layer1DblClick(Sender: TObject);
    procedure SwitchTaskGroupMenuItemClick(Sender: TObject);
    procedure NewTaskGroupMenuItemClick(Sender: TObject);
    procedure MarketInfoMenuItemClick(Sender: TObject);
    procedure ResetDockTimeMenuItemClick(Sender: TObject);
    procedure FlightHistoryMenuItemClick(Sender: TObject);
    procedure ReqQtyColLabelDblClick(Sender: TObject);
    procedure CopyReqQtyMenuItemClick(Sender: TObject);
    procedure PasteReqQtyMenuItemClick(Sender: TObject);
    procedure ClearReqQtyMenuItemClick(Sender: TObject);
    procedure UseMaxReqQtyMenuItemClick(Sender: TObject);
    procedure ActiveConstrMenuItemClick(Sender: TObject);
    procedure ConstructionTypesMenuItemClick(Sender: TObject);
    procedure ManageMarketsMenuItemClick(Sender: TObject);
    procedure ManageColoniesMenuItemClick(Sender: TObject);
    procedure SystemInfoMenuItemClick(Sender: TObject);
    procedure SystemInfoCurrentMenuItemClick(Sender: TObject);
    procedure Wiki1Click(Sender: TObject);
    procedure StarMapMenuItemClick(Sender: TObject);
    procedure SummaryMenuItemClick(Sender: TObject);
private
    { Private declarations }
    FSelectedConstructions: TStringList;
    FSelectedItems: TStringList;
    FCurrentDepot: TConstructionDepot;
    FSecondaryMarket: TMarket;
    FAutoSelectMarket: Boolean;
    FUseEmptyDepot: Boolean;
    FFlightHistory: Boolean;
    FWorkingDir,FJournalDir: string;
//    FSettings: TSettings;
    FTransColor: TColor;
    FShadowTimer: Integer;
    FLastActiveWnd: HWND;
    FEliteWnd: HWND;
    FBackdrop: Boolean;
    FTextHeight: Integer;
    FItemsShown: Integer;
    FLastBkgColor: Integer;
    FLastClipbrdStr: string;
    FCrossHair: TForm;
    FLayer1: TForm;
    FIndicators: TStringList;
    procedure ResetAlwaysOnTop;
    procedure ApplySettings;
    procedure UpdateBackdrop;
    procedure SetupLayers;
    procedure ArrangeLayers;
    procedure UpdateLayersPos;
    procedure UpdateTransparency;
    function FindBestMarket(reqList: TStringList; prevMarket: TMarket): TMarket;
    function GetItemMarketIndicators(normItem: string; reqQty: Integer; cargo: Integer; bestMarket: TMarket): string;
    function IsEliteActiveWnd: Boolean;
  public
    { Public declarations }
    procedure OnEDDataUpdate;
    procedure UpdateConstrDepot;
    procedure AddDepotToGroup(cd: TConstructionDepot);
    procedure SetDepot(mID: string; groupf: Boolean);
    procedure SetDepotGroup(mIDs: string);
    procedure SetSecondaryMarket(mID: string);
    procedure MarketAsDepotDlg(m: TMarket);
    procedure MarketAsExtCargoDlg(m: TMarket; mode: Integer);
    procedure OnChangeSettings;
    property CurrentDepot: TConstructionDepot read FCurrentDepot;
  end;

var
  EDCDForm: TEDCDForm;
 gLastCursorPos: TPoint;
 gTimersSuspended: Boolean;

implementation

{$R *.dfm}

uses Splash, Markets, SettingsGUI, MarketInfo, Clipbrd, Colonies, StationInfo,
  SystemInfo, ConstrTypes, Toolbar, StarMap, Summary;

const cDefaultCapacity: Integer = 784;

procedure TEDCDForm.TextColLabelDblClick(Sender: TObject);
var sl: TStringList;
    pt: TPoint;
    idx,p,p2,px: Integer;
    s: string;
    r: TRect;
begin
   pt := Mouse.CursorPos;
   sl := TStringList.Create;
   sl.Text := TextColLabel.Caption;
   try
     pt := TextColLabel.ScreenToClient(pt);
     idx := pt.Y div FTextHeight;
     if (idx >= 0)  and (idx < sl.Count) then
     begin
       s := LowerCase(sl[idx]);
       if idx >= FItemsShown then
       begin
         p := Pos('/',s);
         px := self.Canvas.TextWidth(Copy(s,1,p));

         s := Trim(RightStr(s,100)); //full names hidden in padded string
         p := Pos('/',s);
         p2 := Pos('⇨',s);

         if ((p > 0) and (pt.X > px)) or (p2 > 0) then
         begin
           s := Copy(s,p+1,200);
           Clipboard.SetTextBuf(PChar(s));
           SplashForm.ShowInfo('System name copied...',1000);
           Exit;
         end;

         if p > 0 then
           s := Copy(s,1,p-1)
         else
           Exit;
       end;
       MarketsForm.SetMarketFilter(s,idx<FItemsShown);

     end;
   finally
     sl.Free;

   end;
end;

procedure TEDCDForm.TextColLabelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  gLastCursorPos := Mouse.CursorPos;
end;

procedure TEDCDForm.TextColLabelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var pt: TPoint;
begin
  if ssLeft in Shift then
  begin
    pt := Mouse.CursorPos;
    self.Left := self.Left + pt.X - gLastCursorPos.X;
    self.Top := self.Top + pt.Y - gLastCursorPos.Y;
    UpdateLayersPos;
    ToolbarForm.UpdatePosition;
    gLastCursorPos := pt;
  end;
end;

procedure TEDCDForm.UpdateBackdrop;
begin
  if FBackdrop then
  begin
    self.Color := clBlack;
    self.TransparentColor := false;
  end
  else
  begin
    self.Color := FTransColor;
    self.TransparentColor := true;
  end;
end;

procedure TEDCDForm.TitleLabelDblClick(Sender: TObject);
begin
  FBackdrop := not FBackdrop;
  UpdateBackdrop;
end;

procedure TEDCDForm.AddDepotInfoMenuItemClick(Sender: TObject);
var orgs,s: string;
begin
  if FCurrentDepot = nil then Exit;

  StationInfoForm.SetStation(FCurrentDepot);
  StationInfoForm.RestoreAndShow;
  {
  orgs := DataSrc.MarketComments.Values[FCurrentDepot.MarketID];
  s := Vcl.Dialogs.InputBox(FCurrentDepot.StationName_full, 'Info', orgs);
  if s <> orgs then
    DataSrc.UpdateMarketComment(FCurrentDepot.MarketID,s);
  }
end;


procedure TEDCDForm.ToggleExtCargoMenuItemClick(Sender: TObject);
begin

  if ToggleExtCargoMenuItem.Checked then
    Opts['UseExtCargo'] := '0'
  else
    Opts['UseExtCargo'] := '1';
//  Opts.Flags['UseExtCargo'] := not Opts.Flags['UseExtCargo'] ;
  UpdateConstrDepot;
end;

procedure TEDCDForm.MarketAsExtCargoDlg(m: TMarket; mode: Integer);
begin
  if m = nil then Exit;
  if m.MarketID = '' then Exit;
  if m.Snapshot then Exit;
  if m.StationType <> 'FleetCarrier' then
    if Opts['AnyMarketAsDepot'] <> '1' then
    begin
      ShowMessage('Market is not a Fleet Carrier.' + Chr(13) + 'Visit a valid Commodity market and try again.');
      Exit;
    end;

{
  if Vcl.Dialogs.MessageDlg('Do you want to use ' +
    m.StationName + ' as active Fleet Carrier?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;
}
  if mode <> -1 then
    Opts['UseExtCargo'] := IntToStr(mode);
  DataSrc.MarketToCargoExt(m.MarketID);
  UpdateConstrDepot;
end;

procedure TEDCDForm.UseAsStockMenuItemClick(Sender: TObject);
begin
  MarketAsExtCargoDlg(DataSrc.CargoExt,1);
end;


procedure TEDCDForm.Wiki1Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://github.com/CMDR-Squedie/EDConstrDepot/wiki', nil, nil, SW_SHOWNORMAL);
end;

function TEDCDForm.FindBestMarket(reqList: TStringList; prevMarket: TMarket): TMarket;
var i,mi,score,maxscore,reqQty,shipQty,stock,totAvail,lowCnt,uniqueCnt,bonus,extraJumps: Integer;
    m: TMarket;
    normItem,tg: string;
    testf: Boolean;
    mlev: TMarketLevel;
    d: Extended;
begin
  Result := nil;
  maxscore := 0;
  for mi := 0 to DataSrc.RecentMarkets.Count - 1 do
  begin
    m := TMarket(DataSrc.RecentMarkets.Objects[mi]);
    testf := true;
    if m.MarketID = DataSrc.Market.MarketID then testf := false;
    if (prevMarket <> nil) and (m.MarketID = prevMarket.MarketID) then testf := false;
    mlev := DataSrc.GetMarketLevel(m.MarketID);
    tg := DataSrc.MarketGroups.Values[m.MarketID];
    if tg <> '' then
      if (DataSrc.TaskGroup <> '') and (DataSrc.TaskGroup <> tg) then testf := false;
    if mlev = miIgnore then testf := false;
    if testf then
    begin
      score := 0;
      totAvail := 0;
      lowCnt := 0;
      uniqueCnt := 0;
      for i := 0 to reqList.Count - 1 do
      begin
        normItem := LowerCase(reqList.Names[i]);
        reqQty := StrToIntDef(reqList.ValueFromIndex[i],0);
        if DataSrc.Cargo[normItem] >= reqQty then continue;
        shipQty := reqQty;
        if shipQty > DataSrc.Capacity then shipQty := DataSrc.Capacity;


        stock := m.Stock[normItem];
        if stock > 0 then
        begin
//base points for stocking the commodity
          score := score + 100;

//base points for priority/selected commodities (still need to compare markets, hence the score)
          if {(prevMarket <> nil) and} (FSelectedItems.IndexOf(normItem) <> -1) then
            if stock >= shipQty then
              score := score + 100000;

//bonus for stocking other items than pre-selected market
          if (prevMarket <> nil) and (prevMarket.Stock[normItem] < shipQty) then
          begin
            score := score + 20;
            if stock >= shipQty then
            begin
              score := score + 40;   //40
              uniqueCnt := uniqueCnt + 1;
            end;
          end;
//or, a penalty  for stocking same items as pre-selected market
{
          if (prevMarket <> nil) and
            ((prevMarket.Stock[s] >= DataSrc.Capacity) or (prevMarket.Stock[s] >= reqQty)) then
          begin
            score := score - 50;
          end;
}

//extra points for station in same system
          if (FCurrentDepot <> nil) and (m.StarSystem = FCurrentDepot.StarSystem) then
          begin
            score := score + 10;
            if stock >= shipQty then
              if prevMarket = nil then
                score := score + 100;
          end;

//extra points for station other than last visited (just for variety)
          if DataSrc.Market.Stock[normItem] <= 0 then
            score := score + 20;

          if stock < reqQty then
          begin
            totAvail := totAvail + stock;
//penalty points for low stock
            if stock < DataSrc.Capacity then
              score := score - 50
            else
              score := score - 10;
          end
          else
          begin
            totAvail := totAvail + reqQty;
//extra points for quickly clearing the request list (minimum 20% capacity)
            if (DataSrc.Capacity div reqQty) >= 5  then
            begin
              score := score + 50;
              lowCnt := lowCnt + 1;
            end;
          end;
        end;
      end;

//penalty points for under capacity run
      if totAvail < DataSrc.Capacity then
      begin
        score := score - 30 * lowCnt;
//        score := score div 2;
        score := score * 2 div 3; //33% penalty
      end
      else
//bonus for unique items, applied only when at full capacity, for last market only
        score := score + uniqueCnt * 1000;

//bonus/penalty for distance from star
      if score > 0 then
      begin
        if m.DistFromStar <= 3000  then
        begin
          bonus := 3000 - m.DistFromStar;
          bonus := 15 * (bonus * bonus) div (3000*3000); //15% bonus dimnishing with square of distance
          score := score * (100 + bonus + 1) div 100
        end
        else
          //no bonus nor penalty between 3kLs and 10kLs
          score := score * 30 div (30 + m.DistFromStar div 10000);  //reverse 1% penalty for each 10kLs
      end;

//penalty for system distance (above 2 jumps back and forth)
      if score > 0 then
      begin
        d := m.DistanceTo(FCurrentDepot);
        if (d > 0) and (DataSrc.JumpRange > 0)  then
        begin
          extraJumps := Ceil(d / DataSrc.MaxJumpRange) + Ceil(d / DataSrc.JumpRange) - 2;
          score := score * 6 div (6 + extraJumps);  // reverse 16% penalty for each extra jump
        end;
      end;

//penalty for no large pads
      if score > 0 then
        if m.LPads = 0 then
          score := score * 2 div 3;  //33% penalty

//bonus for favorite market
      if score > 0 then
      begin
        if mlev = miFavorite then
          score := score * 125 div 100;  //25% bonus
        if mlev = miPriority then
          score := score * 150 div 100;  //50% bonus
      end;

      if score > maxscore then
      begin
        maxscore := score;
        Result := m;
        //m.LastScore := IntToStr(score);
      end;
    end;
  end;
end;

procedure TEDCDForm.FlightHistoryMenuItemClick(Sender: TObject);
begin
  FFlightHistory := not FFlightHistory;
  UpdateConstrDepot;
end;

function TEDCDForm.GetItemMarketIndicators(normItem: string; reqQty: Integer; cargo: Integer; bestMarket: TMarket): string;
var stock,maxQty: Integer;
    indPad: string;
    s: string;
    procedure AddMarker(q: Integer; const a: string; const b: string);
    begin
      if q > 0 then
      begin
        if q >= maxQty then
          s := s + a
        else
          s := s + b;
      end
      else
        s := s + indPad;
    end;
begin
  Result := '';

  indPad := '';
  if Opts.Flags['IndicatorsPadding'] then indPad := ' ';

  stock := DataSrc.Market.Stock[normItem];
  maxQty := reqQty;
  if Opts['IncludeSupply'] = '1' then
    if maxQty > DataSrc.Capacity then
      maxQty := DataSrc.Capacity;

  if not Opts.Flags['IncludeSupply'] then
  begin
    AddMarker(stock,'□','□');
    if bestMarket <> nil then
      AddMarker(bestMarket.Stock[normItem],'○','○');
    if FSecondaryMarket <> nil then
      AddMarker(FSecondaryMarket.Stock[normItem],'△','△');
  end
  else
  begin
    AddMarker(stock,'■','□');
    if bestMarket <> nil then
      AddMarker(bestMarket.Stock[normItem],'●','○');
    if FSecondaryMarket <> nil then
      AddMarker(FSecondaryMarket.Stock[normItem],'▲','△');
  end;
  Result := s;
end;

procedure TEDCDForm.IgnoreMarketMenuItemClick(Sender: TObject);
begin
  if FSecondaryMarket = nil then Exit;

  DataSrc.SetMarketLevel(FSecondaryMarket.MarketID,miIgnore);
  UpdateConstrDepot;
end;

procedure TEDCDForm.OnEDDataUpdate;
var idx: Integer;
begin
  if DataSrc.LastConstructionDone <> '' then
  begin
    idx := FSelectedConstructions.IndexOf(DataSrc.LastConstructionDone);
    if idx <> -1 then
      FSelectedConstructions.Delete(idx);
  end;

  if FCrossHair <> nil then
    with TLabel(FCrossHair.Components[0]) do
      Caption := IfThen(DataSrc.Docked,'',Hint);

  if FCurrentDepot <> nil then
    if FCurrentDepot.ReplacedWith <> '' then
     FSelectedConstructions.Text := FCurrentDepot.ReplacedWith;

  UpdateConstrDepot;

  //main overlay update is priority, so immediately process all repaints and resizing
  //risking recursion if something else than timers kick in, but...
  if MarketsForm.Visible or ColoniesForm.Visible then
  begin
    gTimersSuspended := True;
    try
      Application.ProcessMessages;
    finally
      gTimersSuspended := False;
    end;
  end;
end;

procedure TEDCDForm.OnChangeSettings;
begin
  ApplySettings;
  ArrangeLayers;
  UpdateConstrDepot;
end;

//core procedure

procedure TEDCDForm.UpdateConstrDepot;
var j: TJSONObject;
    jarr,resReq: TJSONArray;
    sl: TStringList;
    csl: TStock;
    js,s,s2,fn,cnames,cprogress,lastUpdate,itemName,normItem,prevSys,warning: string;
    i,ci,res,lastWIP,h,w,q,prec,sortPrefixLen: Integer;
    fa: DWord;
    reqQty,delQty,cargo,stock,prevQty,maxQty: Integer;
    totReqQty,totDelQty,validCargo: Integer;
    srec: TSearchRec;
    useExtCargo: Integer;
    a,l: array [colReq..colStatus] of string;
    cd: TConstructionDepot;
    col: TCDCol;
    m,bestMarket: TMarket;
    avgt: Extended;
label
    LSkipDepotSelection;

  procedure addline;
  var col: TCDCol;
  begin
    for col := colReq to colStatus do
    begin
      a[col] := a[col] + l[col] + Chr(13);
      l[col] := '';
    end;
  end;

  procedure addDistInfo(m: TBaseMarket);
  var d: Extended;
  begin
    if not Opts.Flags['ShowDistance'] then Exit;
    d := FCurrentDepot.DistanceTo(m);
    if (d > 0) and (DataSrc.MaxJumpRange > 0) then
    begin
      l[colStock] := IntToStr(Ceil(d/DataSrc.MaxJumpRange)) + '/' + IntToStr(Ceil(d/DataSrc.JumpRange));
      l[colStatus] := FloatToStrF(d,ffFixed,7,2);
    end;
  end;

begin

  sl := TStringList.Create;
  csl := TStock.Create;

  prevSys := '';
  if FCurrentDepot <> nil then
    prevSys := FCurrentDepot.StarSystem;
  FCurrentDepot := nil;

  if FSecondaryMarket = nil then
    if Opts['SelectedMarket'] <> 'auto' then
      FSecondaryMarket := DataSrc.MarketFromID(Opts['SelectedMarket']);


//  DataSrc.Update;

  try

    for col := colReq to colStatus do begin a[col] := ''; l[col] := ''; end;
    FItemsShown := 0;
    totReqQty := 0;
    totDelQty := 0;
    lastWIP := -1;
    lastUpdate := '';
    useExtCargo := -1;
    cnames := '';
    cprogress := '';

    if FUseEmptyDepot then
    begin
      cnames := 'Cargo';
      cargo := 0;
      for i := 0 to DataSrc.Cargo.Count -1 do
      begin
        l[colText] := DataSrc.ItemNames.Values[DataSrc.Cargo.Names[i]];
        s := DataSrc.Cargo.ValueFromIndex[i];
        l[colStock] := s;
        addline;
        cargo := cargo + StrToIntDef(s,0);
        FItemsShown := FItemsShown + 1;
      end;
      if cargo < DataSrc.Capacity then
      begin
        l[colText] := '(Unused)';
        l[colStock] := '(' + IntToStr(DataSrc.Capacity-cargo) + ')';
        addline;
      end;
      goto LSkipDepotSelection;
    end;

    if FSelectedConstructions.Count = 0 then
      for ci := 0 to DataSrc.Constructions.Count - 1 do
      begin
        cd := TConstructionDepot(DataSrc.Constructions.Objects[ci]);
        if not cd.Finished and not cd.Simulated and (cd.Status <> '') then
          if cd.LastUpdate > lastUpdate then
            if DataSrc.GetMarketLevel(cd.MarketID) <> miIgnore then
            begin
              lastWIP := ci;
              lastUpdate := cd.LastUpdate;
            end;
      end;

    for ci := 0 to DataSrc.Constructions.Count - 1 do
    begin
      cd := TConstructionDepot(DataSrc.Constructions.Objects[ci]);
      if (FSelectedConstructions.IndexOf(cd.MarketID) = -1) and (ci <> lastWIP) then continue;
      FCurrentDepot := cd;
//      if cnames <> '' then cnames := cnames + ', ';
      s := cd.StationName_full;
      if Opts.Flags['ShowStarSystem'] then
        if Length(s) > 13 then
          s := Copy(s,1,12) + '…';
      s2 := DataSrc.MarketComments.Values[cd.MarketID];
      if (s2 = '') and (cd.StationName <> '') then
      begin
        if cd.ConstructionType <> '' then
          try  s := s + ' (' + cd.GetConstrType.StationType_abbrev + ')'; except end;
      end
      else
        if s2 <> '' then
          s := s + ' (' + s2 + ')';
      if Opts.Flags['ShowStarSystem'] then
        s := s + ' ✧' + GetStarSystemAbbrev(cd.StarSystem);
      if FSelectedConstructions.Count > 1 then
        s := Copy(s,1,30 div FSelectedConstructions.Count) + '…';
      cnames := cnames + s;

      if FSelectedConstructions.Count > 1 then
        if (cd.Status = '') and (cd.CustomRequest = '') and not cd.Simulated then
          warning := '⚠ EMPTY MAT. LISTS';

      js := cd.Status;

      try
        j := TJSONObject.ParseJSONValue(js) as TJSONObject;

        if (cd.Status = '') and (cd.CustomRequest <> '') then
        begin
          csl.Text := cd.CustomRequest;
          for i := 0 to csl.Count - 1 do
          begin
            s := csl.Names[i];
            prevQty := StrToIntDef(sl.Values[s],0);
            reqQty := csl.Qty[s];
            sl.Values[s] := IntToStr(prevQty + reqQty);
            totReqQty := totReqQty + reqQty;
          end;
        end
        else
        if cd.Simulated then
        begin
{
          resReq := j.GetValue<TJSONArray>('Items');
          for i := 0 to resReq.Count - 1 do
          begin
            reqQty := StrToInt(resReq.Items[i].GetValue<string>('Demand'));
            if reqQty > 0 then
            begin
              totReqQty := totReqQty + reqQty;
              s := resReq.Items[i].GetValue<string>('Name_Localised');
              prevQty := StrToIntDef(sl.Values[s],0);
              sl.Values[s] := IntToStr(prevQty + (reqQty-delQty));
            end;
          end;
 }

          //this includes temporary updates from remote TradeOrders
          for i := 0 to cd.Stock.Count - 1 do
          begin
            s := cd.Stock.Names[i];
            if Copy(s,1,1) = '$' then //purchase order
            begin
              sl.Values[DataSrc.ItemNames.Values[Copy(s,2,200)]] := cd.Stock.Values[s];
              totReqQty := totReqQty + cd.Stock.Qty[s];
            end;
          end;

        end
        else
        begin
          resReq := j.GetValue<TJSONArray>('ResourcesRequired');
          for i := 0 to resReq.Count - 1 do
          begin
            reqQty := StrToInt(resReq.Items[i].GetValue<string>('RequiredAmount'));
            delQty := StrToInt(resReq.Items[i].GetValue<string>('ProvidedAmount'));
            if cd.Finished then delQty := 0;

            totReqQty := totReqQty + reqQty;
            totDelQty := totDelQty + delQty;

            if delQty<reqQty then
            begin
              s := resReq.Items[i].GetValue<string>('Name_Localised');
              prevQty := StrToIntDef(sl.Values[s],0);
              sl.Values[s] := IntToStr(prevQty + (reqQty-delQty));
            end;
          end;
        end;
      except
        __log_except('UpdateConstrDepot','');
      end;
    end;

//invalid cargo (todo: show on option only)
    for i := 0 to DataSrc.Cargo.Count -1 do
    begin
      s := DataSrc.ItemNames.Values[DataSrc.Cargo.Names[i]];
      if (s <> '') and (sl.IndexOfName(s) = -1) then
        sl.AddPair(s,'');
    end;

//fleet carrier used to fullfill request
    if (Opts['UseExtCargo'] = '2') and (DataSrc.CargoExt <> nil) then
    begin
      for i := sl.Count - 1 downto 0  do
      begin
        normItem := LowerCase(sl.Names[i]);
        reqQty := StrToIntDef(sl.ValueFromIndex[i],0);
        reqQty := reqQty - StrToIntDef(DataSrc.CargoExt.Stock.Values[normItem],0);
        if reqQty <= 0 then
          sl.Delete(i)
        else
          sl.Values[sl.Names[i]] := IntToStr(reqQty);
      end;

    end;



    bestMarket := nil;
    if Opts.Flags['ShowBestMarket'] then
      bestMarket := FindBestMarket(sl,nil);

    if FAutoSelectMarket then
      FSecondaryMarket := FindBestMarket(sl,bestMarket);

    if Opts['AutoSort'] = '2' then
    begin
      sortPrefixLen := 20;
      for i := 0 to sl.Count - 1 do
      begin
        s := LowerCase(sl.Names[i]);
        s2 := '9';
        if DataSrc.Market.Stock[s] > 0 then
          s2 := '1' + DataSrc.ItemCategories.Values[s]
        else
          if (bestMarket <> nil) and (bestMarket.Stock[s] > 0) then
            s2 := '2'
          else
            if (FSecondaryMarket <> nil) and (FSecondaryMarket.Stock[s] > 0) then
              s2 := '4';
        if FSelectedItems.IndexOf(s) <> -1 then
          s2 := '0'+ s2;
        s2 := Copy(s2 + '                         ',1,20);
        sl[i] := s2 + sl[i];
      end;
    end
    else
    begin
      sortPrefixLen := 1;
      for i := 0 to sl.Count - 1 do
      begin
        s := LowerCase(sl.Names[i]);
        s2 := '9';
        if (DataSrc.Cargo[s] > 0) or (FSelectedItems.IndexOf(s) <> -1) then
          s2 := '0'
        else
        if DataSrc.Market.Stock[s] > 0 then
          s2 := '1'
        else
          if (bestMarket <> nil) and (bestMarket.Stock[s] > 0) then
            s2 := '2'
          else
            if (FSecondaryMarket <> nil) and (FSecondaryMarket.Stock[s] > 0) then
              s2 := '4';
        sl[i] := s2 + sl[i];
      end;
    end;

    if Opts.Flags['AutoSort'] then
      sl.Sort;


    if totReqQty > 0  then
    begin
      validCargo := 0;
      if DataSrc.CargoExt <> nil then
        useExtCargo := StrToInt(Opts['UseExtCargo']);
      for i := 0 to sl.Count - 1 do
      begin
        itemName := Copy(sl.Names[i],1+sortPrefixLen,200);
        normItem := LowerCase(itemName);

        reqQty := StrToIntDef(sl.ValueFromIndex[i],0);
        cargo := StrToIntDef(DataSrc.Cargo.Values[normItem],0);
        if cargo > 0 then
          if reqQty > 0 then
            validCargo := validCargo + cargo;
        if useExtCargo = 1 then
          cargo := cargo + StrToIntDef(DataSrc.CargoExt.Stock.Values[normItem],0);
        if useExtCargo = 3 then
          cargo := cargo + StrToIntDef(DataSrc.CargoExt.Stock.Values['$' + normItem],0);

{
        if not FCurrentDepot.Finished and (cargo = 0) and (FItemsShown > 3) and (i < sl.Count - 3) then
        begin
          a[colText] := a[colText] + '...' + Chr(13);
          a[colReq] := a[colReq] + Chr(13);
       a[colStock] := a[colStock]  + Chr(13);
       a[colStatus] := a[colStatus]  + Chr(13);
          break;
        end;
}

        FItemsShown := FItemsShown + 1;

        l[colReq] := sl.ValueFromIndex[i];
        if FSelectedItems.IndexOf(normItem) <> -1 then
          l[colReq] := '✓ ' + l[colReq]; //△
        l[colText] := itemName;

        s := '';
        if cargo > 0 then
        begin
          s := IntToStr(cargo);
          if (reqQty > 0) and not Opts.Flags['ShowIndicators'] then
          begin
            if cargo = reqQty then s := '✓ ' + s;
            if cargo > reqQty then s := '+ ' + s;
          end;
        end;
        l[colStock] := s;

        s := '';
        if cargo < reqQty then
          s := GetItemMarketIndicators(normItem,reqQty,cargo,bestMarket);
        if cargo > 0 then
        begin
          if cargo = reqQty then s := '✓';           //■□▼▲◊♦○●✓✋⚠⛔
          if cargo > reqQty then s := '✓+';
          if reqQty = 0 then s := '⛔';
//          if cargo < reqQty then
//            if cargo < DataSrc.Capacity then s := '< ' + s;
        end;
        l[colStatus] := s;

        addline;
      end;

      if (Opts.Flags['ShowUnderCapacity']) and (DataSrc.Capacity > 0) then
        if (validCargo < DataSrc.Capacity) and (totDelQty + validCargo < totReqQty) then
        begin
          s := '';
          if Opts['ShowFlightsLeft'] = '2' then
          begin
            reqQty := totReqQty-totDelQty;
            q := reqQty - (reqQty div DataSrc.Capacity) * DataSrc.Capacity - validCargo;
            if q > 0 then
            begin
              s := '('+ IntToStr(q) + ')';

            end;
          end;
          l[colReq] := s;
          l[colText] := '⚠ UNDER CAPACITY';
          l[colStock] := '(' + IntToStr(DataSrc.Capacity-validCargo) + ')';
          addline;
        end;
      if (FCurrentDepot <> nil) and Opts.Flags['ShowProgress'] then
      begin
        if Opts['ShowProgress'] = '1' then
        begin
          if FCurrentDepot.Simulated then
          begin
            s := 'Update: ' + Copy(FCurrentDepot.LastUpdate,1,16);
          end
          else
          begin
            s := 'Progress: ';
            if FCurrentDepot.Finished then
              s := s + 'DONE'
            else
              s := s + IntToStr((100*totDelQty) div totReqQty) + '%';
          end;
          l[colText] := s;
          addline;
        end;
        if Opts['ShowProgress'] = '2' then
        begin
          if not FCurrentDepot.Simulated then
            if FCurrentDepot.Finished then
              cprogress := '✓ '
            else
              cprogress := '' + IntToStr((100*totDelQty) div totReqQty) + '% ';  //⏩
        end;
      end;
      if Opts.Flags['ShowFlightsLeft'] and (DataSrc.Capacity > 0) then
      begin
        reqQty := totReqQty-totDelQty;
        if Opts['ShowFlightsLeft'] = '2' then
        begin
          q := reqQty div DataSrc.Capacity;
          if reqQty/DataSrc.Capacity <> reqQty div DataSrc.Capacity then q := q + 1;
          s := IntToStr(q);
          cprogress := cprogress + '' + s + '⭮ ' //⏳ ⭮⮀
        end
        else
        begin
          prec := 1;
          s := FloatToStrF(reqQty/DataSrc.Capacity,ffFixed,7,prec);
          if RightStr(s,prec) = LeftStr('00000',prec) then
          begin
            s := Copy(s,1,Length(s)-prec-1);
            if reqQty/DataSrc.Capacity <> reqQty div DataSrc.Capacity then
              s := s + '+';
          end;
          q := reqQty - (reqQty div DataSrc.Capacity) * DataSrc.Capacity;
          s2 := IntToStr(q) + '/' + IntToStr(DataSrc.Capacity);
          l[colText] := 'Flights left: ' + s + ' (' + s2 + 't)';
          addline;
        end;
      end;

      if FFlightHistory then
      begin
        if FCurrentDepot <> nil then
        with FCurrentDepot.DockToDockTimes do
        for ci := AddIdx to AddIdx + High(fdata) do
        begin
          i := ci mod (High(fdata)+1);
          if fdata[i].Time = 0 then continue;
          s := '?';
          m := DataSrc.MarketFromId(fdata[i].Destination);
          if m <> nil then s := m.FullName;
          l[colText] := '⮀ ' + s;
          l[colStock] := FloatToStrF(fdata[i].Time,ffFixed,7,1);
          addline;
        end;
      end;


      if Opts.Flags['ShowDelTime'] then
      begin
        s := '(no dock-to-dock times)';
        avgt := FCurrentDepot.DockToDockTimes.GetAvg;
        if avgt > 0 then
        begin
          reqQty := totReqQty-totDelQty;
          s := 'Time left: ';        //⏱🕒
          if FCurrentDepot.Finished then
          begin
            reqQty := totReqQty;
            s := 'Est. Time: ';
          end;

          s2 := '?';
          if DataSrc.Capacity > 0 then
          begin
            q := reqQty div DataSrc.Capacity;
            if reqQty/DataSrc.Capacity <> reqQty div DataSrc.Capacity then q := q + 1;
            s2 := FloatToStrF(avgt / 60 * q,ffFixed,7,1) + 'h';
          end;
          s := s + s2 + ', avg. ' + FloatToStrF(avgt,ffFixed,7,1) + 'm';
        end;

        l[colText] := s;
        s := '';
        if (FCurrentDepot.DockToDockTimes.Last > 0) and
           (FCurrentDepot.DockToDockTimes.Last < cMaxDockToDockTime) then
          s := '⏳' + FloatToStrF(FCurrentDepot.DockToDockTimes.Last,ffFixed,7,1);
        l[colStock] := s;
        addline;
      end;

      if Opts.Flags['ShowIndicators'] then
      begin
        if Opts.Flags['ShowRecentMarket'] then
          if DataSrc.Market.Stock.Count > 0 then
          begin
            m := nil;
            if DataSrc.Market.StationType = 'FleetCarrier' then
              m := DataSrc.MarketFromId(DataSrc.Market.MarketId);
            if m = nil then m := DataSrc.Market;
            s := m.StationName_abbrev(true);
            l[colText] := '□ ' + s;
            addDistInfo(DataSrc.Market);
            addline;
          end;
        if bestMarket <> nil then
        begin
          l[colText] := '○ ' + bestMarket.StationName_abbrev(true); //FullName;
          addDistInfo(bestMarket);
          addline;
        end;
        if FSecondaryMarket <> nil then
        begin
          s := '';
          if not FAutoSelectMarket then
            s := '🤚';  //👉☝🤚
          l[colReq] := s;
          l[colText] := '△ ' + FSecondaryMarket.StationName_abbrev(true); //FullName;
          addDistInfo(FSecondaryMarket);
          addline;
        end;
      end;
    end;

   if useExtCargo <> -1 then cprogress := cprogress + '🠵 ' ;


LSkipDepotSelection:;

    if DataSrc.CurrentRoute.Active then
    begin
      if DataSrc.CurrentRoute.Count > 0 then
      begin
        l[colReq] := '🏳🏁';
        l[colText] := '⇨ ' + DataSrc.CurrentRoute.Strings[0];
        l[colStock] := '✧' + IntToStr(DataSrc.CurrentRoute.Count);
        addline;
      end;
    end;

    if warning <> '' then
    begin
      l[colText] := warning;
      addline;
    end;

    if a[colText] = '' then
    if FCurrentDepot <> nil then
    begin
      l[colText] := 'Empty material list. '; addline;
      l[colText] := 'Dock to depot, paste list'; addline;
      l[colText] := 'or use avg./max. request.'; addline;
    end;

    ReqQtyColLabel.Caption := a[colReq];
    TextColLabel.Caption := a[colText];
    StockColLabel.Caption := a[colStock];
    FIndicators.Text := a[colStatus];
    StatusPaintBox.Invalidate;

    if cnames = '' then
      TitleLabel.Caption := '(no active constructions)'
    else
      TitleLabel.Caption := cprogress + cnames;


    if Opts.Flags['AutoHeight'] then
    begin
      sl.Text := a[colText];
      h := TextColLabel.Margins.Top +
           FTextHeight * sl.Count +
           TextColLabel.Margins.Bottom;
      h := TextColLabel.Top + h + 2;
      if self.Height <> h then
      begin
        self.Height := h;
      end;
      h := h + 4;
      if (FLayer1 <> nil) and (FLayer1.Height <> h) then
        FLayer1.Height := h;
      ToolbarForm.UpdatePosition;
    end;

    {
    w := StockColLabel.Tag;
    if DataSrc.Capacity >= 1000 then
      w := w * 6 div 5;
    if StockColLabel.Width <> w then StockColLabel.Width := w;
    }

  finally

    j.Free;
    sl.Free;
    csl.Free;
  end;

  if FCurrentDepot <> nil then
    if prevSys <> FCurrentDepot.StarSystem then
      if MarketsForm.Visible and MarketsForm.MarketsCheck.Checked then
        MarketsForm.UpdateItems;  //update distances to markets
end;

procedure TEDCDForm.FormShow(Sender: TObject);
begin
//
end;

procedure TEDCDForm.ReqQtyColLabelDblClick(Sender: TObject);
var sl: TStringList;
    pt: TPoint;
    idx,p: Integer;
    s: string;
begin
   pt := Mouse.CursorPos;
   sl := TStringList.Create;
   sl.Text := TextColLabel.Caption;
   try
     pt := TextColLabel.ScreenToClient(pt);
     idx := pt.Y div FTextHeight;
     if (idx >= 0)  and (idx < sl.Count) then
     begin
       s := LowerCase(sl[idx]);
       if s = '' then Exit;
       if idx >= FItemsShown then
       begin
         if not FAutoSelectMarket then
         begin
           FAutoSelectMarket := True;
           UpdateConstrDepot;
         end;
         Exit;
       end;
       if FSelectedItems.IndexOf(s) = -1 then
         FSelectedItems.Add(s)
       else
         FSelectedItems.Delete(FSelectedItems.IndexOf(s));
       UpdateConstrDepot;
     end;
   finally
     sl.Free;
   end;
end;

function TEDCDForm.IsEliteActiveWnd: Boolean;
var wnd: HWND;
    pid: DWORD;
    hProcess: THandle;
    path: array[0..4095] of Char;
    s: string;
begin
  Result := False;
  wnd := GetForegroundWindow;
  if wnd = self.Handle then Exit;

  GetWindowThreadProcessId(wnd, pid);
  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, FALSE, pid);
  if hProcess <> 0 then
    try
      if GetModuleFileNameEx(hProcess, 0, @path[0], Length(path)) <> 0 then
      begin
        s := PWideChar(@path);
        if Pos('EliteDangerous',s) > 0 then
          Result := True;
      end;
    finally
      CloseHandle(hProcess);
    end
end;
procedure TEDCDForm.ResetAlwaysOnTop;
var wnd: HWND;
    pid: DWORD;
    hProcess: THandle;
    path: array[0..4095] of Char;
    s: string;
begin
  wnd := GetForegroundWindow;
  if wnd = FLastActiveWnd then Exit;
  FLastActiveWnd := wnd;
  if IsEliteActiveWnd then
  begin
    if FCrossHair <> nil then FCrossHair.FormStyle := fsStayOnTop;
    if FLayer1 <> nil then FLayer1.FormStyle := fsStayOnTop;
    self.FormStyle := fsStayOnTop;
    ToggleTitleBar(false);
    FEliteWnd := wnd;
  end
  else
  begin
    ToggleTitleBar(Application.Active);
    if FCrossHair <> nil then FCrossHair.FormStyle := fsNormal;
    if FLayer1 <> nil then FLayer1.FormStyle := fsNormal;
    self.FormStyle := fsNormal;
  end;
end;

procedure TEDCDForm.ResetDockTimeMenuItemClick(Sender: TObject);
var d: Extended;
begin
  if Vcl.Dialogs.MessageDlg('Start a new estimate?' + Chr(13) +
    'Only the most recent time will be retained.' + Chr(13) +
    '(The average will again include up to 6 recent runs after restart.)' ,
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  //DataSrc.ResetDockTimes;
  if FCurrentDepot <> nil then
  begin
    d := FCurrentDepot.DockToDockTimes.Last;
    FCurrentDepot.DockToDockTimes.Clear;
    FCurrentDepot.DockToDockTimes.Add(d,DataSrc.LastMarketId);
  end;
  UpdateConstrDepot;
end;

procedure TEDCDForm.UpdateTransparency;
begin
  if Opts.Flags['ClickThrough'] then
    if Application.Active then
    begin
      SetWindowLong(FLayer1.Handle,GWL_EXSTYLE ,
        GetWindowLong(FLayer1.Handle, GWL_EXSTYLE) and not WS_EX_TRANSPARENT);
      SetWindowLong(self.Handle,GWL_EXSTYLE ,
        GetWindowLong(self.Handle, GWL_EXSTYLE) and not WS_EX_TRANSPARENT);
    end
    else
    begin
      SetWindowLong(FLayer1.Handle,GWL_EXSTYLE ,
        GetWindowLong(FLayer1.Handle, GWL_EXSTYLE) or WS_EX_TRANSPARENT);
      SetWindowLong(self.Handle,GWL_EXSTYLE ,
        GetWindowLong(self.Handle, GWL_EXSTYLE) or WS_EX_TRANSPARENT);
    end;
end;

procedure TEDCDForm.ArrangeLayers;
var t: DWORD;
begin
  if FLayer1 = nil then Exit;
  UpdateTransparency;
//  if FLayer1.FormStyle = fsStayOnTop then Exit;
  t := HWND_TOP;
  if self.FormStyle = fsStayOnTop then
    t := HWND_TOPMOST;
  //SetWindowPos(ToolbarForm.Handle, HWND_TOP, 0, 0 , 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  if FCrossHair <> nil then
    SetWindowPos(FCrossHair.Handle, t, 0, 0 , 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  SetWindowPos(FLayer1.Handle, t, 0, 0 , 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  SetWindowPos(self.Handle, t, 0, 0 , 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);


end;

procedure TEDCDForm.UpdTimerTimer(Sender: TObject);
var orgactivewnd: HWND;
    c,orgc: TColor;
    samples: array [0..3] of TColor;
    clr: System.UITypes.TColorRec;
    p: TPoint;
    sdc: HDC;
    i,rgbsum,avg: Integer;

    s: string;
    carr: array [0..256] of Char;
    sys: TStarSystem;
begin
  if gTimersSuspended then Exit;
  
  try
    if Opts['AlwaysOnTop'] = '2' then
      ResetAlwaysOnTop;

  //experimental - four pixel average, popupmenu issues
{
    if Opts.Flags['AutoFontGlow']  then
    begin
      orgc := self.Color;
      sdc:= GetDC(0); //this is slow!

      p := FLayer1.ClientToScreen(TPoint.Create(-2,0));
      rgbsum := 0;
      for i := 1 to 4 do
      begin
        try c := GetPixel(sdc,p.X,p.Y); except c := 0; end;
        clr.Color := c;
        rgbsum := rgbsum + clr.R + clr.G + clr.B;
        p.Y := p.Y + FLayer1.Height div 4;
      end;
      rgbsum := rgbsum div 4;
      avg := 48 + ((rgbsum div 3) div 32) * 16; //8 glow levels only
      clr.R := avg;
      clr.G := avg;
      clr.B := avg;
      c := clr.Color;
      ReleaseDC(0,sdc);
      if c <> orgc then
      begin
        self.Color := c;
        self.TransparentColorValue := c;
        //changing transp.color rearranges layers!
        ArrangeLayers;
      end;
    end;
}
    FShadowTimer := FShadowTimer - UpdTimer.Interval;
    if FShadowTimer <= 0 then
    if Opts.Flags['AutoAlphaBlend'] and (FLayer1 <> nil)  then
    begin
      orgc := FLayer1.AlphaBlendValue;
      sdc:= GetDC(0);
      try
        p := FLayer1.ClientToScreen(TPoint.Create(-2,0));
        if p.X <= 0 then
          p := FLayer1.ClientToScreen(TPoint.Create(FLayer1.Width + 2,0));

        rgbsum := 0;
        //todo: switch to bitblt to scan full line
        for i := 1 to 6 do
        begin
          try c := GetPixel(sdc,p.X,p.Y); except c := 0; end;
          clr.Color := c;
          rgbsum := rgbsum + clr.R + clr.G + clr.B;
          p.Y := p.Y + FLayer1.Height div 6;
        end;
        c := (rgbsum div 3) div 6;
        if (FLastBkgColor = 0) or (Abs(c-FLastBkgColor) > 10) then
        begin
          // 4 alpha levels only
          avg := 32 + (c div 64) * 48;
          if avg <> orgc then
          begin
            FLastBkgColor := c;
            FLayer1.AlphaBlendValue := avg;
            FShadowTimer := 1000; //1s hysteresis
          end;
        end;
      finally
        ReleaseDC(0,sdc);
      end;
    end;


    if self <> EDCDForm then Exit;

    MarketInfoForm.SyncComparison;

    if Opts.Flags['ScanMenuKey'] then
      if GetKeyState(VK_APPS) < 0 then
      begin
        orgactivewnd := GetForegroundWindow;
        if orgactivewnd = FEliteWnd then
        begin
          Application.BringToFront;
          EDCDForm.BringToFront;
        end;
        if GetKeyState(VK_CONTROL) < 0 then
          SystemInfoMenuItemClick(nil);
      end;

    if Opts.Flags['ScanClipboard'] then
      if not DataSrc.CurrentRoute.Active then
      if Clipboard.HasFormat(CF_TEXT) then
      if Clipboard.GetTextBuf(carr,High(carr)-1) > 0 then
      begin
        s := PChar(@carr);
        if  s <> FLastClipbrdStr then
        begin
          FLastClipbrdStr := s;
          if IsEliteActiveWnd then
          begin
            if Length(s) < 60  then
            begin
              sys := DataSrc.StarSystems.SystemByName[s];
              s := '(not visited)';
              if sys <> nil then
              begin
                 s := '(visited, no comments)';
                 if sys.Comment <> '' then
                  s := sys.Comment;
              end;
              SplashForm.ShowInfo(s,4000);
            end;
          end;
        end;
      end;

  except
    //suppress all errors on timers!
  end;

end;


procedure TEDCDForm.SwitchDepotMenuItemClick(Sender: TObject);
var cd: TConstructionDepot;
    i: Integer;
begin
  if TMenuItem(Sender).Tag >= DataSrc.Constructions.Count then Exit;
  FSelectedItems.Clear;
  if TMenuItem(Sender).Tag = -2 then //empty
  begin
    FSelectedConstructions.Clear;
    FCurrentDepot := nil;
    FUseEmptyDepot := not FUseEmptyDepot;
  end
  else
  begin
    FUseEmptyDepot := false;
    if TMenuItem(Sender).Tag = -1 then //recent active
    begin
      FSelectedConstructions.Clear;
    end
    else
    begin
      cd := TConstructionDepot(DataSrc.Constructions.Objects[TMenuItem(Sender).Tag]);
      if not TMenuItem(Sender).Checked then
      begin
        i := FSelectedConstructions.IndexOf(cd.MarketId);
        if i >= 0 then FSelectedConstructions.Delete(i);
      end
      else
      begin
        if GetKeyState(VK_CONTROL) < 0 then
        begin
          if FCurrentDepot <> nil then
            if FSelectedConstructions.Count = 0 then
              FSelectedConstructions.Add(FCurrentDepot.MarketId);
          FSelectedConstructions.Add(cd.MarketId);
          if (cd.Status = '') and (cd.CustomRequest = '') then
            ShowMessage('WARNING: Construction with no material list added to group.');
        end
        else
          FSelectedConstructions.Text := cd.MarketId;
      end;
    end;
  end;
  UpdateConstrDepot;
end;

procedure TEDCDForm.SetDepot(mID: string; groupf: Boolean);
var i: Integer;
begin
  if groupf then
  begin
    i := FSelectedConstructions.IndexOf(mID);
    if i >= 0 then
      FSelectedConstructions.Delete(i)
    else
    begin
      if FCurrentDepot <> nil then
        if FSelectedConstructions.Count = 0 then
            FSelectedConstructions.Add(FCurrentDepot.MarketId);
      FSelectedConstructions.Add(mID);
    end;
  end
  else
    FSelectedConstructions.Text := mID;
  FSelectedItems.Clear;
  UpdateConstrDepot;
end;

procedure TEDCDForm.AddDepotToGroup(cd: TConstructionDepot);
var i: Integer;
begin
  SetDepot(cd.MarketId,true);
  if (cd.Status = '') and (cd.CustomRequest = '') then
    ShowMessage('WARNING: Construction with no material list added to group.');
end;

procedure TEDCDForm.SetDepotGroup(mIDs: string);
var i: Integer;
begin
  FSelectedConstructions.Text := mIDs;
  UpdateConstrDepot;
end;

procedure TEDCDForm.SetSecondaryMarket(mID: string);
begin
  FSecondaryMarket := DataSrc.MarketFromID(mID);
  if FSecondaryMarket <> nil then
    FAutoSelectMarket := False;
  UpdateConstrDepot;
end;

procedure TEDCDForm.SettingsMenuItemClick(Sender: TObject);
begin
  SettingsForm.Show;
end;

procedure TEDCDForm.SwitchMarketMenuItemClick(Sender: TObject);
var m: TMarket;
    i,idx: Integer;
begin
  FAutoSelectMarket := false;
  idx := TMenuItem(Sender).Tag;
  if idx >= DataSrc.RecentMarkets.Count then Exit;
  if not TMenuItem(Sender).Checked or (idx = -1) then
  begin
    FSecondaryMarket := nil;
    Opts['SelectedMarket'] := '';
  end
  else
    FSecondaryMarket := TMarket(DataSrc.RecentMarkets.Objects[idx]);
  UpdateConstrDepot;
end;

function GetColorFromCode(cs: string; def: TColor): TColor;
var s: string;
begin
  Result := def;
  s := Copy(cs,5,2) + Copy(cs,3,2) + Copy(cs,1,2);
  try Result := TColor(StrToInt('$' + s)); except end;
end;

procedure TEDCDForm.Layer1Click(Sender: TObject);
begin
  self.BringToFront;
end;

procedure TEDCDForm.Layer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
begin
  self.BringToFront;
end;

procedure TEDCDForm.Layer1DblClick(Sender: TObject);
var pt: TPoint;
    r: TRect;
begin
   pt := Mouse.CursorPos;
   r := ReqQtyColLabel.ClientToScreen(ReqQtyColLabel.ClientRect);
   if PtInRect(r,pt) then
     ReqQtyColLabelDblClick(nil)
   else
     TextColLabelDblClick(nil);
   self.BringToFront;
end;

procedure TEDCDForm.SetupLayers;
var lbl: TLabel;
    w,h: Integer;
    s: string;
begin

  FLayer1 := TForm.Create(nil);
  FLayer1.AlphaBlend := True;
//  FLayer1.AlphaBlendValue := StrToIntDef(Opts['AlphaBlend'],64);
  FLayer1.BorderStyle := bsNone;
  FLayer1.Color := clBlack;
  FLayer1.FormStyle := fsStayOnTop;
  FLayer1.PopupMenu := self.PopupMenu;
  //can't use Enabled=false here, which solved most of problems - I need the dblclicks
  FLayer1.OnClick := Layer1Click;
  //FLayer1.OnMouseActivate := ;
  FLayer1.OnMouseDown := Layer1MouseDown;
  FLayer1.OnDblClick := Layer1DblClick;
  FLayer1.Visible := False;

  FCrossHair := nil;
  if self = EDCDForm then
  try
    FCrossHair := TForm.Create(nil);
    FCrossHair.Visible := False;
    FCrossHair.BorderStyle := bsNone;
    FCrossHair.FormStyle := fsStayOnTop;
//    FCrossHair.AlphaBlend := True;
//    FCrossHair.AlphaBlendValue := 240;
    FCrossHair.TransparentColor := True;
    FCrossHair.TransparentColorValue := $404040;
    FCrossHair.Color := $404040;
    lbl := TLabel.Create(FCrossHair);
    lbl.Parent := FCrossHair;
    lbl.ParentFont := True;
    lbl.Left := 0;
    lbl.Top := 0;
    lbl.Visible := True;
    SetWindowLong(FCrossHair.Handle,GWL_EXSTYLE ,
      GetWindowLong(FCrossHair.Handle, GWL_EXSTYLE) or WS_EX_TRANSPARENT);
  except
  end;

  //  FLayer1.SetBounds(0,0,self.ClientWidth,self.ClientHeight);
//  FLayer1.Show;

{
  with self, ClientOrigin do
    SetWindowPos(FLayer1.Handle, HWND_BOTTOM, Left - 2, Top - 2, ClientWidth + 4, 0,
      SWP_SHOWWINDOW);
}
end;

procedure TEDCDForm.ApplySettings;
var i,fs,dh,basew,w,h: Integer;
    s: string;
    fn: TFontName;
    c: TColor;
    clr: System.UITypes.TColorRec;
begin
  c := GetColorFromCode(Opts['Color'],TextColLabel.Font.Color);
  TitleLabel.Font.Color := c;
  TextColLabel.Font.Color := c;
  DividerTop.Pen.Color := c;
  DividerBottom.Pen.Color := c;
  try
    fn := Opts['FontName'];
    if fn = '' then fn := TitleLabel.Font.Name;
    fs := StrToIntDef(Opts['FontSize'],TitleLabel.Font.Size);
    //ParentFont is of no use as it applies all font atrributes
    self.Font.Size := fs;
    self.Font.Name := fn;
    for i := 0 to self.ControlCount - 1 do
    begin
      if self.Controls[i] is TLabel then
        with TLabel(self.Controls[i]) do
        begin
          Font.Size := fs;
          Font.Name := fn;
        end;
    end;
    StatusPaintBox.Font.Size := fs;
    StatusPaintBox.Font.Name := fn;
  except
  end;

  DividerTop.Visible := Opts.Flags['ShowDividers'];
  DividerBottom.Visible := Opts.Flags['ShowDividers'];

  CloseLabel.Visible := Opts.Flags['ShowCloseBox'];

  if Opts['FontGlow'] <> '' then
  begin
    clr.R := StrToIntDef(Opts['FontGlow'],0);
    clr.G := clr.R;
    clr.B := clr.R;
    FTransColor := clr.Color;
    self.Color := FTransColor;
    self.TransparentColorValue := FTransColor;
  end;

  if Opts.Flags['AutoWidth'] then
  begin
    basew := self.Canvas.TextWidth(Opts['BaseWidthText']);

    ReqQtyColLabel.Width := basew;
    StatusPaintBox.Visible := Opts.Flags['ShowIndicators'];
    if not Opts.Flags['ShowIndicators'] then
    begin
      self.Width := basew * 7;
    end
    else
    begin
      StatusPaintBox.Width := basew + 2; //tiny margins
      self.Width := basew * 8;
    end;
    StockColLabel.Width := basew;
    StockColLabel.Tag := basew;
    CloseLabel.Left := self.Width - CloseLabel.Width - 3;

    FTextHeight := self.Canvas.TextHeight('Wq');

    dh := FTextHeight - TitleLabel.Height;
    TitleLabel.Height := TitleLabel.Height + dh;
    CloseLabel.Height := CloseLabel.Height + dh;
  end;

  if FLayer1 <> nil then
  begin
    FLayer1.AlphaBlendValue := StrToIntDef(Opts['AlphaBlend'],64);
    SetWindowPos(FLayer1.Handle, HWND_BOTTOM, self.Left - 2, self.Top - 2 , self.ClientWidth + 4, 0,
      SWP_NOACTIVATE);
    FLayer1.Visible := Opts['Backdrop'] = '2';
  end;

  if FCrossHair <> nil then
  if Opts.Flags['CrossHair'] then
  begin
    try
      FCrossHair.Font.Size :=  Opts.Int['CrossHairSize'];
      FCrossHair.Font.Color :=  GetColorFromCode(Opts['CrossHairColor'],clSilver);
      s := Copy('⛶+△◌○●',Opts.Int['CrossHairSymbol'],1);
      if Opts['CrossHairText'] <> '' then s := Opts['CrossHairText'];
      w := FCrossHair.Canvas.TextWidth(s);
      h := FCrossHair.Canvas.TextHeight(s);
      FCrossHair.Left := (Screen.Width - w) div 2;
      FCrossHair.Top := (Screen.Height - h) div 2;
      FCrossHair.Width := w + 1;
      FCrossHair.Height := h + 1;
      FCrossHair.Visible := True;
      with TLabel(FCrossHair.Components[0]) do
      begin
        Width := w;
        Height := h;
        Hint := s;
        Caption := s; //IfThen(DataSrc.Docked,'',Hint);
      end;
    except
      __log_except('CrossHair','');
    end;
  end
  else
    FCrossHair.Visible := False;

  //this is not optimized right now
  if not Opts.Flags['AllowMoreWindows'] then
    NewWindowMenuItem.Visible := False;

  FBackdrop :=  Opts['Backdrop'] = '1';
  UpdateBackdrop;

  FAutoSelectMarket := Opts['SelectedMarket'] = 'auto';
end;

procedure TEDCDForm.AutoSelectMarketMenuItemClick(Sender: TObject);
begin
   FAutoSelectMarket := TMenuItem(Sender).Checked;
   UpdateConstrDepot;
end;

procedure TEDCDForm.ComparePurchaseOrderMenuItemClick(Sender: TObject);
begin
  if ComparePurchaseOrderMenuItem.Checked then
    Opts['UseExtCargo'] := '0'
  else
    Opts['UseExtCargo'] := '3';
  UpdateConstrDepot;
end;

procedure TEDCDForm.ManageAllMenuItemClick(Sender: TObject);
begin
  ColoniesForm.UpdateAndShow;
  MarketsForm.UpdateAndShow;
end;

procedure TEDCDForm.ManageColoniesMenuItemClick(Sender: TObject);
begin
  with ColoniesForm do
  begin
  {
    BeginFilterChange;
    try
      ColoniesCheck.Checked := true;
      ColonTargetsCheck.Checked := false;
      ColonCandidatesCheck.Checked := false;
      OtherSystemsCheck.Checked := false;
      InclIgnoredCheck.Checked := false;
    finally
      EndFilterChange;
    end;
 }
    UpdateAndShow;
  end;
end;

procedure TEDCDForm.ManageMarketsMenuItemClick(Sender: TObject);
begin
  MarketsForm.BeginFilterChange;
  try
    MarketsForm.FilterEdit.Text := '';
    MarketsForm.InclIgnoredCheck.Checked := False;
    MarketsForm.MarketsCheck.Checked := True;
    MarketsForm.ConstrCheck.Checked := False;
    MarketsForm.SetRecentSort;
  finally
    MarketsForm.EndFilterChange;
    MarketsForm.UpdateAndShow;
  end;
end;

procedure TEDCDForm.MarketAsDepotDlg(m: TMarket);
begin
  if m = nil then Exit;
  if m.MarketId = '' then Exit;
  if m.Snapshot then Exit;
  if m.StationType <> 'FleetCarrier' then
    if Opts['AnyMarketAsDepot'] <> '1' then
    begin
      ShowMessage('Market is not a Fleet Carrier.' + Chr(13) + 'Visit a valid Commodity market and try again.');
      Exit;
    end;


  if Vcl.Dialogs.MessageDlg('Set ' +
    m.StationName_full + ' as simulated Construction Depot?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  DataSrc.MarketToSimDepot(m.MarketId);
  Opts['SimDepot'] := m.MarketId;
  self.SetDepot(m.MarketId,false);
  UpdateConstrDepot;
end;

procedure TEDCDForm.MarketAsDepotMenuItemClick(Sender: TObject);
begin
  if DataSrc.CargoExt = nil then Exit;
  MarketAsDepotDlg(DataSrc.CargoExt);
end;

procedure TEDCDForm.MinimizeMenuItemClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TEDCDForm.NewTaskGroupMenuItemClick(Sender: TObject);
var s,orgs: string;
begin
  s := '';
  if DataSrc.MarketGroups.Count = 0 then
    s := '(just visiting)';
  if Vcl.Dialogs.InputQuery('New Task Group','Name',s) then
    if s <> '' then
      DataSrc.TaskGroup := s;
end;

procedure TEDCDForm.NewWindowMenuItemClick(Sender: TObject);
begin
  with TEDCDForm.Create(Application) do
  begin
    Top := self.Top + self.Height + ToolbarForm.Height;
    Show;
    UpdateLayersPos;
    UpdateConstrDepot;
  end;
  AppActivate(nil);
end;

procedure TEDCDForm.AddRecentMarketMenuItemClick(Sender: TObject);
begin
  if DataSrc.Market.MarketID = '' then Exit;

  if DataSrc.RecentMarkets.IndexOf(DataSrc.Market.MarketID) >= 0 then
  begin
    ShowMessage(DataSrc.Market.StationName_full + Chr(13) + 'Market is already available for selection.');
    Exit;
  end;

  if Vcl.Dialogs.MessageDlg('Add ' +
    DataSrc.Market.StationName_full + ' to market list?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  DataSrc.UpdateSecondaryMarket(true);
//  UpdateConstrDepot;
end;

procedure TEDCDForm.ForgetMarketMenuItemClick(Sender: TObject);
begin
  if FSecondaryMarket = nil then Exit;

  if Vcl.Dialogs.MessageDlg('Remove ' +
    FSecondaryMarket.StationName_full + ' from market list?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  DataSrc.RemoveSecondaryMarket(FSecondaryMarket);
  FSecondaryMarket := nil;
  UpdateConstrDepot;
end;

procedure TEDCDForm.IncludeExtCargoinRequestMenuItemClick(Sender: TObject);
begin
  if IncludeExtCargoinRequestMenuItem.Checked then
    Opts['UseExtCargo'] := '0'
  else
    Opts['UseExtCargo'] := '2';
  UpdateConstrDepot;
end;

procedure TEDCDForm.StarMapMenuItemClick(Sender: TObject);
begin
  StarMapForm.Show;
end;

procedure TEDCDForm.StatusPaintBoxPaint(Sender: TObject);
var r: TRect;
    i,j,y,dx,dy,dx2: Integer;
    s,orgs: string;
    supplyhintf: Boolean;
begin
  supplyhintf := (Opts['ShowIndicators'] = '2') and Opts.Flags['IncludeSupply'];
  r := StatusPaintBox.ClientRect;
  with StatusPaintBox.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clSilver;
    dx := TextWidth('W') + 1;
//    dx2 := (dx - TextWidth('_')) div 2;
    dy := FTextHeight;
    y := 0;
    for i  := 0 to FIndicators.Count - 1 do
    begin
      if i < FItemsShown then
      begin
        for j := 1 to Length(FIndicators[i]) do
        begin
          s := Copy(FIndicators[i],j,1);    //■●▲  □○△
          if supplyhintf then
          begin
            if (s = '△') or (s = '○') or (s = '□') then
              Font.Color := TColor($23238E) //clFireBrick
            else
            if s = '⛔' then
              Font.Color := TColor($23238E)
            else
              Font.Color := clSilver;
              //Canvas.TextRect(r,(j-1)*dx + 2 + dx2,y+1,'_');
            if s = '▲' then s := '△';
            if s = '●' then s := '○';
            if s = '■' then s := '□';
          end;
          TextRect(r,(j-1)*dx + 2,y,s);
        end;
      end
      else
      begin
        s := FIndicators[i];
        if s <> '' then
        begin
          Font.Color := clSilver;
          TextRect(r,r.Width - TextWidth(s),y,s);
        end;
      end;
      y := y + dy;
    end;
  end;
end;

procedure TEDCDForm.SummaryMenuItemClick(Sender: TObject);
begin
  SummaryForm.RestoreAndShow;
end;

procedure TEDCDForm.SwitchFleetCarrierMenuItemClick(Sender: TObject);
var m: TMarket;
    idx: Integer;
begin
  idx := TMenuItem(Sender).Tag - 1;
  if idx >= DataSrc.RecentMarkets.Count then Exit;
  if not TMenuItem(Sender).Checked or (idx = -1) then
    DataSrc.MarketToCargoExt('')
  else
    MarketAsExtCargoDlg(TMarket(DataSrc.RecentMarkets.Objects[idx]),-1);
end;

procedure TEDCDForm.SwitchTaskGroupMenuItemClick(Sender: TObject);
begin
  if DataSrc.TaskGroup = TMenuItem(Sender).Hint then
    DataSrc.TaskGroup := ''
  else
    DataSrc.TaskGroup := TMenuItem(Sender).Hint;
end;

procedure TEDCDForm.SystemInfoCurrentMenuItemClick(Sender: TObject);
begin
  if DataSrc.CurrentSystem <> nil then
  begin
    SystemInfoForm.SetSystem(DataSrc.CurrentSystem);
    SystemInfoForm.RestoreAndShow;
  end;
end;

procedure TEDCDForm.SystemInfoMenuItemClick(Sender: TObject);
begin
  if FCurrentDepot <> nil then
  begin
    SystemInfoForm.SetSystem(FCurrentDepot.GetSys);
    SystemInfoForm.RestoreAndShow;
  end
  else
    SystemInfoCurrentMenuItemClick(Sender);
end;

procedure TEDCDForm.MarketInfoMenuItemClick(Sender: TObject);
begin
  if FSecondaryMarket <> nil then
  begin
    MarketInfoForm.SetMarket(FSecondaryMarket,false);
    MarketInfoForm.Show;
  end;
end;

procedure TEDCDForm.CopyReqQtyMenuItemClick(Sender: TObject);
var sl,sl2: TStringList;
    s: string;
    i: Integer;
begin
  sl := TStringList.Create;
  sl2 := TStringList.Create;
  sl.Text := TextColLabel.Caption;
  sl2.Text := ReqQtyColLabel.Caption;
  s := '';
  try
    while sl.Count > FItemsShown do
      sl.Delete(FItemsShown);
    for i := 0 to FItemsShown - 1 do
      sl[i] := sl[i] + Chr(9) + sl2[i];
    sl.Sort;
    s := sl.Text;
  finally
    sl.Free;
    sl2.Free;
  end;
  if s <> '' then
  begin
    Clipboard.SetTextBuf(PChar(s));
    SplashForm.ShowInfo('Request copied to clipboard...',1000);
  end;
end;

procedure TEDCDForm.PasteReqQtyMenuItemClick(Sender: TObject);
begin
  if FCurrentDepot = nil then Exit;
  if FCurrentDepot.Status <> '' then Exit;
  if not Clipboard.HasFormat(CF_TEXT) then Exit;
  FCurrentDepot.PasteRequest;
  FCurrentDepot.GetSys.Save;
  UpdateConstrDepot;
end;

procedure TEDCDForm.UseMaxReqQtyMenuItemClick(Sender: TObject);
var i,q: Integer;
    maxreq: TStock;
    s: string;
begin
  if FCurrentDepot = nil then Exit;
  if FCurrentDepot.Status <> '' then Exit;
  if FCurrentDepot.GetConstrType = nil then Exit;
  maxreq := TStock.Create;
  maxreq.Assign(FCurrentDepot.GetConstrType.ResourcesRequired);
  if TMenuItem(Sender).Tag = 1 then
    for i := 0 to maxreq.Count - 1 do
    begin
      s := maxreq.Names[i];
      q := maxreq.Qty[s];
      q := q + Ceil(q*0.05); //actually up to 25% more for prim.outpost, 30% for prim.coriolis
      maxreq.Qty[s] := q;
    end;
  FCurrentDepot.CustomRequest := maxreq.Text;
  FCurrentDepot.GetSys.Save;
  UpdateConstrDepot;
  maxreq.Free;
end;

procedure TEDCDForm.ClearReqQtyMenuItemClick(Sender: TObject);
begin
  if FCurrentDepot = nil then Exit;
  if FCurrentDepot.Status <> '' then Exit;
  if FCurrentDepot.CustomRequest = '' then Exit;
  FCurrentDepot.CustomRequest := '';
  FCurrentDepot.GetSys.Save;
  UpdateConstrDepot;
end;

procedure TEDCDForm.ActiveConstrMenuItemClick(Sender: TObject);
begin
  MarketsForm.BeginFilterChange;
  try
    MarketsForm.FilterEdit.Text := '';
    MarketsForm.InclIgnoredCheck.Checked := False;
    MarketsForm.MarketsCheck.Checked := False;
    MarketsForm.ConstrCheck.Checked := True;
    MarketsForm.InclPlannedCheck.Checked := True;
    MarketsForm.SetRecentSort;
    if TComponent(Sender).Tag = 0 then
      MarketsForm.FilterEdit.Text := '(Active)';
    if TComponent(Sender).Tag = 1 then
    begin
      MarketsForm.InclPlannedCheck.Checked := True;
      MarketsForm.FilterEdit.Text := '(Planned)'
    end
  finally
    MarketsForm.EndFilterChange;
    MarketsForm.UpdateAndShow;
  end;
end;

procedure TEDCDForm.ConstructionTypesMenuItemClick(Sender: TObject);
begin
  ConstrTypesForm.Show;
end;

procedure TEDCDForm.PopupMenuPopup(Sender: TObject);
var
  i,j,idx: Integer;
  mitem: TMenuItem;
  cd: TConstructionDepot;
  ct: TConstructionType;
  m: TMarket;
  selectedf,activef,custreqf: Boolean;
  s: string;
  sl: TStringList;
begin

  ToggleExtCargoMenuItem.Checked := Opts['UseExtCargo'] = '1';
  IncludeExtCargoinRequestMenuItem.Checked := Opts['UseExtCargo'] = '2';
  ComparePurchaseOrderMenuItem.Checked := Opts['UseExtCargo'] = '3';
  CurrentTGMenuItem.Caption := 'Task Group: ' + DataSrc.TaskGroup;
  CurrentTGMenuItem.Visible := DataSrc.TaskGroup <> '';
  DeliveriesSubMenu.Visible := Opts.Flags['ShowDelTime'];
  FlightHistoryMenuItem.Checked := FFlightHistory;
  SystemInfoMenuItem.Visible := (FCurrentDepot <> nil);
  SystemInfoCurrentMenuItem.Visible := (FCurrentDepot = nil) or
    ((DataSrc.CurrentSystem <> nil) and (DataSrc.CurrentSystem <> FCurrentDepot.GetSys));

  SelectDepotSubMenu.Clear;
  activef := False;

  sl := TStringList.Create;
  try

  sl.Clear;
  for i := 0 to DataSrc.Constructions.Count - 1 do
  begin
    cd := TConstructionDepot(DataSrc.Constructions.Objects[i]);
    //if cd.Status = '' then continue; //docked but no depot info?
    if cd.Planned then continue; //docked but no depot info?
    if cd.Finished and not Opts.Flags['IncludeFinished'] then
      if FSelectedConstructions.IndexOf(cd.MarketID) = -1 then continue;
    if DataSrc.GetMarketLevel(cd.MarketID) = miIgnore then continue;
    s := IntToStr(2*Ord(not cd.Finished));
    if cd.Simulated then s := '1';
    sl.AddObject(s + cd.LastUpdate,cd);
  end;
  sl.Sort;
  for i := sl.Count - 1 downto sl.Count - 20 do
  begin
    if i < 0 then break;
    cd := TConstructionDepot(sl.Objects[i]);
    mitem := TMenuItem.Create(SelectDepotSubMenu);
    mitem.Caption := cd.FullName;
    s := DataSrc.MarketComments.Values[cd.MarketID];
    if s <> '' then
      mitem.Caption := mitem.Caption + ' (' + Copy(s,1,20) + ')'
    else
      if cd.ConstructionType <> '' then
        try
          if cd.StationName <> '' then
            mitem.Caption := mitem.Caption + ' (' + cd.GetConstrType.StationType_abbrev + ')';
        except
        end;
    mitem.Tag := DataSrc.Constructions.IndexOfObject(cd);
    mitem.OnClick := SwitchDepotMenuItemClick;
    mitem.AutoCheck := true;
    selectedf := (FSelectedConstructions.IndexOf(cd.MarketId) <> -1) or (cd = FCurrentDepot);
    mitem.Checked := selectedf;
//    activef := activef or selectedf;

    if cd.Finished then  mitem.Caption := '[DONE] ' + mitem.Caption;

    SelectDepotSubMenu.Add(mitem);
  end;

  mitem := TMenuItem.Create(SelectDepotSubMenu);
  mitem.Caption := '( No depot, show ship cargo only )';
  mitem.Tag := -2;
  mitem.Checked := FUseEmptyDepot;
  mitem.OnClick := SwitchDepotMenuItemClick;
  SelectDepotSubMenu.Insert(0,mitem);

  mitem := TMenuItem.Create(SelectDepotSubMenu);
  mitem.Caption := '( Recent construction in progress )';
  mitem.Checked := (FSelectedConstructions.Count = 0) and not FUseEmptyDepot; //not activef;
//  mitem.Enabled := activef;
  mitem.Tag := -1;
  mitem.OnClick := SwitchDepotMenuItemClick;
  SelectDepotSubMenu.Insert(0,mitem);



  mitem := TMenuItem.Create(SelectDepotSubMenu);
  mitem.Caption := '( Press and hold CTRL key to group depots )';
  mitem.Enabled := False;
  SelectDepotSubMenu.Add(mitem);

  mitem := TMenuItem.Create(SelectDepotSubMenu);
  mitem.Caption := '-';
  SelectDepotSubMenu.Add(mitem);

  mitem := TMenuItem.Create(SelectDepotSubMenu);
  mitem.Caption := 'Copy Request';
  mitem.OnClick := CopyReqQtyMenuItemClick;
  SelectDepotSubMenu.Add(mitem);

  custreqf := (FCurrentDepot <> nil) and (FCurrentDepot.Status = '');
  if custreqf then
  begin
    mitem := TMenuItem.Create(SelectDepotSubMenu);
    mitem.Caption := 'Paste Request';
    mitem.OnClick := PasteReqQtyMenuItemClick;
    //mitem.Enabled := custreqf;
    SelectDepotSubMenu.Add(mitem);

    mitem := TMenuItem.Create(SelectDepotSubMenu);
    mitem.Caption := 'Use Avg. Request';
    mitem.OnClick := UseMaxReqQtyMenuItemClick;
    //mitem.Enabled := custreqf;
    SelectDepotSubMenu.Add(mitem);

    mitem := TMenuItem.Create(SelectDepotSubMenu);
    mitem.Caption := 'Use Max. Request';
    mitem.OnClick := UseMaxReqQtyMenuItemClick;
    mitem.Tag := 1;
    //mitem.Enabled := custreqf;
    SelectDepotSubMenu.Add(mitem);

    mitem := TMenuItem.Create(SelectDepotSubMenu);
    mitem.Caption := 'Clear Request';
    mitem.OnClick := ClearReqQtyMenuItemClick;
    //mitem.Enabled := custreqf;
    SelectDepotSubMenu.Add(mitem);
  end;

  mitem := TMenuItem.Create(SelectDepotSubMenu);
  mitem.Caption := '-';
  SelectDepotSubMenu.Add(mitem);

  mitem := TMenuItem.Create(SelectDepotSubMenu);
  mitem.Caption := 'Active Constructions';
  mitem.OnClick := ActiveConstrMenuItemClick;
  SelectDepotSubMenu.Add(mitem);

  mitem := TMenuItem.Create(SelectDepotSubMenu);
  mitem.Caption := 'Planned Constructions';
  mitem.OnClick := ActiveConstrMenuItemClick;
  mitem.Tag := 1;
  SelectDepotSubMenu.Add(mitem);

  mitem := TMenuItem.Create(SelectDepotSubMenu);
  mitem.Caption := 'Construction Types';
  mitem.OnClick := ConstructionTypesMenuItemClick;
  mitem.Tag := 1;
  SelectDepotSubMenu.Add(mitem);


  SelectMarketSubMenu.Clear;
  mitem := TMenuItem.Create(SelectMarketSubMenu);
  mitem.Caption := '( Auto select market )';
  mitem.AutoCheck := True;
  mitem.Checked := FAutoSelectMarket;
  mitem.OnClick := AutoSelectMarketMenuItemClick;
  SelectMarketSubMenu.Add(mitem);
  activef := False;
  sl.Clear;
  for i := 0 to DataSrc.RecentMarkets.Count - 1 do
  begin
    m := TMarket(DataSrc.RecentMarkets.Objects[i]);
    if (m.Status = '') and (m.Stock.Count = 0)then continue; //docked but no depot info?
    if DataSrc.GetMarketLevel(m.MarketID) = miIgnore then continue;
    if DataSrc.TaskGroup <> '' then
    begin
      s := DataSrc.MarketGroups.Values[m.MarketID];
      if (s <> '') and (DataSrc.TaskGroup <> s) then continue;
    end;
    sl.AddObject(m.LastUpdate,m);
  end;
  sl.Sort;
  for i := sl.Count - 1 downto sl.Count - 20 do
  begin
    if i < 0 then break;
    m := TMarket(sl.Objects[i]);
    mitem := TMenuItem.Create(SelectMarketSubMenu);
    mitem.Caption := m.FullName;
//    if DataSrc.GetMarketLevel(m.MarketID) = miIgnore then
//       mitem.Caption := '[IGNORED] ' + mitem.Caption;
    s := DataSrc.MarketComments.Values[m.MarketID];
    if s <> '' then
      mitem.Caption := mitem.Caption + ' (' + Copy(s,1,20) + ')';
    mitem.Tag := DataSrc.RecentMarkets.IndexOfObject(m);
    mitem.OnClick := SwitchMarketMenuItemClick;
    mitem.AutoCheck := true;
    mitem.Checked := (FSecondaryMarket <> nil) and (m.MarketId = FSecondaryMarket.MarketID);
    SelectMarketSubMenu.Add(mitem);
  end;

  mitem := TMenuItem.Create(SelectMarketSubMenu);
  mitem.Caption := '-';
  SelectMarketSubMenu.Add(mitem);

  mitem := TMenuItem.Create(SelectMarketSubMenu);
  mitem.Caption := 'Clear Selection';
  mitem.Tag := -1;
  mitem.OnClick := SwitchMarketMenuItemClick;
  SelectMarketSubMenu.Add(mitem);

  if not Opts.Flags['TrackMarkets'] then
  begin
    mitem := TMenuItem.Create(SelectMarketSubMenu);
    mitem.Caption := 'Add Recent Market';
    mitem.OnClick := AddRecentMarketMenuItemClick;
    SelectMarketSubMenu.Add(mitem);
  end;

  if FSecondaryMarket <> nil then
  begin
    mitem := TMenuItem.Create(SelectMarketSubMenu);
    mitem.Caption := 'Market Info';
    mitem.OnClick := MarketInfoMenuItemClick;
    SelectMarketSubMenu.Add(mitem);

    mitem := TMenuItem.Create(SelectMarketSubMenu);
    mitem.Caption := 'Ignore Selected Market';
    mitem.OnClick := IgnoreMarketMenuItemClick;
    SelectMarketSubMenu.Add(mitem);

    mitem := TMenuItem.Create(SelectMarketSubMenu);
    mitem.Caption := 'Forget Selected Market';
    mitem.OnClick := ForgetMarketMenuItemClick;
    SelectMarketSubMenu.Add(mitem);
  end;

  sl.Clear;
  for i := 0 to DataSrc.RecentMarkets.Count - 1 do
  begin
    m := TMarket(DataSrc.RecentMarkets.Objects[i]);
    if m.StationType <> 'FleetCarrier' then continue;
    if DataSrc.GetMarketLevel(m.MarketID) = miIgnore then continue;
    if DataSrc.TaskGroup <> '' then
    begin
      s := DataSrc.MarketGroups.Values[m.MarketID];
      if (s <> '') and (DataSrc.TaskGroup <> s) then continue;
    end;
    sl.AddObject(m.LastUpdate,m);
  end;
  sl.Sort;
  for i := FleetCarrierSubMenu.Count - 1 downto 0 do
  begin
    if FleetCarrierSubMenu.Items[i].Tag > 0 then
      FleetCarrierSubMenu.Delete(i);
  end;
  MarketAsDepotMenuItem.Enabled := False;
  idx := 0;
  for i := sl.Count - 1 downto sl.Count - 20 do
  begin
    if i < 0 then break;
    m := TMarket(sl.Objects[i]);
    mitem := TMenuItem.Create(FleetCarrierSubMenu);
    mitem.Caption := m.StationName_full;
    s := DataSrc.MarketComments.Values[m.MarketID];
    if s <> '' then
      mitem.Caption := mitem.Caption + ' (' + Copy(s,1,20) + ')';
    mitem.Tag := DataSrc.RecentMarkets.IndexOfObject(m) + 1;
    mitem.OnClick := SwitchFleetCarrierMenuItemClick;
    mitem.AutoCheck := true;
    mitem.Checked := (DataSrc.CargoExt <> nil) and (m.MarketId = DataSrc.CargoExt.MarketID);
    FleetCarrierSubMenu.Insert(idx,mitem);
    MarketAsDepotMenuItem.Enabled := True;
    idx := idx + 1;
  end;

  for i := TaskGroupSubMenu.Count - 1 downto 0 do
  begin
    if TaskGroupSubMenu.Items[i].Tag > 0 then
      TaskGroupSubMenu.Delete(i);
  end;
  if DataSrc.MarketGroups.Count > 0 then
  begin
    DataSrc.GetUniqueGroups(sl);
    for i := sl.Count - 1 downto 0 do
    begin
      mitem := TMenuItem.Create(TaskGroupSubMenu);
      mitem.Caption := sl[i];
      mitem.Hint := sl[i];
      mitem.Tag := 1;
      mitem.OnClick := SwitchTaskGroupMenuItemClick;
      mitem.Checked := (sl[i] = DataSrc.TaskGroup);
      TaskGroupSubMenu.Insert(0,mitem);
    end;
    TaskGroupSeparator.Visible := (sl.Count>0);
  end;

  finally
    sl.Free;
  end;
end;

procedure TEDCDForm.ExitMenuItemClick(Sender: TObject);
begin
  self.Close;
end;



procedure TEDCDForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  UpdTimer.Enabled := False;
  DataSrc.RemoveListener(self);
  if self = EDCDForm then
  begin

    //force position saving; FormClose is not called on termination!
    if MarketsForm.Visible then MarketsForm.Close;
    if ColoniesForm.Visible then ColoniesForm.Close;
    if StarMapForm.Visible then StarMapForm.Close;

    Opts['Left'] := IntToStr(self.Left);
    Opts['Top'] := IntToStr(self.Top);
    if Opts.Flags['KeepSelected'] then
      if FUseEmptyDepot then
        Opts['SelectedDepots'] := 'cargo'
      else
        Opts['SelectedDepots'] := FSelectedConstructions.CommaText;
    if FAutoSelectMarket then
      Opts['SelectedMarket'] := 'auto'
    else
      if FSecondaryMarket = nil then
        Opts['SelectedMarket'] := ''
      else
        Opts['SelectedMarket'] := FSecondaryMarket.MarketID;
    Opts.Save;
  end;
  if FLayer1 <> nil then
  begin
    FLayer1.Free;
    FLayer1 := nil;
  end;
  if FCrossHair <> nil then
  begin
    FCrossHair.Free;
    FCrossHair := nil;
  end;
end;

procedure TEDCDForm.FormCreate(Sender: TObject);
var s: string;
begin
  FIndicators := TStringList.Create;

  DataSrc.AddListener(self);

  FSelectedConstructions := TStringList.Create;
  FSelectedItems := TStringList.Create;
  FSelectedItems.Sorted := True;
  FSelectedItems.Duplicates := dupIgnore;

  if Opts.Flags['KeepSelected'] then
    if Opts['SelectedDepots'] = 'cargo' then
      FUseEmptyDepot := True
    else
      FSelectedConstructions.CommaText := Opts['SelectedDepots'];

  FTransColor := self.Color;

   if not Opts.Flags['AlwaysOnTop'] then
    self.FormStyle := fsNormal
  else
    self.FormStyle := fsStayOnTop;

  SetupLayers;

  ApplySettings;

  self.Left := StrToIntDef(Opts['Left'],Screen.Width - self.Width);
  self.Top := StrToIntDef(Opts['Top'],(Screen.Height - self.Height) div 2);
  UpdateLayersPos;

end;

procedure TEDCDForm.UpdateLayersPos;
begin
  if FLayer1 <> nil then
  begin
    FLayer1.Left := self.Left - 2;
    FLayer1.Top := self.Top - 2;
  end;
end;


procedure TEDCDForm.AppActivate(Sender: TObject);
var i: Integer;
    fs: TFormStyle;
begin
  if Application.Terminated then Exit;
  for i := 0 to Application.ComponentCount - 1 do
    if Application.Components[i] is TEDCDForm then
      with TEDCDForm(Application.Components[i]) do
      begin
        ToggleTitleBar(true);
        ArrangeLayers;
      end;
end;

procedure TEDCDForm.AppDeactivate(Sender: TObject);
var i: Integer;
begin
  if Application.Terminated then Exit;
  for i := 0 to Application.ComponentCount - 1 do
    if Application.Components[i] is TEDCDForm then
    with TEDCDForm(Application.Components[i]) do
    begin
      UpdateBackdrop;
      ToggleTitleBar(false);
      UpdateTransparency;
    end;
end;

procedure TEDCDForm.ToggleTitleBar(activef: Boolean);
begin
  with TitleLabel do
  begin
    Transparent := not activef and Opts.Flags['TransparentTitle'];
    if activef then
    begin
      Font := CloseLabel.Font;
      Color := CloseLabel.Color;

      if (self = EDCDForm) and not ToolbarForm.Visible then
      begin
        ToolbarForm.Show;
                                        //HWND_BOTTOM
        SetWindowPos(ToolbarForm.Handle, self.Handle, 0, 0 , 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
      end;
    end
    else
    begin
      Font := TextColLabel.Font;
      if not Opts.Flags['TransparentTitle'] then
        Color := clBlack
      else
        Color := TextColLabel.Color;

      ToolbarForm.Hide;
    end;
  end;
  if not Opts.Flags['ShowCloseBox'] then CloseLabel.Visible := activef;
end;

end.
