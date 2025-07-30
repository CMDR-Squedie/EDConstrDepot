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

uses DataSource, Main, Settings, Clipbrd;

procedure TSummaryForm.CmdrComboBoxChange(Sender: TObject);
begin
  UpdateItems;
end;

procedure TSummaryForm.UpdateItems;
var i,i2: Integer;
    item: TListItem;
    sys: TStarSystem;
    isColonyf: Boolean;
    totPop,totScore,totSystems,totHaul,totConstr,totT3,totT2,totT1surf,totT1orb: Integer;
    totSystems10,totSystems100,totShipyards: Integer;
    totELWs,totWWs,totAWs,totLandRings: Integer;
    ct: TConstructionType;
    s: string;

    procedure addHeader(s: string);
    begin
      item := ListView.Items.Add;
      item.Caption := s;
      item.SubItems.Add('');
    end;

    procedure addStat(s: string; v: Integer; const inclzerof: Boolean = True);
    begin
      if v = 0 then
        if not inclzerof then Exit;
      item := ListView.Items.Add;
      item.Caption := '    ' + s;
      item.SubItems.Add(Format('%.0n', [double(v)]));
    end;

begin
  ListView.Items.Clear;

  DataSrc.UpdateSystemStations;


  totPop := 0;
  totScore := 0;
  totSystems := 0;
  totSystems10 := 0;
  totSystems100 := 0;
  totHaul := 0;
  totT3 := 0;
  totT2 := 0;
  totT1orb := 0;
  totT1surf := 0;
  totConstr := 0;
  totShipyards := 0;
  totELWs := 0;
  totWWs := 0;
  totAWs := 0;
  totLandRings := 0;
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


    totPop := totPop + sys.Population;
    totScore := totScore + sys.GetScore;
    Inc(totSystems);
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
      with TSystemBody(sys.Bodies.Objects[i2]) do
      begin
        s := LowerCase(BodyType);
        if Pos('earth',s) > 0 then Inc(totELWs);
        if Pos('water world',s) > 0 then Inc(totWWs);
        if Pos('ammonia world',s) > 0 then Inc(totAWs);
        if Landable and HasRings then Inc(totLandRings);
      end;


  end;

  addHeader('GENERAL');
  addStat('Population',totPop);
  addStat('Score',totScore);
  addStat('Base Income',10000*totScore);
  addStat('Number of Systems',totSystems);
  addStat('  - pop. 10-100m',totSystems10);
  addStat('  - pop. over 100m',totSystems100);

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
  addStat('Earth-like worlds',totELWs,false);
  addStat('Water worlds',totWWs,false);
  addStat('Ammonia worlds',totAWs,false);
  addStat('Landable w/Rings',totLandRings,false);

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

end.
