unit SettingsGUI;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

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
    FontDialog: TFontDialog;
    Panel1: TPanel;
    VersionLabel: TLabel;
    UpdLinkLabel: TLinkLabel;
    BackupJournalLink: TLinkLabel;
    procedure FormShow(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdLinkLabelLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure BackupJournalLinkLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FUserOpts: TList;
    procedure UpdateList;
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

uses Settings, Main, Markets, MarketInfo, DataSource, Splash, Colonies,
  SystemInfo, StationInfo, ConstrTypes, MaterialList, Toolbar;

procedure TSettingsForm.BackupJournalLinkLinkClick(Sender: TObject;
  const Link: string; LinkType: TSysLinkType);
begin
  if Vcl.Dialogs.MessageDlg('Are you sure you want create a journal backup?' + Chr(13) +
    '(These files can be moved to a new machine and put in E:D Saved Games folder.)' ,
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  SplashForm.ShowInfo('Backing up journal...',0);
  try
    DataSrc.DoBackup;
  finally
    SplashForm.Hide;
  end;
end;

procedure TSettingsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Opts.Save;
end;

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
  DefineOpt('Color','hex color code for font color',0,0,'hex');
  DefineFlag('DarkMode','changes color scheme to dark');
  DefineOpt('FontGlow','0-255 transition between font color and background',0,255,'');
  DefineOpt('Backdrop','0-transparent; 1-opaque; 2-shadowed',0,2,'');
  DefineOpt('AlphaBlend','0-255 shadow intensity (if Backdrop=2)',0,255,'');
  DefineFlag('AutoAlphaBlend','automatic shadow intensity (if Backdrop=2)');
  DefineFlag('ClickThrough','transparent to in-game clicks (Alt-Tab/Menu key to re-activate)');
  DefineFlag('ScanMenuKey','when in-game, press and hold Quick Menu key to activate the app');
  DefineOpt('AlwaysOnTop','0-not on top; 1-always on top; 2-on top of E:D window only',0,2,'');
  DefineOpt('AutoSort','0-alphabetical; 1-by market availability; 2-by category and availability',0,2,'');
  DefineFlag('TrackMarkets','automatically track visited markets');
  DefineFlag('AutoSnapshots','auto-create market history on economy change');
  DefineFlag('IncludeFinished','allow finished constructions for menu selection');
  DefineFlag('ShowUnderCapacity','');
  DefineOpt('ShowProgress','0-no info; 1-beneath the list; 2-in the title bar',0,2,'');
  DefineOpt('ShowFlightsLeft','0-no info; 1-beneath the list; 2-in the title bar',0,2,'');
  DefineFlag('ShowStarSystem','star system abbrev. in title bar');
  DefineFlag('ShowDelTime','includes delivery time left, recent and average dock-to-dock time');
  DefineFlag('ShowRecentMarket','');
  DefineFlag('ShowBestMarket','');
  DefineFlag('ShowDividers','');
  DefineOpt('ShowIndicators','0-no indicators; 1-solid/hollow indicators; 2-hollow indicators only',0,2,'');
  DefineFlag('ShowDistance','shows number of jumps there and back and exact Ly distance to markets');
  DefineOpt('IncludeSupply','0-no supply hint; 1-full capacity supply; 2-full request supply',0,2,'');
  DefineFlag('ShowCloseBox','');
  DefineFlag('TransparentTitle','');
  DefineOpt('FontName2','font name for secondary windows (markets, colonies etc.)',0,0,'font');
  DefineOpt('FontSize2','font size for secondary windows',1,255,'');

  for i := 0 to ListView.Columns.Count - 1 do
  begin
//    ListView.Column[2].Width := -1;
  end;
  ListView.Column[2].Width := -1;
end;

procedure TSettingsForm.UpdateList;
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
      s := Opts[Name];
      if SubType = '' then
        if High = 1 then
          if s = '1' then s := '✓' else s := '';
      item.SubItems.Add(s);
      item.SubItems.Add(Desc);
    end;
    item.Data := FUserOpts[i];
  end;
  ListView.Items.EndUpdate;
  sl.Free;
end;

procedure TSettingsForm.UpdLinkLabelLinkClick(Sender: TObject;
  const Link: string; LinkType: TSysLinkType);
begin
  ShellExecute(0, 'open', PChar(Link), nil, nil, SW_SHOWNORMAL);
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  UpdateList;
end;

procedure TSettingsForm.ListViewDblClick(Sender: TObject);
var opt: TUserOpt;
    i: Integer;
    s,orgs: string;
begin
  if ListView.Selected = nil then Exit;
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
    FontDialog.Font.Name := Opts[opt.Name];
    if FontDialog.Execute then
      Opts[opt.Name] := FontDialog.Font.Name;
  end;

  //ListView.Selected.SubItems[0] := Opts[opt.Name];
  UpdateList;
  for i := 0 to Application.ComponentCount - 1 do
    if Application.Components[i] is TEDCDForm then
      TEDCDForm(Application.Components[i]).OnChangeSettings;
  MarketsForm.ApplySettings;
  MarketInfoForm.ApplySettings;
  ColoniesForm.ApplySettings;
  SystemInfoForm.ApplySettings;
  StationInfoForm.ApplySettings;
  ConstrTypesForm.ApplySettings;
  MaterialListForm.ApplySettings;
  ToolbarForm.ApplySettings;
end;

end.
