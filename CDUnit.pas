unit CDUnit;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, System.IOUtils, System.Math,
  Vcl.ExtCtrls, Vcl.Menus;

type TMarket = class
  MarketID: string;
  StationName: string;
  StarSystem: string;
  Status: string;
  Active: Boolean;
end;

type TConstructionDepot = class (TMarket)
  Finished: Boolean;
end;

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
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure SwitchDepotMenuItemClick(Sender: TObject);
    procedure MinimizeMenuItemClick(Sender: TObject);
    procedure AddDepotInfoMenuItemClick(Sender: TObject);
  private
    { Private declarations }
    FMarket,FCargo,FFileDates,FCargoExt: TStringList;
    FConstructions: TStringList;
    FCurrentDepot: TConstructionDepot;
    FMarketComments: TStringList;
    FWorkingDir,FJournalDir: string;
    FMarketJSON,FCargoJSON,FCargoExtJSON,FModuleInfoJSON: string;
    FSettings: TStringList;
    FCapacity: Integer;
    FLastJrnlTimeStamp: string;
    function CheckLoadFromFile(var sl: TStringList; fn: string): Boolean;
    procedure UpdateConstrDepotFromJrnl;
    procedure UpdateCargo;
    procedure UpdateCargoExternal;
    procedure UpdateMarket;
    procedure UpdateCapacity;
    procedure UpdateFromJournal(jrnl: TStringList);
    procedure LoadSettings;
    procedure SaveSettings;
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

type TCDCol = (colReq,colText,colStock,colStatus);

procedure TEDCDForm.TextColLabelDblClick(Sender: TObject);
begin
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

  FMarketComments.Values[FCurrentDepot.MarketID] :=
    Vcl.Dialogs.InputBox(FCurrentDepot.StationName, 'Info', FMarketComments.Values[FCurrentDepot.MarketID]);
  try FMarketComments.SaveToFile(FWorkingDir + 'market_info.txt'); except end;
end;

procedure TEDCDForm.AddMarketToExtCargoMenuItemClick(Sender: TObject);
begin
  if FMarket.Values['$MarketName'] = '' then Exit;


  if Vcl.Dialogs.MessageDlg('Are you sure you want to use ' +
    FMarket.Values['$MarketName'] + ' as external cargo?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  FCargoExt.Clear;
//  FFileDates.Clear;
  CopyFile(PChar(FMarketJSON),PChar(FCargoExtJSON),false);
  FSettings.Values['UseExtCargo'] := '1';
  UpdateConstrDepotFromJrnl;
end;

procedure TEDCDForm.ToggleExtCargoMenuItemClick(Sender: TObject);
begin
  FCargoExt.Clear;
  FFileDates.Clear;

  if FSettings.Values['UseExtCargo'] = '1' then
    FSettings.Values['UseExtCargo'] := '0'
  else
    FSettings.Values['UseExtCargo'] := '1';
  UpdateConstrDepotFromJrnl;
end;

function TEDCDForm.CheckLoadFromFile(var sl: TStringList; fn: string): Boolean;
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

procedure TEDCDForm.UpdateCapacity;
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

procedure TEDCDForm.UpdateCargo;
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

procedure TEDCDForm.UpdateMarket;
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

    finally
      j.Free;
    end;
  except
  end;
  sl.Free;
end;

procedure TEDCDForm.UpdateCargoExternal;
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

procedure TEDCDForm.UpdateFromJournal(jrnl: TStringList);
var j: TJSONObject;
    jarr: TJSONArray;
    js,s,tms,event,mID: string;
    i,cpos,midx: Integer;
    cd: TConstructionDepot;
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

        cd := nil;
        if (event = 'Docked') or (event = 'ColonisationConstructionDepot') then
        begin
          midx := FConstructions.IndexOf(mID);
          if midx < 0 then
          begin
            cd := TConstructionDepot.Create;
            cd.MarketID := mID;
            cd.StationName := '#' + mID;
            midx := FConstructions.AddObject(mID,cd);
          end;
          cd := TConstructionDepot(FConstructions.Objects[midx]);
        end;

        if event = 'Docked' then
        begin
          s := j.GetValue<string>('StationName');
          cpos := Pos(': ',s);
          if cpos > 0 then
            s := Copy(s,cpos+2,200);
          cd.StationName := s;
          cd.StarSystem := j.GetValue<string>('StarSystem');
        end;

        if event = 'ColonisationConstructionDepot' then
        begin
          cd := TConstructionDepot(FConstructions.Objects[midx]);
          cd.Status := jrnl[i];
          s := j.GetValue<string>('ConstructionComplete');
          if s = 'true' then cd.Finished := true;
        end;

        FLastJrnlTimeStamp := tms;
      except

      end;


{
      js := jrnl[i];
      if Pos('Loadout',js) > 0 then
      begin
        try
          j := TJSONObject.ParseJSONValue(js) as TJSONObject;
          FCapacity := j.GetValue<Integer>('CargoCapacity');
        except
        end;
      end;
      if Pos('ConstructionDepot',js) > 0 then
      begin
        mID := '';
        try
          j := TJSONObject.ParseJSONValue(js) as TJSONObject;
          mID := j.GetValue<string>('MarketID');
        except
        end;

        if mID = '' then continue;

        midx := FConstructions.IndexOf(mID);
        if midx < 0 then
        begin
          cd := TConstructionDepot.Create;
          cd.MarketID := mID;
          midx := FConstructions.AddObject(mID,cd);
        end;
        cd := TConstructionDepot(FConstructions.Objects[midx]);

        if Pos('Docked',js) > 0 then
        begin
          s := j.GetValue<string>('StationName');
          cpos := Pos(': ',s);
          if cpos > 0 then
            s := Copy(s,cpos+2,200);
          cd.StationName := s;
          cd.StarSystem := j.GetValue<string>('StarSystem');
        end;

        if Pos('ColonisationConstructionDepot',js) > 0 then
        begin
          cd.Status := js;
          s := j.GetValue<string>('ConstructionComplete');
          if s = 'true' then cd.Finished := true;

        end;
      end;
 }

    finally
      j.Free;
    end;

  end;
end;

procedure TEDCDForm.UpdateConstrDepotFromJrnl;
var j: TJSONObject;
    jarr,resReq: TJSONArray;
    sl: TStringList;
    js,s,s2,fn,cnames: string;
    i,ci,res,lastWIP,h: Integer;
    fa: DWord;
    reqQty,delQty,stock,prevQty: Integer;
    totReqQty,totDelQty,validCargo: Integer;
    srec: TSearchRec;
    useExtCargo: Boolean;
    a: array [colReq..colStatus] of string;
    cd: TConstructionDepot;

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

  FCurrentDepot := nil;

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

  try

    totReqQty := 0;
    totDelQty := 0;
    sl.Clear;

    lastWIP := -1;
    for ci := 0 to FConstructions.Count - 1 do
    begin
      cd := TConstructionDepot(FConstructions.Objects[ci]);
      if not cd.Finished and (cd.Status <> '') then lastWIP := ci;
      if cd.Active then
      begin
        lastWIP := -1;
        break;
      end;
    end;

    cnames := '';

    for ci := 0 to FConstructions.Count - 1 do
    begin
      cd := TConstructionDepot(FConstructions.Objects[ci]);
      if not cd.Active and (ci <> lastWIP) then continue;
      FCurrentDepot := cd;
      if cnames <> '' then cnames := cnames + ', ';
      cnames := cnames + cd.StationName;
      if FMarketComments.Values[cd.MarketID] <> '' then  
        cnames := cnames + ' (' + FMarketComments.Values[cd.MarketID] + ')';
      js := cd.Status;
      try
        j := TJSONObject.ParseJSONValue(js) as TJSONObject;
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
      except
      end;
    end;

    for i := 0 to sl.Count - 1 do
    begin
      s := sl.Names[i];
      if FMarket.Values[LowerCase(s)] > '0' then
        sl[i] := '+' + sl[i]
      else
        sl[i] := 'x' + sl[i];
    end;
    sl.Sort;

    a[colReq] := '';
    a[colText] := '';
    a[colStock] := '';
    a[colStatus] := '';

    if totReqQty > 0  then
    begin
      validCargo := 0;
      useExtCargo := FSettings.Values['UseExtCargo'] = '1';
      for i := 0 to sl.Count - 1 do
      begin
        s := Copy(sl.Names[i],2,200);

        stock := StrToIntDef(FCargo.Values[LowerCase(s)],0);
        if stock> 0 then validCargo := validCargo + stock;
        if useExtCargo then
          stock := stock + StrToIntDef(FCargoExt.Values[LowerCase(s)],0);

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
          if stock = reqQty then s2 := '■';
          if stock > reqQty then s2 := '▼';
          if stock < reqQty then s2 := '▲';
        except
        end;
        a[colStatus] := a[colStatus] + s2 + Chr(13);
      end;

      if FSettings.Values['ShowUnderCapacity'] <> '0' then
        if (validCargo < FCapacity) and (totDelQty + validCargo < totReqQty) then
        begin
          a[colText] := a[colText] + 'UNDER CAPACITY' + Chr(13);
          a[colStock] := a[colStock] + IntToStr(FCapacity-validCargo) + Chr(13);
          a[colStatus] := a[colStatus] + '--' + Chr(13);
        end;
      if FSettings.Values['ShowProgress'] <> '0' then
        a[colText] := a[colText] + 'Progress: ' + IntToStr((100*totDelQty) div totReqQty) + '%' + Chr(13);
      if FSettings.Values['ShowFlightsLeft'] <> '0' then
        a[colText] := a[colText] + 'Flights left: ' + FloatToStrF((totReqQty-totDelQty)/FCapacity,ffFixed,7,2) +
          ' (' + IntToStr(FCapacity) + 't)' + Chr(13);
      if FMarket.Count > 0 then
        a[colText] := a[colText] + '□ ' + FMarket.Values['$MarketName'] + Chr(13);
    end;

    TextColLabel.Caption := a[colText];
    ReqQtyColLabel.Caption := a[colReq];
    StockColLabel.Caption := a[colStock];
    StatusColLabel.Caption := a[colStatus];

    if cnames = '' then
      TitleLabel.Caption := '(no active constructions)'
    else
      TitleLabel.Caption := cnames;

    if FSettings.Values['AutoHeight'] <> '0' then
    begin
      sl.Text := a[colText];
      h := TextColLabel.Top +
        TextColLabel.Margins.Top +
        TextColLabel.Canvas.TextHeight('Wq') * sl.Count +
        TextColLabel.Margins.Bottom;
      if self.Height <> h then
      begin
        self.Height := h;
        DividerBottom.Top := self.ClientHeight - 2;
      end;
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
  UpdateConstrDepotFromJrnl;
  SplashForm.Hide;
  UpdTimer.Enabled := True;
end;

procedure TEDCDForm.UpdTimerTimer(Sender: TObject);
begin
  UpdateConstrDepotFromJrnl;
end;

procedure TEDCDForm.SaveSettings;
begin
  try FSettings.SaveToFile(FWorkingDir + 'EDConstrDepot.ini');  except end;
end;

procedure TEDCDForm.SwitchDepotMenuItemClick(Sender: TObject);
var cd: TConstructionDepot;
    i: Integer;
begin
  if TMenuItem(Sender).Tag >= FConstructions.Count then Exit;
  if TMenuItem(Sender).Tag = -1 then
  begin
    for i := 0 to FConstructions.Count - 1 do
      TConstructionDepot(FConstructions.Objects[i]).Active := False;
  end
  else
  begin
    cd := TConstructionDepot(FConstructions.Objects[TMenuItem(Sender).Tag]);
    cd.Active := not cd.Active;
  end;
  UpdateConstrDepotFromJrnl;
end;

procedure TEDCDForm.LoadSettings;
var i,fs: Integer;
    s: string;
    fn: TFontName;
    c: TColor;
begin
  try
    FSettings.LoadFromFile(FWorkingDir + 'EDConstrDepot.ini');
    FCapacity := StrToIntDef(FSettings.Values['Capacity'],cDefaultCapacity);
    if FCapacity <= 0 then FCapacity := 9999;
    try
      s := FSettings.Values['Color'];
      s := Copy(s,5,2) + Copy(s,3,2) + Copy(s,1,2);
      c := TColor(StrToInt('$' + s));
      TitleLabel.Font.Color := c;
      TextColLabel.Font.Color := c;
      DividerTop.Pen.Color := c;
      DividerBottom.Pen.Color := c;
    except
    end;
    try
      fn := FSettings.Values['FontName'];
      if fn = '' then fn := TitleLabel.Font.Name;
      fs := StrToIntDef(FSettings.Values['FontSize'],TitleLabel.Font.Size);
      //ParentFont is of no use as it applies all font atrributes
      for i := 0 to self.ControlCount - 1 do
        if self.Controls[i] is TLabel then
          with TLabel(self.Controls[i]) do
          begin
            Font.Size := fs;
            Font.Name := fn;
          end;
    except
    end;
    try
      self.Left := StrToInt(FSettings.Values['Left']);
      self.Top := StrToInt(FSettings.Values['Top']);
    except
    end;
    if FSettings.Values['ShowDividers'] = '0' then
    begin
      DividerTop.Visible := False;
      DividerBottom.Visible := False;
    end;
    if FSettings.Values['ShowCloseBox'] = '0' then
      CloseLabel.Visible := False;
    if FSettings.Values['AlwaysOnTop'] = '0' then
      self.FormStyle := fsNormal;
    if FSettings.Values['Backdrop'] = '1' then
      self.TransparentColor := False;
  except
  end;
end;

procedure TEDCDForm.MinimizeMenuItemClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TEDCDForm.PopupMenuPopup(Sender: TObject);
var
  i: Integer;
  mitem: TMenuItem;
  cd: TConstructionDepot;
  activef: Boolean;
  s: string;
begin
  SelectDepotSubMenu.Clear;
  activef := False;
  for i := 0 to FConstructions.Count - 1 do
  begin
    cd := TConstructionDepot(FConstructions.Objects[i]);
    if cd.Status = '' then continue; //docked but no depot info?
    
    mitem := TMenuItem.Create(SelectDepotSubMenu);
    mitem.Caption := cd.StationName + '/' + cd.StarSystem;
    s := FMarketComments.Values[cd.MarketID];
    if s <> '' then
      mitem.Caption := mitem.Caption + ' (' + Copy(s,1,20) + ')';
    mitem.Tag := i;
    mitem.OnClick := SwitchDepotMenuItemClick;
    mitem.AutoCheck := true;
    mitem.Checked := cd.Active;
    activef := activef or cd.Active;

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
end;

procedure TEDCDForm.ExitMenuItemClick(Sender: TObject);
begin
  self.Close;
end;

procedure TEDCDForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FSettings.Values['Left'] := IntToStr(self.Left);
  FSettings.Values['Top'] := IntToStr(self.Top);
  SaveSettings;
end;

procedure TEDCDForm.FormCreate(Sender: TObject);
var s: string;
begin
  FWorkingDir := GetCurrentDir + '\';

  self.Left := Screen.Width - self.Width;
  self.Top := (Screen.Height - self.Height) div 2;
  FMarket := TStringList.Create;
  FCargo := TStringList.Create;
  FCargoExt := TStringList.Create;
  FFileDates := TStringList.Create;
  FSettings := TStringList.Create;
  FConstructions := TStringList.Create;
  FMarketComments := TStringList.Create;

  try FMarketComments.LoadFromFile(FWorkingDir + 'market_info.txt') except end;

  LoadSettings;

  FJournalDir := System.SysUtils.GetEnvironmentVariable('USERPROFILE') +
       '\Saved Games\Frontier Developments\Elite Dangerous\';
  if FSettings.Values['JournalDir'] <> '' then
    FJournalDir := FSettings.Values['JournalDir'];
  SetCurrentDir(FJournalDir);
  FJournalDir :=  GetCurrentDir + '\';

  FMarketJSON := FJournalDir + 'market.json';
  FCargoJSON := FJournalDir + 'cargo.json';
  FModuleInfoJSON := FJournalDir + 'modulesinfo.json';
  FCargoExtJSON := FWorkingDir + 'market_cargoext.json';

  Application.OnActivate :=  FormActivate;
  Application.OnDeactivate :=  FormDeactivate;

end;

procedure TEDCDForm.FormActivate(Sender: TObject);
begin
  with TitleLabel do
  begin
    Font := CloseLabel.Font;
    Color := CloseLabel.Color;
  end;
end;

procedure TEDCDForm.FormDeactivate(Sender: TObject);
begin
  with TitleLabel do
  begin
    Font := TextColLabel.Font;
    Color := TextColLabel.Color;
  end;
end;

end.
