unit SystemInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  DataSource, System.Types, System.Math, System.JSON, System.StrUtils, Vcl.Menus,  Vcl.Imaging.pngimage,
  Winapi.ShellAPI;

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
    InfoPanel2: TPanel;
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
    ReloadPictureMenuItem: TMenuItem;
    Label10: TLabel;
    InduLinksLabel1: TLabel;
    HighLinksLabel1: TLabel;
    RefiLinksLabel1: TLabel;
    AgriLinksLabel1: TLabel;
    ExtrLinksLabel1: TLabel;
    TourLinksLabel1: TLabel;
    MiliLinksLabel1: TLabel;
    N4: TMenuItem;
    AddSignalsSubMenu: TMenuItem;
    AddBioSignalsMenuItem: TMenuItem;
    AddGeoSignalsMenuItem: TMenuItem;
    N5: TMenuItem;
    Reset1: TMenuItem;
    SlotsLabel: TLabel;
    SetAsActiveMenuItem: TMenuItem;
    ResourceReserveSubMenu: TMenuItem;
    PristineReserveMenuItem: TMenuItem;
    Major1: TMenuItem;
    Low1: TMenuItem;
    Depleted1: TMenuItem;
    N6: TMenuItem;
    Reset2: TMenuItem;
    FiltersPanel: TPanel;
    Label9: TLabel;
    PlannedCheck: TCheckBox;
    FilterEdit: TComboBox;
    ClearFilterButton: TButton;
    BodiesCheck: TCheckBox;
    StationsCheck: TCheckBox;
    InProgressCheck: TCheckBox;
    FinishedCheck: TCheckBox;
    EconomiesCheck: TCheckBox;
    Label12: TLabel;
    FiltersCheck: TCheckBox;
    Label13: TLabel;
    ShowUpLinksCheck: TCheckBox;
    Label14: TLabel;
    N7: TMenuItem;
    MarketHistoryMenuItem: TMenuItem;
    GroupAddRemoveMenuItem: TMenuItem;
    Label15: TLabel;
    TaskGroupEdit: TEdit;
    EDSMScanLabel: TLabel;
    PopupMenu3: TPopupMenu;
    IgnoredCheck: TCheckBox;
    IgnoredLabel: TLabel;
    Label0: TLabel;
    ScoreLabel: TLabel;
    BodyCommentMenuItem: TMenuItem;
    SetPrimaryLocationMenuItem: TMenuItem;
    SolverMenuItem: TMenuItem;
    ConstructionTypesMenuItem: TMenuItem;
    LabelsSubMenu: TMenuItem;
    N8: TMenuItem;
    ClearAllLabelsMenuItem: TMenuItem;
    UndoBodyLabelMenuItem: TMenuItem;
    AddLabelsMenuItem: TMenuItem;
    NextPictLabel: TLabel;
    N9: TMenuItem;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    NoLabelsLabel: TLabel;
    BodyInfoPanel: TPanel;
    BodyInfoFrame: TShape;
    BodyInfoLabel: TLabel;
    BodySlotsPanel: TPanel;
    Label23: TLabel;
    OrbSlotsLabel: TLabel;
    SurfSlotsLabel: TLabel;
    Label18: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Label24: TLabel;
    Label30: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    HideSlotEditLabel: TLabel;
    BodyStationsLabel: TLabel;
    Label17: TLabel;
    AlterNameEdit: TEdit;
    FreeSlotsCheck: TCheckBox;
    Label20: TLabel;
    Normal1: TMenuItem;
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
    procedure ReloadPictureMenuItemClick(Sender: TObject);
    procedure AddBioSignalsMenuItemClick(Sender: TObject);
    procedure SetAsActiveMenuItemClick(Sender: TObject);
    procedure SlotsLabelClick(Sender: TObject);
    procedure PristineReserveMenuItemClick(Sender: TObject);
    procedure ClearFilterButtonClick(Sender: TObject);
    procedure BodiesCheckClick(Sender: TObject);
    procedure EconomiesCheckClick(Sender: TObject);
    procedure FiltersCheckClick(Sender: TObject);
    procedure FilterEditChange(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure ShowUpLinksCheckClick(Sender: TObject);
    procedure Label14Click(Sender: TObject);
    procedure MarketHistoryMenuItemClick(Sender: TObject);
    procedure GroupAddRemoveMenuItemClick(Sender: TObject);
    procedure SystemNameLabelClick(Sender: TObject);
    procedure MiliLinksLabel1DblClick(Sender: TObject);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure EDSMScanLabelClick(Sender: TObject);
    procedure PopupMenu3Popup(Sender: TObject);
    procedure ArchitectLabelClick(Sender: TObject);
    procedure ChangeArchitectMenuItemClick(Sender: TObject);
    procedure IgnoredLabelClick(Sender: TObject);
    procedure IgnoredCheckClick(Sender: TObject);
    procedure FactionsLabelDblClick(Sender: TObject);
    procedure BodyCommentMenuItemClick(Sender: TObject);
    procedure SetPrimaryLocationMenuItemClick(Sender: TObject);
    procedure SolverMenuItemClick(Sender: TObject);
    procedure ConstructionTypesMenuItemClick(Sender: TObject);
    procedure AddLabelsMenuItemClick(Sender: TObject);
    procedure ClearAllLabelsMenuItemClick(Sender: TObject);
    procedure BodyLabelClick(Sender: TObject);
    procedure UndoBodyLabelMenuItemClick(Sender: TObject);
    procedure Label16Click(Sender: TObject);
    procedure Label37Click(Sender: TObject);
    procedure OrbSlotsLabelClick(Sender: TObject);
    procedure HideSlotEditLabelClick(Sender: TObject);
    procedure Label20Click(Sender: TObject);
  private
    { Private declarations }
    FCP2,FCP3: Integer;
    FCurrentSystem: TStarSystem;
    FStartPos,FScrollPos: TPoint;
    FImageChanged: Boolean;
    FDataChanged: Boolean;
    FSelectedObj: TObject;
    FListViewVScrollPos: Integer;
    FClickedColumn: Integer;
    FSortColumn: Integer;
    FSortAscending: Boolean;
    FShowEconomies: Boolean;
    FHoldUpdate: Boolean;
    FBodyLabelNr: Integer;
    FLabelMode: Boolean;
    FMouseScroll: Boolean;
    FBodyLabels: TList;
    FSelBodyLabel: TLabel;
    procedure TryPasteImage;
    procedure SavePicture;
    procedure SaveData;
    procedure SystemSaveQuery;
    procedure SaveSelection;
    procedure RestoreSelection;
    function TryOpenMarket: Boolean;
    procedure ResolveConstructions(orgcl: TList);
    procedure GetSystemLinks(cl: TList; var weakLinks: array of TEconomyArray;
      var totWeakLinks: TEconomyArray);
    procedure ResolveBodyLinks(b: TSystemBody; var surfLinks,orbLinks,bwLinks: TEconomyArray);
    procedure ResetFilters;
    function SelectedMarket: TMarket;
    procedure AddPictureLabels;
    procedure UpdateNextBodyLabel;
    procedure ClearBodyLabels;
    procedure AddBodyLabel(x,y: Integer; bodyNr: Integer);
    procedure SelectNearestBody;
    procedure UnselectBodyLabel;
  public
    { Public declarations }
    procedure BeginFilterChange;
    procedure EndFilterChange;
    procedure SetSystem(s: TStarSystem; const selObj: TObject = nil; const stationsOnly: Boolean = false);
    procedure ApplySettings;
    procedure OnEDDataUpdate;
    procedure UpdateView(const keepSel: Boolean = true);
    procedure RestoreAndShow;
    property CurrentSystem: TStarSystem read FCurrentSystem;
    function GetNextConstruction(bm: TBaseMarket): TBaseMarket;
  end;

var
  SystemInfoForm: TSystemInfoForm;

implementation

{$R *.dfm}

uses Markets, Main, Settings, SystemPict, Colonies, Clipbrd, StationInfo,
  MarketInfo, Splash, Solver, ConstrTypes, BodyInfo;

procedure TSystemInfoForm.BeginFilterChange;
begin
  FHoldUpdate := True;

  //this is only needed because changing checkboxes immediately trigger their Clicked event
  //not the case with edits
end;

procedure TSystemInfoForm.EndFilterChange;
begin
  FHoldUpdate := false;
//  UpdateItems;
end;

procedure TSystemInfoForm.ResetFilters;
begin
  BeginFilterChange;
  try
    FilterEdit.Text := '';
    BodiesCheck.Checked := True;
    StationsCheck.Checked := True;
    FinishedCheck.Checked := True;
    InProgressCheck.Checked := True;
    PlannedCheck.Checked := True;
  finally
    EndFilterChange;
  end;
end;

procedure TSystemInfoForm.RestoreAndShow;
begin
  if WindowState = wsMinimized then WindowState := wsNormal;
  Show;
end;

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

procedure TSystemInfoForm.UndoBodyLabelMenuItemClick(Sender: TObject);
begin
  if FBodyLabelNr = 0 then Exit;
  UnselectBodyLabel;
  FBodyLabelNr := FBodyLabelNr - 1;
  TLabel(FBodyLabels[FBodyLabelNr]).Free;
  FBodyLabels.Delete(FBodyLabelNr);
  FDataChanged := True;
  BodyInfoPanel.Visible := False;
  UpdateNextBodyLabel;
end;

procedure TSystemInfoForm.UpdateNextBodyLabel;
begin
  if not FLabelMode then Exit;
  if FBodyLabelNr < FCurrentSystem.Bodies.Count then
    NextPictLabel.Caption :=
      'Next Body: ' +
        TSystemBody(FCurrentSystem.Bodies.Objects[FBodyLabelNr]).BodyName  + '   ' +
        TSystemBody(FCurrentSystem.Bodies.Objects[FBodyLabelNr]).BodyType
  else
    NextPictLabel.Caption := '( no more bodies )';
end;


procedure TSystemInfoForm.ClearAllLabelsMenuItemClick(Sender: TObject);
begin
  ClearBodyLabels;
  BodyInfoPanel.Visible := False;
  FDataChanged := True;
end;

procedure TSystemInfoForm.UnselectBodyLabel;
begin
  if FSelBodyLabel <> nil then
  begin
    FSelBodyLabel.Color := clBlack;
    FSelBodyLabel.Font.Color := clSilver;
  end;
  FSelBodyLabel := nil;
  BodyInfoPanel.Visible := False;
end;

procedure TSystemInfoForm.ClearBodyLabels;
var i: Integer;
begin
  UnselectBodyLabel;
  for i := 0 to FBodyLabels.Count - 1 do
    TLabel(FBodyLabels[i]).Free;
  FBodyLabels.Clear;
  FBodyLabelNr := 0;
  UpdateNextBodyLabel;
end;

procedure TSystemInfoForm.ClearFilterButtonClick(Sender: TObject);
begin
  FilterEdit.Text := '';
  UpdateView(false);
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
  NoLabelsLabel.Visible := False;
  if ColoniesForm.Visible then
    ColoniesForm.UpdateItems;
end;

procedure TSystemInfoForm.BodiesCheckClick(Sender: TObject);
begin
  UpdateView(false);
end;

procedure TSystemInfoForm.BodyCommentMenuItemClick(Sender: TObject);
var s: string;
begin
  if ListView.Selected = nil then Exit;
  if TObject(ListView.Selected.Data) is TSystemBody then
    with TSystemBody(ListView.Selected.Data) do
    begin
      s := Vcl.Dialogs.InputBox('Body', 'Comment', Comment);
      if s <> Comment then
      begin
        FeaturesModified := True;
        Comment := s;
        FCurrentSystem.Save;
        self.UpdateView;
      end;
    end;
end;

procedure TSystemInfoForm.CommentEditChange(Sender: TObject);
begin
  FDataChanged := True;
end;

procedure TSystemInfoForm.ConstructionTypesMenuItemClick(Sender: TObject);
begin
  ConstrTypesForm.Show;
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
    if cd.Simulated then Exit;  //should not happen - these are not listed
    if cd.LastUpdate <> '' then Exit; //journal-based construction
    
    if Vcl.Dialogs.MessageDlg('Delete this construction?',
       mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;
    if StationInfoForm.CurrentStation = cd then StationInfoForm.Close;
    if FCurrentSystem.PrimaryPortId = cd.MarketID then FCurrentSystem.PrimaryPortId := '';
    DataSrc.RemoveConstruction(cd);
    FCurrentSystem.Save;
    if SolverForm.Visible then
      if SolverForm.CurrentSystem = FCurrentSystem then
        SolverForm.SetSystem(FCurrentSystem,FCP2,FCP3);
  end;
end;

procedure TSystemInfoForm.EconomiesCheckClick(Sender: TObject);
var margin: Integer;
begin
  FShowEconomies := not FShowEconomies;
  margin := SecLabel.Top + 4;
  if FShowEconomies then
    InfoPanel2.Height := MiliLinksLabel1.Top + MiliLinksLabel1.Height + margin
  else
    InfoPanel2.Height := SecLabel.Top + SecLabel.Height + margin;
  UpdateView;
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

    if QuickAddAsFinishedMenuItem.Checked then cd.ConstrStatus := csFinished;
    if QuickAddAsPlannedMenuItem.Checked then cd.ConstrStatus := csPlanned;
 
    cd.Modified := True;

    CreateGUID(UUID);
    cd.MarketId := GUIDToString(UUID);
    DataSrc.Constructions.AddObject(cd.MarketID,cd);
    if FCurrentSystem.PrimaryPortId = '' then
      if cd.GetConstrType.IsPort then
        FCurrentSystem.PrimaryPortId := cd.MarketId;
    FCurrentSystem.Save;
    UpdateView;
  end;
end;

procedure TSystemInfoForm.SetAsActiveMenuItemClick(Sender: TObject);
var m: TMarket;
begin
  if ListView.Selected = nil then Exit;

  if  TObject(ListView.Selected.Data) is TConstructionDepot then
    with TConstructionDepot(ListView.Selected.Data) do
      if not Finished then
      begin
        SplashForm.ShowInfo('Switching construction depot...',1000);
        EDCDForm.SetDepot(MarketId,false);
      end;

  m := nil;
  if TObject(ListView.Selected.Data) is TMarket then
    m := TMarket(ListView.Selected.Data);
  if TObject(ListView.Selected.Data) is TConstructionDepot then
  begin
    m := DataSrc.MarketFromID(TConstructionDepot(ListView.Selected.Data).LinkedMarketID);
  end;
  if m <> nil then
    begin
      SplashForm.ShowInfo('Switching market...',1000);
      EDCDForm.SetSecondaryMarket(m.MarketId);
    end;

end;

procedure TSystemInfoForm.SetPrimaryLocationMenuItemClick(Sender: TObject);
var i: Integer;
    b,b2: TSystemBody;
begin
  if ListView.Selected = nil then Exit;
  if TObject(ListView.Selected.Data) is TSystemBody then
  begin
    b := TSystemBody(ListView.Selected.Data);
    b.FeaturesModified := True;
    b.PrimaryLoc := not b.PrimaryLoc;
    if b.PrimaryLoc then
    for i := 0 to FCurrentSystem.Bodies.Count - 1 do
    begin
      b2 := TSystemBody(FCurrentSystem.Bodies.Objects[i]);
      if (b <> b2) and b2.PrimaryLoc then
        b2.PrimaryLoc := False;
    end;
    FCurrentSystem.Save;
    self.UpdateView;
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
    cd.Modified := True;
    FCurrentSystem.Save;
    UpdateView;
  end;
end;

procedure TSystemInfoForm.PopupMenu2Popup(Sender: TObject);
var mf,cdf,bf,orphanf: Boolean;
    sl: TStringList;
    i,d,matchHaul: Integer;
    mitem: TMenuItem;
    ct: TConstructionType;
    matchOrbital: Boolean;
    torb,tsur,s: string;

  procedure buildSubMenu(loc: string; subMenu: TMenuItem);
  var t: string;
      i: Integer;
      mitem: TMenuItem;
  begin
    t := '';
    mitem := TMenuItem.Create(subMenu);
    mitem.Caption := '                     TIER 1';
    mitem.Enabled := False;
    subMenu.Add(mitem);
    for i := 0 to sl.Count - 1 do
    begin
      if TConstructionType(sl.Objects[i]).Location = loc then
      begin
        if (t <> '') and (t <> TConstructionType(sl.Objects[i]).Tier) then
        begin
          mitem := TMenuItem.Create(subMenu);
          mitem.Caption := '-';
          subMenu.Add(mitem);
          mitem := TMenuItem.Create(subMenu);
          mitem.Caption := '                     TIER ' + TConstructionType(sl.Objects[i]).Tier;
          mitem.Enabled := False;
          subMenu.Add(mitem);
        end;
        mitem := TMenuItem.Create(subMenu);
        mitem.Caption := sl[i];
        mitem.Tag := DataSrc.ConstructionTypes.IndexOfObject(sl.Objects[i]);
        mitem.OnClick := QuickAddStationMenuItemClick;
        subMenu.Add(mitem);
        t := TConstructionType(sl.Objects[i]).Tier;
      end;
    end;
  end;
begin
  mf := False;
  cdf := False;
  bf := False;
  if ListView.Selected <> nil then
  begin
    orphanf := TObject(ListView.Selected.Data) is TMarket;
    mf := SelectedMarket <> nil;
    cdf := TObject(ListView.Selected.Data) is TConstructionDepot;
    bf := TObject(ListView.Selected.Data) is TSystemBody;
  end;
  AddConstructionMenuItem.Enabled := bf or orphanf;
  AddSignalsSubMenu.Enabled := bf;
  ResourceReserveSubMenu.Enabled := bf;
  QuickAddOrbitalSubMenu.Enabled := bf;
  QuickAddSurfaceSubMenu.Enabled := bf;
  SetTypeSubMenu.Enabled := cdf;
  DeleteConstructionMenuItem.Enabled := cdf;
  SetAsActiveMenuItem.Enabled := mf or cdf;
  GroupAddRemoveMenuItem.Enabled := cdf;
  MarketInfoMenuItem.Enabled := mf;
  MarketHistoryMenuItem.Enabled := mf;
  //SolverMenuItem.Visible := Opts.Flags['DevMode'];

  BodyCommentMenuItem.Visible := bf;
  SetPrimaryLocationMenuItem.Visible := bf;

  sl := TStringList.Create;
  DataSrc.ConstructionTypes.PopulateList(sl);
  for i := 0 to sl.Count - 1 do
    sl[i] := TConstructionType(sl.Objects[i]).Tier.PadLeft(3,' ') +
      //IntToStr(TConstructionType(sl.Objects[i]).EstCargo).PadLeft(9,'0') +
      sl[i];
  sl.Sort;
  for i := 0 to sl.Count - 1 do
    sl[i] := Copy(sl[i],4,200);

  if QuickAddOrbitalSubMenu.Count = 0 then
  begin
    buildSubMenu('Orbital',QuickAddOrbitalSubMenu);
    buildSubMenu('Surface',QuickAddSurfaceSubMenu);
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

procedure TSystemInfoForm.PopupMenu3Popup(Sender: TObject);
var mitem: TMenuItem;
    var i: Integer;
begin
  PopupMenu3.Items.Clear;
  for i := 0 to DataSrc.Commanders.Count - 1 do
  begin
    mitem := TMenuItem.Create(PopupMenu3);
    mitem.Caption := DataSrc.Commanders.ValueFromIndex[i];
    mitem.Hint := DataSrc.Commanders.ValueFromIndex[i];
    mitem.OnClick := ChangeArchitectMenuItemClick;
    PopupMenu3.Items.Add(mitem);
  end;
  if (FCurrentSystem.Population = 0) and (FCurrentSystem.Architect = '') then
  begin
    mitem := TMenuItem.Create(PopupMenu3);
    mitem.Caption := '(target)';
    mitem.Hint := '(target)';
    mitem.OnClick := ChangeArchitectMenuItemClick;
    PopupMenu3.Items.Add(mitem);
  end;
  mitem := TMenuItem.Create(PopupMenu3);
  mitem.Caption := '-';
  PopupMenu3.Items.Add(mitem);
  mitem := TMenuItem.Create(PopupMenu3);
  mitem.Caption := 'Other...';
  mitem.Hint := '?';
  mitem.OnClick := ChangeArchitectMenuItemClick;
  PopupMenu3.Items.Add(mitem);
  mitem := TMenuItem.Create(PopupMenu3);
  mitem.Caption := 'Clear';
  mitem.Hint := '';
  mitem.OnClick := ChangeArchitectMenuItemClick;
  PopupMenu3.Items.Add(mitem);
end;

procedure TSystemInfoForm.ChangeArchitectMenuItemClick(Sender: TObject);
var s: string;
begin
  s := TMenuItem(Sender).Hint;
  if s = '?' then
  begin
    s := Vcl.Dialogs.InputBox('Architect', 'Name', '');
    if s = '' then Exit;
  end;
  FCurrentSystem.ArchitectName := s;
  FCurrentSystem.UpdateSave;
end;

procedure TSystemInfoForm.ArchitectLabelClick(Sender: TObject);
var pt: TPoint;
begin
  pt.X := ArchitectLabel.Left;
  pt.Y := ArchitectLabel.Top + ArchitectLabel.Height;
  pt := Panel1.ClientToScreen(pt);
  PopupMenu3.Popup(pt.X,pt.Y);
end;

procedure TSystemInfoForm.PopupMenuPopup(Sender: TObject);
var picf: Boolean;
begin
  picf := SysImage.Picture.Width > 0;
  SavePictureMenuItem.Enabled := picf;
  EditPictureMenuItem.Enabled := picf;
  FullPictureMenuItem.Enabled := picf;
  //LabelsSubMenu.Visible := Opts.Flags['DevMode'];
  AddLabelsMenuItem.Checked := FLabelMode;
  UndoBodyLabelMenuItem.Enabled := FLabelMode;
//  ClearAllLabelsMenuItem.Enabled := FLabelMode;
end;

procedure TSystemInfoForm.PristineReserveMenuItemClick(Sender: TObject);
begin
  if ListView.Selected = nil then Exit;
  if TObject(ListView.Selected.Data) is TSystemBody then
    with TSystemBody(ListView.Selected.Data) do
    begin
      FeaturesModified := True;
      case TMenuItem(Sender).Tag of
        0: ReserveLevel := 'Pristine';
        1: ReserveLevel := 'Major';
        2: ReserveLevel := 'Low';
        3: ReserveLevel := 'Depleted';
        4: ReserveLevel := 'Common';
        -1:
          begin
            ReserveLevel := ''; //default
          end;
      end;
      FCurrentSystem.ResetEconomies;
      FCurrentSystem.Save;
    end;
  UpdateView;
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
    NoLabelsLabel.Visible := FBodyLabelNr = 0;

    FImageChanged := True;
  end;
  bmp.Free;
end;

procedure SetChecked(box: TCheckBox; checkedf: Boolean);
var ev: TNotifyEvent;
begin
  ev := box.OnClick;
  box.OnClick := nil;
  box.Checked := checkedf;
  box.OnClick := ev;
end;

procedure TSystemInfoForm.SaveData;
var i: Integer;
    b: TSystemBody;
begin
  if not FDataChanged then Exit;
  FCurrentSystem.Comment := CommentEdit.Text;
  FCurrentSystem.CurrentGoals := GoalsEdit.Text;
  FCurrentSystem.Objectives := ObjectivesEdit.Text;
  FCurrentSystem.TaskGroup := TaskGroupEdit.Text;
  FCurrentSystem.AlterName := AlterNameEdit.Text;
  FCurrentSystem.Ignored := IgnoredCheck.Checked;

  for i := 0 to FCurrentSystem.Bodies.Count - 1 do
    with TSystemBody(FCurrentSystem.Bodies.Objects[i]) do
    begin
      LabelPos.X := 0;
      LabelPos.Y := 0;
    end;

  for i := 0 to FBodyLabels.Count - 1 do
  begin
    b := FCurrentSystem.BodyByName(TLabel(FBodyLabels[i]).Hint);
    if b <> nil then
    begin
      b.LabelPos.X := Scrollbox.HorzScrollBar.Position + TLabel(FBodyLabels[i]).Left;
      b.LabelPos.Y := Scrollbox.VertScrollBar.Position + TLabel(FBodyLabels[i]).Top;
    end;
  end;

  FCurrentSystem.Save;
  FDataChanged := False;
end;

procedure TSystemInfoForm.SaveDataButtonClick(Sender: TObject);
begin
  DataSrc.BeginUpdate;
  try
    SaveData;
    SavePicture;

    if FLabelMode then
      AddLabelsMenuItemClick(nil);
  finally
    DataSrc.EndUpdate;
  end;
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


procedure TSystemInfoForm.EDSMScanLabelClick(Sender: TObject);
begin
  FCurrentSystem.SystemScan_EDSM := '';
  FCurrentSystem.Save;
  UpdateView;
end;

procedure TSystemInfoForm.EDSMScanButtonClick(Sender: TObject);
begin
  if FCurrentSystem.NavBeaconScan then
    if Vcl.Dialogs.MessageDlg('This system already has Nav Beacon/FSS scan. Fetch data from EDSM?',
      mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  FCurrentSystem.UpdateBodies_EDSM;
  FCurrentSystem.Save;
  UpdateView;
end;

procedure TSystemInfoForm.FactionsLabelDblClick(Sender: TObject);
var s: string;
begin
  s := FCurrentSystem.Factions_full;
  if s <> '' then
    ShowMessage(s);
end;

procedure TSystemInfoForm.FilterEditChange(Sender: TObject);
begin
  UpdateView(false);
end;

procedure TSystemInfoForm.FiltersCheckClick(Sender: TObject);
begin
  FiltersPanel.Visible := not FiltersPanel.Visible;
  UpdateView;
end;

procedure TSystemInfoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if self <> SystemInfoForm then
  begin
    Action := caFree;
    DataSrc.RemoveListener(self);
  end;

  if WindowState = wsNormal then
  begin
    Opts['System.Left'] := IntToStr(self.Left);
    Opts['System.Top'] := IntToStr(self.Top);
    Opts['System.Height'] := IntToStr(self.Height);
    Opts['System.Width'] := IntToStr(self.Width);
    Opts.Save;
  end;
end;


procedure TSystemInfoForm.FormCreate(Sender: TObject);
begin
  Panel1.Color := clBlack;
  FStartPos.X := -1;
  InfoPanel2.Height := 32;
  DataSrc.AddListener(self);
  ApplySettings;

  self.Width := StrToIntDef(Opts['System.Width'],self.Width);
  self.Height := StrToIntDef(Opts['System.Height'],self.Height);
  self.Left := StrToIntDef(Opts['System.Left'],(Screen.Width-self.Width) div 2);
  self.Top := StrToIntDef(Opts['System.Top'],(Screen.Height-self.Height) div 2);

  if Opts['Markets.AlphaBlend'] <> '' then
  begin
    AlphaBlendValue := StrToIntDef(Opts['Markets.AlphaBlend'],255);
    AlphaBlend := True;
  end;

  FBodyLabels := TList.Create;

end;


procedure TSystemInfoForm.Label12Click(Sender: TObject);
begin
  EconomiesCheck.Checked := not EconomiesCheck.Checked;
end;

procedure TSystemInfoForm.Label13Click(Sender: TObject);
begin
  FiltersCheck.Checked := not FiltersCheck.Checked;
end;

procedure TSystemInfoForm.Label14Click(Sender: TObject);
begin
  ShowUpLinksCheck.Checked := not ShowUpLinksCheck.Checked;
end;

procedure TSystemInfoForm.Label16Click(Sender: TObject);
var b: TSystemBody;
begin
  if FSelectedObj = nil then Exit;
  if not (FSelectedObj is TSystemBody) then Exit;

  b := TSystemBody(FSelectedObj);
  b.OrbSlots := StrToInt(TLabel(Sender).Caption);
  OrbSlotsLabel.Caption := b.OrbSlots.toString;
  UpdateView;
  RestoreSelection;
  FDataChanged := True;
end;

procedure TSystemInfoForm.Label20Click(Sender: TObject);
begin
  FreeSlotsCheck.Checked := not FreeSlotsCheck.Checked;
end;

procedure TSystemInfoForm.Label37Click(Sender: TObject);
var b: TSystemBody;
begin
  if FSelectedObj = nil then Exit;
  if not (FSelectedObj is TSystemBody) then Exit;

  b := TSystemBody(FSelectedObj);
  b.SurfSlots := StrToInt(TLabel(Sender).Caption);
  SurfSlotsLabel.Caption := b.SurfSlots.toString;
  UpdateView;
  RestoreSelection;
  FDataChanged := True;
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

procedure TSystemInfoForm.ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var s1,s2,b1,b2: string;
    sItem1, sItem2: TListItem;

  function getBody(item: TListItem): string;
  begin
    if TObject(item.Data) is TSystemBody then
      Result := TSystemBody(item.Data).BodyName
    else
      Result := TBaseMarket(item.Data).Body;
  end;
begin
{
  Compare := 0;

  sItem1 := Item1;
  sItem2 := Item2;

  if BodiesCheck.Checked then
  begin
    if Item1.SubItems.Objects[0] <> nil then
      sItem1 := TListItem(Item1.SubItems.Objects[0]);
    if Item2.SubItems.Objects[0] <> nil then
      sItem2 := TListItem(Item2.SubItems.Objects[0]);
  end;

  b1 := getBody(sItem1);
  b2 := getBody(sItem2);
  if FSortColumn <= 0 then
  begin
    s1 := b1;
    s2 := b2;
  end
  else
  if FSortColumn <= 8 then
  begin
    s1 := sItem1.SubItems[FSortColumn-1] + b1;
    s2 := sItem2.SubItems[FSortColumn-1] + b2;
  end
  else
  begin
    s1 := sItem1.SubItems[FSortColumn-1].PadLeft(20) + b1;
    s2 := sItem2.SubItems[FSortColumn-1].PadLeft(20) + b2;
  end;

  Compare := CompareText(s1,s2);
  if not FSortAscending then Compare := -Compare;
  }
end;

procedure TSystemInfoForm.ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var r: TRect;
    i,x: Integer;
begin
  if (cdsSelected in State) or (cdsFocused in State) then
  begin
    Sender.Canvas.Brush.Color := clHighLight;
  end
  else
  begin
    Sender.Canvas.Brush.Color := ListView.Color;
    if Item.Index mod 2 = 0 then
      Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color - $202020;
  end;

  if (cdsSelected in State) or (cdsFocused in State) then
    Sender.Canvas.Font.Color := clWhite
  else
  if (TObject(Item.Data) is TBaseMarket) then
  begin
    if ListView.Font.Color = clBlack then
      Sender.Canvas.Font.Color := clNavy
    else
      Sender.Canvas.Font.Color := clSilver;
  end
  else
  if Item.SubItems[0].StartsWith('  ◌')  then
  begin
    if Pos('-',Item.SubItems[0]) > 0 then
      Sender.Canvas.Font.Color := $4040C0
    else
    if ListView.Font.Color = clBlack then
      Sender.Canvas.Font.Color := $404040
    else
      Sender.Canvas.Font.Color := clGray; //$40A040
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

  if FClickedColumn = 3 then
    if TryOpenMarket then Exit;

  if data is TConstructionDepot then
  begin
    if TConstructionDepot(data).Simulated then Exit;
    StationInfoForm.SetStation(TBaseMarket(data));
    StationInfoForm.RestoreAndShow;
  end;

  if data is TSystemBody then
  begin
    //if FClickedColumn = 4 then
    //  BodyCommentMenuItemClick(nil)
    //else
    begin
      BodyInfoForm.SetBody(TSystemBody(data));
      BodyInfoForm.RestoreAndShow;
    end;
  end;


  if data is TMarket then
    ShowMessage('Link this market to its construction, or choose Add Construction command to create one.');
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
  m := SelectedMarket;
  if m <> nil then
  begin
    MarketInfoForm.SetMarket(m,false);
    MarketInfoForm.Show;
    Result := True;
  end;
end;

function TSystemInfoForm.SelectedMarket: TMarket;
begin
  Result := nil;
  if ListView.Selected = nil then Exit;
  if TObject(ListView.Selected.Data) is TMarket then
    Result := TMarket(ListView.Selected.Data);
  if TObject(ListView.Selected.Data) is TConstructionDepot then
  if TConstructionDepot(ListView.Selected.Data).LinkedMarketID <> '' then
    Result := DataSrc.MarketFromID(TConstructionDepot(ListView.Selected.Data).LinkedMarketID);
end;

procedure TSystemInfoForm.GroupAddRemoveMenuItemClick(Sender: TObject);
begin
  if ListView.Selected = nil then Exit;
  if TObject(ListView.Selected.Data) is TConstructionDepot then
    EDCDForm.AddDepotToGroup(TConstructionDepot(ListView.Selected.Data));
end;

procedure TSystemInfoForm.HideSlotEditLabelClick(Sender: TObject);
begin
  BodySlotsPanel.Width := Label16.Left;
end;

procedure TSystemInfoForm.IgnoredCheckClick(Sender: TObject);
begin
  if not (GetKeyState(VK_SHIFT) < 0) then
  begin
    ShowMessage('Hold Shift to toggle this option.');
    SetChecked(TCheckBox(Sender),not TCheckBox(Sender).Checked);
    Exit;
  end;
  FDataChanged := True;
end;

procedure TSystemInfoForm.IgnoredLabelClick(Sender: TObject);
begin
  IgnoredCheck.Checked := not IgnoredCheck.Checked;
end;

procedure TSystemInfoForm.MarketHistoryMenuItemClick(Sender: TObject);
var m: TMarket;
begin
  m := SelectedMarket;
  if m <> nil then
    MarketsForm.ShowMarketHistory(m);
end;

procedure TSystemInfoForm.MarketInfoMenuItemClick(Sender: TObject);
var m: TMarket;
begin
  TryOpenMarket;
end;

procedure TSystemInfoForm.MiliLinksLabel1DblClick(Sender: TObject);
begin
  ResetFilters;
  BeginFilterChange;
  try
    FiltersCheck.Checked := True;
    EconomiesCheck.Checked := True;
    FilterEdit.Text := '🔗' + LeftStr(TLabel(Sender).Caption,4);
  finally
    EndFilterChange;
    UpdateView;
  end;
end;

procedure TSystemInfoForm.OnEDDataUpdate;
begin
  if Visible then UpdateView;
end;

procedure TSystemInfoForm.OrbSlotsLabelClick(Sender: TObject);
begin
  BodySlotsPanel.Width := HideSlotEditLabel.Left + HideSlotEditLabel.Width + 2;
end;

procedure TSystemInfoForm.AddPictureLabels;
var i: Integer;
begin
  FBodyLabelNr := 0;
  for i := 0 to FCurrentSystem.Bodies.Count - 1 do
    with TSystemBody(FCurrentSystem.Bodies.Objects[i]) do
    if LabelPos.X > 0 then
    begin
      AddBodyLabel(LabelPos.X,LabelPos.Y,i);
      FBodyLabelNr := i + 1;
    end;
end;

procedure TSystemInfoForm.SetSystem(s: TStarSystem; const selObj: TObject = nil;
  const stationsOnly: Boolean = false);
var png: TPngImage;
begin
  if Visible and (FCurrentSystem <> nil) then
    SystemSaveQuery;


  FCurrentSystem := s;

  ListView.Items.Clear;
  ResetFilters;
  SysImage.Picture := nil;
  NoPictureLabel.Visible := s.Architect <> '';
  NoLabelsLabel.Visible := False;
  Scrollbox.HorzScrollBar.Position := 0;
  Scrollbox.VertScrollBar.Position := 0;
  ListView.Scroll(0,0);
  FSelectedObj := nil;

  ClearBodyLabels;
  png := TPngImage.Create;
  try
    png.LoadFromFile(FCurrentSystem.ImagePath);
    SysImage.Picture.Assign(png);
    AddPictureLabels;
    NoPictureLabel.Visible := False;
    NoLabelsLabel.Visible := FBodyLabelNr = 0;
  except
  end;
  png.Free;

  FLabelMode := False;
  NextPictLabel.Visible := False;
  BodyInfoPanel.Visible := False;
  BodySlotsPanel.Width := Label16.Left;


  CommentEdit.Text := FCurrentSystem.Comment;
  GoalsEdit.Text := FCurrentSystem.CurrentGoals;
  ObjectivesEdit.Text := FCurrentSystem.Objectives;
  TaskGroupEdit.Text := FCurrentSystem.TaskGroup;
  AlterNameEdit.Text := FCurrentSystem.AlterName;
  SetChecked(IgnoredCheck,FCurrentSystem.Ignored);

  FDataChanged := False;
  FImageChanged := False;

  if stationsOnly then
  begin
    BeginFilterChange;
    try
      FiltersCheck.Checked := True;
      BodiesCheck.Checked := False;
    finally
      EndFilterChange;
    end;
  end;


  UpdateView;
  if selObj <> nil then
  begin
    FSelectedObj := selObj;
    RestoreSelection;
  end;
end;

procedure TSystemInfoForm.ShowUpLinksCheckClick(Sender: TObject);
begin
  UpdateView;
end;

procedure TSystemInfoForm.SlotsLabelClick(Sender: TObject);
var sarr: TStringDynArray;
    s,orgs: string;
    i,orbTaken,surfTaken: Integer;
    ct: TConstructionType;
begin
  orbTaken := 0;
  surfTaken := 0;
  for i := 0 to DataSrc.Constructions.Count - 1 do
    with TConstructionDepot(DataSrc.Constructions.Objects[i]) do
      if not Cancelled then
      if not Planned and (StarSystem = FCurrentSystem.StarSystem) then
      begin
        ct := GetConstrType;
        if ct <> nil then
          if ct.IsOrbital then
            Inc(orbTaken)
          else
            Inc(surfTaken);
      end;


  orgs := IntToStr(Max(FCurrentSystem.OrbitalSlots - orbTaken,0)) + '/' +
    IntToStr(Max(FCurrentSystem.SurfaceSlots - surfTaken,0));
  s := Vcl.Dialogs.InputBox(FCurrentSystem.StarSystem, 'CURRENT FREE Orbital / Surface Slots', orgs);
  if s <> orgs then
  begin
    if s = '' then
    begin
      FCurrentSystem.OrbitalSlots := 0;
      FCurrentSystem.SurfaceSlots := 0;
    end
    else
    begin
      sarr := SplitString(s,'/');
      if High(sarr) <> 1 then
      begin
        ShowMessage('Invalid slots');
        Exit;
      end;
      FCurrentSystem.OrbitalSlots := StrToIntDef(sarr[0],0) + orbTaken;
      FCurrentSystem.SurfaceSlots := StrToIntDef(sarr[1],0) + surfTaken;
    end;
    FCurrentSystem.Save;
    UpdateView;
  end;
end;

procedure TSystemInfoForm.SolverMenuItemClick(Sender: TObject);
var sf: TSolverForm;
begin
  if GetKeyState(VK_SHIFT) < 0 then
  begin
    sf := TSolverForm.Create(Application);
    sf.SetSystem(FCurrentSystem,FCP2,FCP3,true);
    sf.Show;
    Exit;
  end;

  if not SolverForm.Visible or (SolverForm.CurrentSystem <> FCurrentSystem) then
    SolverForm.SetSystem(FCurrentSystem,FCP2,FCP3,true);
  SolverForm.Show;
end;

procedure TSystemInfoForm.BodyLabelClick(Sender: TObject);
var b: TSystemBody;
    s,bodyInfo: string;
    i,orbSlots,surfSlots: Integer;

    procedure addData(title,txt: string; const newLinef: Boolean = false);
    var s: string;
    begin
      if txt = '' then Exit;
      if title <> '' then s := s + title + ': ';
      s := s + txt;
      bodyInfo := bodyInfo + s + '  ';
      if newLinef then
        bodyInfo := bodyInfo + Chr(13);
    end;

    procedure newLine;
    begin
      bodyInfo := bodyInfo + Chr(13);
    end;

begin
  if Sender = FSelBodyLabel then
  begin
    UnselectBodyLabel;
    Exit;
  end;

  if FSelBodyLabel <> nil then
  begin
    FSelBodyLabel.Color := clBlack;
    FSelBodyLabel.Font.Color := clSilver;
  end;

  FSelBodyLabel := TLabel(Sender);
  FSelBodyLabel.Color := clSilver;
  FSelBodyLabel.Font.Color := clBlack;

  if FLabelMode then Exit;

  b := FCurrentSystem.BodyByName(TLabel(Sender).Hint);
  if b <> nil then
  begin
    FSelectedObj := b;
    RestoreSelection;
  end;

  bodyInfo := '';
  addData('',b.BodyType,true);
  addData('',b.Comment,true);
  addData('Econ.',b.Economies_nice,true);
  if b.BiologicalSignals > 0 then s := s + 'Bio: ' + IntToStr(b.BiologicalSignals) + '; ';
  if b.GeologicalSignals > 0 then s := s + 'Geo: ' + IntToStr(b.GeologicalSignals) + '; ';
  if b.HumanSignals > 0 then s := s + 'Hum: ' + IntToStr(b.HumanSignals) + '; ';
  if b.OtherSignals > 0 then s := s + 'Oth: ' + IntToStr(b.OtherSignals) + '; ';
  addData('Signals',s,true);

  addData('Dist.',FloatToStrF(b.DistanceFromArrivalLS,ffFixed,7,1));
  if b.SurfaceGravity > 0 then
    addData('Gravity',FloatToStrF(b.SurfaceGravity,ffFixed,7,2));
  if b.IsMoon and (Abs(b.OrbitalInclination) > 0.1) then
    addData('Orb. Incl.',FloatToStrF(b.OrbitalInclination,ffFixed,7,1));
  newLine;

  addData('Volcanism',IfThen(b.Volcanism <> '','Yes',''));
  addData('Tidal Lock',IfThen(b.TidalLock,'Yes',''));
  addData('Terraform.',IfThen(b.Terraformable,'Yes',''));
  newLine;

  if FLabelMode then
    bodyInfo := bodyInfo + '(Click at new position to move this label)';
  bodyInfo := Trim(bodyInfo);
  BodyInfoLabel.Caption := bodyInfo;

  OrbSlotsLabel.Caption := b.OrbSlots.toString;
  SurfSlotsLabel.Caption := b.SurfSlots.toString;

  BodySlotsPanel.Top := BodyInfoLabel.Height + 2;

  orbSlots := b.OrbSlots;
  surfSlots := b.SurfSlots;

  if not b.IsRing then
  begin
    s := '';
    if b.OrbSlots + b.SurfSlots = 0  then
      s := '⯇click to edit slots' + Chr(13); //←
    for i := 0 to b.Constructions.Count - 1 do
    begin
      if TObject(b.Constructions[i]) is TConstructionDepot then
        with TConstructionDepot(b.Constructions[i]) do
        if not Cancelled then
        begin
          s := s + IfThen(Planned,'✏',
                   IfThen(Finished,'🚩','🚧'));
          s := s + IfThen(IsOrbital,'⚪•','🏭');
          s := s + ' ' + CurStationName;
          if GetConstrType <> nil then
            s := s + ' (' + GetConstrType.StationType_abbrev + ')';
          s := s + Chr(13);

          if IsOrbital then
            Dec(orbSlots)
          else
            Dec(surfSlots);
        end;
    end;

    if (b.OrbSlots + b.SurfSlots) > 0  then
    if (orbSlots <> 0) or (surfSlots <> 0) then
      s := s + '( free: ' +
                    IfThen(orbSlots<>0,' ⚪• ' + orbSlots.toString + '  ','') +
                    IfThen(surfSlots<>0,' 🏭 ' + surfSlots.toString,'') + ' )';
    BodyStationsLabel.Caption := s;

    BodyStationsLabel.Top := BodyInfoLabel.Top + BodyInfoLabel.Height;
    BodySlotsPanel.Visible := True;
    BodySlotsPanel.Height := Max(
      BodyStationsLabel.Height,
      SurfSlotsLabel.Top + SurfSlotsLabel.Height);
  end
  else
  begin
    BodyStationsLabel.Caption := '(ring - check parent body)';
    BodyStationsLabel.Top := BodyInfoLabel.Top + BodyInfoLabel.Height;
    BodySlotsPanel.Visible := False;
    BodySlotsPanel.Height := 0;
  end;



  BodyInfoPanel.Left := TLabel(Sender).Left;
  BodyInfoPanel.Top := TLabel(Sender).Top + TLabel(Sender).Height + 2;
  BodyInfoPanel.Width := Max(
    BodyInfoLabel.Left + BodyInfoLabel.Width + 2, Max(
    BodyStationsLabel.Left + BodyStationsLabel.Width + 4,
    HideSlotEditLabel.Left + HideSlotEditLabel.Width + 2));
  BodyInfoPanel.Height := BodyInfoLabel.Height +
    Max(BodySlotsPanel.Height + 4,BodyStationsLabel.Height + 4);
  BodyInfoPanel.Visible := True;

  BodyInfoPanel.BringToFront;

end;

procedure TSystemInfoForm.SelectNearestBody;
var b: TSystemBody;
    lbl: TLabel;
    pt: TPoint;
    d,mind: Extended;
    i: Integer;
begin
  lbl := nil;
  pt := Mouse.CursorPos;
  pt := SysImage.ScreenToClient(pt);
  mind := 1000000;

  for i := 0 to FBodyLabels.Count - 1 do
  with TLabel(FBodyLabels[i]) do
  begin
    d := Sqrt(Sqr(Left-pt.X) + Sqr(Top-pt.Y));
    if d < mind then
    begin
      lbl := TLabel(FBodyLabels[i]);
      mind := d;
    end;
  end;
  if lbl = nil then Exit;
  

  b := FCurrentSystem.BodyByName(lbl.Hint);
  if b <> nil then
  begin
    FSelectedObj := b;
    RestoreSelection;
  end;
end;

procedure TSystemInfoForm.AddBodyLabel(x,y: Integer; bodyNr: Integer);
var lbl: TLabel;
    b: TSystemBody;
    s: string;
begin
  b := TSystemBody(FCurrentSystem.Bodies.Objects[bodyNr]);

  lbl := TLabel.Create(ScrollBox);
  lbl.Parent := ScrollBox;
  lbl.ParentFont := True;
  lbl.Font.Color := clSilver;
  lbl.Font.Size := Opts.Int['FontSize2'] - 1;
  lbl.Transparent := False;
  lbl.Color := $202020; //clBlack;
  lbl.Left := x;
  lbl.Top := y;
  lbl.Visible := True;
  lbl.Hint := b.BodyName;
  if lbl.Hint = '' then
    lbl.Caption := '( Primary )'
  else
    lbl.Caption := ' ' + lbl.Hint + ' ';

//test
{
  lbl.Caption := lbl.Caption + ' ' +
              IfThen(b.OrbSlots<>0,'⚪• ','') +
              IfThen(b.SurfSlots<>0,'🏭','');
}
  lbl.OnClick := BodyLabelClick;
  lbl.BringToFront;
  FBodyLabels.Add(lbl);
end;

procedure TSystemInfoForm.SysImageClick(Sender: TObject);
var pt: TPoint;
    lbl: TLabel;
begin

  if not FLabelMode then
  begin
    UnselectBodyLabel;
    Exit;
  end;

  pt := Mouse.CursorPos;
  pt := ScrollBox.ScreenToClient(pt);
  pt.X := (pt.X div 10) * 10;
  pt.Y := (pt.Y div 10) * 10;

  if GetKeyState(VK_SHIFT) < 0 then
  begin
    UndoBodyLabelMenuItemClick(nil);
    Exit;
  end;


  if FSelBodyLabel <> nil then
  begin
    FSelBodyLabel.Left := pt.X;
    FSelBodyLabel.Top := pt.Y;
    UnselectBodyLabel;
    FDataChanged := True;
    Exit;
  end;

  if FBodyLabelNr >= FCurrentSystem.Bodies.Count then Exit;

  AddBodyLabel(pt.X,pt.Y,FBodyLabelNr);
  FDataChanged := True;

  Inc(FBodyLabelNr);
  UpdateNextBodyLabel;

end;

procedure TSystemInfoForm.SysImageDblClick(Sender: TObject);
begin
  if FLabelMode then Exit;
  
  SystemPictForm.SetSystem(FCurrentSystem.StarSystem);
  SystemPictForm.Show;
end;

procedure TSystemInfoForm.SysImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FStartPos := Mouse.CursorPos;
  FScrollPos := TPoint.Create(Scrollbox.HorzScrollBar.Position,Scrollbox.VertScrollBar.Position);
  FMouseScroll := False;
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
      FMouseScroll := True;
    end;
  end;
end;

procedure TSystemInfoForm.SysImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FStartPos.X := -1;
  if not FMouseScroll then
    SelectNearestBody;
  FMouseScroll := False;
end;

procedure TSystemInfoForm.SystemAddrLabelDblClick(Sender: TObject);
begin
  Clipboard.AsText := Copy(SystemAddrLabel.Caption,2,200);
end;

procedure TSystemInfoForm.SystemNameLabelClick(Sender: TObject);
begin
  Clipboard.AsText := SystemNameLabel.Caption;
  SplashForm.ShowInfo('System name copied...',1000);
end;

function CompareConstr(Item1, Item2: Pointer): Integer;
var s1,s2: string;
begin
  Result := 0;
  try
    s1 := Ord(TBaseMarket(Item1).IsOrbital).ToString + TBaseMarket(Item1).LastUpdate;
    s2 := Ord(TBaseMarket(Item2).IsOrbital).ToString + TBaseMarket(Item2).LastUpdate;
    Result := CompareText(s1,s2);
  except
  end;
end;

function CompareConstr2(Item1, Item2: Pointer): Integer;
var idx1,idx2: Integer;
begin
  Result := 0;
  try
    idx1 := 0;
    if not TConstructionDepot(Item1).Finished then idx1 := 1;
    if TConstructionDepot(Item1).Planned then idx1 := 2;
    idx2 := 0;
    if not TConstructionDepot(Item2).Finished then idx2 := 1;
    if TConstructionDepot(Item2).Planned then idx2 := 2;
    Result := CompareValue(idx1,idx2);
  except
  end;
end;

//assign construction to bodies and find link hubs (ports that accept strong links)
procedure TSystemInfoForm.ResolveConstructions(orgcl: TList);
var i,i2: Integer;
    b,pb: TSystemBody;
    surfFirstSeq,orbFirstSeq: string;
    cd: TConstructionDepot;
    ct: TConstructionType;
    s: string;
    remcl: TList;
begin
  if FCurrentSystem.Bodies.Count = 0 then Exit;

  remcl := TList.Create;
  remcl.Assign(orgcl);

  for i := 0 to remcl.Count - 1 do
    with TConstructionDepot(remcl[i]) do
    begin
      LinkHub := False;
      IsOrphan := False;
    end;

  for i := 0 to FCurrentSystem.Bodies.Count - 1 do
  begin
    b := TSystemBody(FCurrentSystem.Bodies.Objects[i]);
    if b.Constructions = nil then
      b.Constructions := TList.Create
    else
      b.Constructions.Clear;
    b.SurfLinkHub := nil;
    b.OrbLinkHub := nil;
  end;

  for i := 0 to FCurrentSystem.Bodies.Count - 1 do
  begin
    b := TSystemBody(FCurrentSystem.Bodies.Objects[i]);
    pb := nil; //add constructions to main body c.list as well if rings present
    if b.IsRing then
      pb := b.ParentBody;
    for i2 := remcl.Count - 1 downto 0 do
      if TConstructionDepot(remcl[i2]).Body = b.BodyName then
      begin
        b.Constructions.Add(remcl[i2]);
        if pb <> nil then
          pb.Constructions.Add(remcl[i2]);
        remcl.Delete(i2);
      end;
  end;

  //orphans go to main star
  for i := 0 to remcl.Count - 1 do
  begin
    TConstructionDepot(remcl[i]).IsOrphan := True;
    TSystemBody(FCurrentSystem.Bodies.Objects[0]).Constructions.Add(remcl[i]);
  end;


  for i := 0 to FCurrentSystem.Bodies.Count - 1 do
  begin
    b := TSystemBody(FCurrentSystem.Bodies.Objects[i]);
    if b.IsRing then continue;

    b.Constructions.Sort(@CompareConstr);

    surfFirstSeq := ''; //build sequence tag
    orbFirstSeq := '';

    //find body surface and orbital hub for links
    for i2 := 0 to b.Constructions.Count - 1 do
    begin
      cd := TConstructionDepot(b.Constructions[i2]);
      ct := cd.GetConstrType;
      if ct <> nil then
      begin
        if ct.IsPort then
        begin
          s := IntToStr(9 - StrToIntDef(ct.Tier,0)); //higher tier ports go first
          s := s + IntToStr(cd.BuildOrder).PadLeft(6,'0'); //earlier builds go first
          s := s + cd.FirstUpdate;
          if ct.Location = 'Orbital' then
            if (orbFirstSeq = '') or (s < orbFirstSeq) then
            begin
              orbFirstSeq := s;
              b.OrbLinkHub := cd;
            end;

          if ct.Location = 'Surface' then
            if (surfFirstSeq = '') or (s < surfFirstSeq) then
            begin
              surfFirstSeq := s;
              b.SurfLinkHub := cd;
            end;
        end;

      end;
    end;
    if b.OrbLinkHub <> nil then b.OrbLinkHub.LinkHub := True;
    if b.SurfLinkHub <> nil then b.SurfLinkHub.LinkHub := True;
  end;
  remcl.Free;
end;


procedure TSystemInfoForm.GetSystemLinks(cl: TList; var weakLinks: array of TEconomyArray;
  var totWeakLinks: TEconomyArray);
var i,bi,idx: Integer;
    cd: TConstructionDepot;
    ct: TConstructionType;
    s: string;
    ei: TEconomy;
    wLink: TEconomyArray;
    b: TSystemBody;
begin
  for i := 0 to cl.Count - 1 do
  begin
    cd := TConstructionDepot(cl[i]);
    //ports that accept links (link hubs) do not generate weak links
    //ports that are only linking to other ports work like facilities and generate weak links
    //however, colony ports that are only linking to other ports
    //also generate weak links from planetary influence (sick!)
    if cd.LinkHub then continue;
    ct := cd.GetConstrType;
    if ct <> nil then
    begin
      idx := 0;
      if not cd.Finished then idx := 1;
      if cd.Planned then idx := 2;
      b := FCurrentSystem.BodyByName(cd.Body);
      wLink := DataSrc.EconomySets.GetWeakLinkEconomies(cd,b);
      AddEconomies(weakLinks[idx],wLink);
      AddEconomies(totWeakLinks,wLink);
    end;
  end;
end;

procedure TSystemInfoForm.ResolveBodyLinks(b: TSystemBody; var surfLinks,orbLinks,bwLinks: TEconomyArray);
var i: Integer;
    cd: TConstructionDepot;
    ct: TConstructionType;
    s: string;
    ei: TEconomy;
    cLink,wLink: TEconomyArray;
begin
  ClearEconomies(surfLinks);
  ClearEconomies(orbLinks);
  ClearEconomies(bwLinks);

  //sum up body stations weak links, to deduct them from system weak links
  for i := 0 to b.Constructions.Count - 1 do
  begin
    cd := TConstructionDepot(b.Constructions[i]);
    if cd.LinkHub then continue;
    ct := cd.GetConstrType;
    if ct <> nil then
      AddEconomies(bwLinks,DataSrc.EconomySets.GetWeakLinkEconomies(cd,b));
  end;

  //find strong links for surface and orbital link hub
  for i := 0 to b.Constructions.Count - 1 do
    if b.Constructions[i] <> b.OrbLinkHub then
    begin
      cd := TConstructionDepot(b.Constructions[i]);
      ct := cd.GetConstrType;
      if ct <> nil then
      begin
        if ct.Economy = 'Colony' then
          cLink := DataSrc.EconomySets.GetUpLinkEconomies(cd,b)
        else
          cLink := DataSrc.EconomySets.GetLinkEconomies(cd,b);

        for ei := Low(TEconomy) to High(TEconomy) do
        begin
          orbLinks[ei] := orbLinks[ei] + cLink[ei];

          if b.Constructions[i] <> b.SurfLinkHub then
            //this is tricky, orbital installations influence surface port
            //only if there is no orbital port
            if not ct.IsOrbital or (b.OrbLinkHub = nil) then
              surfLinks[ei] := surfLinks[ei] + cLink[ei];
        end;
      end;
    end;

end;

procedure TSystemInfoForm.UpdateView(const keepSel: Boolean = true);
var  i,i2,idx,cp2idx,cp3idx,curCol: Integer;
     s,s2,comment: string;
     sl,t23sl,row: TStringList;
     cl: TList;
     b: TSystemBody;
     bm: TBaseMarket;
     cd,cd2: TConstructionDepot;
     m: TMarket;
     ct: TConstructionType;
     t2penalty,t3penalty: Integer;
     colMaxLen: array [0..100] of Integer;
     colMaxTxt: array [0..100] of string;
     filters: Boolean;
     fs: string;
     fsarr: TStringDynArray;

     score: array [0..2] of Integer;
     seclev: array [0..2] of Integer;
     devlev: array [0..2] of Integer;
     techlev: array [0..2] of Integer;
     wealthlev: array [0..2] of Integer;
     livlev: array [0..2] of Integer;
     cp2: array [0..2] of Integer;
     cp3: array [0..2] of Integer;
     techBonus: Integer;
     weakLinks: array [0..3] of TEconomyArray;
     totWeakLinks: TEconomyArray;
     orbSlotsTaken: array [0..2] of Integer;
     surfSlotsTaken: array [0..2] of Integer;
     orbFree,surfFree: Integer;
     cEconomies,orbLinks,surfLinks,wLinks,bwLinks: TEconomyArray;
     curEco,calcEco: string;
     ei: TEconomy;
     eb: TSystemBody;

     orbSlots,surfSlots: Integer;

  procedure addRow(data: TObject);
  var i,ln,idx: Integer;
     item: TListItem;
  begin
    for i := 0 to row.Count - 1 do
    begin
      idx := Pos('|',row[i]);
      if idx > 0 then
        row[i] := Copy(row[i],1,idx-1);
      ln := Length(row[i]);
      if ln > colMaxLen[i] then
      begin
        colMaxLen[i] := ln;
        colMaxTxt[i] := row[i];
      end;
    end;

    item := ListView.Items.Add;
    item.Data := data;
    item.Caption := row[0];
    row.Delete(0);
    item.SubItems.Assign(row);
  end;

  procedure addCaption(s: string);
  begin
    row.Clear;
    row.Add(s);
  end;

  procedure addSubItem(s: string; const addColCapf: Boolean = false);
  var curCol: Integer;
  begin
    if addColCapf and (s <> '') then
    begin
      curCol := row.Count;
      row.Add(s + '|' + ListView.Columns[curCol].Caption);
    end
    else
      row.Add(s);
  end;

   procedure dispStat(lev: array of Integer; lab: TLabel);
   var s: string;
   begin
     s := IntToStr(lev[0]);
     if (lev[1] <> 0) or (lev[2] <> 0) then
     begin
       s := s + '  (';
{
       if lev[2] <> 0 then
         s := s + '' + IntToStr(lev[0]+lev[1]+lev[2])
       else
         s := s + '' + IntToStr(lev[0]+lev[1]);
}

       if lev[1] <> 0 then
       begin
         s := s + '' + IntToStr(lev[0]+lev[1]); //🚧
         if lev[2] <> 0 then s := s + '/';
       end;
       if lev[2] <> 0 then
         s := s + '' + IntToStr(lev[0]+lev[1]+lev[2]); //✏


       s := s + ')';
     end;
     lab.Caption := s;
   end;

   procedure dispLinks(ei: TEconomy);
   var lab: TLabel;
       s: string;
       i: Integer;
       wl: array [0..2] of Extended;
       etyp: string;
   begin
     etyp := LeftStr(cEconomyNames[ei],4);
     lab := TLabel(FindComponent(etyp + 'LinksLabel1'));
     if lab = nil then Exit;
     if lab.Tag = 0 then lab.Tag := lab.Color;
     lab.Color := lab.Tag;
     lab.Font.Color := clBlack;
//     if wl[0] = 0 then
//       lab.Color := lab.Color + $202020;
     for i := 0 to 2 do
       wl[i] := weakLinks[i][ei];
     if wl[0]+wl[1]+wl[2] = 0 then
     begin
       lab.Color := clGray;
       lab.Font.Color := clSilver;
     end;
     if wl[0] = 0 then
       s := '--'
     else
       s := FloatToStrF(wl[0],ffFixed,7,2,JSONFrmt);

     if (wl[1] <> 0) or (wl[2] <> 0) then
     begin
       if wl[0]+wl[1] = 0 then
         s := s + ' (--'
       else
         s := s + ' (' + FloatToStrF(wl[0]+wl[1],ffFixed,7,2,JSONFrmt);
       if wl[2] <> 0 then
         s := s + '/' + FloatToStrF(wl[0]+wl[1]+wl[2],ffFixed,7,2,JSONFrmt);
       s := s + ')';
     end;
     lab.Caption := etyp + ': ' + s;
   end;

  function CheckFilter(data: TObject): Boolean;
  var i,i2: Integer;
      negf: Boolean;
  begin
    Result := True;
    if not FiltersCheck.Checked then Exit;

    if not BodiesCheck.Checked then
      if TObject(data) is TSystemBody then Result := False;
    if not StationsCheck.Checked then
      if TObject(data) is TBaseMarket then Result := False;
    if Result then
      if TObject(data) is TConstructionDepot then
      with TConstructionDepot(data) do
      begin
        if Finished and not FinishedCheck.Checked then Result := False;
        if InProgress and not InProgressCheck.Checked then Result := False;
        if Planned and not PlannedCheck.Checked then Result := False;
      end;

    if Result and (fs <> '') then
    begin
{
      Result := False;
      for i := 0 to row.Count - 1 do
        if Pos(fs,LowerCase(row[i])) > 0 then
        begin
          Result := true;
          break;
        end;
 }
      for i2 := 0 to High(fsarr) do
        if fsarr[i2] <> '' then
        begin
          s := fsarr[i2];
          negf := false;
          if Copy(s,1,1) = '~' then
          begin
            negf := True;
            s := Copy(s,2,100);
          end;
          Result := negf;
          for i := 0 to row.Count - 1 do
          if Pos(s,LowerCase(row[i])) > 0 then
          begin
            Result := not negf;
            break;
          end;
          if not Result then break;
        end;
    end;
  end;

begin
  if FHoldUpdate then Exit;
  if FCurrentSystem = nil then Exit;

//todo: move all calculations to TStarSystem class

  FCurrentSystem.UpdateMoons;

  FCP2 := 0;
  FCP3 := 0;

  SaveSelection;

  for i := 0 to ListView.Columns.Count - 1 do
  begin
    colMaxLen[i] := Length(ListView.Columns[i].Caption);
    colMaxTxt[i] := ListView.Columns[i].Caption;
  end;

  fs := LowerCase(FilterEdit.Text);
  fsarr := SplitString(fs,'+');
  filters := FiltersCheck.Checked;

  ListView.Items.BeginUpdate;
  try

    cl := TList.Create; //system constructions
    sl := TStringList.Create; //orphan market ids
    t23sl := TStringList.Create; //list of t2/t3 stations sorted by finish date/build order
    row := TStringList.Create;

    ListView.Items.Clear;

    SystemNameLabel.Caption := FCurrentSystem.StarSystem;
    s := FCurrentSystem.ArchitectName;
     if s = '' then
       //if FCurrentSystem.Population > 0 then
         s := '(click to assign)';
    ArchitectLabel.Caption := s;
    PopulationLabel.Caption := Format('%.0n', [double(FCurrentSystem.Population)]);;
    FactionsLabel.Caption := FCurrentSystem.Factions;
    LastUpdateLabel.Caption :=
      Copy(FCurrentSystem.LastUpdate,1,10) + ' ' + Copy(FCurrentSystem.LastUpdate,12,8) + ' UTC';
    SystemAddrLabel.Caption := '#' + FCurrentSystem.SystemAddress;
    SecurityLabel.Caption := FCurrentSystem.SystemSecurity;
    EDSMScanLabel.Visible := FCurrentSystem.SystemScan_EDSM <> '';

    PrimaryLabel.Caption := '(select primary)';
{
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
 }
    PrimaryLabel.Hint := 'T2/T3 Port Order:' + Chr(13);

    for i := 0 to 2 do
    begin
      ClearEconomies(weakLinks[i]);
      orbSlotsTaken[i] := 0;
      surfSlotsTaken[i] := 0;
    end;
    ClearEconomies(totWeakLinks);

    for i := 0 to 2 do
    begin
      seclev[i] := 0;
      devlev[i] := 0;
      techlev[i] := 0;
      wealthlev[i] := 0;
      livlev[i] := 0;
    end;
    techBonus := 35;

    //get all system constructions
    for i := 0 to DataSrc.Constructions.Count - 1 do
      with TConstructionDepot(DataSrc.Constructions.Objects[i]) do
        if StarSystem = FCurrentSystem.StarSystem then
          if not Simulated and not Cancelled and (StationType <> 'FleetCarrier') then
          begin
            cl.Add(DataSrc.Constructions.Objects[i]);
            if LinkedMarketId <> '' then sl.Add(LinkedMarketId);
          end;

    cl.Sort(@CompareConstr2); //sort constructions, finished - in progress - planned   

    for i := 0 to cl.Count - 1 do
      with TConstructionDepot(cl[i]) do
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
          score[idx] := score[idx] + ct.Score;

          if ct.IsOrbital then
            orbSlotsTaken[idx] := orbSlotsTaken[idx] + 1
          else
            surfSlotsTaken[idx] := surfSlotsTaken[idx] + 1;

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

          if ct.IsT23Port then
          begin
            techlev[idx] := techlev[idx] + techBonus;
            techBonus := 0;

            if MarketId <> FCurrentSystem.PrimaryPortId then
            begin
              s := 'B';
              if Status = '' then s := 'A'; //builds before Updated 2 come first?
              if not Finished then s := 'Y';
              if Planned then s := 'Z';
              s := s + IntToStr(BuildOrder).PadLeft(6,'0');
              s := s + FirstUpdate;
              t23sl.AddObject(s,cl[i]);
            end
            else
              PrimaryLabel.Hint := PrimaryLabel.Hint + StationName + ' (primary)' + Chr(13);
          end;
        end;
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
        s := StationName;
        if s = '' then s := ct.StationType;
        PrimaryLabel.Hint := PrimaryLabel.Hint + s + ' T' + ct.Tier + Chr(13);
      end;
    end;
   if FCurrentSystem.PrimaryPortId <> '' then
   begin
     i := Max(0,t23sl.Count-1);
     PrimaryLabel.Caption := 'Next Port Cost: ' + Chr(13) +
        'T2: ' + (3+2*i).ToString + '   T3: ' + (6+6*i).ToString;
    end;
    dispStat(score,ScoreLabel);
    dispStat(seclev,SecLabel);
    dispStat(devlev,devLabel);
    dispStat(techlev,TechLabel);
    dispStat(wealthlev,WealthLabel);
    dispStat(livlev,LivLabel);

    dispStat(cp2,CP2Label);
    dispStat(cp3,CP3Label);

    FCP2 := cp2[0] + cp2[1];
    FCP3 := cp3[0] + cp3[1];


    ResolveConstructions(cl);
    GetSystemLinks(cl,weakLinks,totWeakLinks);

    for ei := Low(ei) to ecoTour do
      dispLinks(ei);



    SlotsLabel.Caption := 'Slots •⚪-- 🏭--';
    if FCurrentSystem.OrbitalSlots + FCurrentSystem.SurfaceSlots > 0 then
    begin
      orbFree := FCurrentSystem.OrbitalSlots;
      surfFree := FCurrentSystem.SurfaceSlots;
      for i := 0 to 2 do
      begin
        orbFree := orbFree - orbSlotsTaken[i];
        surfFree := surfFree - surfSlotsTaken[i];
      end;
      SlotsLabel.Caption := 'Slots •⚪' + orbFree.ToString +  ' 🏭' + surfFree.ToString;
      SlotsLabel.Font.Color := clSilver;
      if (orbFree < 0) or (surfFree < 0) then
        SlotsLabel.Font.Color := clYellow;
    end;

    if FCurrentSystem.Bodies.Count > 0 then
    for i := 0 to DataSrc.RecentMarkets.Count - 1 do
      with TBaseMarket(DataSrc.RecentMarkets.Objects[i]) do
        if StarSystem = FCurrentSystem.StarSystem then
          if StationType <> 'FleetCarrier' then
            if sl.IndexOf(MarketId) = -1 then
            begin
              bm := TBaseMarket(DataSrc.RecentMarkets.Objects[i]);
              bm.IsOrphan := True;
              TSystemBody(FCurrentSystem.Bodies.Objects[0]).Constructions.Add(bm);
            end;


    try
      ListView.Items.BeginUpdate;
      try

        for i := 0 to FCurrentSystem.Bodies.Count - 1 do
        begin
          b := TSystemBody(FCurrentSystem.Bodies.Objects[i]);

          s := b.BodyName;
          if b.IsMoon or b.IsRing then s := '  ' + s;
          if b.PrimaryLoc then s := s + ' ⚑';
          addCaption(s);
          addSubItem(b.BodyType);
          s := '';
          s := s + b.ReserveLevel;

          addSubItem(s);
          s := '';
          if FShowEconomies then
            s := b.Economies_nice;
          addSubItem(s);
          addSubItem(b.Comment); //features
          addSubItem(FloatToStrF(b.DistanceFromArrivalLS,ffFixed,7,1));
          addSubItem(IfThen(b.Landable,'Yes',''),true);
          addSubItem(b.Atmosphere,true);
          s := '';
          if b.BiologicalSignals > 0 then s := s + 'Bio: ' + IntToStr(b.BiologicalSignals) + '; ';
          if b.GeologicalSignals > 0 then s := s + 'Geo: ' + IntToStr(b.GeologicalSignals) + '; ';
          if b.HumanSignals > 0 then s := s + 'Hum: ' + IntToStr(b.HumanSignals) + '; ';
          if b.OtherSignals > 0 then s := s + 'Oth: ' + IntToStr(b.OtherSignals) + '; ';
          addSubItem(s,true);
          addSubItem(b.Volcanism,true);
          addSubItem(FloatToStrF(b.SurfaceGravity,ffFixed,7,2));
          addSubItem(IfThen(b.TidalLock,'Yes',''),true);
          addSubItem(IfThen(b.Terraformable,'Yes',''),true);

          //addSubItem(FloatToStrF(b.OrbitalInclination,ffFixed,7,1));
          s := '';
          if (b.OrbitalInclination > 0.1) or (b.OrbitalInclination < -0.1) then
            s := FloatToStrF(b.OrbitalInclination,ffFixed,7,1);
          addSubItem(s,true);

          addSubItem(FloatToStrF(b.Radius,ffFixed,7,1));
          addSubItem(FloatToStrF(b.RotationPeriod,ffFixed,7,1));
          addSubItem(FloatToStrF(b.OrbitalPeriod,ffFixed,7,1));
          addSubItem(FloatToStrF(b.SemiMajorAxis,ffFixed,12,1));

          //not visible
          s := IfThen(b.HasRings,'Rings','') + ';' +
               IfThen(b.HasMoons,'Moons','') + ';' +
               IfThen(b.IsMoon,'Moon','') + ';';
          addSubItem(s);

          if CheckFilter(b) then
          begin
            addRow(b);


            //test
          end;
          begin

            if (b.orbSlots+b.SurfSlots>0) then
            begin
              orbSlots := b.OrbSlots;
              surfSlots := b.SurfSlots;
              for i2 := 0 to b.Constructions.Count - 1 do
              begin
                if TObject(b.Constructions[i2]) is TConstructionDepot then
                  if TConstructionDepot(b.Constructions[i2]).IsOrbital then
                    Dec(orbSlots)
                  else
                    Dec(surfSlots);
              end;
              if {not FiltersCheck.Checked or} FreeSlotsCheck.Checked or (orbSlots < 0) or (surfSlots < 0) then
              if (orbSlots <> 0) or (surfSlots <> 0) then
              begin
                s := '';
                if FiltersCheck.Checked then
                  s := '  ' + b.BodyName;
                addCaption(s);
                addSubItem('  ◌ free:' +
                  IfThen(orbSlots<>0,' ⚪• ' + orbSlots.toString + '  ','') +
                  IfThen(surfSlots<>0,' 🏭 ' + surfSlots.toString,''));
                if not BodiesCheck.Checked then
                begin
                  addSubItem(b.BodyType);
                  s := '';
                  if FShowEconomies then
                    s := b.Economies_nice;
                  addSubItem(s);
                end;
                addRow(b);
              end;
            end;
          end;


         //if b is a ring, the link resolution is not reset after parent's iteration
          //and thus carries over from parent body
          if FShowEconomies then
            if not b.IsRing then
              if b.Constructions.Count > 0  then
                ResolveBodyLinks(b,surfLinks,orbLinks,bwLinks);

          for i2 := 0 to b.Constructions.Count - 1 do
          begin
            bm := TBaseMarket(b.Constructions[i2]);

            //skip bodies from rings (not main star - it collects orphans)
            if (bm.Body <> b.BodyName) and not bm.IsOrphan then continue;

            ct := DataSrc.ConstructionTypes.TypeById[bm.ConstructionType];
            s := '';
            if FiltersCheck.Checked then
              s := '  ' + bm.Body
            else
              if (bm.Body <> b.BodyName) and bm.IsOrphan then
                s := '? '+ bm.Body;
            if s <> '' then
              if b.IsMoon or b.IsRing then s := '  ' + s;
            addCaption(s);
            //orphans attached to main star
            m := nil;
            cd := nil;
            if bm is TMarket then m := TMarket(bm);
            if bm is TConstructionDepot then
            begin
              cd := TConstructionDepot(bm);
              s := '  ';
              //s := s + IfThen((ct <> nil) and (ct.Location = 'Orbital'),'⚪• ','🏭 ');
              //s := s + IfThen(TConstructionDepot(bm).Finished,'','🚧');
              s := s + IfThen(cd.Planned,'✏',
                       IfThen(cd.Finished,'🚩','🚧'));
              s := s + IfThen(cd.IsOrbital,'⚪•','🏭'); //⚪○• 🏭
              if bm.LinkedMarketId <> '' then
              begin
                m := DataSrc.MarketFromID(bm.LinkedMarketId);
                if m <> nil then
                begin
                  s := s + '🛒 ';
                  if bm.NameModified then
                    s := s + bm.StationName
                  else
                    s := s + m.StationName;
                  //cl.Remove(m);
                end
                else
                  s := s + ' ' + bm.StationName;
              end
              else
                s := s + ' ' + bm.StationName;
              addSubItem(s);
            end
            else
            begin
              addSubItem('  🛒 '+ bm.StationName);
            end;
            s := '';
            comment := bm.GetComment;
            if ct <> nil then
              s := ct.StationType_full;
            if s = '' then
            begin
              s := comment;
              comment := '';
            end;
            addSubItem(s);

            curEco := '';
            calcEco := '';
            if m <> nil then curEco := m.Economies;

            s := curEco;
            if FShowEconomies then
            if (bm is TConstructionDepot) and (ct <> nil) then
            begin
              cEconomies := DataSrc.EconomySets.GetStationEconomies(cd,b);
              if ct.Economy = 'Colony' then
                AddEconomies(cEconomies,b.Economies);

//              if ct.IsPort then
              eb := nil;
              if cd.LinkHub then
              begin
                eb := b;
                if b.IsRing then eb := b.ParentBody;
                if eb <> nil then
                begin
                  if bm = eb.SurfLinkHub then
                    AddEconomies(cEconomies,surfLinks);
                  if bm = eb.OrbLinkHub then
                  begin
                    AddEconomies(cEconomies,orbLinks);

                    //if eb.SurfLinkHub <> nil then
                    //  AddEconomies(cEconomies,DataSrc.EconomySets.GetUpLinkEconomies(eb.SurfLinkHub,eb));
                  end;
                end;
                AddEconomies(cEconomies,totWeakLinks);
                SubEconomies(cEconomies,bwLinks);
              end;
              calcEco := FormatEconomies(cEconomies);

              if curEco = '' then
              begin
                s := calcEco;
                calcEco := '';
              end;

              if (eb = nil) or (bm <> eb.orbLinkHub) then //no strong links/uplinks from orbital link hub port
              begin
                s2 := DataSrc.EconomySets.GetLinkEconomies_nice(cd,b);
                if s2 <> '' then s := s + '(🔗' + s2 + ') ';

                if ShowUpLinksCheck.Checked {and not bm.IsOrbital} then
                if not cd.LinkHub or ((eb <> nil) and (bm = eb.surfLinkHub) and (eb.OrbLinkHub <> nil)) then
                begin
                  s2 := FormatEconomies(DataSrc.EconomySets.GetUpLinkEconomies(cd,b));
                  if s2 <> '' then s := s + '( ⬆ ' + s2 + ') ';
                end;
              end;
            end;
            addSubItem('  ' + s);


//            addSubItem(comment);
//            addSubItem('');
            s := '';
            s2 := '';
            if cd <> nil then s2 := cd.Faction_short;
            if m <> nil then s2 := m.Faction_short;
            //addSubItem(s);
            if s2 <> '' then s := s + '👥' + s2 + ' ';

            s2 := '';
            if m <> nil then
            begin
              if Pos('shipyard',m.Services) > 0  then s2 := s2 + '🚀SY ';
              if Pos('outfitting',m.Services) > 0  then s2 := s2 + '⚒OF ';
              if Pos('exploration',m.Services) > 0  then s2 := s2 + '🌐UC ';
              if Pos('facilitator',m.Services) > 0  then s2 := s2 + '⚖IF ';
            end;
            if s2 <> '' then s := s + s2;
            if comment <> '' then s := s + comment + ' ' ;
            addSubItem(s);

            s := '';
            if bm.BuildOrder <> 0 then
              s := '#' + bm.BuildOrder.ToString;
            addSubItem(s);

            if CheckFilter(bm) then
            begin
              addRow(bm);
              if (calcEco <> '') and not EconomiesMatch(calcEco,curEco) then
              begin
                addCaption('');
                addSubItem('');
                addSubItem('    --- calculated / planned economy:');
                addSubItem('  ' + calcEco);
                addRow(bm);
                calcEco := '';
              end;
              if cd <> nil then
                if not cd.CheckDependencies(cl) then
                begin
                  addCaption('');
                  addSubItem('');
                  addSubItem('    --- missing: ' + cd.GetConstrType.Requirements);
                  addRow(bm);
                end;

            end;
          end;

        end;
      finally
        ListView.Items.EndUpdate;
      end;
    except
    end;

    for i := 0 to ListView.Columns.Count - 1 do
      ListView.Column[i].Width := ListView.Canvas.TextWidth(colMaxTxt[i]) +
        15 + ListView.Font.Size div 6; //margins

  finally
    ListView.Items.EndUpdate;
    cl.Free;
    sl.Free;
    t23sl.Free;
    row.Free;
    if keepSel then
      RestoreSelection;
  end;
end;

procedure TSystemInfoForm.AddBioSignalsMenuItemClick(Sender: TObject);
begin
  if ListView.Selected = nil then Exit;
  if TObject(ListView.Selected.Data) is TSystemBody then
    with TSystemBody(ListView.Selected.Data) do
    begin
      FeaturesModified := True;
      case TMenuItem(Sender).Tag of
        0: BiologicalSignals := BiologicalSignals + 1;
        1: GeologicalSignals := GeologicalSignals + 1;
        -1:
          begin
            BiologicalSignals := 0;
            GeologicalSignals := 0;
//            SignalsModified := False;
          end;
      end;
      FCurrentSystem.ResetEconomies;
      FCurrentSystem.Save;
    end;
  UpdateView;
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

procedure TSystemInfoForm.AddLabelsMenuItemClick(Sender: TObject);
begin
  FLabelMode := not FLabelMode;
  NextPictLabel.Visible := FLabelMode;
  NoLabelsLabel.Visible := not FLabelMode and (FBodyLabelNr = 0);
  if FLabelMode then
    UpdateNextBodyLabel;
end;

procedure TSystemInfoForm.ApplySettings;
var i,fs: Integer;
    fn: string;
    clr: TColor;
begin
  ShowInTaskBar := Opts.Flags['ShowInTaskbar'];
  with Panel1 do
  begin
  {
    if not Opts.Flags['DarkMode'] then
    begin
      Font.Color := clSilver;
    end
    else
  }
    begin
      clr := EDCDForm.TextColLabel.Font.Color;
      Font.Color := clr;
      SystemNameLabel.Font.Color := clr;
    end;
  end;

  with ListView do
  begin
    Font.Name := Opts['FontName2'];
    Font.Size := Opts.Int['FontSize2'];
    if not Opts.Flags['DarkMode'] then
    begin
      Color := clSilver;
      Font.Color := clBlack;
    end
    else
    begin
      clr := EDCDForm.TextColLabel.Font.Color;
      Color := $6B5E4F; //$484848; $585140
      Font.Color := clr;
    end;
  end;

  BodyInfoLabel.Font.Size := Opts.Int['FontSize2'] - 1;
  BodyStationsLabel.Font.Size := Opts.Int['FontSize2'] - 1;

  if Visible then UpdateView;
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

procedure TSystemInfoForm.ReloadPictureMenuItemClick(Sender: TObject);
var png: TPngImage;
begin
  if SysImage.Picture.Width = 0 then Exit;
  png := TPngImage.Create;
  try
    png.LoadFromFile(FCurrentSystem.ImagePath);
    SysImage.Picture.Assign(png);
    FImageChanged := False;
  except
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

      //todo: make nice centering based on ItemHeight, not 7 positions upfront
      ListView.Items[Min(i+7,ListView.Items.Count - 1)].MakeVisible(false);
      break;
    end;
  end;
end;


end.
