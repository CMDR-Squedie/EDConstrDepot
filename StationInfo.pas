unit StationInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DataSource, Settings,
  System.StrUtils, System.DateUtils, Vcl.ComCtrls, Vcl.Menus, System.Math;

type
  TStationInfoForm = class(TForm)
    Panel1: TPanel;
    CommentEdit: TEdit;
    Label1: TLabel;
    OKButton: TButton;
    CancelButton: TButton;
    Label2: TLabel;
    PlannedStatus: TRadioButton;
    StatusRadio2: TRadioButton;
    Label3: TLabel;
    StatusRadio3: TRadioButton;
    Label4: TLabel;
    FinishedStatus: TRadioButton;
    Label5: TLabel;
    TypeCombo: TComboBox;
    Label6: TLabel;
    SecPosLabel: TLabel;
    Label8: TLabel;
    SecNegLabel: TLabel;
    Label10: TLabel;
    TechNegLabel: TLabel;
    TechPosLabel: TLabel;
    Label13: TLabel;
    DevNegLabel: TLabel;
    DevPosLabel: TLabel;
    Label16: TLabel;
    WealthNegLabel: TLabel;
    WealthPosLabel: TLabel;
    Label19: TLabel;
    LivNegLabel: TLabel;
    LivPosLabel: TLabel;
    Label22: TLabel;
    EconomyLabel: TLabel;
    EconomyInflLabel: TLabel;
    Label25: TLabel;
    NameEdit: TEdit;
    Label26: TLabel;
    BodyCombo: TComboBox;
    Label27: TLabel;
    Label28: TLabel;
    CPCostLabel: TLabel;
    Label30: TLabel;
    EstHaulLabel: TLabel;
    CPRewardLabel: TLabel;
    Label33: TLabel;
    SecLabel: TLabel;
    TechLabel: TLabel;
    DevLabel: TLabel;
    WealthLabel: TLabel;
    LivLabel: TLabel;
    SecBkgLabel: TLabel;
    TechBkgLabel: TLabel;
    DevBkgLabel: TLabel;
    WealthBkgLabel: TLabel;
    LivBkgLabel: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    LinkedStationCombo: TComboBox;
    Label11: TLabel;
    ReqLabel: TLabel;
    NextButton: TButton;
    PrimaryCheck: TCheckBox;
    Label12: TLabel;
    Label14: TLabel;
    BuildOrderEdit: TEdit;
    BuildOrderUpDown: TUpDown;
    Label15: TLabel;
    LayoutCombo: TComboBox;
    Label17: TLabel;
    PasteMatButton: TButton;
    PopupMenu: TPopupMenu;
    PasteRequestMenuItem: TMenuItem;
    PasteRequest2: TMenuItem;
    ClearMatListMenuItem: TMenuItem;
    UseAvgRequestMenuItem: TMenuItem;
    UseMaxRequestMenuItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure TypeComboChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure NameEditChange(Sender: TObject);
    procedure CommentEditChange(Sender: TObject);
    procedure BodyComboChange(Sender: TObject);
    procedure PlannedStatusClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LinkedStationComboChange(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure PrimaryCheckClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure BuildOrderUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure LayoutComboChange(Sender: TObject);
    procedure EstHaulLabelClick(Sender: TObject);
    procedure Label17Click(Sender: TObject);
    procedure PasteMatButtonClick(Sender: TObject);
    procedure UseAvgRequestMenuItemClick(Sender: TObject);
    procedure ClearMatListMenuItemClick(Sender: TObject);
    procedure PasteRequestMenuItemClick(Sender: TObject);
  private
    { Private declarations }
    FCurrentStation: TBaseMarket;
    FCurrentSystem: TStarSystem;
    FDataChanged: Boolean;
    procedure Save;
  public
    { Public declarations }
    procedure SetStation(st: TBaseMarket);
    procedure NewConstruction(sys: TStarSystem; body: string);
    procedure AddLinkedConstruction(m: TMarket);
    procedure ApplySettings;
    procedure RestoreAndShow;
    property CurrentStation: TBaseMarket read FCurrentStation;
  end;

var
  StationInfoForm: TStationInfoForm;

implementation

{$R *.dfm}

uses SystemInfo, Main, MaterialList, ConstrTypes;

procedure TStationInfoForm.RestoreAndShow;
begin
  if WindowState = wsMinimized then WindowState := wsNormal;
  Show;
end;

procedure TStationInfoForm.BodyComboChange(Sender: TObject);
begin
  FDataChanged := True;
end;

procedure TStationInfoForm.Save;
var ct: TConstructionType;
    m: TMarket;
    UUID: TGUID;
    b: TSystemBody;
begin
  if FDataChanged then
  begin
    DataSrc.BeginUpdate;
    try

      if FCurrentStation is TConstructionDepot then
      with TConstructionDepot(FCurrentStation) do
      begin
        if Finished and not FinishedStatus.Checked then
          if Vcl.Dialogs.MessageDlg('This station was previously tagged as Finished.' + Chr(13) +
             'Are you sure you want to change its status?',
             mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;
        Finished := FinishedStatus.Checked;
        Planned := PlannedStatus.Checked;
      end;

      if FCurrentStation.MarketId = '' then
      begin
        CreateGUID(UUID);
        FCurrentStation.MarketId := GUIDToString(UUID);
  //      FCurrentStation.FirstUpdate := DateToISO8601(Now);
  //      FCurrentStation.Status := '{}';
        DataSrc.Constructions.AddObject(FCurrentStation.MarketID,FCurrentStation);
      end;

      ct := nil;
      FCurrentStation.ConstructionType := '';
      if TypeCombo.ItemIndex > -1 then
      begin
        ct := TConstructionType(TypeCombo.Items.Objects[TypeCombo.ItemIndex]);
        if ct <> nil then
          FCurrentStation.ConstructionType := ct.Id;
      end;

      FCurrentStation.LinkedMarketId := '';
      if LinkedStationCombo.ItemIndex > -1 then
      begin
        m := TMarket(LinkedStationCombo.Items.Objects[LinkedStationCombo.ItemIndex]);
        if m <> nil then
          FCurrentStation.LinkedMarketId := m.MarketId;
      end;


      if FCurrentStation.StationName <> NameEdit.Text then
      begin
        FCurrentStation.StationName := NameEdit.Text;
        FCurrentStation.NameModified := False;
        if FCurrentStation.StationName <> '' then
          FCurrentStation.NameModified := True;
      end;

      if FCurrentStation.GetComment <> CommentEdit.Text then
      begin
        FCurrentStation.Comment := CommentEdit.Text;
        //remove old solution entry for construction depots
        DataSrc.UpdateMarketComment(FCurrentStation.MarketID,'');
      end;

      if FCurrentStation.BuildOrder <> StrToIntDef(BuildOrderEdit.Text,0) then
        FCurrentStation.BuildOrder := StrToIntDef(BuildOrderEdit.Text,0) mod 100000;


      FCurrentStation.Body := Trim(LeftStr(BodyCombo.Text,20));
      FCurrentStation.Layout := LayoutCombo.Text;
      if FCurrentStation.DistFromStar = 0 then
      begin
        b := FCurrentSystem.BodyByName(FCurrentStation.Body);
        if b <> nil then
          FCurrentStation.DistFromStar := Trunc(b.DistanceFromArrivalLS);
      end;

      if PrimaryCheck.Checked then
        FCurrentStation.GetSys.PrimaryPortId := FCurrentStation.MarketID
      else
        if FCurrentStation.GetSys.PrimaryPortId = FCurrentStation.MarketID then
          FCurrentStation.GetSys.PrimaryPortId := '';

      FCurrentStation.Modified := True;
      FCurrentStation.GetSys.Save;
      FDataChanged := False;
    finally
      DataSrc.EndUpdate;
    end;
  end;
end;

procedure TStationInfoForm.OKButtonClick(Sender: TObject);
begin
  Save;
  Close;
end;

procedure TStationInfoForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TStationInfoForm.CommentEditChange(Sender: TObject);
begin
  FDataChanged := True;
end;

procedure TStationInfoForm.EstHaulLabelClick(Sender: TObject);
begin
  if TypeCombo.ItemIndex < 1 then Exit;
  MaterialListForm.SetConstructionType(
    TConstructionType(TypeCombo.Items.Objects[TypeCombo.ItemIndex]));
  MaterialListForm.Show;
end;

procedure TStationInfoForm.FormCreate(Sender: TObject);
begin
  DataSrc.ConstructionTypes.PopulateList(TypeCombo.Items);
//  TypeCombo.Items.Insert(0,'( other )');
  TypeCombo.Items.Insert(0,'( unknown )');

  ApplySettings;
end;

procedure TStationInfoForm.FormShow(Sender: TObject);
begin
  if NameEdit.Text = '' then
    NameEdit.SetFocus
  else
    CommentEdit.SetFocus;
end;

procedure TStationInfoForm.Label12Click(Sender: TObject);
begin
  PrimaryCheck.Checked := not PrimaryCheck.Checked;
end;

procedure TStationInfoForm.Label17Click(Sender: TObject);
begin
  ConstrTypesForm.Show;
end;

procedure TStationInfoForm.Label2Click(Sender: TObject);
begin
  with TLabel(Sender) do
    TRadioButton(FocusControl).Checked := not TRadioButton(FocusControl).Checked;
end;

procedure TStationInfoForm.LayoutComboChange(Sender: TObject);
begin
  FDataChanged := True;
end;

procedure TStationInfoForm.LinkedStationComboChange(Sender: TObject);
begin
  FDataChanged := True;
end;

procedure TStationInfoForm.NameEditChange(Sender: TObject);
begin
  FDataChanged := True;
end;

procedure TStationInfoForm.SetStation(st: TBaseMarket);
var i: Integer;
    m: TMarket;
    ct: TConstructionType;
begin
  if (st is TConstructionDepot) and TConstructionDepot(st).Simulated then
  begin
    ShowMessage('Simulated depot, no info available.');
    Abort;
  end;
  FCurrentStation := st; //
  FCurrentSystem := st.GetSys;
  NameEdit.Text := FCurrentStation.StationName;
  CommentEdit.Text := FCurrentStation.GetComment;
  BuildOrderEdit.Text := IntToStr(FCurrentStation.BuildOrder);
  try BuildOrderUpDown.Position := FCurrentStation.BuildOrder; except end;
  BodyCombo.Text := FCurrentStation.Body;
  BodyCombo.Items.Clear;
  if FCurrentStation.GetSys <> nil then
    for i := 0 to FCurrentStation.GetSys.Bodies.Count - 1 do
      with TSystemBody(FCurrentStation.GetSys.Bodies.Objects[i]) do
      begin
        BodyCombo.Items.AddObject(BodyName.PadRight(20,' ') + BodyType,FCurrentStation.GetSys.Bodies.Objects[i]);
      end;
  LayoutCombo.Text := FCurrentStation.Layout;

  TypeCombo.ItemIndex := TypeCombo.Items.IndexOfObject(
    DataSrc.ConstructionTypes.TypeById[FCurrentStation.ConstructionType]);
  TypeComboChange(nil);


  LinkedStationCombo.Items.Clear;
  LinkedStationCombo.ItemIndex := -1;
  for i := 0 to DataSrc.RecentMarkets.Count - 1 do
  begin
    m := TMarket(DataSrc.RecentMarkets.Objects[i]);
    if m.StarSystem = FCurrentSystem.StarSystem then
      if m.StationType <> 'FleetCarrier' then
      begin
        LinkedStationCombo.Items.AddObject(m.StationName,m);
        if m.MarketId = FCurrentStation.LinkedMarketId then
          LinkedStationCombo.ItemIndex := LinkedStationCombo.Items.IndexOfObject(m); //sorted!
      end;
  end;
  LinkedStationCombo.Items.InsertObject(0,'( none )',nil);


  if st is TMarket then
  begin
    PlannedStatus.Enabled := False;
    StatusRadio2.Enabled := False;
    FinishedStatus.Enabled := True;
    FinishedStatus.Checked := True;
  end;
  if st is TConstructionDepot then
  with TConstructionDepot(st) do
  begin
    PlannedStatus.Checked := Planned;
    PlannedStatus.Enabled := true;
    StatusRadio2.Checked := not Planned and not Finished;
    StatusRadio2.Enabled := true;
    FinishedStatus.Checked := Finished;
    FinishedStatus.Enabled := true;
  end;

  PrimaryCheck.Checked := (FCurrentStation.GetSys.PrimaryPortId <> '') and
    (FCurrentStation.GetSys.PrimaryPortId = FCurrentStation.MarketID);

  PasteMatButton.Visible := (FCurrentStation is TConstructionDepot) and (FCurrentStation.Status = '');
  FDataChanged := False;
end;

procedure TStationInfoForm.NewConstruction(sys: TStarSystem; body: string);
var i: Integer;
    cd: TConstructionDepot;
    b: TSystemBody;
begin
  FCurrentSystem := sys;
  cd := TConstructionDepot.Create;
  cd.StarSystem := sys.StarSystem;
  cd.Body := body;
  cd.Planned := True;
  cd.Modified := True;
  SetStation(cd);
end;

procedure TStationInfoForm.NextButtonClick(Sender: TObject);
var bm: TBaseMarket;
begin
  if not SystemInfoForm.Visible then Exit;
  if SystemInfoForm.CurrentSystem <> FCurrentSystem then Exit;
  bm := SystemInfoForm.GetNextConstruction(FCurrentStation);
  if bm <> nil then
  begin
    Save;
    SetStation(bm);
  end;
end;

procedure TStationInfoForm.AddLinkedConstruction(m: TMarket);
var i: Integer;
    cd: TConstructionDepot;
begin
  FCurrentSystem := m.GetSys;
  cd := TConstructionDepot.Create;
  cd.StarSystem := FCurrentSystem.StarSystem;
  cd.LinkedMarketId := m.MarketID;
  cd.StationName := m.StationName;
  cd.StationType := m.StationType;
  cd.DistFromStar := m.DistFromStar;
  cd.Comment := m.Comment;
  cd.Body := m.Body;
  cd.Finished := True;
  cd.Modified := True;
  SetStation(cd);
end;

procedure TStationInfoForm.PlannedStatusClick(Sender: TObject);
begin
  FDataChanged := True;
end;

procedure TStationInfoForm.PrimaryCheckClick(Sender: TObject);
begin
  FDataChanged := True;
end;

procedure TStationInfoForm.TypeComboChange(Sender: TObject);
var t,dummy: TConstructionType;
    s: string;
    nc,pc: Char;

   procedure  SetLevels(lev: Integer;neglab,poslab,lab: TLabel);
   var s: string;
   begin
     s := '';
     neglab.Caption := '';
     poslab.Caption := '';
     lab.Caption := '';
     if lev < 0 then
     begin
       neglab.Caption := s.PadLeft(-lev,nc);
       lab.Caption := '(' + IntToStr(lev) + ')';
     end;
     if lev > 0 then
     begin
       poslab.Caption := s.PadLeft(lev,pc);
       lab.Caption := '(+' + IntToStr(lev) + ')';
     end;

   end;

   function FormatCP(cp2,cp3: Integer; costf: Boolean): string;
   begin
     Result := '';
     if costf then
     begin
       if cp2 < 0 then Result := IntToStr(cp2) + ' T2';
       if cp3 < 0 then Result := IntToStr(cp3) + ' T3';
     end
     else
     begin
       if cp2 > 0 then Result := '+' + IntToStr(cp2) + ' T2';
       if cp3 > 0 then Result := '+' + IntToStr(cp3) + ' T3';
     end;
   end;

begin
  if TypeCombo.ItemIndex < 0 then Exit;
  t := TConstructionType(TypeCombo.Items.Objects[TypeCombo.ItemIndex]);
  dummy := TConstructionType.Create;
  if t = nil then t := dummy;
  nc := '❰';
  pc := '❱';
  s := '';
  SetLevels(t.SecLev,SecNegLabel,SecPosLabel,SecLabel);
  SetLevels(t.TechLev,TechNegLabel,TechPosLabel,TechLabel);
  SetLevels(t.DevLev,DevNegLabel,DevPosLabel,DevLabel);
  SetLevels(t.WealthLev,WealthNegLabel,WealthPosLabel,WealthLabel);
  SetLevels(t.StdLivLev,LivNegLabel,LivPosLabel,LivLabel);
  EconomyLabel.Caption := t.Economy;
  if t.Economy = '' then EconomyLabel.Caption := '-';
  EconomyInflLabel.Caption := t.Influence;
  CPCostLabel.Caption := FormatCP(t.CP2,t.CP3,true);
  CPRewardLabel.Caption := FormatCP(t.CP2,t.CP3,false);
  EstHaulLabel.Caption := IntToStr(t.EstCargo) + ' [...]';
  EstHaulLabel.Tag := TypeCombo.ItemIndex;
  if FCurrentStation is TConstructionDepot then
    with TConstructionDepot(FCurrentStation) do
      if ActualHaul > 0 then
        EstHaulLabel.Caption := EstHaulLabel.Caption + ' / ' + IntToStr(ActualHaul)
      else
        if CustomRequest <> '' then
          EstHaulLabel.Caption := EstHaulLabel.Caption + ' / (custom list)';


  ReqLabel.Caption := t.Requirements;
  LayoutCombo.Items.CommaText := t.Layouts;
  dummy.Free;
  FDataChanged := True;
end;

procedure TStationInfoForm.PasteRequestMenuItemClick(Sender: TObject);
begin
  if FCurrentStation = nil then Exit;
  TConstructionDepot(FCurrentStation).PasteRequest;
end;

procedure TStationInfoForm.UseAvgRequestMenuItemClick(Sender: TObject);
var i,q: Integer;
    maxreq: TStock;
    s: string;
begin
  if FCurrentStation = nil then Exit;
  if FCurrentStation.Status <> '' then Exit;
  if FCurrentStation.GetConstrType = nil then Exit;
  maxreq := TStock.Create;
  maxreq.Assign(FCurrentStation.GetConstrType.ResourcesRequired);
  if TMenuItem(Sender).Tag = 1 then
    for i := 0 to maxreq.Count - 1 do
    begin
      s := maxreq.Names[i];
      q := maxreq.Qty[s];
      q := q + Ceil(q*0.05);
      maxreq.Qty[s] := q;
    end;
  TConstructionDepot(FCurrentStation).CustomRequest := maxreq.Text;
  FCurrentStation.GetSys.UpdateSave;
  maxreq.Free;
  TypeComboChange(nil);
end;

procedure TStationInfoForm.ClearMatListMenuItemClick(Sender: TObject);
begin
  if FCurrentStation = nil then Exit;
  if FCurrentStation.Status <> '' then Exit;
  if TConstructionDepot(FCurrentStation).CustomRequest = '' then Exit;
  TConstructionDepot(FCurrentStation).CustomRequest := '';
  FCurrentStation.GetSys.UpdateSave;
  TypeComboChange(nil);
end;


procedure TStationInfoForm.BuildOrderUpDownClick(Sender: TObject;
  Button: TUDBtnType);
begin
  if Button = btNext then
    BuildOrderEdit.Text := (StrToIntDef(BuildOrderEdit.Text,0) + 1).ToString
  else
    BuildOrderEdit.Text := (StrToIntDef(BuildOrderEdit.Text,0) - 1).ToString;
end;

procedure TStationInfoForm.PasteMatButtonClick(Sender: TObject);
var pt: TPoint;
begin
  pt.X := PasteMatButton.Left;
  pt.Y := PasteMatButton.Top + PasteMatButton.Height;
  pt := Panel1.ClientToScreen(pt);
  PopupMenu.Popup(pt.X,pt.Y)
end;

procedure TStationInfoForm.ApplySettings;
var i,fs: Integer;
    fn: string;
    clr: TColor;
begin
  if not Opts.Flags['DarkMode'] then
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
//  Font.Size := Opts.Int['FontSize2'];

  SecBkgLabel.Font.Color := self.Color - $101010;
  DevBkgLabel.Font.Color := SecBkgLabel.Font.Color;
  TechBkgLabel.Font.Color := SecBkgLabel.Font.Color;
  WealthBkgLabel.Font.Color := SecBkgLabel.Font.Color;
  LivBkgLabel.Font.Color := SecBkgLabel.Font.Color;
end;


end.
