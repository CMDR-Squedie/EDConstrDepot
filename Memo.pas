unit Memo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMemoForm = class(TForm)
    Memo: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MemoForm: TMemoForm;

implementation

{$R *.dfm}

end.
