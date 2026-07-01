unit FontAwesome;

interface

uses
  Vcl.Buttons, Vcl.Graphics;

const
  cFontAwesomeName = 'FontAwesome';
  cFaIconColorDefault = clBtnText;
  fa_file_o = WideChar($F016);
  fa_folder = WideChar($F07B);
  fa_folder_open = WideChar($F07C);
  fa_floppy_o = WideChar($F0C7);
  fa_files_o = WideChar($F0C5);
  fa_download = WideChar($F019);
  fa_upload = WideChar($F093);
  fa_sign_out = WideChar($F08B);

function RegisterFontAwesome: Boolean;

procedure SetupSpeedButtonIcon(AButton: TSpeedButton; AIcon: WideChar; const AHint: string;
  AFontSize: Integer = 16; AIconColor: TColor = cFaIconColorDefault);

procedure SetSpeedButtonIconColor(AButton: TSpeedButton; AIconColor: TColor);

implementation

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, Vcl.Forms;

var
  GFontLoaded: Boolean;
  GFontPath: string;

function RegisterFontAwesome: Boolean;
var
  Paths: TArray<string>;
  Path: string;
begin
  if GFontLoaded then
    Exit(True);

  Paths := TArray<string>.Create(
    ExtractFilePath(Application.ExeName) + 'fonts\fontawesome-webfont.ttf',
    ExtractFilePath(Application.ExeName) + 'fontawesome-webfont.ttf',
    ExtractFilePath(ParamStr(0)) + '..\fonts\fontawesome-webfont.ttf',
    ExtractFilePath(ParamStr(0)) + '..\..\font-awesome-4.7.0\fonts\fontawesome-webfont.ttf'
  );
  for Path in Paths do
  begin
    if FileExists(Path) and (AddFontResource(PChar(Path)) > 0) then
    begin
      GFontPath := Path;
      SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
      GFontLoaded := True;
      Exit(True);
    end;
  end;

  Result := False;
end;

procedure SetupSpeedButtonIcon(AButton: TSpeedButton; AIcon: WideChar; const AHint: string;
  AFontSize: Integer; AIconColor: TColor);
begin
  AButton.ParentFont := False;
  AButton.Font.Name := cFontAwesomeName;
  AButton.Font.Charset := DEFAULT_CHARSET;
  AButton.Font.Size := AFontSize;
  AButton.Font.Style := [];
  AButton.Font.Color := AIconColor;
  AButton.Caption := string(AIcon);
  AButton.Hint := AHint;
  AButton.ShowHint := True;
end;

procedure SetSpeedButtonIconColor(AButton: TSpeedButton; AIconColor: TColor);
begin
  AButton.ParentFont := False;
  AButton.Font.Color := AIconColor;
end;

initialization

finalization
  if GFontLoaded and (GFontPath <> '') then
    RemoveFontResource(PChar(GFontPath));

end.

