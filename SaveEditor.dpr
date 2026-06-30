program SaveEditor;

uses
  Vcl.Forms,
  MainForm in 'src\MainForm.pas' {frmMain},
  LZString in 'src\LZString.pas',
  SaveCodec in 'src\SaveCodec.pas',
  SaveSlots in 'src\SaveSlots.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Save Editor';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
