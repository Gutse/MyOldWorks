program XLLink;

uses
//  ExceptionLog,
  Forms,
  Main in 'Main.pas' {MainFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
