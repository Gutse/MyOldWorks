unit FilterEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons;

type
  TFilterFrm = class(TForm)
    Panel1: TPanel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    GroupBox1: TGroupBox;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    LabeledEdit9: TLabeledEdit;
    LabeledEdit10: TLabeledEdit;
    LabeledEdit11: TLabeledEdit;
    LabeledEdit12: TLabeledEdit;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    done : boolean;
    f : string;
  end;

var
  FilterFrm: TFilterFrm;

implementation

{$R *.dfm}

procedure TFilterFrm.SpeedButton2Click(Sender: TObject);
begin
done := false;
close;
end;

procedure TFilterFrm.SpeedButton1Click(Sender: TObject);
var p:string;
begin
f:='';
if (trim(LabeledEdit1.Text) <> '*') and (trim(LabeledEdit1.Text) <> '') then f:= 'Family like '+QuotedStr(trim(LabeledEdit1.Text));
if f <> '' then p:= ' and ' else p := '';
if (trim(LabeledEdit2.Text) <> '*') and (trim(LabeledEdit2.Text) <> '') then f:= p+' and f_name like '+QuotedStr(trim(LabeledEdit2.Text));
if f <> '' then p:= ' and ' else p := '';
if (trim(LabeledEdit3.Text) <> '*')  and (trim(LabeledEdit3.Text) <> '') then f:= p+' and l_name like '+QuotedStr(trim(LabeledEdit3.Text));
if f <> '' then p:= ' and ' else p := '';
if (trim(LabeledEdit4.Text) <> '*') and (trim(LabeledEdit4.Text) <> '') then f:= p+' and p_number like '+QuotedStr(trim(LabeledEdit4.Text));
if f <> '' then p:= ' and ' else p := '';
if (trim(LabeledEdit5.Text) <> '*') and (trim(LabeledEdit5.Text) <> '') then f:= p+' and p_serial like '+QuotedStr(trim(LabeledEdit5.Text));
if f <> '' then p:= ' and ' else p := '';
if (trim(LabeledEdit6.Text) <> '*') and (trim(LabeledEdit6.Text) <> '') then f:= p+' and org like '+QuotedStr(trim(LabeledEdit6.Text));
done := true;
close;
end;

procedure TFilterFrm.FormShow(Sender: TObject);
begin
if SpeedButton4.Down then
 begin
   GroupBox1.Visible := true;
   Width := 807;
   Panel1.Update;
 end else
 begin
   GroupBox1.Visible := false;
   Width := 403;
 end;
end;

procedure TFilterFrm.SpeedButton4Click(Sender: TObject);
begin
if SpeedButton4.Down then
 begin
   GroupBox1.Visible := true;
   Width := 807;
   Panel1.Update;
 end else
 begin
   GroupBox1.Visible := false;
   Width := 403;
 end;

end;

procedure TFilterFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then SpeedButton1Click(self);
if Key = #27 then SpeedButton3.Click;
end;

end.
