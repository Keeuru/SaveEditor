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
  object StatusBar: TStatusBar
    Left = 0
    Top = 761
    Width = 1250
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object pnlSaveEditor: TPanel
    Left = 300
    Top = 0
    Width = 950
    Height = 761
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object splBodyJSON: TSplitter
      Left = 0
      Top = 225
      Width = 950
      Height = 3
      Cursor = crVSplit
      Align = alTop
      MinSize = 100
      ExplicitWidth = 200
    end
    object splEditJSON: TSplitter
      Left = 300
      Top = 228
      Height = 533
      MinSize = 100
      ExplicitLeft = 368
      ExplicitTop = 320
      ExplicitHeight = 100
    end
    object memoJson: TMemo
      Left = 0
      Top = 0
      Width = 950
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
    end
    object PanelTree: TPanel
      Left = 0
      Top = 228
      Width = 300
      Height = 533
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
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
      end
    end
    object PanelEdit: TPanel
      Left = 303
      Top = 228
      Width = 647
      Height = 533
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object PanelEditTop: TPanel
        Left = 0
        Top = 0
        Width = 647
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
        Width = 647
        Height = 451
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 1
        WordWrap = False
        OnChange = memoValueChange
        OnExit = memoValueExit
        OnKeyDown = memoValueKeyDown
      end
    end
  end
  object svMainLeft: TSplitView
    Left = 0
    Top = 0
    Width = 300
    Height = 761
    CloseStyle = svcCompact
    CompactWidth = 40
    OpenedWidth = 300
    ParentBackground = True
    ParentColor = True
    ParentDoubleBuffered = True
    Placement = svpLeft
    TabOrder = 2
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
          Control = spbOpenFolder
          Row = 2
        end
        item
          Column = 0
          Control = spbSaveFile
          Row = 3
        end
        item
          Column = 0
          Control = spbSaveFileAs
          Row = 4
        end
        item
          Column = 0
          Control = spbExportJson
          Row = 5
        end
        item
          Column = 0
          Control = spbImportJson
          Row = 6
        end
        item
          Column = 0
          Control = spbOpenFile
          Row = 1
        end
        item
          Column = 0
          Control = spbExitApp
          Row = 8
        end>
      RowCollection = <
        item
          Value = 50.000000000000000000
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
          SizeStyle = ssAbsolute
          Value = 40.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 40.000000000000000000
        end>
      TabOrder = 0
      object spbOpenFolder: TSpeedButton
        Left = 0
        Top = 280
        Width = 40
        Height = 40
        Align = alClient
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = OpenFolderClick
        ExplicitTop = 8
        ExplicitWidth = 50
        ExplicitHeight = 280
      end
      object spbSaveFile: TSpeedButton
        Left = 0
        Top = 320
        Width = 40
        Height = 40
        Align = alClient
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = SaveFileClick
        ExplicitLeft = 13
        ExplicitTop = 8
        ExplicitWidth = 23
        ExplicitHeight = 22
      end
      object spbSaveFileAs: TSpeedButton
        Left = 0
        Top = 360
        Width = 40
        Height = 40
        Align = alClient
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = SaveFileAsClick
        ExplicitLeft = 13
        ExplicitTop = 8
        ExplicitWidth = 23
        ExplicitHeight = 22
      end
      object spbExportJson: TSpeedButton
        Left = 0
        Top = 400
        Width = 40
        Height = 40
        Align = alClient
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = ExportJsonClick
        ExplicitLeft = 13
        ExplicitTop = 8
        ExplicitWidth = 23
        ExplicitHeight = 22
      end
      object spbImportJson: TSpeedButton
        Left = 0
        Top = 440
        Width = 40
        Height = 40
        Align = alClient
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = ImportJsonClick
        ExplicitLeft = 13
        ExplicitTop = 8
        ExplicitWidth = 23
        ExplicitHeight = 22
      end
      object spbOpenFile: TSpeedButton
        Left = 0
        Top = 240
        Width = 40
        Height = 40
        Align = alClient
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = OpenFileClick
        ExplicitLeft = -6
        ExplicitTop = 234
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
        ExplicitLeft = 8
        ExplicitTop = 8
        ExplicitWidth = 23
        ExplicitHeight = 22
      end
    end
    object gpFolderPath: TGridPanel
      Left = 40
      Top = 0
      Width = 260
      Height = 761
      Align = alClient
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
        ExplicitLeft = 253
        ExplicitTop = 4
        ExplicitWidth = 23
        ExplicitHeight = 22
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
