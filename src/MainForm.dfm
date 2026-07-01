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
    Left = 280
    Top = 0
    Height = 761
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 761
    Width = 1250
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object gpFolderPath: TGridPanel
    Left = 0
    Top = 0
    Width = 280
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
        Control = spbFolderPath
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
    TabOrder = 0
    ExplicitTop = 225
    ExplicitHeight = 536
    object edtFolderPath: TEdit
      Left = 0
      Top = 0
      Width = 250
      Height = 28
      Align = alClient
      TabOrder = 0
      OnEnter = edtFolderPathEnter
      OnKeyDown = edtFolderPathKeyDown
      ExplicitHeight = 23
    end
    object spbFolderPath: TSpeedButton
      Left = 250
      Top = 0
      Width = 30
      Height = 28
      Align = alClient
      Caption = '...'
      Flat = True
      OnClick = spbFolderPathClick
      ExplicitLeft = 253
      ExplicitTop = 4
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object lbFilesList: TListBox
      Left = 0
      Top = 28
      Width = 280
      Height = 733
      Align = alClient
      ItemHeight = 15
      TabOrder = 1
      OnDblClick = lbFilesListDblClick
      ExplicitTop = 30
      ExplicitHeight = 506
    end
  end
  object Panel1: TPanel
    Left = 283
    Top = 0
    Width = 967
    Height = 761
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    ExplicitLeft = 352
    ExplicitTop = 128
    ExplicitWidth = 857
    ExplicitHeight = 425
    object Splitter2: TSplitter
      Left = 0
      Top = 225
      Width = 967
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitWidth = 200
    end
    object Splitter3: TSplitter
      Left = 300
      Top = 228
      Height = 533
      ExplicitLeft = 368
      ExplicitTop = 320
      ExplicitHeight = 100
    end
    object memoJson: TMemo
      Left = 0
      Top = 0
      Width = 967
      Height = 225
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WantTabs = True
      WordWrap = False
      OnChange = memoJsonChange
      ExplicitTop = -48
      ExplicitWidth = 925
    end
    object PanelTree: TPanel
      Left = 0
      Top = 228
      Width = 300
      Height = 533
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 280
      ExplicitTop = 0
      ExplicitHeight = 761
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
        Height = 451
        Align = alClient
        HideSelection = False
        Indent = 19
        TabOrder = 1
        OnChange = TreeJsonChange
        ExplicitHeight = 679
      end
    end
    object PanelEdit: TPanel
      Left = 303
      Top = 228
      Width = 664
      Height = 533
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitLeft = 285
      ExplicitTop = 0
      ExplicitWidth = 965
      ExplicitHeight = 761
      object PanelEditTop: TPanel
        Left = 0
        Top = 0
        Width = 664
        Height = 82
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
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
      object memoValue: TMemo
        Left = 0
        Top = 82
        Width = 664
        Height = 451
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 1
        WordWrap = False
        OnChange = memoValueChange
        OnExit = memoValueExit
        OnKeyDown = memoValueKeyDown
        ExplicitTop = 64
        ExplicitWidth = 965
        ExplicitHeight = 697
      end
    end
  end
  object MainMenu: TMainMenu
    Left = 64
    Top = 352
    object mnuFile: TMenuItem
      Caption = 'File'
      object mnuOpen: TMenuItem
        Caption = 'Open...'
        ShortCut = 16463
        OnClick = mnuOpenClick
      end
      object mnuSave: TMenuItem
        Caption = 'Save'
        ShortCut = 16467
        OnClick = mnuSaveClick
      end
      object mnuSaveAs: TMenuItem
        Caption = 'Save As...'
        OnClick = mnuSaveAsClick
      end
      object mnuExportJson: TMenuItem
        Caption = 'Export to JSON...'
        OnClick = mnuExportJsonClick
      end
      object mnuImportJson: TMenuItem
        Caption = 'Import from JSON...'
        OnClick = mnuImportJsonClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
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
    Left = 64
    Top = 408
  end
  object SaveDialog: TSaveDialog
    Left = 160
    Top = 408
  end
  object JsonSaveDialog: TSaveDialog
    Left = 160
    Top = 464
  end
  object JsonOpenDialog: TOpenDialog
    Left = 64
    Top = 464
  end
  object ApplicationEvents: TApplicationEvents
    OnActivate = AppActivate
    OnIdle = AppIdle
    Left = 160
    Top = 352
  end
end
