unit main;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, IniFiles, DB, ADODB, XLHelp;
var
  apply_grade_from_call_to_order: byte = 2; // 0 - never, 1 - only if 1 order, 2 - allways;
  apply_grade_to_boss: boolean = false;

type
  TMainFrm = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    GroupBox2: TGroupBox;
    DateTimePicker1: TDateTimePicker;
    Label5: TLabel;
    Label6: TLabel;
    DateTimePicker2: TDateTimePicker;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ADOConnection1: TADOConnection;
    RichEdit1: TRichEdit;
    q1: TADOQuery;
    q2: TADOQuery;
    CheckBox1: TCheckBox;
    RadioGroup1: TRadioGroup;
    CheckBox2: TCheckBox;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    Format: TFormatSettings;
    procedure MakeReport;
    procedure MakeReport2;
    procedure DataToFile(data: OleVariant; count: integer; filename: string);
    procedure DataToFile2(data: OleVariant; count: integer);
  end;

var
  MainFrm: TMainFrm;

implementation

uses ComObj;

{$R *.dfm}

procedure TMainFrm.SpeedButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TMainFrm.MakeReport;
var
  con_str: string;
  i: integer;
  OleData: OleVariant;
begin
  con_str := 'Provider=SQLOLEDB.1;Password=' + Edit2.Text + ';Persist Security Info=True;User ID=' + Edit1.Text + ';Initial Catalog=' + Edit4.Text + ';Data Source=' + Edit3.Text;
  ADOConnection1.ConnectionString := con_str;
  try
    ADOConnection1.Open;
  except on e: exception do
    begin
      RichEdit1.Lines.Add('не удалось подключится к серверу: ' + e.Message);
    end;
  end;
  if not (ADOConnection1.Connected) then exit;
  RichEdit1.Lines.Add('Подключились к серверу.');

  if q1.Active then q1.Close;
  try
    q1.SQL.Clear;
    q1.SQL.Add('SELECT');
    q1.SQL.Add('T3.per_name AS "maker",');
    q1.SQL.Add('count(1) as cnt,');
    q1.SQL.Add('AVG(case isnull(T2.scf_scnumber3,4) WHEN 0 THEN 4 ELSE ISNULL(T2.scf_scnumber3,4) END ) as "avg_grade",');
    q1.SQL.Add('AVG(isnull(T2.scf_duration2,0)) AS "avg_time",');
    q1.SQL.Add('sum(case sign(datediff (second, isnull(ser_actualfinish, getdate()),ser_deadline )) when -1 then 1 else 0 end) as "late_count"');
    q1.SQL.Add('FROM  ((( itsm_servicecalls T1');
    q1.SQL.Add(' LEFT OUTER JOIN itsm_persons T3 ON (T3.per_oid = T1.ser_ass_per_to_oid))');
    q1.SQL.Add(' LEFT OUTER JOIN itsm_ser_custom_fields T2 ON (T2.scf_ser_oid = T1.ser_oid))');
    q1.SQL.Add(' INNER JOIN rep_codes T4 ON (T4.rcd_oid = T1.ser_sta_oid))');
    q1.SQL.Add('where convert(datetime,t1.reg_created) >= convert(datetime, ' + QuotedStr(DateToStr(DateTimePicker1.Date, Format)) + ')  and T3.per_name is not null and T1.ser_sta_oid = 3094610096');
    q1.SQL.Add('and convert(datetime,t1.reg_created) <= convert(datetime, ' + QuotedStr(DateToStr(DateTimePicker2.Date, Format)) + ')');
    q1.SQL.Add('group by T3.per_name order by "maker"');
    q1.Parameters.ParseSQL(q1.SQL.Text, true);
    q1.Open;
  except on e: exception do
    begin
      RichEdit1.Lines.Add('Не удалось выполнить запрос: ' + e.Message);
      q1.Active := false;
    end;
  end;

  if not (q1.Active) then exit;
  q1.First;
  if q1.RecordCount = 0 then
  begin
    q1.Active := false;
    RichEdit1.Lines.Add('Данных нет');
    exit;
  end;

  RichEdit1.Lines.Add('Найдено данных по исполнителям: исполнителей: ' + IntToStr(q1.RecordCount));
  oleData := VarArrayCreate([1, q1.RecordCount + 1, 1, 6], varVariant);
  for i := 2 to q1.RecordCount + 1 do
  begin
    oleData[i, 1] := IntToStr(i - 1);
    oleData[i, 2] := q1.FieldByName('maker').AsVariant;
    oleData[i, 3] := q1.FieldByName('cnt').AsVariant;
    oleData[i, 4] := q1.FieldByName('late_count').AsVariant;
    oleData[i, 5] := q1.FieldByName('avg_grade').AsVariant;
    oleData[i, 6] := TimeToStr(q1.FieldByName('avg_time').AsVariant);
    q1.Next;
  end;
  DataToFile(oleData, q1.RecordCount, 'c:\temp\pers.txt');
  q1.Close;
end;

procedure TMainFrm.SpeedButton1Click(Sender: TObject);
begin
  apply_grade_from_call_to_order:= RadioGroup1.ItemIndex;
  apply_grade_to_boss:= CheckBox1.Checked;
  RichEdit1.Lines.Clear;
  MakeReport2;
  if q1.Active then q1.Close;
  if q2.Active then q1.Close;
  if ADOConnection1.Connected then ADOConnection1.Close;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
var
  ini: TIniFile;
  str_date: string;
  c_date: Double;
begin
  GetLocaleFormatSettings(0, Format);
  Format.ShortDateFormat := 'mm.dd.yyyy';
  try
    ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.cfg');
    Edit1.Text := ini.ReadString('main', 'login', 'sa');
    Edit2.Text := ini.ReadString('main', 'password', '');
    Edit3.Text := ini.ReadString('main', 'server', 'sd');
    Edit4.Text := ini.ReadString('main', 'db', 'sd');

    str_date := ini.ReadString('main', 'BeginDate', '01.01.2007');
    if AnsiLowerCase(str_date) <> 'now' then
    begin
      try
        c_date := StrToDate(str_date);
        DateTimePicker1.Date := c_date;
      except DateTimePicker1.Date := Now; end;
    end else
    begin
      DateTimePicker1.Date := Now;
    end;

    str_date := ini.ReadString('main', 'EndDate', '01.01.2007');
    if AnsiLowerCase(str_date) <> 'now' then
    begin
      try
        c_date := StrToDate(str_date);
        DateTimePicker2.Date := c_date;
      except DateTimePicker1.Date := Now; end;
    end else
    begin
      DateTimePicker2.Date := Now;
    end;
  finally FreeAndNil(ini); end;
end;

procedure TMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ADOConnection1.Connected then ADOConnection1.Close;
end;

procedure TMainFrm.DataToFile(data: OleVariant; count: integer; filename: string);
{var
  i, j: integer;
  f: TFileStream;
  buf: string;
begin
  try
    DeleteFile(filename);
    f := TFileStream.Create(filename, fmCreate);
    data[0,0] := 'Номер записи';
    data[0,1] := 'ФИО';
    data[0,2] := 'Кол-во заявок';
    data[0,3] := 'Кол-во просроченных заявок';
    data[0,4] := 'Средняя оценка';
    data[0,5] := 'Средняя продолжительность';
    for i := 0 to count do
    begin
      for j := 0 to 5 do
      begin
        buf := VarToStr(data[i, j]) + ';';
        f.Write(buf[1], length(buf));
      end;
      buf := #$0A#$0D;
      f.Write(buf[1], length(buf));
    end;
  except on e: exception do
    begin
      RichEdit1.Lines.Add('Ошибка при экспорте данных: ' + e.Message);
    end;
  end;
  FreeAndNil(f);   }
var
  ex, sheet: OleVariant;
begin
  ex := XLCreateApp(false);
  try
    data[1, 1] := 'Номер записи';
    data[1, 2] := 'ФИО';
    data[1, 3] := 'Кол-во заявок';
    data[1, 4] := 'Кол-во просроченных заявок';
    data[1, 5] := 'Средняя оценка';
    data[1, 6] := 'Средняя продолжительность';
    sheet := ex.workbooks.add.sheets[1];
    XLSetRangeValue(sheet, data, 1, count + 1, 'A', 'F');
    sheet.range['A' + IntToStr(1) + ':' + 'F' + IntToStr(1)].Font.Bold := true;
    sheet.columns['A' + ':' + 'F'].AutoFit;
//    sheet.range['A'+IntToStr(1)+':'+'F'+IntToStr(1)].ShrinkToFit := true;
  finally ex.visible := true; end;
end;

procedure TMainFrm.MakeReport2;
var
  oleData: OleVariant;
  p_count, i, j, k: integer;
  boss_counted: boolean;
begin
  if ADOConnection1.Connected then
  begin
    if q1.Active then q1.close;
    if q2.Active then q2.close;
    ADOConnection1.Close;
  end;
  ADOConnection1.ConnectionString := 'Provider=SQLOLEDB.1;Password=' + Edit2.Text + ';Persist Security Info=True;User ID=' + Edit1.Text + ';Initial Catalog=' + Edit4.Text + ';Data Source=' + Edit3.Text;;
  try
    ADOConnection1.Open;
  except on e: exception do
    begin
      RichEdit1.Lines.Add('не удалось подключится к серверу: ' + e.Message);
    end;
  end;
  if not (ADOConnection1.Connected) then exit;

  if q1.Active then q1.Close;
  q1.sql.clear;
  q1.sql.add('select distinct T1.ass_per_to_oid as per_oid, T2.per_name as maker from itsm_workorders T1, itsm_persons T2 where T1.ass_per_to_oid is not null and T1.ass_per_to_oid = T2.per_oid');
  q1.sql.add('union');
  q1.sql.add('select distinct T1.ser_ass_per_to_oid as per_oid, T2.per_name as maker from itsm_servicecalls T1, itsm_persons T2 where ser_ass_per_to_oid is not null and T1.ser_ass_per_to_oid = T2.per_oid order by maker');
  try
    q1.Open;
  except on e: exception do
    begin
      RichEdit1.Lines.add('Не удалось найти исполнителей: ' + e.Message);
      ADOConnection1.Close;
      exit;
    end;
  end;
  if q1.RecordCount = 0 then
  begin
    RichEdit1.Lines.add('Исполнителей за данный период нет.');
    q1.Close;
    ADOConnection1.Close;
    exit;
  end;
  q1.First;
  p_count := q1.RecordCount;
  oleData := VarArrayCreate([1, p_count + 1, 1, 6 + 1], varVariant); // 1 для шапки и 1 для записи числа оценок
  oleData[1, 1] := '№';
  oleData[1, 2] := 'ФИО';
  oleData[1, 3] := 'Кол-во заявок/нарядов';
  oleData[1, 4] := 'Кол-во просроченных заявок/нарядов';
  oleData[1, 5] := 'Средний балл';
  oleData[1, 6] := 'Среднее время выполнения';
  oleData[1, 7] := 'Кол-во заявок/нарядов с оценками';
  for i := 2 to p_count + 1 do // обнуляем
  begin
    oleData[i, 1] := q1.fieldbyname('per_oid').AsVariant; // временно тут хранить ИД будем
    oleData[i, 2] := q1.fieldbyname('maker').AsString;
    oleData[i, 3] := 0;
    oleData[i, 4] := 0;
    oleData[i, 5] := 0;
    oleData[i, 6] := 0;
    oleData[i, 7] := 0;
    q1.Next;
  end;
  q1.Close;
  q1.SQL.Clear;

  q1.sql.add('select T1.ser_id as "ser_num",');
  q1.sql.add('T1.ser_oid as "oid",');
  q1.sql.add('T1.ser_ass_per_to_oid as "pers",');
  q1.sql.add('case sign(datediff(second, SER_DEADLINE,SER_ACTUALFINISH)) when 1 then 1 else 0 end as late_sign,');
//  q1.sql.add('5 as "grade",');
//  q1.sql.add('4.1666666666666664E-2 as "duration"');
  q1.SQL.Add('case isnull(T2.scf_scnumber3,4) WHEN 0 THEN 4 ELSE ISNULL(T2.scf_scnumber3,4) END  as "grade",');
  q1.SQL.Add('isnull(T2.scf_duration2,0) AS "duration"');

  q1.sql.add('from itsm_servicecalls T1,itsm_ser_custom_fields T2  ');
  q1.sql.add('where');
  q1.sql.add('T1.reg_created >= ' + QuotedStr(DateToStr(DateTimePicker1.Date, Format)));
  q1.sql.add('and T1.reg_created <= ' + QuotedStr(DateToStr(DateTimePicker2.Date, Format)));
  q1.sql.add('and t1.ser_sta_oid = 3094610096');
  q1.sql.add('and T1.ser_ass_per_to_oid is not null ');
  q1.sql.add('and T2.scf_ser_oid = T1.ser_oid');
  if CheckBox2.Checked then  q1.sql.add('and ser_cla_oid != 281485938393252');
  try
    q1.Open
  except on e: exception do
    begin
      RichEdit1.Lines.Add('Не удалось найти заявки за данный период: ' + e.Message);
      ADOConnection1.Close;
      exit;
    end;
  end;
  q1.First;
  if q1.RecordCount = 0 then
  begin
    RichEdit1.Lines.Add('Нет заявок за этот период');
    q1.Close;
    ADOConnection1.Close;
    exit;
  end;
  for i := 1 to q1.RecordCount do
  begin
    if q2.Active then q2.Close;
    q2.SQL.Clear;
    q2.SQL.Add('select ');
    q2.SQL.Add('T1.ass_per_to_oid as "maker",');
    q2.SQL.Add('T2.WCF_DURATION2 as "duration",');
    q2.SQL.Add('case sign(datediff(second, WOR_DEADLINE,WOR_ACTUALFINISH)) when 1 then 1 else 0 end as late_sign');
    q2.SQL.Add('from itsm_workorders T1, ITSM_WOR_CUSTOM_FIELDS T2');
    q2.SQL.Add('where');
    q2.SQL.Add('T1.WOR_SER_OID = :PRN');
    q2.SQL.Add('and T2.WCF_WOR_OID = T1.WOR_OID');
    q2.Parameters.ParseSQL(q2.sql.Text, true);
    q2.Parameters.ParamByName('PRN').Value := q1.FieldByName('oid').Value;
    try
      q2.Open;
      q2.First;
      boss_counted := false;
      if q2.RecordCount = 0 then // если заявку выполнял руководитель (нет нарядов)
      begin
        for j := 2 to p_count + 1 do // ищем исполнителя
        begin
          if VarToStr(oleData[j, 1]) = VarToStr(q1.fieldbyname('pers').Value) then
          begin // нашли
            oleData[j, 3] := VarAsType(oleData[j, 3], varInteger) + 1;
            oleData[j, 4] := VarAsType(oleData[j, 4], varInteger) + q1.FieldByName('late_sign').AsInteger;
            oleData[j, 5] := VarAsType(oleData[j, 5], varInteger) + q1.FieldByName('grade').AsInteger;
            oleData[j, 6] := VarAsType(oleData[j, 6], varDouble) + q1.FieldByName('duration').AsFloat;
            oleData[j, 7] := VarAsType(oleData[j, 7], varInteger) + 1;
            break;
          end;
        end;
      end else // а если наряды есть
      begin
        for j := 1 to q2.RecordCount do
        begin
          for k := 2 to p_count + 1 do
          begin
            if VarToStr(oleData[k, 1]) = VarToStr(q2.fieldbyname('maker').Value) then
            begin
              oleData[k, 3] := VarAsType(oleData[k, 3], varInteger) + 1;
              oleData[k, 4] := VarAsType(oleData[k, 4], varInteger) + q2.FieldByName('late_sign').AsInteger;
              oleData[k, 6] := VarAsType(oleData[k, 6], varDouble) + q2.FieldByName('duration').AsFloat;
              case apply_grade_from_call_to_order of // режим подстановки оценки из заявки в наряд
                1: // добавлять оценку если только существует только один наряд из заявки
                  begin
                    if q2.RecordCount = 1 then
                    begin
                      oleData[k, 5] := VarAsType(oleData[k, 5], varInteger) + q1.FieldByName('grade').AsInteger;
                      oleData[k, 7] := VarAsType(oleData[k, 7], varInteger) + 1;
                      if VarToStr(oleData[k, 1]) = VarToStr(q1.fieldbyname('pers').Value) then boss_counted := true; // тоесть босс сам себе наряд выписал %)
                    end;
                  end;
                2: // добавлять всегда
                  begin
                    oleData[k, 5] := VarAsType(oleData[k, 5], varInteger) + q1.FieldByName('grade').AsInteger;
                    oleData[k, 7] := VarAsType(oleData[k, 7], varInteger) + 1;
                    if VarToStr(oleData[k, 1]) = VarToStr(q1.fieldbyname('pers').Value) then boss_counted := true; // босс выписал наряд себе и еще кому то
                  end;
              end;
              break;
            end;
          end;
          q2.Next;
        end;
        if (apply_grade_to_boss) and not (boss_counted) then // если стоит режим отвественности босса за свою группу и его не было в нарядах на данную заявку то посчитаем его
        begin
          for j := 2 to p_count + 1 do // ищем исполнителя
          begin
            if VarToStr(oleData[j, 1]) = VarToStr(q1.fieldbyname('pers').Value) then
            begin // нашли
              oleData[j, 5] := VarAsType(oleData[j, 5], varInteger) + q1.FieldByName('grade').AsInteger;
              oleData[j, 7] := VarAsType(oleData[j, 7], varInteger) + 1;
              break;
            end;
          end;
        end;
      end;
    except on e: exception do
      begin
        RichEdit1.Lines.Add('Ошибка при обработки заявки № ' + VarToStr(q1.fieldByName('ser_num').Value));
      end;
    end;
    q1.Next;
  end;


  // пересчет (выше мы просто суммировали оценки, время итп)
  for i := 2 to p_count + 1 do
  begin
//    oleData[i,1] := VarToStr(oleData[i,1]);   // отладочный вариант, где вместо номера ИД персоны
    oleData[i, 1] := IntToStr(i - 1);
    if oleData[i, 3] > 0 then // если есть заявки или наряды то поделим (на 0 делить нельзя%) )
    begin
      oleData[i, 6] := oleData[i, 6] / oleData[i, 3];
      oleData[i, 6] := TimeToStr(oleData[i, 6]);
    end;
    if oleData[i, 7] > 0 then // тут у нас кол-во заявок/нарядов с оценками (в зависимости от настроек не все наряды могут быть оценены)
    begin
      oleData[i, 5] := oleData[i, 5] / oleData[i, 7];
    end;
  end;

  DataToFile2(oleData, p_count);
end;


procedure TMainFrm.DataToFile2(data: OleVariant; count: integer);
var
  ex, sheet: OleVariant;
begin
  ex := XLCreateApp(false);
  try
    sheet := ex.workbooks.add.sheets[1];
    XLSetRangeValue(sheet, data, 1, count + 1, 'A', 'G');
    sheet.range['A' + IntToStr(1) + ':' + 'G' + IntToStr(1)].Font.Bold := true;
    sheet.columns['A' + ':' + 'G'].AutoFit;
  finally ex.visible := true; end;
end;

end.

