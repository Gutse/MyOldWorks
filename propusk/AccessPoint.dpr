program AccessPoint;

uses
  Forms,windows,
  Main in 'Main.pas' {MainFrm},
  DataMod in 'DataMod.pas' {DM: TDataModule},
  Logon in 'Logon.pas' {LogonFrm},
  StringEdit in 'StringEdit.pas' {StrEditFrm},
  common in 'common.pas',
  person_edit in 'person_edit.pas' {PersonFrm},
  FilterEdit in 'FilterEdit.pas' {FilterFrm},
  PassEdit in 'PassEdit.pas' {PassFrm};

{$R *.res}
var
  hMap : THandle;

begin
  hMap:=CreateFileMapping($FFFFFFFF,nil,PAGE_READWRITE,0,1,'AccessPointOnOraUniqueMapping');
  if GetLastError = ERROR_ALREADY_EXISTS then
   begin
    MessageBox(0,'Программа уже запущена!','Завершение программы',0);
//    ShowMessage('Программа уже запущена!');
   end else
  begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainFrm, MainFrm);
  Application.CreateForm(TStrEditFrm, StrEditFrm);
  Application.CreateForm(TPersonFrm, PersonFrm);
  Application.CreateForm(TFilterFrm, FilterFrm);
  Application.CreateForm(TPassFrm, PassFrm);
  //  Application.CreateForm(TLogonFrm, LogonFrm);
  Application.Run;
  CloseHandle(hMap);
  end;
end.
