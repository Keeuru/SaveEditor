program SaveEditor;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  MainForm in 'src\MainForm.pas' {frmMain},
  LZString in 'src\LZString.pas',
  FontAwesome in 'src\FontAwesome.pas',
  SaveCodec in 'src\SaveCodec.pas',
  XSuperJSON in 'src\XSuperJSON.pas',
  XSuperObject in 'src\XSuperObject.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Auric');
  Application.Title := 'Save Editor';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
