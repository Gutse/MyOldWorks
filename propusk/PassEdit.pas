unit PassEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons,common;

type
  TPassFrm = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    DateTimePicker1: TDateTimePicker;
    Label1: TLabel;
    DateTimePicker2: TDateTimePicker;
    Label2: TLabel;
    LabeledEdit4: TLabeledEdit;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    reason : byte; // 0 - add, 1 - edit, 2 - view
    person : integer;
    p_rn : integer;
    done : boolean;
  end;

var
  PassFrm: TPassFrm;

implementation

uses DataMod, DB;

{$R *.dfm}

procedure TPassFrm.FormShow(Sender: TObject);
begin
done := false;
case reason of
 0 :
  begin
   LabeledEdit1.Text := '';
   LabeledEdit2.Text := '';
   LabeledEdit3.Text := '';
   SpeedButton1.Enabled:=true;
  end;
 1 :
  begin
   LabeledEdit1.Text := dm.ACCESS_T.fieldByName('numb').AsString;
   LabeledEdit2.Text := dm.ACCESS_T.fieldByName('s_target').AsString;
   LabeledEdit3.Text := dm.ACCESS_T.fieldByName('s_caller').AsString;
   LabeledEdit4.Text := dm.ACCESS_T.fieldByName('mobile').AsString;
   DateTimePicker1.Date :=dm.ACCESS_T.fieldByName('b_date').AsDateTime;
   DateTimePicker2.Date :=dm.ACCESS_T.fieldByName('e_date').AsDateTime;
   p_rn := dm.ACCESS_T.fieldByName('rn').asInteger;
   SpeedButton1.Enabled:=true;
  end;
 2 :
  begin
   SpeedButton1.Enabled:=false;
  end
  else close;
 end;

end;

procedure TPassFrm.SpeedButton1Click(Sender: TObject);
begin
done := true;
case reason of
 0 :
  begin
   try
    AddAccess(person,LabeledEdit1.Text,LabeledEdit2.Text,LabeledEdit3.Text,LabeledEdit4.Text,DateTimePicker1.Date,DateTimePicker2.Date,dm.persons.fieldByName('is_worker').AsInteger);
    dm.ACCESS_T.Requery;
   except on e:exception do showmessage('Не удалось добавить запись: '+e.Message); end;
   close;
  end;
 1 :
  begin
   try
    ShowMessage('edit');
    EditAccess(dm.ACCESS_T.fieldByName('rn').AsInteger,dm.ACCESS_T.fieldByName('prn').AsInteger, LabeledEdit1.Text,LabeledEdit2.Text,LabeledEdit3.Text,LabeledEdit4.Text,DateTimePicker1.Date,DateTimePicker2.Date,dm.persons.fieldByName('is_worker').AsInteger);
    ShowMessage('requery');
    dm.ACCESS_T.Requery;
    ShowMessage('requery2');
   except on e:exception do showmessage('Не удалось изменить запись: '+e.Message); end;
   close;
  end;
 2 :
  begin
   close;
  end
  else close;
 end;
 showmessage('quit 1');
end;

procedure TPassFrm.SpeedButton2Click(Sender: TObject);
begin
done := false;
close;
end;

procedure TPassFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key = #13 then SpeedButton1.Click;
if Key = #27 then SpeedButton2.Click;
end;

end.
