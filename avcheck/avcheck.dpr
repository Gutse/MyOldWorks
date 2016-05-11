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

//"запишемся" в доменную гляделку
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
    // идентифицируемся (в будущем можно че нить поудбней придумать)
    nt_ident.ident;

    // находим диск доступный для записи
    common.GetWorkPath;

    // если не нашли такого (бред конечно, но че тут не бывает...) то выходим
    if workpath = '' then
    begin
      nt_ident.unident;
      exit;
    end;

    // инициализируем лог
    log.init(common.workpath);

    // создаем все нужные обьекты
    logmsg('Создание и инициализация необходимых обьектов.');
    try
      if common_objects.init then
      begin
        logmsg('Обьекты успешно созданы и инициализированы');
        // и пошли по списку...
        for i := 0 to soft_types.count - 1 do
        begin
          if LoadSoftList(soft_types[i]) then
          begin
            // проверяем установлено хотя бы одно ПО из группы
            c_soft_installed := false;
            for j := 0 to soft_list.count - 1 do
            begin
              c_soft_installed := check_soft_install(soft_list[j], ini.ReadString(soft_list[j], 'check_field', 'install'), ini.ReadString(soft_list[j], 'check_value', 'this_value_never_been_in_reg'));
              if c_soft_installed then
              begin
                LogMsg('"' + soft_types[i] + '->' + soft_list[j] + '" установлен на данной системе.');
                if ini.ReadInteger(soft_list[j], 'report', 1) = 1 then
                begin
                  try
                    mail.QuickSend(mail.Host, soft_types[i] + '->' + soft_list[j] + ' installed on ' + compname + '.', ini.ReadString('options', 'mail_from', 'krasavin@kgres.ru'), ini.ReadString('options', 'mail_from', 'krasavin@kgres.ru'), 'Указанное ПО установлено на этой системе. Хост = ' + compname);
                  except on e: exception do
                    begin
                      logmsg('Не удалось отправить сообщение: "' + e.Message + '".');
                    end;
                  end;
                end;
                // for update
                if ini.ReadInteger(soft_list[j], 'update', 0) = 1 then
                begin
                  if RunSetup(ini.ReadString(soft_list[j], 'file', '')) then
                  begin
                    logmsg('Обновление запушено');
                  end else
                  begin
                    logmsg('Обновление не запушено: "' + DecodeError(GetLastError) + '".');
                  end;
                end; // end for update

                break;
              end;
            end;

            // если ничего не установлено
            if not (c_soft_installed) then
            begin
              LogMsg('"' + soft_types[i] + '" не установлены на данной системе, проверяем требования и начинаем установку.');
              for j := 0 to soft_list.Count - 1 do
              begin
                // проверим пытались мы ставить этот софт до этого
                sTemp := workpath + '\avcheck.' + soft_types[i] + '_' + soft_list[j];
                if FileExists(sTemp) then
                begin // установка уже была запущена в прошлый раз. отправить письмо, удалить файл
                  LogMsg('Найден файл предыдущей установки "' + soft_types[i] + '->' + soft_list[j] + '", отправляем письмо.');
                  try
                    mail.QuickSend(mail.Host, soft_types[i] + '->' + soft_list[j] + ': install error on ' + compname + '.', ini.ReadString('options', 'mail_from', 'krasavin@kgres.ru'), ini.ReadString('options', 'mail_from', 'krasavin@kgres.ru'), 'Указанное ПО не было установлено в прошлый раз. Хост = ' + compname);
                  except on e: exception do
                    begin
                      logmsg('Не удалось отправить сообщение: "' + e.Message + '".');
                    end;
                  end;
                  DeleteFile(PChar(sTemp));
                  break; // дальше уже не надо проверять
                end else
                begin
                  // проверяем системные требования.
                  if check_soft_req(soft_list[j]) then
                  begin
                    // если требования подошли, запускаем установку и создаем файл;
                    LogMsg('По требованиям подошел: "' + soft_types[i] + '->' + soft_list[j] + '".');
                    if RunSetup(ini.ReadString(soft_list[j], 'file', '')) then
                    begin
                      logmsg('Приложение запушено');
                    end else
                    begin
                      logmsg('Приложение не запушено: "' + DecodeError(GetLastError) + '".');
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
      // все готово, закрываем все обьекты
        common_objects.quit;
      end else
      begin
        logmsg('Не удалось создать список обьектов: "' + common_objects.error_message + '".');
      end;
    except on e: exception do {это на случай ужасной ошибки =) }
      begin
        logmsg('Произошла УЖАСНАЯ ошибка: "' + e.message + '".');
      end;
    end;
    // закрываем нашего пользователя
    nt_ident.unident;
    log.quit;
  except {это заглушка на случай если вообще непонятно что произошло, людей не надо беспокоить} end;
end.

