unit StringEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TStrEditFrm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Edit1: TEdit;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
   mr:integer;
  end;

var
  StrEditFrm: TStrEditFrm;

implementation

{$R *.dfm}

procedure TStrEditFrm.SpeedButton2Click(Sender: TObject);
begin
mr := mrCancel;
close;
end;

procedure TStrEditFrm.SpeedButton1Click(Sender: TObject);
begin
mr := mrOk;
close;
end;

procedure TStrEditFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key = #13 then SpeedButton1.Click;

end;

end.
