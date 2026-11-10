program EDConstrDepot;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  System.SysUtils,

  Splash         in 'src\utils\Splash.pas' {SplashForm},
  Toolbar        in 'src\utils\Toolbar.pas' {ToolbarForm},
  ToolTip        in 'src\utils\ToolTip.pas' {TooltipForm},
  Memo           in 'src\utils\Memo.pas' {MemoForm},

  Main           in 'src\Main.pas' {EDCDForm},
  DataSource     in 'src\data\DataSource.pas',
  Settings       in 'src\settings\Settings.pas',

  SettingsGUI    in 'src\settings\SettingsGUI.pas' {SettingsForm},

  Markets        in 'src\browse\Markets.pas' {MarketsForm},
  Colonies       in 'src\browse\Colonies.pas' {ColoniesForm},
  Bodies         in 'src\browse\Bodies.pas' {BodiesForm},
  ConstrTypes    in 'src\browse\ConstrTypes.pas' {ConstrTypesForm},
  MaterialList   in 'src\browse\details\MaterialList.pas' {MaterialListForm},
  MarketInfo     in 'src\browse\details\MarketInfo.pas' {MarketInfoForm},
  BodyInfo       in 'src\browse\details\BodyInfo.pas' {BodyInfoForm},

  StarMap        in 'src\map\StarMap.pas' {StarMapForm},

  SystemPict     in 'src\colony\SystemPict.pas' {SystemPictForm},
  SystemInfo     in 'src\colony\SystemInfo.pas' {SystemInfoForm},
  StationInfo    in 'src\colony\StationInfo.pas' {StationInfoForm},
  Solver         in 'src\colony\Solver.pas' {SolverForm},

  Chart          in 'src\dashboard\Chart.pas' {ChartForm},
  Summary        in 'src\dashboard\Summary.pas' {SummaryForm},
  Dashboard      in 'src\dashboard\Dashboard.pas' {DashboardForm},

  TradeRoutes    in 'src\wip\TradeRoutes.pas' {TradeRoutesForm};

{$R *.res}

const gNiceVersion: string = 'Release 34, build 1';

{
  changes
  - customizable dashboard (select charts and set dashboard dimensions)
  - more chart types, chart options and ability to save the default chart setup
  - mini-chart in main overlay with current construction progress and projected daily haul
  - collapse main overlay by double-clicking the title bar (3 modes)
  - commander's missions (as a simulated construction)
  - limited star map depth and ability to change it
  - option to temporarily turn off map labels

  future builds:
 - 'asteroid' slots
 - find similar economy market
 - force show system on map  (other than objective)
 - custom star lanes
 - merge routes, edit routes
 - biggest station name layer  +  show biggest station on select

  tentative:
 - POIs
}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.Title := 'ED Construction Depot';

  Opts := TSettings.Create(GetCurrentDir + '\' + 'EDConstrDepot.ini');
  Opts.Load;
  TEDDataSource.Create(Application);

  Application.CreateForm(TEDCDForm, EDCDForm);
  Application.CreateForm(TSplashForm, SplashForm);
  Application.CreateForm(TToolbarForm, ToolbarForm);
  Application.CreateForm(TMarketsForm, MarketsForm);
  Application.CreateForm(TColoniesForm, ColoniesForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TMarketInfoForm, MarketInfoForm);
  Application.CreateForm(TSystemPictForm, SystemPictForm);
  Application.CreateForm(TSystemInfoForm, SystemInfoForm);
  Application.CreateForm(TStationInfoForm, StationInfoForm);
  Application.CreateForm(TConstrTypesForm, ConstrTypesForm);
  Application.CreateForm(TTooltipForm, TooltipForm);
  Application.CreateForm(TStarMapForm, StarMapForm);
  Application.CreateForm(TSummaryForm, SummaryForm);
  Application.CreateForm(TBodiesForm, BodiesForm);
  Application.CreateForm(TMemoForm, MemoForm);
  Application.CreateForm(TSolverForm, SolverForm);
  Application.CreateForm(TBodyInfoForm, BodyInfoForm);
  Application.CreateForm(TTradeRoutesForm, TradeRoutesForm);
  Application.CreateForm(TMaterialListForm, MaterialListForm);
  Application.CreateForm(TDashboardForm, DashboardForm);


  SettingsForm.VersionLabel.Caption := gNiceVersion;

  Application.OnActivate :=  EDCDForm.AppActivate;
  Application.OnDeactivate :=  EDCDForm.AppDeactivate;


  SplashForm.ShowInfo('Reading journal files...',0);
  SplashForm.Update;

  DataSrc.Load;

  //Application.ProcessMessages;

  EDCDForm.UpdateConstrDepot;
  EDCDForm.Show;
  EDCDForm.BringToFront;

  EDCDForm.UpdTimer.Enabled := True;
  DataSrc.UpdTimer.Enabled := True;

  //SplashForm.Hide;  //this sometimes fails from wrong message processing
  SplashForm.ShowInfo('Ready.',1);
  SplashForm.Update;

  Application.Run;
end.
