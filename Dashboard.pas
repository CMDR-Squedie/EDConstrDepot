unit Dashboard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.Skia, Vcl.Skia,
  System.StrUtils, System.IniFiles, System.DateUtils, Vcl.StdCtrls;

type
  TDashboardForm = class(TForm)
    GridPanel1: TGridPanel;
    Panel1: TPanel;
    MenuLabel: TLabel;
    RefreshLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SvgDblClick(Sender: TObject);
    procedure RefreshLabelClick(Sender: TObject);
  private
    FMaxRows: Integer;
    FMaxCols: Integer;
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateCharts(const cmdr: string = ''; const taskGroup: string = '');
  end;

var
  DashboardForm: TDashboardForm;

implementation

{$R *.dfm}

uses Summary, Chart, DataSource, Settings;


procedure TDashboardForm.FormCreate(Sender: TObject);
var
  row, col: Integer;
  Svg: TSkSvg;
  id: string;
const
   defChartIDs: array [0..2,0..2] of string = (
     ('POPHISTM','CONTRIBD30','CONTRIBW90'),
     ('SCOREHIST','TOP24DEVTECH','FINCONSCORE'),
     ('TOP12POP','TOP12POPINC','TOP12SCORE'));
begin
  FMaxRows := StrToIntDef(Opts.Val['Dashboard.Rows'],3);
  FMaxCols := StrToIntDef(Opts.Val['Dashboard.Cols'],3);;



  ShowInTaskBar := Opts.Flags['ShowInTaskbar'];

  GridPanel1.ControlCollection.Clear;
  GridPanel1.RowCollection.Clear;
  GridPanel1.ColumnCollection.Clear;

  GridPanel1.Padding.SetBounds(0, 0, 0, 0);

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
      id := Opts.Val['Dashboard.Chart' + (row+1).ToString + (col+1).ToString];
      if (id = '') and (row < 3) and (col < 3) then
        id := defChartIDs[row,col];
      Svg.Tag := NativeInt(TChartData.Create(id)); //row * maxCols + col;

      Svg.OnDblClick := SvgDblClick;

      GridPanel1.ControlCollection.AddControl(Svg, col, row);
    end;

end;

procedure TDashboardForm.FormShow(Sender: TObject);
begin
  UpdateCharts;
end;

procedure TDashboardForm.RefreshLabelClick(Sender: TObject);
begin
  UpdateCharts;
end;

procedure TDashboardForm.SvgDblClick(Sender: TObject);
var cd: TChartData;
begin
  cd := TChartData(TSkSvg(Sender).Tag);
  with TChartForm.Create(Application) do
  begin
    //SvgArea.Svg.Source := TSkSvg(Sender).Svg.Source;
    //Show;
    CreateChart(cd.dataSeries,cd.title,cd.chartOptions,cd.labStep,cd.chartType,
      cd.colorScheme,cd.barThickness);
  end;
end;


procedure TDashboardForm.UpdateCharts(const cmdr: string = ''; const taskGroup: string = '');
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
        cd.cmdr := cmdr;
        cd.taskGroup := taskGroup;
        cd.Update;
        Svg.Source := cd.svgSource;
      end;
    end;
end;

end.
