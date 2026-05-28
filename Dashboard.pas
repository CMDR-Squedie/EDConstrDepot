unit Dashboard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.Skia, Vcl.Skia,
  System.StrUtils, System.IniFiles, System.DateUtils, Vcl.StdCtrls, Vcl.Menus, System.Math,
  System.IOUtils;

type
  TDashboardForm = class(TForm)
    GridPanel1: TGridPanel;
    Panel1: TPanel;
    MenuLabel: TLabel;
    RefreshLabel: TLabel;
    PopupMenu: TPopupMenu;
    ChartTypeSubMenu: TMenuItem;
    SingleSeries1: TMenuItem;
    ChartTypeMenuItem: TMenuItem;
    Line2: TMenuItem;
    C1: TMenuItem;
    N3: TMenuItem;
    DualSeries1: TMenuItem;
    StackedColumn1: TMenuItem;
    DualSecondary1: TMenuItem;
    ComboSecondary1: TMenuItem;
    ScatterPlot1: TMenuItem;
    ColorSchemeSubMenu: TMenuItem;
    ColorSchemeMenuItem: TMenuItem;
    FixedColor2: TMenuItem;
    CyclicGolden1: TMenuItem;
    CyclicGolden2: TMenuItem;
    Gradient1: TMenuItem;
    GradientPurpletoYellowY1: TMenuItem;
    GradientHottoColdY1: TMenuItem;
    GradientTealY1: TMenuItem;
    RedToGreen1: TMenuItem;
    RedToGrayToGreenX1: TMenuItem;
    ChartOptionsSubMenu: TMenuItem;
    N1: TMenuItem;
    CopyDataMenuItem: TMenuItem;
    SaveChartMenuItem: TMenuItem;
    GradientFlameY1: TMenuItem;
    GradientSkyY1: TMenuItem;
    CategoryColoring1: TMenuItem;
    SaveSettingsMenuItem: TMenuItem;
    RestoreSetupMenuItem: TMenuItem;
    N4: TMenuItem;
    AxisGrid1: TMenuItem;
    MoreGridLines1: TMenuItem;
    CleanGridSteps1: TMenuItem;
    AverageLine1: TMenuItem;
    ReversedAxis1: TMenuItem;
    N5: TMenuItem;
    Values1: TMenuItem;
    ValueLabels1: TMenuItem;
    MilestoneMarkers1: TMenuItem;
    N6: TMenuItem;
    Other1: TMenuItem;
    BarSeparation1: TMenuItem;
    AdjustDataSeriesSubMenu: TMenuItem;
    AdjustDataSeries1MenuItem: TMenuItem;
    ExcludeZeros1: TMenuItem;
    ShortenTimeline1: TMenuItem;
    YTD1: TMenuItem;
    N12months1: TMenuItem;
    N6months1: TMenuItem;
    N3months1: TMenuItem;
    op121: TMenuItem;
    op241: TMenuItem;
    NextColorSchemeMenuItem: TMenuItem;
    N7: TMenuItem;
    SelectChartMenuItem: TMenuItem;
    ChartPanel: TPanel;
    ChartListBox: TListBox;
    Label1: TLabel;
    N2: TMenuItem;
    LinearPalette1: TMenuItem;
    N9: TMenuItem;
    FilterCategories1: TMenuItem;
    N10: TMenuItem;
    SortAscending1: TMenuItem;
    Sort1: TMenuItem;
    ColdToWarm1: TMenuItem;
    PurpletoYellow1: TMenuItem;
    Emerald1: TMenuItem;
    RainForest1: TMenuItem;
    Peppermint1: TMenuItem;
    PinkToCyan1: TMenuItem;
    BlueToSand1: TMenuItem;
    Lavender1: TMenuItem;
    exludezeros1: TMenuItem;
    SegmentedBars1: TMenuItem;
    LargeLabels1: TMenuItem;
    SharedScaleDual1: TMenuItem;
    N8: TMenuItem;
    ColorPolicySubMenu: TMenuItem;
    CategoryColors1: TMenuItem;
    ValueColors1: TMenuItem;
    RotateGradient901: TMenuItem;
    FlipPalette1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SvgDblClick(Sender: TObject);
    procedure RefreshLabelClick(Sender: TObject);
    procedure ChartTypeMenuItemClick(Sender: TObject);
    procedure ColorSchemeMenuItemClick(Sender: TObject);
    procedure ChartOptionMenuItemClick(Sender: TObject);
    procedure SaveSettingsMenuItemClick(Sender: TObject);
    procedure RestoreSetupMenuItemClick(Sender: TObject);
    procedure AdjustDataSeries1MenuItemClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure NextColorSchemeMenuItemClick(Sender: TObject);
    procedure SelectChartMenuItemClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure ChartListBoxDblClick(Sender: TObject);
    procedure CopyDataMenuItemClick(Sender: TObject);
    procedure SaveChartMenuItemClick(Sender: TObject);
  private
    FMaxRows: Integer;
    FMaxCols: Integer;
    { Private declarations }
    procedure ReloadCharts(const id: string = '');
  public
    { Public declarations }
    procedure UpdateCharts(const filterUpdf: Boolean = false; const cmdr: string = ''; const taskGroup: string = '');
    procedure ApplySettings;
  end;

var
  DashboardForm: TDashboardForm;

implementation

{$R *.dfm}

uses Summary, Chart, DataSource, Settings, Main, Clipbrd;


procedure TDashboardForm.AdjustDataSeries1MenuItemClick(Sender: TObject);
var cd: TChartData;
begin
  with TSkSvg(PopupMenu.PopupComponent) do
    if Tag <> 0 then
    begin
      cd := TChartData(Tag);
      cd.ToggleDataAdj(TDataAdjustment(TControl(Sender).Tag));
      Svg.Source := cd.svgSource;
    end;
end;

procedure TDashboardForm.ChartListBoxDblClick(Sender: TObject);
var cd: TChartData;
begin
  with TSkSvg(ChartListBox.Tag) do
  begin
    cd := TChartData(Tag);
    if cd = nil then Exit;
    cd.id := ChartList.Names[ChartListBox.ItemIndex];
    //cd.LoadSetup;
    cd.ResetSetup;
    cd.Update;
    Svg.Source := cd.svgSource;

    Opts.Val['DashboardChart.' + Integer(HelpContext).ToString] := cd.id;
    Opts.Save;
  end;
  ChartPanel.Hide;
end;

procedure TDashboardForm.ChartOptionMenuItemClick(Sender: TObject);
var co: TChartOption;
    cd: TChartData;
begin
  co := TChartOption(TMenuItem(Sender).Tag);
  with TSkSvg(PopupMenu.PopupComponent) do
    if Tag <> 0 then
    begin
      cd := TChartData(Tag);
      if co in cd.chartOptions then
        cd.chartOptions := cd.chartOptions - [co]
      else
      begin
        if co in cChartColorModes then
          cd.chartOptions := cd.chartOptions - cChartColorModes;
        cd.chartOptions := cd.chartOptions + [co];
      end;
      cd.UpdateSvg;
      Svg.Source := cd.svgSource;
    end;
end;

procedure TDashboardForm.ChartTypeMenuItemClick(Sender: TObject);
var cd: TChartData;
begin
  with TSkSvg(PopupMenu.PopupComponent) do
    if Tag <> 0 then
    begin
      cd := TChartData(Tag);
      cd.chartType := TChartType(TMenuItem(Sender).Tag);
      cd.UpdateSvg;
      Svg.Source := cd.svgSource;
    end;
end;

procedure TDashboardForm.ColorSchemeMenuItemClick(Sender: TObject);
var cd: TChartData;
begin
  with TSkSvg(PopupMenu.PopupComponent) do
    if Tag <> 0 then
    begin
      cd := TChartData(Tag);
      cd.colorScheme := TChartColorScheme(TMenuItem(Sender).Tag);
      cd.Update;
      Svg.Source := cd.svgSource;
    end;
end;

procedure TDashboardForm.CopyDataMenuItemClick(Sender: TObject);
var cd: TChartData;
begin
  with TSkSvg(PopupMenu.PopupComponent) do
    if Tag <> 0 then
    begin
      cd := TChartData(Tag);
      Clipboard.AsText := cd.dataSeries.Text;
    end;
end;

procedure TDashboardForm.ApplySettings;
var
  i, row, col: Integer;
  Svg: TSkSvg;
  id: string;
const
   defChartIDs: array [0..2,0..2] of string = (
     ('SCOREHIST','CONTRIBD30','CONTRIBW90'),
     ('POPHISTM','TOP24DEVTECH','FINCONSCORE'),
     ('POPUPD','TOP12POPS','TOP12SCORE'));
begin

  ShowInTaskBar := Opts.Flags['ShowInTaskbar'];

  if (FMaxRows = Opts.Int['DashboardRows']) and (FMaxCols = Opts.Int['DashboardCols']) then Exit;

  for row := 0 to GridPanel1.RowCollection.Count - 1 do
    for col := 0 to GridPanel1.ColumnCollection.Count - 1 do
    begin
      Svg := TSkSvg(GridPanel1.ControlCollection.Controls[col,row]);
      if Svg <> nil then
      begin
        TChartData(Svg.Tag).Free;
        Svg.Free;
      end;
    end;

  GridPanel1.DisableAlign;
  try
    GridPanel1.ControlCollection.Clear;
    GridPanel1.RowCollection.Clear;
    GridPanel1.ColumnCollection.Clear;
    GridPanel1.Padding.SetBounds(0, 0, 0, 0);

    FMaxRows := Opts.Int['DashboardRows'];
    FMaxCols := Opts.Int['DashboardCols'];


    for col := 0 to FMaxCols - 1 do
      with GridPanel1.ColumnCollection.Add do
        SizeStyle := ssPercent;

    for row := 0 to FMaxRows - 1 do
      with GridPanel1.RowCollection.Add do
        SizeStyle := ssPercent;

    for row := 0 to FMaxRows - 1 do
      for col := 0 to FMaxCols - 1 do
      begin
        Svg := TSkSvg.Create(Self);
        Svg.Parent := GridPanel1;
        Svg.Align := alClient;
        Svg.Margins.SetBounds(0, 0, 0, 0);
        Svg.HelpContext := (row+1) * 10  + (col+1);
        id := Opts.Val['DashboardChart.' + Integer(Svg.HelpContext).ToString];
        if (id = '') and (row < 3) and (col < 3) then
          id := defChartIDs[row,col];
        Svg.Tag := NativeInt(TChartData.Create(id,'D' + Integer(Svg.HelpContext).ToString)); //row * maxCols + col;
        Svg.PopupMenu := self.PopupMenu;

        Svg.OnDblClick := SvgDblClick;

        GridPanel1.ControlCollection.AddControl(Svg, col, row);
      end;
  finally
    GridPanel1.EnableAlign;
  end;

  if Visible then
    UpdateCharts(true);
end;

procedure TDashboardForm.FormCreate(Sender: TObject);
var i: Integer;
begin
  for i := 0 to ChartList.Count - 1 do
    ChartListBox.Items.Add(ChartList.ValueFromIndex[i] + '  (' + ChartList.Names[i] + ')');

  ApplySettings;
  EDCDForm.ChartArea.PopupMenu := DashboardForm.PopupMenu;
  EDCDForm.ChartArea.OnDblClick := SvgDblClick;
end;

procedure TDashboardForm.FormShow(Sender: TObject);
begin
  UpdateCharts(true);
end;

procedure TDashboardForm.Label1Click(Sender: TObject);
begin
  ChartPanel.Hide;
end;

procedure TDashboardForm.NextColorSchemeMenuItemClick(Sender: TObject);
var cs: Integer;
    cd: TChartData;
begin
  with TSkSvg(PopupMenu.PopupComponent) do
  begin
    cd := TChartData(Tag);
    if cd = nil then Exit;
    cs := Ord(cd.colorScheme);
    cs := cs + 1;
    if cs > Ord(High(TChartColorScheme)) then cs := 0;
    cd.colorScheme := TChartColorScheme(cs);
    cd.UpdateSvg;
    Svg.Source := cd.svgSource;
  end;
end;

procedure TDashboardForm.PopupMenuPopup(Sender: TObject);
var i: Integer;
    cd: TChartData;
begin
  SelectChartMenuItem.Visible := DashboardForm.Active;
  cd := TChartData(TSkSvg(PopupMenu.PopupComponent).Tag);
  if cd <> nil then
  begin
    for i := 0 to ChartTypeSubMenu.Count -1 do
      ChartTypeSubMenu.Items[i].Checked :=
        TChartType(ChartTypeSubMenu.Items[i].Tag) = cd.chartType;
    for i := 0 to ColorSchemeSubMenu.Count -1 do
      ColorSchemeSubMenu.Items[i].Checked :=
        TChartColorScheme(ColorSchemeSubMenu.Items[i].Tag) = cd.colorScheme;
    for i := 0 to ColorPolicySubMenu.Count -1 do
      ColorPolicySubMenu.Items[i].Checked :=
        TChartOption(ColorPolicySubMenu.Items[i].Tag) in cd.chartOptions;
    for i := 0 to ChartOptionsSubMenu.Count -1 do
      ChartOptionsSubMenu.Items[i].Checked :=
        TChartOption(ChartOptionsSubMenu.Items[i].Tag) in cd.chartOptions;
    for i := 0 to AdjustDataSeriesSubMenu.Count -1 do
      AdjustDataSeriesSubMenu.Items[i].Checked :=
        TDataAdjustment(AdjustDataSeriesSubMenu.Items[i].Tag) in cd.dataAdjustments;

  end;
end;

procedure TDashboardForm.RefreshLabelClick(Sender: TObject);
begin
  UpdateCharts(false);
end;

procedure TDashboardForm.RestoreSetupMenuItemClick(Sender: TObject);
var cd: TChartData;
begin
  with TSkSvg(PopupMenu.PopupComponent) do
    if Tag <> 0 then
    begin
      cd := TChartData(Tag);
      cd.ResetSetup;
      cd.Update;
      Svg.Source := cd.svgSource;
      //if Parent <> DashboardForm then
      if DashboardForm.Visible then
        DashboardForm.ReloadCharts(cd.id);
    end;
end;

procedure TDashboardForm.SaveChartMenuItemClick(Sender: TObject);
var cd: TChartData;
begin
  with TSkSvg(PopupMenu.PopupComponent) do
    TFile.WriteAllText('chart.svg', Svg.Source, TEncoding.UTF8);
end;

procedure TDashboardForm.SaveSettingsMenuItemClick(Sender: TObject);
var cd: TChartData;
begin
  with TSkSvg(PopupMenu.PopupComponent) do
    if Tag <> 0 then
    begin
      cd := TChartData(Tag);
      cd.SaveSetup;
      //if Parent <> DashboardForm then
      if DashboardForm.Visible then
        DashboardForm.ReloadCharts(cd.id);
    end;
end;

procedure TDashboardForm.SelectChartMenuItemClick(Sender: TObject);
begin
  ChartPanel.Left := TSkSvg(PopupMenu.PopupComponent).Left + 20;
  ChartPanel.Top := TSkSvg(PopupMenu.PopupComponent).Top + 20;
  ChartPanel.Visible := True;
  ChartPanel.Width := Min(480,GridPanel1.Width div GridPanel1.ColumnCollection.Count - 20);
  ChartPanel.Height := Min(320,GridPanel1.Height div GridPanel1.RowCollection.Count - 20);
  ChartListBox.Tag := NativeInt(PopupMenu.PopupComponent);
end;

procedure TDashboardForm.SvgDblClick(Sender: TObject);
var cd,ncd: TChartData;
begin
  cd := TChartData.Create('','');
  cd.Assign(TChartData(TSkSvg(Sender).Tag));
  cd.chartOptions := cd.chartOptions - cTransientOptions;
  with TChartForm.Create(Application) do
    CreateChart(cd);
end;


procedure TDashboardForm.UpdateCharts(const filterUpdf: Boolean = false;
  const cmdr: string = ''; const taskGroup: string = '');
var i,row,col: Integer;
  cd: TChartData;
begin
  DataSrc.UpdateSystemStations;

  for row := 0 to FMaxRows - 1 do
    for col := 0 to FMaxCols - 1 do
    with TSkSvg(GridPanel1.ControlCollection.Controls[col,row]) do
    begin
      if Tag <> 0 then
      begin
        cd := TChartData(Tag);
        if filterUpdf then
        begin
          cd.cmdr := cmdr;
          cd.taskGroup := taskGroup;
        end;
        cd.Update;
        Svg.Source := cd.svgSource;
      end;
    end;
end;

procedure TDashboardForm.ReloadCharts(const id: string = '');
var i,row,col: Integer;
  cd: TChartData;
begin
  for row := 0 to FMaxRows - 1 do
    for col := 0 to FMaxCols - 1 do
    with TSkSvg(GridPanel1.ControlCollection.Controls[col,row]) do
    begin
      if Tag <> 0 then
      begin
        cd := TChartData(Tag);
        if (id = '') or (cd.id = id) then
        begin
          cd.LoadSetup;
          cd.Update;
          Svg.Source := cd.svgSource;
        end;
      end;
    end;
end;

end.
