unit SaveCodec;

interface

uses
  System.SysUtils, System.JSON;

type
  ESaveCodecError = class(Exception);

function LoadSaveFromFile(const AFileName: string; out AJson: TJSONValue): string;
procedure SaveSaveToFile(const AFileName: string; AJson: TJSONValue);
function LoadSaveFromText(const ACompressed: string; out AJson: TJSONValue): string;
function SaveSaveToText(AJson: TJSONValue): string;
function FormatJson(AJson: TJSONValue): string;
function ParseJsonText(const AText: string): TJSONValue;

implementation

uses
  System.IOUtils,
  LZString;

function TrimSaveText(const S: string): string;
begin
  Result := S.Trim;
end;

function LoadSaveFromText(const ACompressed: string; out AJson: TJSONValue): string;
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

function LoadSaveFromFile(const AFileName: string; out AJson: TJSONValue): string;
var
  Bytes: TBytes;
begin
  { .save — одна строка Base64 (ASCII); UTF-8 с BOM портит данные }
  Bytes := TFile.ReadAllBytes(AFileName);
  Result := LoadSaveFromText(TEncoding.ANSI.GetString(Bytes), AJson);
end;

function SaveSaveToText(AJson: TJSONValue): string;
var
  JsonText: string;
begin
  if AJson = nil then
    raise ESaveCodecError.Create('Нет данных для сохранения.');
  JsonText := AJson.ToJSON;
  Result := LZCompressToBase64(JsonText);
end;

procedure SaveSaveToFile(const AFileName: string; AJson: TJSONValue);
var
  OutText: string;
  Bytes: TBytes;
begin
  OutText := SaveSaveToText(AJson);
  Bytes := TEncoding.ANSI.GetBytes(OutText);
  TFile.WriteAllBytes(AFileName, Bytes);
end;

function FormatJson(AJson: TJSONValue): string;
begin
  if AJson = nil then
    Exit('');
  Result := AJson.Format(2);
end;

function ParseJsonText(const AText: string): TJSONValue;
begin
  Result := TJSONObject.ParseJSONValue(AText);
  if Result = nil then
    raise ESaveCodecError.Create('Некорректный JSON после распаковки.');
end;

end.
