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
  MaterialList in 'MaterialList.pas' {MaterialListForm},
  Toolbar in 'Toolbar.pas' {ToolbarForm},
  ToolTip in 'ToolTip.pas' {TooltipForm},
  StarMap in 'StarMap.pas' {StarMapForm},
  Summary in 'Summary.pas' {SummaryForm},
  Bodies in 'Bodies.pas' {BodiesForm},
  Memo in 'Memo.pas' {MemoForm},
  Solver in 'Solver.pas' {SolverForm};

{$R *.res}

const gNiceVersion: string = 'Release 28, build 1';

{
}

{
  future builds:
 - economy commodity dependencies
 - free slots per body
 - 'asteroid' slots
 - find similar economy market

  tentative:
 - Population Map layer
 - set faction for non-dockable stations
 - POIs
 - force show system on map
 - custom star lanes
 - biggest station name layer  +  show biggest station on select
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
  Application.CreateForm(TMaterialListForm, MaterialListForm);
  Application.CreateForm(TTooltipForm, TooltipForm);
  Application.CreateForm(TStarMapForm, StarMapForm);
  Application.CreateForm(TSummaryForm, SummaryForm);
  Application.CreateForm(TBodiesForm, BodiesForm);
  Application.CreateForm(TMemoForm, MemoForm);
  Application.CreateForm(TSolverForm, SolverForm);
  SettingsForm.VersionLabel.Caption := gNiceVersion;

  Application.OnActivate :=  EDCDForm.AppActivate;
  Application.OnDeactivate :=  EDCDForm.AppDeactivate;


  SplashForm.ShowInfo('Reading journal files...',0);
  SplashForm.Update;
  DataSrc.Load;
  EDCDForm.UpdateConstrDepot;
  SplashForm.Hide;
  EDCDForm.Show;
  EDCDForm.BringToFront;
  DataSrc.UpdTimer.Enabled := True;

  Application.Run;
end.
