unit Main;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Menus, Grids, DBGrids,common,person_edit,FilterEdit,
  DBGridEh,IniFiles,db, cxPropertiesStore;
type
  rn_store =class(TObject)
   rn,crn : integer;
  end;
  TMainFrm = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    TreeView1: TTreeView;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Splitter1: TSplitter;
    catalog_menu: TPopupMenu;
    N5: TMenuItem;
    N7: TMenuItem;
    person_menu: TPopupMenu;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N15: TMenuItem;
    DBGrid2: TDBGrid;
    access_menu: TPopupMenu;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    DBGridEh1: TDBGridEh;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure N15Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure DBGrid1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure DBGridEh1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure FormShow(Sender: TObject);
    procedure DBGridEh1Columns6CheckDrawRequiredState(Sender: TObject;
      Text: String; var DrawState: Boolean);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    Logged : boolean;
    MainFilter : string;
    gFilter: TAccessFilter;
    Function Logon : boolean;
    Procedure SessionClose;
    Procedure SessionStart;
    Function GetCtlgRN (node : TTreeNode) : integer;
    Function GetCtlgCRN (node : TTreeNode) : integer;
    Function  FillCtlg:integer;
    Procedure ParseCtlg (node : TTreeNode);
    Procedure ClearTree;
    PRocedure AllSetCursor (c:integer);
  end;
var
  MainFrm: TMainFrm;
implementation
uses Logon, DataMod, StringEdit, PassEdit;
{$R *.dfm}
(*==============================================================================================*)
procedure TMainFrm.FormCreate(Sender: TObject);
begin
// cxPropertiesStore1.RestoreFrom;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName)+'acc.ini');
// LogonFrm := TLogonFrm.Create(self);
// Logged := Logon;
  dm.connection.ConnectionString := 'Provider=MSDAORA.1;Password='+Ini.ReadString('main','password','securyti')+';User ID='+Ini.ReadString('main','login','securyti')+';Data Source='+Ini.ReadString('main','server','boss')+';Persist Security Info=True';
  try
   dm.connection.Open;
   Logged := true;
  except
    on E: Exception do
     begin
      ShowMessage('Вход в систему не удался: '+e.Message);
      Logged := false;
     end;
    end;
 if Logged then SessionStart else Application.Terminate;
 MainFilter := '';
end;
(*==============================================================================================*)
Function TMainFrm.Logon : boolean;
begin
 LogonFrm.ShowModal;
 result:=LogonFrm.Logged;
 if Logged then SessionStart;
end;
(*==============================================================================================*)
Procedure TMainFrm.SessionClose;
begin
 dm.connection.Close;
 Logged := false;
 ClearTree;
 gFilter.Free;
end;
(*==============================================================================================*)
Procedure TMainFrm.SessionStart;
var
 acc_rn,l_reason,for_worker,crn ,prn,i: integer;

begin
  gFilter := TAccessFilter.Create;
  FillCtlg;
 try
 l_reason := ini.ReadInteger('main','reason',0);
 case l_reason of
  0 :  StatusBar1.SimpleText := 'Последний добавленный пропуск: '+ini.ReadString('main','numb','не найдено');
  1 :  StatusBar1.SimpleText := 'Последний измененный пропуск: '+ini.ReadString('main','numb','не найдено');
  end;
 for_worker := ini.ReadInteger('main','for_worker',0);
 prn := ini.ReadInteger('main','prn',0);
 crn := ini.ReadInteger('main','crn',0);
 if dm.cm.Active then dm.cm.Close;
 dm.cm.SQL.Clear;
 dm.cm.SQL.Add('select crn from dias_v_all_person where rn = '+IntToStr(prn)+' and is_worker = '+IntToStr(for_worker));
 dm.cm.Open;
 crn := dm.cm.FieldByName('crn').AsInteger;
 For i := 0 to TreeView1.Items.Count-1 do
  begin
   if GetCtlgRN(TreeView1.Items[i]) = crn then
    begin
     TreeView1.Select(TreeView1.Items[i]);
    end;
  end;
 DM.persons.Locate('rn;is_worker',VarArrayOf([prn,for_worker]),[loPartialKey]);
 DM.ACCESS_T.Locate('rn;for_worker',VarArrayOf([crn,for_worker]),[loPartialKey]);
 except end;
 StatusBar1.Update;
end;
(*==============================================================================================*)
Function TMainFrm.FillCtlg:integer;
var
 i : integer;
 new_rn : rn_store;
 tmp_node : TTreeNode;
begin
 // находим папки нулевого уровня
 if DM.CTLG_Q.Active then DM.CTLG_Q.Close;
 DM.CTLG_Q.SQL.Clear;
 DM.CTLG_Q.SQL.Add('select * from dias_acatalog where crn is null order by name');
 DM.CTLG_Q.Open;
 DM.CTLG_Q.First;
 result := DM.CTLG_Q.RecordCount;
 if DM.CTLG_Q.RecordCount <= 0 then exit;
 For i:= 0 to DM.CTLG_Q.RecordCount-1 do
  begin
   new_rn := rn_store.Create;
   new_rn.rn := DM.CTLG_Q.FieldByName('rn').AsInteger;
   new_rn.crn :=0;
   TreeView1.Items.AddChildObject(TreeView1.Items[0],trim(DM.CTLG_Q.FieldByName('name').AsString),new_rn);
   DM.CTLG_Q.Next;
  end;
 // ищем подпапки
 tmp_node := TreeView1.Items[0].getFirstChild;
 ParseCtlg(tmp_node);
 tmp_node:=TreeView1.Items[0].GetNextChild(tmp_node);
 while tmp_node <> nil do
  begin
   ParseCtlg(tmp_node);
   tmp_node:=TreeView1.Items[0].GetNextChild(tmp_node);
  end;
 // добавим папку сотрудников
 new_rn := rn_store.Create;
 new_rn.rn  := -1;
 new_rn.crn := -1;
 TreeView1.Items.AddChildObject(TreeView1.Items[0],'Сотрудники',new_rn);
 TreeView1.FullExpand;
end;
(*==============================================================================================*)
Procedure TMainFrm.ParseCtlg (node : TTreeNode);
var
 count,i:integer;
 tmp_node : TTreeNode;
 rn,new_rn : rn_store;
begin
 rn := rn_store(node.data);
 if DM.CTLG_Q.Active then DM.CTLG_Q.Close;
 DM.CTLG_Q.SQL.Clear;
 DM.CTLG_Q.SQL.Add('select * from dias_acatalog where crn = '+''''+IntToStr(rn.rn)+''''+' order by name');
 DM.CTLG_Q.Open;
 DM.CTLG_Q.First;
 count :=DM.CTLG_Q.RecordCount;
 if DM.CTLG_Q.RecordCount <= 0 then exit;

 For i:= 0 to DM.CTLG_Q.RecordCount-1 do
  begin
   new_rn := rn_store.Create;
   new_rn.rn := DM.CTLG_Q.FieldByName('rn').AsInteger;
   new_rn.crn :=rn.rn;
   TreeView1.Items.AddChildObject(node,trim(DM.CTLG_Q.FieldByName('name').AsString),new_rn);
   DM.CTLG_Q.Next;
  end;
 tmp_node:=node.getFirstChild;
 ParseCtlg(tmp_node);
 if count >= 2 then
  begin
   tmp_node:=node.GetNextChild(tmp_node);
   while tmp_node <> nil do
    begin
     ParseCtlg(tmp_node);
     tmp_node:=node.GetNextChild(tmp_node);
    end;
  end;
end;
(*==============================================================================================*)
procedure TMainFrm.FormDestroy(Sender: TObject);
begin
//cxPropertiesStore1.StoreTo;
SessionClose;
LogonFrm.Free;
ini.Free;
end;
(*==============================================================================================*)
Function TMainFrm.GetCtlgRN (node : TTreeNode) : integer;
begin
 if (node <> nil) and (node.Data <> nil) then  result := rn_store(node.Data).rn else result := 0;
end;
(*==============================================================================================*)
Function TMainFrm.GetCtlgCRN (node : TTreeNode) : integer;
begin
 if node.Data <> nil then  result := rn_store(node.Data).crn else result := 0;
end;
(*==============================================================================================*)
Procedure TMainFrm.ClearTree;
var
 i:integer;
begin
 For i:=0 to TreeView1.Items.Count-1 do
  begin
   if TreeView1.items[i].Data <> nil then rn_store(TreeView1.items[i].Data).Free;
  end;
 TreeView1.Items.Clear;
end;
(*==============================================================================================*)
procedure TMainFrm.N5Click(Sender: TObject);
var
 cur_rn,new_rn : rn_store;
begin
 if not(Assigned(TreeView1.Selected)) then exit;
 StrEditFrm.ShowModal;

 if StrEditFrm.mr = mrCancel then exit;
 if trim(StrEditFrm.Edit1.Text) = '' then exit;
 cur_rn := rn_store(TreeView1.Selected.Data);
 if DM.CTLG_Q.Active then DM.CTLG_Q.Close;
 DM.CTLG_Q.SQL.Clear;
 if cur_rn = nil then
  begin
   try
     DM.CTLG_Q.SQL.Add('insert into dias_acatalog values (dias_id.nextval,null,'+''''+trim(StrEditFrm.Edit1.Text)+''''+')');
     DM.CTLG_Q.ExecSQL;
   except on e:exception do
    begin
     ShowMessage ('Ошибка при добавлении каталога:'+e.Message );
     exit;
    end; end;
    new_rn := rn_store.Create;
    if DM.CTLG_Q.Active then DM.CTLG_Q.Close;
    DM.CTLG_Q.SQL.Clear;
    DM.CTLG_Q.SQL.Add('select dias_id.currval as c_val from dual');
    DM.CTLG_Q.Open;
    new_rn.rn :=DM.CTLG_Q.FieldByName('c_val').AsInteger;
    new_rn.crn := 0;
    TreeView1.Items.AddChildObject(TreeView1.Items[0],trim(StrEditFrm.Edit1.Text),new_rn)
  end else
  begin
   try
     DM.CTLG_Q.SQL.Add('insert into dias_acatalog values (dias_id.nextval,'+IntToStr(cur_rn.rn)+','+''''+trim(StrEditFrm.Edit1.Text)+''''+')');
     DM.CTLG_Q.ExecSQL;
   except on e:exception do
    begin
     ShowMessage ('Ошибка при добавлении каталога:'+e.Message );
     exit;
    end; end;
    new_rn := rn_store.Create;
    if DM.CTLG_Q.Active then DM.CTLG_Q.Close;
    DM.CTLG_Q.SQL.Clear;
    DM.CTLG_Q.SQL.Add('select dias_id.currval as c_val from dual');
    DM.CTLG_Q.Open;
    new_rn.rn :=DM.CTLG_Q.FieldByName('c_val').AsInteger;
    new_rn.crn := cur_rn.rn;
    TreeView1.Items.AddChildObject(TreeView1.Selected,trim(StrEditFrm.Edit1.Text),new_rn)
  end;
end;
(*==============================================================================================*)
procedure TMainFrm.N6Click(Sender: TObject);
var
 cur_rn : rn_store;
begin
 if not(Assigned(TreeView1.Selected)) then exit;
 cur_rn := rn_store(TreeView1.Selected.Data);
 if cur_rn = nil then exit;
 if cur_rn.rn = -1 then exit;
 if MessageDlg('Вы действительно хотите удалить этот каталог? (Все записи будут удалены) ',mtConfirmation,[mbOk,mbCancel],-1) = mrOk then
  begin
   if dm.CTLG_Q.Active then dm.CTLG_Q.Close;
   dm.CTLG_Q.SQL.Clear;
//   dm.CTLG_Q.SQL.Add('delete from dias_acatalog where rn = '+IntToStr(cur_rn.rn));
   dm.CTLG_Q.SQL.Add('begin');
//   dm.CTLG_Q.SQL.Add('delete from dias_access where prn in (select rn from dias_person where crn = '+IntToStr(cur_rn.rn)+');');
//   dm.CTLG_Q.SQL.Add('delete from dias_person where crn = '+IntToStr(cur_rn.rn)+';');
   dm.CTLG_Q.SQL.Add('delete from dias_acatalog where rn = '+IntToStr(cur_rn.rn)+';');
   dm.CTLG_Q.SQL.Add('end;');
   try
    dm.CTLG_Q.ExecSQL;
    TreeView1.Items.Delete(TreeView1.Selected);
   except on e:exception do ShowMessage('Ошибка при удалении каталога: '+e.Message); end;
  end;
end;
(*==============================================================================================*)
procedure TMainFrm.N7Click(Sender: TObject);
var
 cur_rn : rn_store;
begin
 if not(Assigned(TreeView1.Selected)) then exit;
 cur_rn := rn_store(TreeView1.Selected.Data);
 if cur_rn = nil then exit;
 StrEditFrm.Edit1.Text := TreeView1.Selected.Text;
 StrEditFrm.ShowModal;
 if StrEditFrm.mr = mrCancel then exit;
 if trim(StrEditFrm.Edit1.Text) = '' then exit;
 if dm.CTLG_Q.Active then dm.CTLG_Q.Close;
 dm.CTLG_Q.SQL.Clear;
 dm.CTLG_Q.SQL.Add('update dias_acatalog set name = '+''''+trim(StrEditFrm.Edit1.Text)+''''+' where rn = '+IntToStr(cur_rn.rn));
 try
  dm.CTLG_Q.ExecSQL;
  TreeView1.Selected.Text :=trim(StrEditFrm.Edit1.Text);
 except on e:exception do ShowMessage('Ошибка при изменении каталога: '+e.Message); end;
end;
(*==============================================================================================*)
procedure TMainFrm.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
 f : string;
begin
gFilter.crn:=IntToStr(GetCtlgRN(node));
//if gFilter.crn = '0' then exit;
if gFilter.crn = '-1' then gFilter.is_worker:= '1' else gFilter.is_worker:= '0';
dm.persons.SQL.Clear;
f:=gFilter.GetGoodFilterString;
dm.persons.SQL.Add(f);
AllSetCursor(crHourGlass);
if dm.persons.Active then dm.persons.Requery else dm.persons.Open;
AllSetCursor(crDefault);
end;
(*==============================================================================================*)
procedure TMainFrm.N15Click(Sender: TObject);
var
 f : string;
begin
if TreeView1.Selected = nil then exit;
gFilter.crn:=IntToStr(GetCtlgRN(TreeView1.Selected));
//if gFilter.crn = '0' then exit;
FilterFrm.Left := self.Left;
FilterFrm.Top := self.top;
FilterFrm.ShowModal;
if not(FilterFrm.done) then exit;
gFilter.name1:= FilterFrm.LabeledEdit1.Text;
gFilter.name2:= FilterFrm.LabeledEdit2.Text;
gFilter.name3:= FilterFrm.LabeledEdit3.Text;
if gFilter.crn = '-1' then gFilter.is_worker:= '1' else gFilter.is_worker:= '0';

gFilter.org:= FilterFrm.LabeledEdit6.Text;
gFilter.p_serial:= FilterFrm.LabeledEdit5.Text;
gFilter.p_number:= FilterFrm.LabeledEdit4.Text;

gFilter.s_numb:= FilterFrm.LabeledEdit7.Text;
gFilter.s_b_date:= FilterFrm.LabeledEdit8.Text;
gFilter.s_e_date:= FilterFrm.LabeledEdit9.Text;
gFilter.s_mobile:= FilterFrm.LabeledEdit10.Text;
gFilter.s_target:= FilterFrm.LabeledEdit11.Text;
gFilter.s_caller:= FilterFrm.LabeledEdit12.Text;

dm.persons.SQL.Clear;
f:=gFilter.GetGoodFilterString;
dm.persons.SQL.Add(f);
AllSetCursor(crHourGlass);
if dm.persons.Active then dm.persons.Requery else dm.persons.Open;
AllSetCursor(crDefault);
end;
(*==============================================================================================*)
procedure TMainFrm.N8Click(Sender: TObject);
var
 cur_rn : rn_store;
 f : string;
begin
 if not(Assigned(TreeView1.Selected)) then exit;
 cur_rn := rn_store(TreeView1.Selected.Data);
 if cur_rn = nil then exit;
 if cur_rn.rn = -1 then exit;
 PersonFrm.ctlg := cur_rn.rn;
 PersonFrm.reason := 0;
 PersonFrm.Left := self.Left +Panel2.Left;
 PersonFrm.Top := self.top + Panel2.Top;

 PersonFrm.ShowModal;
 if PersonFrm.res <=0 then exit;
 if TreeView1.Selected = nil then exit;
 gFilter.crn:=IntToStr(GetCtlgRN(TreeView1.Selected));
 if (gFilter.crn = '-1') then exit;
 dm.persons.SQL.Clear;
 f:=gFilter.GetGoodFilterString;
 dm.persons.SQL.Add(f);
 if PersonFrm.res > 0 then
  begin
   if dm.persons.Active then dm.persons.Refresh else dm.persons.Open;
   dm.persons.Locate('rn;is_worker',VarArrayOf([PersonFrm.res,0]),[loPartialKey]);
  end;
end;
(*==============================================================================================*)
procedure TMainFrm.N9Click(Sender: TObject);
begin
if MessageDlg('Вы действительно хотите удалить запись?',mtConfirmation,[mbOk,mbCancel],-1) = mrOk then
 begin
  try
   DeletePerson(dm.persons.fieldbyname('rn').asinteger);
   dm.persons.Requery;
  except on e:exception do ShowMessage('Не удалось удалить запись: '+e.Message); end;
 end;
end;
(*==============================================================================================*)
procedure TMainFrm.N10Click(Sender: TObject);
var
 cur_rn : rn_store;
begin
 if not(Assigned(TreeView1.Selected)) then exit;
 cur_rn := rn_store(TreeView1.Selected.Data);
 if cur_rn = nil then exit;
// if cur_rn.rn = -1 then exit;
 PersonFrm.Left := self.Left +Panel2.Left;
 PersonFrm.Top := self.top + Panel2.Top;
 PersonFrm.reason := 1;
 if cur_rn.rn = -1 then PersonFrm.reason := 2;
 PersonFrm.ctlg := cur_rn.rn;
 PersonFrm.ShowModal;
 if PersonFrm.res > 0 then
  begin
   if dm.persons.Active then dm.persons.Requery else dm.persons.Open;
   dm.persons.Locate('rn;is_worker',VarArrayOf([PersonFrm.res,0]),[loPartialKey]);
  end;

end;
(*==============================================================================================*)
procedure TMainFrm.N12Click(Sender: TObject);
var
 l_reason : integer;
begin
 if not(dm.PERSONS.Active) then exit;
 if dm.PERSONS.RecordCount <=0 then exit;
 PassFrm.person := dm.PERSONS.FieldByName('rn').AsInteger;
 PassFrm.reason := 0;
 PassFrm.Left := self.Left +Panel2.Left;
 PassFrm.Top := self.top + Panel2.Top;
 PassFrm.ShowModal;
 l_reason := ini.ReadInteger('main','reason',0);
 case l_reason of
  0 :  StatusBar1.SimpleText := 'Последний добавленный пропуск: '+ini.ReadString('main','numb','не найдено');
  1 :  StatusBar1.SimpleText := 'Последний измененный пропуск: '+ini.ReadString('main','numb','не найдено');
  end;

end;
(*==============================================================================================*)
procedure TMainFrm.N14Click(Sender: TObject);
var l_reason : integer;
begin
 if not(dm.PERSONS.Active) then exit;
 if dm.PERSONS.RecordCount <=0 then exit;
 if (dm.ACCESS_T.Active) and (dm.ACCESS_T.recordCount >0) then
  begin
   PassFrm.person := dm.PERSONS.FieldByName('rn').AsInteger;
   PassFrm.reason := 1;
   PassFrm.Left := self.Left +Panel2.Left;
   PassFrm.Top := self.top + Panel2.Top;
   PassFrm.ShowModal;
  end;
 l_reason := ini.ReadInteger('main','reason',0);
 case l_reason of
  0 :  StatusBar1.SimpleText := 'Последний добавленный пропуск: '+ini.ReadString('main','numb','не найдено');
  1 :  StatusBar1.SimpleText := 'Последний измененный пропуск: '+ini.ReadString('main','numb','не найдено');
  end;
 StatusBar1.Update;

end;
(*==============================================================================================*)
procedure TMainFrm.N13Click(Sender: TObject);
begin
 if not(dm.PERSONS.Active) then exit;
 if dm.PERSONS.RecordCount <=0 then exit;
 if (dm.ACCESS_T.Active) and (dm.ACCESS_T.recordCount >0) then
  begin
   dm.ACCESS_T.Delete;
  end;
end;
(*==============================================================================================*)
procedure TMainFrm.DBGrid1DblClick(Sender: TObject);
begin
N10Click(self);
end;
(*==============================================================================================*)
procedure TMainFrm.DBGrid2DblClick(Sender: TObject);
begin
N14Click(self);
end;
(*==============================================================================================*)
procedure TMainFrm.TreeView1DblClick(Sender: TObject);
begin
N7Click(self);
end;
(*==============================================================================================*)
PRocedure TMainFrm.AllSetCursor (c:integer);
begin
 TreeView1.Cursor := c;
 DBGridEh1.Cursor := c;
 DBGrid2.Cursor := c;
end;
(*==============================================================================================*)

procedure TMainFrm.TreeView1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin

Accept := (Source = DBGridEh1)
 and (dm.persons.RecordCount > 0)
 and (GetCtlgRN(TreeView1.GetNodeAt(x,y)) > 0);
end;

procedure TMainFrm.DBGrid1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
 if dm.persons.RecordCount <= 0 then  CancelDrag;
end;

procedure TMainFrm.TreeView1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
if (Source = DBGridEh1) and (dm.persons.RecordCount > 0) and (GetCtlgRN(TreeView1.GetNodeAt(x,y)) > 0) and (dm.persons.FieldByName('crn').AsInteger > 0) then
 begin
  EditPerson(
  	dm.persons.fieldbyname('rn').AsInteger,
   GetCtlgRN(TreeView1.GetNodeAt(x,y)),
  	dm.persons.fieldbyname('Family').AsString,
  	dm.persons.fieldbyname('f_name').AsString,
  	dm.persons.fieldbyname('l_name').AsString,
  	dm.persons.fieldbyname('p_number').AsString,
  	dm.persons.fieldbyname('p_serial').AsString,
  	dm.persons.fieldbyname('org').AsString,
  	dm.persons.fieldbyname('proff').AsString,
  	dm.persons.fieldbyname('addr').AsString,
   dm.persons.fieldbyname('birth_date').AsDateTime);
  dm.persons.Requery;
 end;
end;

procedure TMainFrm.DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//DBGrid1.BeginDrag(false,-1);

end;

procedure TMainFrm.DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//CancelDrag
end;

procedure TMainFrm.DBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
{if (ssLeft in Shift) and
  ( (Sender as TCustomGrid).MouseCoord(X,Y).Y > 0 ) then
  TDBGrid(Sender).BeginDrag(False);
 }
end;

procedure TMainFrm.DBGridEh1DblClick(Sender: TObject);
begin
N10Click(self);
EndDrag(true);
end;

procedure TMainFrm.DBGridEh1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if (Button = mbLeft) and not(ssDouble in Shift )and (dm.persons.FieldByName('crn').AsInteger > 0) then DBGridEh1.BeginDrag(false,-1);
end;

procedure TMainFrm.DBGridEh1TitleClick(Column: TColumnEh);
begin
 if DM.PERSONS.Sort = Column.Field.FieldName +' ASC' then DM.PERSONS.Sort := Column.Field.FieldName +' DESC'
  else DM.PERSONS.Sort := Column.Field.FieldName +' ASC';
end;

procedure TMainFrm.FormShow(Sender: TObject);
begin
 StatusBar1.Update;
end;

procedure TMainFrm.DBGridEh1Columns6CheckDrawRequiredState(Sender: TObject;
  Text: String; var DrawState: Boolean);
begin
{ try
  if (text <> '') and (StrToDate(text) = 0) then DrawState := true;
 except end;}
end;

procedure TMainFrm.DBGridEh1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
{ if (DataCol = 6) then
  begin
   try
    if (Column.DisplayText <> '') and (StrToDate(Column.DisplayText) = 0) then
     begin
      dbgrideh1.canvas.Brush.Color := clRed;
      dbgrideh1.canvas.FillRect(rect);
     end;
   except end;
  end;}
end;

procedure TMainFrm.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if (Column.Index = 6) and (Column.Field.AsDateTime = 0) then AFont.Color := clRed;
end;

end.
