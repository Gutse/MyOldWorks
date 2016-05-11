unit
  checks;
interface
uses
  common, common_objects, log, strutils, sysutils, windows;
function check_soft_req(name: string): boolean;
function check_soft_install(name, field, value: string): boolean;

implementation

function check_soft_install(name, field, value: string): boolean;
var
  i, j: integer;
  procedure GetValues;
  var
    pos: integer;
  begin
    try
      temp_list.clear;
      pos := AnsiPos('|', value);
      if pos = 0 then temp_list.Add(AnsiLowerCase(value)) else
      begin
        repeat
          temp_list.Add(AnsiLowerCase(AnsiLeftStr(value, pos - 1)));
          value := AnsiRightStr(value, length(value) - pos);
          pos := AnsiPos('|', value);
        until (pos = 0) or (value = '');
        if value <> '' then temp_list.Add(AnsiLowerCase(value));
      end;
    except on e: exception do
      begin
        LogMsg('Не удалось распарсить список поиска для "' + name + '": "' + e.Message + '".');
        temp_list.Add('this field never will find');
      end;
    end;
  end;
begin
// field может быть: install file service
  result := false;
  value := trim(value);
  if value = '' then exit;
  if field = 'install' then
  begin
    if app_list.count = 0 then exit;
    GetValues;
    for i := 0 to app_list.count - 1 do
    begin
      for j := 0 to temp_list.count - 1 do
      begin
        if app_list[i] = temp_list[j] then
        begin
          LogMsg('Найден ' + name);
          result := true;
          exit;
        end;
      end;
    end;
  end;

  if field = 'file' then
  begin
    GetValues;
    for i := 0 to temp_list.count - 1 do
    begin
      if FileExists(temp_list[i]) then
      begin
        result := true;
        break;
      end;
    end;
  end;

  if field = 'service' then
  begin
    GetValues;
    for i := 0 to temp_list.count - 1 do
    begin
    end;
  end;
end;

function check_soft_req(name: string): boolean;
var
  mem: _MEMORYSTATUS;
  r_freq, r_mem: integer;
begin
  cpu_spd := GetCPUSpeed;
  if cpu_spd = 0 then
  begin
    result := false;
    exit;
  end;
  mem.dwLength := SizeOf(mem);
  GlobalMemoryStatus(mem);

  try
    r_mem := ini.ReadInteger(name, 'req_mem', 0);
  except r_mem := 0; end;

  try
    r_freq := ini.ReadInteger(name, 'req_freq', 0);
  except r_freq := 0; end;

  if (r_mem = 0) and (r_freq = 0) then result := true else
  begin
    if r_mem = 0 then
    begin
      result := r_freq <= cpu_spd;
    end else
    begin
      if r_freq = 0 then result := (r_mem <= (mem.dwTotalPhys / 1048576)) else result := (r_mem <= (mem.dwTotalPhys / 1048576)) and (r_freq <= cpu_spd);
    end;
  end;
end;

end.

