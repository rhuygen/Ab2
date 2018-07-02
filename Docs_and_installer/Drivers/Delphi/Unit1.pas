unit Unit1;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  PI_GCS2_DLL,
  StdCtrls,
  ExtCtrls,
  TeeProcs,
  TeEngine,
  Teeprevi,
  Chart,
  Series,
  Math, ComCtrls;

type
  TForm1=class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    Label4: TLabel;
    Panel2: TPanel;
    CmdComboBox: TComboBox;
    Label6: TLabel;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Memo1: TMemo;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1             : TForm1;
  g_iD              : INTEGER;
  xLine             : TFastLineSeries;
  aLine             : TFastLineSeries;
  i_start           : INTEGER;
//  ValArray          : TDoubleArray;
  ValArray          : PDoubleArray;

implementation
const
  maxlen=1024*16;
var
  puffer           : array[0..maxlen] of Char;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);

var
  buffer            : array[0..200] of CHAR;
  sbuffer           : string;
  bOk               : Bool;
  index            : integer;
  st               : string;
  ch               : char;

begin
  if g_iD>=0 then
  begin
    PI_CloseConnection(g_iD);
    g_iD:=-1;
    Timer1.Enabled:=False;
    Button1.Caption:='Connect';
    Label1.Caption:='Not connected';
    Button1.Caption:='Connect';
  end else
  begin
    g_iD:=PI_InterfaceSetupDlg('');
    if g_iD<0 then
    begin
      Application.MessageBox('Connection failed','Error',0);
      Exit;
    end;
    Timer1.Enabled:=True;
    Button1.Caption:='Disonnect';
    Label1.Caption:='Stagename';
    bOk:=PI_qIDN(g_iD,buffer,200);
    sbuffer:=string(buffer);
    sbuffer[Length(sbuffer)]:=' '; //clear trailing linefeed character
    Form1.Caption:='Connected to: '+sbuffer;
    //  bOk:=PI_qPOS(g_iD,'1',valfeld);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Label4.Caption:=GetPIDllVersion;
  i_start:=1;
  g_id:=-1;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  i_start:=1;
  xLine.Clear;
  aLine.Clear;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if g_iD>=0 then PI_CloseConnection(g_iD);
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  cmd              : array[0..1023] of char;
begin
  CmdComboBox.SelectAll;
  if CmdComboBox.Items.IndexOf(cmdComboBox.Text)<0 then
    CmdComboBox.Items.Add(cmdComboBox.Text);
  StrPCopy(cmd,CmdComboBox.Text);
  PI_GcsCommandset(g_iD,cmd);
  CmdCombobox.SetFocus;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  AnswerSize,index : integer;
  st               : string;
  ch               : char;
begin
  if g_iD<0 then exit;
  PI_GcsGetAnswerSize(g_iD,AnswerSize);
  if AnswerSize>0 then
  begin
    PI_GcsGetAnswer(g_iD,puffer,maxlen);
    index:=0;
    repeat
      ch:=puffer[index];
      inc(index);
      if ch=#10 then
      begin
        Memo1.Lines.Add(st);
        st:='';
      end else st:=st+ch;
    until (ch=#0) or (index>AnswerSize);
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  PI_GcsCommandset(g_iD,'ERR?');
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  Memo1.Clear;
end;

end.

