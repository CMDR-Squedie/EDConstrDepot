unit Summary;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Menus, Vcl.StdCtrls;

type
  TSummaryForm = class(TForm)
    ListView: TListView;
    PopupMenu: TPopupMenu;
    CopyMenuItem: TMenuItem;
    CmdrComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure CopyMenuItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CmdrComboBoxChange(Sender: TObject);
    procedure ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateItems;
  public
    { Public declarations }
    procedure RestoreAndShow;
    procedure ApplySettings;
  end;

var
  SummaryForm: TSummaryForm;

implementation

{$R *.dfm}

uses DataSource, Main, Settings, Clipbrd, Bodies;

procedure TSummaryForm.CmdrComboBoxChange(Sender: TObject);
begin
  UpdateItems;
end;

procedure TSummaryForm.UpdateItems;
var i,i2: Integer;
    item: TListItem;
    sys: TStarSystem;
    isColonyf: Boolean;
    totPop: Int64;
    totHaul,totScore,totSystems,totConstr,totT3,totT2,totT1surf,totT1orb: Integer;
    totSystems10,totSystems100,totSystems1b,totShipyards: Integer;
    totELW,totWW,totAW,totELW2,totWW2,totAW2,totELW3,totWW3,totAW3: Integer;
    totLandRings,totG4,totG5,totGW,totGH,
      totLandOxy,totLandHelium,totAbundLife,totLandAtmMoons,totWaterGeysers,totMetalRings,totLandTiny: Integer;
    ct: TConstructionType;
    s: string;

    procedure addHeader(s: string);
    begin
      item := ListView.Items.Add;
      item.Caption := s;
      item.SubItems.Add('');
    end;

    procedure addStat(s: string; v: Int64; const inclzerof: Boolean = True; const fs: string = '');
    begin
      if v = 0 then
        if not inclzerof then Exit;
      item := ListView.Items.Add;
      item.Caption := '    ' + s;
      item.SubItems.Add(Format('%.0n', [double(v)]));
      item.SubItems.Add(fs);
    end;

begin
  ListView.Items.Clear;

  DataSrc.UpdateSystemStations;


  totPop := 0;
  totScore := 0;
  totSystems := 0;
  totSystems10 := 0;
  totSystems100 := 0;
  totSystems1b := 0;
  totHaul := 0;
  totT3 := 0;
  totT2 := 0;
  totT1orb := 0;
  totT1surf := 0;
  totConstr := 0;
  totShipyards := 0;
  totELW := 0;
  totWW := 0;
  totAW := 0;
  totELW2 := 0;
  totWW2 := 0;
  totAW2 := 0;
  totELW3 := 0;
  totWW3 := 0;
  totAW3 := 0;
  totLandRings := 0;
  totLandAtmMoons := 0;
  totWaterGeysers := 0;
  totLandHelium := 0;
  totLandOxy := 0;
  totAbundLife := 0;
  totG4 := 0;
  totG5 := 0;
  totGH := 0;
  totGW := 0;
  totMetalRings := 0;
  totLandTiny := 0;
  for i := 0 to DataSrc.StarSystems.Count - 1 do
  begin
    sys := DataSrc.StarSystems[i];
    isColonyf := (sys.Architect <> '') and (sys.PrimaryDone or (sys.Population > 0));
    if not isColonyf then continue;
    if CmdrComboBox.ItemIndex = 0 then
    begin
      if DataSrc.Commanders.Values[sys.Architect] = '' then continue;
    end
    else
      if sys.ArchitectName <> CmdrComboBox.Text then continue;

    sys.UpdateMoons;

    totPop := totPop + sys.Population;
    totScore := totScore + sys.GetScore;
    Inc(totSystems);
    if sys.Population >= 1000000000 then
      Inc(totSystems1b)
    else
    if sys.Population >= 100000000 then
      Inc(totSystems100)
    else
    if sys.Population >= 10000000 then
      Inc(totSystems10);


    if sys.Constructions <> nil then
    for i2 := 0 to sys.Constructions.Count - 1 do
      with TConstructionDepot(sys.Constructions[i2]) do
      if Finished then
      begin
        Inc(totConstr);
        ct := GetConstrType;
        totHaul := totHaul + ActualHaul;
        if ct <> nil then
        begin
          if ActualHaul = 0 then totHaul := totHaul + ct.EstCargo;
          if ct.Tier = '3' then Inc(totT3);
          if ct.Tier = '2' then
            if ct.Category = 'Starport' then Inc(totT2);
          if ct.Tier = '1' then
          begin
            if ct.Category = 'Outpost' then Inc(totT1orb);
            if ct.Category = 'Planetary Port' then Inc(totT1surf);
          end;

        end;
      end;

    if sys.Stations <> nil then
    for i2 := 0 to sys.Stations.Count - 1 do
      with TMarket(sys.Stations[i2]) do
      begin
        if Pos('shipyard',Services) > 0 then Inc(totShipyards);
        //if Pos('outfitting',m.Services) > 0  then s := s + '⚒OF ';
        //if Pos('exploration',m.Services) > 0  then s := s + '🌐UC ';
        //if Pos('facilitator',m.Services) > 0  then s := s + '⚖IF ';

      end;

    if sys.Bodies <> nil then
    for i2 := 0 to sys.Bodies.Count - 1 do
      if sys.Bodies[i2] <> '?' then
      with TSystemBody(sys.Bodies.Objects[i2]) do
      begin
        s := LowerCase(BodyName) + LowerCase(BodyType);
        if Pos('earth',s) > 0 then
        begin
          Inc(totELW);
          if HasRings then Inc(totELW2);
          if HasMoons then Inc(totELW3);
        end;

        if Pos('water world',s) > 0 then
        begin
          Inc(totWW);
          if HasRings then Inc(totWW2);
          if HasMoons then Inc(totWW3);
        end;
        if Pos('ammonia world',s) > 0 then
        begin
          Inc(totAW);
          if HasRings then Inc(totAW2);
          if HasMoons then Inc(totAW3);
        end;
        if Landable then
        begin
          if HasRings then Inc(totLandRings);
          if Pos('helium',LowerCase(Atmosphere)) > 0 then Inc(totLandHelium);
          if Pos('oxygen',LowerCase(Atmosphere)) > 0 then Inc(totLandOxy);
          if BiologicalSignals > 4 then Inc(totAbundLife);
          if Atmosphere <> '' then
            if IsMoon then
              if HasMoons then Inc(totLandAtmMoons);
          if (Radius > 0) and (Radius < 250) then Inc(totLandTiny);
          if GeologicalSignals > 0 then
            if Pos('major water',LowerCase(Volcanism)) > 0 then Inc(totWaterGeysers);

        end;
        if Pos('giant',s) > 0 then
        begin
          if Pos('class iv',s) > 0 then Inc(totG4);
          if Pos('class v',s) > 0 then Inc(totG5);
          if Pos('helium',s) > 0 then Inc(totGH);
          if Pos('water giant',s) > 0 then Inc(totGW);
        end;

        if IsRing then
          if Pos('metallic',s) > 0 then
            if Pos('belt',s) <= 0 then
              Inc(totMetalRings);
      end;


  end;

  addHeader('GENERAL');
  addStat('Population',totPop);
  addStat('Score',totScore);
  addStat('Base Income',10000*totScore);
  addStat('Number of Systems',totSystems);
  addStat('  - popul. 10-100m',totSystems10);
  addStat('  - popul. 100m-1b',totSystems100,false);
  addStat('  - popul. over 1b',totSystems1b,false);

  addHeader('CONSTRUCTIONS');
  addStat('T3 Ports (Orbis, Ocellus, Surf. Port)',totT3);
  addStat('T2 Ports (Coriolis, Asteroid)',totT2);
  addStat('T1 Surface Ports',totT1surf);
  addStat('T1 Orbital Outposts',totT1orb);
  addStat('Facilities and other inst.',totConstr - totT3 - totT2 - totT1surf - totT1orb);
  addStat('Constructions - total',totConstr);
  addStat('Cargo Haul (t)',totHaul);

  addHeader('FACILITIES');
  addStat('Shipyards',totShipyards);

  addHeader('PLANETS OF INTEREST');
  addStat('Earth-like worlds',totELW,false,'earth');
  addStat('  - w/Rings',totELW2,false,'earth+rings');
// addStat('  - w/Moons',totELW3,false);
  addStat('Water worlds',totWW,false,'water world');
  addStat('  - w/Rings',totWW2,false,'water world+rings');
//  addStat('  - w/Moons',totWW3,false);
  addStat('Ammonia worlds',totAW,false,'ammonia world');
  addStat('  - w/Rings',totAW2,false,'ammonia world+rings');
//  addStat('  - w/Moons',totAW3,false);
  addStat('Class IV Giants',totG4,false,'class iv');
  addStat('Class V Giants',totG5,false,'class v');
  addStat('Helium Giants',totGH,false,'helium+giant');
  addStat('Water Giants',totGW,false,'water giant');
  addStat('Landable w/Rings',totLandRings,false,'land+rings');
  addStat('Landable w/Oxygen',totLandOxy,false,'land+oxy');
  addStat('Landable w/Helium',totLandHelium,false,'land+helium');
  addStat('Landable w/Bio-diversity (min.5)',totAbundLife,false,'land+bio');
  addStat('Landable Moon w/Atm. and Moons',totLandAtmMoons,false,'land+atmo+moons');
  addStat('Landable w/Major Water Geysers',totWaterGeysers,false,'land+major water+geo');
  addStat('Tiny Landable',totLandTiny,false,'land+tiny');
  addStat('Planetary Rings - Metallic',totMetalRings,false, 'metallic+ring+~belt+~magma');

end;

procedure TSummaryForm.RestoreAndShow;
begin
  if WindowState = wsMinimized then WindowState := wsNormal;
  Show;
end;

procedure TSummaryForm.ApplySettings;
var i,fs: Integer;
    fn: string;
    clr: TColor;
begin
  ShowInTaskBar := Opts.Flags['ShowInTaskbar'];
  if not Opts.Flags['DarkMode'] then
  begin
    with ListView do
    begin
      Color := clSilver;
      Font.Color := clBlack;
    end;
  end
  else
  begin
    clr := EDCDForm.TextColLabel.Font.Color;
    with ListView do
    begin
      Color := $6B5E4F; //$484848; $585140
      Font.Color := clr;
    end;
  end;
  with ListView do
  begin
    Font.Name := Opts['FontName2'];
    Font.Size := Opts.Int['FontSize2'];
  end;

end;

procedure TSummaryForm.CopyMenuItemClick(Sender: TObject);
var s: string;
    i: Integer;
begin
  s := '';
  for i := 0 to ListView.Items.Count - 1 do
    s := s + ListView.Items[i].Caption + Chr(9) + ListView.Items[i].SubItems[0] + Chr(13);
  Clipboard.AsText := s;
end;

procedure TSummaryForm.FormCreate(Sender: TObject);
begin
  ApplySettings;
  ListView.Items.Clear;
end;

procedure TSummaryForm.FormShow(Sender: TObject);
var i: Integer;
begin
  for i := CmdrComboBox.Items.Count - 1 downto 1 do
    CmdrComboBox.Items.Delete(i);
  for i := 0 to DataSrc.Commanders.Count - 1 do
    CmdrComboBox.Items.Add(DataSrc.Commanders.ValueFromIndex[i]);
  CmdrComboBox.ItemIndex := 0;
  UpdateItems;
end;

procedure TSummaryForm.ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.SubItems[0] = '' then
    Sender.Canvas.Font.Style := [fsItalic]
  else
    Sender.Canvas.Font.Style := [];

  if cdsSelected in State then
  begin
    Sender.Canvas.Brush.Color := clHighLight;
  end
  else
  begin
    Sender.Canvas.Brush.Color := ListView.Color;
    if Item.SubItems[0] = '' then
      Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color - $202020;
  end;

end;

procedure TSummaryForm.ListViewDblClick(Sender: TObject);
begin
  if ListView.Selected = nil then Exit;
  if ListView.Selected.SubItems.Count < 2 then Exit;
  if ListView.Selected.SubItems[1] = '' then Exit;
  BodiesForm.BeginFilterChange;
  try
    BodiesForm.ColoniesCheck.Checked := True;
    BodiesForm.ColonTargetsCheck.Checked := False;
    BodiesForm.ColonCandidatesCheck.Checked := False;
    BodiesForm.OtherSystemsCheck.Checked := False;
    BodiesForm.InclIgnoredCheck.Checked := True;
    BodiesForm.FilterEdit.Text := ListView.Selected.SubItems[1];
  finally
    BodiesForm.EndFilterChange;
  end;
  BodiesForm.UpdateAndShow;
end;

end.
