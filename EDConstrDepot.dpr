program EDConstrDepot;

uses
  Vcl.Forms,
  Main in 'Main.pas' {EDCDForm},
  Splash in 'Splash.pas' {SplashForm},
  Markets in 'Markets.pas' {MarketsForm},
  Vcl.Themes,
  Vcl.Styles,
  System.SysUtils,
  Settings in 'Settings.pas',
  DataSource in 'DataSource.pas',
  SettingsGUI in 'SettingsGUI.pas' {SettingsForm},
  Colonies in 'Colonies.pas' {ColoniesForm},
  SystemPict in 'SystemPict.pas' {SystemPictForm},
  SystemInfo in 'SystemInfo.pas' {SystemInfoForm},
  StationInfo in 'StationInfo.pas' {StationInfoForm},
  MarketInfo in 'MarketInfo.pas' {MarketInfoForm},
  ConstrTypes in 'ConstrTypes.pas' {ConstrTypesForm},
  Toolbar in 'Toolbar.pas' {ToolbarForm},
  ToolTip in 'ToolTip.pas' {TooltipForm},
  StarMap in 'StarMap.pas' {StarMapForm},
  Summary in 'Summary.pas' {SummaryForm},
  Bodies in 'Bodies.pas' {BodiesForm},
  Memo in 'Memo.pas' {MemoForm},
  Solver in 'Solver.pas' {SolverForm},
  BodyInfo in 'BodyInfo.pas' {BodyInfoForm},
  MaterialList in 'MaterialList.pas' {MaterialListForm},
  TradeRoutes in 'TradeRoutes.pas' {TradeRoutesForm},
  Chart in 'Chart.pas' {ChartForm},
  Dashboard in 'Dashboard.pas' {DashboardForm};

{$R *.res}

const gNiceVersion: string = 'Release 33, build 1';

{
changes:
 - colonization charts and dashboard
 - Settings toolbar button replaced with Main Menu button (includes Settings command)
 - Dashboard command in Main Menu with Colony Summary and preselected charts
 - create charts for selected colonies with Chart command in Colonies windows
 - create general charts with Chart command in Summary window
 - menu button and Select All commands for Colonies and Markets/Constructions list


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
  DataSrc.UpdTimer.Enabled := True;

  //SplashForm.Hide;  //this sometimes fails from wrong message processing
  SplashForm.ShowInfo('Ready.',1);
  SplashForm.Update;

  Application.Run;
end.
