﻿unit Main;


interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.PsAPI, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, System.IOUtils, System.Math,
  Vcl.ExtCtrls, Vcl.Menus, Vcl.ComCtrls, Settings, DataSource;

type TCDCol = (colReq,colText,colStock,colStatus);

type
  TEDCDForm = class(TForm, IEDDataListener)
    TextColLabel: TLabel;
    ReqQtyColLabel: TLabel;
    StockColLabel: TLabel;
    StatusColLabel: TLabel;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    ExitMenuItem: TMenuItem;
    ExternalCargoMenu: TMenuItem;
    AddMarketToExtCargoMenuItem: TMenuItem;
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
    procedure FormCreate(Sender: TObject);
    procedure UpdTimerTimer(Sender: TObject);
    procedure TextColLabelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TextColLabelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExitMenuItemClick(Sender: TObject);
    procedure AddMarketToExtCargoMenuItemClick(Sender: TObject);
    procedure ToggleExtCargoMenuItemClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure SwitchDepotMenuItemClick(Sender: TObject);
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
  private
    { Private declarations }
    FSelectedConstructions: TStringList;
    FCurrentDepot: TConstructionDepot;
    FSecondaryMarket: TMarket;
    FAutoSelectMarket: Boolean;
    FWorkingDir,FJournalDir: string;
//    FSettings: TSettings;
    FTransColor: TColor;
    FLastActiveWnd: HWND;
    FTable: array [colReq..colStatus] of TLabel;
    procedure ResetAlwaysOnTop;
    procedure UpdateConstrDepot;
    procedure ApplySettings;
    function FindBestMarket(reqList: TStringList; prevMarket: TMarket): TMarket;
    function GetItemMarketIndicators(normItem: string; reqQty: Integer; cargo: Integer; bestMarket: TMarket): string;
  public
    { Public declarations }
    procedure OnEDDataUpdate;
    procedure SetDepot(mID: string);
    procedure SetSecondaryMarket(mID: string);
  end;

var
  EDCDForm: TEDCDForm;

implementation

{$R *.dfm}

uses Splash, Markets; //SettingsGUI;

var gLastCursorPos: TPoint;

const cDefaultCapacity: Integer = 784;

procedure TEDCDForm.TextColLabelDblClick(Sender: TObject);
var sl: TStringList;
    pt: TPoint;
    idx: Integer;
begin
   pt := Mouse.CursorPos;
   sl := TStringList.Create;
   sl.Text := TextColLabel.Caption;
   try
     pt := TextColLabel.ScreenToClient(pt);
     idx := pt.Y div self.Canvas.TextHeight('Wq');
     if (idx >= 0)  and (idx < sl.Count) then
     begin
       MarketsForm.FilterEdit.Text := LowerCase(sl[idx]);
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
    gLastCursorPos := pt;
  end;
end;

procedure TEDCDForm.TitleLabelDblClick(Sender: TObject);
begin
  if self.TransparentColor then
  begin
    self.Color := clBlack

  end
  else
    self.Color := FTransColor;
  self.TransparentColor := not self.TransparentColor;
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

procedure TEDCDForm.AddMarketToExtCargoMenuItemClick(Sender: TObject);
begin
  if DataSrc.Market.MarketID = '' then Exit;


  if Vcl.Dialogs.MessageDlg('Are you sure you want to use ' +
    DataSrc.Market.StationName + ' as external cargo?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  Opts.Flags['UseExtCargo'] := true;
  DataSrc.MarketToCargoExt;
  UpdateConstrDepot;
end;

procedure TEDCDForm.ToggleExtCargoMenuItemClick(Sender: TObject);
begin
//  FCargoExt.Clear;
//  FFileDates.Clear;

  Opts.Flags['UseExtCargo'] := not Opts.Flags['UseExtCargo'] ;
  UpdateConstrDepot;
end;

function TEDCDForm.FindBestMarket(reqList: TStringList; prevMarket: TMarket): TMarket;
var i,mi,score,maxscore,reqQty,stock,totAvail,lowCnt: Integer;
    m: TMarket;
    s: string;
    testf: Boolean;
begin
  Result := nil;
  maxscore := 0;
  for mi := 0 to DataSrc.RecentMarkets.Count - 1 do
  begin
    m := TMarket(DataSrc.RecentMarkets.Objects[mi]);
    testf := true;
    if m.MarketID = DataSrc.Market.MarketID then testf := false;
    if (prevMarket <> nil) and (m.MarketID = prevMarket.MarketID) then testf := false;
    if DataSrc.GetMarketLevel(m.MarketID) = miIgnore then testf := false;
    if testf then
    begin
      score := 0;
      totAvail := 0;
      for i := 0 to reqList.Count - 1 do
      begin
        s := LowerCase(reqList.Names[i]);
        reqQty := StrToIntDef(reqList.ValueFromIndex[i],0);
        if DataSrc.Cargo[s] >= reqQty then continue;

        lowCnt := 0;
        stock := m.Stock[s];
        if stock > 0 then
        begin
//base points for stocking the commodity
          score := score + 100;
//bonus for stocking other items than pre-selected market
          if (prevMarket <> nil) and (prevMarket.Stock[s] < reqQty) then
          begin
            score := score + 20;
            if stock >= reqQty then score := score + 40;
          end;

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
            if stock > DataSrc.Capacity then
              score := score - 20
            else
              score := score - 50;
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

//bonus for favorite market
      if score > 0 then
         if DataSrc.GetMarketLevel(m.MarketID) >= miFavorite then
           score := score * 4 div 3;  //25% bonus
//penalty points for under capacity run
      if totAvail < DataSrc.Capacity then
      begin
        score := score - 30 * lowCnt;
//        score := score div 2;
        score := score * 2 div 3; //33% penalty
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

var cIndPad: string = '';

function TEDCDForm.GetItemMarketIndicators(normItem: string; reqQty: Integer; cargo: Integer; bestMarket: TMarket): string;
var stock,maxQty: Integer;
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
        s := s + cIndPad; //todo: calculate spaces!
    end;
begin
  Result := '';

  if Opts.Flags['IndicatorsPadding'] then
    if cIndPad = '' then
    begin
      while (Length(cIndPad) < 5) and (self.Canvas.TextWidth(cIndPad) < self.Canvas.TextWidth('■')) do
        cIndPad := cIndPad + ' ' ;
    end;

  stock := DataSrc.Market.Stock[normItem];
  maxQty := reqQty;
  if maxQty > DataSrc.Capacity then
    maxQty := DataSrc.Capacity;

  if not Opts.Flags['IncludeSupply'] then
  begin
    AddMarker(stock,'□','□');
    if bestMarket <> nil then
      AddMarker(bestMarket.Stock[normItem],'○','○');
    if FSecondaryMarket <> nil then
      AddMarker(FSecondaryMarket.Stock[normItem],'∆','∆');
  end
  else
  begin
    AddMarker(stock,'■','□');
    if bestMarket <> nil then
      AddMarker(bestMarket.Stock[normItem],'●','○');
    if FSecondaryMarket <> nil then
      AddMarker(FSecondaryMarket.Stock[normItem],'▲','∆');
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

procedure TEDCDForm.UpdateConstrDepot;
var j: TJSONObject;
    jarr,resReq: TJSONArray;
    sl: TStringList;
    js,s,s2,fn,cnames,lastUpdate,itemName,normItem: string;
    i,ci,res,lastWIP,h: Integer;
    fa: DWord;
    reqQty,delQty,cargo,stock,prevQty,maxQty: Integer;
    totReqQty,totDelQty,validCargo: Integer;
    srec: TSearchRec;
    useExtCargo: Boolean;
    a: array [colReq..colStatus] of string;
    cd: TConstructionDepot;
    col: TCDCol;
    bestMarket: TMarket;
begin

  sl := TStringList.Create;

  FCurrentDepot := nil;

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
          begin
            lastWIP := ci;
            lastUpdate := cd.LastUpdate;
          end;
      end;

    cnames := '';

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


    bestMarket := nil;
    if Opts.Flags['ShowBestMarket'] then
      bestMarket := FindBestMarket(sl,nil);

    if FAutoSelectMarket then
      FSecondaryMarket := FindBestMarket(sl,bestMarket);

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

    if Opts.Flags['AutoSort'] then
      sl.Sort;

    for col := colReq to colStatus do a[col] := '';

    if totReqQty > 0  then
    begin
      validCargo := 0;
      useExtCargo := Opts['UseExtCargo'] = '1';
      for i := 0 to sl.Count - 1 do
      begin
        itemName := Copy(sl.Names[i],2,200);
        normItem := LowerCase(itemName);

        cargo := StrToIntDef(DataSrc.Cargo.Values[normItem],0);
        if cargo > 0 then validCargo := validCargo + cargo;
        if useExtCargo then
          cargo := cargo + StrToIntDef(DataSrc.CargoExt.Stock.Values[normItem],0);

        a[colText] := a[colText] + itemName + Chr(13);
        a[colReq] := a[colReq] + sl.ValueFromIndex[i] + Chr(13);

        s := '';
        if cargo > 0 then s := IntToStr(cargo);
        a[colStock] := a[colStock] + s + Chr(13);
        s := '';
        reqQty := StrToIntDef(sl.ValueFromIndex[i],0);
        if cargo < reqQty then
          s := GetItemMarketIndicators(normItem,reqQty,cargo,bestMarket);
        if cargo > 0 then
        begin
          if cargo = reqQty then s := '';           //■□↑↓▼▲▪▫+∆◊♦○●
          if cargo > reqQty then s := '≠ ' + s;
          if cargo < reqQty then
            if cargo < DataSrc.Capacity then s := '< ' + s;
//          if Length(s) > 3 then
//            s := Copy(s,1,3) + '...'; //show only one extra market
        end;
        a[colStatus] := a[colStatus] + s + Chr(13);
      end;

      if Opts.Flags['ShowUnderCapacity'] then
        if (validCargo < DataSrc.Capacity) and (totDelQty + validCargo < totReqQty) then
        begin
          a[colText] := a[colText] + 'UNDER CAPACITY' + Chr(13);
          a[colStock] := a[colStock] + IntToStr(DataSrc.Capacity-validCargo) + Chr(13);
          a[colStatus] := a[colStatus] + '----' + Chr(13);
        end;
      if (FCurrentDepot <> nil) and Opts.Flags['ShowProgress'] then
      begin
        if FCurrentDepot.Simulated then
        begin
          s := 'Last update: ' + Copy(FCurrentDepot.LastUpdate,1,16);
        end
        else
        begin
          s := 'Progress: ';
          if FCurrentDepot.Finished then
            s := s + 'DONE'
          else
            s := s + IntToStr((100*totDelQty) div totReqQty) + '%';
        end;
//        if FCurrentDepot <> nil then
//          s := s + ' (' + Copy(FCurrentDepot.LastUpdate,1,10) + ')';
        a[colText] := a[colText] + s + Chr(13);
      end;
      if Opts.Flags['ShowFlightsLeft'] and (DataSrc.Capacity > 0) then
        a[colText] := a[colText] + 'Flights left: ' +
          FloatToStrF((totReqQty-totDelQty)/DataSrc.Capacity,ffFixed,7,2) +
          ' (' + IntToStr(DataSrc.Capacity) + 't)' + Chr(13);
      if Opts.Flags['ShowRecentMarket'] then
        if DataSrc.Market.Stock.Count > 0 then
          a[colText] := a[colText] + '□ ' + DataSrc.Market.FullName + Chr(13);
      if bestMarket <> nil then
        a[colText] := a[colText] + '○ ' + bestMarket.FullName + Chr(13);
      if FSecondaryMarket <> nil then
        a[colText] := a[colText] + '∆ ' + FSecondaryMarket.FullName + Chr(13);
    end;

    for col := colReq to colStatus do
      FTable[col].Caption := a[col];

    if cnames = '' then
      TitleLabel.Caption := '(no active constructions)'
    else
      TitleLabel.Caption := cnames;

    if Opts.Flags['AutoHeight'] then
    begin
      sl.Text := a[colText];
      h := TextColLabel.Margins.Top +
           self.Canvas.TextHeight('Wq') * sl.Count +
           TextColLabel.Margins.Bottom;
      h := TextColLabel.Top + h + 2;
      if self.Height <> h then self.Height := h;
    end;

  finally

    j.Free;
    sl.Free;
  end;
end;

procedure TEDCDForm.FormShow(Sender: TObject);
begin
  SplashForm.Show;
  SplashForm.Update;
  DataSrc.Update;
  if Opts['SelectedMarket'] <> 'auto' then
    FSecondaryMarket := DataSrc.MarketFromID(Opts['SelectedMarket']);
  UpdateConstrDepot;
  SplashForm.Hide;
  self.BringToFront;
  DataSrc.UpdTimer.Enabled := True;
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
          self.FormStyle := fsStayOnTop
        else
          self.FormStyle := fsNormal;
      end;
    finally
      CloseHandle(hProcess);
    end
end;

procedure TEDCDForm.UpdTimerTimer(Sender: TObject);
begin
  if Opts['AlwaysOnTop'] = '2' then
    ResetAlwaysOnTop;
  if Opts.Flags['ScanMenuKey']  then
    if GetKeyState(VK_APPS) < 0 then
      MarketsForm.Show; //PopupMenu.Popup(self.Left,self.Top);
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
      FSelectedConstructions.Add(cd.MarketId);
  end;
  UpdateConstrDepot;
end;

procedure TEDCDForm.SetDepot(mID: string);
begin
  FSelectedConstructions.Text := mID;
  UpdateConstrDepot;
end;

procedure TEDCDForm.SetSecondaryMarket(mID: string);
begin
  FAutoSelectMarket := False;
  FSecondaryMarket := DataSrc.MarketFromID(mID);
  UpdateConstrDepot;
end;

procedure TEDCDForm.SettingsMenuItemClick(Sender: TObject);
begin
//  SettingsForm.Show;
end;

procedure TEDCDForm.SwitchMarketMenuItemClick(Sender: TObject);
var m: TMarket;
    i,idx: Integer;
begin
  FAutoSelectMarket := false;
  idx := TMenuItem(Sender).Tag;
  if idx >= DataSrc.RecentMarkets.Count then Exit;
  if not TMenuItem(Sender).Checked or (idx = -1) then
    FSecondaryMarket := nil
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

procedure TEDCDForm.ApplySettings;
var i,fs,dh,basew: Integer;
    s: string;
    fn: TFontName;
    c: TColor;
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
      if self.Controls[i] is TLabel then
        with TLabel(self.Controls[i]) do
        begin
          Font.Size := fs;
          Font.Name := fn;
        end;
  except
  end;

  if not Opts.Flags['ShowDividers'] then
  begin
    DividerTop.Visible := False;
    DividerBottom.Visible := False;
  end;
  if not Opts.Flags['ShowCloseBox'] then
    CloseLabel.Visible := False;
  if not Opts.Flags['AlwaysOnTop'] then
    self.FormStyle := fsNormal;
  if Opts.Flags['Backdrop'] then
    self.TransparentColor := False;
  if Opts['TransColor'] <> '' then
  begin
    FTransColor := GetColorFromCode(Opts['TransColor'],self.Color);
    self.Color := FTransColor;
    self.TransparentColorValue := FTransColor;
  end;

  if Opts.Flags['AutoWidth'] then
  begin
    basew := self.Canvas.TextWidth(Opts['BaseWidthText']);

    ReqQtyColLabel.Width := basew;
    StockColLabel.Width := basew;
    if not Opts.Flags['ShowIndicators'] then
    begin
      StatusColLabel.Visible := false;
      self.Width := basew * 7;
    end
    else
    begin
      StatusColLabel.Width := basew;
      self.Width := basew * 8;
    end;
    CloseLabel.Left := self.Width - CloseLabel.Width - 3;

    dh := self.Canvas.TextHeight('Wq') - TitleLabel.Height;
    TitleLabel.Height := TitleLabel.Height + dh;
    CloseLabel.Height := CloseLabel.Height + dh;
  end;

  self.Left := StrToIntDef(Opts['Left'],Screen.Width - self.Width);
  self.Top := StrToIntDef(Opts['Top'],(Screen.Height - self.Height) div 2);

  //this is not optimized right now
  if not Opts.Flags['AllowMoreWindows'] then
    NewWindowMenuItem.Visible := False;

  FAutoSelectMarket := Opts['SelectedMarket'] = 'auto';
end;

procedure TEDCDForm.AutoSelectMarketMenuItemClick(Sender: TObject);
begin
   FAutoSelectMarket := TMenuItem(Sender).Checked;
   UpdateConstrDepot;
end;

procedure TEDCDForm.ManageMarketsMenuItemClick(Sender: TObject);
begin
  MarketsForm.Show;
end;

procedure TEDCDForm.MarketAsDepotMenuItemClick(Sender: TObject);
begin
  if DataSrc.Market.MarketId = '' then Exit;
  if DataSrc.Market.StationType <> 'FleetCarrier' then
    if Opts['AnyMarketAsDepot'] <> '1' then
    begin
      ShowMessage('Recent market is not a Fleet Carrier.' + Chr(13) + 'Visit a valid Commodity market and try again.');
      Exit;
    end;


  if Vcl.Dialogs.MessageDlg('Are you sure you want to use ' +
    DataSrc.Market.StationName + ' as simulated Construction Depot?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  DataSrc.MarketToSimDepot;
  UpdateConstrDepot;
end;

procedure TEDCDForm.MinimizeMenuItemClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TEDCDForm.NewWindowMenuItemClick(Sender: TObject);
begin
  with TEDCDForm.Create(Application) do
  begin
    Top := self.Top + self.Height;
    Show;
  end;
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

procedure TEDCDForm.PopupMenuPopup(Sender: TObject);
var
  i,j: Integer;
  mitem: TMenuItem;
  cd: TConstructionDepot;
  m: TMarket;
  selectedf,activef: Boolean;
  s: string;
begin
  SelectDepotSubMenu.Clear;
  activef := False;

//stress test
//  for j := 0 to 10 do

  for i := 0 to DataSrc.Constructions.Count - 1 do
  begin
    cd := TConstructionDepot(DataSrc.Constructions.Objects[i]);
    if cd.Status = '' then continue; //docked but no depot info?
    if cd.Finished and not Opts.Flags['IncludeFinished'] then
      if FSelectedConstructions.IndexOf(cd.MarketID) = -1 then continue;


    mitem := TMenuItem.Create(SelectDepotSubMenu);
    mitem.Caption := cd.StationName + '/' + cd.StarSystem;
    s := DataSrc.MarketComments.Values[cd.MarketID];
    if s <> '' then
      mitem.Caption := mitem.Caption + ' (' + Copy(s,1,20) + ')';
    mitem.Tag := i;
    mitem.OnClick := SwitchDepotMenuItemClick;
    mitem.AutoCheck := true;
    selectedf := FSelectedConstructions.IndexOf(cd.MarketId) <> -1;
    mitem.Checked := selectedf;
    activef := activef or selectedf;

    if cd.Finished then  mitem.Caption := '[DONE] ' + mitem.Caption;

    SelectDepotSubMenu.Add(mitem);
  end;

  mitem := TMenuItem.Create(SelectDepotSubMenu);
  mitem.Caption := '(Recent construction in progress)';
  mitem.Checked := not activef;
  mitem.Enabled := activef;
  mitem.Tag := -1;
  mitem.OnClick := SwitchDepotMenuItemClick;
  SelectDepotSubMenu.Add(mitem);
  ToggleExtCargoMenuItem.Checked := Opts.Flags['UseExtCargo'];


  SelectMarketSubMenu.Clear;
  activef := False;
  for i := 0 to DataSrc.RecentMarkets.Count - 1 do
  begin
    m := TMarket(DataSrc.RecentMarkets.Objects[i]);
    if m.Status = '' then continue; //docked but no depot info?
    if DataSrc.GetMarketLevel(m.MarketID) = miIgnore then continue;
    mitem := TMenuItem.Create(SelectMarketSubMenu);
    mitem.Caption := m.StationName + '/' + m.StarSystem;
//    if DataSrc.GetMarketLevel(m.MarketID) = miIgnore then
//       mitem.Caption := '[IGNORED] ' + mitem.Caption;
    s := DataSrc.MarketComments.Values[m.MarketID];
    if s <> '' then
      mitem.Caption := mitem.Caption + ' (' + Copy(s,1,20) + ')';
    mitem.Tag := i;
    mitem.OnClick := SwitchMarketMenuItemClick;
    mitem.AutoCheck := true;
    mitem.Checked := (FSecondaryMarket <> nil) and (m.MarketId = FSecondaryMarket.MarketID);
    SelectMarketSubMenu.Add(mitem);
  end;

  mitem := TMenuItem.Create(SelectMarketSubMenu);
  mitem.Caption := '( Auto select market )';
  mitem.AutoCheck := True;
  mitem.Checked := FAutoSelectMarket;
  mitem.OnClick := AutoSelectMarketMenuItemClick;
  SelectMarketSubMenu.Add(mitem);

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
    mitem.Caption := 'Ignore Selected Market';
    mitem.OnClick := IgnoreMarketMenuItemClick;
    SelectMarketSubMenu.Add(mitem);

    mitem := TMenuItem.Create(SelectMarketSubMenu);
    mitem.Caption := 'Forget Selected Market';
    mitem.OnClick := ForgetMarketMenuItemClick;
    SelectMarketSubMenu.Add(mitem);
  end;
end;

procedure TEDCDForm.ExitMenuItemClick(Sender: TObject);
begin
  self.Close;
end;



procedure TEDCDForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
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
end;

procedure TEDCDForm.FormCreate(Sender: TObject);
var s: string;
begin
  FTable[colReq] := ReqQtyColLabel;
  FTable[colText] := TextColLabel;
  FTable[colStock] := StockColLabel;
  FTable[colStatus] := StatusColLabel;

  FWorkingDir := GetCurrentDir + '\';
  if Opts = nil then
  begin
    Opts := TSettings.Create(FWorkingDir + 'EDConstrDepot.ini');
    Opts.Load;
  end;

  if DataSrc = nil then
    DataSrc := TEDDataSource.Create(Application);
  DataSrc.AddListener(self);

  FSelectedConstructions := TStringList.Create;

  if Opts.Flags['KeepSelected'] then
    FSelectedConstructions.CommaText := Opts['SelectedDepots'];

  FTransColor := self.Color;

  ApplySettings;

  Application.OnActivate :=  AppActivate;
  Application.OnDeactivate :=  AppDeactivate;

end;

procedure TEDCDForm.AppActivate(Sender: TObject);
var i: Integer;
begin
  for i := 0 to Application.ComponentCount - 1 do
    if Application.Components[i] is TEDCDForm then
      TEDCDForm(Application.Components[i]).ToggleTitleBar(true);
end;

procedure TEDCDForm.AppDeactivate(Sender: TObject);
var i: Integer;
begin
  for i := 0 to Application.ComponentCount - 1 do
    if Application.Components[i] is TEDCDForm then
      TEDCDForm(Application.Components[i]).ToggleTitleBar(false);
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
