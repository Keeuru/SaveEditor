object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Save Editor'
  ClientHeight = 600
  ClientWidth = 960
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
    Top = 581
    Width = 960
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 960
    Height = 581
    ActivePage = tabTree
    Align = alClient
    TabOrder = 0
    OnChange = PageControlChange
    object tabTree: TTabSheet
      Caption = 'Tree'
      object Splitter1: TSplitter
        Left = 300
        Top = 0
        Width = 5
        Height = 551
        ExplicitLeft = 200
        ExplicitHeight = 573
      end
      object PanelTree: TPanel
        Left = 0
        Top = 0
        Width = 300
        Height = 551
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
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
          Height = 469
          Align = alClient
          HideSelection = False
          Indent = 19
          TabOrder = 1
          OnChange = TreeJsonChange
        end
      end
      object PanelEdit: TPanel
        Left = 305
        Top = 0
        Width = 647
        Height = 551
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object lblPath: TLabel
          Left = 8
          Top = 8
          Width = 24
          Height = 15
          Caption = 'Path'
        end
        object btnApply: TButton
          Left = 8
          Top = 32
          Width = 120
          Height = 25
          Caption = 'Apply'
          TabOrder = 0
          OnClick = btnApplyClick
        end
        object memoValue: TMemo
          Left = 0
          Top = 0
          Width = 647
          Height = 551
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 1
          WordWrap = False
        end
      end
    end
    object tabJson: TTabSheet
      Caption = 'JSON'
      ImageIndex = 1
      object memoJson: TMemo
        Left = 0
        Top = 0
        Width = 952
        Height = 551
        Align = alClient
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
        ExplicitHeight = 571
      end
    end
  end
  object MainMenu: TMainMenu
    Left = 32
    Top = 80
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
    Left = 120
    Top = 80
  end
  object SaveDialog: TSaveDialog
    Left = 208
    Top = 80
  end
  object JsonSaveDialog: TSaveDialog
    Left = 296
    Top = 80
  end
  object JsonOpenDialog: TOpenDialog
    Left = 384
    Top = 80
  end
end
