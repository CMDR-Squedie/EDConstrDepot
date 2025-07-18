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
  StarMap in 'StarMap.pas' {StarMapForm};

{$R *.res}

const gNiceVersion: string = 'Release 26, build 3';

{
  Build 4:
   - optional system elevation (Y) marks (for colonies & targets only, measured against middle plane)
   - colony map button in toolbar
   - systems can now belong to multiple task groups (separated with comma)
   - selected system label is always on top of map
   - colonies filter now also supports '+' sign
   - task group field added to System Info view
   - Architect can be assigned directly in System Info view
   - option to clear EDSM scan in System Info view
   - holding Shift when using System Info button in toolbar opens current system
   - new 'E' star lane type that favors short lanes
   - Empty material list now only shows for actual depots
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
