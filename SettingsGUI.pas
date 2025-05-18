unit SettingsGUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type TUserOpt = class
  Name: string;
  Desc: string;
  Low: Integer;
  High: Integer;
  SubType: string;
end;

type
  TSettingsForm = class(TForm)
    ListView: TListView;
    Label1: TLabel;
    FontDialog: TFontDialog;
    procedure FormShow(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FUserOpts: TList;
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

uses Settings, Main, Markets;

procedure TSettingsForm.FormCreate(Sender: TObject);
var i: Integer;

  procedure DefineOpt(n,c: string;l,h: Integer; styp: string);
  var opt: TUserOpt;
  begin
    opt := TUserOpt.Create;
    with opt do
    begin
      Name := n;
      Desc := c;
      Low := l;
      High := h;
      SubType := styp;
    end;
    FUserOpts.Add(opt);
  end;

  procedure DefineFlag(n,c: string);
  begin
    DefineOpt(n,c,0,1,'');
  end;

begin
  FUserOpts := TList.Create;

  DefineOpt('FontName','',0,0,'font');
  DefineOpt('FontSize','',1,255,'');
  DefineOpt('Color','hex color code',0,0,'hex');
  DefineOpt('FontGlow','0-255 transition between font color and background',0,255,'');
  DefineOpt('Backdrop','0-transparent; 1-opaque; 2-shadowed',0,2,'');
  DefineOpt('AlphaBlend','0-255 shadow intensity if Backdrop=2',0,255,'');
  DefineOpt('AlwaysOnTop','0-not on top; 1-always on top; 2-on top of E:D window only',0,2,'');
  DefineOpt('AutoSort','0-alphabetical; 1-by market availability; 2-by category and availability',0,2,'');
  DefineFlag('TrackMarkets','automatically track visited markets');
//  DefineFlag('IncludeFinished','* allow finished constructions for selection');
  DefineFlag('ShowUnderCapacity','');
  DefineFlag('ShowProgress','');
  DefineFlag('ShowFlightsLeft','');
  DefineFlag('ShowRecentMarket','');
  DefineFlag('ShowBestMarket','');
  DefineFlag('ShowDividers','');
  DefineFlag('ShowIndicators','');
  DefineFlag('ShowCloseBox','');
  DefineFlag('TransparentTitle','');
  DefineFlag('MarketsDarkMode','changes market list background to dark');

  for i := 0 to ListView.Columns.Count - 1 do
  begin
//    ListView.Column[i].Width := -2;
  end;
//  ListView.SortType := stText;

end;

procedure TSettingsForm.FormShow(Sender: TObject);
var i: Integer;
    item: TListItem;
    s: string;
    sl: TStringList;
begin
  sl := TStringList.Create;
  ListView.SortType := stNone;
  ListView.Items.Clear;
  ListView.Items.BeginUpdate;
  for i := 0 to FUserOpts.Count - 1 do
  begin
    with TUserOpt(FUserOpts[i]) do
    begin
      item := ListView.Items.Add;
      item.Caption := Name;
      item.SubItems.Add(Opts[Name]);
      item.SubItems.Add(Desc);
    end;
    item.Data := FUserOpts[i];
  end;
  ListView.Items.EndUpdate;
  sl.Free;
end;

procedure TSettingsForm.ListViewDblClick(Sender: TObject);
var opt: TUserOpt;
    i: Integer;
    s,orgs: string;
begin
  opt := TUserOpt(ListView.Selected.Data);
  if opt.SubType = '' then
    if opt.High = 1 then
      Opts.Flags[opt.Name] := not Opts.Flags[opt.Name]
    else
    if  (opt.High-opt.Low > 1) and (opt.High-opt.Low < 6) then
    begin
      i := StrToIntDef(Opts[opt.Name],0);
      i := i + 1;
      if i > opt.High then i := opt.Low;
      Opts[opt.Name] := IntToStr(i);
    end
    else
    begin
      orgs := Opts[opt.Name];
      s := Vcl.Dialogs.InputBox(opt.Name, 'Value', orgs);
      i := StrToInt(s);
      if (i < opt.Low) or (i > opt.High) then Exit;
      Opts[opt.Name] := IntToStr(i);
    end;
  if opt.SubType = 'hex' then
  begin
    orgs := Opts[opt.Name];
    s := Vcl.Dialogs.InputBox(opt.Name, 'Value', orgs);
    if s <> '' then
      i := StrToInt('$' + s);
    Opts[opt.Name] := s;
  end;

  if opt.SubType = 'font' then
  begin
    if FontDialog.Execute then
      Opts[opt.Name] := FontDialog.Font.Name;
  end;

  ListView.Selected.SubItems[0] := Opts[opt.Name];
  EDCDForm.OnChangeSettings;
  MarketsForm.ApplySettings;
end;

end.
