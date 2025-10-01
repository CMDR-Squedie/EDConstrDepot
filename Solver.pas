unit Solver;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.ComCtrls,DataSource, System.Math, Vcl.Menus, Vcl.CheckLst, System.StrUtils;

type
  TSolverForm = class(TForm)
    ListView: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    NewPortsLabel: TLabel;
    Label3: TLabel;
    SurfSlotsEdit: TLabeledEdit;
    GoalT3OrbEdit: TLabeledEdit;
    SolveButton: TButton;
    GoalCombo: TComboBox;
    GoalT2OrbEdit: TLabeledEdit;
    OrbSlotsEdit: TLabeledEdit;
    AsterSlotsEdit: TLabeledEdit;
    GoalT3SurfEdit: TLabeledEdit;
    InitialCP2Edit: TLabeledEdit;
    InitialCP3Edit: TLabeledEdit;
    WarnLabel: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    AllPortsLabel: TLabel;
    DevTrackBar: TTrackBar;
    Label7: TLabel;
    Label8: TLabel;
    TechTrackBar: TTrackBar;
    Label9: TLabel;
    SecTrackBar: TTrackBar;
    WealthTrackBar: TTrackBar;
    Label13: TLabel;
    StdLivTrackBar: TTrackBar;
    Label14: TLabel;
    Label10: TLabel;
    BalStatsCheck: TCheckBox;
    AllowOutpostsCheck: TCheckBox;
    AllowHubsCheck: TCheckBox;
    PopupMenu: TPopupMenu;
    CopyAllMenuItem: TMenuItem;
    EcoInflCheckList: TCheckListBox;
    EcoInflCheck: TCheckBox;
    ResetButton: TButton;
    Label11: TLabel;
    DevLabel: TLabel;
    TechLabel: TLabel;
    WealthLabel: TLabel;
    StdLivLabel: TLabel;
    SecLabel: TLabel;
    N1: TMenuItem;
    AddToSystemMenuItem: TMenuItem;
    SaveButton: TButton;
    MaxInflEdit: TLabeledEdit;
    GoalT1SurfEdit: TLabeledEdit;
    GoalT1OrbEdit: TLabeledEdit;
    Label6: TLabel;
    DependCombo: TComboBox;
    Label12: TLabel;
    Label15: TLabel;
    ScoreLabel: TLabel;
    AllowPortsCheck: TCheckBox;
    Label16: TLabel;
    SlotsCombo: TComboBox;
    Label17: TLabel;
    Alternatives1: TMenuItem;
    StatsHelpLabel: TLabel;
    procedure SolveButtonClick(Sender: TObject);
    procedure ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure GoalT3SurfEditChange(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure CopyAllMenuItemClick(Sender: TObject);
    procedure TechTrackBarChange(Sender: TObject);
    procedure EcoInflCheckListClickCheck(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure AddToSystemMenuItemClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure Label7MouseEnter(Sender: TObject);
    procedure Label7MouseLeave(Sender: TObject);
  private
    { Private declarations }
    FCP2,FCP3: Integer;
    FSecLev,FDevLev,FTechlev,FWealthLev,FStdLivLev,FScore,FTechBonus: Integer;
    FCurrentSystem: TStarSystem;
    FT23Primary: Boolean;
    FT23Ports: Integer;
    FPrioConstructions,APrioConstructions: TStringList;
    FConstrList: TList;
    FInflList: TStringList;
    procedure ResetOptions;
  public
    { Public declarations }
    procedure SetSystem(sys: TStarSystem; CP2,CP3: Integer; const restoref: Boolean = false);
    procedure ApplySettings;
    property CurrentSystem: TStarSystem read FCurrentSystem;
  end;

var
  SolverForm: TSolverForm;

implementation

{$R *.dfm}

uses Main,Settings, ConstrTypes, Clipbrd;

procedure TSolverForm.AddToSystemMenuItemClick(Sender: TObject);
var ct: TConstructionType;
    cd: TConstructionDepot;
    b: TSystemBody;
    UUID: TGUID;
    s: string;
begin
  if ListView.Selected = nil then Exit;
  if FCurrentSystem = nil then Exit;
  if ListView.Selected.Data = nil then Exit;
  if FCurrentSystem.Bodies.Count = 0 then Exit;
  
  ct := TConstructionType(ListView.Selected.Data);

  cd := TConstructionDepot.Create;
  cd.StarSystem := FCurrentSystem.StarSystem;
  cd.Body := '?';
  cd.ConstructionType := ct.Id;
  cd.ConstrStatus := csPlanned;
  cd.Modified := True;
  CreateGUID(UUID);
  cd.MarketId := GUIDToString(UUID);
  DataSrc.Constructions.AddObject(cd.MarketID,cd);
  FCurrentSystem.UpdateSave;
  SetSystem(FCurrentSystem,FCP2,FCP3); //refresh
  SolveButtonClick(nil);
end;

procedure TSolverForm.ApplySettings;
begin
  ShowInTaskBar := Opts.Flags['ShowInTaskbar'];
end;

procedure TSolverForm.ResetOptions;
var i: Integer;
begin
  AsterSlotsEdit.Text := '';
  GoalT3SurfEdit.Text := '';
  GoalT1SurfEdit.Text := '';
  GoalT3OrbEdit.Text := '';
  GoalT2OrbEdit.Text := '';
  GoalT1OrbEdit.Text := '';
  GoalCombo.ItemIndex := 3;

  DevTrackBar.Position := 0;
  TechTrackBar.Position := 0;
  SecTrackBar.Position := 0;
  WealthTrackBar.Position := 0;
  StdLivTrackBar.Position := 0;

  DevLabel.Caption := '';
  TechLabel.Caption := '';
  SecLabel.Caption := '';
  WealthLabel.Caption := '';
  StdLivLabel.Caption := '';
  WarnLabel.Caption := '';
  NewPortsLabel.Caption := '';
  AllPortsLabel.Caption := '';
  ScoreLabel.Caption := '';

  DependCombo.ItemIndex := 0;
  SlotsCombo.ItemIndex := 0;


  BalStatsCheck.Checked := False;

  AllowOutpostsCheck.Checked := False;
  AllowHubsCheck.Checked := False;
  AllowPortsCheck.Checked := False;
  EcoInflCheck.Checked := False;
  for i := 0 to EcoInflCheckList.Count - 1 do
    EcoInflCheckList.Checked[i] := True;
  MaxInflEdit.Text := '';  
end;

procedure TSolverForm.SaveButtonClick(Sender: TObject);
var i: Integer;
begin
  with FCurrentSystem.ColonyPlanner do
  begin
    Modified := True;
    AsterSlots := StrToIntDef(AsterSlotsEdit.Text,0);
    GoalT3Surf := StrToIntDef(GoalT3SurfEdit.Text,0);
    GoalT1Surf := StrToIntDef(GoalT1SurfEdit.Text,0);
    GoalT3Orb := StrToIntDef(GoalT3OrbEdit.Text,0);
    GoalT2Orb := StrToIntDef(GoalT2OrbEdit.Text,0);
    GoalT1Orb := StrToIntDef(GoalT1OrbEdit.Text,0);
    GoalIndex := GoalCombo.ItemIndex;
    ReqDev := DevTrackBar.Position;
    ReqTech := TechTrackBar.Position;
    ReqSec := SecTrackBar.Position;
    ReqWealth := WealthTrackBar.Position;
    ReqStdLiv := StdLivTrackBar.Position;

    BalStats := BalStatsCheck.Checked;
    AllowOutposts := AllowOutpostsCheck.Checked;
    AllowHubs := AllowHubsCheck.Checked;
    AllowPorts := AllowPortsCheck.Checked;
    DependIndex := DependCombo.ItemIndex;
    SlotsIndex := SlotsCombo.ItemIndex;
    EcoInfl := EcoInflCheck.Checked;
    EcoInflList := '';
    LimInflList := '';
    for i := 0 to EcoInflCheckList.Count - 1 do
    begin
      if EcoInflCheckList.State[i] = cbChecked then
        EcoInflList := EcoInflList + EcoInflCheckList.Items[i] + ',';
      if EcoInflCheckList.State[i] = cbGrayed then
        LimInflList := LimInflList + EcoInflCheckList.Items[i] + ',';
    end;
    LimInflCnt := StrToIntDef(MaxInflEdit.Text,0);
  end;
  FCurrentSystem.Save;

end;

procedure TSolverForm.SetSystem(sys: TStarSystem; CP2,CP3: Integer; const restoref: Boolean = false);
var i,orbTaken,surfTaken,bOrd,techBonus: Integer;
    ct: TConstructionType;
    item: TListItem;
    t23portf,primf: Boolean;
    s: string;
begin

  FCurrentSystem := sys;

  if restoref then
  begin
    ResetOptions;
    if FCurrentSystem.ColonyPlanner.Modified then
    with FCurrentSystem.ColonyPlanner do
    begin
      AsterSlotsEdit.Text := IfThen(AsterSlots>0,AsterSlots.ToString,'');
      GoalT3SurfEdit.Text := IfThen(GoalT3Surf>0,GoalT3Surf.ToString,'');
      GoalT1SurfEdit.Text := IfThen(GoalT1Surf>0,GoalT1Surf.ToString,'');
      GoalT3OrbEdit.Text := IfThen(GoalT3Orb>0,GoalT3Orb.ToString,'');
      GoalT2OrbEdit.Text := IfThen(GoalT2Orb>0,GoalT2Orb.ToString,'');
      GoalT1OrbEdit.Text := IfThen(GoalT1Orb>0,GoalT1Orb.ToString,'');
      GoalCombo.ItemIndex := GoalIndex;
      DevTrackBar.Position := ReqDev;
      TechTrackBar.Position := ReqTech;
      SecTrackBar.Position := ReqSec;
      WealthTrackBar.Position := ReqWealth;
      StdLivTrackBar.Position := ReqStdLiv;

      BalStatsCheck.Checked := BalStats;
      AllowOutpostsCheck.Checked := AllowOutposts;
      AllowHubsCheck.Checked := AllowHubs;
      AllowPortsCheck.Checked := AllowPorts;
      DependCombo.ItemIndex := DependIndex;
      SlotsCombo.ItemIndex := SlotsIndex;
      for i := 0 to EcoInflCheckList.Count - 1 do
      begin
        EcoInflCheckList.State[i] := cbUnChecked;
        if Pos(EcoInflCheckList.Items[i],EcoInflList) > 0 then
          EcoInflCheckList.State[i] := cbChecked;
        if Pos(EcoInflCheckList.Items[i],LimInflList) > 0 then
          EcoInflCheckList.State[i] := cbGrayed;
      end;
      EcoInflCheck.Checked := EcoInfl;
      MaxInflEdit.Text := IfThen(LimInflCnt>0,LimInflCnt.ToString,'');
    end;

  end;

  FCP2 := CP2;
  FCP3 := CP3;

  FPrioConstructions.Clear;
  FT23Primary := False;
  FT23Ports := 0;
  ListView.Clear;
  orbTaken := 0;
  surfTaken := 0;

  FSecLev := 0;
  FDevLev := 0;
  FTechlev := 0;
  FWealthlev := 0;
  FStdLivLev := 0;
  FScore := 0;
  FTechBonus := 35;
  primf := False;

  DataSrc.UpdateSystemStations;
  for i := 0 to FCurrentSystem.Constructions.Count - 1 do
    with TConstructionDepot(FCurrentSystem.Constructions[i]) do
    begin
      if IsPrimary then primf := True;
      ct := GetConstrType;
      if ct <> nil then
      begin
        if not Planned then
        begin
          if ct.IsOrbital then
            Inc(orbTaken)
          else
            Inc(surfTaken);
         if ct.IsT23port then
         begin
           if not IsPrimary then
             Inc(FT23Ports)
           else
             FT23Primary := True;
           FTechlev := FTechlev + FTechBonus;
           FTechBonus := 0;
         end;

        FSecLev := FSecLev + ct.SecLev;
        FDevLev := FDevLev + ct.DevLev;
        FTechlev := FTechLev + ct.TechLev;
        FWealthlev := FWealthlev + ct.WealthLev;
        FStdLivLev := FStdLivLev + ct.StdLivLev;
        FScore:= FScore + ct.Score;

        end
        else
        begin
          //PrioConstructions sorted by tier and starport type
          bOrd := BuildOrder;
          if IsPrimary then
            bOrd := 0
          else
          begin
          {
            s := '1';
            if ct.Tier = '2' then
              if ct.Category = 'Starport' then
                s := '9'
              else
                s := '2';
            if ct.Tier = '3' then s := '8';
            }
            if bOrd = 0 then
            begin
              bOrd := 99900;
              if ct.Tier = '1' then bOrd := bOrd - 1;
              //tier 2 - no change
              if ct.Tier = '3' then bOrd := bOrd + 3;
              if ct.Dependencies <> '' then bOrd := bOrd + 1;
            end;
          end;
          s := bOrd.ToString.PadLeft(5,'0'); // + s;
          FPrioConstructions.AddObject(s,ct);
        end;
      end;
    end;
  OrbSlotsEdit.Text := (FCurrentSystem.OrbitalSlots - orbTaken).ToString;
  SurfSlotsEdit.Text := (FCurrentSystem.SurfaceSlots - surfTaken).ToString;

  InitialCP2Edit.Text := FCP2.ToString;
  InitialCP3Edit.Text := FCP3.ToString;

  if not primf then WarnLabel.Caption := 'add or select primary port before using solver';

  FPrioConstructions.Sort;


  for i := 0 to FPrioConstructions.Count - 1 do
  begin
    ct := TConstructionType(FPrioConstructions.Objects[i]);
    item := ListView.Items.Add;
    item.SubItems.Add('');
    item.Caption := '✏';
    item.SubItems.Add(ct.StationType_full);
    item.SubItems.Add('');
    item.SubItems.Add('');
    item.SubItems.Add('');
  end;
end;


procedure TSolverForm.CopyAllMenuItemClick(Sender: TObject);
var s: string;
    i,j: Integer;
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
  Clipboard.AsText := s;
end;

procedure TSolverForm.EcoInflCheckListClickCheck(Sender: TObject);
begin
  EcoInflCheck.Checked := True;
end;

procedure TSolverForm.FormCreate(Sender: TObject);
var eco: TEconomy;
begin
  FPrioConstructions := TStringList.Create;
  APrioConstructions := TStringList.Create;
  FConstrList := TList.Create;
  FInflList := TStringList.Create;

  ApplySettings;

  for eco := ecoAgri to ecoTour do
    EcoInflCheckList.Items.AddObject(cEconomyNames[eco],Pointer(eco));

  ResetOptions;
end;

procedure TSolverForm.GoalT3SurfEditChange(Sender: TObject);
begin
  GoalCombo.ItemIndex := 2;
end;

procedure TSolverForm.Label7MouseEnter(Sender: TObject);
begin
  if Sender is TControl then
  if TControl(Sender).Hint <> '' then
  begin
    StatsHelpLabel.Caption := TControl(Sender).Hint;
    StatsHelpLabel.Visible := True;
  end;
end;

procedure TSolverForm.Label7MouseLeave(Sender: TObject);
begin
  StatsHelpLabel.Visible := False;
end;

procedure TSolverForm.ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  Sender.Canvas.Font.Style := [];
  if Item.Data <> nil then
    if TConstructionType(Item.Data).IsT23Port then
      Sender.Canvas.Font.Style := [fsBold];
end;

procedure TSolverForm.ListViewDblClick(Sender: TObject);
var ct: TConstructionType;
begin
  if ListView.Selected = nil then Exit;

  ct := TConstructionType(ListView.Selected.Data);
  ConstrTypesForm.FilterEdit.Text := '';
  if ct <> nil then
    ConstrTypesForm.FilterEdit.Text := LowerCase('T' + ct.Tier + '+' + ct.Location + '+' + ct.Category)
  else
    ConstrTypesForm.FilterEdit.Text := LowerCase(Trim(ListView.Selected.SubItems[0]).Replace(' ','+'));
  ConstrTypesForm.UpdateItems;
  ConstrTypesForm.Show;
end;

procedure TSolverForm.PopupMenuPopup(Sender: TObject);
begin
  AddToSystemMenuItem.Enabled :=
    (ListView.Selected <> nil) and
    (FCurrentSystem <> nil) and
    (ListView.Selected.Data <> nil);
end;

procedure TSolverForm.ResetButtonClick(Sender: TObject);
begin
  ResetOptions;
end;

type 
  TNextBuild = (nNone,nAnyInst,nAnyOrb,nAnySurf,nT1Inst,nT2Inst,nT3Port,nT2Port,nT1Port,nT2Aster,nT3SurfPort,nT1SurfPort,nT2Settl,nT2Orb,nT1Settl,nT1Orb,nPrio);
  TSlotPolicy = (spNone,spBalance,spAlternate,spOrbFirst,spSurfFirst);
  TSlotType = (stAny,stOrb,stSurf);

procedure TSolverForm.SolveButtonClick(Sender: TObject);
var item: TListItem;
    OrbSlots,SurfSlots,AsterSlots,OrbReserved,SurfReserved: Integer;
    CP2,CP3: Integer;
    cp2Cost,cp3Cost,t23ports,t1ports,maxinflcnt: Integer;
    t1ToBuild,t2ToBuild,t3ToBuild,t1SurfToBuild,t3SurfToBuild: Integer;
    t23portf,asteroidOnlyf: Boolean;
    i,prioIdx: Integer;
    s,constrType,constrTag: string;
    nextBuild,reqBuild: TNextBuild;
    nextCt,depCt: TConstructionType;
    balstatsf,outpostsf,hubsf,nonegf,portsf,primaryf,slotbalf,prioT3portf: Boolean;
    reqSec,reqWealth,reqStdLiv,reqDev,reqTech,reqTot: Integer;
    ASecLev,ADevLev,ATechlev,AWealthLev,AStdLivLev,AScore,ATechBonus,statTot,orgStatTot: Integer;
    nextPts: Extended;
    inflList: TStringList;
    dependMode: Integer;
    constrNr: Integer;
    slotPolicy: TSlotPolicy;
    reqSlot,lastReqSlot: TSlotType;

    procedure updateReserved;
    var i,maxT3,maxT2: Integer;
    begin
      OrbReserved := 0;
      SurfReserved := 0;

      maxT3 := 0;
      if OrbSlots > SurfSlots then
        maxT3 := Trunc( (SurfSlots - 1) / cp3Cost  + (OrbSlots - SurfSlots) / (cp3Cost / 2) )
      else
        maxT3 := Trunc( (OrbSlots - 1) / cp3Cost  + (SurfSlots - OrbSlots) / (cp3Cost / 2) );
      maxT2 := Trunc( (OrbSlots - 1 + SurfSlots) / cp2Cost);

      //t3 ports are always priority, as their cost rises the most

      if t3SurfToBuild > 0 then
      begin
        SurfReserved := Min(Max(0,t3SurfToBuild), maxT3);
        //SurfReserved := Max(1, SurfReserved);
      end
      else
      begin
        if t3ToBuild > 0 then
          OrbReserved := Min(Max(0,t3ToBuild), maxT3);
        if t2ToBuild > 0 then
          OrbReserved := OrbReserved + Min(Max(0,t2ToBuild), maxT2);
        if t2ToBuild + t3ToBuild > 0 then
          OrbReserved := Max(1, OrbReserved);
      end;

      OrbReserved := OrbReserved + t1ToBuild;
      SurfReserved := SurfReserved + t1SurfToBuild;

      for i := prioIdx to APrioConstructions.Count - 1 do
        with TConstructionType(APrioConstructions.Objects[i]) do
          if IsOrbital then
            Inc(OrbReserved)
          else
            Inc(SurfReserved);
    end;

    procedure addStats;
    begin
      item.SubItems.Add(CP2.ToString);
      item.SubItems.Add(CP3.ToString);
      if balstatsf then
      begin
        item.SubItems.Add(ADevLev.ToString);
        item.SubItems.Add(ATechLev.ToString);
        item.SubItems.Add(AWealthLev.ToString);
        item.SubItems.Add(AStdLivLev.ToString);
        item.SubItems.Add(ASecLev.ToString);
        item.SubItems.Add(AScore.ToString);
      end;
    end;

    procedure updSysStats(ct: TConstructionType);
    var idx,cnt: Integer;
    begin
      if ct = nil then Exit;

      ADevLev := ADevLev + ct.DevLev;
      ATechlev := ATechLev + ct.TechLev;
      ASecLev := ASecLev + ct.SecLev;
      AWealthlev := AWealthlev + ct.WealthLev;
      AStdLivLev := AStdLivLev + ct.StdLivLev;
      AScore := AScore + ct.Score;
      if ct.IsT23Port then
      begin
        ATechLev := ATechLev + ATechBonus;
        ATechBonus := 0;
      end;

      if FInflList.Count > 0 then
      if ct.Influence <> '' then
      begin
        idx := FInflList.IndexOf(ct.Influence);
        if idx > -1 then
        begin
          cnt := Integer(FInflList.Objects[idx]);
          cnt := cnt - 1;
          if cnt <= 0 then
            FInflList.Delete(idx)
          else
            FInflList.Objects[idx] := Pointer(cnt);
        end;
      end;
    end;

    function dependAllowedToBuild(nextCt: TConstructionType; var depCt: TConstructionType): Boolean;
    var availOrbSlots,availSurfSlots: Integer;
    begin
      Result := False;
      depCt := nextCt.GetFirstDependType;
      if depCt = nil then Exit;

      Result := True;
      availOrbSlots := OrbSlots - OrbReserved - Ord(nextCt.IsOrbital) - Ord(depCt.IsOrbital);
      availSurfSlots := SurfSlots - SurfReserved - Ord(not nextCt.IsOrbital) - Ord(not depCt.IsOrbital);
      if depCt.IsOrbital then
      begin
        if availOrbSlots < 0 then Result := False;
      end
      else
        if availSurfSlots < 0 then Result := False;
      if Result then
        if FInflList.Count > 0 then
          if depCt.Influence <> '' then
            if FInflList.IndexOf(depCt.Influence) < 0 then Result := False;
    end;

    function pickBestConstr(bld: TNextBuild; var ct: TConstructionType; const minPts: Extended = -100): Extended;
    var act: TConstructionType;
        i: Integer;
        pts,bestPts: Extended;
    begin
      ct := nil;
      bestPts := minPts;
      for i := 0 to DataSrc.ConstructionTypes.Count - 1 do
      begin
        act := DataSrc.ConstructionTypes.TypeByIdx[i];
        pts := 0;
        
        case bld of
          nAnyOrb: if (act.Location <> 'Orbital') then continue;
          nAnySurf: if (act.Location <> 'Surface') then continue;
          nT2Settl: if (act.Tier <> '2') or (act.Location <> 'Surface') then continue;
          nT2Orb: if (act.Tier <> '2') or (act.Location <> 'Orbital') or act.IsT23Port then continue;
          nT1Settl: if (act.Tier <> '1') or (act.Location <> 'Surface') then continue;
          nT1Orb: if (act.Tier <> '1') or (act.Location <> 'Orbital') then continue;
          nT1Port: if (act.Tier <> '1') or (act.Location <> 'Orbital') or (act.Category <> 'Outpost') then continue;
          nT1SurfPort: if (act.Tier <> '1') or (act.Location <> 'Surface') or (act.Category <> 'Planetary Port') then continue;
        end;        

//test
{
        if constrNr mod 3 = 0 then
        begin
          if act.Category = 'Outpost' then continue;
          if act.Category = 'Planetary Port' then continue;
        end;
}

        if not (bld in [nT1Port,nT1SurfPort]) then
        if not outpostsf then
        begin
          if act.Category = 'Outpost' then continue;
          if act.Category = 'Planetary Port' then continue;
        end;
        if not hubsf then
          if act.Category = 'Hub' then continue;

        if dependMode = 2 then
        begin
          //skip construction if dependencies are not there
          if not act.CheckDependencies(FConstrList) then continue
        end
        else
          //do not list dependencies if system has no slots of type needed
          //otherwise, let me always see them to decide
          if act.GetFirstDependType <> nil then
            if act.GetFirstDependType.IsOrbital then
            begin
              if OrbSlots <= 0 then continue;
            end
            else
              if SurfSlots <= 0 then continue;

        if FInflList.Count > 0 then
          if act.Influence <> '' then
          begin
            if FInflList.IndexOf(act.Influence) < 0 then continue;
            //tiny bonus if station has requested economy infl.
            //to make sure it always wins with stations with no infl.
            pts := pts + 0.0500;
          end;

//
        if nonegf then
        if not (bld in [nT1Port,nT1SurfPort]) then
        if (reqTot > 0) and (statTot <> 0) then
        begin
          if (reqStdLiv > 0) and (act.StdLivLev < 0) and (AStdLivLev < 0) then
            if (AStdLivLev < reqStdLiv-act.StdLivLev) then
              if (AStdLivLev < OrbSlots + SurfSlots) then continue;
          if (reqSec > 0) and (act.SecLev < 0) then
            if (ASecLev < reqSec-act.SecLev) then
              if (ASecLev < OrbSlots + SurfSlots) then continue;
        end;

        //do not let stats go down past zero if requested proportion is not zero
        if false then
        if nonegf then
        if not (bld in [nT1Port,nT1SurfPort]) then
        if (reqTot > 0) and (statTot <> 0) then
        begin

          {
          if (reqDev > 0) and (act.DevLev < 0) then
            if (ADevLev < reqDev-act.DevLev) or (ADevLev/statTot < reqDev/reqTot) then continue;
          if (reqTech > 0) and (act.TechLev < 0) then
            if (ATechLev < reqTech-act.TechLev) or (ATechLev/statTot < reqTech/reqTot) then continue;
          if (reqWealth > 0) and (act.WealthLev < 0) then
            if (AWealthLev < reqWealth-act.WealthLev) or (AWealthLev/statTot < reqWealth/reqTot) then continue;
          }
          if (reqStdLiv > 0) and (act.StdLivLev < 0) then
            if (AStdLivLev < reqStdLiv-act.StdLivLev) or  (AStdLivLev/statTot < reqStdLiv/reqTot) then continue;
          if (reqSec > 0) and (act.SecLev < 0) then
            if (ASecLev < reqSec-act.SecLev) or (ASecLev/statTot < reqSec/reqTot) then continue;
        end;


        //assign some tiny weight if no economy influence is selected
        pts := pts +
               act.DevLev * 0.0020 +
               act.TechLev * 0.0010 +
               act.WealthLev * 0.0005 +
               act.StdLivLev * 0.0005 +
               act.SecLev * 0.0002;

        //for T1 installations, pick the ones that have best total
        if (reqTot > 0) and (FInflList.Count = 0) then
        if bld in [nT1Orb,nT1Settl] then
        begin
          if (reqDev > 1) then pts := pts + act.DevLev;
          if (reqTech > 1) then pts := pts + act.TechLev;
          if (reqSec > 1) then pts := pts + act.SecLev;
          if (reqWealth > 1) then pts := pts + act.WealthLev;
          if (reqStdLiv > 1) then pts := pts + act.StdLivLev;
        end;

        //installation score corrected for requested proportions
        if reqTot > 0 then
          pts := pts +
            act.DevLev * reqDev/reqTot +
            act.TechLev * reqTech/reqTot +
            act.SecLev * reqSec/reqTot +
            act.WealthLev * reqWealth/reqTot +
            act.StdLivLev * reqStdLiv/reqTot;

        //if score is positive, make some slots balancing
        if slotPolicy = spBalance then
        if pts > 0 then
        begin
          if  act.IsOrbital then
          begin
            if (OrbSlots - OrbReserved) > 0 then
            if (OrbSlots - OrbReserved) - (SurfSlots - SurfReserved) > 2 then
                pts := pts + 1.0 *  ((OrbSlots - OrbReserved) - (SurfSlots - SurfReserved));
          end
          else
          begin
            if (SurfSlots - SurfReserved) > 0 then
            if (SurfSlots - SurfReserved) - (OrbSlots - OrbReserved)  > 2 then
                pts := pts + 1.0 *  ((SurfSlots - SurfReserved) - (OrbSlots - OrbReserved));
          end;
        end;

        if (reqSlot = stOrb) and act.IsOrbital then pts := pts * 3;
        if (reqSlot = stSurf) and not act.IsOrbital then pts := pts * 3;


        if (pts > bestPts) or ((ct <> nil) and (pts = bestPts) and (act.CP3 > ct.CP3)) then
        begin
          ct := act;
          bestPts := pts;
        end;
      end;

      if ct = nil then bestPts := minPts;
      Result := bestPts;
      {
      if ct <> nil then
      begin

        //correct CP3 calculation, for T2 surface assumed CP3 = 2
        if ct.Tier = '2' then
          if ct.Location = 'Surface' then
            if ct.CP3 = 1 then CP3 := CP3 - 1;


        updSysStats(ct);

        constrType := ct.StationType_full;
      end;
      }
    end;

    procedure checkStatBal(var reqStat: Integer; var AStatLev: Integer);
    begin
      if reqStat = 0 then Exit;

      //keep the stats within 5% margin of trackbar proportions
      if (AStatLev/orgStatTot > 1.05 * reqStat/reqTot) then
        reqStat := 1;

      //prioritize if stat severely lags behind
      if (AStatLev/orgStatTot < 0.10 * reqStat/reqTot) then
        reqStat := 50
      else
      if (AStatLev/orgStatTot < 0.25 * reqStat/reqTot) then
        reqStat := Min(20, reqTot div 2);
    end;

    procedure updateReqStats;
    var balStep: Integer;
    begin

      reqSec := SecTrackBar.Position;
      reqWealth := WealthTrackBar.Position;
      reqStdLiv := StdLivTrackBar.Position;
      reqDev := DevTrackBar.Position;
      reqTech := TechTrackBar.Position;

      //apply higher priority if stats go negative
      if nonegf then
      begin
        if (reqSec > 0) and (ASecLev < 0) then reqSec := 50;
        if (reqWealth > 0) and (AWealthLev < 0) then reqStdLiv := 50;
        if (reqStdLiv > 0) and (AStdLivLev < 0) then reqStdLiv := 50;
        if (reqDev > 0) and (ADevLev < 0) then reqDev := 50;
        if (reqTech > 0) and (ATechLev < 0) then reqTech := 50;
      end;

      //do some stats balancing
      //only start balancing if min. stats total is reached

      statTot := 0;
      if reqSec > 0 then statTot := statTot + ASecLev;
      if reqWealth > 0 then statTot := statTot + AWealthLev;
      if reqStdLiv > 0 then statTot := statTot + AStdLivLev;
      if reqDev > 0 then statTot := statTot + ADevLev;
      if reqTech > 0 then statTot := statTot + ATechLev;

      orgStatTot := statTot;

      if reqTot > 0 then
        if statTot > 20 then
        begin
          checkStatBal(reqDev,ADevLev);
          checkStatBal(reqTech,ATechLev);
          checkStatBal(reqWealth,AWealthLev);
          checkStatBal(reqStdLiv,AStdLivLev);
          checkStatBal(reqSec,ASecLev);
        end;


    end;

    procedure checkNextBuild(bld: TNextBuild; var bestCt: TConstructionType; var bestPts: Extended);
    var ct: TConstructionType;
        pts: Extended;
    begin
      if balstatsf then
      begin
        ct := nil;
        pts := pickBestConstr(bld,ct,bestPts);
        if ct <> nil then
        begin
          nextBuild := bld;
          bestCt := ct;
          bestPts := pts;
        end;
      end
      else
      begin
        bestCt := nil;
        if nextBuild = nNone then
          nextBuild := bld;
      end;
    end;

begin
  ListView.Clear;

  APrioConstructions.Assign(FPrioConstructions);
  FConstrList.Clear;
  for i := 0 to FCurrentSystem.Constructions.Count - 1 do
    if not TConstructionDepot(FCurrentSystem.Constructions[i]).Planned then
      FConstrList.Add(FCurrentSystem.Constructions[i]);

  dependMode := DependCombo.ItemIndex;

  slotPolicy := spNone;
  try slotPolicy := TSlotPolicy(SlotsCombo.ItemIndex); except end; 

  OrbSlots := StrToIntDef(OrbSlotsEdit.Text,0);
  SurfSlots := StrToIntDef(SurfSlotsEdit.Text,0);
  AsterSlots := StrToIntDef(AsterSlotsEdit.Text,0);

  WarnLabel.Caption := 'FAILED!';

  if OrbSlots > 300 then Exit;
  if SurfSlots > 300 then Exit;
  if AsterSlots > 300 then Exit;

  constrNr := 0;

  slotbalf := Opts['SlotBalancing'] <> '0';
  balstatsf := BalStatsCheck.Checked or EcoInflCheck.Checked;
  outpostsf := AllowOutpostsCheck.Checked;
  hubsf := AllowHubsCheck.Checked;
  portsf := AllowPortsCheck.Checked;
  nonegf := true; //no negative stats allowed; todo: on option
  FInflList.Clear;
  maxinflcnt := StrToIntDef(MaxInflEdit.Text,0);
  if EcoInflCheck.Checked then
  begin
    FInflList.Add('-');
    for i := 0 to EcoInflCheckList.Count - 1 do
    begin
      if EcoInflCheckList.State[i] = cbChecked then
         FInflList.AddObject(EcoInflCheckList.Items[i],Pointer(999));
      if EcoInflCheckList.State[i] = cbGrayed then
        if maxinflcnt > 0 then
          FInflList.AddObject(EcoInflCheckList.Items[i],Pointer(maxinflcnt));
    end;
  end;

  OrbSlots := OrbSlots - AsterSlots;

  CP2 := StrToIntDef(InitialCP2Edit.Text,0);
  CP3 := StrToIntDef(InitialCP3Edit.Text,0);

  cp2Cost := 3;
  cp3Cost := 6;
  t23ports := 0;
  t1ports := 0;
  while FT23Ports > t23ports do
  begin
    Inc(t23ports);
    if t23ports >= 2 then
    begin
      cp2Cost := cp2Cost + 2;
      cp3Cost := cp3Cost + 6;
    end;
  end;


  t1ToBuild := 0;
  t2ToBuild := 0;
  t3ToBuild := 0;
  t1SurfToBuild := 0;
  t3SurfToBuild := 0;

  OrbReserved := 0;
  SurfReserved := 0;

  prioIdx := 0;

  if GoalCombo.ItemIndex = 0 then t3ToBuild := 99;
  if GoalCombo.ItemIndex = 1 then t2ToBuild := 99;
  if GoalCombo.ItemIndex = 2 then
  begin
    t3SurfToBuild := StrToIntDef(GoalT3SurfEdit.Text,0);
    t1SurfToBuild := StrToIntDef(GoalT1SurfEdit.Text,0);
    t3ToBuild := StrToIntDef(GoalT3OrbEdit.Text,0);
    t2ToBuild := StrToIntDef(GoalT2OrbEdit.Text,0);
    t1ToBuild := StrToIntDef(GoalT1OrbEdit.Text,0);
  end;

  updateReserved;

  ADevLev := FDevLev;
  ATechlev := FTechLev;
  ASecLev := FSecLev;
  AWealthlev := FWealthlev;
  AStdLivLev := FStdLivLev;
  AScore := FScore;
  ATechBonus := FTechBonus;


  if balstatsf then
  begin
    reqSec := SecTrackBar.Position;
    reqWealth := WealthTrackBar.Position;
    reqStdLiv := StdLivTrackBar.Position;
    reqDev := DevTrackBar.Position;
    reqTech := TechTrackBar.Position;
    reqTot := reqSec + reqWealth + reqStdLiv + reqDev + reqTech;


    item := ListView.Items.Add;
    item.Caption := '';
    item.SubItems.Add('');
    item.SubItems.Add('( initial stats )');
    addStats;

//    updateReqStats;
  end;


  asteroidOnlyf := False;
  lastReqSlot := stAny;

  while (OrbSlots + AsterSlots > 0) or (SurfSlots > 0) do
  begin
    t23portf := false;
    primaryf := false;
    nextBuild := nNone;
    reqBuild := nNone;
    prioT3portf := false;
    nextCt := nil;
    if balstatsf then
      updateReqStats;

    case slotPolicy of
      spAlternate: 
        if lastReqSlot = stOrb then
          reqSlot := stSurf
        else  
          reqSlot := stOrb;
      spOrbFirst: reqSlot := stOrb;
      spSurfFirst: reqSlot := stSurf;
    else  
      reqSlot := stAny;
    end;
    

    if (OrbSlots <= 0) and (SurfSlots <= 0) then 
    begin
      if CP2 >= cp2Cost then
        nextBuild := nT2Aster;
      asteroidOnlyf := True;
    end
    else
    if prioIdx < APrioConstructions.Count then
    begin
      nextCt := TConstructionType(APrioConstructions.Objects[prioIdx]);
      if APrioConstructions[prioIdx] = '00000' then //primary
      begin
        primaryf := True;
        nextBuild := nPrio;
      end
      else
      begin
        if nextCt.IsT23port then
        begin
          if nextCt.Tier = '2' then
            if CP2 >= cp2cost then
              nextBuild := nPrio
            else
              reqBuild := nT1Inst;
          if nextCt.Tier = '3' then
            if CP3 >= cp3cost then
              nextBuild := nPrio
            else
            begin
              prioT3portf := true;
              reqBuild := nT2Inst;
            end;
        end
        else
        begin
          if (CP2 + nextCt.CP2 >= 0) and (CP3 + nextCt.CP3 >= 0) then nextBuild := nPrio;

          if nextBuild <> nPrio then
          begin
            if CP2 + nextCt.CP2 < 0 then
              reqBuild := nT1Inst
            else
              if (CP2 > 0) and (CP3 + nextCt.CP3 < 0) then
                reqBuild := nT2Inst
              else
                reqBuild := nT1Inst;
          end;
        end;
        if nextBuild <> nPrio then nextCt := nil;
      end;
    end
    else
    begin
      if t1SurfToBuild > 0 then
        reqBuild := nT1SurfPort
      else
      if t1ToBuild > 0 then
        reqBuild := nT1Port
      else
      if t3SurfToBuild > 0 then
         reqBuild := nT3SurfPort
      else
      if t3ToBuild > 0 then
      begin
        reqBuild := nT3Port;
      end
      else
        if t2ToBuild > 0 then
          reqBuild := nT2Port;


      //under most circumstances, t3 is priority
      //however, if t2 is ALSO requested and we are still under penalty
      //build one t2 first as this will get us one CP3 point
      if reqBuild in [nT3Port,nT3SurfPort] then
        if (t23ports = 0) and (t2ToBuild > 0) then
          reqBuild := nT2Port;
          

      case reqBuild of
        nT1SurfPort:
          begin
            if SurfSlots > 0 then
              nextBuild := nT1SurfPort
            else
            begin
              t1SurfToBuild := -1;
              continue;
            end;
          end;
        nT1Port:
          begin
            if OrbSlots > 0 then
              nextBuild := nT1Port
            else
            begin
              t1ToBuild := -1;
              continue;
            end;
          end;
        nT3SurfPort:  
          begin
            if (SurfSlots > 0) and (CP3 >= cp3Cost) then
              nextBuild := nT3SurfPort
            else
            if CP2 > 0 then
              reqBuild := nT2Inst
            else
              reqBuild := nT1Inst;
          end;
        nT3Port:  
          begin
            if (OrbSlots > 0) and (CP3 >= cp3Cost) then
              nextBuild := nT3Port
            else
            if CP2 > 0 then
              reqBuild := nT2Inst
            else
              reqBuild := nT1Inst;
          end;
        nT2Port:  
          begin
            if (AsterSlots > 0) and (CP2 >= cp2Cost) then
              nextBuild := nT2Aster
            else
            if (OrbSlots > 0) and (CP2 >= cp2Cost) then
              nextBuild := nT2Port
            else
              reqBuild := nT1Inst;
          end;
      else  
        if balstatsf then
        begin
          if portsf then
          begin
            if (SurfSlots > 0) and (CP3 >= cp3Cost) then
              nextBuild := nT3SurfPort;
            if (OrbSlots > 0) and (CP3 >= cp3Cost) then
              nextBuild := nT3Port;
            if (OrbSlots > 0) and (CP2 >= cp2Cost) then
              nextBuild := nT2Port;
          end;
          if nextBuild = nNone then
            reqBuild := nAnyInst;
        end;        
      end;   
    end;

    nextPts := -100;
    constrType := '';
    constrTag := '';

    if reqBuild in [nT2Inst,nAnyInst,nAnyOrb,nAnySurf] then
    begin
      //nextBuild := nNone;
      if CP2 > 0 then
      begin
        if (SurfSlots > SurfReserved) or (OrbSlots = 0) then
          checkNextBuild(nT2Settl,nextCt,nextPts);
        if (OrbSlots > OrbReserved) or (SurfSlots = 0) then
          if nextBuild = nNone then
            checkNextBuild(nT2Orb,nextCt,nextPts)
          else
          //check for T2Orb better than T2Settl only if
          // - more free orb. slots than surf.
          // - all T3 ports are done
            if (reqBuild in [nAnyInst,nAnyOrb]) or ((OrbSlots-OrbReserved) - (SurfSlots-SurfReserved) > 0) then
            if not prioT3portf and (t3ToBuild + t3SurfToBuild = 0) then
              checkNextBuild(nT2Orb,nextCt,nextPts);
      end;
      if nextBuild = nNone then
        reqBuild := nT1Inst;
    end;

    if reqBuild in [nT1Inst,nAnyInst,nAnyOrb,nAnySurf] then
    begin
      //nextBuild := nNone;
      if (OrbSlots > OrbReserved) or (SurfSlots = 0) then
        checkNextBuild(nT1Orb,nextCt,nextPts);
      if (SurfSlots > SurfReserved) or (OrbSlots = 0) then
        if nextBuild = nNone then
          checkNextBuild(nT1Settl,nextCt,nextPts)
        else
          //check for T1Settl better than T1Orb only if
          // - more free surf. slots than orb.
          // - all T3 ports are done
           if (SurfSlots-SurfReserved) - (OrbSlots-OrbReserved) > 0 then
           if not prioT3portf and (t3ToBuild + t3SurfToBuild = 0) then
             checkNextBuild(nT1Settl,nextCt,nextPts)
    end;

    if balstatsf then
      if reqBuild in [nT1Orb,nT2Orb,nT1Settl,nT2Settl,nAnyInst,nAnyOrb,nAnySurf] then
      begin
        if nextCt = nil then
          pickBestConstr(nextBuild,nextCt);
      end;

    if dependMode = 1 then
    if nextCt <> nil then
    if nextCt.Dependencies <> '' then
    if not nextCt.CheckDependencies(FConstrList) then
    if dependAllowedToBuild(nextCt,depCt) then
    if APrioConstructions.IndexOfObject(depCt) < 0 then
    begin
      APrioConstructions.InsertObject(prioIdx,'D',nextCt);
      APrioConstructions.InsertObject(prioIdx,'D',depCt);
      continue;
    end;


    case nextBuild of
      nPrio:
        begin
          if APrioConstructions[prioIdx] <> 'D' then
            constrTag := '✏';
          constrType := nextCt.StationType_full;
          if nextCt.IsOrbital then
          begin
            if (AsterSlots > 0) and (nextCt.Id = 'StaAst2') then
              Dec(AsterSlots)
            else
              Dec(OrbSlots);
          end
          else
            Dec(SurfSlots);
          if primaryf then
          begin
            if nextCt.CP2 > 0 then CP2 := CP2 + nextCt.CP2;
            if nextCt.CP3 > 0 then CP3 := CP3 + nextCt.CP3;
          end
          else
          begin
            CP2 := CP2 + nextCt.CP2;
            CP3 := CP3 + nextCt.CP3;
            if nextCt.Tier >= '2' then
              if (nextCt.Category = 'Starport') or (nextCt.Category = 'Planetary Port') then
                t23portf := true;
          end;
          prioIdx := prioIdx + 1;
        end;
      nT3Port:
        begin
          nextCt := DataSrc.ConstructionTypes.GetTypeById('StaOrb3');
          constrType := 'T3 Orbital Port';
          Dec(OrbSlots);
          CP3 := CP3 - cp3Cost;
          t23portf := true;
          if t3ToBuild > 0 then t3ToBuild := t3ToBuild - 1;
        end;
      nT3SurfPort:
        begin
          nextCt := DataSrc.ConstructionTypes.GetTypeById('PlaPor3');
          constrType := 'T3 Surface Port';
          Dec(SurfSlots);
          CP3 := CP3 - cp3Cost;
          t23portf := true;
          if t3SurfToBuild > 0 then t3SurfToBuild := t3SurfToBuild - 1;
        end;
      nT2Aster:
        begin
          nextCt := DataSrc.ConstructionTypes.GetTypeById('StaAst2');
          constrType := 'T2 Asteroid Base';
          if AsterSlots > 0 then
            Dec(AsterSlots)
          else  
            Dec(OrbSlots);
          CP2 := CP2 - cp2Cost;
          CP3 := CP3 + 1;
          t23portf := true;
          if t2ToBuild > 0  then t2ToBuild := t2ToBuild - 1;
        end;
      nT1Port:
        begin
          checkNextBuild(nT1Port,nextCt,nextPts);
          constrType := 'T1 Orbital Outpost';
          if nextCt <> nil then
            constrType := nextCt.StationType_full;
          Dec(OrbSlots);
          CP2 := CP2 + 1;
          t1ToBuild := t1ToBuild - 1;
       end;
      nT1SurfPort:
        begin
          checkNextBuild(nT1SurfPort,nextCt,nextPts);
          constrType := 'T1 Surface Port';
          if nextCt <> nil then
            constrType := nextCt.StationType_full;
          Dec(SurfSlots);
          CP2 := CP2 + 1;
          t1SurfToBuild := t1SurfToBuild - 1;
          Inc(t1ports);
       end;
      nT2Port:
        begin
          nextCt := DataSrc.ConstructionTypes.GetTypeById('StaCor2');
          constrType := 'T2 Orbital Port';
          Dec(OrbSlots);
          CP2 := CP2 - cp2Cost;
          CP3 := CP3 + 1;
          t23portf := true;
          if t2ToBuild > 0  then t2ToBuild := t2ToBuild - 1;
       end;
      nT2Settl:
       begin
          Dec(SurfSlots);
          if nextCt = nil then
          begin
            constrType := '     T2 Surface Settlement';
            CP3 := CP3 + 2;
            CP2 := CP2 - 1;
          end
          else
          begin
            CP3 := CP3 + nextCt.CP3;
            CP2 := CP2 + nextCt.CP2;
          end;
        end;
      nT2Orb:
        begin
          Dec(OrbSlots);
          CP3 := CP3 + 1;
          CP2 := CP2 - 1;
          constrType := '     T2 Orbital Installation';
        end;
      nT1Orb:
        begin
          Dec(OrbSlots);
          CP2 := CP2 + 1;
          constrType := '  T1 Orbital Installation';
        end;
      nT1Settl:
        begin
          Dec(SurfSlots);
          CP2 := CP2 + 1;
          constrType := '  T1 Surface Settlement';
        end;
    end;

    if nextCt <> nil then
    begin
      if not (nextBuild in [nT2Port,nT3Port,nT3SurfPort,nT2Aster]) then
        constrType := nextCt.StationType_full;
      FConstrList.Add(nextCt);
      updSysStats(nextCt);
      //updateReqStats(false);

      if (nextCt.Tier = '1') and nextCt.IsPort then
        Inc(t1ports);
    end;

    lastReqSlot := reqSlot;
      

    item := ListView.Items.Add;
    if nextBuild <> nNone then
    begin
      Inc(constrNr);
      item.Caption := constrNr.ToString;
      item.SubItems.Add(constrTag);
      item.SubItems.Add(constrType);
      addStats;
      if balstatsf  then
        if nextCt <> nil then
          item.SubItems.Add(nextCt.Influence);
      item.Data := nextCt;
      //item.SubItems.Add(Ord(t23portf).ToString);
      if nextCt <> nil then
        if not nextCt.CheckDependencies(FConstrList) then
        begin
          item := ListView.Items.Add;
          item.Caption := '';
          item.SubItems.Add('');
          item.SubItems.Add('   --- missing: ' + nextCt.Requirements);
          item.Data := nextCt.GetFirstDependType;
        end;
    end
    else
    begin
      item.Caption := '';
      item.SubItems.Add('');
      s := '  ( slots left: ';
      if OrbSlots > 0 then s := s + OrbSlots.ToString + ' orb.; ';
      if SurfSlots > 0 then s := s + SurfSlots.ToString + ' surf.; ';
      if AsterSlots > 0 then s := s + AsterSlots.ToString + ' ast.; ';
      s := s + ' )';
      item.SubItems.Add(s);
      item.SubItems.Add('');
      item.SubItems.Add('');
      item.SubItems.Add('');
      item.SubItems.Add('');
      item.SubItems.Add('');
      item.SubItems.Add('');
      item.SubItems.Add('');
    end;

    if t23portf then
    begin
      Inc(t23ports);
      if t23ports >= 2 then
      begin
        cp2Cost := cp2Cost + 2;
        cp3Cost := cp3Cost + 6;
      end;
    end;


    if asteroidOnlyf then break;
    if nextBuild = nNone then break;

    updateReserved;

  end;
  NewPortsLabel.Caption := (t23ports-FT23Ports).ToString;
  AllPortsLabel.Caption := (t23ports+Ord(FT23Primary)).ToString;
  DevLabel.Caption := ADevLev.ToString;
  TechLabel.Caption := ATechlev.ToString;
  SecLabel.Caption := ASecLev.ToString;
  WealthLabel.Caption := AWealthlev.ToString;
  StdLivLabel.Caption := AStdLivLev.ToString;
  ScoreLabel.Caption := AScore.ToString;


  s := '';
  if prioIdx < APrioConstructions.Count then
    s := 'Failed to build all planned; ';
  if GoalCombo.ItemIndex = 2 then
  begin
    if t1ToBuild <> 0 then s := s + 'T1 goal failed; ';
    if t1SurfToBuild <> 0 then s := s + 'T1 Surf. goal failed; ';
    if t2ToBuild <> 0 then s := s + 'T2 goal failed; ';
    if t3ToBuild <> 0 then s := s + 'T3 goal failed; ';
    if t3SurfToBuild <> 0 then s := s + 'T3 Surf. goal failed; ';
  end;
  WarnLabel.Caption := s;

  ListView.ItemIndex := ListView.Items.Count - 1;
  if ListView.Selected <> nil then
    ListView.Selected.MakeVisible(False);
end;

procedure TSolverForm.TechTrackBarChange(Sender: TObject);
begin
  BalStatsCheck.Checked := True;
end;

end.
