program EDConstrDepot;

uses
  Vcl.Forms,
  Main in 'Main.pas' {EDCDForm},
  Splash in 'Splash.pas' {SplashForm},
  Vcl.Themes,
  Vcl.Styles,
  Settings in 'Settings.pas',
  DataSource in 'DataSource.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ED Construction Depot';
  Application.CreateForm(TEDCDForm, EDCDForm);
  Application.CreateForm(TSplashForm, SplashForm);
  Application.Run;
end.
