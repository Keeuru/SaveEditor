unit SaveSlots;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections;

type
  TSaveViewItem = record
    Caption: string;
    Value: TJSONValue;
  end;

procedure FillSaveViewList(ARoot: TJSONValue; AList: TStrings);

implementation

procedure AddView(AList: TStrings; const ACaption: string; AValue: TJSONValue);
begin
  AList.AddObject(ACaption, TObject(AValue));
end;

procedure AddSlotArray(AList: TStrings; const APrefix: string; Arr: TJSONArray);
var
  I: Integer;
  Cap: string;
  TitlePair: TJSONPair;
begin
  for I := 0 to Arr.Count - 1 do
  begin
    if Arr.Items[I] is TJSONObject then
    begin
      Cap := APrefix + ' ' + IntToStr(I);
      TitlePair := TJSONObject(Arr.Items[I]).Get('title');
      if (TitlePair <> nil) and (TitlePair.JsonValue is TJSONString) then
        Cap := Cap + ' — ' + TJSONString(TitlePair.JsonValue).Value;
      AddView(AList, Cap, Arr.Items[I]);
    end
    else
      AddView(AList, APrefix + ' ' + IntToStr(I), Arr.Items[I]);
  end;
end;

procedure FillSaveViewList(ARoot: TJSONValue; AList: TStrings);
var
  Obj: TJSONObject;
  Pair: TJSONPair;
  Arr: TJSONArray;
  SkipKey: TDictionary<string, Byte>;
begin
  AList.Clear;
  AddView(AList, 'Весь файл', ARoot);
  if not (ARoot is TJSONObject) then
    Exit;

  Obj := TJSONObject(ARoot);
  SkipKey := TDictionary<string, Byte>.Create;
  try
    Pair := Obj.Get('slots');
    if (Pair <> nil) and (Pair.JsonValue is TJSONArray) then
    begin
      Arr := TJSONArray(Pair.JsonValue);
      if Arr.Count > 0 then
      begin
        SkipKey.Add('slots', 0);
        AddSlotArray(AList, 'Слот', Arr);
      end;
    end;

    Pair := Obj.Get('saves');
    if (Pair <> nil) and (Pair.JsonValue is TJSONArray) then
    begin
      Arr := TJSONArray(Pair.JsonValue);
      if Arr.Count > 0 then
      begin
        SkipKey.Add('saves', 0);
        AddSlotArray(AList, 'Save', Arr);
      end;
    end;

    for Pair in Obj do
    begin
      if SkipKey.ContainsKey(Pair.JsonString.Value) then
        Continue;
      if (Pair.JsonValue is TJSONObject) or (Pair.JsonValue is TJSONArray) then
        AddView(AList, Pair.JsonString.Value, Pair.JsonValue);
    end;
  finally
    SkipKey.Free;
  end;
end;

end.
