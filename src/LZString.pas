unit LZString;

{ Port of lz-string 1.5.0 (pieroxy) for SugarCube / Twine .save files. }

interface

function LZDecompressFromBase64(const AInput: string): string;
function LZCompressToBase64(const AInput: string): string;

implementation

uses
  System.SysUtils, System.Generics.Collections, System.Math;

const
  KEY_STR_BASE64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';

var
  GBase64Map: TDictionary<Char, Integer>;

procedure EnsureBase64Map;
var
  I: Integer;
  C: Char;
begin
  if GBase64Map <> nil then
    Exit;
  GBase64Map := TDictionary<Char, Integer>.Create;
  for I := 1 to Length(KEY_STR_BASE64) do
  begin
    C := KEY_STR_BASE64[I];
    GBase64Map.AddOrSetValue(C, I - 1);
  end;
end;

function Base64Value(C: Char): Integer;
begin
  EnsureBase64Map;
  if not GBase64Map.TryGetValue(C, Result) then
    Result := 0;
end;

type
  TLZData = record
    Values: TArray<Integer>;
    Val: Integer;
    Position: Integer;
    Index: Integer;
  end;

function GetNextFromArray(const Data: TLZData; AIndex: Integer): Integer;
begin
  if (AIndex < 0) or (AIndex >= Length(Data.Values)) then
    Exit(0);
  Result := Data.Values[AIndex];
end;

function LZDecompress(const ALength: Integer; AResetValue: Integer;
  const AGetNext: TArray<Integer>): string;
var
  Dictionary: TArray<string>;
  DictSize, NumBits, EnlargeIn: Integer;
  Data: TLZData;
  Bits, MaxPower, Power, Resb, NextBits: Integer;
  W, Entry, C: string;
  I: Integer;

  procedure ReadBits(ABitCount: Integer; out ABits: Integer);
  var
    P, MP: Integer;
  begin
    ABits := 0;
    MP := 1 shl ABitCount;
    P := 1;
    while P <> MP do
    begin
      Resb := Data.Val and Data.Position;
      Data.Position := Data.Position shr 1;
      if Data.Position = 0 then
      begin
        Data.Position := AResetValue;
        Data.Val := GetNextFromArray(Data, Data.Index);
        Inc(Data.Index);
      end;
      if Resb > 0 then
        ABits := ABits or P;
      P := P shl 1;
    end;
  end;

begin
  SetLength(Dictionary, 4);
  Dictionary[0] := #0;
  Dictionary[1] := #1;
  Dictionary[2] := #2;
  DictSize := 4;
  NumBits := 3;
  EnlargeIn := 4;

  Data.Values := AGetNext;
  Data.Index := 1;
  Data.Val := GetNextFromArray(Data, 0);
  Data.Position := AResetValue;

  ReadBits(2, Bits);
  case Bits of
    0:
      begin
        ReadBits(8, Bits);
        C := Char(Bits);
      end;
    1:
      begin
        ReadBits(16, Bits);
        C := Char(Bits);
      end;
  else
    Exit('');
  end;

  Dictionary[3] := C;
  W := C;
  Result := C;

  while True do
  begin
    if Data.Index > ALength then
      Exit('');

    ReadBits(NumBits, NextBits);

    case NextBits of
      0:
        begin
          ReadBits(8, Bits);
          if DictSize >= Length(Dictionary) then
            SetLength(Dictionary, DictSize + 1);
          Dictionary[DictSize] := Char(Bits);
          Inc(DictSize);
          NextBits := DictSize - 1;
          Dec(EnlargeIn);
        end;
      1:
        begin
          ReadBits(16, Bits);
          if DictSize >= Length(Dictionary) then
            SetLength(Dictionary, DictSize + 1);
          Dictionary[DictSize] := Char(Bits);
          Inc(DictSize);
          NextBits := DictSize - 1;
          Dec(EnlargeIn);
        end;
      2:
        Exit(Result);
    end;

    if EnlargeIn = 0 then
    begin
      EnlargeIn := 1 shl NumBits;
      Inc(NumBits);
    end;

    if (NextBits >= 0) and (NextBits < Length(Dictionary)) and (Dictionary[NextBits] <> '') then
      Entry := Dictionary[NextBits]
    else if NextBits = DictSize then
      Entry := W + W[1]
    else
      Exit('');

    Result := Result + Entry;

    if DictSize >= Length(Dictionary) then
      SetLength(Dictionary, DictSize + 1);
    Dictionary[DictSize] := W + Entry[1];
    Inc(DictSize);
    Dec(EnlargeIn);
    W := Entry;

    if EnlargeIn = 0 then
    begin
      EnlargeIn := 1 shl NumBits;
      Inc(NumBits);
    end;
  end;
end;

function LZDecompressFromBase64(const AInput: string): string;
var
  Values: TArray<Integer>;
  I, L: Integer;
  S: string;
begin
  if AInput = '' then
    Exit('');
  S := AInput;
  L := Length(S);
  SetLength(Values, L);
  for I := 1 to L do
    Values[I - 1] := Base64Value(S[I]);
  Result := LZDecompress(L, 32, Values);
end;

procedure WriteBits(var ADataVal: Integer; var ADataPos, ABitsPerChar: Integer;
  var AOutput: TStringBuilder; AValue, ABitCount: Integer;
  const AGetChar: TFunc<Integer, Char>);
var
  I: Integer;
begin
  for I := 0 to ABitCount - 1 do
  begin
    if (AValue and 1) = 1 then
      ADataVal := (ADataVal shl 1) or 1
    else
      ADataVal := ADataVal shl 1;
    if ADataPos = ABitsPerChar - 1 then
    begin
      ADataPos := 0;
      AOutput.Append(AGetChar(ADataVal));
      ADataVal := 0;
    end
    else
      Inc(ADataPos);
    AValue := AValue shr 1;
  end;
end;

procedure WriteBitsZero(var ADataVal: Integer; var ADataPos, ABitsPerChar, ACount: Integer;
  var AOutput: TStringBuilder; const AGetChar: TFunc<Integer, Char>);
var
  I: Integer;
begin
  for I := 0 to ACount - 1 do
  begin
    ADataVal := ADataVal shl 1;
    if ADataPos = ABitsPerChar - 1 then
    begin
      ADataPos := 0;
      AOutput.Append(AGetChar(ADataVal));
      ADataVal := 0;
    end
    else
      Inc(ADataPos);
  end;
end;

function LZCompress(const AInput: string; ABitsPerChar: Integer;
  const AGetChar: TFunc<Integer, Char>): string;
var
  Dict, DictToCreate: TDictionary<string, Integer>;
  Output: TStringBuilder;
  ContextW, ContextC, ContextWC: string;
  ContextDictSize, ContextNumBits, ContextEnlargeIn: Integer;
  ContextDataVal, ContextDataPos: Integer;
  II, I, Value: Integer;
  InDict, InCreate: Boolean;

  procedure FlushEndMarker;
  begin
    Value := 2;
    WriteBits(ContextDataVal, ContextDataPos, ABitsPerChar, Output, Value, ContextNumBits, AGetChar);
    while True do
    begin
      ContextDataVal := ContextDataVal shl 1;
      if ContextDataPos = ABitsPerChar - 1 then
      begin
        Output.Append(AGetChar(ContextDataVal));
        Break;
      end
      else
        Inc(ContextDataPos);
    end;
  end;

  procedure OutputW(const AW: string);
  var
    Ch: Integer;
  begin
    if DictToCreate.ContainsKey(AW) then
    begin
      Ch := Ord(AW[1]);
      if Ch < 256 then
      begin
        WriteBitsZero(ContextDataVal, ContextDataPos, ABitsPerChar, ContextNumBits, Output, AGetChar);
        WriteBits(ContextDataVal, ContextDataPos, ABitsPerChar, Output, Ch, 8, AGetChar);
      end
      else
      begin
        WriteBits(ContextDataVal, ContextDataPos, ABitsPerChar, Output, 1, ContextNumBits, AGetChar);
        WriteBits(ContextDataVal, ContextDataPos, ABitsPerChar, Output, 0, ContextNumBits, AGetChar);
        WriteBits(ContextDataVal, ContextDataPos, ABitsPerChar, Output, Ch, 16, AGetChar);
      end;
      Dec(ContextEnlargeIn);
      if ContextEnlargeIn = 0 then
      begin
        ContextEnlargeIn := 1 shl ContextNumBits;
        Inc(ContextNumBits);
      end;
      DictToCreate.Remove(AW);
    end
    else
    begin
      Value := Dict[AW];
      WriteBits(ContextDataVal, ContextDataPos, ABitsPerChar, Output, Value, ContextNumBits, AGetChar);
    end;
    Dec(ContextEnlargeIn);
    if ContextEnlargeIn = 0 then
    begin
      ContextEnlargeIn := 1 shl ContextNumBits;
      Inc(ContextNumBits);
    end;
  end;

begin
  if AInput = '' then
    Exit('');

  Dict := TDictionary<string, Integer>.Create;
  DictToCreate := TDictionary<string, Integer>.Create;
  Output := TStringBuilder.Create;
  try
    ContextDictSize := 3;
    ContextNumBits := 2;
    ContextEnlargeIn := 2;
    ContextDataVal := 0;
    ContextDataPos := 0;
    ContextW := '';

    for II := 1 to Length(AInput) do
    begin
      ContextC := AInput[II];
      if not Dict.ContainsKey(ContextC) then
      begin
        Dict.Add(ContextC, ContextDictSize);
        Inc(ContextDictSize);
        DictToCreate.Add(ContextC, 0);
      end;

      ContextWC := ContextW + ContextC;
      if Dict.ContainsKey(ContextWC) then
        ContextW := ContextWC
      else
      begin
        OutputW(ContextW);
        Dict.Add(ContextWC, ContextDictSize);
        Inc(ContextDictSize);
        ContextW := ContextC;
      end;
    end;

    if ContextW <> '' then
      OutputW(ContextW);

    FlushEndMarker;
    Result := Output.ToString;
  finally
    Output.Free;
    Dict.Free;
    DictToCreate.Free;
  end;
end;

function LZCompressToBase64(const AInput: string): string;
begin
  Result := LZCompress(AInput, 6,
    function(A: Integer): Char
    begin
      Result := KEY_STR_BASE64[A + 1];
    end);
  case Length(Result) mod 4 of
    1: Result := Result + '===';
    2: Result := Result + '==';
    3: Result := Result + '=';
  end;
end;

initialization

finalization
  GBase64Map.Free;

end.
