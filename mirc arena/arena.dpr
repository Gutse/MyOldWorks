library arena;
uses
  SysUtils,windows,classes,StrUtils,inifiles,ComObj,Variants,Dialogs;
type
 TSpell = class(TObject)
 public
  index  : string;
  name   : string;
  mana   : integer;
  mtype  : byte;
  effect : real;
 end;

 TPlayer = class(TObject)
 public
  name  : string [100];
  index : integer;
  proff : byte; // 0 - ����; 1 - ������; 2 - ���; 3 - ����;
  level : byte;
  team  : integer;
  hp    : integer;
  tk    : integer;
 end;

 PMircInfo = ^TMircInfo;
 TMircInfo = packed record
   mVersion : DWORD;
   mHwnd 	: DWORD;
   mKeep		: boolean;
 end;
 
var
 MaxDataLen :integer = 900;
 MaxParmLen :integer = 900;

 inf   	  : TMircInfo;
 mKeep 	  : boolean = true;
 CanUnload : integer = 0;

 ordered   : boolean = false;
 SpellList,Friends : TStringList;
 inited    : boolean = false;

 SelfNick     : string = 'DESt';
 SelfMana     : real = 10;
 SelfMRegen   : real = 5;
 SelfPlayType : byte = 1;
 botname      : string = 'arena';

 CurrentMana  : real = 10;
 CurrentHp    : integer = 10;

 log 			  : dword;

Function kWriteFile(
    hFile:THANDLE;
    lpBuffer:Pointer;
    nNumberOfBytesToWrite:DWORD ;
    lpNumberOfBytesWritten:LPDWORD;
    lpOverlapped:pointer ):boolean; stdcall; external 'kernel32.dll' name 'WriteFile';
Function kReadFile(
    hFile:THANDLE;
    lpBuffer:Pointer;
    nNumberOfBytesToRead:DWORD ;
    lpNumberOfBytesReaden:LPDWORD;
    lpOverlapped:pointer ):boolean; stdcall; external 'kernel32.dll' name 'ReadFile';

Function aMin (a,b:integer):integer;
begin
 if a > b then result := b else result := a;
end;

Function FillCmd (data,params,cmd,line : pchar) : integer;
begin
 try
  ZeroMemory(data,  MaxDataLen);
  ZeroMemory(params,MaxParmLen);
  CopyMemory(data  ,cmd ,aMin(strlen(cmd),MaxDataLen));
  CopyMemory(params,line,aMin(strlen(line),MaxParmLen));
  result := 2;
 except result := 0; end; 
end;

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


procedure LoadDll (info : PMircInfo); stdcall;
begin
 Copymemory (@inf,info,sizeof(inf));
 info.mKeep := mKeep;
end;

function UnloadDll(mTimeOut : integer):integer;stdcall;
begin
 if CanUnload = 1 then CloseHandle(log);
 result := CanUnload;
end;

(*-= user functions =-*)
function Init (mWnd,aWnd:dword;data:pchar;params : pchar;show,nopause:boolean) : integer; stdcall;
var
 magfile,inifile,path,friend  : string;
 ExMag,MagBook,MagData : OleVariant;
 i 						  : integer;
 NewSpell 				  : TSpell;
 ini						  : TIniFile;
 sline    				  : string;
begin
 // ���� ���������� ��� ���������������� �� �������
 if inited then
  begin
   result := FillCmd(data,params,PChar('/notice '+SelfNick+ ' $1-'),PChar('���������� ��� ����������������!'));
   exit;
  end;

 inited := false;

 // getting filnames with options
 ordered := false;
 path := trim(string(data));
 if path[length(path)] = '\' then
  begin
   magfile :=  path + 'mag.xls';
   inifile :=  path + 'arena.ini';
   DeleteFile(PChar(path+'arenalog.log'));
   log := CreateFile(PChar(path+'arenalog.log'),GENERIC_WRITE or GENERIC_READ,FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_ALWAYS,FILE_ATTRIBUTE_HIDDEN,0);
  end else
  begin
   magfile :=  path + '\mag.xls';
   inifile :=  path + '\arena.ini';
   DeleteFile(PChar(path+'\arenalog.log'));
   log := CreateFile(PChar(path+'\arenalog.log'),GENERIC_WRITE or GENERIC_READ,FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_ALWAYS,FILE_ATTRIBUTE_HIDDEN,0);
  end;

 if (not(FileExists(magfile))) or (not(FileExists(inifile))) then
  begin
   result := FillCmd(data,params,PChar('/notice '+SelfNick+ ' $1-'),PChar('���� � ������������ ��� ���� �������� �� �������.'));
   CloseHandle(log);
   exit;
  end;

  // opening and fill maglist
 try
  ExMag := CreateOleObject('Excel.Application');
 except on e:exception do
  begin
   result := FillCmd(data,params,PChar('/notice '+SelfNick+ ' $1-'),PChar('�� ������� ������� ������ Excel.Application: '+e.message +' ����������� /dll -u ��� �������� � ��������� �����.'));
   CloseHandle(log);
   exit;
  end;
 end;

 try
  ExMag.EnableEvents := false;
  ExMag.visible      := false;
  MagBook 				:= ExMag.Workbooks.Open(magfile);
  MagData 				:= MagBook.sheets[1].range['A2:F100'].value;
 except on e: exception do
  begin
   result := FillCmd(data,params,PChar('/notice '+SelfNick+ ' $1-'),PChar('�� ������� ��������� ������ ����������: '+e.message +' ����������� /dll -u ��� �������� � ��������� �����.'));
   CloseHandle(log);
   ExMag.quit;
   ExMag := UnAssigned;
   exit;
  end;
 end;

 i := 1;
 SpellList := TStringList.Create;
 while trim(MagData[i,1]) <> '' do
  begin
   if trim(MagData[i,6]) = '1' then
    begin
     try
      NewSpell 		 := TSpell.Create;
      NewSpell.index  := trim(MagData[i,1]);
      NewSpell.name   := trim(MagData[i,2]);
      NewSpell.mana   := MagData[i,3];
      NewSpell.mtype  := MagData[i,4];
      NewSpell.effect := MagData[i,5];
      SpellList.AddObject(NewSpell.name, NewSpell);
     except FreeAndNil(NewSpell); end;
    end;
   inc(i);
  end;

 ExMag.quit;
 ExMag := UnAssigned;

 ini := TIniFile.Create(inifile);
 SelfNick     := AnsiLowerCase(ini.ReadString('main','nick','DESt'));
 SelfMana     := ini.ReadFloat('main','mana',10);
 SelfMRegen   := ini.ReadFloat('main','mregen',3);
 SelfPlayType := ini.ReadInteger('main','playtype',1);
 botname      := ini.ReadString('main','botname','arena');
 CurrentMana  := SelfMana;

 MaxDataLen   := ini.ReadInteger('config','MaxDataLen',900);
 MaxParmLen   := ini.ReadInteger('config','MaxParmLen',900);

 i := 1;
 Friends := TStringList.Create;
 Friends.Add('Dia'); // � ���� ����� ��� ���???
 repeat
  friend := ini.ReadString('friends','friend'+IntToStr(i),'$$$');
  if friend <> '$$$' then Friends.Add(AnsiLowerCase(friend)) else break;
  inc(i);
 until friend = '$$$';

 FreeAndNil(ini);

 inited    := true;
 sline := '���������: ���� ��� = '+SelfNick+', ���� = '+FloatToStr(SelfMana)+', ����� ���� = ' + FloatToStr(SelfMRegen) + ', ����� ���� = ' + IntToStr(SelfPlayType)+'; ���������� : ';
 if SpellList.Count > 0 then
  begin
   For i := 0 to SpellList.Count-2 do
    sline := sline + SpellList[i]+'('+FloatToStr(TSPell(SpellList.Objects[i]).effect)+')'+', ';
   sline := sline + SpellList[SpellList.Count-1]+'('+FloatToStr(TSPell(SpellList.Objects[SpellList.Count-1]).effect)+')'+'; Thats all;';
  end else
  begin
   sline := sline + '�� �������� �� ���� ����������!';
  end;
 mWriteFile(sLine);
 result := FillCmd(data,params,PChar('/notice '+SelfNick+ ' $1-'),PChar(sline));
end;

function NewFight (mWnd,aWnd:dword;data:pchar;params : pchar;show,nopause:boolean) : integer; stdcall;
begin
 result  := 1;
 if not(Inited) then exit;
 CurrentMana := SelfMana;
 mWriteFile('������ ������ ���, ������� �������� ���� ����������� � '+FloatToStr(CurrentMana));
end;

function ParseList(players : TStringList; list : string): boolean ;
var
 p1,p2,team_index,i : integer;
 lteam,rem,t1 : string;
 NewPlayer : TPlayer;
begin
 rem := list;
 try
 result := false;
 p1  := AnsiPos('[',rem);
 p2  := AnsiPos(']',rem);
 if (p1 = 0) or (p2 = 0) or (p1 >= p2)then exit;

 lteam := AnsiMidStr(rem,p1+1,p2-p1-1);
 rem   := AnsiRightStr(rem,length(rem)-p2);
 team_index := 1;
 while lteam <> '' do
  begin
   repeat
    NewPlayer := TPlayer.Create;
    p1 := AnsiPos('.',lteam);
    p2 := AnsiPos('|',lteam);
    NewPlayer.name := AnsiMidStr(lteam,p1+1,p2-p1-1);
    NewPlayer.team := team_index;
    t1 := '';
    For i := p1-1 downto 1 do
     begin
      if lteam[i] in ['0'..'9'] then t1 := lteam[i]+t1 else break;
     end;
    try
     NewPlayer.index := StrToInt(t1);
    except NewPlayer.index := 1; end;
    t1 := '';
    For i := p2+1 to length(lteam) do
     begin
      if lteam[i] in ['0'..'9'] then break else t1 := t1 + lteam[i];
     end;
    if length(t1) > 1 then
     begin
      NewPlayer.tk := 10;
      case t1[2] of
       'w' : NewPlayer.proff := 0;
       'l' : NewPlayer.proff := 1;
       'm' : NewPlayer.proff := 2;
       'p' : NewPlayer.proff := 3;
      end;
     end else
     begin
      NewPlayer.tk := 0;
      case t1[1] of
       'w' : NewPlayer.proff := 0;
       'l' : NewPlayer.proff := 1;
       'm' : NewPlayer.proff := 2;
       'p' : NewPlayer.proff := 3;
      end;
     end;
    lteam := AnsiRightStr(lteam, length(lteam) - (p2 + length(t1)));
    t1    := '';
    For i:= 1 to length(lteam) do
     begin
       if lteam[i] in ['0'..'9'] then t1 := lteam[i]+t1 else break;
     end;
    try
     NewPlayer.level := StrToInt(t1);
    except NewPlayer.level := 1; end;
    t1 := '';
    For i:= 3 to length(lteam) do
     begin
       if lteam[i] in ['0'..'9'] then t1 := t1+lteam[i] else break;
     end;
    try
     NewPlayer.hp := StrToInt(t1);
    except NewPlayer.hp := 1; end;
    lteam := trim(AnsiRightStr(lteam,length(lteam)-length(t1)-3));

    players.AddObject(AnsiLowerCase(NewPlayer.name),NewPLayer);
    if lteam = '' then break;
   until false;

   p1  := AnsiPos('[',rem);
   p2  := AnsiPos(']',rem);
   lteam := AnsiMidStr(rem,p1+1,p2-p1-1);
   rem   := AnsiRightStr(rem,length(rem)-p2);
   inc(team_index);
  end;
 result := true;
 except result := false; end;
 if players.Count = 0 then result := false;
end;

function Choice (players : TStringList; var order : string) : boolean;
var
 i,j,self_index : integer;
 self_team : integer;
 cPlayer : TPlayer;
 wanted_spelltype : set of byte;
 sSpell,cSpell : TSpell;
begin
 // TK - To Kill =) ��� �� ������ ��� ���� �� �������� �����
 // ��������� ������� TK, �� ��� ��������������� � ������� ������, ��� �������� +10 � �� )
 // ������ ������ ���� �������
 self_team := 1; // ��� �� ���������� �� �������. � ��� ��� �� ����� ���� �� �������, ��� �� � ���� 100%
// self_index:= 1;
 CurrentHp := 1;
 For i := 0 to players.Count -1 do
  begin
   cPlayer := TPLayer(players.objects[i]);
   if players[i] = SelfNick then
    begin
     self_team  := cPlayer.team;
     cPlayer.tk := 666; // � ����� ���� �
     self_index := cPlayer.index;
     CurrentHp  := cPlayer.hp;
     mWriteFile('Found self: index = '+IntToStr(self_index)+'; hp = '+IntToStr(CurrentHp)+'; Mana = '+FloatToStr(CurrentMana));
    end;
   if Friends.IndexOf(cPlayer.name) <> -1 then cPlayer.tk := cPlayer.tk+15; // ������ �� �������� =)
   if cPlayer.level < 5 then cPlayer.tk := cPlayer.tk + 10; 		 // ����� ��������� �� ���� �� ��� ��... =)
   cPlayer.tk := cPlayer.tk +			 // �� ����� �� �� ��� ���������
   cPlayer.level+ 						// ��� ���� ������� ��� ����
   2*trunc(abs(cPlayer.hp - 13)/13) // ���� ���� �� �� �������� ���� ������� �������� ��� �����
   + cPlayer.proff; // ���� �������� �������� ������� �� �� �������� ����
  end;
 // ����� ��� �� �������! � ����� � ���� � �������
 For i := 0 to players.Count -1 do
  begin
   cPlayer := TPLayer(players.objects[i]);
   if cPlayer.team = self_team then cPlayer.tk := 666; // ���� ���� ����� ����� =)
   if cPlayer.proff = 3 then
    begin
     For j := 0 to players.Count -1 do
      if TPlayer(players.objects[j]).team = cPLayer.team then TPlayer(players.objects[j]).tk := TPlayer(players.objects[j]).tk + cPlayer.level;
    end;
  end;
 // �� �� ��� ������ �? =)
 // �������� ����
 case SelfPlayType of
  0 : wanted_spelltype := [0];
  1 : wanted_spelltype := [1,2];
 end;
 if CurrentHp <= 3 then wanted_spelltype := [1,2];
 if wanted_spelltype = [0] then mWriteFile('��������� ��� �����: ���������') else mWriteFile('��������� ��� �����: ��������'); 
 sSpell := nil;
 For i := 0 to SpellList.Count-1 do
  begin
   cSpell := TSpell(SpellList.objects[i]);
   if cSpell.mtype in wanted_spelltype then
    if (sSpell = nil) and (cSpell.mana <= CurrentMana) then sSpell := cSpell else
     begin
      if (cSpell.mana <= CurrentMana) and (cSpell.effect > sSPell.effect) then sSpell := cSpell;
     end;
   if sSpell <> nil then mWriteFile('������� �����: '+sSpell.name) else mWriteFile('������� �����: �� �������');
  end;
{ if sSpell = nil then // �� ���� �� ���� �� �����, �� ��������� ������ ���������� �� ����
  For i:= 0 to SpellList.Count-1 do
   begin
    cSpell := TSpell(SpellList.objects[i]);
    if cSpell.mana <= CurrentMana then sSpell := cSpell;
    if cSpell.mana <= CurrentMana then break;
   end;} // ��� ���� �� ������ ��� ������ ������� ��� ������ �� ���� ��������� ����.

 if sSpell <> nil then
  begin
   // �� ���� ���� ������� ������ =)
   if wanted_spelltype = [1,2] then order := '!do m '+SelfNick+' 100 '+sSpell.index  else // �� ��� ��� ������ ...
    begin
     cPlayer := TPlayer(players.Objects[1]);
     For i := 0 to players.Count -1 do
      begin
       if TPlayer(players.Objects[i]).tk <= cPlayer.tk then cPlayer := TPlayer(players.Objects[i]);
      end;
     order := '!do m '+ IntToStr(cPlayer.index) +' 100 '+sSpell.index;
    end;
   CurrentMana := CurrentMana - sSpell.mana;
  end else
   begin
    order := '!do n'; // ����� ������ ���� ...
    mWriteFile('����������� ���������� �� �������, !do n'); 
    CurrentMana := CurrentMana + SelfMRegen;
   end;
 result := true;
end;

function ParseSimpleText(value: string; var scmd,sline : string) : byte;
begin

 if AnsiContainsText(value,'������') and AnsiContainsText(value,'���������� �����������')then
  begin
   CurrentMana := 10;
  end;

 if AnsiContainsText(value,'������ ������ N') then
  begin
   ordered := false;
  end;

 if AnsiContainsText(value,'[1.') then
  begin
   if not(ordered) then result := 0 else result := 1;
   exit;
  end;

 result := 1;
end;

function MakeOrder (mWnd,aWnd:dword;data:pchar;params : pchar;show,nopause:boolean) : integer; stdcall;
var
 list       : string;
 players    : TStringList;
 i,ret 		: integer;
 cmd, line  : pchar;
 sline,scmd	: string;
 simple     : byte;
begin
 result  := 1;
 if not(Inited) then exit;

 list := trim(string(data));
 mWriteFile('(in):'+list);
 simple := ParseSimpleText(list,scmd,sline);
 mWriteFile('(simple):'+IntToStr(simple));

 if simple = 2 then
  begin
   ZeroMemory(data,  MaxDataLen*SizeOf(data[1]));
	ZeroMemory(params,MaxParmLen*SizeOf(data[1]));
	cmd  := PChar(scmd);
	line := PChar(sline);
	CopyMemory(data  ,cmd ,strlen(cmd ));
	CopyMemory(params,line,strlen(line));
	result := 2;
   exit;
  end;

 if simple = 1 then
  begin
   result := 1;
   exit;
  end;
 players := TStringList.Create;
 if list[length(list)] <> ']' then list := list+']';
 if ParseList(players,list) then
  begin
   mWriteFile('(out): ������ ��������: ');
   if players.Count > 0 then
    begin
     for i := 0 to players.Count -1 do
      begin
       if Assigned (players.Objects[i]) then mWriteFile('	���: '+TPlayer(players.Objects[i]).name+'; ������: '+INtToStr(TPlayer(players.Objects[i]).index)+'; ��: '+IntToStr(TPlayer(players.Objects[i]).hp));
      end;
    end else mWriteFile('������ �� ��������.');

   if Choice(players, sline) then
    begin
		ZeroMemory(data,  MaxDataLen*SizeOf(data[1]));
		ZeroMemory(params,MaxParmLen*SizeOf(data[1]));
		cmd  := PChar('/msg '+BotName+ ' $1-');
		line := PChar(sline);
		CopyMemory(data  ,cmd ,strlen(cmd ));
		CopyMemory(params,line,strlen(line));
      ordered := true;
	   ret := 2;
    end else ret := 1;
  end else ret := 1;

 if players.Count > 0 then
  begin
   for i := 0 to players.Count -1 do
    begin
     if Assigned (players.Objects[i]) then players.Objects[i].Free;
    end;
  end;
 FreeAndNil(players);
 result := ret;
end;


function OnPeopleTalk (mWnd,aWnd:dword;data:pchar;params : pchar;show,nopause:boolean) : integer; stdcall;
{var
 val        : string;
 cmd, line  : pchar;
 sline,scmd	: string;}
begin
{ val := trim(string(data));
 ZeroMemory(data,  MaxDataLen*SizeOf(data[1]));
 ZeroMemory(params,MaxParmLen*SizeOf(data[1]));
 scmd  := val;
 sline := val;
 cmd  := PChar(scmd);
 line := PChar(sline);
 CopyMemory(data  ,cmd ,strlen(cmd ));
 CopyMemory(params,line,strlen(line));
 result := 2;}
 result := 1;
end;



exports
(*-=Load/Unload routine=-*)
LoadDll  	name 'LoadDll',
UnloadDll 	name 'UnloadDll',

(*-= user functions =-*)
Init		 	name 'Init',
NewFight 	name 'NewFight',
OnPeopleTalk 	name 'OnPeopleTalk',     
MakeOrder 	name 'MakeOrder';
begin
 // here we can init some variables
end.
