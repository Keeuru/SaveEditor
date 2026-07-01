program SaveEditor;

uses
  Vcl.Forms,
  MainForm in 'src\MainForm.pas' {frmMain},
  LZString in 'src\LZString.pas',
  SaveCodec in 'src\SaveCodec.pas',
  SaveSlots in 'src\SaveSlots.pas',
  XSuperJSON in 'src\XSuperJSON.pas',
  XSuperObject in 'src\XSuperObject.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Save Editor';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
