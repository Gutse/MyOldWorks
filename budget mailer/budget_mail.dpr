program budget_mail;

uses
  Forms,
  Main in 'Main.pas' {MainFrm},
  RarRunner in 'RarRunner.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
