unit Splash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TSplashForm = class(TForm)
    InfoLabel: TLabel;
    HideTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure HideTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowInfo(s: string; timer: Integer);
  end;

var
  SplashForm: TSplashForm;

implementation

{$R *.dfm}

uses Main;

procedure TSplashForm.FormCreate(Sender: TObject);
begin
  InfoLabel.Font := EDCDForm.TextColLabel.Font;   //it's already changed from settings here
  self.Font := InfoLabel.Font;
end;

procedure TSplashForm.ShowInfo(s: string; timer: Integer);
begin
  InfoLabel.Caption := s;
  InfoLabel.Height := self.Canvas.TextHeight('Wq');
  InfoLabel.Width := self.Canvas.TextWidth(InfoLabel.Caption);
  self.Height := InfoLabel.Height + 4;
  self.Width := InfoLabel.Width + 40;
  Show;
  HideTimer.Interval := timer;
  HideTimer.Enabled := timer <> 0;
end;

procedure TSplashForm.HideTimerTimer(Sender: TObject);
begin
  Hide;
  HideTimer.Enabled := False;
end;

end.
