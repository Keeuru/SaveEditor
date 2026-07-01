unit SaveSlots;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, XSuperObject, XSuperJSON;

procedure FillSaveViewList(ARoot: ISuperObject; AList: TStrings);

implementation

procedure AddView(AList: TStrings; const ACaption: string; AValue: IJSONAncestor);
begin
  AList.AddObject(ACaption, TObject(Pointer(AValue)));
end;

procedure AddSlotArray(AList: TStrings; const APrefix: string; Arr: ISuperArray);
var
  I: Integer;
  Cap: string;
  Item: IJSONAncestor;
  ItemObj: ISuperObject;
  ItemCast: ICast;
begin
  for I := 0 to Arr.Length - 1 do
  begin
    Item := Arr.Ancestor[I];
    ItemCast := TCast.Create(Item);
    if ItemCast.DataType = dtObject then
    begin
      Cap := APrefix + ' ' + IntToStr(I);
      ItemObj := ItemCast.AsObject;
      if ItemObj.Contains('title') then
        Cap := Cap + ' — ' + ItemObj.S['title'];
      AddView(AList, Cap, Item);
    end
    else
      AddView(AList, APrefix + ' ' + IntToStr(I), Item);
  end;
end;

procedure FillSaveViewList(ARoot: ISuperObject; AList: TStrings);
var
  SlotsArr, SavesArr: ISuperArray;
  SkipKey: TDictionary<string, Byte>;
  Key: string;
  Val: IJSONAncestor;
  ValCast: ICast;
begin
  AList.Clear;
  AddView(AList, 'Весь файл', JsonRootAncestor(ARoot));
  if (ARoot = nil) or (ARoot.DataType <> dtObject) then
    Exit;

  SkipKey := TDictionary<string, Byte>.Create;
  try
    if ARoot.Contains('slots') then
    begin
      SlotsArr := ARoot.A['slots'];
      if SlotsArr.Length > 0 then
      begin
        SkipKey.Add('slots', 0);
        AddSlotArray(AList, 'Слот', SlotsArr);
      end;
    end;

    if ARoot.Contains('saves') then
    begin
      SavesArr := ARoot.A['saves'];
      if SavesArr.Length > 0 then
      begin
        SkipKey.Add('saves', 0);
        AddSlotArray(AList, 'Save', SavesArr);
      end;
    end;

    ARoot.First;
    while not ARoot.EoF do
    begin
      Key := ARoot.CurrentKey;
      if not SkipKey.ContainsKey(Key) then
      begin
        Val := ARoot.CurrentValue;
        ValCast := TCast.Create(Val);
        if ValCast.DataType in [dtObject, dtArray] then
          AddView(AList, Key, Val);
      end;
      ARoot.Next;
    end;
  finally
    SkipKey.Free;
  end;
end;

end.
