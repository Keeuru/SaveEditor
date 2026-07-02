object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Save Editor'
  ClientHeight = 780
  ClientWidth = 1250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 847
    Top = 0
    Height = 761
    Align = alRight
    Color = clBlack
    MinSize = 100
    ParentColor = False
    ExplicitLeft = 831
    ExplicitTop = -6
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 761
    Width = 1250
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object gpMainButtons: TGridPanel
    Left = 0
    Top = 0
    Width = 40
    Height = 761
    Align = alLeft
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = spbOpenFile
        Row = 0
      end
      item
        Column = 0
        Control = spbOpenFolder
        Row = 1
      end
      item
        Column = 0
        Control = spbSaveFile
        Row = 2
      end
      item
        Column = 0
        Control = spbSaveFileAs
        Row = 3
      end
      item
        Column = 0
        Control = spbExportJson
        Row = 4
      end
      item
        Column = 0
        Control = spbImportJson
        Row = 5
      end
      item
        Column = 0
        Control = spbExitApp
        Row = 7
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 40.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 40.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 40.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 40.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 40.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 40.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 40.000000000000000000
      end>
    TabOrder = 0
    object spbOpenFile: TSpeedButton
      Left = 0
      Top = 0
      Width = 40
      Height = 40
      Align = alClient
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = OpenFileClick
      ExplicitTop = 240
    end
    object spbOpenFolder: TSpeedButton
      Left = 0
      Top = 40
      Width = 40
      Height = 40
      Align = alClient
      AllowAllUp = True
      GroupIndex = 1
      Down = True
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = OpenFolderClick
      ExplicitTop = 280
    end
    object spbSaveFile: TSpeedButton
      Left = 0
      Top = 80
      Width = 40
      Height = 40
      Align = alClient
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = SaveFileClick
      ExplicitTop = 320
    end
    object spbSaveFileAs: TSpeedButton
      Left = 0
      Top = 120
      Width = 40
      Height = 40
      Align = alClient
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = SaveFileAsClick
      ExplicitTop = 360
    end
    object spbExportJson: TSpeedButton
      Left = 0
      Top = 160
      Width = 40
      Height = 40
      Align = alClient
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = ExportJsonClick
      ExplicitTop = 400
    end
    object spbImportJson: TSpeedButton
      Left = 0
      Top = 200
      Width = 40
      Height = 40
      Align = alClient
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = ImportJsonClick
      ExplicitTop = 440
    end
    object spbExitApp: TSpeedButton
      Left = 0
      Top = 721
      Width = 40
      Height = 40
      Align = alClient
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = ExitClick
    end
  end
  object gpFolderPath: TGridPanel
    Left = 40
    Top = 0
    Width = 260
    Height = 761
    Align = alLeft
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 30.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = edtFolderPath
        Row = 0
      end
      item
        Column = 1
        Control = spbFolderSelect
        Row = 0
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = flbFilesList
        Row = 1
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 28.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 1
    Visible = False
    object edtFolderPath: TEdit
      AlignWithMargins = True
      Left = 0
      Top = 4
      Width = 230
      Height = 21
      Margins.Left = 0
      Margins.Top = 4
      Margins.Right = 0
      Align = alClient
      TabOrder = 0
      OnEnter = edtFolderPathEnter
      OnKeyDown = edtFolderPathKeyDown
      ExplicitHeight = 23
    end
    object spbFolderSelect: TSpeedButton
      Left = 230
      Top = 0
      Width = 30
      Height = 28
      Align = alClient
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = spbFolderSelectClick
    end
    object flbFilesList: TFileListBox
      Left = 0
      Top = 28
      Width = 260
      Height = 733
      Align = alClient
      Mask = '*.save'
      ShowGlyphs = True
      TabOrder = 1
      OnDblClick = flbFilesListDblClick
    end
  end
  object memoJson: TSynEdit
    Left = 300
    Top = 0
    Width = 547
    Height = 761
    Margins.Top = 4
    Align = alClient
    CaseSensitive = True
    Color = clWheat
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    TabOrder = 3
    UseCodeFolding = False
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Consolas'
    Gutter.Font.Style = []
    Gutter.Font.Quality = fqClearTypeNatural
    Gutter.Bands = <>
    Highlighter = synJsonHL
    ScrollbarAnnotations = <>
    WantTabs = True
    OnChange = memoJsonChange
  end
  object Panel1: TPanel
    Left = 850
    Top = 0
    Width = 400
    Height = 761
    Align = alRight
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 4
    object splEditJSON: TSplitter
      Left = 0
      Top = 558
      Width = 400
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Color = clBlack
      MinSize = 100
      ParentColor = False
      ExplicitLeft = 310
      ExplicitTop = 439
      ExplicitWidth = 218
    end
    object GridPanel1: TGridPanel
      Left = 0
      Top = 0
      Width = 400
      Height = 558
      Align = alClient
      BevelOuter = bvNone
      ColumnCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 60.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = lblView
          Row = 0
        end
        item
          Column = 1
          Control = cboView
          Row = 0
        end
        item
          Column = 0
          Control = lblSearch
          Row = 1
        end
        item
          Column = 1
          Control = edtSearch
          Row = 1
        end
        item
          Column = 0
          ColumnSpan = 2
          Control = vstJson
          Row = 2
        end>
      RowCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 0
      object lblView: TLabel
        Left = 0
        Top = 0
        Width = 25
        Height = 30
        Align = alLeft
        Caption = 'View'
        Layout = tlCenter
        ExplicitLeft = 8
        ExplicitTop = 8
        ExplicitHeight = 15
      end
      object cboView: TComboBox
        AlignWithMargins = True
        Left = 60
        Top = 4
        Width = 340
        Height = 23
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Align = alClient
        Style = csDropDownList
        TabOrder = 0
        OnChange = cboViewChange
      end
      object lblSearch: TLabel
        Left = 0
        Top = 30
        Width = 56
        Height = 30
        Align = alLeft
        Caption = 'Search key'
        Layout = tlCenter
        ExplicitLeft = 8
        ExplicitTop = 56
        ExplicitHeight = 15
      end
      object edtSearch: TEdit
        AlignWithMargins = True
        Left = 60
        Top = 34
        Width = 340
        Height = 23
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Align = alClient
        TabOrder = 1
        OnChange = edtSearchChange
        OnKeyDown = edtSearchKeyDown
      end
      object vstJson: TVirtualStringTree
        Left = 0
        Top = 60
        Width = 400
        Height = 498
        Align = alClient
        Anchors = []
        DefaultNodeHeight = 19
        Header.AutoSizeIndex = 0
        Header.Height = 15
        ParentColor = True
        TabOrder = 2
        OnFocusChanged = vstJsonFocusChanged
        OnFocusChanging = vstJsonFocusChanging
        OnFreeNode = vstJsonFreeNode
        OnGetText = vstJsonGetText
        OnInitNode = vstJsonInitNode
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        ExplicitLeft = 3
        ExplicitTop = 63
        Columns = <
          item
            Position = 0
            Text = #1050#1083#1102#1095
            Width = 200
          end
          item
            Position = 1
            Text = #1047#1085#1072#1095#1077#1085#1080#1077
            Width = 100
          end>
      end
    end
    object GridPanel2: TGridPanel
      Left = 0
      Top = 561
      Width = 400
      Height = 200
      Align = alBottom
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 100.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          ColumnSpan = 3
          Control = memoValue
          Row = 0
        end
        item
          Column = 1
          Control = btnApply
          Row = 1
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 25.000000000000000000
        end>
      TabOrder = 1
      object memoValue: TSynEdit
        Left = 0
        Top = 0
        Width = 400
        Height = 175
        Align = alClient
        Anchors = []
        CaseSensitive = True
        Color = clWheat
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        TabOrder = 0
        OnExit = memoValueExit
        OnKeyDown = memoValueKeyDown
        UseCodeFolding = False
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Consolas'
        Gutter.Font.Style = []
        Gutter.Font.Quality = fqClearTypeNatural
        Gutter.Bands = <>
        Highlighter = synJsonHL
        ScrollbarAnnotations = <>
        WantTabs = True
        OnChange = memoValueChange
      end
      object btnApply: TButton
        Left = 150
        Top = 175
        Width = 100
        Height = 25
        Align = alClient
        Caption = 'Apply'
        TabOrder = 1
        OnClick = btnApplyClick
      end
    end
  end
  object synJsonHL: TSynJSONSyn
    Left = 112
    Top = 536
  end
  object MainMenu: TMainMenu
    Left = 112
    Top = 592
    object mnuEdit: TMenuItem
      Caption = 'Edit'
      object mnuFind: TMenuItem
        Caption = 'Find Key...'
        ShortCut = 16454
        OnClick = mnuFindClick
      end
      object mnuFindNext: TMenuItem
        Caption = 'Next Match (F3)'
        ShortCut = 114
        OnClick = btnFindNextClick
      end
      object mnuFindPrev: TMenuItem
        Caption = 'Previous Match (Shift+F3)'
        ShortCut = 8238
        OnClick = btnFindPrevClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuFormatJson: TMenuItem
        Caption = 'Format JSON'
        OnClick = mnuFormatJsonClick
      end
      object mnuReloadTree: TMenuItem
        Caption = 'Apply JSON to Tree'
        OnClick = mnuReloadTreeClick
      end
    end
  end
  object OpenDialog: TOpenDialog
    Left = 112
    Top = 648
  end
  object SaveDialog: TSaveDialog
    Left = 208
    Top = 648
  end
  object JsonSaveDialog: TSaveDialog
    Left = 208
    Top = 704
  end
  object JsonOpenDialog: TOpenDialog
    Left = 112
    Top = 704
  end
  object ApplicationEvents: TApplicationEvents
    OnActivate = AppActivate
    OnIdle = AppIdle
    Left = 208
    Top = 592
  end
end
