unit StarMap;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, DataSource, System.Types, System.Math,
  Vcl.StdCtrls, Vcl.Menus, Vcl.Imaging.pngimage, System.StrUtils;

type
  TStarSystemLabel = record
    sys: TStarSystem;
    labelRect: TRect;
    starRect: TRect;
    overlaps: Integer;
  end;

  TMapPos = record
    X: Extended;
    Y: Extended;
  end;

type
  TStarMapForm = class(TForm, IEDDataListener)
    Panel1: TPanel;
    PopupMenu: TPopupMenu;
    SystemInfoMenuItem: TMenuItem;
    MapKeySubMenu: TMenuItem;
    N1: TMenuItem;
    MapKeyClearMenuItem: TMenuItem;
    MapKey1MenuItem: TMenuItem;
    MapKey2MenuItem: TMenuItem;
    MapKey3MenuItem: TMenuItem;
    N2: TMenuItem;
    CopySystemNameMenuItem: TMenuItem;
    MapKey4MenuItem: TMenuItem;
    MapKey5MenuItem: TMenuItem;
    PaintBox: TPaintBox;
    HistTimer: TTimer;
    InnerPanel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ProjectionXCombo: TComboBox;
    ProjectionYCombo: TComboBox;
    MajorColCheck: TCheckBox;
    MinorColCheck: TCheckBox;
    TargetsCheck: TCheckBox;
    OtherSysCheck: TCheckBox;
    MinPopCombo: TComboBox;
    InnerPanel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    TaskGroupCombo: TComboBox;
    InfoCombo: TComboBox;
    LinkStyleCombo: TComboBox;
    ElevationCheck: TCheckBox;
    MapKey6MenuItem: TMenuItem;
    ElevFollowSelCheck: TCheckBox;
    ShowInListMenuItem: TMenuItem;
    ColonModeCheck: TCheckBox;
    ColonizationSubMenu: TMenuItem;
    AddNeighboursEDSMMenuItem: TMenuItem;
    Add2HopSystemsEDSMMenuItem: TMenuItem;
    N3: TMenuItem;
    AddToTargetsMenuItem: TMenuItem;
    StartRouteMenuItem: TMenuItem;
    RouteSubMenu: TMenuItem;
    StopRouteMenuItem: TMenuItem;
    ClearRouteMenuItem: TMenuItem;
    N4: TMenuItem;
    HideDistancesMenuItem: TMenuItem;
    FindSystemMenuItem: TMenuItem;
    FindBodiesMenuItem: TMenuItem;
    AddSystemsMenuItem: TMenuItem;
    procedure PaintBoxPaint(Sender: TObject);
    procedure PaintBoxDblClick(Sender: TObject);
    procedure ProjectionXComboChange(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure MajorColCheckClick(Sender: TObject);
    procedure MinPopComboChange(Sender: TObject);
    procedure PaintBoxClick(Sender: TObject);
    procedure TaskGroupComboChange(Sender: TObject);
    procedure ClusterLinesCheckClick(Sender: TObject);
    procedure MapKey1MenuItemClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure CopySystemNameMenuItemClick(Sender: TObject);
    procedure LinkStyleComboChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HistTimerTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure ElevationCheckClick(Sender: TObject);
    procedure ShowInListMenuItemClick(Sender: TObject);
    procedure ColonModeCheckClick(Sender: TObject);
    procedure AddNeighboursEDSMMenuItemClick(Sender: TObject);
    procedure Add2HopSystemsEDSMMenuItemClick(Sender: TObject);
    procedure AddToTargetsMenuItemClick(Sender: TObject);
    procedure StartRouteMenuItemClick(Sender: TObject);
    procedure StopRouteMenuItemClick(Sender: TObject);
    procedure DeleteRouteMenuItemClick(Sender: TObject);
    procedure ClearRouteMenuItemClick(Sender: TObject);
    procedure HideDistancesMenuItemClick(Sender: TObject);
    procedure FindSystemMenuItemClick(Sender: TObject);
    procedure FindBodiesMenuItemClick(Sender: TObject);
    procedure AddSystemsMenuItemClick(Sender: TObject);
  private
    { Private declarations }
    FShowNeighbours: Boolean;
    FHideDistances: Boolean;
    FCenterOnSelected: Boolean;
    FMap: TBitmap;
    FMapSpan: TRect; //in light years
    FOrigin: TPoint; //distance from LeftTop of current colon. area in pixels, for panning
    FSavedOrigin: TPoint;
    FStartPanPos: TPoint;
    FMapZoom: Integer;
    sysPosArr: array of TStarSystemLabel;
    FStarSystems: TSystemList;
    FNeighbours: TSystemList;
    FConnectors: TSystemList;
    FColonies: TSystemList;
    FRoute: TSystemList;
    FRouteName: string;
    FHistory: TSystemList;
    FHistoryEntry: Integer;
    FHistTimerPaused: Boolean;
    FSelectedSystem: TStarSystem;
    FPreviewRect: TRect;
    function InfoLayer: string;
    procedure UpdateItems;
    procedure UpdateMap(const autoCenter: Boolean = false; const centerOnSelected: Boolean = false);
    procedure ResetMap;
    procedure UpdateOpts;
    procedure SetRouteMenuItemClick(Sender: TObject);
    procedure SaveRouteMenuItemClick(Sender: TObject);
  public
    { Public declarations }
    procedure OnEDDataUpdate;
    procedure OnChangeSettings;
    procedure SelectSystem(sys: TStarSystem);
    procedure RestoreAndShow;
  end;

var
  StarMapForm: TStarMapForm;

implementation

{$R *.dfm}

uses SystemInfo, Settings, Clipbrd, SystemPict, Colonies, Main, Bodies;

procedure TStarMapForm.OnEDDataUpdate;
begin
  if Visible then
  begin
    UpdateItems;
    UpdateMap;
    PaintBoxPaint(nil);
  end;
end;

procedure TStarMapForm.SelectSystem(sys: TStarSystem);
begin
  FSelectedSystem := sys;
  if Visible then
  begin
    UpdateItems;
    UpdateMap(true,true);
    PaintBoxPaint(nil);
  end
  else
    FCenterOnSelected := True;
end;

procedure TStarMapForm.RestoreAndShow;
begin
  if WindowState = wsMinimized then WindowState := wsNormal;
  Show;
end;

procedure TStarMapForm.ResetMap;
begin
  FOrigin := TPoint.Create(0,0);
  FMapZoom := 100;
  UpdateItems;
  UpdateMap(true,FCenterOnSelected);
  FCenterOnSelected := False;
end;

procedure TStarMapForm.ShowInListMenuItemClick(Sender: TObject);
begin
  if FSelectedSystem = nil then Exit;
  ColoniesForm.SetReferenceSystem(FSelectedSystem,true);
  ColoniesForm.Show;
end;

procedure TStarMapForm.StartRouteMenuItemClick(Sender: TObject);
begin
  DataSrc.CurrentRoute.StartRoute(FRoute);
  EDCDForm.UpdateConstrDepot;
end;

procedure TStarMapForm.StopRouteMenuItemClick(Sender: TObject);
begin
  DataSrc.CurrentRoute.StopRoute;
  EDCDForm.UpdateConstrDepot;
end;

procedure TStarMapForm.FormShow(Sender: TObject);
var sl: TStringList;
begin
  ResetMap;

  sl := TStringList.Create;
  DataSrc.GetUniqueGroups(sl);
  TaskGroupCombo.Items.Assign(sl);
  TaskGroupCombo.Items.Insert(0,'');
  sl.Free;
end;

procedure TStarMapForm.HideDistancesMenuItemClick(Sender: TObject);
begin
  FHideDistances := not FHideDistances;
  UpdateMap;
  PaintBoxPaint(nil);
end;

procedure TStarMapForm.HistTimerTimer(Sender: TObject);
var idx: Integer;
begin
  if FHistTimerPaused then Exit;
  try
    if FHistoryEntry >= FHistory.Count - 1 then
      HistTimer.Enabled := False
    else
    begin
      FHistoryEntry := FHistoryEntry + 1;

      //move the system to end of list so it gets printed last
      if FHistoryEntry < FHistory.Count then
      begin
        idx := FStarSystems.IndexOfObject(FHistory[FHistoryEntry]);
        if idx <> -1 then
          FStarSystems.Move(idx,FStarSystems.Count-1);
      end;
    end;
    UpdateMap;
    PaintBoxPaint(nil);
  except
    HistTimer.Enabled := False;
  end;
end;

function TStarMapForm.InfoLayer: string;
begin
  Result := Trim(RightStr(InfoCombo.Text,6));
end;

procedure TStarMapForm.LinkStyleComboChange(Sender: TObject);
begin
  UpdateMap;
  PaintBoxPaint(nil);
  UpdateOpts;
end;

procedure TStarMapForm.ProjectionXComboChange(Sender: TObject);
begin
  FOrigin := TPoint.Create(0,0);
  FMapZoom := 100;
  UpdateMap(true);
  PaintBoxPaint(nil);
  UpdateOpts;
end;

procedure TStarMapForm.TaskGroupComboChange(Sender: TObject);
begin
  FHistory.Clear;
  FHistoryEntry := 0;
  FHistTimerPaused := False;
  HistTimer.Enabled := False;

  ResetMap;
  PaintBoxPaint(nil);

  if InfoLayer = 'AH' then
    HistTimer.Enabled := True;
end;

procedure TStarMapForm.MajorColCheckClick(Sender: TObject);
begin
  UpdateItems;
  UpdateMap;
  PaintBoxPaint(nil);
end;

procedure TStarMapForm.MapKey1MenuItemClick(Sender: TObject);
begin
  if FSelectedSystem = nil then Exit;
  FSelectedSystem.MapKey := TMenuItem(Sender).Tag;
  FSelectedSystem.Save;
  FSelectedSystem := nil;
  UpdateItems;
  UpdateMap(true);
  PaintBoxPaint(nil);
end;

procedure TStarMapForm.MinPopComboChange(Sender: TObject);
begin
  UpdateItems;
  UpdateMap;
  PaintBoxPaint(nil);
end;

procedure TStarMapForm.ColonModeCheckClick(Sender: TObject);
begin
  FShowNeighbours := not FShowNeighbours;
  UpdateItems;
  UpdateMap(false);
  PaintBoxPaint(nil);
end;

procedure TStarMapForm.Add2HopSystemsEDSMMenuItemClick(Sender: TObject);
var cnt: Integer;
begin
  if FSelectedSystem = nil then Exit;
  cnt := DataSrc.StarSystems.AddNeighbours2_EDSM(FSelectedSystem);
  ShowMessage('EDSM query successful, ' + IntToStr(cnt) + ' systems added.');
  if cnt > 0 then
  begin
    UpdateItems;
    if ColoniesForm.Visible then ColoniesForm.UpdateItems;
  end;
end;

procedure TStarMapForm.AddNeighboursEDSMMenuItemClick(Sender: TObject);
var cnt: Integer;
begin
  if FSelectedSystem = nil then Exit;
  cnt := DataSrc.StarSystems.AddNeighbours_EDSM(FSelectedSystem.StarSystem);
  ShowMessage('EDSM query successful, ' + IntToStr(cnt) + ' new systems added.');
  if cnt > 0 then
  begin
    UpdateItems;
    if ColoniesForm.Visible then ColoniesForm.UpdateItems;
  end;
end;

procedure TStarMapForm.AddSystemsMenuItemClick(Sender: TObject);
var sl: TStringList;
    s: string;
    i: Integer;
begin
  if Vcl.Dialogs.MessageDlg('Add all systems in clipboard?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  sl := TStringList.Create;
  sl.Text := Clipboard.AsText;
  for i := 0 to sl.Count - 1 do
  begin
    s := Trim(sl[i]);
    if s <> '' then
    begin
      if DataSrc.StarSystems.AddSystem_EDSM(s) then Sleep(1000);
    end;

  end;
  sl.Free;
//  Exit;


  for i := 0 to DataSrc.StarSystems.Count - 1 do
    if DataSrc.StarSystems[i].SystemScan_EDSM = '' then
    if not DataSrc.StarSystems[i].Ignored then
//    if DataSrc.StarSystems[i].Comment <> '' then
    if DataSrc.StarSystems[i].Architect = '' then
//    if DataSrc.StarSystems[i].Population = 0 then
    begin
      //DataSrc.StarSystems[i].Architect := 'x';
      //DataSrc.StarSystems[i].ArchitectName := 'x';
      DataSrc.StarSystems[i].UpdateBodies_EDSM;
      DataSrc.StarSystems[i].Save;
      Sleep(1000);
    end;

end;

procedure TStarMapForm.AddToTargetsMenuItemClick(Sender: TObject);
begin
  if FSelectedSystem = nil then Exit;
  if FSelectedSystem.Architect = '' then
  begin
    FSelectedSystem.Architect := '(target)';
    FSelectedSystem.UpdateSave;
    //UpdateMap;
    //PaintBoxPaint(nil);
  end;
end;

procedure TStarMapForm.ClearRouteMenuItemClick(Sender: TObject);
begin
  FRoute.Clear;
  UpdateMap;
  PaintBoxPaint(nil);
end;

procedure TStarMapForm.ClusterLinesCheckClick(Sender: TObject);
begin
  UpdateMap;
  PaintBoxPaint(nil);
end;

procedure TStarMapForm.CopySystemNameMenuItemClick(Sender: TObject);
begin
  if FSelectedSystem = nil then Exit;
  Clipboard.AsText := FSelectedSystem.StarSystem;
end;


procedure TStarMapForm.ElevationCheckClick(Sender: TObject);
begin
  UpdateMap;
  PaintBoxPaint(nil);
end;

procedure TStarMapForm.UpdateOpts;
begin
  Opts['MapProjX'] := ProjectionXCombo.Text;
  Opts['MapProjY'] := ProjectionYCombo.Text;
  Opts['MapLanes'] := LinkStyleCombo.Text;
  if WindowState = wsNormal then
  begin
    Opts['Map.Left'] := IntToStr(self.Left);
    Opts['Map.Top'] := IntToStr(self.Top);
    Opts['Map.Height'] := IntToStr(self.Height);
    Opts['Map.Width'] := IntToStr(self.Width);
  end;
end;


procedure TStarMapForm.FindBodiesMenuItemClick(Sender: TObject);
begin
  BodiesForm.UpdateAndShow;
end;

procedure TStarMapForm.FindSystemMenuItemClick(Sender: TObject);
var s: string;
    i: Integer;
    sys: TStarSystem;
begin
  s := LowerCase(Vcl.Dialogs.InputBox('Find System', 'Name', ''));
  sys := nil;
  if s <> '' then
    for i := 0 to DataSrc.StarSystems.Count - 1 do
    begin
      if Pos(s,LowerCase(DataSrc.StarSystems[i].StarSystem)) > 0 then
      begin
        sys := DataSrc.StarSystems[i];
        if s = LowerCase(DataSrc.StarSystems[i].StarSystem) then
          break;
      end;
      if Pos(s,LowerCase(DataSrc.StarSystems[i].AlterName)) > 0 then
      begin
        sys := DataSrc.StarSystems[i];
        if s = LowerCase(DataSrc.StarSystems[i].AlterName) then
          break;
      end;
    end;
  if sys <> nil then
    SelectSystem(sys);
end;

procedure TStarMapForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UpdateOpts;
  HistTimer.Enabled := False;
end;

procedure TStarMapForm.OnChangeSettings;
begin
  ShowInTaskBar := Opts.Flags['ShowInTaskbar'];
  if Visible then
  begin
    UpdateMap;
    PaintBoxPaint(nil);
  end;
end;

procedure TStarMapForm.FormCreate(Sender: TObject);
begin
  ShowInTaskBar := Opts.Flags['ShowInTaskbar'];
  DataSrc.AddListener(self);

  self.Width := StrToIntDef(Opts['Map.Width'],self.Width);
  self.Height := StrToIntDef(Opts['Map.Height'],self.Height);
  self.Left := StrToIntDef(Opts['Map.Left'],(Screen.Width - self.Width) div 2);
  self.Top := StrToIntDef(Opts['Map.Top'],(Screen.Height - self.Height) div 2);

  FMapZoom := 100;
  FOrigin := TPoint.Create(0,0);
  ProjectionXCombo.ItemIndex := ProjectionXCombo.Items.IndexOf(Opts['MapProjX']);
  ProjectionYCombo.ItemIndex := ProjectionYCombo.Items.IndexOf(Opts['MapProjY']);
  LinkStyleCombo.ItemIndex := LinkStyleCombo.Items.IndexOf(Opts['MapLanes']);
  if LinkStyleCombo.ItemIndex = -1 then LinkStyleCombo.ItemIndex := 0;
  
  InfoCombo.ItemIndex := 0;
  FStarSystems := TSystemList.Create;
  FColonies := TSystemList.Create;
  FNeighbours := TSystemList.Create;
  FConnectors := TSystemList.Create;
  FRoute := TSystemList.Create;
  FRoute.StrictDelimiter := True;
  FHistory := TSystemList.Create;
  FHistoryEntry := 0;
  FMap := TBitmap.Create;
end;

procedure TStarMapForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if self.ActiveControl = nil then
  if Key = ' ' then
    if InfoLayer = 'AH' then
    begin
      FHistTimerPaused := not FHistTimerPaused;
      if FHistoryEntry >= FHistory.Count - 1 then
        FHistoryEntry := 0;
    end;
end;

procedure TStarMapForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var pt: TPoint;
    zoomStep: Integer;
begin
  pt := PaintBox.ScreenToClient(MousePos);
  zoomStep := WheelDelta div 60;
  FMapZoom := Min(Max(FMapZoom + zoomStep,5),1000); //5%-1000% of initial view

    FOrigin.X := FOrigin.X  + (Width div 2 * zoomStep) div 100;
    FOrigin.Y := FOrigin.Y  + (Height div 2 * zoomStep) div 100;

  UpdateMap;
  PaintBoxPaint(nil);
end;

procedure TStarMapForm.FormResize(Sender: TObject);
begin
  if Width < (InnerPanel1.Width + ElevationCheck.Left + ElevationCheck.Width) then
  begin
    Panel1.Height := InnerPanel1.Height * 2;
    InnerPanel2.Left := 0;
    InnerPanel2.Top := InnerPanel1.Height;
  end
  else
  begin
    Panel1.Height := InnerPanel1.Height;
    InnerPanel2.Left := InnerPanel1.Width;
    InnerPanel2.Top := 0;
  end;
end;

procedure TStarMapForm.PaintBoxClick(Sender: TObject);
var i: Integer;
    pt: TPoint;
begin
  self.ActiveControl := nil;

  pt := Mouse.CursorPos;

  if FStartPanPos.X <> -1 then
    if (Abs(FStartPanPos.X-pt.X) > 10) or (Abs(FStartPanPos.Y-pt.Y) > 10) then Exit;

  pt := PaintBox.ScreenToClient(pt);

  if FPreviewRect.Left <> 0 then
    if PtInRect(FPreviewRect,pt) then Exit;

  if not (GetKeyState(VK_SHIFT) < 0) then
  begin
    if not DataSrc.CurrentRoute.Active and (FRouteName = '') then
    begin
      FRoute.Clear;
      FRouteName := '';
    end;
  end else
    if FSelectedSystem <> nil then
      if FRoute.Count = 0 then
        FRoute.AddObject(FSelectedSystem.StarSystem,FSelectedSystem);

  for i := 0 to High(sysPosArr) do
    if PtInRect(sysPosArr[i].labelRect,pt) or PtInRect(sysPosArr[i].starRect,pt) then
    begin
       if GetKeyState(VK_SHIFT) < 0 then
         if FRoute.IndexOf(sysPosArr[i].sys.StarSystem) > -1 then
           FRoute.RemoveFromName(sysPosArr[i].sys.StarSystem,false)
         else
           FRoute.AddObject(sysPosArr[i].sys.StarSystem,sysPosArr[i].sys);
       if FSelectedSystem <> sysPosArr[i].sys then
       begin
         FSelectedSystem := sysPosArr[i].sys;
         if FShowNeighbours then
           UpdateItems;
       end;
       UpdateMap;
       PaintBoxPaint(nil);
       Exit;
    end;

  if FSelectedSystem <> nil then
  begin
    FSelectedSystem := nil;
    UpdateMap;
    PaintBoxPaint(nil);
  end;
end;

procedure TStarMapForm.PaintBoxDblClick(Sender: TObject);
var i: Integer;
    pt: TPoint;
begin
  if FSelectedSystem = nil then Exit;

  pt := Mouse.CursorPos;
  pt := PaintBox.ScreenToClient(pt);
  if FPreviewRect.Left <> 0 then
    if PtInRect(FPreviewRect,pt) then
    begin
      SystemPictForm.SetSystem(FSelectedSystem.StarSystem);
      SystemPictForm.Show;
      Exit;
    end;

  SystemInfoForm.SetSystem(FSelectedSystem);
  if InfoCombo.ItemIndex > 0 then
  with SystemInfoForm do
  begin
    BeginFilterChange;
    FiltersCheck.Checked := True;
    try
      if (InfoLayer = 'C1') or (InfoLayer = 'C2') then
      begin
        if FSelectedSystem.Constructions <> nil then
          if FSelectedSystem.Constructions.Count > 0 then
          begin
            BodiesCheck.Checked := False;
            FinishedCheck.Checked := False;
          end;
      end;
      if InfoLayer = 'LR' then FilterEdit.Text := 'Refi ';
      if InfoLayer = 'LA' then FilterEdit.Text := 'Agri ';
      if InfoLayer = 'SY' then FilterEdit.Text := '🚀';
    finally
      EndFilterChange;
      UpdateView;
    end;
  end;
  SystemInfoForm.RestoreAndShow;
end;

procedure TStarMapForm.PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FStartPanPos := Mouse.CursorPos;
  FSavedOrigin := FOrigin;
end;

procedure TStarMapForm.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var pt: TPoint;
begin
  if ((ssLeft in Shift) or (ssMiddle in Shift)) and (FStartPanPos.X > 0) then
  begin
    pt := Mouse.CursorPos;
    if (Abs(pt.X-FStartPanPos.X) > 5) or (Abs(pt.X-FStartPanPos.Y) > 5) then
    begin
      FOrigin.X := FSavedOrigin.X - (pt.X - FStartPanPos.X);
      FOrigin.Y := FSavedOrigin.Y - (pt.Y - FStartPanPos.Y);
      //PaintBox.Invalidate;
      //PaintBox.Update;
      UpdateMap;
      PaintBoxPaint(nil);
    end;
  end;
end;

procedure TStarMapForm.PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FStartPanPos.X := -1;
  //todo: change to test if a label was actually right-clicked
  if not ColonModeCheck.Checked and (FRoute.Count = 0) then
    if Button = mbRight then PaintBoxClick(nil);
end;

procedure TStarMapForm.UpdateItems;
var i,i2: Integer;
    sys: TStarSystem;
    minPop: Integer;
    s,s2: string;
    okf,isColonyf: Boolean;
begin
  FStarSystems.Clear;
  FColonies.Clear;
  FNeighbours.Clear;
  FConnectors.Clear;

  s := MinPopCombo.Text;
  s := s.Replace(' ','');
  s := s.Replace(',','');
  minPop := StrToIntDef(s.Replace(' ',''),1000000);
  for i := 0 to DataSrc.StarSystems.Count - 1 do
  begin
    sys := DataSrc.StarSystems[i];

    okf := true;
    isColonyf := (sys.Architect <> '') and (sys.PrimaryDone or (sys.Population > 0));

    if not MajorColCheck.Checked then
      if isColonyf and (sys.Population >= 1000000) then okf := false;
    if not MinorColCheck.Checked then
      if isColonyf and (sys.Population < 1000000) then okf := false;
    if not TargetsCheck.Checked then
      if (sys.Architect <> '') and not isColonyf then okf := false;

    if not OtherSysCheck.Checked then
      if sys.Architect = '' then okf := false;

    if OtherSysCheck.Checked then
      if (sys.Architect = '') then
        if(sys.Population < minPop) and (sys.CurrentGoals = '') then okf := false;

    if sys.Ignored then isColonyf := False;

    if FShowNeighbours then
      if FSelectedSystem <> nil then
        if (FSelectedSystem.Population = 0) or (sys.Population = 0) then
        if sys.DistanceTo(FSelectedSystem) <= 15 then
        begin
          FNeighbours.AddObject('',sys);
          if (sys.Population > 0) or (sys.Architect <> '') then
            FSelectedSystem.NearestColony := sys;
          okf := true;
        end;

    if sys = FSelectedSystem then
      okf := true;

    if not okf then
      if FRoute.IndexOfObject(sys) > -1 then okf := true;
      


    if TaskGroupCombo.Text <> '' then
//    if sys.TaskGroup <> '' then
         if Pos(TaskGroupCombo.Text,sys.TaskGroup) > 0  then
         begin
           okf := True;
           isColonyf := True; //include all system in Task Group in colony span calculation
         end;


    if okf then
    begin
      //sort colonies as last to bring their labels to front
      s := '0';
      if isColonyf then s := '1';
      if sys.CurrentGoals <> '' then s := '2';
      if sys.MapKey > 0 then s:= '3';

      FStarSystems.AddObject(s + sys.StarSystem,sys);

      if sys.Constructions = nil then
        sys.Constructions := TList.Create
      else
        sys.Constructions.Clear;

      if isColonyf then
      begin
//        if sys.TaskGroup <> '' then
          if TaskGroupCombo.Text <> '' then
             if Pos(TaskGroupCombo.Text,sys.TaskGroup) <= 0  then continue;
        s := '0';
        if sys.MapKey > 0 then s := '1';
        s := s + sys.Population.ToString.PadLeft(12);
        FColonies.AddObject(s,sys);
      end;
    end;
  end;
  FStarSystems.Sort;
  FColonies.Sort;
  if DataSrc.CurrentSystem <> nil then
  begin
    if FStarSystems.IndexOfObject(DataSrc.CurrentSystem) = -1 then
      FStarSystems.AddObject('$current',DataSrc.CurrentSystem);
    if FColonies.Count = 0 then
      FColonies.AddObject('',DataSrc.CurrentSystem);
  end;

  //if InfoCombo.ItemIndex > 0 then
  DataSrc.UpdateSystemStations;

  if (InfoLayer = 'AH') and not HistTimer.Enabled then
  begin
    FHistory.Clear;
    for i := 0 to FColonies.Count -1 do
    begin
      s := FColonies[i].ClaimDate;
      if FSelectedSystem <> nil then
        if s < FSelectedSystem.ClaimDate then continue;

      if s <> '' then
        FHistory.AddObject(s.PadRight(30,' ') + ' 🏆  Claimed',FColonies[i]);

      for i2 := 0 to FColonies[i].Constructions.Count - 1 do
        with TConstructionDepot(FColonies[i].Constructions[i2]) do
        begin
          if LastUpdate <> '' then
            if (s = '') or (LastUpdate < s) then s := LastUpdate;
          if Finished and (Status <> '') then
            if ActualHaul > Opts.Int['MinHistHaul'] then
            begin
              s2 := LastUpdate.PadRight(30,' ') + ' 🏗  ';
              if GetLinkedMarket <> nil then
                s2 := s2 + GetLinkedMarket.StationName
              else
                s2 := s2 + StationName;
              if GetConstrType <> nil then
                s2 := s2 + ' (' + GetConstrType.StationType + ')';
              FHistory.AddObject(s2,FColonies[i]);
            end;
{
          if Finished and (Status <> '') and (GetConstrType <> nil) then
            if GetConstrType.IsPort then
              FHistory.AddObject(LastUpdate.PadRight(30,' ') + ' 🏗  ' + GetConstrType.StationType,FColonies[i]);
}
        end;

      //if (FColonies[i].ClaimDate = '') and (s <> '') then
      //  FHistory.AddObject(s.PadRight(30,' ') + ' 🏆  (History Start)',FColonies[i]);
    end;
    FHistory.Sort;
  end;

  if FShowNeighbours then
  if FSelectedSystem <> nil then
  if FSelectedSystem.Population = 0 then
  if FSelectedSystem.NearestColony = nil then
  begin
    for i := 0 to FNeighbours.Count -1 do
      if FNeighbours[i].NearestColony <> nil then
        FConnectors.AddObject('',FNeighbours[i])
      else
      for i2 := 0 to FColonies.Count - 1 do
        if FNeighbours[i] <> FColonies[i2] then
          if FNeighbours[i].DistanceTo(FColonies[i2]) <= 15 then
          begin
            FNeighbours[i].NearestColony := FColonies[i2];
            FConnectors.AddObject('',FNeighbours[i]);
          end;
  end;

end;

procedure TStarMapForm.UpdateMap(const autoCenter: Boolean = false; const centerOnSelected: Boolean = false);
var i,i2,i3,w,idx,si,margin,projectionX,projectionY,labOffsetX,labOffsetY,fontSize: Integer;
    sys: TStarSystem;
    sysSpanList: TSystemList;
    r,r2,unir: TRect;
    pt,pt2: TPoint;
    proj: TMapPos;
    linkRects: array [0..100] of TRect;
    linkRectsCnt: Integer;
    maxSize,minPop,maxLinks,maxLinkCnt,curLinkCnt,maxDist,radius: Integer;
    dt: TDateTime;
    PixelsPerLy,dist,totDist,dDt: Extended;
    starSymbol,s,laneStyle: string;
    okf,isColonyf: Boolean;
    cnt1,cnt2,cnt3: Integer;
    png: TPngImage;
    selSysIdx: Integer;
    minY,maxY,midY: Integer;
    elevationf: Boolean;
    othernamesf: Integer;
label
    LSkipLabelReposition,LSkipLabelPrint;

    procedure setMin(var mapSpanVal: Integer; starPos: Extended);
    begin
      if (mapSpanVal = 0) or (starPos < mapSpanVal) then
        mapSpanVal := Trunc(starPos);
    end;

    procedure setMax(var mapSpanVal: Integer; starPos: Extended);
    begin
      if (mapSpanVal = 0) or (starPos > mapSpanVal) then
        mapSpanVal := Trunc(starPos);
    end;


    procedure getSysPos_projected(sys: TStarSystem; var map: TMapPos);
    begin
      case projectionX of
        0: map.X := sys.StarPosX;
        1: map.X := sys.StarPosY;
        2: map.X := sys.StarPosZ;
        3: map.X := -sys.StarPosX;
        4: map.X := -sys.StarPosY;
        5: map.X := -sys.StarPosZ;
      else
        map.X := sys.StarPosX;
      end;
      case projectionY of //negated, it's more natural for Y to rise from bottom to top
        0: map.Y := -sys.StarPosX;
        1: map.Y := -sys.StarPosY;
        2: map.Y := -sys.StarPosZ;
        3: map.Y := sys.StarPosX;
        4: map.Y := sys.StarPosY;
        5: map.Y := sys.StarPosZ;
      else
        map.Y := sys.StarPosZ;
      end;
    end;

    function fixRect(r: TRect): TRect;
    begin
      Result := r;
      if r.Left > r.Right then
      begin
        Result.Left := r.Right;
        Result.Right := r.Left;
      end;
      if r.Top > r.Bottom then
      begin
        Result.Top := r.Bottom;
        Result.Bottom := r.Top;
      end;
    end;

    function formatHistEntry(s: string): string;
    begin
      Result := (StrToIntDef(Copy(s,1,4),2025)-2025+3311).ToString +
                Copy(s,5,6) + Copy(s,30,100);
    end;

    procedure CalcStarLane(sys1,sys2: TStarSystem; var r: TRect);
    var proj: TMapPos;
        fs: Integer;
    begin
      getSysPos_projected(sys1,proj);
      fs := fontSize;
      if sys1.Architect <> '' then fs := fs + 4;
      r.Left := -FOrigin.X + Trunc(PixelsPerLy*(proj.X - FMapSpan.Left)) + fs div 2;
      r.Top := -FOrigin.Y + Trunc(PixelsPerLy*(proj.Y - FMapSpan.Top)) + fs div 2 + 4;
      if elevationf then
        r.Top := r.Top - Trunc((sys1.StarPosY-midY)*PixelsPerLy/6);

      getSysPos_projected(sys2,proj);
      fs := fontSize;
      if sys2.Architect <> '' then fs := fs + 4;
      r.Right := -FOrigin.X + Trunc(PixelsPerLy*(proj.X - FMapSpan.Left)) + fs div 2;
      r.Bottom := -FOrigin.Y + Trunc(PixelsPerLy*(proj.Y - FMapSpan.Top))+ fs div 2 + 4;
      if elevationf then
        r.Bottom := r.Bottom - Trunc((sys2.StarPosY-midY)*PixelsPerLy/6);
    end;

begin
  //todo (lots of optimization pending):
  // - move map info layer to UpdateItems
  // - move star lanes to UpdateItems
  // - turn off info layers for zoom < 25%
  // - scroll bitmap (no redraw) on map panning ?

  SetLength(sysPosArr,0);
//  ZeroMemory(@mostPops,sizeof(mostPops));
  ZeroMemory(@linkRects,sizeof(linkRects));
  linkRectsCnt := 0;

  minY := 0;
  maxY := 0;
  midY := 0;
  elevationf := ElevationCheck.Checked;
  othernamesf := Opts.Int['ShowSysNames'];

  projectionX := ProjectionXCombo.ItemIndex;
  projectionY := ProjectionYCombo.ItemIndex;

  if autoCenter then
    FMapSpan := Default(TRect);

  FMap.SetSize(PaintBox.Width,PaintBox.Height);
  FMap.Canvas.Font.Assign(PaintBox.Font);
  FMap.Canvas.Brush.Color := $001E150A; //$001A1106
  FMap.Canvas.Brush.Style := bsSolid;
  FMap.Canvas.FillRect(PaintBox.ClientRect);

  with FMap.Canvas do
  begin

    sysSpanList := FColonies;
    if FRouteName <> '' then
      sysSpanList := FRoute;

    if elevationf then
    for i := 0 to sysSpanList.Count - 1 do
    begin
      sys := sysSpanList[i];
      if sys = nil then continue;
      setMin(minY,sys.StarPosY);
      setMax(maxY,sys.StarPosY);
    end;
    midY := (minY + maxY) div 2;

    if autoCenter then
    begin
      for i := 0 to sysSpanList.Count - 1 do
      begin
        sys := sysSpanList[i];
        if sys = nil then continue;
        getSysPos_projected(sys,proj);
        setMin(FMapSpan.Left,proj.X);
        setMax(FMapSpan.Right,proj.X);
        setMin(FMapSpan.Top,proj.Y);
        setMax(FMapSpan.Bottom,proj.Y);
      end;

      //calculate colonization span area, add 10 Ly margins
      FMapSpan.Width := Max(FMapSpan.Right - FMapSpan.Left,10);
      FMapSpan.Height := Max(FMapSpan.Bottom - FMapSpan.Top,10);

      margin := FMapSpan.Width div 10;
      FMapSpan.Left := FMapSpan.Left - margin;
      FMapSpan.Right := FMapSpan.Right + 2*margin; //double right-bottom margins - text get printed in there

      margin := FMapSpan.Height div 10;
      FMapSpan.Top := FMapSpan.Top - margin;
      FMapSpan.Bottom := FMapSpan.Bottom + 2*margin;

      FMapSpan.Width := FMapSpan.Right - FMapSpan.Left;
      FMapSpan.Height := FMapSpan.Bottom - FMapSpan.Top;
    end;

    maxSize := Max(FMapSpan.Width,FMapSpan.Height);
    PixelsPerLy := Min(Width,Height) / maxSize;
    PixelsPerLy := PixelsPerLy * FMapZoom / 100;

    if autoCenter then
    begin
      FOrigin.X := -(Width - Trunc(PixelsPerLy * FMapSpan.Width)) div 2;
      FOrigin.Y := -(Height - Trunc(PixelsPerLy * FMapSpan.Height)) div 2;

      if centerOnSelected and (FSelectedSystem <> nil) then
      begin
        getSysPos_projected(FSelectedSystem,proj);
        proj.X := proj.X - (FMapSpan.Left + FMapSpan.Width/2);
        proj.Y := proj.Y - (FMapSpan.Top + FMapSpan.Height/2 );
        FOrigin.X := FOrigin.X + Trunc(PixelsPerLy * proj.X);
        FOrigin.Y := FOrigin.Y + Trunc(PixelsPerLy * proj.Y);
      end;
    end;


    fontSize := Max(6,Min(6 + Trunc(PixelsPerLy/3) {2 * FMapZoom div 50},16));
    labOffsetX := fontSize + 4;
    labOffsetY := fontSize - 2;

    if FSelectedSystem <> nil then
      if ElevFollowSelCheck.Checked or FShowNeighbours then
        midY := Trunc(FSelectedSystem.StarPosY);

    if FMapZoom >= 25 then
    begin
      Pen.Color := $202020;
      Pen.Style := psSolid;
      Pen.Width := 1;
      for i := 0 to Ceil(Height / (10*PixelsPerLy)) do
      begin
        MoveTo(0,Trunc(i * 10*PixelsPerLy));
        LineTo(Width,Trunc(i * 10*PixelsPerLy));
      end;
      for i := 0 to Ceil(Width / (10*PixelsPerLy)) do
      begin
        MoveTo(Trunc(i * 10*PixelsPerLy),0);
        LineTo(Trunc(i * 10*PixelsPerLy),Height);
      end;
    end;



    if InfoLayer = 'PP' then
    begin
      Pen.Color := $303030;
      Pen.Style := psSolid;
      Pen.Width := 1;
      Brush.Style := bsSolid;
      for i := FColonies.Count - 1 downto 0 do    //Max(FColonies.Count - 12,0)
      begin
        if FColonies[i].Population < 1000000 then continue;
        getSysPos_projected(FColonies[i],proj);
        radius := Trunc(Power((FColonies[i].Population  div 100000),1/3)*4);
        radius := Trunc(radius * (FMapZoom/100));
        pt.X := -FOrigin.X + Trunc(PixelsPerLy*(proj.X - FMapSpan.Left)) + fontSize div 2 + 2;
        pt.Y := -FOrigin.Y + Trunc(PixelsPerLy*(proj.Y - FMapSpan.Top)) + fontSize div 2 + 6;
        if elevationf then
          pt.Y := pt.Y - Trunc((FColonies[i].StarPosY-midY)*PixelsPerLy/6);
        if pt.X < -radius then continue;
        if pt.Y < -radius then continue;
        if pt.X > FMap.Width + radius then continue;
        if pt.Y > FMap.Height + radius then continue;
        r.Left := pt.X - radius;
        r.Right := pt.X + radius;
        r.Top := pt.Y - radius;
        r.Bottom := pt.Y + radius;
        Brush.Color := $402000 + 32*(i mod 2);
        Ellipse(r);
      end;
      Brush.Style := bsClear;
    end;

    laneStyle := LinkStyleCombo.Text;
    if laneStyle = '' then laneStyle := 'A';
    if laneStyle <> 'off' then
    begin
      maxLinks := 50;

      //Star lanes styles
      //Most populated and highlighted system are favored
      //A: lanes from one system in different directions are preferred
      //B: maximum lanes from most populated (or highlighted) systems
      //C: lanes from one system in different directions are preferred,
      //   max. 3 links from one system, up to 45 Ly away
      //D: maximum lanes from most populated (or highlighted) systems,
      //   max. 3 links from one system
      //E: maximum lanes from most populated (or highlighted) systems,
      //   max. 5 links from one system, up to 15 Ly away, one link > 15 Ly allowed

      Pen.Color := $808080;
      Pen.Style := psDot;
      Pen.Width := 1;
      maxDist := 30;
      if (laneStyle = 'C') then
        maxDist := 45;

      for i := FColonies.Count - 1 downto 0 do    //Max(FColonies.Count - 12,0)
      begin
        if InfoLayer = 'AH' then
          if FColonies[i].ClaimDate > FHistory.Strings[FHistoryEntry] then continue;
        if (laneStyle = 'E') then
          maxDist := 45;

        maxLinkCnt := linkRectsCnt;
        curLinkCnt := 0;
        si := i - 1;
        //si := FColonies.Count - 1;
        for i2 := si downto 0 do
        if i <> i2 then
        begin
          dist := FColonies[i].DistanceTo(FColonies[i2]);
          if dist > maxDist then continue;
          if InfoLayer = 'AH' then
            if FColonies[i2].ClaimDate > FHistory.Strings[FHistoryEntry] then continue;

          CalcStarLane(FColonies[i],FColonies[i2],r);
          {
          getSysPos_projected(FColonies[i],proj);
          r.Left := -FOrigin.X + Trunc(PixelsPerLy*(proj.X - FMapSpan.Left)) + (fontSize+4) div 2;
          r.Top := -FOrigin.Y + Trunc(PixelsPerLy*(proj.Y - FMapSpan.Top)) + (fontSize+4) div 2 + 4;
          if elevationf then
            r.Top := r.Top - Trunc((FColonies[i].StarPosY-midY)*PixelsPerLy/6);

          getSysPos_projected(FColonies[i2],proj);
          r.Right := -FOrigin.X + Trunc(PixelsPerLy*(proj.X - FMapSpan.Left)) + (fontSize+4) div 2;
          r.Bottom := -FOrigin.Y + Trunc(PixelsPerLy*(proj.Y - FMapSpan.Top))+ (fontSize+4) div 2 + 4;
          if elevationf then
            r.Bottom := r.Bottom - Trunc((FColonies[i].StarPosY-midY)*PixelsPerLy/6);
          }
          r2 := fixRect(r);
          i3 := 0;

          if (laneStyle = 'A') or (laneStyle = 'C') then maxLinkCnt := linkRectsCnt;
          //maxLinkCnt not set to current link count excludes star lanes from very same star
          //as these never cross each other
          while i3 < maxLinkCnt do
          begin
            if IntersectRect(r2,linkRects[i3]) then
            begin
              i3 := -1;
              break;
            end;
            i3 := i3 + 1;
          end;
          if i3 = -1 then continue;

          linkRects[linkRectsCnt] := r2;
          Inc(linkRectsCnt);
          Inc(curLinkCnt);

          MoveTo(r.Left,r.Top);
          LineTo(r.Right,r.Bottom);

          if (laneStyle = 'C') or (laneStyle = 'D') then
            if curLinkCnt > 2 then break;
          if (laneStyle = 'E') then
            if curLinkCnt > 4 then break;
          if (laneStyle = 'E') then
            if dist > 15 then
              maxDist := 15;

          if linkRectsCnt > maxLinks then break;

        end;
        if linkRectsCnt > maxLinks then break;
      end;
    end;

    if FShowNeighbours and (FNeighbours.Count > 0) and (FSelectedSystem <> nil) then
    begin
      Pen.Style := psDot;
      for i := 0 to FNeighbours.Count - 1 do
      begin
//        dist := FNeighbours[i2].DistanceTo(FConnectors[i]);
//        if dist > 15 then continue;
        CalcStarLane(FNeighbours[i],FSelectedSystem,r);
        Pen.Color := $00C000;
        Pen.Width := 1;
        if (FNeighbours[i].Architect <> '') or (FNeighbours[i].Population > 0) then
          Pen.Width := 2
        else
          if FNeighbours[i].Ignored then
            Pen.Color := $404040
          else
            if (FNeighbours[i].LastUpdate = '') or
               (FNeighbours[i].Comment = '') or
               (FSelectedSystem.LastUpdate = '') then
              Pen.Color := clYellow;

        MoveTo(r.Left,r.Top);
        LineTo(r.Right,r.Bottom);
      end;

      for i := 0 to FConnectors.Count - 1 do
      begin
        CalcStarLane(FConnectors[i],FConnectors[i].NearestColony,r);
        Pen.Color := $00C000;
        Pen.Width := 2;
        MoveTo(r.Left,r.Top);
        LineTo(r.Right,r.Bottom);
      end;

    end;


    s := MinPopCombo.Text;
    s := s.Replace(' ','');
    s := s.Replace(',','');
    selSysIdx := -1;
    minPop := StrToIntDef(s.Replace(' ',''),1000000);


    //add selected system to end of list to make sure its printed on top
    FStarSystems.RemoveFromName('$selected',false);
    if FSelectedSystem <> nil then
      FStarSystems.AddObject('$selected',FSelectedSystem);

    for i := 0 to FStarSystems.Count - 1 do
    begin
      sys := FStarSystems[i];

      if True then
      begin
        idx := High(sysPosArr) + 1;
        SetLength(sysPosArr,idx+1);
        sysPosArr[idx].sys := sys;
        sysPosArr[idx].overlaps := 0;

        //reprint selected system on top of map
        if FStarSystems.Strings[i] = '$selected' then
        begin
          if selSysIdx = -1 then continue;
          r := sysPosArr[selSysIdx].labelRect;
          goto LSkipLabelReposition;
        end;

        if sys = FSelectedSystem then selSysIdx := idx;


        getSysPos_projected(sys,proj);
        pt.X := -FOrigin.X + Trunc(PixelsPerLy*(proj.X - FMapSpan.Left));
        pt.Y := -FOrigin.Y + Trunc(PixelsPerLy*(proj.Y - FMapSpan.Top));

        if elevationf then
          pt.Y := pt.Y - Trunc((sys.StarPosY-midY)*PixelsPerLy/6);

        if pt.X < -100 then continue;
        if pt.Y < -20 then continue;
        if pt.X > FMap.Width then continue;
        if pt.Y > FMap.Height then continue;

        Brush.Style := bsClear;
        Font.Style := [];

        //colonies
        starSymbol := '✧';
        if sys.Population > 1000000 then
          starSymbol := '✦';
        Font.Size := fontSize + 4; //default star size is somewhat small

        //if sys.Population > 100000000 then
        //  starSymbol := '✹';

        //targets
        if (sys.Population = 0) and not sys.PrimaryDone and (sys.Architect <> '') then
          starSymbol := '⛶';

        if (sys.Architect = '') or sys.Ignored then
        begin
          Font.Size := fontSize;
          starSymbol := '○';
          if sys.Population > 0 then
            starSymbol := '●'; //◌ • ●
        end;

        if ((sys.Population = 0) and not sys.PrimaryDone) or (sys.Architect = '') then
          Font.Color := clGray
        else
          Font.Color := clWhite;

        if sys = DataSrc.CurrentSystem then
          Font.Color := clYellow;

        if InfoLayer = 'AH' then
          if sys.ClaimDate > FHistory.Strings[FHistoryEntry] then
            Font.Color := $404040;


        r.Left := pt.X;
        r.Top := pt.Y;
        r.Right := r.Left + TextWidth(starSymbol);
        r.Bottom := r.Top + TextHeight(starSymbol);
        sysPosArr[idx].starRect := r;
        TextOut(pt.X,pt.Y,starSymbol);

        if FRoute.Count > 1 then
        begin
          //Font.Color := clWhite;
          Font.Size := fontSize + 2;
          if sys = FRoute[0] then
            TextOut(pt.X+4,pt.Y-fontSize-4,'🏳');
          if sys = FRoute[FRoute.Count-1] then
            TextOut(pt.X+4,pt.Y-fontSize-4,'🏁');
        end;

        if elevationf then
        if (sys.Architect <> '') or (sys.CurrentGoals <> '') or (sys.TaskGroup <> '') or
         (FNeighbours.IndexOfObject(sys) >= 0) then
        begin
          Pen.Style := psSolid;
          Pen.Width := 1;
          Pen.Color := $00A000;
          if sys.StarPosY < midY then
            Pen.Color := $0000A0;
          r.Left := r.Left + (Font.Size) div 2;
          r.Top := r.Top + (Font.Size) div 2 + 4;
          MoveTo(r.Left,r.Top);
          r.Top := r.Top + Trunc((sys.StarPosY-midY)*PixelsPerLy/6);
          LineTo(r.Left,r.Top);
          Ellipse(r.Left-5,r.Top-3,r.Left+6,r.Top+3);
        end;

        if InfoLayer = 'AH' then
          if sys.ClaimDate > FHistory.Strings[FHistoryEntry] then
            continue;

        if sys <> FSelectedSystem then
        if sys.CurrentGoals = '' then
        if sys.AlterName = '' then
        case othernamesf of
          0: ; //show all names
          1: if not sys.IsOwnColony and (sys.Population < 10000000) then goto LSkipLabelPrint;
          2: if not sys.IsOwnColony then goto LSkipLabelPrint;
        end;


        Font.Size := fontSize;
        pt.X := pt.X + labOffSetX;
        pt.Y := pt.Y + labOffSetY;
        r.Left := pt.X;
        r.Top := pt.Y;
        r.Right := r.Left + TextWidth(sys.StarSystem);
        r.Bottom := r.Top + TextHeight(sys.StarSystem);

        if FMapZoom >= 25 then
        for i2 := 0 to High(sysPosArr) do
          if IntersectRect(unir,r,sysPosArr[i2].labelRect) then
          //move labels only on substantial intersection (min. 2-3 chars and 33% of height)
          if (unir.Width > fontSize * 2) and (unir.Height > fontSize div 3) then
          begin
             Inc(sysPosArr[i2].overlaps);

             //todo: 12 -> fontsize ?
             OffsetRect(r,0,12*sysPosArr[i2].overlaps);
             if IntersectRect(r,sysPosArr[i2].labelRect) then
               OffsetRect(r,0,-24);
             break;
          end;

        sysPosArr[idx].labelRect := r;

LSkipLabelReposition:;
        Font.Size := fontSize;
        Brush.Style := bsSolid;
        case sys.MapKey of
          1: Brush.Color := $505050;
          2: Brush.Color := $23238E;  //clFirebrick
          3: Brush.Color := $0070D0;
          4: Brush.Color := $006000;
          5: Brush.Color := $700000;
          6: Brush.Color := $600060;
        else
          Brush.Style := bsClear;
        end;

        if sys = FSelectedSystem then
        begin
          Brush.Style := bsSolid;
          Brush.Color := clWhite;
          Font.Color := clBlack;
        end;

        s := sys.StarSystem;
        if sys.AlterName <> '' then
          if Opts.Flags['ShowAlterNames'] then s := sys.AlterName;
        TextOut(r.Left,r.Top,s);

LSkipLabelPrint:;
        Pen.Color := $606060;
        s := '';
        // s2 := '';
        if sys.Architect <> '' then
        if sys.Constructions <> nil then
        begin

          if (InfoLayer = 'C1') or (InfoLayer = 'C2') then
          begin
            cnt1 := 0;
            cnt2 := 0;
            for i2 := 0 to sys.Constructions.Count - 1 do
            with TConstructionDepot(sys.Constructions[i2]) do
              if not Finished then
              if not Simulated then
              if GetMarketLevel <> miIgnore then
                if Planned then
                  Inc(cnt2)
                else
                  Inc(cnt1);
            s := '';
            if cnt1 > 0  then s := s + '🚧' + cnt1.ToString + ' ';
            if cnt2 > 0  then s := s + '✏' + cnt2.ToString + ' ';
            if InfoLayer = 'C2' then
              s := s + Copy(sys.CurrentGoals,1,40);

            Font.Color := $00A0FF;
          end;

          if InfoLayer = 'SC' then
          if (sys.Population > 0) or sys.PrimaryDone then
          begin
            cnt1 := sys.GetScore;
            s := '🏆 ' + cnt1.ToString;
            if cnt1 <= 5 then
              Font.Color := $0000A0
            else
            if cnt1 <= 15 then
              Font.Color := $00A0FF
            else
            if cnt1 <= 50 then
              Font.Color := $00C0C0
            else
              Font.Color := $00A000;
          end;

        {
          if InfoLayer = 'MF' then
          if sys.Population > 0 then
          begin
            s := '👥' + sys.GetFactions(true,true);
            Font.Color := $00C000;
            if Pos(';',s) > 0 then
              Font.Color := $00A0A0;
          end;

          if InfoLayer = 'LV' then
          if (sys.Population > 0) or sys.PrimaryDone then
          begin
            try
              dt := StrToDateTime(Copy(sys.LastUpdate,1,10));
              dDt := Now - dt;
              s := '⏳' + IntToStr(Trunc(dDt)) + 'd';
              //Font.Color := $00C000;
              if dDt <= 1  then
                s := '';
              if dDt > 28 then
                Font.Color := $0000A0
              else
              if dDt > 14 then
                Font.Color := $00A0FF
              else
              if dDt > 3 then
                Font.Color := $00C0C0
              else
                Font.Color := $00A000;
            except
            end;
          end;

          if InfoLayer = 'LP' then
          begin
            cnt1 := 0;
            cnt2 := 0;
            cnt3 := 0;
            for i2 := 0 to sys.Stations.Count - 1 do
            with TMarket(sys.Stations[i2]) do
              if LPads > 0 then
                if (Pos('Settl',StationType) <= 0) and (Pos('Carrier',StationType) <= 0) then
                  if IsOrbital then
                  begin
                    if Pos('Asteroid',StationType) > 0 then
                      Inc(cnt2)
                    else
                      Inc(cnt1);
                  end
                  else
                    Inc(cnt3);
            s := '';
            if cnt1 > 0  then s := s + '⚪•' + cnt1.ToString + ' ';
            if cnt2 > 0  then s := s + '🥔' + cnt2.ToString + ' ';
            if cnt3 > 0  then s := s + '🏭' + cnt3.ToString + ' ';
            Font.Color := $00A000;
          end;
}
          if InfoLayer = 'AH' then
          begin
            if FHistoryEntry > 0 then
            if FHistory.Objects[FHistoryEntry-1] = sys then
            begin
              s := formatHistEntry(FHistory.Strings[FHistoryEntry-1]);
              Font.Color := $606060;
              Pen.Color := $404040;
            end;
            if FHistory.Objects[FHistoryEntry] = sys then
            begin
              s := formatHistEntry(FHistory.Strings[FHistoryEntry]);
              Font.Color := $FFFFFF;
            end;
          end;

        end;

        if (sys.Architect <> '') or (sys.TaskGroup <> '') then
        begin
          if InfoLayer = 'MF' then
          if sys.Population > 0 then
          begin
            s := '👥' + sys.GetFactions(true,true);
            Font.Color := $00C000;
            if Pos(';',s) > 0 then
              Font.Color := $00A0A0;
          end;

          if InfoLayer = 'LV' then
          if (sys.Population > 0) or sys.PrimaryDone then
          begin
            try
              dt := StrToDateTime(Copy(sys.LastUpdate,1,10));
              dDt := Now - dt;
              s := '⏳' + IntToStr(Trunc(dDt)) + 'd';
              //Font.Color := $00C000;
              if dDt <= 1  then
                s := '';
              if dDt > 28 then
                Font.Color := $0000A0
              else
              if dDt > 14 then
                Font.Color := $00A0FF
              else
              if dDt > 3 then
                Font.Color := $00C0C0
              else
                Font.Color := $00A000;
            except
            end;
          end;

          if InfoLayer = 'LP' then
          begin
            cnt1 := 0;
            cnt2 := 0;
            cnt3 := 0;
            for i2 := 0 to sys.Stations.Count - 1 do
            with TMarket(sys.Stations[i2]) do
              if LPads > 0 then
                if (Pos('Settl',StationType) <= 0) and (Pos('Carrier',StationType) <= 0) then
                  if IsOrbital then
                  begin
                    //this is not perfect for asteroid bases, these are marked as SurfaceStation until weekly tick
                    if Pos('Asteroid',StationType) > 0 then
                      Inc(cnt2)
                    else
                      Inc(cnt1);
                  end
                  else
                    Inc(cnt3);
            s := '';
            if cnt1 > 0  then s := s + '⚪•' + cnt1.ToString + ' ';
            if cnt2 > 0  then s := s + '🥔' + cnt2.ToString + ' ';
            if cnt3 > 0  then s := s + '🏭' + cnt3.ToString + ' ';
            Font.Color := $00A000;
          end;
        end;

        if sys.Stations.Count > 0 then
        begin
          if InfoLayer = 'LR' then
          begin
            cnt1 := 0;
            cnt2 := 0;
            for i2 := 0 to sys.Stations.Count - 1 do
            with TMarket(sys.Stations[i2]) do
              if LPads > 0 then
                if (Pos('Settl',StationType) <= 0) and (Pos('Carrier',StationType) <= 0) then
                begin
                  s := Economies;
                  if Pos('Refi ',s) > 0 then
                  if (Pos('Refi 0.',s) <= 0) or (Stock.Qty['steel'] > 10000) then
                  if IsOrbital then
                    Inc(cnt1)
                  else
                    Inc(cnt2);
                end;
            s := '';
            if cnt1 > 0  then s := s + '⚪•' + cnt1.ToString + ' ';
            if cnt2 > 0  then s := s + '🏭' + cnt2.ToString + ' ';
            Font.Color := $0070C0;
          end;

          if InfoLayer = 'LA' then
          begin
            cnt1 := 0;
            cnt2 := 0;
            for i2 := 0 to sys.Stations.Count - 1 do
            with TMarket(sys.Stations[i2]) do
              if LPads > 0 then
                if (Pos('Settl',StationType) <= 0) and (Pos('Carrier',StationType) <= 0) then
                begin
                  s := Economies;
                  if Pos('Agri ',s) > 0 then
                  if (Stock.Qty['fruit and vegetables'] > 10000) or (Stock.Qty['water'] > 10000) then
                  if IsOrbital then
                    Inc(cnt1)
                  else
                    Inc(cnt2);
                end;
            s := '';
            if cnt1 > 0  then s := s + '⚪•' + cnt1.ToString + ' ';
            if cnt2 > 0  then s := s + '🏭' + cnt2.ToString + ' ';
            Font.Color := $60CF90;
          end;


          if InfoLayer = 'SY' then
          begin
            cnt1 := 0;
            cnt2 := 0;
            for i2 := 0 to sys.Stations.Count - 1 do
            with TMarket(sys.Stations[i2]) do
              if Pos('shipyard',Services) > 0 then
              if Pos('Carrier',StationType) <= 0 then
                Inc(cnt1);
            s := '';
            if cnt1 > 0  then s := s + '🚀' + cnt1.ToString + ' ';
            //if cnt2 > 0  then s := s + '🏭' + cnt2.ToString + ' ';
            Font.Color := $00A000;
          end;



          if InfoLayer = 'IF' then
          begin
            cnt1 := 0;
            cnt2 := 0;
            for i2 := 0 to sys.Stations.Count - 1 do
            with TMarket(sys.Stations[i2]) do
              if Pos('facilitator',Services) > 0 then
                if LPads > 0 then
                  Inc(cnt1)
                else
                  Inc(cnt2);
            s := '';
            Font.Color := $00A000;
            if (cnt1+cnt2) > 0  then
              s := s + '⚖';
            if cnt1 = 0  then
              Font.Color := $A0A0A0;
          end;

          if InfoLayer = 'UC' then
          begin
            cnt1 := 0;
            cnt2 := 0;
            for i2 := 0 to sys.Stations.Count - 1 do
            with TMarket(sys.Stations[i2]) do
              if Pos('exploration',Services) > 0 then
              if Pos('Carrier',StationType) <= 0 then
                if LPads > 0 then
                  Inc(cnt1)
                else
                  Inc(cnt2);
            s := '';
            Font.Color := $00A000;
            if (cnt1+cnt2) > 0  then
              s := s + '🌐';
            if cnt1 = 0  then
              Font.Color := $A0A0A0;
          end;


        end;


        if (sys.Architect <> '') or (sys.CurrentGoals <> '') or (sys.TaskGroup <> '') then
        begin
          if InfoLayer = 'EW' then
          begin
            cnt1 := 0;
            cnt2 := 0;
            cnt3 := 0;
            for i2 := 0 to sys.Bodies.Count - 1 do
            with TSystemBody(sys.Bodies.Objects[i2]) do
            begin
              s := LowerCase(BodyType);
              if Pos('earth',s) > 0  then Inc(cnt1);
              if s = 'water world' then Inc(cnt2);
              if HasRings and (Pos('star',s) <= 0) then Inc(cnt3);
            end;

            s := '';
            if cnt1 > 0  then s := s + '🌍' + cnt1.ToString + ' ';
            if cnt2 > 0  then s := s + '●' + cnt2.ToString + ' '; //○⚪ • ●💧
            if cnt3 > 0  then s := s + '🪐' + cnt3.ToString + ' ';
            Font.Color := $D0C000;
          end;
        end;

        if s <> '' then
        begin
          r.Top := r.Top + TextHeight('Wq') + 1;
          Font.Size := fontSize + 2;
          Brush.Style := bsClear;
          Brush.Style := bsSolid;
          Brush.Color := clBlack;
          TextOut(r.Left,r.Top,s);


          r.Right := r.Left + TextWidth(s) + 1;
          r.Bottom := r.Top + TextHeight(s) + 1;
          Pen.Width := 1;
          Pen.Style := psSolid;
          Brush.Style := bsClear;
          Rectangle(r);
        end;
      end;
    end;

    if FRoute.Count > 1 then
    begin
      totDist := 0;
      Pen.Width := 1;
      Font.Color := clWhite;
      Font.Size := fontSize + 2;
      for i := 0 to FRoute.Count - 2 do
      begin
        if FRoute[i] = nil then continue;
        if FRoute[i+1] = nil then continue;
        CalcStarLane(FRoute[i],FRoute[i+1],r);
        Pen.Style := psDot;
        Pen.Color := $0000A0;
        Brush.Style := bsSolid;
        Brush.Color := clGray;
        MoveTo(r.Left,r.Top);
        LineTo(r.Right,r.Bottom);

        {
        Pen.Style := psSolid;
        Pen.Color := clWhite;
        LineTo(r.Right,r.Bottom);
        Pen.Style := psDot;
        Pen.Color := $0000A0;
        LineTo(r.Left,r.Top);
        }

        if not FHideDistances then
        begin
          r.Left := r.Left + (r.Right - r.Left) div 2;
          r.Top := r.Top + (r.Bottom - r.Top) div 2;
          dist := FRoute[i].DistanceTo(FRoute[i+1]);
          totDist := totDist + dist;
          s := '';
          {if i = 0 then
            s := s + '🏳 ';  }
          s := s + FloatToStrF(dist,ffFixed,7,2);
          if i > 0 then
            s := s + ' (' + FloatToStrF(totDist,ffFixed,7,2) + ')';
          {if i = FRoute.Count - 2 then
            s := s + ' 🏁';}
          r.Top := r.Top + TextHeight('Wq') div 2 + 1;
          Brush.Style := bsSolid;
          Brush.Color := clBlack;
          TextOut(r.Left,r.Top,s);

          r.Right := r.Left + TextWidth(s) + 1;
          r.Left := r.Left - 1;
          r.Bottom := r.Top + TextHeight(s) + 1;
          Pen.Style := psSolid;
          Pen.Color := $0000A0;
          Brush.Style := bsClear;
          Rectangle(r);
        end;
      end;
    end;

    Brush.Assign(PaintBox.Canvas.Brush);
    Brush.Color := $A0A0A0;
    r := PaintBox.ClientRect;
    r.Right := r.Right - 12;
    r.Bottom := r.Bottom - 12;
    r.Left := r.Right - 128;
    r.Top := r.Bottom - 92;
    FillRect(r);
    Pen.Color := clWhite;
    Pen.Style := psSolid;
    Pen.Width := 1;
    Rectangle(r);

    Font.Color := clBlack;
    Font.Size := 9;
    Font.Style := [];
    Brush.Style := bsClear;
    r.Left := r.Left + 12;
    Font.Size := 11;
    TextOut(r.Left, r.Top, '✦'); Inc(r.Top,12);
    TextOut(r.Left, r.Top , '✧'); Inc(r.Top,12);
    TextOut(r.Left, r.Top, '⛶'); Inc(r.Top,12);
    Font.Size := 9;
    TextOut(r.Left, r.Top, '● '); Inc(r.Top,12);
    TextOut(r.Left, r.Top, '○ '); Inc(r.Top,12);
    TextOut(r.Left, r.Top, '---'); Inc(r.Top,12);

    s := '10 ly grid';
    TextOut(r.Right - TextWidth(s) - 4, r.Top + 2, s);

    //Font.Style := [fsItalic];
    r.Top := r.Bottom - 92;
    r.Left := r.Left + 16;
    r.Top := r.Top + 2;
    TextOut(r.Left, r.Top, 'Major Colonies'); Inc(r.Top,12);
    TextOut(r.Left, r.Top , 'Minor Colonies'); Inc(r.Top,12);
    TextOut(r.Left, r.Top, 'Colon. Targets'); Inc(r.Top,12);
    TextOut(r.Left, r.Top, 'Popul. Systems'); Inc(r.Top,12);
    TextOut(r.Left, r.Top, 'Other Systems'); Inc(r.Top,12);
    TextOut(r.Left, r.Top, 'Star Lanes'); Inc(r.Top,12);

    FPreviewRect := Default(TRect);

    if FSelectedSystem <> nil then
    if Opts.Int['ShowSysPreview'] > 0 then
    if (FRoute.Count = 0) or (Opts.Int['ShowSysPreview'] = 2) then
    begin
      if not ColonModeCheck.Checked then
      begin
        png := TPngImage.Create;
        try
          png.LoadFromFile(FSelectedSystem.ImagePath);
          r := PaintBox.ClientRect;
          w := r.Width div 3;
          r.Left := 12;
          r.Right := r.Left + w;
          r.Bottom := r.Bottom - 12;
          r.Top := r.Bottom - w * png.Height div png.Width;
          GetBrushOrgEx(Handle,pt);
          SetStretchBltMode(Handle,HALFTONE);
          SetBrushOrgEx(Handle,pt.x,pt.y,@pt);
          StretchBlt(Handle, r.Left, r.Top, r.Right - r.Left, r.Bottom - r.Top,
            png.Canvas.Handle, 0, 0, png.Width, png.Height, CopyMode);
          Pen.Width := 1;
          Pen.Style := psSolid;
          Pen.Color := clSilver;
          Brush.Style := bsClear;
          Rectangle(r);
          FPreviewRect := r;

        except
        end;
        png.Free;
      end;

      s := '';
      if FSelectedSystem.Comment <> '' then s := s + FSelectedSystem.Comment + '  ';
      if FSelectedSystem.CurrentGoals <> '' then s := s + FSelectedSystem.CurrentGoals + '  ';
      if s <> '' then
      begin
        Font.Size := fontSize;
        Font.Color := clSilver;
        r.Left := 12;
        r.bottom := PaintBox.ClientRect.bottom - 12 - TextHeight(s);
        TextOut(r.Left+2,r.bottom-2,s);
      end;
    end;

  end;
end;

procedure TStarMapForm.PaintBoxPaint(Sender: TObject);
begin
  if (FMap.Width <> Paintbox.Width) or (FMap.Height <> PaintBox.Height) then
    UpdateMap;
  PaintBox.Canvas.Draw(0,0,FMap);
end;

procedure TStarMapForm.SetRouteMenuItemClick(Sender: TObject);
var i: Integer;
begin
  if FRouteName = TMenuItem(Sender).Hint then
  begin
    FRouteName := '';
    FRoute.Clear;
  end
  else
  begin
    FRouteName := TMenuItem(Sender).Hint;
    FRoute.CommaText := DataSrc.Routes.Values[FRouteName];
    for i := 0 to FRoute.Count - 1 do
      FRoute.Objects[i] := DataSrc.StarSystems.SystemByName[FRoute.Strings[i]];
    FMapZoom := 75;
  end;
  UpdateItems;
  UpdateMap(true);
  PaintBoxPaint(nil);
end;

procedure TStarMapForm.SaveRouteMenuItemClick(Sender: TObject);
begin
  if (TMenuItem(Sender).Tag = 1) or (FRouteName = '') then
    FRouteName := Vcl.Dialogs.InputBox('Route', 'Name', FRouteName);
  if FRouteName = '' then Exit;
  DataSrc.SetRoute(FRouteName,FRoute.CommaText);
end;

procedure TStarMapForm.DeleteRouteMenuItemClick(Sender: TObject);
begin
  if FRouteName = '' then Exit;
  if Vcl.Dialogs.MessageDlg('Delete current route?',
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;
  DataSrc.SetRoute(FRouteName,'');
  FRouteName := '';
  FRoute.Clear;
  UpdateMap;
  PaintBoxPaint(nil);
end;

procedure TStarMapForm.PopupMenuPopup(Sender: TObject);
var i: Integer;
    mitem: TMenuItem;
begin
  SystemInfoMenuItem.Enabled := FSelectedSystem <> nil;
  CopySystemNameMenuItem.Enabled := FSelectedSystem <> nil;
  MapKeySubMenu.Enabled := FSelectedSystem <> nil;
  ColonizationSubMenu.Enabled := FSelectedSystem <> nil;
  StartRouteMenuItem.Enabled := FRoute.Count > 1;
  StopRouteMenuItem.Enabled := (FRoute.Count > 1) or DataSrc.CurrentRoute.Active;
  ClearRouteMenuItem.Enabled := FRoute.Count > 1;

  AddSystemsMenuItem.Visible := Opts.Flags['DevMode'];

  for i := RouteSubMenu.Count - 1 downto 0 do
  begin
    if RouteSubMenu.Items[i].Caption = '-' then break;
    RouteSubMenu.Delete(i);
  end;

  for i := 0 to DataSrc.Routes.Count - 1 do
  begin
    mitem := TMenuItem.Create(RouteSubMenu);
    mitem.Caption := '🏳🏁 ' + DataSrc.Routes.Names[i];
    mitem.Hint := DataSrc.Routes.Names[i];
    mitem.OnClick := SetRouteMenuItemClick;
    mitem.AutoCheck := true;
    mitem.Checked := FRouteName = mitem.Hint;
    RouteSubMenu.Add(mitem);
  end;
  if DataSrc.Routes.Count = 0 then
  begin
    mitem := TMenuItem.Create(RouteSubMenu);
    mitem.Caption := '( no saved routes )';
    mitem.Enabled := false;
    RouteSubMenu.Add(mitem);
  end;
  mitem := TMenuItem.Create(RouteSubMenu);
  mitem.Caption := 'Save';
  mitem.OnClick := SaveRouteMenuItemClick;
  mitem.Enabled := (FRoute.Count > 1) and (FRouteName <> '');
  RouteSubMenu.Add(mitem);
  mitem := TMenuItem.Create(RouteSubMenu);
  mitem.Caption := 'Save As...';
  mitem.OnClick := SaveRouteMenuItemClick;
  mitem.Tag := 1;
  mitem.Enabled := FRoute.Count > 1;
  RouteSubMenu.Add(mitem);
  mitem := TMenuItem.Create(RouteSubMenu);
  mitem.Caption := 'Delete';
  mitem.OnClick := DeleteRouteMenuItemClick;
  mitem.Enabled := FRouteName <> '';
  RouteSubMenu.Add(mitem);
end;

end.
