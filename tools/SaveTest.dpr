program SaveTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.JSON,
  LZString in '..\src\LZString.pas',
  SaveCodec in '..\src\SaveCodec.pas';

var
  Json: TJSONValue;
  Text, Recompressed: string;
  Fn: string;
begin
  Fn := '..\degrees-of-lewdity-20260515-140333.save';
  if ParamCount >= 1 then
    Fn := ParamStr(1);

  try
    WriteLn('small=', LZCompressToBase64('{"test":1}'));
    WriteLn('small back=', LZDecompressFromBase64(LZCompressToBase64('{"test":1}')));
    Text := LoadSaveFromFile(Fn, Json);
    WriteLn('Decompressed OK, length=', Length(Text));
    WriteLn(Copy(Text, 1, 120));
    Recompressed := SaveSaveToText(Json);
    WriteLn('Recompressed length=', Length(Recompressed));
    Json.Free;
    Json := nil;
    LoadSaveFromText(Recompressed, Json);
    WriteLn('Roundtrip JSON OK, root=', Json.ClassName);
    Json.Free;
    WriteLn('SUCCESS');
  except
    on E: Exception do
    begin
      WriteLn('FAIL: ', E.Message);
      ExitCode := 1;
    end;
  end;
end.
