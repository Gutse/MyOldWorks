unit Main;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, Buttons, math, Mask, ComObj, XLHelp;

type
  TMainFrm = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    Edit1: TEdit;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    ComboBox2: TComboBox;
    Label5: TLabel;
    ComboBox3: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    Label8: TLabel;
    Edit2: TEdit;
    SpeedButton2: TSpeedButton;
    Label9: TLabel;
    ComboBox4: TComboBox;
    Label10: TLabel;
    Label11: TLabel;
    ComboBox5: TComboBox;
    Label12: TLabel;
    ComboBox6: TComboBox;
    Label13: TLabel;
    Label14: TLabel;
    CheckBox2: TCheckBox;
    Label15: TLabel;
    ComboBox7: TComboBox;
    SpeedButton3: TSpeedButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    StringGrid1: TStringGrid;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    StringGrid2: TStringGrid;
    SkipExisted: TCheckBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    main_header, linked_header, main_data, linked_data: OleVariant;
    Excel, Main_book, linked_book, main_sheet, linked_sheet: OleVariant;
    function CompareValues(mr, mc, lr, lc: integer): boolean;
  end;

var
  MainFrm: TMainFrm;

implementation

uses StrUtils;

{$R *.dfm}

procedure TMainFrm.SpeedButton1Click(Sender: TObject);
var
  p: integer;
begin
  if OpenDialog1.Execute then
  begin
    try
      Main_book := Unassigned;
      main_sheet := Unassigned;
      main_header := Unassigned;

      if edit1.Text = OpenDialog1.FileName then exit;
      Main_book := XLOpenWBook(Excel, OpenDialog1.FileName);
      if VarIsClear(Main_book) then raise Exception.Create('Main_book is null')at@XLCreateApp;
      main_sheet := XLGetSheet(main_book, 1);
      ComboBox1.Items.Clear;
      main_header := XLGetRangeValue(main_sheet, 1, 1, 3, XLStrToCol('IV'));
      if VarIsClear(Main_header) then raise Exception.Create('Main_header is null')at@XLCreateApp;
      for p := 1 to main_book.sheets.Count do
      begin
        ComboBox1.Items.add(main_book.sheets.item[p].name);
      end;
      ComboBox1.ItemIndex := 0;
      for p := 1 to 256 do
      begin
        StringGrid1.Cells[p, 1] := string(main_header[1, p]);
        StringGrid1.Cells[p, 2] := string(main_header[2, p]);
        StringGrid1.Cells[p, 3] := string(main_header[3, p]);
      end;
      edit1.Text := OpenDialog1.FileName;
    except on e: exception do
      begin
        ComboBox1.Items.Clear;
        Main_book := Unassigned;
        main_sheet := Unassigned;
        main_header := Unassigned;
        ShowMessage('Cannot open file: ' + e.Message);
      end;
    end;
  end;
end;

procedure TMainFrm.ComboBox1Change(Sender: TObject);
var p: integer;
begin
  try
    main_sheet := XLGetSheet(Main_book, ComboBox1.ItemIndex + 1);
    main_header := XLGetRangeValue(main_sheet, 1, 1, 3, XLStrToCol('IV'));
    if VarIsClear(Main_header) then raise Exception.Create('Main_header is null')at@XLCreateApp;
    for p := 1 to 256 do
    begin
      StringGrid1.Cells[p, 1] := string(main_header[1, p]);
      StringGrid1.Cells[p, 2] := string(main_header[2, p]);
      StringGrid1.Cells[p, 3] := string(main_header[3, p]);
    end;
  except on e: exception do
    begin
      ComboBox1.Items.Clear;
      Main_book := Unassigned;
      main_sheet := Unassigned;
      main_header := Unassigned;
      ShowMessage('Exception: ' + e.Message);
    end;
  end;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
var
  i: integer;
  s: string;
begin
  Excel := XLCreateApp(false);
  if VarIsClear(Excel) then
  begin
    ShowMessage('Cannot create excel');
    Application.Terminate;
  end;
  StringGrid1.ColCount := 256 + 1;
  StringGrid2.ColCount := 256 + 1;
  for i := 1 to 256 do
  begin
    s := XLColToStr(i);
    StringGrid1.Cells[i, 0] := s;
    StringGrid2.Cells[i, 0] := s;
    ComboBox2.Items.Add(s);
    ComboBox3.Items.Add(s);
    ComboBox5.Items.Add(s);
    ComboBox6.Items.Add(s);
    ComboBox7.Items.Add(s);
  end;
  ComboBox2.ItemIndex := 0;
  ComboBox3.ItemIndex := 1;
  ComboBox5.ItemIndex := 0;
  ComboBox6.ItemIndex := 1;
  ComboBox7.ItemIndex := 3;
end;

procedure TMainFrm.CheckBox1Click(Sender: TObject);
begin
  edit5.Enabled := not (CheckBox1.Checked);

end;

procedure TMainFrm.SpeedButton2Click(Sender: TObject);
var
  p: integer;
begin
  if OpenDialog1.Execute then
  begin
    try
      Linked_book := Unassigned;
      Linked_sheet := Unassigned;
      Linked_header := Unassigned;

      if edit2.Text = OpenDialog1.FileName then exit;
      Linked_book := XLOpenWBook(Excel, OpenDialog1.FileName);
      if VarIsClear(Linked_book) then raise Exception.Create('Linked_book is null')at@XLCreateApp;
      Linked_sheet := XLGetSheet(Linked_book, 1);
      ComboBox4.Items.Clear;
      Linked_header := XLGetRangeValue(Linked_sheet, 1, 1, 3, XLStrToCol('IV'));
      if VarIsClear(Linked_header) then raise Exception.Create('Linked_header is null')at@XLCreateApp;
      for p := 1 to Linked_book.sheets.Count do
      begin
        ComboBox4.Items.add(Linked_book.sheets.item[p].name);
      end;
      ComboBox4.ItemIndex := 0;
      for p := 1 to 256 do
      begin
        StringGrid2.Cells[p, 1] := string(Linked_header[1, p]);
        StringGrid2.Cells[p, 2] := string(Linked_header[2, p]);
        StringGrid2.Cells[p, 3] := string(Linked_header[3, p]);
      end;
      edit2.Text := OpenDialog1.FileName;
    except on e: exception do
      begin
        ComboBox4.Items.Clear;
        Linked_book := Unassigned;
        Linked_sheet := Unassigned;
        Linked_header := Unassigned;
        ShowMessage('Cannot open file: ' + e.Message);
      end;
    end;
  end;
end;

procedure TMainFrm.ComboBox4Change(Sender: TObject);
var p: integer;
begin
  try
    Linked_sheet := XLGetSheet(Linked_book, ComboBox4.ItemIndex + 1);
    Linked_header := XLGetRangeValue(Linked_sheet, 1, 1, 3, XLStrToCol('IV'));
    if VarIsClear(Linked_header) then raise Exception.Create('Linked_header is null')at@XLCreateApp;
    for p := 1 to 256 do
    begin
      StringGrid2.Cells[p, 1] := string(Linked_header[1, p]);
      StringGrid2.Cells[p, 2] := string(Linked_header[2, p]);
      StringGrid2.Cells[p, 3] := string(Linked_header[3, p]);
    end;
  except on e: exception do
    begin
      ComboBox4.Items.Clear;
      Linked_book := Unassigned;
      Linked_sheet := Unassigned;
      Linked_header := Unassigned;
      ShowMessage('Exception: ' + e.Message);
    end;
  end;
end;

procedure TMainFrm.CheckBox2Click(Sender: TObject);
begin
  edit7.Enabled := not (CheckBox2.Checked);
end;

procedure TMainFrm.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 1 then RadioGroup2.Enabled := false else RadioGroup2.Enabled := true;
end;

function TMainFrm.CompareValues(mr, mc, lr, lc: integer): boolean;
var v1, v2: variant;
begin
  result := false;
  if RadioGroup1.ItemIndex = 0 then
  begin
    case RadioGroup2.ItemIndex of
      0:
        begin
          result := AnsiUpperCase(trim(Main_Data[mr, mc])) = AnsiUpperCase(trim(Linked_Data[lr, lc]));
        end;
      1:
        begin
          result := AnsiContainsText(trim(Main_Data[mr, mc]), trim(Linked_Data[lr, lc]));
        end;
      2:
        begin
          result := AnsiContainsText(trim(Linked_Data[lr, lc]), trim(Main_Data[mr, mc]));
        end;
    end;
  end else
  begin
    v1 := Main_Data[mr, mc];
    v2 := Linked_Data[lr, lc];
    result := VarCompareValue(v1, v2) = vrEqual;
  end;
end;


procedure TMainFrm.SpeedButton3Click(Sender: TObject);
var
  i, j, k, imax, jmax, jmin: integer;
  b_found: boolean;
begin
  if ComboBox6.ItemIndex > ComboBox7.ItemIndex then
  begin
    ShowMessage('Wrong range to paste');
    exit;
  end;
  try
    if CheckBox1.Checked then main_data := XLGetRangeValue(main_sheet, StrToInt(edit4.Text), Min(ComboBox2.ItemIndex, ComboBox3.ItemIndex) + 1, 65536, Max(ComboBox2.ItemIndex, ComboBox3.ItemIndex) + ComboBox7.ItemIndex - ComboBox6.ItemIndex) else
      main_data := XLGetRangeValue(main_sheet, StrToInt(edit4.Text), Min(ComboBox2.ItemIndex, ComboBox3.ItemIndex) + 1, StrToInt(Edit5.Text), Max(ComboBox2.ItemIndex, ComboBox3.ItemIndex) + ComboBox7.ItemIndex - ComboBox6.ItemIndex);

    if CheckBox2.Checked then linked_data := XLGetRangeValue(linked_sheet, StrToInt(edit6.Text), Min(ComboBox5.ItemIndex, ComboBox6.ItemIndex) + 1, 65536, Max(ComboBox5.ItemIndex, ComboBox7.ItemIndex)) else
      linked_data := XLGetRangeValue(main_sheet, StrToInt(edit6.Text), Min(ComboBox5.ItemIndex, ComboBox6.ItemIndex) + 1, StrToInt(Edit7.Text), Max(ComboBox5.ItemIndex, ComboBox7.ItemIndex));
  except
    begin
      main_data := Unassigned;
      linked_data := Unassigned;
    end;
  end;

  if VarIsClear(Main_Data) or VarIsClear(linked_data) then
  begin
    ShowMessage('Need file');
    exit;
  end;
  if not (CheckBox1.Checked) {and (RzNumericEdit1.IntValue > RzNumericEdit2.IntValue)} then
  begin
    ShowMessage('Wrong range');
    exit;
  end;
  if not (CheckBox2.Checked) {and (RzNumericEdit3.IntValue > RzNumericEdit4.IntValue)} then
  begin
    ShowMessage('Wrong range');
    exit;
  end;

  try
    i := StrToInt(Edit4.Text);
    imax := StrToInt(Edit5.Text);
    jmin := StrToInt(Edit6.Text);
    jmax := StrToInt(Edit7.Text);
  except on e: exception do begin ShowMessage('wrong row: ' + e.Message); exit; end; end;

  while (not (CheckBox1.Checked) and (i <= iMax)) or ((CheckBox1.Checked) and (trim(Main_Data[i, ComboBox1.itemindex + 1]) <> '')) do
  begin
    b_found := false;
    j := jmin;
    while (not (CheckBox2.Checked) and (j <= jmax)) or ((CheckBox2.Checked) and (trim(Linked_Data[j, ComboBox5.itemindex + 1]) <> '')) do
    begin
      if CompareValues(i, ComboBox2.itemindex + 1, j, ComboBox5.itemindex + 1) then
      begin
        for k := 1 to ComboBox7.ItemIndex - ComboBox6.ItemIndex + 1 do
        begin
          if not(SkipExisted.Checked) or (Main_Data[i,ComboBox3.ItemIndex+k] <> '')  then
          begin
            Main_Data[i, ComboBox3.ItemIndex + k] := Linked_Data[j, ComboBox6.ItemIndex + k];
          end;
        end;
        b_found := true;
      end;
      if b_found then break;
      inc(j);
    end;
    inc(i);
  end;
  try
    if CheckBox1.Checked then XLSetRangeValue(main_sheet, main_data, StrToInt(edit4.Text), Min(ComboBox2.ItemIndex, ComboBox3.ItemIndex) + 1, 65536, Max(ComboBox2.ItemIndex, ComboBox3.ItemIndex) + ComboBox7.ItemIndex - ComboBox6.ItemIndex) else
      XLSetRangeValue(main_sheet, main_data, StrToInt(edit4.Text), Min(ComboBox2.ItemIndex, ComboBox3.ItemIndex) + 1, StrToInt(Edit5.Text), Max(ComboBox2.ItemIndex, ComboBox3.ItemIndex) + ComboBox7.ItemIndex - ComboBox6.ItemIndex);
    Excel.Visible := true;
  except on e: exception do
    begin
      ShowMessage('Cannot save file: ' + e.Message);
    end;
  end;
end;

procedure TMainFrm.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in (['0'..'9'] + [#8])) then key := #0;
end;

procedure TMainFrm.Edit4Change(Sender: TObject);
begin
  if trim(TEdit(Sender).Text) = '' then TEdit(Sender).Text := '1';
end;

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
  if not (VarIsClear(Excel)) then Excel.quit;
  Excel := Unassigned;
  Main_book := Unassigned;
  main_sheet := Unassigned;
  main_header := Unassigned;
end;

end.

