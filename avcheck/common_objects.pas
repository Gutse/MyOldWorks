unit
  common_objects;

interface

uses
  common, log, SysUtils, Windows, IniFiles, Classes, Registry, IdSmtp, MyRegistry64;
var
  apps_loaded: boolean = false;
  error_message: string;
  ini: TIniFile;
  soft_types, soft_list, temp_list, app_list: TStringList;
  reg: TRegistry;
  mail: TIdSMTP;


type
  pbool = ^Boolean;
  TisWow64Proc = function(proc: THandle; res: pbool): boolean; stdcall;

var
  fnIsWow64Process: TisWow64Proc;

function IsWow64(): boolean;

function init: boolean;
function LoadSoftList(soft_type: string): boolean;
procedure LoadAppList;
procedure quit;

implementation


function IsWow64(): boolean;
var
  bIsWow64: boolean;
  pa: pointer;
begin
  bIsWow64 := FALSE;
  pa := GetProcAddress(GetModuleHandle('kernel32'), 'IsWow64Process');
  fnIsWow64Process := pa;
  if (pa <> nil) then
  begin if not (fnIsWow64Process(GetCurrentProcess(), @bIsWow64)) then
    begin
            //handle error
    end;
  end;
  result := bIsWow64;
end;


procedure MyFree(var obj);
var
  Temp: TObject;
begin
  if Pointer(obj) <> nil then
  begin
    Temp := TObject(Obj);
    Pointer(Obj) := nil;
    Temp.Free;
  end;
end;

procedure free_all;
begin
  try
    MyFree(temp_list);
    MyFree(app_list);
    MyFree(soft_types);
    MyFree(soft_list);
    MyFree(reg);
    MyFree(ini);
    MyFree(mail);
  except end;
end;

function init: boolean;
var i: integer;
begin
// зададим начальные значения, при чем тут никаких эксепшенов быть не должно
  ini := nil;
  soft_types := nil;
  soft_list := nil;
  temp_list := nil;
  app_list := nil;
  reg := nil;
  mail := nil;
  error_message := '';
  result := true;
  // создаем обьекты
  try
    temp_list := TStringList.Create;
    app_list := TStringList.Create;
    soft_types := TStringList.Create;
    soft_list := TStringList.Create;
    reg := TRegistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Uninstall');
    ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'avcheck.ini');
    mail := TIdSMTP.Create(nil);
  except
    on e: exception do
    begin
      free_all;
      error_message := 'Исключение при создании обьектов: "' + e.Message + '"';
      result := false;
    end;
  end;
  if result then
  begin
    try
      mail.Host := ini.ReadString('options', 'mail_server', 'yourserver.com');
      mail.Port := ini.ReadInteger('options', 'mail_server', 25);
      ini.ReadSection('product_types', temp_list);
      if temp_list.Count = 0 then
      begin
        raise Exception.Create('Не указаны типы ПО');
      end;
      for i := 0 to temp_list.Count - 1 do
      begin
        if trim(ini.ReadString('product_types', temp_list[i], '')) <> '' then soft_types.Add(trim(ini.ReadString('product_types', temp_list[i], '')));
      end;
      if soft_types.Count = 0 then
      begin
        FreeAndNil(ini);
        raise Exception.Create('Неверно указаны типы ПО');
      end;
      LoadAppList;
    except
      on e: exception do
      begin
        free_all;
        error_message := 'Исключение при инициализации обьектов: "' + e.Message + '"';
        result := false;
      end;
    end;
  end;
end;

procedure LoadAppList;
var
  i: integer;
  r64: TRegistry64;
  apps64: TStringlist;
begin
  if apps_loaded then exit;
  apps_loaded := true;
  try
    reg.GetKeyNames(app_list);
    if app_list.count = 0 then raise Exception.Create('Список пуст');
    for i := app_list.count - 1 downto 0 do
    begin
      reg.CloseKey;
      reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' + app_list[i]);
      app_list[i] := AnsiLowerCase(reg.ReadString('DisplayName'));
      if app_list[i] = '' then app_list.Delete(i);
    end;
  except on e: exception do
    begin
      LogMsg('Не удалось загрузить список установленных приложений: "' + e.Message + '"');
      app_list.Add('Этой записи никогда не будет в списке программ');
    end;
  end;
  if IsWow64 then
  begin
    try
      apps64 := TStringlist.Create;
      r64 := TRegistry64.Create(KEY_WOW64_64KEY);
      r64.RootKey := HKEY_LOCAL_MACHINE;
      r64.OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Uninstall');
      r64.GetKeyNames(apps64);
      if apps64.Count > 0 then
      begin
        for i := apps64.count - 1 downto 0 do
        begin
          r64.CloseKey;
          r64.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' + apps64[i]);
          apps64[i] := AnsiLowerCase(r64.ReadString('DisplayName'));
          if apps64[i] = '' then apps64.Delete(i);
        end;
      end;
      app_list.AddStrings(apps64);
      // если не вышло создать список - ну и фиг с ним
    except end;
  end;
end;

procedure quit;
begin
  free_all;
end;

function LoadSoftList(soft_type: string): boolean;
var
  i: integer;
begin
  try
    temp_list.clear;
    soft_list.clear;
    ini.ReadSection(soft_type, temp_list);
    if temp_list.Count > 0 then
    begin
      for i := 0 to temp_list.Count - 1 do
      begin
        if trim(ini.ReadString(soft_type, temp_list[i], '')) <> '' then soft_list.Add(trim(ini.ReadString(soft_type, temp_list[i], '')));
      end;
    end;
    if soft_list.count = 0 then raise Exception.Create('Список пуст');
    result := true;
  except on e: exception do
    begin
      LogMsg('Не удалось загрузить список ПО для группы "' + soft_type + '": "' + e.Message + '".');
      result := false;
    end;
  end;
end;

end.

