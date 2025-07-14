unit StarMap;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, DataSource, System.Types, System.Math,
  Vcl.StdCtrls, Vcl.Menus, Vcl.Imaging.pngimage;

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
  TStarMapForm = class(TForm)
    PaintBox: TPaintBox;
    Panel1: TPanel;
    Label1: TLabel;
    ProjectionXCombo: TComboBox;
    Label2: TLabel;
    ProjectionYCombo: TComboBox;
    MajorColCheck: TCheckBox;
    MinorColCheck: TCheckBox;
    TargetsCheck: TCheckBox;
    OtherSysCheck: TCheckBox;
    MinPopCombo: TComboBox;
    TaskGroupCombo: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    InfoCombo: TComboBox;
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
    LinkStyleCombo: TComboBox;
    Label5: TLabel;
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
  private
    { Private declarations }

    FMap: TBitmap;
    FMapSpan: TRect; //in light years
    FOrigin: TPoint; //in pixels, for panning
    FSavedOrigin: TPoint;
    FStartPanPos: TPoint;
    FMapZoom: Integer;
    sysPosArr: array of TStarSystemLabel;
    FStarSystems: TSystemList;
    FColonies: TSystemList;
    FSelectedSystem: TStarSystem;
    procedure UpdateItems;
    procedure UpdateMap(const autoCenter: Boolean = false);
    procedure ResetMap;
    procedure UpdateOpts;
  public
    { Public declarations }
  end;

var
  StarMapForm: TStarMapForm;

implementation

{$R *.dfm}

uses SystemInfo, Settings, Clipbrd;


procedure TStarMapForm.ResetMap;
begin
  FOrigin := TPoint.Create(0,0);
  FMapZoom := 100;
  UpdateItems;
  UpdateMap(true);
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
  ResetMap;
  PaintBoxPaint(nil);
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
  UpdateMap;
  PaintBoxPaint(nil);
end;

procedure TStarMapForm.MinPopComboChange(Sender: TObject);
begin
  UpdateItems;
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


procedure TStarMapForm.UpdateOpts;
begin
  Opts['MapProjX'] := ProjectionXCombo.Text;
  Opts['MapProjY'] := ProjectionYCombo.Text;
  Opts['MapLanes'] := LinkStyleCombo.Text;
  Opts['Map.Left'] := IntToStr(self.Left);
  Opts['Map.Top'] := IntToStr(self.Top);
  Opts['Map.Height'] := IntToStr(self.Height);
  Opts['Map.Width'] := IntToStr(self.Width);
end;


procedure TStarMapForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UpdateOpts;
end;

procedure TStarMapForm.FormCreate(Sender: TObject);
begin
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
  FMap := TBitmap.Create;
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

procedure TStarMapForm.PaintBoxClick(Sender: TObject);
var i: Integer;
    pt: TPoint;
begin
  pt := Mouse.CursorPos;
  pt := PaintBox.ScreenToClient(pt);
  for i := 0 to High(sysPosArr) do
    if PtInRect(sysPosArr[i].labelRect,pt) or PtInRect(sysPosArr[i].starRect,pt) then
    begin
       if FSelectedSystem <> sysPosArr[i].sys then
       begin
         FSelectedSystem := sysPosArr[i].sys;
         UpdateMap;
         PaintBoxPaint(nil);
       end;
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
  SystemInfoForm.SetSystem(FSelectedSystem);
  SystemInfoForm.Show;
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
  if ((ssLeft in Shift) or (ssMiddle in Shift)) and (FStartPanPos.X <> -1) then
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
  if Button = mbRight then PaintBoxClick(nil);
end;

procedure TStarMapForm.UpdateItems;
var i: Integer;
    sys: TStarSystem;
    minPop: Integer;
    s: string;
    okf,isColonyf: Boolean;
begin
  FStarSystems.Clear;
  FColonies.Clear;

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
      if (sys.Architect = '') and (sys.Population < minPop) then okf := false;

{
    if sys.TaskGroup <> '' then
      if TaskGroupCombo.Text <> '' then
         if sys.TaskGroup <> TaskGroupCombo.Text then okf := false;
}

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
        if sys.TaskGroup <> '' then
          if TaskGroupCombo.Text <> '' then
             if sys.TaskGroup <> TaskGroupCombo.Text then continue;
        FColonies.AddObject(sys.Population.ToString.PadLeft(12),sys);
      end;
    end;
  end;
  FStarSystems.Sort;
  FColonies.Sort;
  if DataSrc.CurrentSystem <> nil then
    if FStarSystems.IndexOfObject(DataSrc.CurrentSystem) = -1 then
      FStarSystems.AddObject('$current',DataSrc.CurrentSystem);
  if InfoCombo.ItemIndex = 1 then
    DataSrc.UpdateSystemConstructions;
end;

procedure TStarMapForm.UpdateMap(const autoCenter: Boolean = false);
var i,i2,i3,w,idx,si,margin,projectionX,projectionY,labOffsetX,labOffsetY,fontSize: Integer;
    sys: TStarSystem;
    r,r2: TRect;
    pt,pt2: TPoint;
    proj: TMapPos;
    linkRects: array [0..100] of TRect;
    linkRectsCnt: Integer;
    maxSize,minPop,maxLinks,maxLinkCnt,curLinkCnt: Integer;
    lyPixels: Extended;
    starSymbol,s: string;
    okf,isColonyf: Boolean;
    cnt1,cnt2,cnt3: Integer;
    png: TPngImage;

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
        map.Y := sys.StarPosY;
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

begin
  SetLength(sysPosArr,0);
//  ZeroMemory(@mostPops,sizeof(mostPops));
  ZeroMemory(@linkRects,sizeof(linkRects));
  linkRectsCnt := 0;

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
    if autoCenter then
    begin
      for i := 0 to FColonies.Count - 1 do
      begin
        sys := FColonies[i];
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
    lyPixels := Min(Width,Height) / maxSize;
    lyPixels := lyPixels * FMapZoom / 100;

    if autoCenter then
    begin
      FOrigin.X := -(Width - Trunc(lyPixels * FMapSpan.Width)) div 2;
      FOrigin.Y := -(Height - Trunc(lyPixels * FMapSpan.Height)) div 2;
    end;

    fontSize := Max(6,Min(6 + Trunc(lyPixels/3) {2 * FMapZoom div 50},24));
    labOffsetX := fontSize + 4;
    labOffsetY := fontSize - 2;


    if FMapZoom >= 25 then
    begin
      Pen.Color := $202020;
      Pen.Style := psSolid;
      Pen.Width := 1;
      for i := 0 to Ceil(Height / (10*lyPixels)) do
      begin
        MoveTo(0,Trunc(i * 10*lyPixels));
        LineTo(Width,Trunc(i * 10*lyPixels));
      end;
      for i := 0 to Ceil(Width / (10*lyPixels)) do
      begin
        MoveTo(Trunc(i * 10*lyPixels),0);
        LineTo(Trunc(i * 10*lyPixels),Height);
      end;
    end;

    if LinkStyleCombo.ItemIndex <> 4 {ClusterLinesCheck.Checked} then
    begin
      maxLinks := 50;

      Pen.Color := $808080;
      Pen.Style := psDot;
      Pen.Width := 1;
      for i := FColonies.Count - 1 downto 0 do    //Max(FColonies.Count - 12,0)
      begin
        maxLinkCnt := linkRectsCnt;
        curLinkCnt := 0;
        si := i - 1;
        if LinkStyleCombo.ItemIndex >= 3 then
          si := FColonies.Count - 1;
        for i2 := si downto 0 do
        if i <> i2 then
        begin
          if FColonies[i].DistanceTo(FColonies[i2]) > 30 then continue;

          getSysPos_projected(FColonies[i],proj);
          r.Left := -FOrigin.X + Trunc(lyPixels*(proj.X - FMapSpan.Left)) + (fontSize+4) div 2;
          r.Top := -FOrigin.Y + Trunc(lyPixels*(proj.Y - FMapSpan.Top)) + (fontSize+4) div 2;
          getSysPos_projected(FColonies[i2],proj);
          r.Right := -FOrigin.X + Trunc(lyPixels*(proj.X - FMapSpan.Left)) + (fontSize+4) div 2;
          r.Bottom := -FOrigin.Y + Trunc(lyPixels*(proj.Y - FMapSpan.Top))+ (fontSize+4) div 2;

          r2 := fixRect(r);
          i3 := 0;

          if LinkStyleCombo.ItemIndex mod 2 = 0 then maxLinkCnt := linkRectsCnt;

          while i3 < {linkRectsCnt}maxLinkCnt do
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

          if LinkStyleCombo.ItemIndex >= 2 then
            if curLinkCnt > 3 then break;
          if linkRectsCnt > maxLinks then break;

        end;
        if linkRectsCnt > maxLinks then break;
      end;
    end;

    s := MinPopCombo.Text;
    s := s.Replace(' ','');
    s := s.Replace(',','');
    minPop := StrToIntDef(s.Replace(' ',''),1000000);
    for i := 0 to FStarSystems.Count - 1 do
    begin
      sys := FStarSystems[i];

      if True then
      begin
        idx := High(sysPosArr) + 1;
        SetLength(sysPosArr,idx+1);
        sysPosArr[idx].sys := sys;
        sysPosArr[idx].overlaps := 0;

        getSysPos_projected(sys,proj);
        pt.X := -FOrigin.X + Trunc(lyPixels*(proj.X - FMapSpan.Left));
        pt.Y := -FOrigin.Y + Trunc(lyPixels*(proj.Y - FMapSpan.Top));

        Brush.Style := bsClear;
        Font.Style := [];

        //colonies
        starSymbol := '✧';
        if sys.Population > 1000000 then
          starSymbol := '✦';
        Font.Size := fontSize + 4; //default star size is somewhat small

        //targets
        if (sys.Population = 0) and not sys.PrimaryDone and (sys.Architect <> '') then
          starSymbol := '⛶';

        if sys.Architect = '' then
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

        r.Left := pt.X;
        r.Top := pt.Y;
        r.Right := r.Left + TextWidth(starSymbol);
        r.Bottom := r.Top + TextHeight(starSymbol);
        sysPosArr[idx].starRect := r;
        TextOut(pt.X,pt.Y,starSymbol);

        Brush.Style := bsSolid;
        case sys.MapKey of
          1: Brush.Color := $505050;
          2: Brush.Color := $23238E;  //clFirebrick
          3: Brush.Color := $0070D0;
          4: Brush.Color := $006000;
          5: Brush.Color := $800000;
        else
          Brush.Style := bsClear;
        end;

        if sys = FSelectedSystem then
        begin
          Brush.Style := bsSolid;
          Brush.Color := clWhite;
          Font.Color := clBlack;
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
          if IntersectRect(r,sysPosArr[i2].labelRect) then
          begin
             Inc(sysPosArr[i2].overlaps);
             //todo: include font size, and move only on substantial intersection
             OffsetRect(r,0,12*sysPosArr[i2].overlaps);
             if IntersectRect(r,sysPosArr[i2].labelRect) then
               OffsetRect(r,0,-24);
             break;
          end;

        sysPosArr[idx].labelRect := r;
        TextOut(r.Left,r.Top,sys.StarSystem);

        if sys.Architect <> '' then
        if sys.Constructions <> nil then
        begin
          if InfoCombo.ItemIndex = 1 then
          begin
            cnt1 := 0;
            cnt2 := 0;
            for i2 := 0 to sys.Constructions.Count - 1 do
            with TConstructionDepot(sys.Constructions[i2]) do
              if not Finished then
                if Planned then
                  Inc(cnt2)
                else
                  Inc(cnt1);
            s := '';
            if cnt1 > 0  then s := s + '🚧' + cnt1.ToString + ' ';
            if cnt2 > 0  then s := s + '✏' + cnt2.ToString + ' ';
            if s <> '' then
            begin
              r.Top := r.Top + fontSize + 4;
              Font.Color := $00A0FF;
              Font.Size := fontSize + 2;
              Brush.Style := bsClear;
              TextOut(r.Left,r.Top,s);
            end;
          end;

          if InfoCombo.ItemIndex = 2 then
          if sys.Population > 0 then
          begin
            s := '👥' + sys.GetFactions(true,true);
            r.Top := r.Top + fontSize + 4;
            Font.Color := $00C000;
            Font.Size := fontSize;
            Brush.Style := bsClear;
            TextOut(r.Left,r.Top,s);
          end;


          if InfoCombo.ItemIndex = 3 then
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
            if s <> '' then
            begin
              r.Top := r.Top + fontSize + 4;
              Font.Color := $D0C000;
              Font.Size := fontSize + 2;
              Brush.Style := bsClear;
              TextOut(r.Left,r.Top,s);
            end;
          end;

        end;
      end;
    end;

    Brush.Assign(PaintBox.Canvas.Brush);
    Brush.Color := $808080;
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
    TextOut(r.Left, r.Top, '○ '); Inc(r.Top,12);
    TextOut(r.Left, r.Top, '● '); Inc(r.Top,12);
    TextOut(r.Left, r.Top, '---'); Inc(r.Top,12);

    //Font.Style := [fsItalic];
    r.Top := r.Bottom - 92;
    r.Left := r.Left + 16;
    r.Top := r.Top + 2;
    TextOut(r.Left, r.Top, 'Major Colonies'); Inc(r.Top,12);
    TextOut(r.Left, r.Top , 'Minor Colonies'); Inc(r.Top,12);
    TextOut(r.Left, r.Top, 'Colon. Targets'); Inc(r.Top,12);
    TextOut(r.Left, r.Top, 'Other Systems'); Inc(r.Top,12);
    TextOut(r.Left, r.Top, 'Popul. Systems'); Inc(r.Top,12);
    TextOut(r.Left, r.Top, 'Star Lanes'); Inc(r.Top,12);
    TextOut(r.Left, r.Top, '(10 ly grid)'); Inc(r.Top,12);

    if FSelectedSystem <> nil then
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
      except
      end;
      png.Free;
    end;

  end;
end;

procedure TStarMapForm.PaintBoxPaint(Sender: TObject);
begin
  if (FMap.Width <> Paintbox.Width) or (FMap.Height <> PaintBox.Height) then
    UpdateMap;
  PaintBox.Canvas.Draw(0,0,FMap);
end;

procedure TStarMapForm.PopupMenuPopup(Sender: TObject);
begin
  SystemInfoMenuItem.Enabled := FSelectedSystem <> nil;
  CopySystemNameMenuItem.Enabled := FSelectedSystem <> nil;
  MapKeySubMenu.Enabled := FSelectedSystem <> nil;
end;

end.
