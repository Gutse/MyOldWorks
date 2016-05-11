unit common;
interface
uses sysutils,strutils,datamod,classes,inifiles,dialogs;
type
 TAccessFilter = class (TObject)
  public
   crn,
   name1,name2,name3,
   is_worker,
   org,
   p_serial,p_number :string;

   s_numb,s_b_date,s_e_date,s_mobile,s_target,s_caller:string;

   Function GetFilterString : string;
   Function GetGoodFilterString : string;
  end;
Procedure WrLog (acc_rn,for_worker,reason ,prn: integer; numb : string);
Function MyDateToStr(d:TDateTime):string;
Procedure ExecCM (s : TStringList);
Procedure OpenCM (s : TStringList);

Function  AddPerson(crn:integer;family,f_name,l_name,p_numb,p_serial,org,proff,addr : string; birth_date : TDateTime):integer;
Function  AddAccess(prn:integer;numb,s_target,s_caller,mobile:string;b_date,e_date : TDateTime;for_worker:integer):integer;
Procedure AddCatalog;

Function  EditPerson(rn,crn:integer;family,f_name,l_name,p_numb,p_serial,org,proff,addr : string;birth_date : TDateTime):integer;
Function  EditAccess(rn,prn:integer;numb,s_target,s_caller,mobile:string;b_date,e_date : TDateTime;for_worker:integer):integer;
Procedure EditCatalog;

Procedure DeletePerson ( rn : integer);
Procedure DeleteAccess;
Procedure DeleteCatalog;


var GlobalAccessFilter : TAccessFilter;
sql :TStringList;
ini : TIniFile;

implementation

Function MyDateToStr(d:TDateTime):string;
var
res:string;
t1,t2:string;
begin
   res:=FormatDateTime('dd.mmm.yyyy',d);
   t1:='';
   t1:=res[4]+res[5]+res[6];
   t2:=t1;
   if t1 = 'янв' then t2 := 'jan';
   if t1 = 'фев' then t2 := 'feb';
   if t1 = 'мар' then t2 := 'mar';
   if t1 = 'апр' then t2 := 'apr';
   if t1 = 'май' then t2 := 'may';
   if t1 = 'июн' then t2 := 'jun';
   if t1 = 'июл' then t2 := 'jul';
   if t1 = 'авг' then t2 := 'aug';
   if t1 = 'сен' then t2 := 'sep';
   if t1 = 'окт' then t2 := 'oct';
   if t1 = 'ноя' then t2 := 'nov';
   if t1 = 'дек' then t2 := 'dec';
   res[4]:=t2[1];
   res[5]:=t2[2];
   res[6]:=t2[3];
   result:=res;
end;

Function TAccessFilter.GetFilterString : string;
begin
 crn   := trim(crn);
 name1 := trim(name1);
 name2 := trim(name2);
 name3 := trim(name3);
 is_worker := trim(is_worker);
 org := trim(org);
 p_serial := trim(p_serial);
 p_number := trim(p_number);
 s_numb:= trim(s_numb);
 s_b_date:= trim(s_b_date);
 s_e_date:= trim(s_e_date);
 s_mobile:= trim(s_mobile);
 s_target:= trim(s_target);
 s_caller:= trim(s_caller);

 if crn = '' then crn := '%';
 if name1 = '' then name1 := '%';
 if name2 = '' then name2 := '%';
 if name3 = '' then name3 := '%';
 if is_worker = '' then is_worker := '%';
 if org = '' then org := '%';
 if p_serial = '' then p_serial := '%';
 if p_number = '' then p_number := '%';
 if s_numb = '' then s_numb := '%';
 if s_b_date = '' then s_b_date := '%';
 if s_e_date = '' then s_e_date := '%';
 if s_mobile = '' then s_mobile := '%';
 if s_target = '' then s_target := '%';
 if s_caller = '' then s_caller := '%';

 crn := AnsiReplaceStr (crn,'*','%');
 name1 := AnsiReplaceStr (name1,'*','%');
 name2 :=  AnsiReplaceStr (name2,'*','%');
 name3 :=  AnsiReplaceStr (name3,'*','%');
 is_worker :=  AnsiReplaceStr (is_worker,'*','%');
 org :=  AnsiReplaceStr (org,'*','%');
 p_serial :=  AnsiReplaceStr (p_serial,'*','%');
 p_number :=  AnsiReplaceStr (p_number,'*','%');
 s_numb :=  AnsiReplaceStr (s_numb,'*','%');
 s_b_date :=  AnsiReplaceStr (s_b_date,'*','%');
 s_e_date :=  AnsiReplaceStr (s_e_date,'*','%');
 s_mobile :=  AnsiReplaceStr (s_mobile,'*','%');
 s_target :=  AnsiReplaceStr (s_target,'*','%');
 s_caller :=  AnsiReplaceStr (s_caller,'*','%');

 crn := AnsiReplaceStr (crn,'?','_');
 name1 := AnsiReplaceStr (name1,'?','_');
 name2 :=  AnsiReplaceStr (name2,'?','_');
 name3 :=  AnsiReplaceStr (name3,'?','_');
 is_worker :=  AnsiReplaceStr (is_worker,'?','_');
 org :=  AnsiReplaceStr (org,'?','_');
 p_serial :=  AnsiReplaceStr (p_serial,'?','_');
 p_number :=  AnsiReplaceStr (p_number,'?','_');
 s_numb :=  AnsiReplaceStr (s_numb,'?','_');
 s_b_date :=  AnsiReplaceStr (s_b_date,'?','_');
 s_e_date :=  AnsiReplaceStr (s_e_date,'?','_');
 s_mobile :=  AnsiReplaceStr (s_mobile,'?','_');
 s_target :=  AnsiReplaceStr (s_target,'?','_');
 s_caller :=  AnsiReplaceStr (s_caller,'?','_');


 if s_b_date = '%' then s_b_date := '01.jan.1800' else
  begin
   try
    s_b_date := MyDateToStr(StrToDate(s_b_date));
   except s_b_date := '01.jan.1800';end;
  end;
 if s_e_date = '%' then s_e_date := '01.jan.2800' else
  begin
   try
    s_e_date := MyDateToStr(StrToDate(s_e_date));
   except s_e_date := '01.jan.2800';end;
  end;

 if (s_numb =   '%') and
    (s_b_date = '01.jan.1800') and
    (s_e_date = '01.jan.2800') and
    (s_mobile = '%') and
    (s_target = '%') and
    (s_caller = '%') then
 result := ' select * from dias_v_all_person where crn like '+QuotedStr(crn)+
 ' and nvl(family,0) like '+QuotedStr(name1)+' and nvl(f_name,0) like '+QuotedStr(name2)+' and nvl(l_name,0) like '+QuotedStr(name3)+
 ' and nvl(is_worker,0) like '+QuotedStr(is_worker)+' and nvl(org,0) like '+QuotedStr(org)+ ' and nvl(p_serial,0) like '+QuotedStr(p_serial)+
 ' and nvl(p_number,0) like '+QuotedStr(p_number) else

 result := ' select p.* from dias_v_all_person p where p.crn like '+QuotedStr(crn)+
 ' and nvl(p.family,0) like '+QuotedStr(name1)+' and nvl(p.f_name,0) like '+QuotedStr(name2)+' and nvl(p.l_name,0) like '+QuotedStr(name3)+
 ' and nvl(p.is_worker,0) like '+QuotedStr(is_worker)+' and nvl(p.org,0) like '+QuotedStr(org)+ ' and nvl(p.p_serial,0) like '+QuotedStr(p_serial)+
 ' and nvl(p.p_number,0) like '+QuotedStr(p_number) +
 ' and rn in (select prn from dias_access where nvl(numb,0) like '+ QuotedStr(s_numb)+' and b_date >= '+QuotedStr(s_b_date) +
 ' and b_date <= '+ QuotedStr(s_e_date)+' and nvl(mobile,0) like '+ QuotedStr(s_mobile) + ' and nvl(s_target,0) like '+ QuotedStr(s_target)+
 ' and nvl(s_caller,0) like '+ QuotedStr(s_caller)+' and nvl(for_worker,0) = nvl(p.is_worker,0))';
end;


Function TAccessFilter.GetGoodFilterString : string;
var
 f,p:string;
  old_b_date, old_e_date : string;

begin
 crn   := trim(crn);
 name1 := trim(name1);
 name2 := trim(name2);
 name3 := trim(name3);
 is_worker := trim(is_worker);
 org := trim(org);
 p_serial := trim(p_serial);
 p_number := trim(p_number);
 s_numb:= trim(s_numb);
 s_b_date:= trim(s_b_date);
 s_e_date:= trim(s_e_date);
 s_mobile:= trim(s_mobile);
 s_target:= trim(s_target);
 s_caller:= trim(s_caller);

 if crn = '' then crn := '%';
 if name1 = '' then name1 := '%';
 if name2 = '' then name2 := '%';
 if name3 = '' then name3 := '%';
 if is_worker = '' then is_worker := '%';
 if org = '' then org := '%';
 if p_serial = '' then p_serial := '%';
 if p_number = '' then p_number := '%';
 if s_numb = '' then s_numb := '%';
 if s_b_date = '' then s_b_date := '%';
 if s_e_date = '' then s_e_date := '%';
 if s_mobile = '' then s_mobile := '%';
 if s_target = '' then s_target := '%';
 if s_caller = '' then s_caller := '%';

 crn := AnsiReplaceStr (crn,'*','%');
 name1 := AnsiReplaceStr (name1,'*','%');
 name2 :=  AnsiReplaceStr (name2,'*','%');
 name3 :=  AnsiReplaceStr (name3,'*','%');
 is_worker :=  AnsiReplaceStr (is_worker,'*','%');
 org :=  AnsiReplaceStr (org,'*','%');
 p_serial :=  AnsiReplaceStr (p_serial,'*','%');
 p_number :=  AnsiReplaceStr (p_number,'*','%');
 s_numb :=  AnsiReplaceStr (s_numb,'*','%');
 s_b_date :=  AnsiReplaceStr (s_b_date,'*','%');
 s_e_date :=  AnsiReplaceStr (s_e_date,'*','%');
 s_mobile :=  AnsiReplaceStr (s_mobile,'*','%');
 s_target :=  AnsiReplaceStr (s_target,'*','%');
 s_caller :=  AnsiReplaceStr (s_caller,'*','%');

 crn := AnsiReplaceStr (crn,'?','_');
 name1 := AnsiReplaceStr (name1,'?','_');
 name2 :=  AnsiReplaceStr (name2,'?','_');
 name3 :=  AnsiReplaceStr (name3,'?','_');
 is_worker :=  AnsiReplaceStr (is_worker,'?','_');
 org :=  AnsiReplaceStr (org,'?','_');
 p_serial :=  AnsiReplaceStr (p_serial,'?','_');
 p_number :=  AnsiReplaceStr (p_number,'?','_');
 s_numb :=  AnsiReplaceStr (s_numb,'?','_');
 s_b_date :=  AnsiReplaceStr (s_b_date,'?','_');
 s_e_date :=  AnsiReplaceStr (s_e_date,'?','_');
 s_mobile :=  AnsiReplaceStr (s_mobile,'?','_');
 s_target :=  AnsiReplaceStr (s_target,'?','_');
 s_caller :=  AnsiReplaceStr (s_caller,'?','_');

 old_b_date := s_b_date;
 old_e_date := s_e_date;

// if s_b_date = '%' then s_b_date := '01.jan.1800';
// if s_e_date = '%' then s_e_date := '01.jan.2800';
 if s_b_date = '%' then s_b_date := '01.jan.1800' else
  begin
   try
    s_b_date := MyDateToStr(StrToDate(s_b_date));
   except s_b_date := '01.jan.1800';end;
  end;
 if s_e_date = '%' then s_e_date := '01.jan.2800' else
  begin
   try
    s_e_date := MyDateToStr(StrToDate(s_e_date));
   except s_e_date := '01.jan.2800';end;
  end;

     f := 'select * from dias_v_all_person where crn = '+crn;
     p := ' and ';
     if name1 <> '%' then
      begin
       if AnsiContainsStr(name1,'%') or AnsiContainsStr(name1,'_') then f := f + p+ 'family like '+QuotedStr(name1)
        else f := f + p + 'family = '+QuotedStr(name1);
      end;
     if name2 <> '%' then
      begin
       if AnsiContainsStr(name2,'%') or AnsiContainsStr(name2,'_') then f := f + p+ 'f_name like '+QuotedStr(name2)
        else f := f + p + 'f_name = '+QuotedStr(name2);
      end;
     if name3 <> '%' then
      begin
       if AnsiContainsStr(name3,'%') or AnsiContainsStr(name3,'_') then f := f + p+ 'l_name like '+QuotedStr(name3)
        else f := f + p + 'l_name = '+QuotedStr(name3);
      end;
     if org <> '%' then
      begin
       if AnsiContainsStr(org,'%') or AnsiContainsStr(org,'_') then f := f + p+ 'org like '+QuotedStr(org)
        else f := f + p + 'org = '+QuotedStr(org);
      end;
     if p_serial <> '%' then
      begin
       if AnsiContainsStr(p_serial,'%') or AnsiContainsStr(p_serial,'_') then f := f + p+ 'p_serial like '+QuotedStr(p_serial)
        else f := f + p + 'p_serial = '+QuotedStr(p_serial);
      end;
     if p_number <> '%' then
      begin
       if AnsiContainsStr(p_number,'%') or AnsiContainsStr(p_number,'_') then f := f + p+ 'p_number like '+QuotedStr(p_number)
        else f := f + p + 'p_number = '+QuotedStr(p_number);
      end;
      //NEW 07.26.2005
     if s_b_date <> '01.jan.1800' then
      begin
       f := f + p + ' LAST_ACC_END_DATE >= '+QuotedStr(s_b_date);
      end;
     if s_e_date <> '01.jan.2800' then
      begin
       f := f + p + ' LAST_ACC_END_DATE <= '+QuotedStr(s_e_date);
      end;

{ if not((s_numb =   '%') and (s_b_date = '01.jan.1800') and (s_e_date = '01.jan.2800') and
    (s_mobile = '%') and (s_target = '%') and (s_caller = '%')) then // если пропуска учитываем}

 if not((s_numb =   '%') and (s_mobile = '%') and (s_target = '%') and (s_caller = '%')) then // если пропуска учитываем
    begin
     f:= f + ' and rn in (select prn from dias_access where ';
     p:='';
     if s_numb <> '%' then
      begin
       if AnsiContainsStr(s_numb,'%') or AnsiContainsStr(s_numb,'_') then f := f + p+ 'numb like '+QuotedStr(s_numb)
        else f := f + p + 'numb = '+QuotedStr(s_numb);
       p:= ' and ';
      end;
     if s_mobile <> '%' then
      begin
       if AnsiContainsStr(s_mobile,'%') or AnsiContainsStr(s_mobile,'_') then f := f + p+ 'mobile like '+QuotedStr(s_mobile)
        else f := f + p + 'mobile = '+QuotedStr(s_mobile);
       p:= ' and ';
      end;
     if s_target <> '%' then
      begin
       if AnsiContainsStr(s_target,'%') or AnsiContainsStr(s_target,'_') then f := f + p+ 's_target like '+QuotedStr(s_target)
        else f := f + p + 's_target = '+QuotedStr(s_target);
       p:= ' and ';
      end;
     if s_caller <> '%' then
      begin
       if AnsiContainsStr(s_caller,'%') or AnsiContainsStr(s_caller,'_') then f := f + p+ 's_caller like '+QuotedStr(s_caller)
        else f := f + p + 's_caller = '+QuotedStr(s_caller);
       p:= ' and ';
      end;
{     if s_b_date <> '01.jan.1800' then
      begin
       f := f + p + ' e_date >= '+QuotedStr(s_b_date);
      end;
     if s_e_date <> '01.jan.2800' then
      begin
       f := f + p + ' e_date <= '+QuotedStr(s_e_date);
      end;}
     f := f + ' and for_worker = '+is_worker+')';
    end;
 s_b_date := old_b_date;
 s_e_date := old_e_date;

 result := f;
end;
(*==============================================================================================*)
Function  AddPerson(crn:integer;family,f_name,l_name,p_numb,p_serial,org,proff ,addr: string;birth_date : TDateTime):integer;
var
 c_val : integer;
begin
    sql.Clear;
    sql.Add('select dias_id.nextval as c_val from dual');
    OpenCM(sql);
    c_val :=dm.cm.FieldByName('c_val').AsInteger;
//    ShowMessage(FormatDateTime('dd.mm.yyyy',birth_date));
    sql.Clear;
    sql.Add('begin');
    sql.Add('insert into dias_person values ('+IntToStr(c_val)+','+IntToStr(crn)+','+QuotedStr(org)+','+QuotedStr(p_serial)+','+QuotedStr(p_numb)+','+QuotedStr(family)+','+QuotedStr(f_name)+','+QuotedStr(l_name)+',0,'+QuotedStr(MyDateToStr(StrToDate(FormatDateTime('dd.mm.yyyy',birth_date))))+',NULL,'+QuotedStr(proff)+','+QuotedStr(addr)+');');
    sql.Add('commit;');
    sql.Add('end;');
    ExecCM (sql);
    result := c_val;
end;
(*==============================================================================================*)
Function  AddAccess(prn:integer;numb,s_target,s_caller,mobile:string;b_date,e_date : TDateTime;for_worker:integer):integer;
var
 c_val : integer;
begin
    sql.Clear;
    sql.Add('select dias_id.nextval as c_val from dual');
    OpenCM(sql);
    c_val :=dm.cm.FieldByName('c_val').AsInteger;
    sql.Clear;
    sql.Add('begin');
    sql.Add('insert into dias_access values ('+IntToStr(c_val)+','+IntToStr(prn)+','+QuotedStr(MyDateToStr(b_date))+','+QuotedStr(MyDateToStr(e_date))+','+QuotedStr(numb)+','+QuotedStr(s_target)+','+QuotedStr(s_caller)+',null,null,'+IntToStr(for_worker)+','+QuotedStr(mobile)+',0);');
    sql.Add('commit;');
    sql.Add('end;');
    ExecCM (sql);
    result := c_val;
    wrlog(c_val,for_worker,0,prn,numb);
end;
(*==============================================================================================*)
Procedure AddCatalog;
begin
end;
(*==============================================================================================*)
Function  EditPerson(rn,crn:integer;family,f_name,l_name,p_numb,p_serial,org,proff,addr : string;birth_date : TDateTime):integer;
begin
 sql.Clear;
 sql.Add('begin');
 sql.Add('update dias_person set ');

 sql.Add(' crn = '+IntToStr(crn)+',');
 sql.Add(' family = '+QuotedStr(family)+',');
 sql.Add(' f_name = '+QuotedStr(f_name)+',');
 sql.Add(' l_name = '+QuotedStr(l_name)+',');
 sql.Add(' p_number = '+QuotedStr(p_numb)+',');
 sql.Add(' p_serial = '+QuotedStr(p_serial)+',');
 sql.Add(' birth_date = '+QuotedStr(MyDateToStr(StrToDate(FormatDateTime('dd.mm.yyyy',birth_date))))+',');
 sql.Add(' proff = '+QuotedStr(proff)+',');
 sql.Add(' addr = '+QuotedStr(addr)+',');
 sql.Add(' org = '+QuotedStr(org)+' where rn = '+IntToStr(rn)+';');

 sql.Add('commit;');
 sql.Add('end;');
 ExecCM(sql);
 result := rn;
end;
(*==============================================================================================*)
Function  EditAccess(rn,prn:integer;numb,s_target,s_caller,mobile:string;b_date,e_date : TDateTime;for_worker:integer):integer;
begin
    sql.Clear;
    sql.Add('begin');
    sql.Add('update dias_access set ');

    sql.Add(' prn = '+IntToStr(prn)+',');
    sql.Add(' b_date = '+QuotedStr(MyDateToStr(b_date))+',');
    sql.Add(' e_date = '+QuotedStr(MyDateToStr(e_date))+',');
    sql.Add(' numb = '+QuotedStr(numb)+',');
    sql.Add(' s_target = '+QuotedStr(s_target)+',');
    sql.Add(' s_caller = '+QuotedStr(s_caller)+',');
    sql.Add(' for_worker = '+IntToStr(for_worker)+',');
    sql.Add(' mobile = '+QuotedStr(mobile)+' where rn = '+IntToStr(rn)+';');

    sql.Add('commit;');
    sql.Add('end;');
    ExecCM (sql);
    result := rn;
    wrlog(rn,for_worker,1,prn,numb);
end;
(*==============================================================================================*)
Procedure EditCatalog;
begin
end;
(*==============================================================================================*)
Procedure DeletePerson(rn : integer);
begin
  sql.Clear;
  SQL.Add('begin');
//  SQL.Add('delete from dias_access where prn = '+IntToStr(rn)+' and for_worker = 0;');
  SQL.Add('delete from dias_person where rn = '+IntToStr(rn)+';');
  SQL.Add('end;');
  ExecCM(sql);
end;
(*==============================================================================================*)
Procedure DeleteAccess;
begin
end;
(*==============================================================================================*)
Procedure DeleteCatalog;
begin
end;
(*==============================================================================================*)
Procedure ExecCM (s : TStringList);
begin
 if dm.cm.Active then dm.cm.Close;
 dm.cm.SQL.Clear;
 dm.cm.SQL.AddStrings(s);
 dm.cm.ExecSQL;
end;
(*==============================================================================================*)
Procedure OpenCM (s : TStringList);
begin
 if dm.cm.Active then dm.cm.Close;
 dm.cm.SQL.Clear;
 dm.cm.SQL.AddStrings(s);
 dm.cm.open;
end;
(*==============================================================================================*)
Procedure WrLog (acc_rn,for_worker,reason,prn : integer; numb : string);
begin
 ini.WriteInteger('main','acc_rn',acc_rn);
 ini.WriteInteger('main','for_worker',for_worker);
 ini.WriteInteger('main','reason',reason);
 ini.WriteInteger('main','prn',prn);
 ini.WriteString('main','numb',numb);
end;
(*==============================================================================================*)
begin
sql := TStringList.Create;
end.
