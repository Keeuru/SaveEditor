unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.IOUtils, System.Generics.Collections, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.AppEvnts, Vcl.FileCtrl, System.IniFiles, XSuperObject,
  XSuperJSON, SaveCodec, Vcl.Buttons, FontAwesome, SynEdit,
  SynEditTypes, SynHighlighterJSON, SynEditHighlighter, SynEditCodeFolding,
  VirtualTrees, VirtualTrees.Types, VirtualTrees.Header,
  VirtualTrees.BaseAncestorVCL, VirtualTrees.BaseTree, VirtualTrees.AncestorVCL;

type
  TJsonNodePayload = class
  public
    JsonValue: IJSONAncestor;
    NodeKey: string;
    Caption: string;
    ValuePreview: string;
  end;

  PJsonNodeRef = ^TJsonNodeRef;

  TJsonNodeRef = record
    Payload: TJsonNodePayload;
  end;

  TfrmMain = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    JsonSaveDialog: TSaveDialog;
    JsonOpenDialog: TOpenDialog;
    StatusBar: TStatusBar;
    lblSearch: TLabel;
    edtSearch: TEdit;
    vstJson: TVirtualStringTree;
    memoValue: TSynEdit;
    btnApply: TButton;
    memoJson: TSynEdit;
    synJsonHL: TSynJSONSyn;
    gpFolderPath: TGridPanel;
    edtFolderPath: TEdit;
    spbFolderSelect: TSpeedButton;
    flbFilesList: TFileListBox;
    ApplicationEvents: TApplicationEvents;
    splEditJSON: TSplitter;
    gpMainButtons: TGridPanel;
    spbOpenFolder: TSpeedButton;
    spbSaveFile: TSpeedButton;
    spbSaveFileAs: TSpeedButton;
    spbExportJson: TSpeedButton;
    spbImportJson: TSpeedButton;
    spbFormatJson: TSpeedButton;
    spbReloadTree: TSpeedButton;
    spbOpenFile: TSpeedButton;
    spbExitApp: TSpeedButton;
    Splitter1: TSplitter;
    GridPanel1: TGridPanel;
    Panel1: TPanel;
    GridPanel2: TGridPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AppActivate(Sender: TObject);
    procedure AppIdle(Sender: TObject; var Done: Boolean);
    procedure OpenFileClick(Sender: TObject);
    procedure SaveFileClick(Sender: TObject);
    procedure SaveFileAsClick(Sender: TObject);
    procedure ExportJsonClick(Sender: TObject);
    procedure ImportJsonClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure vstJsonFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
    procedure vstJsonFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure vstJsonGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstJsonInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstJsonFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure edtSearchChange(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure memoValueChange(Sender: TObject);
    procedure memoValueExit(Sender: TObject);
    procedure memoValueKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure memoJsonChange(Sender: TObject);
    procedure memoJsonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure spbFormatJsonClick(Sender: TObject);
    procedure spbReloadTreeClick(Sender: TObject);
    procedure btnFindNextClick(Sender: TObject);
    procedure btnFindPrevClick(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure spbFolderSelectClick(Sender: TObject);
    procedure edtFolderPathKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure flbFilesListDblClick(Sender: TObject);
    procedure edtFolderPathEnter(Sender: TObject);
    procedure OpenFolderClick(Sender: TObject);
  private
    FJsonRoot: ISuperObject;
    FFileName: string;
    FModified: Boolean;
    FUpdating: Boolean;
    FDirChangeHandle: THandle;
    FSearchText: string;
    FMemoNode: PVirtualNode;
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
    procedure RebuildTree;
    procedure BuildTreeNode(ANode: PVirtualNode; AValue: IJSONAncestor; const AKey: string);
    procedure SetNodeFields(APayload: TJsonNodePayload; AValue: IJSONAncestor; const AKey: string);
    function GetNodePayload(ANode: PVirtualNode): TJsonNodePayload;
    procedure ShowNodeValue(ANode: PVirtualNode);
    procedure UpdateNodeCaption(ANode: PVirtualNode; AValue: IJSONAncestor);
    function TreeNodePath(ANode: PVirtualNode): string;
    function ReplaceNodeJsonValue(ANode: PVirtualNode; ANewValue: IJSONAncestor): Boolean;
    function ApplyValueFromMemo(AValue: IJSONAncestor; ANode: PVirtualNode): Boolean;
    function ApplyMemoIfDirty: Boolean;
    function NodeMatchesSearch(ANode: PVirtualNode; const ASearch: string): Boolean;
    procedure ApplySearchFilter;
    procedure UpdateSearchFilterRecursive(ANode: PVirtualNode);
    function FindSearchNode(AForward: Boolean): PVirtualNode;
    procedure FocusSearchNode(ANode: PVirtualNode);
    procedure ApplyJsonFromText(const AJsonText: string);
    function PickFolder(var ADirectory: string): Boolean;
    procedure RefreshSaveFilesList(AShowErrors: Boolean = True);
    procedure LoadSavedFolder;
    procedure SaveFolderPath;
    function SettingsIniPath: string;
    procedure StartFolderWatch;
    procedure StopFolderWatch;
    procedure CheckFolderWatch;
    procedure OnApplicationActivated;
    procedure SetupSpeedButtons;
    procedure SetupSynEditors;
    procedure SetupVirtualTree;
    procedure UpdateFolderPanelVisibility;
    procedure FindKeyClick;
    procedure SaveFromShortcut;
  protected
    procedure WMActivateApp(var Message: TWMActivateApp); message WM_ACTIVATEAPP;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

function NodeJson(AVst: TVirtualStringTree; ANode: PVirtualNode): IJSONAncestor;
var
  Ref: PJsonNodeRef;
begin
  Result := nil;
  if (ANode = nil) or (ANode = AVst.RootNode) or (AVst.NodeDataSize = 0) then
    Exit;
  if not (vsInitialized in ANode.States) then
    AVst.ValidateNode(ANode, False);
  Ref := AVst.GetNodeData(ANode);
  if (Ref <> nil) and (Ref.Payload <> nil) then
    Result := Ref.Payload.JsonValue;
end;

function TfrmMain.GetNodePayload(ANode: PVirtualNode): TJsonNodePayload;
var
  Ref: PJsonNodeRef;
begin
  Result := nil;
  if (ANode = nil) or (ANode = vstJson.RootNode) or (vstJson.NodeDataSize = 0) then
    Exit;
  if not (vsInitialized in ANode.States) then
    vstJson.ValidateNode(ANode, False);
  Ref := vstJson.GetNodeData(ANode);
  if (Ref <> nil) then
    Result := Ref.Payload;
end;

procedure TfrmMain.vstJsonInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Ref: PJsonNodeRef;
begin
  Ref := Sender.GetNodeData(Node);
  if Ref.Payload = nil then
    Ref.Payload := TJsonNodePayload.Create;
end;

procedure TfrmMain.vstJsonFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Ref: PJsonNodeRef;
begin
  Ref := Sender.GetNodeData(Node);
  if (Ref <> nil) and (Ref.Payload <> nil) then
  begin
    Ref.Payload.Free;
    Ref.Payload := nil;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  KeyPreview := True;
  FDirChangeHandle := 0;
  FMemoNode := nil;
  FMemoDirty := False;
  FJsonMemoDirty := False;
  FSearchText := '';
  OpenDialog.Filter := 'Файлы сохранения (*.save)|*.save|Все файлы (*.*)|*.*';
  SaveDialog.Filter := OpenDialog.Filter;
  JsonSaveDialog.Filter := 'JSON (*.json)|*.json|Все файлы (*.*)|*.*';
  JsonSaveDialog.DefaultExt := 'json';
  JsonOpenDialog.Filter := JsonSaveDialog.Filter;
  SetupVirtualTree;
  ClearDocument;
  SetupSynEditors;
  SetupSpeedButtons;
  UpdateFolderPanelVisibility;
  LoadSavedFolder;
  if ParamCount >= 1 then
    LoadDocument(ParamStr(1));
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  StopFolderWatch;
  SaveFolderPath;
  ClearDocument;
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
  Msg: string;
begin
  if FFileName <> '' then
    Msg := FFileName
  else
    Msg := 'Файл не открыт';
  if FJsonRoot <> nil then
    Msg := Msg + '  |  JSON: ' + IntToStr(Length(memoJson.Text)) + ' симв.';
  if FModified then
    Msg := Msg + '  |  изменён';
  StatusBar.SimpleText := Msg;
end;

procedure TfrmMain.ClearDocument;
begin
  FJsonRoot := nil;
  FFileName := '';
  FMemoNode := nil;
  FMemoDirty := False;
  FJsonMemoDirty := False;
  FSearchText := '';
  vstJson.Clear;
  edtSearch.Clear;
  edtSearch.Enabled := False;
  memoValue.Clear;
  memoJson.Clear;
  btnApply.Enabled := False;
  SetModified(False);
end;

procedure TfrmMain.SyncJsonMemo;
begin
  if FJsonRoot = nil then
    memoJson.Clear
  else
  begin
    FUpdating := True;
    try
      memoJson.Lines.BeginUpdate;
      try
        memoJson.Lines.Text := FormatJson(JsonRootAncestor(FJsonRoot));
      finally
        memoJson.Lines.EndUpdate;
      end;
    finally
      FJsonMemoDirty := False;
      FUpdating := False;
    end;
  end;
end;

procedure TfrmMain.SetNodeFields(APayload: TJsonNodePayload; AValue: IJSONAncestor; const AKey: string);
var
  ValueCast: ICast;
  LabelText: string;
begin
  if APayload = nil then
    Exit;
  APayload.JsonValue := AValue;
  APayload.NodeKey := AKey;
  APayload.ValuePreview := '';
  if AKey <> '' then
    LabelText := AKey + ': '
  else
    LabelText := '';

  if AValue = nil then
  begin
    APayload.Caption := LabelText;
    Exit;
  end;

  ValueCast := TCast.Create(AValue);
  case ValueCast.DataType of
    dtObject:
      begin
        if AKey = '' then
          APayload.Caption := 'Object {' + IntToStr(ValueCast.AsObject.Count) + '}'
        else
          APayload.Caption := LabelText + '{' + IntToStr(ValueCast.AsObject.Count) + '}';
      end;
    dtArray:
      begin
        if AKey = '' then
          APayload.Caption := 'Array [' + IntToStr(ValueCast.AsArray.Length) + ']'
        else
          APayload.Caption := LabelText + '[' + IntToStr(ValueCast.AsArray.Length) + ']';
      end;
    dtString:
      begin
        APayload.ValuePreview := '"' + ValueCast.AsString + '"';
        APayload.Caption := LabelText + APayload.ValuePreview;
      end;
    dtInteger:
      begin
        APayload.ValuePreview := IntToStr(ValueCast.AsInteger);
        APayload.Caption := LabelText + APayload.ValuePreview;
      end;
    dtFloat:
      begin
        APayload.ValuePreview := FloatToStr(ValueCast.AsFloat);
        APayload.Caption := LabelText + APayload.ValuePreview;
      end;
    dtBoolean:
      if ValueCast.AsBoolean then
      begin
        APayload.ValuePreview := 'true';
        APayload.Caption := LabelText + 'true';
      end
      else
      begin
        APayload.ValuePreview := 'false';
        APayload.Caption := LabelText + 'false';
      end;
    dtNull:
      begin
        APayload.ValuePreview := 'null';
        APayload.Caption := LabelText + 'null';
      end;
  else
    begin
      APayload.ValuePreview := JsonToCompact(AValue);
      APayload.Caption := LabelText + APayload.ValuePreview;
    end;
  end;
end;

procedure TfrmMain.BuildTreeNode(ANode: PVirtualNode; AValue: IJSONAncestor; const AKey: string);
var
  I: Integer;
  Child: PVirtualNode;
  Obj: ISuperObject;
  Arr: ISuperArray;
  ValueCast: ICast;
  Key: string;
  Payload: TJsonNodePayload;
begin
  if AValue = nil then
    Exit;

  Payload := GetNodePayload(ANode);
  SetNodeFields(Payload, AValue, AKey);

  ValueCast := TCast.Create(AValue);
  case ValueCast.DataType of
    dtObject:
      begin
        Obj := ValueCast.AsObject;
        Obj.First;
        while not Obj.EoF do
        begin
          Key := Obj.CurrentKey;
          Child := vstJson.AddChild(ANode);
          BuildTreeNode(Child, Obj.CurrentValue, Key);
          Obj.Next;
        end;
      end;
    dtArray:
      begin
        Arr := ValueCast.AsArray;
        for I := 0 to Arr.Length - 1 do
        begin
          Key := IntToStr(I);
          Child := vstJson.AddChild(ANode);
          BuildTreeNode(Child, Arr.Ancestor[I], Key);
        end;
      end;
  end;
end;

function TfrmMain.ReplaceNodeJsonValue(ANode: PVirtualNode; ANewValue: IJSONAncestor): Boolean;
var
  ParentNode: PVirtualNode;
  ParentVal: IJSONAncestor;
  ParentCast: ICast;
  Obj: ISuperObject;
  Arr: ISuperArray;
  Key: string;
  Idx, I: Integer;
  Snapshot: TList<IJSONAncestor>;
  Payload: TJsonNodePayload;
begin
  Result := False;
  if (ANode = nil) or (ANewValue = nil) then
    Exit;

  ParentNode := ANode.Parent;
  Payload := GetNodePayload(ANode);
  if Payload = nil then
    Exit;

  if (ParentNode = nil) or (ParentNode = vstJson.RootNode) then
  begin
    FJsonRoot := ParseJsonText(JsonToCompact(ANewValue));
    SetNodeFields(Payload, JsonRootAncestor(FJsonRoot), Payload.NodeKey);
    Exit(True);
  end;

  ParentVal := NodeJson(vstJson, ParentNode);
  if ParentVal = nil then
    Exit;

  Key := Payload.NodeKey;

  ParentCast := TCast.Create(ParentVal);
  if ParentCast.DataType = dtObject then
  begin
    Obj := ParentCast.AsObject;
    Obj.Remove(Key);
    Obj.Add(Key, ANewValue);
    Result := True;
  end
  else if ParentCast.DataType = dtArray then
  begin
    Arr := ParentCast.AsArray;
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
    Result := True;
  end;

  if Result then
    SetNodeFields(Payload, ANewValue, Key);
end;

procedure TfrmMain.RebuildTree;
var
  Root: PVirtualNode;
  RootPayload: TJsonNodePayload;
begin
  FSearchText := Trim(edtSearch.Text);
  vstJson.BeginUpdate;
  try
    vstJson.Clear;
    if FJsonRoot <> nil then
    begin
      Root := vstJson.AddChild(nil);
      BuildTreeNode(Root, JsonRootAncestor(FJsonRoot), '');
      RootPayload := GetNodePayload(Root);
      if RootPayload <> nil then
        RootPayload.Caption := 'save';
      vstJson.Expanded[Root] := True;
    end;
    ApplySearchFilter;
  finally
    vstJson.EndUpdate;
  end;
end;

procedure TfrmMain.ShowNodeValue(ANode: PVirtualNode);
var
  Val: IJSONAncestor;
  ValueCast: ICast;
begin
  memoValue.Clear;
  btnApply.Enabled := False;
  if ANode = nil then
  begin
    FMemoNode := nil;
    FMemoDirty := False;
    Exit;
  end;

  Val := NodeJson(vstJson, ANode);
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

function TfrmMain.TreeNodePath(ANode: PVirtualNode): string;
var
  Parts: TStringList;
  N: PVirtualNode;
  Payload: TJsonNodePayload;
begin
  Parts := TStringList.Create;
  try
    Parts.Delimiter := '\';
    Parts.StrictDelimiter := True;
    N := ANode;
    while (N <> nil) and (N <> vstJson.RootNode) do
    begin
      Payload := GetNodePayload(N);
      if (Payload <> nil) and (Payload.Caption <> '') then
        Parts.Insert(0, Payload.Caption);
      N := N.Parent;
    end;
    Result := Parts.DelimitedText;
  finally
    Parts.Free;
  end;
end;

procedure TfrmMain.UpdateNodeCaption(ANode: PVirtualNode; AValue: IJSONAncestor);
var
  Payload: TJsonNodePayload;
begin
  if (ANode = nil) or (AValue = nil) then
    Exit;
  Payload := GetNodePayload(ANode);
  if Payload = nil then
    Exit;
  SetNodeFields(Payload, AValue, Payload.NodeKey);
  vstJson.InvalidateNode(ANode);
end;

function TfrmMain.ApplyValueFromMemo(AValue: IJSONAncestor; ANode: PVirtualNode): Boolean;
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
  Node: PVirtualNode;
  Val: IJSONAncestor;
begin
  Result := True;
  if not FMemoDirty or (FMemoNode = nil) or memoValue.ReadOnly then
    Exit;

  Node := FMemoNode;
  Val := NodeJson(vstJson, Node);
  if Val = nil then
  begin
    FMemoDirty := False;
    Exit;
  end;

  if not ApplyValueFromMemo(Val, Node) then
    Exit(False);

  UpdateNodeCaption(Node, NodeJson(vstJson, Node));
  SyncJsonMemo;
  SetModified(True);
  FMemoDirty := False;
end;

function TfrmMain.NodeMatchesSearch(ANode: PVirtualNode; const ASearch: string): Boolean;
var
  Payload: TJsonNodePayload;
begin
  Result := False;
  if (ANode = nil) or (ASearch = '') then
    Exit;
  Payload := GetNodePayload(ANode);
  if Payload = nil then
    Exit;
  Result := (Pos(UpperCase(ASearch), UpperCase(Payload.NodeKey)) > 0) or (Pos(UpperCase(ASearch), UpperCase(Payload.Caption)) > 0) or (Pos(UpperCase(ASearch), UpperCase(Payload.ValuePreview)) > 0);
end;

procedure TfrmMain.UpdateSearchFilterRecursive(ANode: PVirtualNode);
var
  Child: PVirtualNode;
  ChildVisible: Boolean;
begin
  Child := vstJson.GetFirstChild(ANode);
  ChildVisible := False;
  while Child <> nil do
  begin
    UpdateSearchFilterRecursive(Child);
    if not vstJson.IsFiltered[Child] then
      ChildVisible := True;
    Child := vstJson.GetNextSibling(Child);
  end;

  if FSearchText = '' then
    vstJson.IsFiltered[ANode] := False
  else if NodeMatchesSearch(ANode, FSearchText) or ChildVisible then
  begin
    vstJson.IsFiltered[ANode] := False;
    if ChildVisible or NodeMatchesSearch(ANode, FSearchText) then
      vstJson.Expanded[ANode] := True;
  end
  else
    vstJson.IsFiltered[ANode] := True;
end;

procedure TfrmMain.ApplySearchFilter;
var
  Root: PVirtualNode;
  MatchCount: Integer;
  Node: PVirtualNode;
  StatusMsg: string;
begin
  FSearchText := Trim(edtSearch.Text);
  vstJson.BeginUpdate;
  try
    Root := vstJson.GetFirst;
    if Root <> nil then
      UpdateSearchFilterRecursive(Root);

    MatchCount := 0;
    if FSearchText <> '' then
    begin
      Node := vstJson.GetFirst;
      while Node <> nil do
      begin
        if NodeMatchesSearch(Node, FSearchText) and not vstJson.IsFiltered[Node] then
          Inc(MatchCount);
        Node := vstJson.GetNext(Node);
      end;
    end;
  finally
    vstJson.EndUpdate;
  end;

  UpdateStatus;
  if FSearchText <> '' then
  begin
    StatusMsg := StatusBar.SimpleText + '  |  найдено: ' + IntToStr(MatchCount);
    StatusBar.SimpleText := StatusMsg;
  end;
end;

function TfrmMain.FindSearchNode(AForward: Boolean): PVirtualNode;
var
  Node, Start: PVirtualNode;
  Search: string;
begin
  Result := nil;
  Search := Trim(edtSearch.Text);
  if Search = '' then
    Exit;

  Node := vstJson.FocusedNode;
  if AForward then
  begin
    if Node <> nil then
      Node := vstJson.GetNext(Node)
    else
      Node := vstJson.GetFirst;
  end
  else
  begin
    if Node <> nil then
      Node := vstJson.GetPrevious(Node)
    else
      Node := vstJson.GetLast;
  end;

  if Node = nil then
    Exit;

  Start := Node;
  repeat
    if NodeMatchesSearch(Node, Search) and not vstJson.IsFiltered[Node] then
      Exit(Node);
    if AForward then
      Node := vstJson.GetNext(Node)
    else
      Node := vstJson.GetPrevious(Node);
    if Node = nil then
    begin
      if AForward then
        Node := vstJson.GetFirst
      else
        Node := vstJson.GetLast;
    end;
  until Node = Start;
end;

procedure TfrmMain.FocusSearchNode(ANode: PVirtualNode);
var
  N: PVirtualNode;
begin
  if ANode = nil then
    Exit;
  N := ANode.Parent;
  while N <> nil do
  begin
    vstJson.Expanded[N] := True;
    N := N.Parent;
  end;
  vstJson.FocusedNode := ANode;
  vstJson.ScrollIntoView(ANode, True, False);
  ShowNodeValue(ANode);
end;

procedure TfrmMain.ApplyJsonFromText(const AJsonText: string);
begin
  FJsonRoot := ParseJsonText(AJsonText);
  edtSearch.Enabled := True;
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
    edtSearch.Enabled := True;
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
      FJsonRoot := ParseJsonText(memoJson.Text);
      RebuildTree;
      FJsonMemoDirty := False;
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
  BaseName, OutName: string;
begin
  if FJsonRoot = nil then
    Exit;

  BaseName := FFileName;
  if BaseName = '' then
    BaseName := 'save'
  else
    BaseName := ChangeFileExt(BaseName, '');
  OutName := BaseName + '.json';
  OutName := StringReplace(OutName, ':', '_', [rfReplaceAll]);
  OutName := StringReplace(OutName, '\', '_', [rfReplaceAll]);
  OutName := StringReplace(OutName, '/', '_', [rfReplaceAll]);

  JsonSaveDialog.FileName := OutName;
  if not JsonSaveDialog.Execute then
    Exit;

  TFile.WriteAllText(JsonSaveDialog.FileName, FormatJson(JsonRootAncestor(FJsonRoot)), TEncoding.UTF8);
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

procedure TfrmMain.vstJsonFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := True;
  if FUpdating then
    Exit;
  if not ApplyMemoIfDirty then
  begin
    Allowed := False;
    if FMemoNode <> nil then
      vstJson.FocusedNode := FMemoNode;
    Exit;
  end;
end;

procedure TfrmMain.vstJsonFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  if FUpdating then
    Exit;
  ShowNodeValue(Node);
end;

procedure TfrmMain.vstJsonGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Payload: TJsonNodePayload;
begin
  Payload := GetNodePayload(Node);
  if Payload = nil then
    Exit;
  case Column of
    0:
      CellText := Payload.Caption;
    1:
      CellText := Payload.ValuePreview;
  end;
end;

procedure TfrmMain.edtSearchChange(Sender: TObject);
begin
  if FUpdating or (FJsonRoot = nil) then
    Exit;
  ApplySearchFilter;
end;

procedure TfrmMain.btnApplyClick(Sender: TObject);
begin
  FMemoNode := vstJson.FocusedNode;
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

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('F')) and (ssCtrl in Shift) and not (ssAlt in Shift) then
  begin
    FindKeyClick;
    Key := 0;
    Exit;
  end;
  if (Key = Ord('S')) and (ssCtrl in Shift) and not (ssAlt in Shift) then
  begin
    SaveFromShortcut;
    Key := 0;
    Exit;
  end;
  if Key = VK_F3 then
  begin
    if ssShift in Shift then
      btnFindPrevClick(nil)
    else
      btnFindNextClick(nil);
    Key := 0;
  end;
end;

procedure TfrmMain.FindKeyClick;
begin
  edtSearch.SetFocus;
  edtSearch.SelectAll;
end;

procedure TfrmMain.SaveFromShortcut;
begin
  if FJsonRoot = nil then
    Exit;
  if not ApplyMemoIfDirty then
    Exit;
  SaveFileClick(nil);
end;

procedure TfrmMain.memoValueKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('S')) and (ssCtrl in Shift) and not (ssAlt in Shift) then
  begin
    SaveFromShortcut;
    Key := 0;
    Exit;
  end;
  if (Key = VK_RETURN) and (ssCtrl in Shift) then
  begin
    ApplyMemoIfDirty;
    Key := 0;
  end;
end;

procedure TfrmMain.memoJsonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('S')) and (ssCtrl in Shift) and not (ssAlt in Shift) then
  begin
    SaveFromShortcut;
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

procedure TfrmMain.spbFormatJsonClick(Sender: TObject);
begin
  if FJsonRoot = nil then
    Exit;
  try
    FUpdating := True;
    memoJson.Lines.BeginUpdate;
    try
      memoJson.Lines.Text := FormatJson(JsonRootAncestor(FJsonRoot));
    finally
      memoJson.Lines.EndUpdate;
    end;
    FJsonMemoDirty := False;
    SetModified(True);
  finally
    FUpdating := False;
  end;
end;

procedure TfrmMain.spbReloadTreeClick(Sender: TObject);
begin
  if FJsonRoot = nil then
    Exit;
  try
    FJsonRoot := ParseJsonText(memoJson.Text);
    RebuildTree;
    SetModified(True);
    FJsonMemoDirty := False;
  except
    on E: Exception do
      MessageDlg('JSON: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmMain.btnFindNextClick(Sender: TObject);
var
  N: PVirtualNode;
begin
  N := FindSearchNode(True);
  if N <> nil then
    FocusSearchNode(N)
  else
    MessageDlg('Ничего не найдено: «' + Trim(edtSearch.Text) + '»', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.btnFindPrevClick(Sender: TObject);
var
  N: PVirtualNode;
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
  else if Key = VK_ESCAPE then
  begin
    edtSearch.Clear;
    Key := 0;
  end;
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

function TfrmMain.SettingsIniPath: string;
begin
  Result := ChangeFileExt(Application.ExeName, '.ini');
end;

procedure TfrmMain.SaveFolderPath;
var
  Ini: TIniFile;
  Folder: string;
begin
  Folder := Trim(edtFolderPath.Text);
  Ini := TIniFile.Create(SettingsIniPath);
  try
    Ini.WriteString('Folders', 'Path', Folder);
  finally
    Ini.Free;
  end;
end;

procedure TfrmMain.LoadSavedFolder;
var
  Ini: TIniFile;
  Folder: string;
begin
  Ini := TIniFile.Create(SettingsIniPath);
  try
    Folder := Trim(Ini.ReadString('Folders', 'Path', ''));
  finally
    Ini.Free;
  end;
  if Folder = '' then
    Exit;
  edtFolderPath.Text := Folder;
  RefreshSaveFilesList(False);
end;

procedure TfrmMain.RefreshSaveFilesList(AShowErrors: Boolean);
var
  Folder: string;
begin
  Folder := Trim(edtFolderPath.Text);
  if Folder = '' then
  begin
    flbFilesList.Directory := '';
    StopFolderWatch;
    Exit;
  end;
  if not TDirectory.Exists(Folder) then
  begin
    flbFilesList.Directory := '';
    StopFolderWatch;
    if AShowErrors then
      MessageDlg('Папка не найдена: ' + Folder, mtError, [mbOK], 0);
    Exit;
  end;

  if not SameText(ExcludeTrailingPathDelimiter(flbFilesList.Directory), ExcludeTrailingPathDelimiter(Folder)) then
    flbFilesList.Directory := Folder
  else
    flbFilesList.Update;
  SaveFolderPath;
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

procedure TfrmMain.flbFilesListDblClick(Sender: TObject);
begin
  if flbFilesList.ItemIndex < 0 then
    Exit;
  if not ConfirmSaveIfModified then
    Exit;
  LoadDocument(flbFilesList.FileName);
end;

procedure TfrmMain.SetupSpeedButtons;
begin
  if not RegisterFontAwesome then
    Exit;
  SetupSpeedButtonIcon(spbOpenFile, fa_file_o, 'Открыть файл...', 18, clBlack);//clNavy
  SetupSpeedButtonIcon(spbSaveFile, fa_floppy_o, 'Сохранить (Ctrl+S)', 18, clBlack);//clGreen
  SetupSpeedButtonIcon(spbSaveFileAs, fa_files_o, 'Сохранить как...', 18, clBlack);//TColor($0080B000)
  SetupSpeedButtonIcon(spbExportJson, fa_download, 'Экспорт в JSON...', 18, clBlack);//clPurple
  SetupSpeedButtonIcon(spbImportJson, fa_upload, 'Импорт из JSON...', 18, clBlack);//clMaroon
  SetupSpeedButtonIcon(spbFormatJson, fa_code, 'Форматировать JSON', 18, clBlack);
  SetupSpeedButtonIcon(spbReloadTree, fa_refresh, 'Применить JSON к дереву', 18, clBlack);
  SetupSpeedButtonIcon(spbExitApp, fa_sign_out, 'Выход', 18, clBlack);//clGray
  SetupSpeedButtonIcon(spbFolderSelect, fa_folder, 'Выбрать папку с сохранениями', 14, TColor($0000A0D0));
  UpdateFolderPanelVisibility;
end;

procedure TfrmMain.SetupVirtualTree;
begin
  vstJson.NodeDataSize := SizeOf(TJsonNodeRef);
  vstJson.Header.Options := vstJson.Header.Options + [hoVisible, hoAutoResize, hoColumnResize];
  vstJson.TreeOptions.PaintOptions := vstJson.TreeOptions.PaintOptions + [toShowButtons, toShowRoot, toShowTreeLines];
  vstJson.TreeOptions.MiscOptions := vstJson.TreeOptions.MiscOptions + [toGridExtensions, toFullRepaintOnResize];
  vstJson.TreeOptions.SelectionOptions := vstJson.TreeOptions.SelectionOptions + [toFullRowSelect];
  vstJson.DefaultNodeHeight := 20;
end;

procedure TfrmMain.SetupSynEditors;
begin
  memoJson.Highlighter := synJsonHL;
  memoValue.Highlighter := synJsonHL;
  memoJson.Font.Name := 'Consolas';
  memoJson.Font.Size := 10;
  memoValue.Font.Name := 'Consolas';
  memoValue.Font.Size := 10;
  memoJson.Gutter.Visible := True;
  memoValue.Gutter.Visible := True;
  memoJson.Options := memoJson.Options + [eoAutoIndent, eoTabsToSpaces, eoSmartTabDelete];
  memoValue.Options := memoValue.Options + [eoAutoIndent, eoTabsToSpaces, eoSmartTabDelete];
  memoJson.WantTabs := True;
  memoValue.WantTabs := True;
  memoJson.WordWrap := False;
  memoValue.WordWrap := False;
  memoJson.ScrollBars := ssBoth;
  memoValue.ScrollBars := ssBoth;
end;

procedure TfrmMain.UpdateFolderPanelVisibility;
begin
  gpFolderPath.Visible := spbOpenFolder.Down;
  if spbOpenFolder.Down then
    SetupSpeedButtonIcon(spbOpenFolder, fa_folder_open, 'Скрыть панель папки', 18, clBlack)//clTeal
  else
    SetupSpeedButtonIcon(spbOpenFolder, fa_folder_open, 'Показать панель папки', 18, clGray);
end;

end.

