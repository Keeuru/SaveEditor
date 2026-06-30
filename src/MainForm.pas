unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.JSON,
  System.IOUtils, System.Generics.Collections, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Menus,
  SaveCodec, SaveSlots;

type
  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    mnuFile: TMenuItem;
    mnuOpen: TMenuItem;
    mnuSave: TMenuItem;
    mnuSaveAs: TMenuItem;
    mnuExportJson: TMenuItem;
    mnuImportJson: TMenuItem;
    N1: TMenuItem;
    mnuExit: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    JsonSaveDialog: TSaveDialog;
    JsonOpenDialog: TOpenDialog;
    StatusBar: TStatusBar;
    PageControl: TPageControl;
    tabTree: TTabSheet;
    tabJson: TTabSheet;
    Splitter1: TSplitter;
    PanelTree: TPanel;
    PanelTreeTop: TPanel;
    lblView: TLabel;
    cboView: TComboBox;
    lblSearch: TLabel;
    edtSearch: TEdit;
    btnFindNext: TButton;
    btnFindPrev: TButton;
    TreeJson: TTreeView;
    PanelEdit: TPanel;
    lblPath: TLabel;
    memoValue: TMemo;
    btnApply: TButton;
    memoJson: TMemo;
    mnuEdit: TMenuItem;
    mnuFind: TMenuItem;
    mnuFindNext: TMenuItem;
    mnuFindPrev: TMenuItem;
    N2: TMenuItem;
    mnuFormatJson: TMenuItem;
    mnuReloadTree: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure mnuExportJsonClick(Sender: TObject);
    procedure mnuImportJsonClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure TreeJsonChange(Sender: TObject; Node: TTreeNode);
    procedure btnApplyClick(Sender: TObject);
    procedure memoJsonChange(Sender: TObject);
    procedure mnuFormatJsonClick(Sender: TObject);
    procedure mnuReloadTreeClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure cboViewChange(Sender: TObject);
    procedure btnFindNextClick(Sender: TObject);
    procedure btnFindPrevClick(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mnuFindClick(Sender: TObject);
  private
    FJsonRoot: TJSONValue;
    FNodeKeys: TDictionary<TTreeNode, string>;
    FFileName: string;
    FModified: Boolean;
    FUpdating: Boolean;
    FLastSearchNode: TTreeNode;
    procedure SetModified(AValue: Boolean);
    procedure UpdateCaption;
    procedure UpdateStatus;
    procedure ClearDocument;
    procedure LoadDocument(const AFileName: string);
    procedure SaveDocument(const AFileName: string);
    function ConfirmSaveIfModified: Boolean;
    procedure SyncJsonMemo;
    procedure RefreshViewCombo;
    function GetViewRoot: TJSONValue;
    procedure RebuildTree;
    procedure BuildTreeNode(ANode: TTreeNode; AValue: TJSONValue; const AName: string);
    function SelectedJsonValue: TJSONValue;
    procedure ShowNodeValue(ANode: TTreeNode);
    procedure UpdateNodeCaption(ANode: TTreeNode; AValue: TJSONValue);
    function TreeNodePath(ANode: TTreeNode): string;
    function ReplaceNodeJsonValue(ANode: TTreeNode; ANewValue: TJSONValue): Boolean;
    function ApplyValueFromMemo(AValue: TJSONValue): Boolean;
    function NodeMatchesSearch(ANode: TTreeNode; const ASearch: string): Boolean;
    procedure CollectNodes(ANode: TTreeNode; AList: TList<TTreeNode>);
    function FindSearchNode(AForward: Boolean): TTreeNode;
    procedure FocusSearchNode(ANode: TTreeNode);
    procedure ApplyJsonFromText(const AJsonText: string);
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FNodeKeys := TDictionary<TTreeNode, string>.Create;
  OpenDialog.Filter := 'Файлы сохранения (*.save)|*.save|Все файлы (*.*)|*.*';
  SaveDialog.Filter := OpenDialog.Filter;
  JsonSaveDialog.Filter := 'JSON (*.json)|*.json|Все файлы (*.*)|*.*';
  JsonSaveDialog.DefaultExt := 'json';
  JsonOpenDialog.Filter := JsonSaveDialog.Filter;
  ClearDocument;
  if ParamCount >= 1 then
    LoadDocument(ParamStr(1));
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  ClearDocument;
  FNodeKeys.Free;
end;

procedure TfrmMain.SetModified(AValue: Boolean);
begin
  FModified := AValue;
  UpdateCaption;
  UpdateStatus;
end;

procedure TfrmMain.UpdateCaption;
var
  Title: string;
begin
  Title := 'Save Editor';
  if FFileName <> '' then
    Title := Title + ' — ' + ExtractFileName(FFileName)
  else
    Title := Title + ' — без имени';
  if FModified then
    Title := Title + ' *';
  Caption := Title;
end;

procedure TfrmMain.UpdateStatus;
var
  Msg, ViewName: string;
begin
  if FFileName <> '' then
    Msg := FFileName
  else
    Msg := 'Файл не открыт';
  if FJsonRoot <> nil then
  begin
    Msg := Msg + '  |  JSON: ' + IntToStr(Length(memoJson.Text)) + ' симв.';
    if cboView.ItemIndex >= 0 then
    begin
      ViewName := cboView.Items[cboView.ItemIndex];
      Msg := Msg + '  |  вид: ' + ViewName;
    end;
  end;
  if FModified then
    Msg := Msg + '  |  изменён';
  StatusBar.SimpleText := Msg;
end;

procedure TfrmMain.ClearDocument;
begin
  FreeAndNil(FJsonRoot);
  FFileName := '';
  FLastSearchNode := nil;
  TreeJson.Items.Clear;
  FNodeKeys.Clear;
  cboView.Items.Clear;
  cboView.Enabled := False;
  edtSearch.Clear;
  edtSearch.Enabled := False;
  btnFindNext.Enabled := False;
  btnFindPrev.Enabled := False;
  lblPath.Caption := '';
  memoValue.Clear;
  memoJson.Clear;
  btnApply.Enabled := False;
  SetModified(False);
end;

function TfrmMain.GetViewRoot: TJSONValue;
begin
  Result := FJsonRoot;
  if (FJsonRoot = nil) or (cboView.ItemIndex < 0) then
    Exit;
  if cboView.ItemIndex = 0 then
    Exit;
  if cboView.Items.Objects[cboView.ItemIndex] <> nil then
    Result := TJSONValue(cboView.Items.Objects[cboView.ItemIndex]);
end;

procedure TfrmMain.RefreshViewCombo;
begin
  FUpdating := True;
  try
    cboView.Items.Clear;
    if FJsonRoot = nil then
    begin
      cboView.Enabled := False;
      Exit;
    end;
    FillSaveViewList(FJsonRoot, cboView.Items);
    cboView.ItemIndex := 0;
    cboView.Enabled := cboView.Items.Count > 1;
    edtSearch.Enabled := True;
    btnFindNext.Enabled := True;
    btnFindPrev.Enabled := True;
  finally
    FUpdating := False;
  end;
end;

procedure TfrmMain.SyncJsonMemo;
var
  View: TJSONValue;
begin
  View := GetViewRoot;
  if View = nil then
    memoJson.Clear
  else
  begin
    FUpdating := True;
    try
      if (cboView.ItemIndex > 0) and (View <> FJsonRoot) then
        memoJson.Lines.Text := FormatJson(View)
      else
        memoJson.Lines.Text := FormatJson(FJsonRoot);
    finally
      FUpdating := False;
    end;
  end;
end;

procedure TfrmMain.BuildTreeNode(ANode: TTreeNode; AValue: TJSONValue; const AName: string);
var
  I: Integer;
  Child: TTreeNode;
  Pair: TJSONPair;
  Obj: TJSONObject;
  Arr: TJSONArray;
  LabelText: string;
begin
  if AValue = nil then
    Exit;

  if AName <> '' then
    LabelText := AName + ': '
  else
    LabelText := '';

  if AValue is TJSONObject then
  begin
    Obj := TJSONObject(AValue);
    if AName = '' then
      ANode.Text := 'Object {' + IntToStr(Obj.Count) + '}'
    else
      ANode.Text := LabelText + '{' + IntToStr(Obj.Count) + '}';
    for Pair in Obj do
    begin
      Child := TreeJson.Items.AddChild(ANode, Pair.JsonString.Value);
      FNodeKeys.Add(Child, Pair.JsonString.Value);
      BuildTreeNode(Child, Pair.JsonValue, Pair.JsonString.Value);
    end;
  end
  else if AValue is TJSONArray then
  begin
    Arr := TJSONArray(AValue);
    if AName = '' then
      ANode.Text := 'Array [' + IntToStr(Arr.Count) + ']'
    else
      ANode.Text := LabelText + '[' + IntToStr(Arr.Count) + ']';
    for I := 0 to Arr.Count - 1 do
    begin
      Child := TreeJson.Items.AddChild(ANode, '[' + IntToStr(I) + ']');
      FNodeKeys.Add(Child, IntToStr(I));
      BuildTreeNode(Child, Arr.Items[I], '[' + IntToStr(I) + ']');
    end;
  end
  else if AValue is TJSONString then
    ANode.Text := LabelText + '"' + TJSONString(AValue).Value + '"'
  else if AValue is TJSONNumber then
    ANode.Text := LabelText + TJSONNumber(AValue).ToString
  else if AValue is TJSONTrue then
    ANode.Text := LabelText + 'true'
  else if AValue is TJSONFalse then
    ANode.Text := LabelText + 'false'
  else if AValue is TJSONNull then
    ANode.Text := LabelText + 'null'
  else
    ANode.Text := LabelText + AValue.ToJSON;

  if ANode.Data = nil then
    ANode.Data := AValue;
end;

function TfrmMain.ReplaceNodeJsonValue(ANode: TTreeNode; ANewValue: TJSONValue): Boolean;
var
  ParentNode: TTreeNode;
  ParentVal: TJSONValue;
  Obj: TJSONObject;
  Arr: TJSONArray;
  Pair: TJSONPair;
  Key: string;
  Idx, I: Integer;
  Snapshot: TList<TJSONValue>;
begin
  Result := False;
  if (ANode = nil) or (ANewValue = nil) then
  begin
    ANewValue.Free;
    Exit;
  end;

  ParentNode := ANode.Parent;
  if ParentNode = nil then
  begin
    FreeAndNil(FJsonRoot);
    FJsonRoot := ANewValue;
    ANode.Data := ANewValue;
    RefreshViewCombo;
    Exit(True);
  end;

  ParentVal := TJSONValue(ParentNode.Data);
  if ParentVal is TJSONObject then
  begin
    Obj := TJSONObject(ParentVal);
    if not FNodeKeys.TryGetValue(ANode, Key) then
      Exit;
    Pair := Obj.RemovePair(Key);
    if Pair = nil then
      Exit;
    Pair.JsonValue.Free;
    Pair.Free;
    Obj.AddPair(Key, ANewValue);
    ANode.Data := ANewValue;
    Result := True;
  end
  else if ParentVal is TJSONArray then
  begin
    Arr := TJSONArray(ParentVal);
    if not FNodeKeys.TryGetValue(ANode, Key) then
      Exit;
    if not TryStrToInt(Key, Idx) then
      Exit;
    if (Idx < 0) or (Idx >= Arr.Count) then
      Exit;
    Snapshot := TList<TJSONValue>.Create;
    try
      for I := 0 to Arr.Count - 1 do
        Snapshot.Add(Arr.Items[I]);
      Snapshot[Idx].Free;
      Snapshot[Idx] := ANewValue;
      while Arr.Count > 0 do
        Arr.Remove(0);
      for I := 0 to Snapshot.Count - 1 do
        Arr.AddElement(Snapshot[I]);
    finally
      Snapshot.Free;
    end;
    ANode.Data := ANewValue;
    Result := True;
  end
  else
    ANewValue.Free;
end;

procedure TfrmMain.RebuildTree;
var
  Root: TTreeNode;
  View: TJSONValue;
begin
  FLastSearchNode := nil;
  TreeJson.Items.BeginUpdate;
  try
    TreeJson.Items.Clear;
    FNodeKeys.Clear;
    View := GetViewRoot;
    if View <> nil then
    begin
      if cboView.ItemIndex = 0 then
        Root := TreeJson.Items.Add(nil, 'save')
      else
        Root := TreeJson.Items.Add(nil, cboView.Text);
      BuildTreeNode(Root, View, '');
      Root.Expand(False);
    end;
  finally
    TreeJson.Items.EndUpdate;
  end;
end;

function TfrmMain.SelectedJsonValue: TJSONValue;
begin
  Result := nil;
  if (TreeJson.Selected <> nil) and (TreeJson.Selected.Data <> nil) then
    Result := TJSONValue(TreeJson.Selected.Data);
end;

procedure TfrmMain.ShowNodeValue(ANode: TTreeNode);
var
  Val: TJSONValue;
begin
  memoValue.Clear;
  btnApply.Enabled := False;
  if ANode = nil then
  begin
    lblPath.Caption := '';
    Exit;
  end;

  lblPath.Caption := TreeNodePath(ANode);
  Val := TJSONValue(ANode.Data);
  if Val = nil then
    Exit;

  FUpdating := True;
  try
    if (Val is TJSONObject) or (Val is TJSONArray) then
    begin
      memoValue.Lines.Text := FormatJson(Val);
      memoValue.ReadOnly := True;
      btnApply.Enabled := False;
    end
    else
    begin
      memoValue.ReadOnly := False;
      if Val is TJSONString then
        memoValue.Text := TJSONString(Val).Value
      else
        memoValue.Text := Val.ToJSON;
      btnApply.Enabled := True;
    end;
  finally
    FUpdating := False;
  end;
end;

function TfrmMain.TreeNodePath(ANode: TTreeNode): string;
var
  Parts: TStringList;
  N: TTreeNode;
begin
  Parts := TStringList.Create;
  try
    Parts.Delimiter := '\';
    Parts.StrictDelimiter := True;
    N := ANode;
    while N <> nil do
    begin
      Parts.Insert(0, N.Text);
      N := N.Parent;
    end;
    Result := Parts.DelimitedText;
  finally
    Parts.Free;
  end;
end;

procedure TfrmMain.UpdateNodeCaption(ANode: TTreeNode; AValue: TJSONValue);
var
  S: string;
  P: Integer;
begin
  if (ANode = nil) or (AValue = nil) then
    Exit;
  S := ANode.Text;
  P := Pos(': ', S);
  if P > 0 then
    S := Copy(S, 1, P + 1)
  else
    S := '';
  if AValue is TJSONString then
    ANode.Text := S + '"' + TJSONString(AValue).Value + '"'
  else if AValue is TJSONNumber then
    ANode.Text := S + TJSONNumber(AValue).ToString
  else if AValue is TJSONTrue then
    ANode.Text := S + 'true'
  else if AValue is TJSONFalse then
    ANode.Text := S + 'false'
  else if AValue is TJSONNull then
    ANode.Text := S + 'null';
end;

function TfrmMain.ApplyValueFromMemo(AValue: TJSONValue): Boolean;
var
  S, JsonFrag: string;
  Num: Double;
  NewVal: TJSONValue;
  Node: TTreeNode;
begin
  Result := False;
  if AValue = nil then
    Exit;

  Node := TreeJson.Selected;
  S := memoValue.Text;

  if AValue is TJSONString then
    NewVal := TJSONString.Create(S)
  else if AValue is TJSONNumber then
  begin
    if not TryStrToFloat(StringReplace(S, '.', FormatSettings.DecimalSeparator, []), Num) then
    begin
      MessageDlg('Некорректное число.', mtError, [mbOK], 0);
      Exit;
    end;
    NewVal := TJSONNumber.Create(Num);
  end
  else if (AValue is TJSONTrue) or (AValue is TJSONFalse) then
  begin
    MessageDlg('Для логических значений используйте вкладку JSON.', mtInformation, [mbOK], 0);
    Exit;
  end
  else if AValue is TJSONNull then
  begin
    if not SameText(S, 'null') then
    begin
      MessageDlg('Для null используйте вкладку JSON.', mtInformation, [mbOK], 0);
      Exit;
    end;
    NewVal := TJSONNull.Create;
  end
  else
    Exit;

  JsonFrag := NewVal.ToJSON;
  NewVal.Free;
  NewVal := TJSONObject.ParseJSONValue(JsonFrag);
  if NewVal = nil then
    Exit;

  Result := ReplaceNodeJsonValue(Node, NewVal);
  if not Result then
    NewVal.Free;
end;

function TfrmMain.NodeMatchesSearch(ANode: TTreeNode; const ASearch: string): Boolean;
begin
  Result := (ANode <> nil) and (ASearch <> '') and
    (Pos(UpperCase(ASearch), UpperCase(ANode.Text)) > 0);
end;

procedure TfrmMain.CollectNodes(ANode: TTreeNode; AList: TList<TTreeNode>);
var
  N: TTreeNode;
begin
  if ANode = nil then
    Exit;
  AList.Add(ANode);
  N := ANode.getFirstChild;
  while N <> nil do
  begin
    CollectNodes(N, AList);
    N := N.getNextSibling;
  end;
end;

function TfrmMain.FindSearchNode(AForward: Boolean): TTreeNode;
var
  All: TList<TTreeNode>;
  Search: string;
  I, StartIdx: Integer;
begin
  Result := nil;
  Search := Trim(edtSearch.Text);
  if (Search = '') or (TreeJson.Items.Count = 0) then
    Exit;

  All := TList<TTreeNode>.Create;
  try
    CollectNodes(TreeJson.Items.GetFirstNode, All);
    if All.Count = 0 then
      Exit;

    StartIdx := 0;
    if FLastSearchNode <> nil then
    begin
      I := All.IndexOf(FLastSearchNode);
      if I >= 0 then
        StartIdx := I;
    end
    else if TreeJson.Selected <> nil then
    begin
      I := All.IndexOf(TreeJson.Selected);
      if I >= 0 then
        StartIdx := I;
    end;

    for I := 1 to All.Count do
    begin
      if AForward then
        StartIdx := (StartIdx + 1) mod All.Count
      else
      begin
        StartIdx := StartIdx - 1;
        if StartIdx < 0 then
          StartIdx := All.Count - 1;
      end;
      if NodeMatchesSearch(All[StartIdx], Search) then
        Exit(All[StartIdx]);
    end;
  finally
    All.Free;
  end;
end;

procedure TfrmMain.FocusSearchNode(ANode: TTreeNode);
var
  N: TTreeNode;
begin
  if ANode = nil then
    Exit;
  N := ANode.Parent;
  while N <> nil do
  begin
    N.Expanded := True;
    N := N.Parent;
  end;
  TreeJson.Selected := ANode;
  ANode.MakeVisible;
  FLastSearchNode := ANode;
  ShowNodeValue(ANode);
end;

procedure TfrmMain.ApplyJsonFromText(const AJsonText: string);
var
  NewRoot: TJSONValue;
begin
  NewRoot := ParseJsonText(AJsonText);
  try
    FreeAndNil(FJsonRoot);
    FJsonRoot := NewRoot;
    NewRoot := nil;
    RefreshViewCombo;
    SyncJsonMemo;
    RebuildTree;
    SetModified(True);
  finally
    NewRoot.Free;
  end;
end;

procedure TfrmMain.LoadDocument(const AFileName: string);
var
  Json: TJSONValue;
begin
  Json := nil;
  try
    LoadSaveFromFile(AFileName, Json);
    ClearDocument;
    FJsonRoot := Json;
    FFileName := AFileName;
    RefreshViewCombo;
    SyncJsonMemo;
    RebuildTree;
    SetModified(False);
  except
    on E: Exception do
    begin
      Json.Free;
      MessageDlg('Ошибка открытия: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMain.SaveDocument(const AFileName: string);
begin
  if FJsonRoot = nil then
    Exit;
  try
    if PageControl.ActivePage = tabJson then
    begin
      if cboView.ItemIndex > 0 then
        MessageDlg('На вкладке JSON отображается выбранный фрагмент. ' +
          'Для сохранения всего .save переключите «Просмотр» на «Весь файл» или примените правки через дерево.',
          mtInformation, [mbOK], 0)
      else
      begin
        FreeAndNil(FJsonRoot);
        FJsonRoot := ParseJsonText(memoJson.Text);
        RefreshViewCombo;
        RebuildTree;
      end;
    end;
    SaveSaveToFile(AFileName, FJsonRoot);
    FFileName := AFileName;
    SetModified(False);
    SyncJsonMemo;
  except
    on E: Exception do
      MessageDlg('Ошибка сохранения: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

function TfrmMain.ConfirmSaveIfModified: Boolean;
var
  R: Integer;
begin
  Result := True;
  if not FModified then
    Exit;
  R := MessageDlg('Сохранить изменения?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
  case R of
    mrYes:
      begin
        if FFileName = '' then
        begin
          if SaveDialog.Execute then
            SaveDocument(SaveDialog.FileName);
        end
        else
          SaveDocument(FFileName);
        Result := not FModified;
      end;
    mrNo:
      Result := True;
    mrCancel:
      Result := False;
  end;
end;

procedure TfrmMain.mnuOpenClick(Sender: TObject);
begin
  if not ConfirmSaveIfModified then
    Exit;
  OpenDialog.FileName := FFileName;
  if OpenDialog.Execute then
    LoadDocument(OpenDialog.FileName);
end;

procedure TfrmMain.mnuSaveClick(Sender: TObject);
begin
  if FJsonRoot = nil then
    Exit;
  if FFileName = '' then
    mnuSaveAsClick(Sender)
  else
    SaveDocument(FFileName);
end;

procedure TfrmMain.mnuSaveAsClick(Sender: TObject);
begin
  if FJsonRoot = nil then
    Exit;
  SaveDialog.FileName := FFileName;
  if SaveDialog.Execute then
    SaveDocument(SaveDialog.FileName);
end;

procedure TfrmMain.mnuExportJsonClick(Sender: TObject);
var
  View: TJSONValue;
  BaseName, OutName: string;
begin
  if FJsonRoot = nil then
    Exit;
  View := GetViewRoot;
  if View = nil then
    Exit;

  BaseName := FFileName;
  if BaseName = '' then
    BaseName := 'save'
  else
    BaseName := ChangeFileExt(BaseName, '');
  if cboView.ItemIndex > 0 then
    OutName := BaseName + '_' + StringReplace(cboView.Text, ' — ', '_', [rfReplaceAll]) + '.json'
  else
    OutName := BaseName + '.json';
  OutName := StringReplace(OutName, ':', '_', [rfReplaceAll]);
  OutName := StringReplace(OutName, '\', '_', [rfReplaceAll]);
  OutName := StringReplace(OutName, '/', '_', [rfReplaceAll]);

  JsonSaveDialog.FileName := OutName;
  if not JsonSaveDialog.Execute then
    Exit;

  TFile.WriteAllText(JsonSaveDialog.FileName, FormatJson(View), TEncoding.UTF8);
  MessageDlg('Экспортировано: ' + JsonSaveDialog.FileName, mtInformation, [mbOK], 0);
end;

procedure TfrmMain.mnuImportJsonClick(Sender: TObject);
var
  Text: string;
begin
  if not ConfirmSaveIfModified then
    Exit;
  if not JsonOpenDialog.Execute then
    Exit;
  Text := TFile.ReadAllText(JsonOpenDialog.FileName, TEncoding.UTF8);
  try
    ApplyJsonFromText(Text);
    FFileName := '';
    UpdateCaption;
    MessageDlg('JSON загружен. Сохраните как .save, чтобы использовать в игре.',
      mtInformation, [mbOK], 0);
  except
    on E: Exception do
      MessageDlg('Ошибка импорта: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  if ConfirmSaveIfModified then
    Close;
end;

procedure TfrmMain.TreeJsonChange(Sender: TObject; Node: TTreeNode);
begin
  ShowNodeValue(Node);
end;

procedure TfrmMain.btnApplyClick(Sender: TObject);
var
  Val: TJSONValue;
  Node: TTreeNode;
begin
  Val := SelectedJsonValue;
  if not ApplyValueFromMemo(Val) then
    Exit;
  Node := TreeJson.Selected;
  UpdateNodeCaption(Node, Val);
  SyncJsonMemo;
  SetModified(True);
end;

procedure TfrmMain.memoJsonChange(Sender: TObject);
begin
  if FUpdating then
    Exit;
  SetModified(True);
end;

procedure TfrmMain.mnuFormatJsonClick(Sender: TObject);
var
  View: TJSONValue;
begin
  View := GetViewRoot;
  if View = nil then
    Exit;
  try
    FUpdating := True;
    memoJson.Lines.Text := FormatJson(View);
    SetModified(True);
  finally
    FUpdating := False;
  end;
end;

procedure TfrmMain.mnuReloadTreeClick(Sender: TObject);
var
  Parsed: TJSONValue;
begin
  if FJsonRoot = nil then
    Exit;
  try
    Parsed := ParseJsonText(memoJson.Text);
    try
      if cboView.ItemIndex = 0 then
      begin
        FreeAndNil(FJsonRoot);
        FJsonRoot := Parsed;
        Parsed := nil;
        RefreshViewCombo;
      end
      else
        MessageDlg('Применение JSON из фрагмента к полному файлу пока не поддерживается. ' +
          'Выберите «Весь файл» или правьте через дерево.', mtInformation, [mbOK], 0);
      RebuildTree;
      SetModified(True);
    finally
      Parsed.Free;
    end;
  except
    on E: Exception do
      MessageDlg('JSON: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmMain.PageControlChange(Sender: TObject);
begin
  if FUpdating or (FJsonRoot = nil) then
    Exit;
  if PageControl.ActivePage = tabJson then
    SyncJsonMemo;
end;

procedure TfrmMain.cboViewChange(Sender: TObject);
begin
  if FUpdating or (FJsonRoot = nil) then
    Exit;
  FLastSearchNode := nil;
  RebuildTree;
  SyncJsonMemo;
  UpdateStatus;
end;

procedure TfrmMain.btnFindNextClick(Sender: TObject);
var
  N: TTreeNode;
begin
  if PageControl.ActivePage <> tabTree then
    PageControl.ActivePage := tabTree;
  N := FindSearchNode(True);
  if N <> nil then
    FocusSearchNode(N)
  else
    MessageDlg('Ничего не найдено: «' + Trim(edtSearch.Text) + '»', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.btnFindPrevClick(Sender: TObject);
var
  N: TTreeNode;
begin
  if PageControl.ActivePage <> tabTree then
    PageControl.ActivePage := tabTree;
  N := FindSearchNode(False);
  if N <> nil then
    FocusSearchNode(N)
  else
    MessageDlg('Ничего не найдено: «' + Trim(edtSearch.Text) + '»', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F3 then
  begin
    if ssShift in Shift then
      btnFindPrevClick(nil)
    else
      btnFindNextClick(nil);
    Key := 0;
  end
  else if Key = VK_RETURN then
  begin
    btnFindNextClick(nil);
    Key := 0;
  end;
end;

procedure TfrmMain.mnuFindClick(Sender: TObject);
begin
  PageControl.ActivePage := tabTree;
  edtSearch.SetFocus;
  edtSearch.SelectAll;
end;

end.
