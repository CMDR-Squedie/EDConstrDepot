unit SystemInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  DataSource, System.JSON, System.StrUtils, Vcl.Menus,  Vcl.Imaging.pngimage, Winapi.ShellAPI;

type
  TSystemInfoForm = class(TForm, IEDDataListener)
    ListView: TListView;
    Panel1: TPanel;
    SystemNameLabel: TLabel;
    FactionsLabel: TLabel;
    LastUpdateLabel: TLabel;
    SystemAddrLabel: TLabel;
    EDSMScanButton: TButton;
    ScrollBox: TScrollBox;
    SysImage: TImage;
    Splitter1: TSplitter;
    ArchitectLabel: TLabel;
    PopulationLabel: TLabel;
    PopupMenu: TPopupMenu;
    PastePictureMenuItem: TMenuItem;
    SavePictureMenuItem: TMenuItem;
    EditPictureMenuItem: TMenuItem;
    N1: TMenuItem;
    ClearPictureMenuItem: TMenuItem;
    N2: TMenuItem;
    FullPictureMenuItem: TMenuItem;
    PopupMenu2: TPopupMenu;
    AddConstructionMenuItem: TMenuItem;
    DeleteConstructionMenuItem: TMenuItem;
    N3: TMenuItem;
    MarketInfoMenuItem: TMenuItem;
    Panel2: TPanel;
    Label1: TLabel;
    SecLabel: TLabel;
    Label2: TLabel;
    DevLabel: TLabel;
    Label4: TLabel;
    TechLabel: TLabel;
    Label6: TLabel;
    WealthLabel: TLabel;
    Label8: TLabel;
    LivLabel: TLabel;
    PrimaryLabel: TLabel;
    Label11: TLabel;
    CP2Label: TLabel;
    T2Label: TLabel;
    CP3Label: TLabel;
    QuickAddOrbitalSubMenu: TMenuItem;
    QuickAddSurfaceSubMenu: TMenuItem;
    CopyAllMenuItem: TMenuItem;
    SecurityLabel: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    CommentEdit: TEdit;
    SaveDataButton: TButton;
    GoalsEdit: TEdit;
    ObjectivesEdit: TEdit;
    NoPictureLabel: TLabel;
    SetTypeSubMenu: TMenuItem;
    QuickAddAsSubMenu: TMenuItem;
    QuickAddAsFinishedMenuItem: TMenuItem;
    QuickAddAsPlannedMenuItem: TMenuItem;
    QuickAddAsInProgressMenuItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EDSMScanButtonClick(Sender: TObject);
    procedure SysImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure SysImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SysImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SysImageDblClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure PastePictureMenuItemClick(Sender: TObject);
    procedure SavePictureMenuItemClick(Sender: TObject);
    procedure EditPictureMenuItemClick(Sender: TObject);
    procedure ClearPictureMenuItemClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ListViewDblClick(Sender: TObject);
    procedure AddConstructionMenuItemClick(Sender: TObject);
    procedure SysImageClick(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure MarketInfoMenuItemClick(Sender: TObject);
    procedure DeleteConstructionMenuItemClick(Sender: TObject);
    procedure ListViewClick(Sender: TObject);
    procedure QuickAddStationMenuItemClick(Sender: TObject);
    procedure CopyAllMenuItemClick(Sender: TObject);
    procedure SystemAddrLabelDblClick(Sender: TObject);
    procedure CommentEditChange(Sender: TObject);
    procedure SaveDataButtonClick(Sender: TObject);
    procedure ListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetStationTypeMenuItemClick(Sender: TObject);
  private
    { Private declarations }
    FCurrentSystem: TStarSystem;
    FStartPos,FScrollPos: TPoint;
    FImageChanged: Boolean;
    FDataChanged: Boolean;
    FSelectedObj: TObject;
    FListViewVScrollPos: Integer;
    FClickedColumn: Integer;
    procedure TryPasteImage;
    procedure SavePicture;
    procedure SaveData;
    procedure SystemSaveQuery;
    procedure SaveSelection;
    procedure RestoreSelection;
    function TryOpenMarket: Boolean;
  public
    { Public declarations }
    procedure SetSystem(s: TStarSystem);
    procedure ApplySettings;
    procedure OnEDDataUpdate;
    procedure UpdateData;
    property CurrentSystem: TStarSystem read FCurrentSystem;
    function GetNextConstruction(bm: TBaseMarket): TBaseMarket;
  end;

var
  SystemInfoForm: TSystemInfoForm;

implementation

{$R *.dfm}

uses Markets, Main, Settings, SystemPict, Colonies, Clipbrd, StationInfo,
  MarketInfo;


function TSystemInfoForm.GetNextConstruction(bm: TBaseMarket): TBaseMarket;
var i: Integer;
    data: TObject;
    nextFlag: Boolean;
begin
  Result := nil;
  nextFlag := False;
  for i := 0 to ListView.Items.Count - 1 do
  begin
    data := TObject(ListView.Items[i].Data);
    if data is TConstructionDepot then
    begin
      if TConstructionDepot(data).Simulated then continue;
      if Result = nil then Result := TBaseMarket(data);
      if nextFlag then
      begin
        Result := TBaseMarket(data);
        break;
      end;
      if data = bm then nextFlag := True;
    end;
  end;
end;


procedure TSystemInfoForm.ClearPictureMenuItemClick(Sender: TObject);
begin
  if FCurrentSystem = nil then Exit;

  if Vcl.Dialogs.MessageDlg('Delete the system picture?',
     mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  DeleteFile(PChar(FCurrentSystem.ImagePath));
  FImageChanged := False;
  SysImage.Picture := nil;
  NoPictureLabel.Visible := True;
  if ColoniesForm.Visible then
    ColoniesForm.UpdateItems;
end;

procedure TSystemInfoForm.CommentEditChange(Sender: TObject);
begin
  FDataChanged := True;
end;

procedure TSystemInfoForm.CopyAllMenuItemClick(Sender: TObject);
var s: string;
    i,j: Integer;
    selonlyf: Boolean;
begin
  s := '';
  for i := 0 to ListView.Columns.Count -1 do
  begin
    if ListView.Columns[i].Caption <> '' then
      s := s + ListView.Columns[i].Caption + Chr(9);
  end;
  s := s + Chr(13);

  for i := 0 to ListView.Items.Count -1 do
  begin
    s := s + ListView.Items[i].Caption + Chr(9);
    for j := 0 to ListView.Items[i].SubItems.Count - 1 do
      if j < ListView.Columns.Count - 1 then
        if ListView.Columns[j+1].Caption <> '' then
          s := s + ListView.Items[i].SubItems[j] + Chr(9);
    s := s + Chr(13);
  end;
  Clipboard.SetTextBuf(PChar(s));
end;

procedure TSystemInfoForm.DeleteConstructionMenuItemClick(Sender: TObject);
var cd: TConstructionDepot;
begin
  if ListView.Selected = nil then Exit;
  if TObject(ListView.Selected.Data) is TConstructionDepot then
  begin
    cd := TConstructionDepot(ListView.Selected.Data);
    if cd.Simulated then Exit;
    if cd.LastUpdate <> '' then Exit; //journal-based construction
    
    if Vcl.Dialogs.MessageDlg('Delete this construction?',
       mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;
    if cd.LastUpdate <> '' then Exit;
    if StationInfoForm.CurrentStation = cd then StationInfoForm.Close;
    DataSrc.RemoveConstruction(cd);
    FCurrentSystem.Save;
  end;
end;

procedure TSystemInfoForm.EditPictureMenuItemClick(Sender: TObject);
begin
  if SysImage.Picture.Width = 0 then Exit;
  ShellExecute(0,'edit',PChar(FCurrentSystem.ImagePath),nil,nil,SW_SHOWNORMAL);
end;

procedure TSystemInfoForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var res: TMsgDlgBtn;
begin
  CanClose := True;
  SystemSaveQuery;
end;

procedure TSystemInfoForm.SystemSaveQuery;
begin
  if FImageChanged or FDataChanged then
  begin
    self.BringToFront;
    if Vcl.Dialogs.MessageDlg('Save system data?',
      mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes then
      SaveDataButtonClick(nil);
  end;
  FImageChanged := False;
  FDataChanged := False;
end;


procedure TSystemInfoForm.PastePictureMenuItemClick(Sender: TObject);
begin
  TryPasteImage;
end;

procedure TSystemInfoForm.SavePictureMenuItemClick(Sender: TObject);
begin
  SavePicture;
  if ColoniesForm.Visible then
    ColoniesForm.UpdateItems;
end;

procedure TSystemInfoForm.QuickAddStationMenuItemClick(Sender: TObject);
var cd: TConstructionDepot;
    b: TSystemBody;
    UUID: TGUID;
begin
  if ListView.Selected = nil then Exit;
  if TObject(ListView.Selected.Data) is TSystemBody then
  begin
    cd := TConstructionDepot.Create;
    cd.StarSystem := FCurrentSystem.StarSystem;
    cd.Body := TSystemBody(ListView.Selected.Data).BodyName;
    cd.ConstructionType := DataSrc.ConstructionTypes[TMenuItem(Sender).Tag];
    if QuickAddAsFinishedMenuItem.Checked then cd.Finished := True;
    if QuickAddAsPlannedMenuItem.Checked then cd.Planned := True;
 
    cd.Modified := True;

    CreateGUID(UUID);
    cd.MarketId := GUIDToString(UUID);
    DataSrc.Constructions.AddObject(cd.MarketID,cd);
    FCurrentSystem.Save;
    UpdateData;
  end;
end;

procedure TSystemInfoForm.SetStationTypeMenuItemClick(Sender: TObject);
var cd: TConstructionDepot;
begin
  if ListView.Selected = nil then Exit;
  if TObject(ListView.Selected.Data) is TConstructionDepot then
  begin
    cd := TConstructionDepot(ListView.Selected.Data);
    cd.ConstructionType := DataSrc.ConstructionTypes[TMenuItem(Sender).Tag];
    FCurrentSystem.Save;
    UpdateData;
  end;
end;

procedure TSystemInfoForm.PopupMenu2Popup(Sender: TObject);
var mf,cdf,bf: Boolean;
    sl: TStringList;
    i,d,matchHaul: Integer;
    mitem: TMenuItem;
    ct: TConstructionType;
    matchOrbital: Boolean;
begin
  mf := False;
  cdf := False;
  bf := False;
  if ListView.Selected <> nil then
  begin
    mf := TObject(ListView.Selected.Data) is TMarket;
    cdf := TObject(ListView.Selected.Data) is TConstructionDepot;
    bf := TObject(ListView.Selected.Data) is TSystemBody;
  end;
  AddConstructionMenuItem.Enabled := bf or mf;
  QuickAddOrbitalSubMenu.Enabled := bf;
  QuickAddSurfaceSubMenu.Enabled := bf;
  SetTypeSubMenu.Enabled := cdf;
  DeleteConstructionMenuItem.Enabled := cdf;
  MarketInfoMenuItem.Enabled := mf or
    (cdf and (TConstructionDepot(ListView.Selected.Data).LinkedMarketId <> ''));

  sl := TStringList.Create;
  DataSrc.ConstructionTypes.PopulateList(sl);
  sl.Sort;

  if QuickAddOrbitalSubMenu.Count = 0 then
  begin
    for i := 0 to sl.Count - 1 do
    begin
      if TConstructionType(sl.Objects[i]).Location = 'Orbital' then
      begin
        mitem := TMenuItem.Create(QuickAddOrbitalSubMenu);
        QuickAddOrbitalSubMenu.Add(mitem);
      end
      else
      begin
        mitem := TMenuItem.Create(QuickAddSurfaceSubMenu);
        QuickAddSurfaceSubMenu.Add(mitem);

      end;
      mitem.Caption := sl[i];
      mitem.Tag := DataSrc.ConstructionTypes.IndexOfObject(sl.Objects[i]);
      mitem.OnClick := QuickAddStationMenuItemClick;
    end;
  end;

  SetTypeSubMenu.Clear;
  if cdf then
  with TConstructionDepot(ListView.Selected.Data) do
  begin
    matchHaul := ActualHaul;
    if matchHaul = 0 then
    begin
      ct := GetConstrType;
      if ct <> nil then matchHaul := ct.EstCargo;
    end;
    if matchHaul > 0 then
    begin
      for i := 0 to sl.Count - 1 do
      begin
        ct := TConstructionType(sl.Objects[i]);
        if (IsOrbital = ct.IsOrbital) and (ct.EstCargo > 0) then
        begin
          d := Abs(100 * (matchHaul - ct.EstCargo) div ct.EstCargo);
          if (d <= 5) or (IsPrimary and (d <= 35)) then  //max. 5% dev., or 35% for primaryport
          begin
            mitem := TMenuItem.Create(SetTypeSubMenu);
            mitem.Caption := ct.StationType_full;
            mitem.Tag := DataSrc.ConstructionTypes.IndexOfObject(sl.Objects[i]);
            mitem.OnClick := SetStationTypeMenuItemClick;
            mitem.Enabled := ct.Id <> ConstructionType;
            mitem.Checked := ct.Id = ConstructionType;
            SetTypeSubMenu.Add(mitem);
          end;
        end;
      end;
    end;

    mitem := TMenuItem.Create(SetTypeSubMenu);
    mitem.Caption := 'Other...';
    mitem.OnClick := ListViewDblClick;
    SetTypeSubMenu.Add(mitem);
  end;
//  MarketInfoMenuItem.Enabled := mf;
  sl.Free;
end;

procedure TSystemInfoForm.PopupMenuPopup(Sender: TObject);
var picf: Boolean;
begin
  picf := SysImage.Picture.Width > 0;
  SavePictureMenuItem.Enabled := picf;
  EditPictureMenuItem.Enabled := picf;
  FullPictureMenuItem.Enabled := picf;
end;

procedure TSystemInfoForm.TryPasteImage;
var
  bmp: TBitmap;
begin
  if FCurrentSystem = nil then Exit;
  bmp := TBitmap.Create;
  if Clipboard.HasFormat(CF_BITMAP) then
  begin
    bmp.Assign(Clipboard);
    SysImage.Picture.Assign(bmp);
    NoPictureLabel.Visible := False;
    FImageChanged := True;
  end;
  bmp.Free;
end;


procedure TSystemInfoForm.SaveData;
begin
  if not FDataChanged then Exit;

  FCurrentSystem.Comment := CommentEdit.Text;
  FCurrentSystem.CurrentGoals := GoalsEdit.Text;
  FCurrentSystem.Objectives := ObjectivesEdit.Text;
  FCurrentSystem.Save;
  FDataChanged := False;
end;

procedure TSystemInfoForm.SaveDataButtonClick(Sender: TObject);
begin
  SaveData;
  SavePicture;
  if ColoniesForm.Visible then
    ColoniesForm.UpdateItems;
end;

procedure TSystemInfoForm.SavePicture;
var png: TPngImage;
begin
  if FCurrentSystem = nil then Exit;
  if SysImage.Picture = nil then Exit;
  if SysImage.Picture.Width = 0 then Exit;
  if not FImageChanged then Exit;

  png := TPngImage.Create;
  png.Assign(SysImage.Picture.Bitmap);
  png.SaveToFile(FCurrentSystem.ImagePath);
  FImageChanged := False;
end;


procedure TSystemInfoForm.EDSMScanButtonClick(Sender: TObject);
begin
  if FCurrentSystem.NavBeaconScan then
    if Vcl.Dialogs.MessageDlg('This system already has full Nav Beacon scan. Fetch data from EDSM?',
      mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  FCurrentSystem.UpdateBodies_EDSM;
  FCurrentSystem.Save;
  UpdateData;
end;

procedure TSystemInfoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if self <> SystemInfoForm then
  begin
    Action := caFree;
    DataSrc.RemoveListener(self);
  end;
end;


procedure TSystemInfoForm.FormCreate(Sender: TObject);
begin
  FStartPos.X := -1;
  DataSrc.AddListener(self);
  ApplySettings;
end;


procedure TSystemInfoForm.ListViewClick(Sender: TObject);
var data: TObject;
begin
  if ListView.Selected = nil then Exit;
  if not StationInfoForm.Visible then Exit;
  
  data := TObject(ListView.Selected.Data);
  if data is TConstructionDepot then
  begin
    if TConstructionDepot(data).Simulated then Exit;
    StationInfoForm.SetStation(TBaseMarket(data));
  end;
end;

procedure TSystemInfoForm.ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var r: TRect;
    i,x: Integer;
begin
  if cdsSelected in State then
  begin
    Sender.Canvas.Brush.Color := clHighLight;
  end
  else
  begin
    Sender.Canvas.Brush.Color := ListView.Color;
    if Item.Index mod 2 = 0 then
      Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color - $202020;
  end;

  if TObject(Item.Data) is TBaseMarket then
  begin
    if ListView.Font.Color = clBlack then
      Sender.Canvas.Font.Color := clNavy
    else
      Sender.Canvas.Font.Color := clSilver;
  end
  else
  begin
    Sender.Canvas.Font.Color := ListView.Font.Color;
  end;
{
  r := Item.DisplayRect(drBounds);
  Sender.Canvas.FillRect(r);
  Sender.Canvas.TextOut(r.Left + 2, r.Top + 2, Item.Caption);

  for i := 0 to Item.SubItems.Count - 1 do
  begin
    ListView_GetSubItemRect(ListView.Handle,Item.Index,i+1,LVIR_BOUNDS,@r);
    case ListView.Columns[i+1].Alignment of
      taLeftJustify: x := r.Left + 4;
      taRightJustify: x := r.Right - Sender.Canvas.TextWidth(Item.SubItems[i]) - 2;
      taCenter: x := r.Left + (r.Width - Sender.Canvas.TextWidth(Item.SubItems[i])) div 2;
    end;
    Sender.Canvas.TextRect(r,x, r.Top + 2, Item.SubItems[i]);
  end;

  DefaultDraw := False;
}
end;

procedure TSystemInfoForm.ListViewDblClick(Sender: TObject);
var data: TObject;
begin
  if ListView.Selected = nil then Exit;
  data := TObject(ListView.Selected.Data);

  if FClickedColumn = 4 then
    if TryOpenMarket then Exit;

  if data is TConstructionDepot then
  begin
    if TConstructionDepot(data).Simulated then Exit;
    StationInfoForm.SetStation(TBaseMarket(data));
    StationInfoForm.Show;
  end;

  if data is TMarket then
     ShowMessage('Link this market to its construction, or choose Add Construction command to create one.');
    //AddConstructionMenuItemClick(nil);
  FClickedColumn := -1;
end;

procedure TSystemInfoForm.ListViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  l: TListItem;
  i: integer;
  w,xm: integer;
begin
  FClickedColumn := -1;
  w := 0;
  xm := x;
  xm := x + GetScrollPos(ListView.Handle,SB_HORZ);
  for i := 0 to ListView.Columns.Count -1  do
  begin
    w := w + ListView.Column[i].Width;
    if w >= xm then
    begin
      FClickedColumn := i;
      break;
    end;
  end;
end;

function TSystemInfoForm.TryOpenMarket: Boolean;
var m: TMarket;
begin
  Result := False;
  if ListView.Selected = nil then Exit;
  m := nil;
  if TObject(ListView.Selected.Data) is TMarket then
    m := TMarket(ListView.Selected.Data);
  if TObject(ListView.Selected.Data) is TConstructionDepot then
  begin
    m := DataSrc.MarketFromID(TConstructionDepot(ListView.Selected.Data).LinkedMarketID);
  end;
  if m <> nil then
  begin
    MarketInfoForm.SetMarket(m,false);
    MarketInfoForm.Show;
    Result := True;
  end;
end;

procedure TSystemInfoForm.MarketInfoMenuItemClick(Sender: TObject);
var m: TMarket;
begin
  TryOpenMarket;
end;

procedure TSystemInfoForm.OnEDDataUpdate;
begin
  if Visible then UpdateData;
end;

procedure TSystemInfoForm.SetSystem(s: TStarSystem);
var png: TPngImage;
begin
  if Visible and (FCurrentSystem <> nil) then
    SystemSaveQuery;


  FCurrentSystem := s;

  SysImage.Picture := nil;
  NoPictureLabel.Visible := s.Architect <> '';
  Scrollbox.HorzScrollBar.Position := 0;
  Scrollbox.VertScrollBar.Position := 0;
  ListView.Scroll(0,0);
  FSelectedObj := nil;

  png := TPngImage.Create;
  try
    png.LoadFromFile(FCurrentSystem.ImagePath);
    SysImage.Picture.Assign(png);
    NoPictureLabel.Visible := False;
  except
  end;
  png.Free;


  UpdateData;

  CommentEdit.Text := FCurrentSystem.Comment;
  GoalsEdit.Text := FCurrentSystem.CurrentGoals;
  ObjectivesEdit.Text := FCurrentSystem.Objectives;


  FDataChanged := False;
  FImageChanged := False;


end;


procedure TSystemInfoForm.SysImageClick(Sender: TObject);
//var bmp: TBitmap;
begin
{  bmp := TBitmap.Create;
  bmp.Assign(SysImage.Picture.Graphic);

  with bmp.Canvas do
    TextOut(100,100,'A 1');
  SysImage.Picture.Bitmap.Assign(bmp);}
end;

procedure TSystemInfoForm.SysImageDblClick(Sender: TObject);
begin
  SystemPictForm.SetSystem(FCurrentSystem.StarSystem);
  SystemPictForm.Show;
end;

procedure TSystemInfoForm.SysImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FStartPos := Mouse.CursorPos;
  FScrollPos := TPoint.Create(Scrollbox.HorzScrollBar.Position,Scrollbox.VertScrollBar.Position);
end;

procedure TSystemInfoForm.SysImageMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var pt: TPoint;
begin
  if (ssLeft in Shift) and (FStartPos.X <> -1) then
  begin
    pt := Mouse.CursorPos;
    if (Abs(pt.X-FStartPos.X) > 5) or (Abs(pt.X-FStartPos.Y) > 5) then
    begin
      Scrollbox.HorzScrollBar.Position := FScrollPos.X - (pt.X - FStartPos.X);
      Scrollbox.VertScrollBar.Position := FScrollPos.Y - (pt.Y - FStartPos.Y);
    end;
  end;
end;

procedure TSystemInfoForm.SysImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FStartPos.X := -1;
end;

procedure TSystemInfoForm.SystemAddrLabelDblClick(Sender: TObject);
begin
  Clipboard.AsText := Copy(SystemAddrLabel.Caption,2,200);
end;

procedure TSystemInfoForm.UpdateData;
var  i,i2,idx,cp2idx,cp3idx: Integer;
     s: string;
     item: TListItem;
     sl,t23sl: TStringList;
     ml: TList;
     b: TSystemBody;
     bm: TBaseMarket;
     m: TMarket;
     ct: TConstructionType;
     listUnassigned: Boolean;
     t2penalty,t3penalty: Integer;

     seclev: array [0..2] of Integer;
     devlev: array [0..2] of Integer;
     techlev: array [0..2] of Integer;
     wealthlev: array [0..2] of Integer;
     livlev: array [0..2] of Integer;
     cp2: array [0..2] of Integer;
     cp3: array [0..2] of Integer;
     techBonus: Integer;

   procedure dispStat(lev: array of Integer; lab: TLabel);
   var s: string;
   begin
     s := IntToStr(lev[0]);
     if (lev[1] <> 0) or (lev[2] <> 0) then
     begin
       s := s + ' (' + IntToStr(lev[0]+lev[1]);
       if lev[2] <> 0 then
         s := s + '/' + IntToStr(lev[0]+lev[1]+lev[2]);
       s := s + ')';
     end;
     lab.Caption := s;
   end;
begin
  SaveSelection;

  ListView.Items.Clear;

  if FCurrentSystem = nil then Exit;

  try
    SystemNameLabel.Caption := FCurrentSystem.StarSystem;
    ArchitectLabel.Caption := 'Architect: ' + FCurrentSystem.ArchitectName;
    PopulationLabel.Caption := 'Population: ' + Format('%.0n', [double(FCurrentSystem.Population)]);;
    FactionsLabel.Caption := FCurrentSystem.Factions;
    LastUpdateLabel.Caption := 'Last Update: ' +
      Copy(FCurrentSystem.LastUpdate,1,10) + ' ' + Copy(FCurrentSystem.LastUpdate,12,8) + ' UTC';
    SystemAddrLabel.Caption := '#' + FCurrentSystem.SystemAddress;
    SecurityLabel.Caption := 'Security: ' + FCurrentSystem.SystemSecurity;

    PrimaryLabel.Caption := '(no primary port)';
    if FCurrentSystem.PrimaryPortId <> '' then
    begin
      PrimaryLabel.Caption := '(T1 primary)';
      bm := DataSrc.DepotFromId(FCurrentSystem.PrimaryPortId);
      if bm <> nil then
      begin
        ct := bm.GetConstrType;
        if (ct <> nil) and (ct.Tier >= '2') then
          PrimaryLabel.Caption := '(T2/T3 primary)';
      end;
    end;

    for i := 0 to 2 do
    begin
      seclev[i] := 0;
      devlev[i] := 0;
      techlev[i] := 0;
      wealthlev[i] := 0;
      livlev[i] := 0;
    end;
    techBonus := 35;

    PrimaryLabel.Hint := 'T2/T3 Port Order:' + Chr(13);

    ml := TList.Create;
    sl := TStringList.Create; //orphan market ids
    t23sl := TStringList.Create; //list of t2/t3 stations sorted by finish date
    for i := 0 to DataSrc.Constructions.Count - 1 do
      with TConstructionDepot(DataSrc.Constructions.Objects[i]) do
        if StarSystem = FCurrentSystem.StarSystem then
          if not Simulated and (StationType <> 'FleetCarrier') then
          begin
            ct := GetConstrType;
            if ct <> nil then
            begin
              idx := 0;
              if not Finished then idx := 1;
              if Planned then idx := 2;
              seclev[idx] := seclev[idx] + ct.SecLev;
              devlev[idx] := devlev[idx] + ct.DevLev;
              techlev[idx] := techlev[idx] + ct.TechLev;
              wealthlev[idx] := wealthlev[idx] + ct.WealthLev;
              livlev[idx] := livlev[idx] + ct.StdLivLev;


              //primary port has no CP cost
              if MarketId = FCurrentSystem.PrimaryPortId then
              begin
                if ct.CP2 > 0 then cp2[idx] := cp2[idx] + ct.CP2;
                if ct.CP3 > 0 then cp3[idx] := cp3[idx] + ct.CP3;
              end
              else
              begin
                cp2idx := idx;
                cp3idx := idx;
               //started constructions already use up CPs
                if idx = 1 then
                begin
                  if ct.CP2 < 0 then cp2idx := 0;
                  if ct.CP3 < 0 then cp3idx := 0;
                end;
                cp2[cp2idx] := cp2[cp2idx] + ct.CP2;
                cp3[cp3idx] := cp3[cp3idx] + ct.CP3;
              end;

              if ct.Tier >= '2' then
                if (ct.Category = 'Starport') or (ct.Category = 'Planetary Port') then
                begin
                  techlev[idx] := techlev[idx] + techBonus;
                  techBonus := 0;

                  if MarketId <> FCurrentSystem.PrimaryPortId then
                  begin
                    s := 'B';
                    if Status = '' then s := 'A'; //built before Updated 2 come first?
                    if not Finished then s := 'Y';
                    if Planned then s := 'Z';
                    s := s + FirstUpdate;
                    t23sl.AddObject(s,DataSrc.Constructions.Objects[i]);
                  end
                  else
                    PrimaryLabel.Hint := PrimaryLabel.Hint + StationName + ' (primary)' + Chr(13);
                end;
            end;

            ml.Add(DataSrc.Constructions.Objects[i]);
            if LinkedMarketId <> '' then sl.Add(LinkedMarketId);
          end;

    t23sl.Sort;
    for i := 1 to t23sl.Count do
    begin
      with TConstructionDepot(t23sl.Objects[i-1]) do
      begin
        ct := GetConstrType;
        if i > 2 then
        begin
          t2penalty := -2 * (i-2);
          t3penalty := -6 * (i-2);
          idx := 0;
          if Planned then idx := 2;
          if ct.Tier = '2' then
            cp2[idx] := cp2[idx] + t2penalty;
          if ct.Tier = '3' then
            cp3[idx] := cp3[idx] + t3penalty;
        end;
        PrimaryLabel.Hint := PrimaryLabel.Hint + StationName + ' T' + ct.Tier + Chr(13);
      end;
    end;

    dispStat(seclev,SecLabel);
    dispStat(devlev,devLabel);
    dispStat(techlev,TechLabel);
    dispStat(wealthlev,WealthLabel);
    dispStat(livlev,LivLabel);

    dispStat(cp2,CP2Label);
    dispStat(cp3,CP3Label);

    for i := 0 to DataSrc.RecentMarkets.Count - 1 do
      with TBaseMarket(DataSrc.RecentMarkets.Objects[i]) do
        if StarSystem = FCurrentSystem.StarSystem then
          if StationType <> 'FleetCarrier' then
            if sl.IndexOf(MarketId) = -1 then
              ml.Add(DataSrc.RecentMarkets.Objects[i]);


    try
      ListView.Items.BeginUpdate;
      try

        for i := 0 to FCurrentSystem.Bodies.Count - 1 do
        begin
          b := TSystemBody(FCurrentSystem.Bodies.Objects[i]);
          item := ListView.Items.Add;
          item.Caption := b.BodyName;
          item.SubItems.Add(b.BodyType);
          item.Data := b;
          s := '';
          s := s + b.ReserveLevel;
          item.SubItems.Add(s);
          item.SubItems.Add(IfThen(b.Landable,'Yes',''));
          item.SubItems.Add(b.Atmosphere);
          item.SubItems.Add(FloatToStrF(b.DistanceFromArrivalLS,ffFixed,7,1));
          s := '';
          if b.BiologicalSignals > 0 then s := s + 'Bio: ' + IntToStr(b.BiologicalSignals) + '; ';
          if b.GeologicalSignals > 0 then s := s + 'Geo: ' + IntToStr(b.GeologicalSignals) + '; ';
          if b.HumanSignals > 0 then s := s + 'Hum: ' + IntToStr(b.HumanSignals) + '; ';
          if b.OtherSignals > 0 then s := s + 'Oth: ' + IntToStr(b.OtherSignals) + '; ';
          item.SubItems.Add(s);
          item.SubItems.Add(b.Volcanism);
          item.SubItems.Add(FloatToStrF(b.SurfaceGravity,ffFixed,7,2));
          item.SubItems.Add(IfThen(b.TidalLock,'Yes',''));
          item.SubItems.Add(FloatToStrF(b.OrbitalInclination,ffFixed,7,1));
          item.SubItems.Add(FloatToStrF(b.RotationPeriod,ffFixed,7,1));
          item.SubItems.Add(FloatToStrF(b.OrbitalPeriod,ffFixed,7,1));
          item.SubItems.Add(FloatToStrF(b.SemiMajorAxis,ffFixed,12,1));


          listUnassigned := (i = FCurrentSystem.Bodies.Count - 1);
          for i2 := ml.Count - 1 downto 0  do
          begin
            bm := TBaseMarket(ml[i2]);
            if (bm.Body = b.BodyName) or listUnassigned then
            begin
              ct := DataSrc.ConstructionTypes.TypeById[bm.ConstructionType];
              item := ListView.Items.Add;
              item.Data := bm;
              item.Caption := '';        //🚩🚧🏭◌◍⚪⚫⧂ ⨀ ⦵⦿
              if bm.Body <> b.BodyName then item.Caption := '?';
              m := nil;
              if bm is TMarket then m := TMarket(bm);
              if bm is TConstructionDepot then
              begin
                s := '  ';     //✈🚀🚢⛯⧂ ⚪•🌐🏙🌆🌇💰📋📝✍⛰✏⚒   ⌂🏠🏭  🏗 ⚐ ⚑  ⛿⛺
                //s := s + IfThen((ct <> nil) and (ct.Location = 'Orbital'),'⚪• ','🏭 ');
                //s := s + IfThen(TConstructionDepot(bm).Finished,'','🚧');
                s := s + IfThen(TConstructionDepot(bm).Planned,'✏',
                         IfThen(TConstructionDepot(bm).Finished,'🚩','🚧'));
                if bm.LinkedMarketId <> '' then
                begin
                  m := DataSrc.MarketFromID(bm.LinkedMarketId);
                  if m <> nil then
                  begin
                    s := s + '🛒 ' + m.StationName;
                    //ml.Remove(m);
                  end;
                end
                else
                  s := s + ' ' + bm.StationName;
                item.SubItems.Add(s);
              end
              else
              begin
                item.SubItems.Add('  🛒 '+ bm.StationName);
              end;
              s := '';
              if ct <> nil then
               s := ct.StationType_full;
               if s = '' then
                s := DataSrc.MarketComments.Values[bm.MarketId];
              item.SubItems.Add(s);
              item.SubItems.Add('');
              s := '';
              if m <> nil then s := m.Economies;
              item.SubItems.Add(s);
              item.SubItems.Add('');
              s := '';
              if m <> nil then s := m.Faction_short;
              item.SubItems.Add(s);
              s := '';
              if m <> nil then
              begin
                if Pos('shipyard',m.Services) > 0  then s := s + '🚀SY ';
                if Pos('outfitting',m.Services) > 0  then s := s + '⚒OF ';
                if Pos('exploration',m.Services) > 0  then s := s + '🌐UC ';
              end;
              item.SubItems.Add(s);

              ml.Delete(i2);
            end;
          end;


        end;
      finally
        ListView.Items.EndUpdate;
      end;
    except
    end;
    for i := 0 to ListView.Columns.Count -2 do
    begin
       ListView.Column[i].Width := -2;
    end;

    RestoreSelection;
  finally
    ml.Free;
    sl.Free;
    t23sl.Free;
  end;
end;

procedure TSystemInfoForm.AddConstructionMenuItemClick(Sender: TObject);
begin
  if ListView.Selected = nil then Exit;
  if TObject(ListView.Selected.Data) is TSystemBody then
  begin
    StationInfoForm.NewConstruction(FCurrentSystem,TSystemBody(ListView.Selected.Data).BodyName);
    StationInfoForm.Show;
  end;
  if TObject(ListView.Selected.Data) is TMarket then
  begin
    if Vcl.Dialogs.MessageDlg('This market may be linked to existing construction.' + Chr(13) +
       'Are you sure you want to create a new construction?',
       mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;
    StationInfoForm.AddLinkedConstruction(TMarket(ListView.Selected.Data));
    StationInfoForm.Show;
  end;
end;

procedure TSystemInfoForm.ApplySettings;
var i,fs: Integer;
    fn: string;
    clr: TColor;
begin
  if not Opts.Flags['MarketsDarkMode'] then
  begin
    Color := clSilver;
    Font.Color := clBlack;
  end
  else
  begin
    clr := EDCDForm.TextColLabel.Font.Color;
    Color := $4A4136 - $202020;
    Font.Color := clr;
  end;
  Font.Name := Opts['FontName2'];


  if not Opts.Flags['MarketsDarkMode'] then
  begin
    with ListView do
    begin
      Color := clSilver;
      Font.Color := clBlack;
//      GridLines := True;
    end;
  end
  else
  begin
    clr := EDCDForm.TextColLabel.Font.Color;
    with ListView do
    begin
      Color := $6B5E4F; //$484848; $585140
      Font.Color := clr;
//      GridLines := False;
    end;
  end;
  with ListView do
  begin
    Font.Name := Opts['FontName2'];
    Font.Size := Opts.Int['FontSize2'];
  end;

end;

procedure TSystemInfoForm.SaveSelection;
var r: TRect;
begin
  FListViewVScrollPos := 0;
  if ListView.TopItem <> nil then
  begin
    FListViewVScrollPos := GetScrollPos(ListView.Handle,SB_VERT); //this is not in pixels!
    r := ListView.TopItem.DisplayRect(drBounds);
    FListViewVScrollPos := FListViewVScrollPos * r.Height;
  end;
  FSelectedObj := nil;
  if ListView.Selected <> nil then
  begin
    FSelectedObj := TObject(ListView.Selected.Data);
  end;
end;

procedure TSystemInfoForm.RestoreSelection;
var i: Integer;
begin
  ListView.Scroll(0,FListViewVScrollPos);
  for i := 0 to ListView.Items.Count - 1 do
  begin
    if TObject(ListView.Items[i].Data) = FSelectedObj  then
    begin
      ListView.Items[i].Selected := True;
      ListView.Items[i].Focused := True;
      ListView.ItemIndex := i;
      ListView.Items[i].MakeVisible(false);
      break;
    end;
  end;
end;


end.
