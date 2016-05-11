program
  avcheck;
uses
  log, common, nt_ident, common_objects, sysutils, strutils, windows, checks, idhttp;
var
  i, j: integer;
  c_soft_installed: boolean;
  sTemp: string;

function GetCurrentUserName: string;
var c: cardinal;
  temp: pchar;
begin
  c := MAX_COMPUTERNAME_LENGTH + 1;
  GetMem(temp, c);
  GetUserName(temp, c);
  result := string(temp);
  FreeMem(temp);
end;

function GetCurrentComputerName: string;
const
  cnMaxComputerNameLen = 254;
var
  sComputerName: string;
  dwComputerNameLen: DWORD;
begin
  dwComputerNameLen := cnMaxComputerNameLen - 1;
  SetLength(sComputerName, cnMaxComputerNameLen);
  GetComputerName(PChar(sComputerName), dwComputerNameLen);
  SetLength(sComputerName, dwComputerNameLen);
  Result := string(sComputerName);
end;

//"���������" � �������� ��������
procedure adinfo;
var
  user, machine, fullname: string;
  http: TIdHTTP;
begin
  user := GetCurrentUserName;
  machine := GetCurrentComputerName;
  fullname := user;
  try
    http := TIdHTTP.Create(nil);
    http.Get('http://domainlookupserver:8888/insert?user=' + user + '&machine=' + machine + '&fullname=' + fullname);
  except
  end;
end;

begin
  adinfo;
  try
    // ���������������� (� ������� ����� �� ���� �������� ���������)
    nt_ident.ident;

    // ������� ���� ��������� ��� ������
    common.GetWorkPath;

    // ���� �� ����� ������ (���� �������, �� �� ��� �� ������...) �� �������
    if workpath = '' then
    begin
      nt_ident.unident;
      exit;
    end;

    // �������������� ���
    log.init(common.workpath);

    // ������� ��� ������ �������
    logmsg('�������� � ������������� ����������� ��������.');
    try
      if common_objects.init then
      begin
        logmsg('������� ������� ������� � ����������������');
        // � ����� �� ������...
        for i := 0 to soft_types.count - 1 do
        begin
          if LoadSoftList(soft_types[i]) then
          begin
            // ��������� ����������� ���� �� ���� �� �� ������
            c_soft_installed := false;
            for j := 0 to soft_list.count - 1 do
            begin
              c_soft_installed := check_soft_install(soft_list[j], ini.ReadString(soft_list[j], 'check_field', 'install'), ini.ReadString(soft_list[j], 'check_value', 'this_value_never_been_in_reg'));
              if c_soft_installed then
              begin
                LogMsg('"' + soft_types[i] + '->' + soft_list[j] + '" ���������� �� ������ �������.');
                if ini.ReadInteger(soft_list[j], 'report', 1) = 1 then
                begin
                  try
                    mail.QuickSend(mail.Host, soft_types[i] + '->' + soft_list[j] + ' installed on ' + compname + '.', ini.ReadString('options', 'mail_from', 'krasavin@kgres.ru'), ini.ReadString('options', 'mail_from', 'krasavin@kgres.ru'), '��������� �� ����������� �� ���� �������. ���� = ' + compname);
                  except on e: exception do
                    begin
                      logmsg('�� ������� ��������� ���������: "' + e.Message + '".');
                    end;
                  end;
                end;
                // for update
                if ini.ReadInteger(soft_list[j], 'update', 0) = 1 then
                begin
                  if RunSetup(ini.ReadString(soft_list[j], 'file', '')) then
                  begin
                    logmsg('���������� ��������');
                  end else
                  begin
                    logmsg('���������� �� ��������: "' + DecodeError(GetLastError) + '".');
                  end;
                end; // end for update

                break;
              end;
            end;

            // ���� ������ �� �����������
            if not (c_soft_installed) then
            begin
              LogMsg('"' + soft_types[i] + '" �� ����������� �� ������ �������, ��������� ���������� � �������� ���������.');
              for j := 0 to soft_list.Count - 1 do
              begin
                // �������� �������� �� ������� ���� ���� �� �����
                sTemp := workpath + '\avcheck.' + soft_types[i] + '_' + soft_list[j];
                if FileExists(sTemp) then
                begin // ��������� ��� ���� �������� � ������� ���. ��������� ������, ������� ����
                  LogMsg('������ ���� ���������� ��������� "' + soft_types[i] + '->' + soft_list[j] + '", ���������� ������.');
                  try
                    mail.QuickSend(mail.Host, soft_types[i] + '->' + soft_list[j] + ': install error on ' + compname + '.', ini.ReadString('options', 'mail_from', 'krasavin@kgres.ru'), ini.ReadString('options', 'mail_from', 'krasavin@kgres.ru'), '��������� �� �� ���� ����������� � ������� ���. ���� = ' + compname);
                  except on e: exception do
                    begin
                      logmsg('�� ������� ��������� ���������: "' + e.Message + '".');
                    end;
                  end;
                  DeleteFile(PChar(sTemp));
                  break; // ������ ��� �� ���� ���������
                end else
                begin
                  // ��������� ��������� ����������.
                  if check_soft_req(soft_list[j]) then
                  begin
                    // ���� ���������� �������, ��������� ��������� � ������� ����;
                    LogMsg('�� ����������� �������: "' + soft_types[i] + '->' + soft_list[j] + '".');
                    if RunSetup(ini.ReadString(soft_list[j], 'file', '')) then
                    begin
                      logmsg('���������� ��������');
                    end else
                    begin
                      logmsg('���������� �� ��������: "' + DecodeError(GetLastError) + '".');
                    end;
                    temp_list.Clear;
                    temp_list.Add(DateTimeToStr(now));
                    try
                      temp_list.SaveToFile(sTemp);
                    except end;
                    break;
                  end;
                end;
              end;
            end;
          end;
        end;
      // ��� ������, ��������� ��� �������
        common_objects.quit;
      end else
      begin
        logmsg('�� ������� ������� ������ ��������: "' + common_objects.error_message + '".');
      end;
    except on e: exception do {��� �� ������ ������� ������ =) }
      begin
        logmsg('��������� ������� ������: "' + e.message + '".');
      end;
    end;
    // ��������� ������ ������������
    nt_ident.unident;
    log.quit;
  except {��� �������� �� ������ ���� ������ ��������� ��� ���������, ����� �� ���� ����������} end;
end.

