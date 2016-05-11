unit person_edit;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,DataMod, ExtCtrls, Buttons, StdCtrls, ComCtrls,db,common, Mask,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar;
type
  TPersonFrm = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    Label1: TLabel;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    DateTimePicker1: TDateTimePicker;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    reason : byte; // 0 - add, 1 - edit, 2 - view
    ctlg : integer;
    res : integer;
    done : boolean;
  end;

var
  PersonFrm: TPersonFrm;

implementation

{$R *.dfm}

procedure TPersonFrm.SpeedButton1Click(Sender: TObject);
begin
case reason of
 0 :
  begin
   try
    res := AddPerson(ctlg,LabeledEdit1.Text,LabeledEdit2.Text,LabeledEdit3.Text,LabeledEdit4.Text,LabeledEdit5.Text,LabeledEdit6.Text,LabeledEdit7.Text,LabeledEdit8.Text,DateTimePicker1.Date);
//    dm.persons.Requery;
   except on e:exception do showmessage('Не удалось добавить запись: '+e.Message); end;
   close;
  end;
 1 :
  begin
   try
    res := EditPerson(dm.persons.fieldbyname('rn').asinteger ,ctlg,LabeledEdit1.Text,LabeledEdit2.Text,LabeledEdit3.Text,LabeledEdit4.Text,LabeledEdit5.Text,LabeledEdit6.Text,LabeledEdit7.Text,LabeledEdit8.Text,DateTimePicker1.Date);
    dm.persons.Requery;
   except on e:exception do showmessage('Не удалось изменить запись: '+e.Message); end;
   close;
  end;
 2 :
  begin
   close;
  end
  else close;
 end;
end;

procedure TPersonFrm.SpeedButton2Click(Sender: TObject);
begin
res := 0;
close;
end;

procedure TPersonFrm.FormShow(Sender: TObject);
begin
case reason of
 0 :
  begin
   LabeledEdit1.Text := '';
   LabeledEdit2.Text := '';
   LabeledEdit3.Text := '';
   LabeledEdit4.Text := '';
   LabeledEdit5.Text := '';
   LabeledEdit6.Text := '';
   LabeledEdit7.Text := '';
   LabeledEdit8.Text := '';
   SpeedButton1.Enabled:=true;
   DateTimePicker1.Date := 0;
  end;
 1 :
  begin
   LabeledEdit1.Text := dm.PERSONS.fieldByName('family').AsString;
   LabeledEdit2.Text := dm.PERSONS.fieldByName('f_name').AsString;
   LabeledEdit3.Text := dm.PERSONS.fieldByName('l_name').AsString;
   LabeledEdit4.Text := dm.PERSONS.fieldByName('p_number').AsString;
   LabeledEdit5.Text := dm.PERSONS.fieldByName('p_serial').AsString;
   LabeledEdit6.Text := dm.PERSONS.fieldByName('org').AsString;
   LabeledEdit7.Text := dm.PERSONS.fieldByName('proff').AsString;
   LabeledEdit8.Text := dm.PERSONS.fieldByName('addr').AsString;
   DateTimePicker1.Date :=dm.PERSONS.fieldByName('birth_date').AsDateTime;
   SpeedButton1.Enabled:=true;
  end;
 2 :
  begin
   LabeledEdit1.Text := dm.PERSONS.fieldByName('family').AsString;
   LabeledEdit2.Text := dm.PERSONS.fieldByName('f_name').AsString;
   LabeledEdit3.Text := dm.PERSONS.fieldByName('l_name').AsString;
   LabeledEdit4.Text := dm.PERSONS.fieldByName('p_number').AsString;
   LabeledEdit5.Text := dm.PERSONS.fieldByName('p_serial').AsString;
   LabeledEdit6.Text := dm.PERSONS.fieldByName('org').AsString;
   LabeledEdit7.Text := dm.PERSONS.fieldByName('proff').AsString;
   DateTimePicker1.Date :=dm.PERSONS.fieldByName('birth_date').AsDateTime;
   SpeedButton1.Enabled:=false;
  end
  else close;
 end;
end;

procedure TPersonFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key = #13 then SpeedButton1.Click;
if Key = #27 then SpeedButton2.Click;

end;

end.
