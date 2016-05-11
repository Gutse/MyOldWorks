program AppRestart;
uses SysUtils, Windows, Classes, IniFiles, WinSvc, advApiHook;
var
  f: TFileStream;
  ini: TIniFile;
  ExeName, SrvName: string;
  s_mgr, srv, waittime: dword;
  srv_status: TServiceStatus;
  pvars: PChar;

procedure log(buf: string);
begin
  if f <> nil then
  begin
    buf := '[' + DateTimeToStr(Now) + ']: ' + buf + #$0A#$0D;
    f.WriteBuffer(buf[1], length(buf));
  end;
end;

function sGetLastError: string;
var
  err: dword;
  buf: pchar;
begin
  err := GetLastError;
  FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_ALLOCATE_BUFFER, nil, err, 0, @buf, 0, nil);
  result := string(buf);
  LocalFree(cardinal(buf));
end;

procedure CheckAndKillProcess;
var
  pid: dword;
begin
  log('killing process (if exists)');
  pid := GetProcessId(PChar(ExtractFileName(ExeName)));
  log('pid = ' + IntToStr(pid));
  if not (DebugKillProcess(pid)) then log('error killing process: ' + sGetLastError);
end;

begin
  try
    DeleteFile(PChar(ExtractFilePath(ParamStr(0)) + 'restart.log'));
    f := TFileStream.Create(ExtractFilePath(ParamStr(0)) + 'restart.log', fmCreate);
    FreeAndNil(f);
    f := TFileStream.Create(ExtractFilePath(ParamStr(0)) + 'restart.log', fmOpenReadWrite or fmShareDenyWrite);
  except f := nil;
  end;

  try
    ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'restart.cfg');
  except on e: exception do
    begin
      log('ini file not opened: ' + e.Message + '. Exiting;');
      f.Free;
      exit;
    end;
  end;
  ExeName := ini.ReadString('main', 'ExeName', '');
  SrvName := ini.ReadString('main', 'SrvName', '');
  waittime := ini.ReadInteger('main', 'waitforgracefulstop', 2) * 60000;
  ini.Free;
  pvars := nil;

  s_mgr := OpenSCManager('', SERVICES_ACTIVE_DATABASE, SC_MANAGER_ALL_ACCESS);
  if s_mgr = 0 then
  begin
    log('s_mgr = 0: ' + sGetLastError);
    f.Free;
    exit;
  end;
  log('SC_MANAGER OK');
  srv := OpenService(s_mgr, PChar(SrvName), SERVICE_QUERY_STATUS or SERVICE_STOP or SERVICE_START);
  if srv = 0 then
  begin
    log('srv = 0: ' + sGetLastError);
    f.Free;
    exit;
  end;
  log('SRV OK');


  // теперь попробуем сначала остановить службу по нормальному. через SCM
  if not (QueryServiceStatus(srv, srv_status)) then
  begin
    log('QueryServiceStatus = 0: ' + sGetLastError);
  end else
  begin
    if srv_status.dwCurrentState <> SERVICE_STOPPED then
    begin
      log('srv_status.dwCurrentState <> SERVICE_STOPPED, trying to stop');
      if ControlService(srv, SERVICE_CONTROL_STOP, srv_status) then
      begin
        sleep(waittime);
        QueryServiceStatus(srv, srv_status);
        if srv_status.dwCurrentState <> SERVICE_STOPPED then log('service was not stopped after waittime')
        else log('service was stopped after waittime')
      end else
      begin
        log('service not stoped: ' + sGetLastError);
      end;
    end else
    begin
      log('Service was stopped at the time of launch');
    end;
  end;
  CheckAndKillProcess;
  sleep(10000);
  log('starting service...');
  if not StartService(srv, 0, pVars) then log('service not started: ' + sGetLastError) else log('service was started');
  f.Free;
end.

