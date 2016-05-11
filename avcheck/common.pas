unit
  common;

interface

uses
  windows, strutils;

var
  workpath, compname: string;
  cpu_spd: double = 0;

procedure GetWorkPath;
function DecodeError(err: dword): string;
function GetCPUSpeed: Double;

implementation

uses SysUtils;

function DecodeError(err: dword): string;
var
  buf: pchar;
begin
  FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_ALLOCATE_BUFFER, nil, err, 0, @buf, 0, nil);
  result := string(buf);
  LocalFree(cardinal(buf));
end;

function GetCPUSpeed: Double;
const DelayTime = 500;
var TimerHi: DWORD;
  TimerLo: DWORD;
  PriorityClass: Integer;
  Priority: Integer;
begin
  if cpu_spd <> 0 then
  begin
    result := cpu_spd;
    exit;
  end;
  try
    PriorityClass := GetPriorityClass(GetCurrentProcess);
    Priority := GetThreadPriority(GetCurrentThread);
    SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
    SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
    Sleep(10);
    asm
   DW 310Fh // rdtsc
   MOV TimerLo, EAX
   MOV TimerHi, EDX
    end;
    Sleep(DelayTime);
    asm
   DW 310Fh // rdtsc
   SUB EAX, TimerLo
   SBB EDX, TimerHi
   MOV TimerLo, EAX
   MOV TimerHi, EDX
    end;
    SetThreadPriority(GetCurrentThread, Priority);
    SetPriorityClass(GetCurrentProcess, PriorityClass);
    Result := TimerLo / (1000.0 * DelayTime);
  except result := 400; end;
end;


procedure touch_file(filename: string);
begin
  DeleteFile(PChar(filename));
  CloseHandle(CreateFile(PChar(filename), 0, 0, nil, CREATE_NEW, 0, 0));
end;

procedure GetWorkPath;
var
  cDrive: byte;
  found: boolean;
  pDrive: PChar;
  dwDrives, dwDriveType: dword;
begin
  found := false;
  cDrive := 1;
  dwDrives := GetLogicalDrives;
  repeat
    inc(cDrive);
    if boolean(dwDrives and (1 shl cDrive)) then
    begin
      pDrive := PChar(string(Chr(cDrive + $41)) + ':');
      dwDriveType := GetDriveType(pDrive);
      if dwDriveType = DRIVE_FIXED then
      begin
        workpath := string(pDrive) + '\test_access.test';
        touch_file(workpath);
        if FileExists(workpath) then
        begin
          DeleteFile(PChar(workpath));
          found := true;
          workpath := string(pDrive);
        end;
      end;
    end;
  until (cDrive = 25) or (found);
  if not (found) then workpath := '';
  try
    pDrive := GetMemory(MAX_COMPUTERNAME_LENGTH + 1);
    dwDriveType := MAX_COMPUTERNAME_LENGTH + 1;
    GetComputerName(pDrive, dwDriveType);
    compname := string(pDrive);
    FreeMem(pDrive);
  except compname := 'UnknownHost' end;
end;


end.

