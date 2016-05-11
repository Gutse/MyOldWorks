unit DataMod;
interface
uses
  SysUtils, Classes, DB, ADODB;
type
  TDM = class(TDataModule)
    connection: TADOConnection;
    CTLG_Q: TADOQuery;
    persons: TADOQuery;
    perons_s: TDataSource;
    PERSON_Q: TADOQuery;
    ACCESS_T: TADOTable;
    ACCESS_S: TDataSource;
    cm: TADOQuery;
    procedure personsAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  DM: TDM;
implementation
{$R *.dfm}
procedure TDM.personsAfterOpen(DataSet: TDataSet);
begin
ACCESS_T.Open;
end;

end.
