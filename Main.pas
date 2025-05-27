unit Main;


interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.PsAPI, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, System.IOUtils, System.Math, System.StrUtils,
  Vcl.ExtCtrls, Vcl.Menus, Vcl.ComCtrls, Settings, DataSource;

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
    ManageMarketsMenuItem: TMenuItem;
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
    procedure FormCreate(Sender: TObject);
    procedure UpdTimerTimer(Sender: TObject);
    procedure TextColLabelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TextColLabelMouseDown(Sender: TObject; Button: TMouseButton;
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
    procedure ManageMarketsMenuItemClick(Sender: TObject);
    procedure SettingsMenuItemClick(Sender: TObject);
    procedure AutoSelectMarketMenuItemClick(Sender: TObject);
    procedure TitleLabelDblClick(Sender: TObject);
    procedure TextColLabelDblClick(Sender: TObject);
    procedure StatusPaintBoxPaint(Sender: TObject);
    procedure IncludeExtCargoinRequestMenuItemClick(Sender: TObject);
    procedure UseAsStockMenuItemClick(Sender: TObject);
    procedure ComparePurchaseOrderMenuItemClick(Sender: TObject);
    procedure Layer1Click(Sender: TObject);
    procedure SwitchTaskGroupMenuItemClick(Sender: TObject);
    procedure NewTaskGroupMenuItemClick(Sender: TObject);
    procedure MarketInfoMenuItemClick(Sender: TObject);
private
    { Private declarations }
    FSelectedConstructions: TStringList;
    FCurrentDepot: TConstructionDepot;
    FSecondaryMarket: TMarket;
    FAutoSelectMarket: Boolean;
    FWorkingDir,FJournalDir: string;
//    FSettings: TSettings;
    FTransColor: TColor;
    FGlowChanges: Integer;
    FLastActiveWnd: HWND;
    FEliteWnd: HWND;
    FBackdrop: Boolean;
    FItemsShown: Integer;
    FLayer0: TForm;
    FLayer1: TForm;
    FIndicators: TStringList;
    procedure ResetAlwaysOnTop;
    procedure ApplySettings;
    procedure UpdateBackdrop;
    procedure SetupLayers;
    procedure ArrangeLayers;
    procedure UpdateTransparency;
    function FindBestMarket(reqList: TStringList; prevMarket: TMarket): TMarket;
    function GetItemMarketIndicators(normItem: string; reqQty: Integer; cargo: Integer; bestMarket: TMarket): string;
  public
    { Public declarations }
    procedure OnEDDataUpdate;
    procedure UpdateConstrDepot;
    procedure SetDepot(mID: string; groupf: Boolean);
    procedure SetSecondaryMarket(mID: string);
    procedure MarketAsDepotDlg(m: TMarket);
    procedure MarketAsExtCargoDlg(m: TMarket; mode: Integer);
    procedure OnChangeSettings;
  end;

var
  EDCDForm: TEDCDForm;

implementation

{$R *.dfm}

uses Splash, Markets, SettingsGUI, MarketInfo, Clipbrd;

var gLastCursorPos: TPoint;

const cDefaultCapacity: Integer = 784;

procedure TEDCDForm.TextColLabelDblClick(Sender: TObject);
var sl: TStringList;
    pt: TPoint;
    idx,p,px: Integer;
    s: string;
begin
   pt := Mouse.CursorPos;
   sl := TStringList.Create;
   sl.Text := TextColLabel.Caption;
   try
     pt := TextColLabel.ScreenToClient(pt);
     idx := pt.Y div self.Canvas.TextHeight('Wq');
     if (idx >= 0)  and (idx < sl.Count) then
     begin
       s := LowerCase(sl[idx]);
       if idx >= FItemsShown then
       begin
         p := Pos('/',s);
         px := self.Canvas.TextWidth(Copy(s,1,p));

         if (p > 0) and (pt.X > px) then
         begin
           s := Copy(s,p+1,200);
           Clipboard.SetTextBuf(PChar(s));
           SplashForm.ShowInfo('System name copied...',1000);
           Exit;
         end;

         if p > 0 then
           s := Copy(s,3,p-3)
         else
           Exit;
       end;
       MarketsForm.MarketsCheck.Checked := True;
       MarketsForm.FilterEdit.Text := s;
       if MarketsForm.Visible then
         MarketsForm.UpdateItems
       else
         MarketsForm.Show;
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
    if FLayer1 <> nil then
    begin
      FLayer1.Left := self.Left - 2;
      FLayer1.Top := self.Top - 2; // + TitleLabel.Height;
    end;
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

  orgs := DataSrc.MarketComments.Values[FCurrentDepot.MarketID];
  s := Vcl.Dialogs.InputBox(FCurrentDepot.StationName, 'Info', orgs);
  if s <> orgs then
    DataSrc.UpdateMarketComment(FCurrentDepot.MarketID,s);
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
  if Vcl.Dialogs.MessageDlg('Are you sure you want to use ' +
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


function TEDCDForm.FindBestMarket(reqList: TStringList; prevMarket: TMarket): TMarket;
var i,mi,score,maxscore,reqQty,shipQty,stock,totAvail,lowCnt,uniqueCnt,bonus: Integer;
    m: TMarket;
    s,tg: string;
    testf: Boolean;
    mlev: TMarketLevel;
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
      for i := 0 to reqList.Count - 1 do
      begin
        s := LowerCase(reqList.Names[i]);
        reqQty := StrToIntDef(reqList.ValueFromIndex[i],0);
        if DataSrc.Cargo[s] >= reqQty then continue;
        shipQty := reqQty;
        if shipQty > DataSrc.Capacity then shipQty := DataSrc.Capacity;


        lowCnt := 0;
        uniqueCnt := 0;
        stock := m.Stock[s];
        if stock > 0 then
        begin
//base points for stocking the commodity
          score := score + 100;
//bonus for stocking other items than pre-selected market
          if (prevMarket <> nil) and (prevMarket.Stock[s] < shipQty) then
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
            score := score + 10;
//extra points for station other than last visited (just for variety)
          if DataSrc.Market.Stock[s] <= 0 then
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
        if m.DistFromStar > 100000  then
          score := score * 50 div 100  //-50% penalty
        else
        if m.DistFromStar > 10000  then
          score := score * 90 div 100  //-10% penalty
        ;
      end;

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
begin
  UpdateConstrDepot;
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
    js,s,s2,fn,cnames,cprogress,lastUpdate,itemName,normItem: string;
    i,ci,res,lastWIP,h,q,prec,sortPrefixLen: Integer;
    fa: DWord;
    reqQty,delQty,cargo,stock,prevQty,maxQty: Integer;
    totReqQty,totDelQty,validCargo: Integer;
    srec: TSearchRec;
    useExtCargo: Integer;
    a: array [colReq..colStatus] of string;
    cd: TConstructionDepot;
    col: TCDCol;
    bestMarket: TMarket;
begin

  sl := TStringList.Create;

  FCurrentDepot := nil;

  if FSecondaryMarket = nil then
    if Opts['SelectedMarket'] <> 'auto' then
      FSecondaryMarket := DataSrc.MarketFromID(Opts['SelectedMarket']);


//  DataSrc.Update;

  try

    totReqQty := 0;
    totDelQty := 0;

    lastWIP := -1;
    lastUpdate := '';
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

    cnames := '';
    cprogress := '';
    FItemsShown := 0;

    for ci := 0 to DataSrc.Constructions.Count - 1 do
    begin
      cd := TConstructionDepot(DataSrc.Constructions.Objects[ci]);
      if (FSelectedConstructions.IndexOf(cd.MarketID) = -1) and (ci <> lastWIP) then continue;
      FCurrentDepot := cd;
      if cnames <> '' then cnames := cnames + ', ';
      cnames := cnames + cd.StationName;
      if DataSrc.MarketComments.Values[cd.MarketID] <> '' then
        cnames := cnames + ' (' + DataSrc.MarketComments.Values[cd.MarketID] + ')';
      js := cd.Status;

      try
        j := TJSONObject.ParseJSONValue(js) as TJSONObject;

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
        if DataSrc.Cargo[s] > 0 then
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

    for col := colReq to colStatus do a[col] := '';

    if totReqQty > 0  then
    begin
      validCargo := 0;
      useExtCargo := -1;
      if DataSrc.CargoExt <> nil then
        useExtCargo := StrToInt(Opts['UseExtCargo']);
      for i := 0 to sl.Count - 1 do
      begin
        itemName := Copy(sl.Names[i],1+sortPrefixLen,200);
        normItem := LowerCase(itemName);

        cargo := StrToIntDef(DataSrc.Cargo.Values[normItem],0);
        if cargo > 0 then validCargo := validCargo + cargo;
        if useExtCargo = 1 then
          cargo := cargo + StrToIntDef(DataSrc.CargoExt.Stock.Values[normItem],0);
        if useExtCargo = 3 then
          cargo := cargo + StrToIntDef(DataSrc.CargoExt.Stock.Values['$' + normItem],0);

        a[colText] := a[colText] + itemName + Chr(13);
        a[colReq] := a[colReq] + sl.ValueFromIndex[i] + Chr(13);
        FItemsShown := FItemsShown + 1;

        reqQty := StrToIntDef(sl.ValueFromIndex[i],0);
        s := '';
        if cargo > 0 then
        begin
          s := IntToStr(cargo);
          if not Opts.Flags['ShowIndicators'] then
          begin
            if cargo = reqQty then s := '✓ ' + s;
            if cargo > reqQty then s := '+ ' + s;
          end;
        end;
        a[colStock] := a[colStock] + s + Chr(13);
        s := '';
        if cargo < reqQty then
          s := GetItemMarketIndicators(normItem,reqQty,cargo,bestMarket);
        if cargo > 0 then
        begin
          if cargo = reqQty then s := '✓';           //■□▼▲◊♦○●✓✋⚠⛔
          if cargo > reqQty then s := '✓+';
//          if cargo < reqQty then
//            if cargo < DataSrc.Capacity then s := '< ' + s;
        end;
        a[colStatus] := a[colStatus] + s + Chr(13);
      end;

      if (Opts.Flags['ShowUnderCapacity']) and (DataSrc.Capacity > 0) then
        if (validCargo < DataSrc.Capacity) and (totDelQty + validCargo < totReqQty) then
        begin
          if Opts['ShowFlightsLeft'] = '2' then
          begin
            reqQty := totReqQty-totDelQty;
            q := reqQty - (reqQty div DataSrc.Capacity) * DataSrc.Capacity - validCargo;
            if q > 0 then
            begin
              s := IntToStr(q);
              a[colReq] := a[colReq] + '(' + s + ')' + Chr(13);
            end;
          end;

          a[colText] := a[colText] + '⚠ UNDER CAPACITY' + Chr(13);
          a[colStock] := a[colStock] + '(' + IntToStr(DataSrc.Capacity-validCargo) + ')' + Chr(13);
          a[colStatus] := a[colStatus] + '' + Chr(13);
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
          a[colText] := a[colText] + s + Chr(13);
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
          a[colText] := a[colText] + 'Flights left: ' + s + ' (' + s2 + 't)' + Chr(13);
        end;
      end;
      if Opts.Flags['ShowIndicators'] then
      begin
        if Opts.Flags['ShowRecentMarket'] then
          if DataSrc.Market.Stock.Count > 0 then
            a[colText] := a[colText] + '□ ' + DataSrc.Market.FullName + Chr(13);
        if bestMarket <> nil then
          a[colText] := a[colText] + '○ ' + bestMarket.FullName + Chr(13);
        if FSecondaryMarket <> nil then
          a[colText] := a[colText] + '△ ' + FSecondaryMarket.FullName + Chr(13);
      end;
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
           self.Canvas.TextHeight('Wq') * sl.Count +
           TextColLabel.Margins.Bottom;
      h := TextColLabel.Top + h + 2;
      if self.Height <> h then
      begin
        self.Height := h;
      end;
      h := h + 4;
      if (FLayer1 <> nil) and (FLayer1.Height <> h) then
        FLayer1.Height := h;
    end;

  finally

    j.Free;
    sl.Free;
  end;
end;

procedure TEDCDForm.FormShow(Sender: TObject);
begin
//
end;

procedure TEDCDForm.ResetAlwaysOnTop;
var wnd: HWND;
    pid: DWORD;
    hProcess: THandle;
    path: array[0..4095] of Char;
    s: string;
begin
  wnd := GetForegroundWindow;
  if wnd = self.Handle then Exit;
  if wnd = FLastActiveWnd then Exit;
  FLastActiveWnd := wnd;

  GetWindowThreadProcessId(wnd, pid);
  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, FALSE, pid);
  if hProcess <> 0 then
    try
      if GetModuleFileNameEx(hProcess, 0, @path[0], Length(path)) <> 0 then
      begin
        s := PWideChar(@path);
        if Pos('EliteDangerous',s) > 0 then
        begin
          if FLayer1 <> nil then FLayer1.FormStyle := fsStayOnTop;
          self.FormStyle := fsStayOnTop;
          FEliteWnd := wnd;
        end
        else
        begin
          if FLayer1 <> nil then FLayer1.FormStyle := fsNormal;
          self.FormStyle := fsNormal;
        end;
      end;
    finally
      CloseHandle(hProcess);
    end
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
  SetWindowPos(FLayer1.Handle, t, 0, 0 , 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  SetWindowPos(self.Handle, t, 0, 0 , 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TEDCDForm.UpdTimerTimer(Sender: TObject);
var orgactivewnd: HWND;
    c,orgc: TColor;
    clr: System.UITypes.TColorRec;
    p: TPoint;
    sdc: HDC;
    i,avg: Integer;
begin
  if Opts['AlwaysOnTop'] = '2' then
    ResetAlwaysOnTop;

  if Opts.Flags['ScanMenuKey'] and (self = EDCDForm) then
    if GetKeyState(VK_APPS) < 0 then
    begin
      orgactivewnd := GetForegroundWindow;
      if orgactivewnd = FEliteWnd then
      begin
        Application.BringToFront;
        //self.BringToFront;
        //self.Activate;
        //if orgactivewnd = self.Handle then
        //  PopupMenu.Popup(self.Left,self.Top);
      end;
    end;

  MarketInfoForm.SyncComparison;

//experimental - single pixel only
  if Opts.Flags['AutoFontGlow']  then
  begin
{
    FGlowChanges := FGlowChanges - 1;
    if FGlowChanges > 0 then Exit;
    FGlowChanges := 1000 div UpdTimer.InterVal; //only one change per second
}
    orgc := self.Color;
    p := FLayer1.ClientToScreen(TPoint.Create(0,0));
    sdc:= GetDC(0);
    c := orgc;
    try c := GetPixel(sdc,p.X,p.Y); except end;
    clr.Color := c;
    avg := 48 + (((clr.R + clr.G + clr.B) div 3) div 64) * 48; //4 levels only
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
end;


procedure TEDCDForm.SwitchDepotMenuItemClick(Sender: TObject);
var cd: TConstructionDepot;
    i: Integer;
begin
  if TMenuItem(Sender).Tag >= DataSrc.Constructions.Count then Exit;
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
        FSelectedConstructions.Add(cd.MarketId)
      end
      else
        FSelectedConstructions.Text := cd.MarketId;
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
var fs: TFormStyle;
begin
  self.BringToFront;

//  fs := self.FormStyle;
//  self.FormStyle := fsStayOnTop;
//  self.FormStyle := fs;
{
  FLayer1.FormStyle := fsNormal;
  FLayer1.SendToBack;
  FLayer1.FormStyle := fsStayOnTop;
  self.BringToFront;
  self.FormStyle := fsStayOnTop;
}
end;


procedure TEDCDForm.SetupLayers;
begin

  FLayer1 := TForm.Create(nil);
  FLayer1.AlphaBlend := True;
//  FLayer1.AlphaBlendValue := StrToIntDef(Opts['AlphaBlend'],64);
  FLayer1.BorderStyle := bsNone;
  FLayer1.Color := clBlack;
  FLayer1.FormStyle := fsStayOnTop;
  FLayer1.PopupMenu := self.PopupMenu;

  FLayer1.OnClick := Layer1Click;
  FLayer1.OnDblClick := TextColLabelDblClick;

  FLayer1.Visible := False;


  //  FLayer1.SetBounds(0,0,self.ClientWidth,self.ClientHeight);
//  FLayer1.Show;

{
  with self, ClientOrigin do
    SetWindowPos(FLayer1.Handle, HWND_BOTTOM, Left - 2, Top - 2, ClientWidth + 4, 0,
      SWP_SHOWWINDOW);
}
end;

procedure TEDCDForm.ApplySettings;
var i,fs,dh,basew: Integer;
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
      StatusPaintBox.Width := basew;
      self.Width := basew * 8;
    end;
    StockColLabel.Width := basew;
    CloseLabel.Left := self.Width - CloseLabel.Width - 3;

    dh := self.Canvas.TextHeight('Wq') - TitleLabel.Height;
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

procedure TEDCDForm.ManageMarketsMenuItemClick(Sender: TObject);
begin
  MarketsForm.Show;
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


  if Vcl.Dialogs.MessageDlg('Are you sure you want to use ' +
    m.StationName + ' as simulated Construction Depot?',
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
    Top := self.Top + self.Height;
    Show;
    UpdateConstrDepot;
  end;
  AppActivate(nil);
end;

procedure TEDCDForm.AddRecentMarketMenuItemClick(Sender: TObject);
begin
  if DataSrc.Market.MarketID = '' then Exit;

  if DataSrc.RecentMarkets.IndexOf(DataSrc.Market.MarketID) >= 0 then
  begin
    ShowMessage(DataSrc.Market.StationName + Chr(13) + 'Market is already available for selection.');
    Exit;
  end;

  if Vcl.Dialogs.MessageDlg('Are you sure you want add ' +
    DataSrc.Market.StationName + ' to market list?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  DataSrc.UpdateSecondaryMarket(true);
//  UpdateConstrDepot;
end;

procedure TEDCDForm.ForgetMarketMenuItemClick(Sender: TObject);
begin
  if FSecondaryMarket = nil then Exit;

  if Vcl.Dialogs.MessageDlg('Are you sure you want remove ' +
    FSecondaryMarket.StationName + ' from market list?',
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

procedure TEDCDForm.StatusPaintBoxPaint(Sender: TObject);
var r: TRect;
    i,j,y,dx,dy,dx2: Integer;
    s,orgs: string;
    supplyhintf: Boolean;
begin
  supplyhintf := (Opts['ShowIndicators'] = '2') and Opts.Flags['IncludeSupply'];
  with StatusPaintBox.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clSilver;
    r := ClientRect;
    dx := TextWidth('W') + 1;
//    dx2 := (dx - TextWidth('_')) div 2;
    dy := TextHeight('Wq');
    y := 0;
    for i  := 0 to FIndicators.Count - 1 do
    begin
      for j := 1 to Length(FIndicators[i]) do
      begin
        s := Copy(FIndicators[i],j,1);    //■●▲  □○△
        if supplyhintf then
        begin
          if (s = '△') or (s = '○') or (s = '□') then
            Font.Color := TColor($23238E) //clFireBrick
          else
            Font.Color := clSilver;
            //Canvas.TextRect(r,(j-1)*dx + 2 + dx2,y+1,'_');
          if s = '▲' then s := '△';
          if s = '●' then s := '○';
          if s = '■' then s := '□';
        end;
        TextRect(r,(j-1)*dx + 2,y,s);
      end;
      y := y + dy;
    end;
  end;
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

procedure TEDCDForm.MarketInfoMenuItemClick(Sender: TObject);
begin
  if FSecondaryMarket <> nil then
  begin
    MarketInfoForm.SetMarket(FSecondaryMarket);
    MarketInfoForm.Show;
  end;
end;

procedure TEDCDForm.PopupMenuPopup(Sender: TObject);
var
  i,j,idx: Integer;
  mitem: TMenuItem;
  cd: TConstructionDepot;
  m: TMarket;
  selectedf,activef: Boolean;
  s: string;
  sl: TStringList;
begin

  ToggleExtCargoMenuItem.Checked := Opts['UseExtCargo'] = '1';
  IncludeExtCargoinRequestMenuItem.Checked := Opts['UseExtCargo'] = '2';
  ComparePurchaseOrderMenuItem.Checked := Opts['UseExtCargo'] = '3';
  CurrentTGMenuItem.Caption := 'Task Group: ' + DataSrc.TaskGroup;
  CurrentTGMenuItem.Visible := DataSrc.TaskGroup <> '';

  SelectDepotSubMenu.Clear;
  activef := False;

  sl := TStringList.Create;
  try

  sl.Clear;
  for i := 0 to DataSrc.Constructions.Count - 1 do
  begin
    cd := TConstructionDepot(DataSrc.Constructions.Objects[i]);
    if cd.Status = '' then continue; //docked but no depot info?
    if cd.Finished and not Opts.Flags['IncludeFinished'] then
      if FSelectedConstructions.IndexOf(cd.MarketID) = -1 then continue;
    if DataSrc.GetMarketLevel(cd.MarketID) = miIgnore then continue;
    sl.AddObject(cd.LastUpdate,cd);
  end;
  sl.Sort;
  for i := sl.Count - 1 downto sl.Count - 20 do
  begin
    if i < 0 then break;
    cd := TConstructionDepot(sl.Objects[i]);
    mitem := TMenuItem.Create(SelectDepotSubMenu);
    mitem.Caption := cd.StationName + '/' + cd.StarSystem;
    s := DataSrc.MarketComments.Values[cd.MarketID];
    if s <> '' then
      mitem.Caption := mitem.Caption + ' (' + Copy(s,1,20) + ')';
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
  mitem.Caption := '( Recent construction in progress )';
  mitem.Checked := (FSelectedConstructions.Count = 0); //not activef;
//  mitem.Enabled := activef;
  mitem.Tag := -1;
  mitem.OnClick := SwitchDepotMenuItemClick;
  SelectDepotSubMenu.Insert(0,mitem);

  mitem := TMenuItem.Create(SelectDepotSubMenu);
  mitem.Caption := '( Press and hold CTRL key to group depots )';
  mitem.Enabled := False;
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
    mitem.Caption := m.StationName + '/' + m.StarSystem;
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
    mitem.Caption := m.StationName;
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
  if self = EDCDForm then
  begin
    Opts['Left'] := IntToStr(self.Left);
    Opts['Top'] := IntToStr(self.Top);
    if Opts.Flags['KeepSelected'] then
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
  DataSrc.RemoveListener(self);
  if FLayer1 <> nil then
    FLayer1.Free;
end;

procedure TEDCDForm.FormCreate(Sender: TObject);
var s: string;
begin
  FIndicators := TStringList.Create;

  DataSrc.AddListener(self);

  FSelectedConstructions := TStringList.Create;

  if Opts.Flags['KeepSelected'] then
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
    end
    else
    begin
      Font := TextColLabel.Font;
      if not Opts.Flags['TransparentTitle'] then
        Color := clBlack
      else
        Color := TextColLabel.Color;
    end;
  end;
  if not Opts.Flags['ShowCloseBox'] then CloseLabel.Visible := activef;
end;

end.
