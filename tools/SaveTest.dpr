program SaveTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  XSuperObject in '..\src\XSuperObject.pas',
  XSuperJSON in '..\src\XSuperJSON.pas',
  LZString in '..\src\LZString.pas',
  SaveCodec in '..\src\SaveCodec.pas';

var
  Json: ISuperObject;
  Text, Recompressed, Chunk: string;
  Fn: string;
  N: Integer;
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
    WriteLn('id=', Json.S['id']);
    WriteLn('has state=', Json.Contains('state'));
  if Json.Contains('state') then
  begin
    WriteLn('has state.delta=', Json.O['state'].Contains('delta'));
    WriteLn('has state.history=', Json.O['state'].Contains('history'));
    WriteLn('state.index=', Json.O['state'].I['index']);
  end;
    if Pos('.000Z', Text) > 0 then
      WriteLn('Contains .000Z UTC marker: OK');
    Recompressed := SaveSaveToText(Json);
    WriteLn('Recompressed length=', Length(Recompressed));
    WriteLn('Orig vs new same=', SameText(Text, JsonToCompact(JsonRootAncestor(Json))));
    try
      LoadSaveFromText(Recompressed, Json);
      WriteLn('Roundtrip via SaveSaveToText OK');
    except
      on E: Exception do
        WriteLn('Roundtrip SaveSaveToText FAIL: ', E.Message);
    end;
    try
      LoadSaveFromText(LZCompressToBase64(Text), Json);
      WriteLn('Roundtrip raw LZ on original text OK');
    except
      on E: Exception do
        WriteLn('Roundtrip raw LZ FAIL: ', E.Message);
    end;
    WriteLn('char250=', Ord(Text[250]), ' ', Text[250]);
    WriteLn('snippet=', Copy(Text, 240, 20));
    WriteLn('N249 ok=', LZDecompressFromBase64(LZCompressToBase64(Copy(Text,1,249))) = Copy(Text,1,249));
    WriteLn('N250 ok=', LZDecompressFromBase64(LZCompressToBase64(Copy(Text,1,250))) = Copy(Text,1,250));
    for N := 100 to 1000 do
    begin
      Chunk := Copy(Text, 1, N);
      if LZDecompressFromBase64(LZCompressToBase64(Chunk)) <> Chunk then
      begin
        WriteLn('First LZ mismatch at N=', N);
        Break;
      end;
    end;
    Json := nil;
    WriteLn('SUCCESS');
  except
    on E: Exception do
    begin
      WriteLn('FAIL: ', E.Message);
      ExitCode := 1;
    end;
  end;
end.
