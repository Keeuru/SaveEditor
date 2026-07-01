unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.IOUtils, System.Generics.Collections, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.AppEvnts, XSuperObject, XSuperJSON, SaveCodec, SaveSlots,
  Vcl.Buttons, FontAwesome;

type
  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    JsonSaveDialog: TSaveDialog;
    JsonOpenDialog: TOpenDialog;
    StatusBar: TStatusBar;
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
    gpFolderPath: TGridPanel;
    edtFolderPath: TEdit;
    spbFolderSelect: TSpeedButton;
    lbFilesList: TListBox;
    ApplicationEvents: TApplicationEvents;
    splEditJSON: TSplitter;
    gpMainButtons: TGridPanel;
    spbOpenFolder: TSpeedButton;
    spbSaveFile: TSpeedButton;
    spbSaveFileAs: TSpeedButton;
    spbExportJson: TSpeedButton;
    spbImportJson: TSpeedButton;
    spbOpenFile: TSpeedButton;
    spbExitApp: TSpeedButton;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AppActivate(Sender: TObject);
    procedure AppIdle(Sender: TObject; var Done: Boolean);
    procedure OpenFileClick(Sender: TObject);
    procedure SaveFileClick(Sender: TObject);
    procedure SaveFileAsClick(Sender: TObject);
    procedure ExportJsonClick(Sender: TObject);
    procedure ImportJsonClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure TreeJsonChange(Sender: TObject; Node: TTreeNode);
    procedure btnApplyClick(Sender: TObject);
    procedure memoValueChange(Sender: TObject);
    procedure memoValueExit(Sender: TObject);
    procedure memoValueKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure memoJsonChange(Sender: TObject);
    procedure mnuFormatJsonClick(Sender: TObject);
    procedure mnuReloadTreeClick(Sender: TObject);
    procedure cboViewChange(Sender: TObject);
    procedure btnFindNextClick(Sender: TObject);
    procedure btnFindPrevClick(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mnuFindClick(Sender: TObject);
    procedure spbFolderSelectClick(Sender: TObject);
    procedure edtFolderPathKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbFilesListDblClick(Sender: TObject);
    procedure edtFolderPathEnter(Sender: TObject);
    procedure OpenFolderClick(Sender: TObject);
  private
    FJsonRoot: ISuperObject;
    FNodeKeys: TDictionary<TTreeNode, string>;
    FFileName: string;
    FModified: Boolean;
    FUpdating: Boolean;
    FLastSearchNode: TTreeNode;
    FDirChangeHandle: THandle;
    FMemoNode: TTreeNode;
    FMemoDirty: Boolean;
    FJsonMemoDirty: Boolean;
    procedure SetModified(AValue: Boolean);
    procedure UpdateCaption;
    procedure UpdateStatus;
    procedure ClearDocument;
    procedure LoadDocument(const AFileName: string);
    procedure SaveDocument(const AFileName: string);
    function ConfirmSaveIfModified: Boolean;
    procedure SyncJsonMemo;
    procedure RefreshViewCombo;
    function GetViewRoot: IJSONAncestor;
    procedure RebuildTree;
    procedure BuildTreeNode(ANode: TTreeNode; AValue: IJSONAncestor; const AName: string);
    function SelectedJsonValue: IJSONAncestor;
    procedure ShowNodeValue(ANode: TTreeNode);
    procedure UpdateNodeCaption(ANode: TTreeNode; AValue: IJSONAncestor);
    function TreeNodePath(ANode: TTreeNode): string;
    function ReplaceNodeJsonValue(ANode: TTreeNode; ANewValue: IJSONAncestor): Boolean;
    function ApplyValueFromMemo(AValue: IJSONAncestor; ANode: TTreeNode): Boolean;
    function ApplyMemoIfDirty: Boolean;
    function NodeMatchesSearch(ANode: TTreeNode; const ASearch: string): Boolean;
    procedure CollectNodes(ANode: TTreeNode; AList: TList<TTreeNode>);
    function FindSearchNode(AForward: Boolean): TTreeNode;
    procedure FocusSearchNode(ANode: TTreeNode);
    procedure ApplyJsonFromText(const AJsonText: string);
    function PickFolder(var ADirectory: string): Boolean;
    procedure RefreshSaveFilesList(AShowErrors: Boolean = True);
    procedure StartFolderWatch;
    procedure StopFolderWatch;
    procedure CheckFolderWatch;
    procedure OnApplicationActivated;
    procedure SetupSpeedButtons;
    procedure UpdateFolderPanelVisibility;
  protected
    procedure WMActivateApp(var Message: TWMActivateApp); message WM_ACTIVATEAPP;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

function NodeJson(ANode: TTreeNode): IJSONAncestor;
begin
  Result := nil;
  if (ANode <> nil) and (ANode.Data <> nil) then
    Result := IJSONAncestor(ANode.Data);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDirChangeHandle := 0;
  FMemoNode := nil;
  FMemoDirty := False;
  FJsonMemoDirty := False;
  FNodeKeys := TDictionary<TTreeNode, string>.Create;
  OpenDialog.Filter := 'Файлы сохранения (*.save)|*.save|Все файлы (*.*)|*.*';
  SaveDialog.Filter := OpenDialog.Filter;
  JsonSaveDialog.Filter := 'JSON (*.json)|*.json|Все файлы (*.*)|*.*';
  JsonSaveDialog.DefaultExt := 'json';
  JsonOpenDialog.Filter := JsonSaveDialog.Filter;
  ClearDocument;
  SetupSpeedButtons;
  UpdateFolderPanelVisibility;
  if ParamCount >= 1 then
    LoadDocument(ParamStr(1));
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  StopFolderWatch;
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
  FJsonRoot := nil;
  FFileName := '';
  FLastSearchNode := nil;
  FMemoNode := nil;
  FMemoDirty := False;
  FJsonMemoDirty := False;
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

function TfrmMain.GetViewRoot: IJSONAncestor;
begin
  Result := nil;
  if FJsonRoot = nil then
    Exit;
  if (cboView.ItemIndex < 0) or (cboView.ItemIndex = 0) then
    Exit(JsonRootAncestor(FJsonRoot));
  if cboView.Items.Objects[cboView.ItemIndex] <> nil then
    Result := IJSONAncestor(Pointer(cboView.Items.Objects[cboView.ItemIndex]));
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
  View: IJSONAncestor;
begin
  View := GetViewRoot;
  if View = nil then
    memoJson.Clear
  else
  begin
    FUpdating := True;
    try
      memoJson.Lines.Text := FormatJson(View);
    finally
      FUpdating := False;
      FJsonMemoDirty := False;
    end;
  end;
end;

procedure TfrmMain.BuildTreeNode(ANode: TTreeNode; AValue: IJSONAncestor; const AName: string);
var
  I: Integer;
  Child: TTreeNode;
  Obj: ISuperObject;
  Arr: ISuperArray;
  LabelText: string;
  ValueCast: ICast;
  Key: string;
begin
  if AValue = nil then
    Exit;

  if AName <> '' then
    LabelText := AName + ': '
  else
    LabelText := '';

  ValueCast := TCast.Create(AValue);
  case ValueCast.DataType of
    dtObject:
      begin
        Obj := ValueCast.AsObject;
        if AName = '' then
          ANode.Text := 'Object {' + IntToStr(Obj.Count) + '}'
        else
          ANode.Text := LabelText + '{' + IntToStr(Obj.Count) + '}';
        Obj.First;
        while not Obj.EoF do
        begin
          Key := Obj.CurrentKey;
          Child := TreeJson.Items.AddChild(ANode, Key);
          FNodeKeys.Add(Child, Key);
          BuildTreeNode(Child, Obj.CurrentValue, Key);
          Obj.Next;
        end;
      end;
    dtArray:
      begin
        Arr := ValueCast.AsArray;
        if AName = '' then
          ANode.Text := 'Array [' + IntToStr(Arr.Length) + ']'
        else
          ANode.Text := LabelText + '[' + IntToStr(Arr.Length) + ']';
        for I := 0 to Arr.Length - 1 do
        begin
          Child := TreeJson.Items.AddChild(ANode, '[' + IntToStr(I) + ']');
          FNodeKeys.Add(Child, IntToStr(I));
          BuildTreeNode(Child, Arr.Ancestor[I], '[' + IntToStr(I) + ']');
        end;
      end;
    dtString:
      ANode.Text := LabelText + '"' + ValueCast.AsString + '"';
    dtInteger:
      ANode.Text := LabelText + IntToStr(ValueCast.AsInteger);
    dtFloat:
      ANode.Text := LabelText + FloatToStr(ValueCast.AsFloat);
    dtBoolean:
      if ValueCast.AsBoolean then
        ANode.Text := LabelText + 'true'
      else
        ANode.Text := LabelText + 'false';
    dtNull:
      ANode.Text := LabelText + 'null';
  else
    ANode.Text := LabelText + JsonToCompact(AValue);
  end;

  if ANode.Data = nil then
    ANode.Data := Pointer(AValue);
end;

function TfrmMain.ReplaceNodeJsonValue(ANode: TTreeNode; ANewValue: IJSONAncestor): Boolean;
var
  ParentNode: TTreeNode;
  ParentVal: IJSONAncestor;
  ParentCast: ICast;
  Obj: ISuperObject;
  Arr: ISuperArray;
  Key: string;
  Idx, I: Integer;
  Snapshot: TList<IJSONAncestor>;
begin
  Result := False;
  if (ANode = nil) or (ANewValue = nil) then
    Exit;

  ParentNode := ANode.Parent;
  if ParentNode = nil then
  begin
    FJsonRoot := SO(JsonToCompact(ANewValue));
    ANode.Data := Pointer(JsonRootAncestor(FJsonRoot));
    RefreshViewCombo;
    Exit(True);
  end;

  ParentVal := NodeJson(ParentNode);
  if ParentVal = nil then
    Exit;

  ParentCast := TCast.Create(ParentVal);
  if ParentCast.DataType = dtObject then
  begin
    Obj := ParentCast.AsObject;
    if not FNodeKeys.TryGetValue(ANode, Key) then
      Exit;
    Obj.Remove(Key);
    Obj.Add(Key, ANewValue);
    ANode.Data := Pointer(ANewValue);
    Result := True;
  end
  else if ParentCast.DataType = dtArray then
  begin
    Arr := ParentCast.AsArray;
    if not FNodeKeys.TryGetValue(ANode, Key) then
      Exit;
    if not TryStrToInt(Key, Idx) then
      Exit;
    if (Idx < 0) or (Idx >= Arr.Length) then
      Exit;
    Snapshot := TList<IJSONAncestor>.Create;
    try
      for I := 0 to Arr.Length - 1 do
        Snapshot.Add(Arr.Ancestor[I]);
      Snapshot[Idx] := ANewValue;
      Arr.Clear;
      for I := 0 to Snapshot.Count - 1 do
        Arr.Add(Snapshot[I]);
    finally
      Snapshot.Free;
    end;
    ANode.Data := Pointer(ANewValue);
    Result := True;
  end;
end;

procedure TfrmMain.RebuildTree;
var
  Root: TTreeNode;
  View: IJSONAncestor;
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

function TfrmMain.SelectedJsonValue: IJSONAncestor;
begin
  Result := NodeJson(TreeJson.Selected);
end;

procedure TfrmMain.ShowNodeValue(ANode: TTreeNode);
var
  Val: IJSONAncestor;
  ValueCast: ICast;
begin
  memoValue.Clear;
  btnApply.Enabled := False;
  if ANode = nil then
  begin
    lblPath.Caption := '';
    FMemoNode := nil;
    FMemoDirty := False;
    Exit;
  end;

  lblPath.Caption := TreeNodePath(ANode);
  Val := NodeJson(ANode);
  if Val = nil then
  begin
    FMemoNode := ANode;
    FMemoDirty := False;
    Exit;
  end;

  FUpdating := True;
  try
    ValueCast := TCast.Create(Val);
    if ValueCast.DataType in [dtObject, dtArray] then
    begin
      memoValue.Lines.Text := FormatJson(Val);
      memoValue.ReadOnly := True;
      btnApply.Enabled := False;
    end
    else
    begin
      memoValue.ReadOnly := False;
      if ValueCast.DataType = dtString then
        memoValue.Text := ValueCast.AsString
      else
        memoValue.Text := JsonToCompact(Val);
      btnApply.Enabled := True;
    end;
  finally
    FUpdating := False;
  end;
  FMemoNode := ANode;
  FMemoDirty := False;
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

procedure TfrmMain.UpdateNodeCaption(ANode: TTreeNode; AValue: IJSONAncestor);
var
  S: string;
  P: Integer;
  ValueCast: ICast;
begin
  if (ANode = nil) or (AValue = nil) then
    Exit;
  S := ANode.Text;
  P := Pos(': ', S);
  if P > 0 then
    S := Copy(S, 1, P + 1)
  else
    S := '';
  ValueCast := TCast.Create(AValue);
  case ValueCast.DataType of
    dtString:
      ANode.Text := S + '"' + ValueCast.AsString + '"';
    dtInteger:
      ANode.Text := S + IntToStr(ValueCast.AsInteger);
    dtFloat:
      ANode.Text := S + FloatToStr(ValueCast.AsFloat);
    dtBoolean:
      if ValueCast.AsBoolean then
        ANode.Text := S + 'true'
      else
        ANode.Text := S + 'false';
    dtNull:
      ANode.Text := S + 'null';
  end;
end;

function TfrmMain.ApplyValueFromMemo(AValue: IJSONAncestor; ANode: TTreeNode): Boolean;
var
  S: string;
  Num: Double;
  IntVal: Int64;
  NewVal: IJSONAncestor;
  ValueCast: ICast;
begin
  Result := False;
  if (AValue = nil) or (ANode = nil) then
    Exit;

  S := memoValue.Text;
  ValueCast := TCast.Create(AValue);

  case ValueCast.DataType of
    dtString:
      NewVal := TJSONString.Create(S);
    dtInteger:
      begin
        if TryStrToInt64(StringReplace(S, '.', FormatSettings.DecimalSeparator, []), IntVal) then
          NewVal := TJSONInteger.Create(IntVal)
        else if TryStrToFloat(StringReplace(S, '.', FormatSettings.DecimalSeparator, []), Num) then
          NewVal := TJSONInteger.Create(Trunc(Num))
        else
        begin
          MessageDlg('Некорректное число.', mtError, [mbOK], 0);
          Exit;
        end;
      end;
    dtFloat:
      begin
        if not TryStrToFloat(StringReplace(S, '.', FormatSettings.DecimalSeparator, []), Num) then
        begin
          MessageDlg('Некорректное число.', mtError, [mbOK], 0);
          Exit;
        end;
        NewVal := TJSONFloat.Create(Num);
      end;
    dtBoolean:
      begin
        MessageDlg('Для логических значений используйте поле JSON.', mtInformation, [mbOK], 0);
        Exit;
      end;
    dtNull:
      begin
        if not SameText(S, 'null') then
        begin
          MessageDlg('Для null используйте поле JSON.', mtInformation, [mbOK], 0);
          Exit;
        end;
        NewVal := TJSONNull.Create(True);
      end;
  else
    Exit;
  end;

  Result := ReplaceNodeJsonValue(ANode, NewVal);
end;

function TfrmMain.ApplyMemoIfDirty: Boolean;
var
  Node: TTreeNode;
  Val: IJSONAncestor;
begin
  Result := True;
  if not FMemoDirty or (FMemoNode = nil) or memoValue.ReadOnly then
    Exit;

  Node := FMemoNode;
  Val := NodeJson(Node);
  if Val = nil then
  begin
    FMemoDirty := False;
    Exit;
  end;

  if not ApplyValueFromMemo(Val, Node) then
    Exit(False);

  UpdateNodeCaption(Node, NodeJson(Node));
  SyncJsonMemo;
  SetModified(True);
  FMemoDirty := False;
end;

function TfrmMain.NodeMatchesSearch(ANode: TTreeNode; const ASearch: string): Boolean;
begin
  Result := (ANode <> nil) and (ASearch <> '') and (Pos(UpperCase(ASearch), UpperCase(ANode.Text)) > 0);
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
begin
  FJsonRoot := ParseJsonText(AJsonText);
  RefreshViewCombo;
  SyncJsonMemo;
  RebuildTree;
  SetModified(True);
end;

procedure TfrmMain.LoadDocument(const AFileName: string);
var
  Json: ISuperObject;
begin
  if not ApplyMemoIfDirty then
    Exit;
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
      Json := nil;
      MessageDlg('Ошибка открытия: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMain.SaveDocument(const AFileName: string);
begin
  if FJsonRoot = nil then
    Exit;
  if not ApplyMemoIfDirty then
    Exit;
  try
    if FJsonMemoDirty then
    begin
      if cboView.ItemIndex > 0 then
        MessageDlg('Отображается выбранный фрагмент. ' + 'Для сохранения всего .save выберите «Просмотр» на «Весь файл» или примените правки через дерево.', mtInformation, [mbOK], 0)
      else
      begin
        FJsonRoot := ParseJsonText(memoJson.Text);
        RefreshViewCombo;
        RebuildTree;
        FJsonMemoDirty := False;
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

procedure TfrmMain.OpenFileClick(Sender: TObject);
begin
  if not ConfirmSaveIfModified then
    Exit;
  OpenDialog.FileName := FFileName;
  if OpenDialog.Execute then
    LoadDocument(OpenDialog.FileName);
end;

procedure TfrmMain.SaveFileClick(Sender: TObject);
begin
  if FJsonRoot = nil then
    Exit;
  if FFileName = '' then
    SaveFileAsClick(Sender)
  else
    SaveDocument(FFileName);
end;

procedure TfrmMain.SaveFileAsClick(Sender: TObject);
begin
  if FJsonRoot = nil then
    Exit;
  SaveDialog.FileName := FFileName;
  if SaveDialog.Execute then
    SaveDocument(SaveDialog.FileName);
end;

procedure TfrmMain.ExportJsonClick(Sender: TObject);
var
  View: IJSONAncestor;
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

procedure TfrmMain.ImportJsonClick(Sender: TObject);
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
    MessageDlg('JSON загружен. Сохраните как .save, чтобы использовать в игре.', mtInformation, [mbOK], 0);
  except
    on E: Exception do
      MessageDlg('Ошибка импорта: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmMain.ExitClick(Sender: TObject);
begin
  if ConfirmSaveIfModified then
    Close;
end;

procedure TfrmMain.TreeJsonChange(Sender: TObject; Node: TTreeNode);
begin
  if FUpdating then
    Exit;
  if not ApplyMemoIfDirty then
  begin
    FUpdating := True;
    try
      if FMemoNode <> nil then
        TreeJson.Selected := FMemoNode;
    finally
      FUpdating := False;
    end;
    Exit;
  end;
  ShowNodeValue(Node);
end;

procedure TfrmMain.btnApplyClick(Sender: TObject);
begin
  FMemoNode := TreeJson.Selected;
  ApplyMemoIfDirty;
end;

procedure TfrmMain.memoValueChange(Sender: TObject);
begin
  if FUpdating or memoValue.ReadOnly then
    Exit;
  FMemoDirty := True;
end;

procedure TfrmMain.memoValueExit(Sender: TObject);
begin
  ApplyMemoIfDirty;
end;

procedure TfrmMain.memoValueKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (ssCtrl in Shift) then
  begin
    ApplyMemoIfDirty;
    Key := 0;
  end;
end;

procedure TfrmMain.memoJsonChange(Sender: TObject);
begin
  if FUpdating then
    Exit;
  FJsonMemoDirty := True;
  SetModified(True);
end;

procedure TfrmMain.mnuFormatJsonClick(Sender: TObject);
var
  View: IJSONAncestor;
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
begin
  if FJsonRoot = nil then
    Exit;
  try
    if cboView.ItemIndex = 0 then
    begin
      FJsonRoot := ParseJsonText(memoJson.Text);
      RefreshViewCombo;
      RebuildTree;
      SetModified(True);
      FJsonMemoDirty := False;
    end
    else
      MessageDlg('Применение JSON из фрагмента к полному файлу пока не поддерживается. ' +
        'Выберите «Весь файл» или правьте через дерево.', mtInformation, [mbOK], 0);
  except
    on E: Exception do
      MessageDlg('JSON: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmMain.cboViewChange(Sender: TObject);
begin
  if FUpdating or (FJsonRoot = nil) then
    Exit;
  if not ApplyMemoIfDirty then
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
  edtSearch.SetFocus;
  edtSearch.SelectAll;
end;

function TfrmMain.PickFolder(var ADirectory: string): Boolean;
var
  Dialog: TFileOpenDialog;
begin
  Result := False;
  Dialog := TFileOpenDialog.Create(nil);
  try
    Dialog.Title := 'Выбор папки с сохранениями';
    Dialog.Options := Dialog.Options + [fdoPickFolders, fdoPathMustExist];
    if ADirectory <> '' then
      Dialog.DefaultFolder := ADirectory;
    if Dialog.Execute then
    begin
      ADirectory := Dialog.FileName;
      Result := True;
    end;
  finally
    Dialog.Free;
  end;
end;

procedure TfrmMain.OnApplicationActivated;
begin
  CheckFolderWatch;
  RefreshSaveFilesList(False);
end;

procedure TfrmMain.AppActivate(Sender: TObject);
begin
  OnApplicationActivated;
end;

procedure TfrmMain.WMActivateApp(var Message: TWMActivateApp);
begin
  inherited;
  if Message.Active then
    OnApplicationActivated;
end;

procedure TfrmMain.AppIdle(Sender: TObject; var Done: Boolean);
begin
  CheckFolderWatch;
end;

procedure TfrmMain.StopFolderWatch;
begin
  if FDirChangeHandle <> 0 then
  begin
    FindCloseChangeNotification(FDirChangeHandle);
    FDirChangeHandle := 0;
  end;
end;

procedure TfrmMain.OpenFolderClick(Sender: TObject);
begin
  UpdateFolderPanelVisibility;
end;

procedure TfrmMain.StartFolderWatch;
var
  Folder: string;
begin
  StopFolderWatch;
  Folder := Trim(edtFolderPath.Text);
  if (Folder = '') or not TDirectory.Exists(Folder) then
    Exit;

  FDirChangeHandle := FindFirstChangeNotification(PChar(ExcludeTrailingPathDelimiter(Folder)), False, FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE);
  if FDirChangeHandle = INVALID_HANDLE_VALUE then
    FDirChangeHandle := 0;
end;

procedure TfrmMain.CheckFolderWatch;
begin
  if FDirChangeHandle = 0 then
    Exit;
  if WaitForSingleObject(FDirChangeHandle, 0) = WAIT_OBJECT_0 then
  begin
    FindNextChangeNotification(FDirChangeHandle);
    RefreshSaveFilesList(False);
  end;
end;

procedure TfrmMain.RefreshSaveFilesList(AShowErrors: Boolean);
var
  Folder: string;
  Files: TArray<string>;
  FileName: string;
  Names: TStringList;
  SelectedFile: string;
  SelectedIndex: Integer;
begin
  SelectedFile := '';
  if lbFilesList.ItemIndex >= 0 then
    SelectedFile := lbFilesList.Items[lbFilesList.ItemIndex];

  lbFilesList.Clear;
  Folder := Trim(edtFolderPath.Text);
  if Folder = '' then
  begin
    StopFolderWatch;
    Exit;
  end;
  if not TDirectory.Exists(Folder) then
  begin
    StopFolderWatch;
    if AShowErrors then
      MessageDlg('Папка не найдена: ' + Folder, mtError, [mbOK], 0);
    Exit;
  end;

  Files := TDirectory.GetFiles(Folder, '*.*', TSearchOption.soTopDirectoryOnly);
  Names := TStringList.Create;
  try
    Names.Sorted := True;
    for FileName in Files do
      if SameText(ExtractFileExt(FileName), '.save') then
        Names.Add(ExtractFileName(FileName));
    lbFilesList.Items.Assign(Names);
  finally
    Names.Free;
  end;

  if SelectedFile <> '' then
  begin
    SelectedIndex := lbFilesList.Items.IndexOf(SelectedFile);
    if SelectedIndex >= 0 then
      lbFilesList.ItemIndex := SelectedIndex;
  end;

  StartFolderWatch;
end;

procedure TfrmMain.spbFolderSelectClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := Trim(edtFolderPath.Text);
  if PickFolder(Dir) then
  begin
    edtFolderPath.Text := Dir;
    RefreshSaveFilesList;
  end;
end;

procedure TfrmMain.edtFolderPathEnter(Sender: TObject);
begin
  LoadKeyboardLayout('00000409'{ENG_KEYBOARD}, KLF_ACTIVATE);
end;

procedure TfrmMain.edtFolderPathKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    RefreshSaveFilesList;
    Key := 0;
  end;
end;

procedure TfrmMain.lbFilesListDblClick(Sender: TObject);
var
  FilePath: string;
begin
  if lbFilesList.ItemIndex < 0 then
    Exit;
  if not ConfirmSaveIfModified then
    Exit;
  FilePath := IncludeTrailingPathDelimiter(Trim(edtFolderPath.Text)) + lbFilesList.Items[lbFilesList.ItemIndex];
  LoadDocument(FilePath);
end;

procedure TfrmMain.SetupSpeedButtons;
begin
  if not RegisterFontAwesome then
    Exit;

  SetupSpeedButtonIcon(spbOpenFile, fa_file_o, 'Открыть файл...', 18, clNavy);
  SetupSpeedButtonIcon(spbSaveFile, fa_floppy_o, 'Сохранить', 18, clGreen);
  SetupSpeedButtonIcon(spbSaveFileAs, fa_files_o, 'Сохранить как...', 18, TColor($0080B000));
  SetupSpeedButtonIcon(spbExportJson, fa_download, 'Экспорт в JSON...', 18, clPurple);
  SetupSpeedButtonIcon(spbImportJson, fa_upload, 'Импорт из JSON...', 18, clMaroon);
  SetupSpeedButtonIcon(spbExitApp, fa_sign_out, 'Выход', 18, clGray);
  SetupSpeedButtonIcon(spbFolderSelect, fa_folder, 'Выбрать папку с сохранениями', 14, TColor($0000A0D0));
  UpdateFolderPanelVisibility;
end;

procedure TfrmMain.UpdateFolderPanelVisibility;
begin
  gpFolderPath.Visible := spbOpenFolder.Down;
  if spbOpenFolder.Down then
    SetupSpeedButtonIcon(spbOpenFolder, fa_folder_open, 'Скрыть панель папки', 18, clTeal)
  else
    SetupSpeedButtonIcon(spbOpenFolder, fa_folder_open, 'Показать панель папки', 18, clGray);
end;

end.

