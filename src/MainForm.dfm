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
  DoubleBuffered = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object splEditJSON: TSplitter
    Left = 947
    Top = 0
    Height = 761
    Align = alRight
    Color = clBlack
    MinSize = 100
    ParentColor = False
    ExplicitLeft = 340
  end
  object Splitter1: TSplitter
    Left = 644
    Top = 0
    Height = 761
    Align = alRight
    Color = clBlack
    MinSize = 100
    ParentColor = False
    ExplicitLeft = 476
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
        Control = lbFilesList
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
      Left = 0
      Top = 0
      Width = 230
      Height = 28
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
    object lbFilesList: TListBox
      Left = 0
      Top = 28
      Width = 260
      Height = 733
      Align = alClient
      ItemHeight = 15
      TabOrder = 1
      OnDblClick = lbFilesListDblClick
    end
  end
  object PanelTree: TPanel
    Left = 647
    Top = 0
    Width = 300
    Height = 761
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 300
    object PanelTreeTop: TPanel
      Left = 0
      Top = 0
      Width = 300
      Height = 82
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblView: TLabel
        Left = 8
        Top = 8
        Width = 25
        Height = 15
        Caption = 'View'
      end
      object lblSearch: TLabel
        Left = 8
        Top = 56
        Width = 35
        Height = 15
        Caption = 'Search'
      end
      object cboView: TComboBox
        Left = 8
        Top = 27
        Width = 284
        Height = 23
        Style = csDropDownList
        TabOrder = 0
        OnChange = cboViewChange
      end
      object edtSearch: TEdit
        Left = 50
        Top = 53
        Width = 163
        Height = 23
        TabOrder = 1
        OnKeyDown = edtSearchKeyDown
      end
      object btnFindNext: TButton
        Left = 219
        Top = 52
        Width = 34
        Height = 25
        Hint = 'Next (F3)'
        Caption = #9660
        TabOrder = 2
        OnClick = btnFindNextClick
      end
      object btnFindPrev: TButton
        Left = 258
        Top = 52
        Width = 34
        Height = 25
        Hint = 'Previous (Shift+F3)'
        Caption = #9650
        TabOrder = 3
        OnClick = btnFindPrevClick
      end
    end
    object TreeJson: TTreeView
      Left = 0
      Top = 82
      Width = 300
      Height = 679
      Align = alClient
      HideSelection = False
      Indent = 19
      TabOrder = 1
      OnChange = TreeJsonChange
    end
  end
  object PanelEdit: TPanel
    Left = 950
    Top = 0
    Width = 300
    Height = 761
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
    object PanelEditTop: TPanel
      Left = 0
      Top = 0
      Width = 300
      Height = 82
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 647
      object lblPath: TLabel
        Left = 8
        Top = 8
        Width = 24
        Height = 15
        Caption = 'Path'
      end
      object btnApply: TButton
        Left = 6
        Top = 51
        Width = 120
        Height = 25
        Caption = 'Apply'
        TabOrder = 0
        OnClick = btnApplyClick
      end
    end
    object memoValue: TRichEdit
      Left = 0
      Top = 82
      Width = 300
      Height = 679
      Align = alClient
      BorderStyle = bsNone
      HideSelection = False
      PlainText = True
      ScrollBars = ssBoth
      TabOrder = 1
      Transparent = True
      WordWrap = False
      OnChange = memoValueChange
      OnExit = memoValueExit
      OnKeyDown = memoValueKeyDown
      ExplicitWidth = 647
    end
  end
  object memoJson: TRichEdit
    Left = 300
    Top = 0
    Width = 344
    Height = 761
    Align = alClient
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    HideSelection = False
    ParentFont = False
    PlainText = True
    ScrollBars = ssBoth
    TabOrder = 5
    Transparent = True
    WordWrap = False
    OnChange = memoJsonChange
    ExplicitWidth = 300
  end
  object imgBackground: TImage
    Left = 720
    Top = 320
    Width = 105
    Height = 105
    Visible = False
  end
  object MainMenu: TMainMenu
    Left = 112
    Top = 592
    object mnuEdit: TMenuItem
      Caption = 'Edit'
      object mnuFind: TMenuItem
        Caption = 'Find in Tree...'
        ShortCut = 16454
        OnClick = mnuFindClick
      end
      object mnuFindNext: TMenuItem
        Caption = 'Find Next'
        ShortCut = 114
        OnClick = btnFindNextClick
      end
      object mnuFindPrev: TMenuItem
        Caption = 'Find Previous'
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
