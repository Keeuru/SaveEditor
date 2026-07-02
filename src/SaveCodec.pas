unit SaveCodec;

interface

uses
  System.SysUtils, XSuperObject, XSuperJSON;

type
  ESaveCodecError = class(Exception);

function LoadSaveFromFile(const AFileName: string; out AJson: ISuperObject): string;
procedure SaveSaveToFile(const AFileName: string; AJson: ISuperObject);
function LoadSaveFromText(const ACompressed: string; out AJson: ISuperObject): string;
function SaveSaveToText(AJson: ISuperObject): string;
function FormatJson(AJson: IJSONAncestor): string;
function JsonToCompact(AJson: IJSONAncestor): string;
function ParseJsonText(const AText: string): ISuperObject;
function JsonRootAncestor(const Root: ISuperObject): IJSONAncestor;

implementation

uses
  System.IOUtils,
  LZString;

function TrimSaveText(const S: string): string;
begin
  Result := S.Trim;
end;

function JsonToCompact(AJson: IJSONAncestor): string;
var
  Writer: TJSONWriter;
begin
  if AJson = nil then
    Exit('');
  if Supports(AJson, ISuperObject) then
    Exit(ISuperObject(AJson).AsJSON(False))
  else if Supports(AJson, ISuperArray) then
    Exit(ISuperArray(AJson).AsJSON(False));
  Writer := TJSONWriter.Create(False, False);
  try
    AJson.AsJSONString(Writer);
    Result := Writer.ToString;
  finally
    Writer.Free;
  end;
end;

function FormatJson(AJson: IJSONAncestor): string;
var
  Writer: TJSONWriter;
begin
  if AJson = nil then
    Exit('');
  if Supports(AJson, ISuperObject) then
    Exit(ISuperObject(AJson).AsJSON(True))
  else if Supports(AJson, ISuperArray) then
    Exit(ISuperArray(AJson).AsJSON(True));
  Writer := TJSONWriter.Create(True, False);
  try
    AJson.AsJSONString(Writer);
    Result := Writer.ToString;
  finally
    Writer.Free;
  end;
end;

function ParseJsonText(const AText: string): ISuperObject;
begin
  if Trim(AText) = '' then
    raise ESaveCodecError.Create('Пустой JSON.');
  // CheckDate=False: ISO-строки (в т.ч. SugarCube "(revive:date)" и ...Z) остаются строками.
  Result := TSuperObject.Create(AText, False);
end;

function JsonRootAncestor(const Root: ISuperObject): IJSONAncestor;
begin
  if Root = nil then
    Exit(nil);
  Result := (Root as TSuperObject).Self;
end;

function LoadSaveFromText(const ACompressed: string; out AJson: ISuperObject): string;
var
  JsonText: string;
begin
  AJson := nil;
  JsonText := LZDecompressFromBase64(TrimSaveText(ACompressed));
  if JsonText = '' then
    raise ESaveCodecError.Create('Не удалось распаковать файл (формат LZ-String / Base64).');
  Result := JsonText;
  AJson := ParseJsonText(JsonText);
end;

function LoadSaveFromFile(const AFileName: string; out AJson: ISuperObject): string;
var
  Bytes: TBytes;
begin
  Bytes := TFile.ReadAllBytes(AFileName);
  Result := LoadSaveFromText(TEncoding.ANSI.GetString(Bytes), AJson);
end;

function SaveSaveToText(AJson: ISuperObject): string;
var
  JsonText: string;
begin
  if AJson = nil then
    raise ESaveCodecError.Create('Нет данных для сохранения.');
  JsonText := JsonToCompact(JsonRootAncestor(AJson));
  Result := LZCompressToBase64(JsonText);
end;

procedure SaveSaveToFile(const AFileName: string; AJson: ISuperObject);
var
  OutText: string;
  Bytes: TBytes;
begin
  OutText := SaveSaveToText(AJson);
  Bytes := TEncoding.ANSI.GetBytes(OutText);
  TFile.WriteAllBytes(AFileName, Bytes);
end;

end.
