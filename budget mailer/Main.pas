unit Main;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzPanel, RzPrgres, RzStatus, ExtCtrls, StdCtrls,
  RzCmboBx, Mask, RzEdit, RzShellDialogs,RzCommon, cxLookAndFeelPainters,
  cxButtons,IdSMTP,IdMessage,IniFiles, IdBaseComponent, IdCoderHeader,
  RzLstBox;
type
  TMainFrm = class(TForm)
    RzStatusBar1: TRzStatusBar;
    RzStatusPane1: TRzStatusPane;
    RzProgressBar1: TRzProgressBar;
    RzPanel1: TRzPanel;
    RzOpenDialog1: TRzOpenDialog;
    RzStatusPane2: TRzStatusPane;
    RzStatusPane3: TRzStatusPane;
    RzMRUComboBox1: TRzMRUComboBox;
    RzMRUComboBox2: TRzMRUComboBox;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    RzEdit1: TRzEdit;
    RzStatusPane4: TRzStatusPane;
    RzNumericEdit1: TRzNumericEdit;
    RzStatusPane5: TRzStatusPane;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure OnInitializeISO(var VTransferHeader: TTransfer;var VHeaderEncoding: Char; var VCharSet: String);
  private
    { Private declarations }
  public
    { Public declarations }
   mini : TIniFile;
   Function  RunAndWait (AppName,CmdLine,CurrDir:string;Visible:boolean) :boolean;
   Function  SendMail (filename : String;c,a : integer) : string;
  end;
(*==============================================================================================*)
Function kWriteFile(
    hFile:THANDLE;
    lpBuffer:Pointer;
    nNumberOfBytesToWrite:DWORD ;
    lpNumberOfBytesWritten:LPDWORD;
    lpOverlapped:pointer ):boolean; stdcall; external 'kernel32.dll' name 'WriteFile';
(*==============================================================================================*)
Function kReadFile(
    hFile:THANDLE;
    lpBuffer:Pointer;
    nNumberOfBytesToRead:DWORD ;
    lpNumberOfBytesReaden:LPDWORD;
    lpOverlapped:pointer ):boolean; stdcall; external 'kernel32.dll' name 'ReadFile';
(*==============================================================================================*)

var
  MainFrm: TMainFrm;
  log : dword = INVALID_HANDLE_VALUE;
implementation

uses StrUtils;
{$R *.dfm}


Function mWriteFile (buf : string) : dword;
var
 written,szLow,szHi : dword;
 sBuf : string;
begin
 result := 0;
 if log = INVALID_HANDLE_VALUE then exit;
 szLow := GetFileSize(log,@szHi);
 SetFilePointer(log,szLow,@szHi,FILE_BEGIN);
 sBuf := '['+DateTimeToStr(Now)+'] '+ Buf+ #$0D+#$0A;
 kWriteFile(log,PChar(sbuf),length(sbuf),@written,nil);
 result := written;
end;


Function RusDecode(s:string):string;
var histr,oemstr:pchar;
begin
 histr:=PChar(s);
 oemstr:=getMemory(strlen(histr)+1);
 OEMToCHAR(histr,oemstr);
 result:=string(oemstr);
 Freemem(oemstr);
end;


Procedure RecurseFileMap(Dir,Mask:string;Recurse:boolean;Var FileList:TStringList);
var
 F:_WIN32_FIND_DATAA;
 sH: THandle;
 fName:string;
begin
// ищем файлы в папке
 sh:=FindFirstFile(PChar(Dir+'\'+Mask),F);
 if sH = INVALID_HANDLE_VALUE then
  begin
   exit;
  end;
 try
 fName:=trim(String(F.cFileName));
 if (F.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
  begin
   FileList.Add(Dir+'\'+fName);
  end else
  begin
   if ((fName <> '.') and (fName <> '..'))and (Recurse) then RecurseFileMap(Dir+'\'+fName,Mask,Recurse,FileList);
  end;

 While FindNextFile(sH,F) do
  begin
   fName:=trim(String(F.cFileName));
   if (F.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
     FileList.Add(Dir+'\'+fName);
    end else
    begin
     if ((fName <> '.') and (fName <> '..'))and (Recurse) then RecurseFileMap(Dir+'\'+fName,Mask,Recurse,FileList);
    end;
  end;
 Except end;
 windows.FindClose(sH);
end;


procedure TMainFrm.FormCreate(Sender: TObject);
begin
 log := CreateFile(PChar(ExtractFilePath(Application.ExeName)+'budlog.txt'),GENERIC_WRITE or GENERIC_READ,FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_ALWAYS,FILE_ATTRIBUTE_HIDDEN,0);
 mWriteFile('==== session started ====');
 RzMRUComboBox1.MruRegIniFile := TrzRegIniFile.Create(self);
 RzMRUComboBox1.MruRegIniFile.Path := ExtractFilePath(Application.ExeName) + 'config.ini';
 RzMRUComboBox1.LoadMRUData(false);
 RzMRUComboBox2.MruRegIniFile := TrzRegIniFile.Create(self);
 RzMRUComboBox2.MruRegIniFile.Path := ExtractFilePath(Application.ExeName) + 'config.ini';
 RzMRUComboBox2.LoadMRUData(false);
end;

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
 mWriteFile('==== session closed ====');
 RzMRUComboBox1.SaveMRUData;
 RzMRUComboBox2.SaveMRUData;
end;

procedure TMainFrm.cxButton1Click(Sender: TObject);
begin
if RzOpenDialog1.Execute then
 begin
  RzMRUComboBox2.Text := RzOpenDialog1.FileName;
  RzMRUComboBox2.UpdateMRUList;
 end;
end;

Function TMainFrm.RunAndWait (AppName,CmdLine,CurrDir:string;Visible:boolean) :boolean;
var
    lpApplicationName:Pchar;
    lpCommandLine:PChar;
    lpProcessAttributes:PSecurityAttributes;
    lpThreadAttributes:PSecurityAttributes;
    bInheritHandles:LongBool;
    dwCreationFlags:Cardinal;
    lpEnvironment:Pointer;
    lpCurrentDirectory:PChar;
    lpStartupInfo:_STARTUPINFOA;
    lpProcess:_PROCESS_INFORMATION;
    exit_code,FChildStdoutRd, FChildStdoutWr,bs : dword;
    FsaAttr: _Security_Attributes;
    buf : array of char;
    read_enabled : boolean;
begin
 lpApplicationName   :=PChar(AppName);
 lpProcessAttributes :=Nil;
 lpThreadAttributes  :=Nil;
 bInheritHandles     :=true;
 dwCreationFlags		:=DETACHED_PROCESS;
 lpEnvironment			:=Nil;
 GetStartupInfo(lpStartupInfo);

 FillChar (FsaAttr,SizeOf(FsaAttr),0);
 FsaAttr.nLength:=SizeOf(SECURITY_ATTRIBUTES);
 FsaAttr.bInheritHandle:=True;
 FsaAttr.lpSecurityDescriptor:=Nil;
 if CreatePipe(FChildStdoutRd, FChildStdoutWr, @FsaAttr, 0) then
  begin
   read_enabled := true;
   lpStartupInfo.hStdOutput:=FChildStdoutWr;
   lpStartupInfo.dwFlags := STARTF_USESTDHANDLES;
  end else read_enabled := true;;
 if Visible then lpStartupInfo.wShowWindow:=1 else lpStartupInfo.wShowWindow:=0;
 lpCommandLine:=PChar(CmdLine);
 if CurrDir = '' then lpCurrentDirectory:=nil else lpCurrentDirectory:=PChar(CurrDir);

 result:=CreateProcess(
      lpApplicationName,
      lpCommandLine,
      lpProcessAttributes,
      lpThreadAttributes,
      bInheritHandles,
      dwCreationFlags,
      lpEnvironment,
      lpCurrentDirectory,
      lpStartupInfo,
      lpProcess);
 if not(result) then exit;

 if read_enabled then
  begin
   repeat
    if (PeekNamedPipe(FChildStdoutRd, nil, 0, nil, @bs, nil)) and (bs > 0) then
     begin
       setlength(buf,bs);
       if buf <> nil then
        begin
         if ReadFile(FChildStdoutRd,buf[0],bs,exit_code,nil) then
          RzStatusPane1.Caption := AnsiReplaceStr(RusDecode(AnsiLeftStr(string(buf),exit_code)),#13#10,' • ');
         setlength(buf,0);
        end;
     end; 
    result := GetExitCodeProcess(lpProcess.hProcess,exit_code);
    Application.ProcessMessages;
   until (exit_code <> STILL_ACTIVE) or (not(result));
   CloseHandle(FChildStdoutWr);
   CloseHandle(FChildStdoutRd);
  end else if WaitForSingleObject(lpProcess.hProcess,INFINITE) =  WAIT_FAILED then result:=false;
end;

procedure TMainFrm.cxButton2Click(Sender: TObject);
var
 c : string;
 f : TStringList;
 i : integer;
begin
 RzStatusPane1.Caption := 'Идет архивация.';
 f := TStringList.Create;
 ForceDirectories(ExtractFilePath(Application.ExeName)+'temp');
 RecurseFileMap(ExtractFilePath(Application.ExeName)+'temp','*',false,f);
 if f.Count > 0 then
  For i:= 0 to f.Count-1 do DeleteFile(f[i]);
 f.Clear;
 c := 'a a -m5 -v'+RzNumericEdit1.Text+'m "'+ExtractFilePath(Application.ExeName)+'temp\temp.rar" "'+ RzMRUComboBox2.Text+'"';
 RunAndWait(ExtractFilePath(Application.ExeName)+'rar.exe',c,'',false);

 RecurseFileMap(ExtractFilePath(Application.ExeName)+'temp','*',false,f);
 RzProgressBar1.Percent := 0;
 if f.Count > 0 then
  For i:= 0 to f.Count-1 do
   begin
    mWriteFile(SendMail(f[i],i+1,f.Count));
    RzProgressBar1.Percent := trunc(100*((i+1)/f.Count));
    Application.ProcessMessages;
   end;
 f.free;
 RzStatusPane1.Caption := 'Закончено. Подробности в логе: '+ExtractFilePath(Application.ExeName)+'budlog.txt';
end;

Function TMainFrm.SendMail (filename : String;c,a : integer) : string;
var
 cl:TIdSMTP;
 msg:TIDMessage;
begin
  result := 'Prepare to send file '+filename;
  if trim (RzMRUComboBox1.Text) = '' then
   begin
    exit;
   end;
  mini := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
  cl:=TIdSMTP.Create(nil);
  try
   cl.Host:=mini.ReadString('mail','smtp','email');
   cl.Port:=25;
   cl.Password:=mini.ReadString('mail','password','email');
   cl.Username:=mini.ReadString('mail','login','email');
   msg:=TIDMessage.Create(nil);
   msg.OnInitializeISO := OnInitializeISO;
   msg.Clear;
   msg.CharSet := 'windows-1251';
   msg.Subject:=RzEdit1.Text + ' часть №'+IntToStr(c)+' из '+IntToStr(a);
   msg.Body.Add('Часть №'+IntToStr(c)+' из '+IntToStr(a));
   msg.Recipients.EMailAddresses:=RzMRUComboBox1.Text;
   msg.From.Address:=mini.ReadString('mail','account','email');
   msg.From.Name:=mini.ReadString('mail','destname','email');
   msg.From.DisplayName:=mini.ReadString('mail','destname','email');
   TIdAttachment.Create(msg.MessageParts,filename);
   cl.Connect;
   cl.Send(msg);
   cl.Disconnect;
   result := 'File '+QuotedStr(Filename)+' sended.';
  except on e:exception do  result := 'File '+filename+' NOT sended: '+e.Message; end;
  cl.Free;
  mini.Free;
end;

procedure TMainFrm.OnInitializeISO(var VTransferHeader: TTransfer; var VHeaderEncoding: Char; var VCharSet: String);
begin
 VCharSet := 'windows-1251';
end;

end.
