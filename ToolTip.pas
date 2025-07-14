unit ToolTip;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Math;

type
  TTooltipForm = class(TForm)
    InfoLabel: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ApplySettings;
  end;

var
  TooltipForm: TTooltipForm;

implementation

{$R *.dfm}

uses Main, Settings;

procedure TTooltipForm.ApplySettings;
begin
  Font.Name := Opts['FontName'];
  Font.Color := EDCDForm.TextColLabel.Font.Color;
  Font.Size := EDCDForm.TextColLabel.Font.Size;
  Height := Max(Font.Size + 6,Canvas.TextHeight('Wq') + 2);
end;

procedure TTooltipForm.FormCreate(Sender: TObject);
begin
  ApplySettings;
end;

end.
