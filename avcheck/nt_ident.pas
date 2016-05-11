unit
  nt_ident;
interface
uses
  windows;
const
  user = 'your_username';
  domain = 'your_domain';
  pwd = 'password';
var
  usr: dword = 0;
  logged: boolean = false;

procedure ident;
procedure unident;
function RunSetup(app: string): boolean;
{$IFDEF WIN32}
{$HPPEMIT '#define _WIN32_WINNT 0x0500'}
function CreateProcessWithLogonW(lpUsername: LPCWSTR;
  lpDomain: LPCWSTR;
  lpPassword: LPCWSTR;
  dwLogonFlags: DWORD;
  lpApplicationName: LPCWSTR;
  lpCommandLine: LPWSTR;
  dwCreationFlags: DWORD;
  lpEnvironment: pointer;
  lpCurrentDirectory: LPCWSTR;
  lpStartupInfo: PStartupInfo;
  lpProcessInf: PProcessInformation): longbool; stdcall; external 'advapi32.dll' name 'CreateProcessWithLogonW';
{$ENDIF}

implementation

procedure ident;
begin
{$IFDEF WIN32}
  logged := LogonUser(PChar(user), PChar(domain), PChar(pwd), LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT, usr);
  if logged then logged := ImpersonateLoggedOnUser(usr);
{$ENDIF}
end;

procedure unident;
begin
{$IFDEF WIN32}
  if logged then RevertToSelf;
{$ENDIF}
end;



function RunSetup(app: string): boolean;
{$IFDEF WIN32}
var
  lpUsername: LPCWSTR;
  lpDomain: LPCWSTR;
  lpPassword: LPCWSTR;
  dwLogonFlags: DWORD;
  lpApplicationName: LPCWSTR;
  lpCommandLine: LPWSTR;
  dwCreationFlags: DWORD;
  lpEnvironment: pointer;
  lpCurrentDirectory: LPCWSTR;
  lpStartupInfo: _STARTUPINFOA;
  lpProcessInfo: PProcessInformation;
{$ENDIF}
begin
  unident;
{$IFDEF WIN32}

  lpUsername := GetMemory((length(user) + 1) * 2);
  StringToWideChar(user, lpUsername, (length(user) + 1) * 2);

  lpDomain := GetMemory((length(domain) + 1) * 2);
  StringToWideChar(domain, lpDomain, (length(domain) + 1) * 2);

  lpPassword := GetMemory((length(pwd) + 1) * 2);
  StringToWideChar(pwd, lpPassword, (length(pwd) + 1) * 2);

  lpApplicationName := nil;
  lpCommandLine := GetMemory((length(app) + 1) * 2);
  StringToWideChar(app, lpCommandLine, (length(app) + 1) * 2);

  dwLogonFlags := 0;
  dwCreationFlags := CREATE_DEFAULT_ERROR_MODE;
  lpEnvironment := nil;
  lpCurrentDirectory := nil;

  GetStartupInfoW(lpStartupInfo);

  lpStartupInfo.lpDesktop := nil;

  lpProcessInfo := GetMemory(SizeOf(_PROCESS_INFORMATION));
  result := CreateProcessWithLogonW(
    lpUsername,
    lpDomain,
    lpPassword,
    dwLogonFlags,
    lpApplicationName,
    lpCommandLine,
    dwCreationFlags,
    lpEnvironment,
    lpCurrentDirectory,
    @lpStartupInfo,
    lpProcessInfo);
{$ELSE}
  result := WinExec(PChar(app), SW_HIDE);
{$ENDIF}
  ident;
end;

end.

