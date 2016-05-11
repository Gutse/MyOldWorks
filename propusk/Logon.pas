unit Logon;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,DataMod, Buttons;
type
  TLogonFrm = class(TForm)
    GroupBox1: TGroupBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    Logged : boolean;
  end;
var
  LogonFrm: TLogonFrm;
implementation
{$R *.dfm}
procedure TLogonFrm.FormCreate(Sender: TObject);
begin
Logged := false;
end;

procedure TLogonFrm.SpeedButton2Click(Sender: TObject);
begin
Logged := false;
close;
end;

procedure TLogonFrm.SpeedButton1Click(Sender: TObject);
begin
dm.connection.ConnectionString := 'Provider=MSDAORA.1;Password='+Edit3.Text+';User ID='+Edit2.Text+';Data Source='+Edit1.Text+';Persist Security Info=True';
try
 dm.connection.Open;
 Logged := true;
except
  on E: Exception do
   begin
    ShowMessage('¬ход в систему не удалс€: '+e.Message);
    Logged := false;
   end;
  end; 
if Logged then close;
end;

procedure TLogonFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key = #13 then SpeedButton1.Click;

end;

end.
