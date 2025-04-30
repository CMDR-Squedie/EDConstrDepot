unit Splash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TSplashForm = class(TForm)
    InfoLabel: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
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
  InfoLabel.Height := self.Canvas.TextHeight('Wq');
  InfoLabel.Width := self.Canvas.TextWidth(InfoLabel.Caption);
  self.Height := InfoLabel.Height + 4;
  self.Width := InfoLabel.Width + 40;
end;

end.
