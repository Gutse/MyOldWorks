program graduate;

uses
  Forms,
  main in 'main.pas' {MainFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
