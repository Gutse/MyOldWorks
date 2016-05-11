unit XLHelp;
interface
uses ComObj,Variants,SysUtils,Math;

Function XLCreateApp     (Visible : boolean)                         : OleVariant;
Function XLOpenWBook     (App     : OleVariant; filename : string )  : OleVariant;
Function XLGetSheet      (Book    : OleVariant; index    : integer)  : OleVariant;

Function XLGetRange      (Sheet   : OleVariant; AStartRow, AStartCol, AEndRow, AEndCol : integer) : Variant;  overload;
Function XLGetRangeValue (Sheet   : OleVariant; AStartRow, AStartCol, AEndRow, AEndCol : integer) : Variant;  overload;
Function XLGetRange      (Sheet   : OleVariant; AStartRow, AEndRow : integer;  AStartCol, AEndCol : string): Variant; overload;
Function XLGetRangeValue (Sheet   : OleVariant; AStartRow, AEndRow : integer;  AStartCol, AEndCol : string): Variant; overload;

Function XLSetRange      (Sheet   : OleVariant; Value : Variant; AStartRow, AStartCol, AEndRow, AEndCol : integer): Variant;  overload;
Function XLSetRangeValue (Sheet   : OleVariant; Value : Variant; AStartRow, AStartCol, AEndRow, AEndCol : integer): Variant;  overload;
Function XLSetRange      (Sheet   : OleVariant; Value : Variant; AStartRow, AEndRow : integer; AStartCol, AEndCol : string): Variant; overload;
Function XLSetRangeValue (Sheet   : OleVariant; Value : Variant; AStartRow, AEndRow : integer; AStartCol, AEndCol : string): Variant; overload;

Function XLColToStr (ACol : integer) : string;
Function XLStrToCol (AStr : string ) : integer;

implementation
(*===============================================================================================================*)
Function XLCreateApp (visible : boolean): OleVariant;
begin
try
 result := CreateOleObject('Excel.Application') ;
 result.EnableEvents := false;
 result.visible      := visible;
except result        := Unassigned; end;
end;
(*===============================================================================================================*)
Function XLOpenWBook(App: OleVariant; filename: string) : OleVariant;
begin
 if filename = '' then
  begin
   try
    result       := App.Workbooks.Add;
   except result := Unassigned end;
  end else
  begin
   try
    result       := App.Workbooks.Open(filename);
   except result := Unassigned end;
  end;
end;
(*===============================================================================================================*)
Function XLGetSheet (Book : OleVariant; index : integer) : OleVariant;
begin
 try
  result := book.sheets[index];
 except result := Unassigned; end
end;
(*===============================================================================================================*)
Function XLGetRange (Sheet : OleVariant; AStartRow,AStartCol,AEndRow,AEndCol : integer): Variant;
begin
try
 result := sheet.range[XLColToStr(AStartCol)+IntToStr(AStartRow)+':'+XLColToStr(AEndCol)+IntToStr(AEndRow)];
except result := Unassigned end;
end;
(*===============================================================================================================*)
Function XLGetRange (Sheet : OleVariant; AStartRow,AEndRow : integer; AStartCol,AEndCol : string): Variant;
begin
try
 result := sheet.range[AStartCol+IntToStr(AStartRow)+':'+AEndCol+IntToStr(AEndRow)];
except result := Unassigned end;
end;
(*===============================================================================================================*)
Function XLGetRangeValue (Sheet : OleVariant; AStartRow,AStartCol,AEndRow,AEndCol : integer): Variant;
begin
try
 result := sheet.range[XLColToStr(AStartCol)+IntToStr(AStartRow)+':'+XLColToStr(AEndCol)+IntToStr(AEndRow)].value;
except result := Unassigned end;
end;
(*===============================================================================================================*)
Function XLGetRangeValue (Sheet : OleVariant; AStartRow,AEndRow : integer; AStartCol,AEndCol : string): Variant;
begin
try
 result := sheet.range[AStartCol+IntToStr(AStartRow)+':'+AEndCol+IntToStr(AEndRow)].value;
except result := Unassigned end;
end;
(*===============================================================================================================*)
Function XLSetRange (Sheet : OleVariant;Value : Variant; AStartRow,AStartCol,AEndRow,AEndCol : integer): Variant;
begin
try
 sheet.range[XLColToStr(AStartCol)+IntToStr(AStartRow)+':'+XLColToStr(AEndCol)+IntToStr(AEndRow)] := Value;
 result := 1;
except result := Unassigned end;
end;
(*===============================================================================================================*)
Function XLSetRange (Sheet : OleVariant;Value : Variant; AStartRow,AEndRow : integer; AStartCol,AEndCol : string): Variant;
begin
try
 sheet.range[AStartCol+IntToStr(AStartRow)+':'+AEndCol+IntToStr(AEndRow)] := value;
 result := 1;
except result := Unassigned end;
end;
(*===============================================================================================================*)
Function XLSetRangeValue (Sheet : OleVariant;Value : Variant; AStartRow,AStartCol,AEndRow,AEndCol : integer): Variant;
begin
try
 sheet.range[XLColToStr(AStartCol)+IntToStr(AStartRow)+':'+XLColToStr(AEndCol)+IntToStr(AEndRow)].value := value;
 result := 1;
except result := Unassigned end;
end;
(*===============================================================================================================*)
Function XLSetRangeValue (Sheet : OleVariant;Value : Variant; AStartRow,AEndRow : integer; AStartCol,AEndCol : string): Variant;
begin
try
 sheet.range[AStartCol+IntToStr(AStartRow)+':'+AEndCol+IntToStr(AEndRow)].value := value;
 result := 1;
except result := Unassigned end;
end;
(*===============================================================================================================*)
Function XLColToStr (ACol : integer) : string;
var degval : integer;
begin
 result := '';
 repeat
  degval := ACol mod 26;
  ACol   := ACol div 26;
  if degval = 0 then
   begin
    ACol   := ACol -1;
    degval := 26;
   end;
  result := Chr(Ord('A') + degval - 1)+result;
 until ACol = 0;
end;
(*===============================================================================================================*)
Function XLStrToCol (AStr : string ) : integer;
var i,d : integer;
begin
 result := 0;
 d := length(AStr);
 if d = 0 then exit;
 for i  := 1 to d do
 begin
  result := result + trunc(power(26,d-i))*(Ord(AStr[i])-Ord('A')+1);
 end;
end;
(*===============================================================================================================*)

end.
