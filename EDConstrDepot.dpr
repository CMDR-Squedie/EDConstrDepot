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
  MarketInfo in 'MarketInfo.pas' {MarketInfoForm};

{$R *.res}

const gNiceVersion: string = 'Release 21, build 1';

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.Title := 'ED Construction Depot';

  Opts := TSettings.Create(GetCurrentDir + '\' + 'EDConstrDepot.ini');
  Opts.Load;
  DataSrc := TEDDataSource.Create(Application);

  Application.CreateForm(TEDCDForm, EDCDForm);
  Application.CreateForm(TSplashForm, SplashForm);
  Application.CreateForm(TMarketsForm, MarketsForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TMarketInfoForm, MarketInfoForm);

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
