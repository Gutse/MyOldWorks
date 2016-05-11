unit
  log;

interface

uses classes, windows, sysutils;

var
  logfile: TFileStream;

procedure init(path: string);
procedure logmsg(msg: string);
procedure quit;
implementation

uses StrUtils;

procedure init(path: string);
begin
  path := path + '\avcheck.log';
  DeleteFile(PChar(path));
  CloseHandle(CreateFile(PChar(path), 0, 0, nil, CREATE_NEW, 0, 0));
  try
    logfile := TFileStream.Create(path, $0002);
  except logfile := nil; end;
end;

procedure logmsg(msg: string);
begin
  if logfile = nil then exit;
  msg := AnsiReplaceStr(msg,#13,'');
  msg := AnsiReplaceStr(msg,#10,'');
  msg := '[' + DateTimeToStr(Now) + '] ' + msg + #13#10;
  try
    logfile.Seek(0, soFromEnd);
    logfile.WriteBuffer(msg[1], length(msg));
  except end;
end;

procedure quit;
begin
  if logfile = nil then exit;
  try
    FreeAndNil(logfile);
  except end;
end;

end.

