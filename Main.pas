unit Main;


interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.PsAPI, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, System.IOUtils, System.Math,
  Vcl.ExtCtrls, Vcl.Menus, Settings, DataSource;

type TCDCol = (colReq,colText,colStock,colStatus);

type
  TEDCDForm = class(TForm)
    TextColLabel: TLabel;
    UpdTimer: TTimer;
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
    procedure FormCreate(Sender: TObject);
    procedure UpdTimerTimer(Sender: TObject);
    procedure TextColLabelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TextColLabelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TextColLabelDblClick(Sender: TObject);
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
  private
    { Private declarations }
    FSelectedConstructions: TStringList;
    FCurrentDepot: TConstructionDepot;
    FWorkingDir,FJournalDir: string;
//    FSettings: TSettings;
    FTransColor: TColor;
    FLastActiveWnd: HWND;
    FTable: array [colReq..colStatus] of TLabel;
    procedure ResetAlwaysOnTop;
    procedure UpdateConstrDepot;
    procedure ApplySettings;
  public
    { Public declarations }
  end;

var
  EDCDForm: TEDCDForm;

implementation

{$R *.dfm}

uses Splash;

var gLastCursorPos: TPoint;

const cDefaultCapacity: Integer = 784;

procedure TEDCDForm.TextColLabelDblClick(Sender: TObject);
begin
  if self.TransparentColor then
  begin
    self.Color := clBlack

  end
  else
    self.Color := FTransColor;
  self.TransparentColor := not self.TransparentColor;
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

procedure TEDCDForm.AddDepotInfoMenuItemClick(Sender: TObject);
begin
  if FCurrentDepot = nil then Exit;

  DataSrc.MarketComments.Values[FCurrentDepot.MarketID] :=
    Vcl.Dialogs.InputBox(FCurrentDepot.StationName, 'Info',
      DataSrc.MarketComments.Values[FCurrentDepot.MarketID]);
  try DataSrc.MarketComments.SaveToFile(FWorkingDir + 'market_info.txt'); except end;
end;

procedure TEDCDForm.AddMarketToExtCargoMenuItemClick(Sender: TObject);
begin
  if DataSrc.Market.Values['$MarketName'] = '' then Exit;


  if Vcl.Dialogs.MessageDlg('Are you sure you want to use ' +
    DataSrc.Market.Values['$MarketName'] + ' as external cargo?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  FSettings.Flags['UseExtCargo'] := true;
  DataSrc.MarketToCargoExt;
  UpdateConstrDepot;
end;

procedure TEDCDForm.ToggleExtCargoMenuItemClick(Sender: TObject);
begin
//  FCargoExt.Clear;
//  FFileDates.Clear;

  FSettings.Flags['UseExtCargo'] := not FSettings.Flags['UseExtCargo'] ;
  UpdateConstrDepot;
end;



procedure TEDCDForm.UpdateConstrDepot;
var j: TJSONObject;
    jarr,resReq: TJSONArray;
    sl: TStringList;
    js,s,s2,fn,cnames,lastUpdate: string;
    i,ci,res,lastWIP,h: Integer;
    fa: DWord;
    reqQty,delQty,stock,prevQty: Integer;
    totReqQty,totDelQty,validCargo: Integer;
    srec: TSearchRec;
    useExtCargo: Boolean;
    a: array [colReq..colStatus] of string;
    cd: TConstructionDepot;
    col: TCDCol;

begin

  sl := TStringList.Create;

  FCurrentDepot := nil;

  DataSrc.Update;

  try

    totReqQty := 0;
    totDelQty := 0;
    sl.Clear;

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
      end;
    end;

    for i := 0 to sl.Count - 1 do
    begin
      s := sl.Names[i];
      if DataSrc.Market.Values[LowerCase(s)] > '0' then
        sl[i] := '+' + sl[i]
      else
        sl[i] := 'x' + sl[i];
    end;
    if FSettings.Flags['AutoSort'] then
      sl.Sort;

    for col := colReq to colStatus do a[col] := '';

    if totReqQty > 0  then
    begin
      validCargo := 0;
      useExtCargo := FSettings['UseExtCargo'] = '1';
      for i := 0 to sl.Count - 1 do
      begin
        s := Copy(sl.Names[i],2,200);

        stock := StrToIntDef(DataSrc.Cargo.Values[LowerCase(s)],0);
        if stock> 0 then validCargo := validCargo + stock;
        if useExtCargo then
          stock := stock + StrToIntDef(DataSrc.CargoExt.Values[LowerCase(s)],0);

        a[colText] := a[colText] + s + Chr(13);
        a[colReq] := a[colReq] + sl.ValueFromIndex[i] + Chr(13);
        s2 := '';
        if stock > 0 then s2 := IntToStr(stock);
        a[colStock] := a[colStock] + s2 + Chr(13);
        s2 := '';
        if Copy(sl.Names[i],1,1) = '+' then s2 := '□';
        if stock > 0 then
        try
          reqQty := StrToInt(sl.ValueFromIndex[i]);
          if stock = reqQty then s2 := '■';           //↑↓▼▲▪▫+
          if stock > reqQty then s2 := '■>';
          if stock < reqQty then s2 := '□>';
        except
        end;
        a[colStatus] := a[colStatus] + s2 + Chr(13);
      end;

      if FSettings.Flags['ShowUnderCapacity'] then
        if (validCargo < DataSrc.Capacity) and (totDelQty + validCargo < totReqQty) then
        begin
          a[colText] := a[colText] + 'UNDER CAPACITY' + Chr(13);
          a[colStock] := a[colStock] + IntToStr(DataSrc.Capacity-validCargo) + Chr(13);
          a[colStatus] := a[colStatus] + '--' + Chr(13);
        end;
      if (FCurrentDepot <> nil) and FSettings.Flags['ShowProgress'] then
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
      if FSettings.Flags['ShowFlightsLeft'] then
        a[colText] := a[colText] + 'Flights left: ' +
          FloatToStrF((totReqQty-totDelQty)/DataSrc.Capacity,ffFixed,7,2) +
          ' (' + IntToStr(DataSrc.Capacity) + 't)' + Chr(13);
      if FSettings.Flags['ShowRecentMarket'] then
        if DataSrc.Market.Count > 0 then
          a[colText] := a[colText] + '□ ' + DataSrc.Market.Values['$MarketName'] + Chr(13);
    end;

    for col := colReq to colStatus do
      FTable[col].Caption := a[col];

    if cnames = '' then
      TitleLabel.Caption := '(no active constructions)'
    else
      TitleLabel.Caption := cnames;

    if FSettings.Flags['AutoHeight'] then
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
  UpdateConstrDepot;
  SplashForm.Hide;
  self.BringToFront;
  UpdTimer.Enabled := True;
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
  UpdateConstrDepot;
  if FSettings['AlwaysOnTop'] = '2' then
    ResetAlwaysOnTop;
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
      FSelectedConstructions.Delete(FSelectedConstructions.IndexOf(cd.MarketId))
    else
      FSelectedConstructions.Add(cd.MarketId);
  end;
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
  c := GetColorFromCode(FSettings['Color'],TextColLabel.Font.Color);
  TitleLabel.Font.Color := c;
  TextColLabel.Font.Color := c;
  DividerTop.Pen.Color := c;
  DividerBottom.Pen.Color := c;
  try
    fn := FSettings['FontName'];
    if fn = '' then fn := TitleLabel.Font.Name;
    fs := StrToIntDef(FSettings['FontSize'],TitleLabel.Font.Size);
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

  if not FSettings.Flags['ShowDividers'] then
  begin
    DividerTop.Visible := False;
    DividerBottom.Visible := False;
  end;
  if not FSettings.Flags['ShowCloseBox'] then
    CloseLabel.Visible := False;
  if not FSettings.Flags['AlwaysOnTop'] then
    self.FormStyle := fsNormal;
  if FSettings.Flags['Backdrop'] then
    self.TransparentColor := False;
  if FSettings['TransColor'] <> '' then
  begin
    FTransColor := GetColorFromCode(FSettings['TransColor'],self.Color);
    self.Color := FTransColor;
    self.TransparentColorValue := FTransColor;
  end;

  if FSettings.Flags['AutoWidth'] then
  begin
    basew := self.Canvas.TextWidth(FSettings['BaseWidthText']);

    ReqQtyColLabel.Width := basew;
    StockColLabel.Width := basew;
    if not FSettings.Flags['ShowIndicators'] then
    begin
      StatusColLabel.Visible := false;
      self.Width := basew * 7;
    end
    else
    begin
      StatusColLabel.Width := basew div 2;
      self.Width := basew * 8;
    end;
    CloseLabel.Left := self.Width - CloseLabel.Width - 3;

    dh := self.Canvas.TextHeight('Wq') - TitleLabel.Height;
    TitleLabel.Height := TitleLabel.Height + dh;
    CloseLabel.Height := CloseLabel.Height + dh;
  end;

  self.Left := StrToIntDef(FSettings['Left'],Screen.Width - self.Width);
  self.Top := StrToIntDef(FSettings['Top'],(Screen.Height - self.Height) div 2);

  //this is not optimized right now
  if not FSettings.Flags['AllowMoreWindows'] then
    NewWindowMenuItem.Visible := False;

end;

procedure TEDCDForm.MarketAsDepotMenuItemClick(Sender: TObject);
begin
  if DataSrc.Market.Values['$MarketName'] = '' then Exit;
  if DataSrc.Market.Values['$MarketType'] <> 'FleetCarrier' then
    if FSettings['AnyMarketAsDepot'] <> '1' then
    begin
      ShowMessage('Recent market is not a Fleet Carrier.' + Chr(13) + 'Visit a valid Commodity market and try again.');
      Exit;
    end;


  if Vcl.Dialogs.MessageDlg('Are you sure you want to use ' +
    DataSrc.Market.Values['$MarketName'] + ' as simulated Construction Depot?',
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

procedure TEDCDForm.PopupMenuPopup(Sender: TObject);
var
  i: Integer;
  mitem: TMenuItem;
  cd: TConstructionDepot;
  selectedf,activef: Boolean;
  s: string;
begin
  SelectDepotSubMenu.Clear;
  activef := False;
  for i := 0 to DataSrc.Constructions.Count - 1 do
  begin
    cd := TConstructionDepot(DataSrc.Constructions.Objects[i]);
    if cd.Status = '' then continue; //docked but no depot info?
    if cd.Finished and not FSettings.Flags['IncludeFinished'] then continue;

    
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
  ToggleExtCargoMenuItem.Checked := FSettings.Flags['UseExtCargo'];
end;

procedure TEDCDForm.ExitMenuItemClick(Sender: TObject);
begin
  self.Close;
end;

procedure TEDCDForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FSettings['Left'] := IntToStr(self.Left);
  FSettings['Top'] := IntToStr(self.Top);
  FSettings.Save;
end;

procedure TEDCDForm.FormCreate(Sender: TObject);
var s: string;
begin
  FTable[colReq] := ReqQtyColLabel;
  FTable[colText] := TextColLabel;
  FTable[colStock] := StockColLabel;
  FTable[colStatus] := StatusColLabel;

  FWorkingDir := GetCurrentDir + '\';
  if FSettings = nil then
  begin
    FSettings := TSettings.Create(FWorkingDir + 'EDConstrDepot.ini');
    FSettings.Load;
  end;

  if DataSrc = nil then
    DataSrc := TEDDataSource.Create;
  FSelectedConstructions := TStringList.Create;

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
    Transparent := not activef;
    if activef then
    begin
      Font := CloseLabel.Font;
      Color := CloseLabel.Color;
    end
    else
    begin
      Font := TextColLabel.Font;
      Color := TextColLabel.Color;
    end;
  end;
  if not FSettings.Flags['ShowCloseBox'] then CloseLabel.Visible := activef;
end;

end.
