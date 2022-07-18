highlight Normal ctermfg=07 ctermbg=00
highlight Bold cterm=bold
highlight Debug ctermfg=01
highlight Directory ctermfg=04
highlight Error ctermfg=00 ctermbg=01
highlight ErrorMsg ctermfg=01 ctermbg=00
highlight Exception ctermfg=01
highlight FoldColumn ctermfg=08 ctermbg=00
highlight Folded ctermfg=19 ctermbg=00
highlight IncSearch ctermfg=18 ctermbg=16 cterm=none
highlight Italic cterm=italic
highlight Macro ctermfg=01
highlight MatchParen ctermbg=08
highlight ModeMsg ctermfg=02
highlight MoreMsg ctermfg=02
highlight Question ctermfg=04
highlight Search ctermfg=18 ctermbg=03
highlight Substitute ctermfg=18 ctermbg=03 cterm=none
highlight SpecialKey ctermfg=08
highlight TooLong ctermfg=01
highlight Underlined ctermfg=01
highlight Visual ctermbg=19
highlight VisualNOS ctermfg=01
highlight WarningMsg ctermfg=01
highlight WildMenu ctermfg=00 ctermbg=07
highlight Title ctermfg=04 cterm=none
highlight Conceal ctermfg=04 ctermbg=00
highlight Cursor ctermfg=00 ctermbg=07 cterm=inverse
highlight NonText ctermfg=08
highlight Whitespace ctermfg=08
highlight LineNr ctermfg=08 ctermbg=00
highlight SignColumn ctermfg=08 ctermbg=00
highlight StatusLine ctermfg=20 ctermbg=18 cterm=none
highlight StatusLineNC ctermfg=08 ctermbg=18 cterm=none
highlight VertSplit ctermfg=18 ctermbg=00 cterm=none
highlight ColorColumn ctermbg=18 cterm=none
highlight CursorColumn ctermbg=18 cterm=none
highlight CursorLine ctermbg=18 cterm=none
highlight CursorLineNr ctermfg=20 ctermbg=18 cterm=bold
highlight QuickFixLine ctermbg=18 cterm=none
highlight PMenu ctermfg=21 ctermbg=18 cterm=none
highlight PMenuSel ctermfg=21 ctermbg=19
highlight PMenuSbar ctermbg=08
highlight PMenuThumb ctermbg=20
highlight TabLine ctermfg=08 ctermbg=18 cterm=none
highlight TabLineFill ctermfg=08 ctermbg=18 cterm=none
highlight TabLineSel ctermfg=02 ctermbg=18 cterm=none

" Standard syntax
highlight Boolean ctermfg=16
highlight Character ctermfg=01
highlight Comment ctermfg=08
highlight Conditional ctermfg=05
highlight Constant ctermfg=16
highlight Define ctermfg=05 cterm=none
highlight Delimiter ctermfg=07
highlight Float ctermfg=16
highlight Function ctermfg=04
highlight Identifier ctermfg=01 cterm=none
highlight Include ctermfg=04
highlight Keyword ctermfg=05
highlight Label ctermfg=03
highlight Number ctermfg=16
highlight Operator ctermfg=07 cterm=none
highlight PreProc ctermfg=03
highlight Repeat ctermfg=05
highlight Special ctermfg=06
highlight SpecialChar ctermfg=06
highlight Statement ctermfg=01
highlight StorageClass ctermfg=03
highlight String ctermfg=02
highlight Structure ctermfg=05
highlight Tag ctermfg=03
highlight Todo ctermfg=03 ctermbg=18
highlight Type ctermfg=03 cterm=none
highlight Typedef ctermfg=03

" Standard highlights to be used by plugins
highlight Deprecated cterm=strikethrough
highlight SearchMatch ctermfg=06

highlight GitAddSign ctermfg=02
highlight GitChangeSign ctermfg=03
highlight GitDeleteSign ctermfg=01
highlight GitChangeDeleteSign ctermfg=03

highlight ErrorSign ctermfg=01
highlight WarningSign ctermfg=16
highlight InfoSign ctermfg=04
highlight HintSign ctermfg=06

highlight ErrorFloat ctermfg=01 ctermbg=18
highlight WarningFloat ctermfg=16 ctermbg=18
highlight InfoFloat ctermfg=04 ctermbg=18
highlight HintFloat ctermfg=06 ctermbg=18

highlight ErrorHighlight ctermfg=00 ctermbg=01 cterm=underline
highlight WarningHighlight ctermfg=00 ctermbg=16 cterm=underline
highlight InfoHighlight ctermfg=00 ctermbg=04 cterm=underline
highlight HintHighlight ctermfg=00 ctermbg=06 cterm=underline

highlight SpellBad ctermfg=00 ctermbg=01 cterm=undercurl
highlight SpellLocal ctermfg=00 ctermbg=06 cterm=undercurl
highlight SpellCap ctermfg=00 ctermbg=04 cterm=undercurl
highlight SpellRare ctermfg=00 ctermbg=05 cterm=undercurl

highlight ReferenceText ctermfg=18 ctermbg=03
highlight ReferenceRead ctermfg=18 ctermbg=02
highlight ReferenceWrite ctermfg=18 ctermbg=01

" C
highlight cOperator ctermfg=06
highlight cPreCondit ctermfg=05

" C#
highlight csClass ctermfg=03
highlight csAttribute ctermfg=03
highlight csModifier ctermfg=05
highlight csType ctermfg=01
highlight csUnspecifiedStatement ctermfg=04
highlight csContextualStatement ctermfg=05
highlight csNewDecleration ctermfg=01

" Clap
hi! link ClapInput             ColorColumn
hi! link ClapSpinner           ColorColumn
hi! link ClapDisplay           Default
hi! link ClapPreview           ColorColumn
hi! link ClapCurrentSelection  CursorLine
hi! link ClapNoMatchesFound    ErrorFloat

" Coc
hi! link CocErrorSign         ErrorSign
hi! link CocWarningSign       WarningSign
hi! link CocInfoSign          InfoSign
hi! link CocHintSign          HintSign

hi! link CocErrorFloat        ErrorFloat
hi! link CocWarningFloat      WarningFloat
hi! link CocInfoFloat         InfoFloat
hi! link CocHintFloat         HintFloat

hi! link CocErrorHighlight    ErrorHighlight
hi! link CocWarningHighlight  WarningHighlight
hi! link CocInfoHighlight     InfoHighlight
hi! link CocHintHighlight     HintHighlight

hi! link CocSem_angle             Keyword
hi! link CocSem_annotation        Keyword
hi! link CocSem_attribute         Type
hi! link CocSem_bitwise           Keyword
hi! link CocSem_boolean           Boolean
hi! link CocSem_brace             Normal
hi! link CocSem_bracket           Normal
hi! link CocSem_builtinAttribute  Type
hi! link CocSem_builtinType       Type
hi! link CocSem_character         String
hi! link CocSem_class             Structure
hi! link CocSem_colon             Normal
hi! link CocSem_comma             Normal
hi! link CocSem_comment           Comment
hi! link CocSem_comparison        Keyword
hi! link CocSem_concept           Keyword
hi! link CocSem_constParameter    Identifier
hi! link CocSem_dependent         Keyword
hi! link CocSem_dot               Keyword
hi! link CocSem_enum              Structure
hi! link CocSem_enumMember        Constant
hi! link CocSem_escapeSequence    Type
hi! link CocSem_event             Identifier
hi! link CocSem_formatSpecifier   Type
hi! link CocSem_function          Function
hi! link CocSem_interface         Type
hi! link CocSem_keyword           Keyword
hi! link CocSem_label             Keyword
hi! link CocSem_logical           Keyword
hi! link CocSem_macro             Macro
hi! link CocSem_method            Function
hi! link CocSem_modifier          Keyword
hi! link CocSem_namespace         Identifier
hi! link CocSem_number            Number
hi! link CocSem_operator          Operator
hi! link CocSem_parameter         Identifier
hi! link CocSem_parenthesis       Normal
hi! link CocSem_property          Identifier
hi! link CocSem_punctuation       Keyword
hi! link CocSem_regexp            Type
hi! link CocSem_selfKeyword       Constant
hi! link CocSem_semicolon         Normal
hi! link CocSem_string            String
hi! link CocSem_struct            Structure
hi! link CocSem_type              Type
hi! link CocSem_typeAlias         Type
hi! link CocSem_typeParameter     Type
hi! link CocSem_unknown           Normal
hi! link CocSem_variable          Identifier

highlight CocHighlightRead  ctermfg=02 ctermbg=18
highlight CocHighlightText  ctermfg=03 ctermbg=18
highlight CocHighlightWrite  ctermfg=10 ctermbg=18
highlight CocListMode  ctermfg=18 ctermbg=02 cterm=bold
highlight CocListPath  ctermfg=18 ctermbg=02
highlight CocSessionsName ctermfg=07

" CSS
highlight cssBraces ctermfg=07
highlight cssClassName ctermfg=05
highlight cssColor ctermfg=06

" CMP
hi! link CmpItemAbbrDeprecated  Deprecated
hi! link CmpItemAbbrMatch       SearchMatch
hi! link CmpItemAbbrMatchFuzzy  SearchMatch
hi! link CmpItemKindText TSText
hi! link CmpItemKindMethod TSMethod
hi! link CmpItemKindFunction TSFunction
hi! link CmpItemKindConstructor TSConstructor
hi! link CmpItemKindField TSField
hi! link CmpItemKindVariable TSVariable
" hi! link CmpItemKindClass TS
hi! link CmpItemKindInterface TSText
" hi! link CmpItemKindModule TS
hi! link CmpItemKindProperty TSProperty
hi! link CmpItemKindUnit TSKeyword
" hi! link CmpItemKindValue TS
" hi! link CmpItemKindEnum TS
hi! link CmpItemKindKeyword TSKeyword
" hi! link CmpItemKindSnippet TS
" hi! link CmpItemKindColor TS
" hi! link CmpItemKindFile TS
" hi! link CmpItemKindReference TS
" hi! link CmpItemKindFolder TS
" hi! link CmpItemKindEnumMember TS
hi! link CmpItemKindConstant TSConstant
" hi! link CmpItemKindStruct TS
" hi! link CmpItemKindEvent TS
hi! link CmpItemKindOperator TSOperator
hi! link CmpItemKindTypeParameter TSType

" Diff
highlight DiffAdd  ctermfg=02 ctermbg=18
highlight DiffChange  ctermfg=07 ctermbg=18
highlight DiffDelete  ctermfg=19 ctermbg=00
highlight DiffText  ctermfg=04 ctermbg=18
highlight DiffAdded  ctermfg=02 ctermbg=00
highlight DiffFile  ctermfg=01 ctermbg=00
highlight DiffNewFile  ctermfg=02 ctermbg=00
highlight DiffLine  ctermfg=04 ctermbg=00
highlight DiffRemoved  ctermfg=01 ctermbg=00

" Git
highlight gitcommitOverflow ctermfg=01
highlight gitcommitSummary ctermfg=02
highlight gitcommitComment ctermfg=08
highlight gitcommitUntracked ctermfg=08
highlight gitcommitDiscarded ctermfg=08
highlight gitcommitSelected ctermfg=08
highlight gitcommitHeader ctermfg=05
highlight gitcommitSelectedType ctermfg=04
highlight gitcommitUnmergedType ctermfg=04
highlight gitcommitDiscardedType ctermfg=04
highlight gitcommitBranch ctermfg=16 cterm=bold
highlight gitcommitUntrackedFile ctermfg=03
highlight gitcommitUnmergedFile ctermfg=01 cterm=bold
highlight gitcommitDiscardedFile ctermfg=01 cterm=bold
highlight gitcommitSelectedFile ctermfg=02 cterm=bold

" GitGutter
hi! link GitGutterAdd            GitAddSign
hi! link GitGutterChange         GitChangeSign
hi! link GitGutterDelete         GitDeleteSign
hi! link GitGutterChangeDelete   GitChangeDeleteSign

" HTML
highlight htmlBold ctermfg=03 cterm=bold
highlight htmlItalic ctermfg=05 cterm=italic
highlight htmlEndTag ctermfg=07
highlight htmlTag ctermfg=07

" JavaScript
highlight javaScript ctermfg=07
highlight javaScriptBraces ctermfg=07
highlight javaScriptNumber ctermfg=16
" pangloss/vim-javascript
highlight jsOperator ctermfg=04
highlight jsStatement ctermfg=05
highlight jsReturn ctermfg=05
highlight jsThis ctermfg=01
highlight jsClassDefinition ctermfg=03
highlight jsFunction ctermfg=05
highlight jsFuncName ctermfg=04
highlight jsFuncCall ctermfg=04
highlight jsClassFuncName ctermfg=04
highlight jsClassMethodType ctermfg=05
highlight jsRegexpString ctermfg=06
highlight jsGlobalObjects ctermfg=03
highlight jsGlobalNodeObjects ctermfg=03
highlight jsExceptions ctermfg=03
highlight jsBuiltins ctermfg=03

" Mail
highlight mailQuoted1 ctermfg=03
highlight mailQuoted2 ctermfg=02
highlight mailQuoted3 ctermfg=05
highlight mailQuoted4 ctermfg=06
highlight mailQuoted5 ctermfg=04
highlight mailQuoted6 ctermfg=03
highlight mailURL ctermfg=04
highlight mailEmail ctermfg=04

" Markdown
highlight markdownCode ctermfg=02
highlight markdownError ctermfg=07 ctermbg=00
highlight markdownCodeBlock ctermfg=02
highlight markdownHeadingDelimiter ctermfg=04

" Matchup
highlight MatchWord  ctermfg=02 ctermbg=18 cterm=underline

" NERDTree
highlight NERDTreeDirSlash ctermfg=04
highlight NERDTreeExecFile ctermfg=07

" PHP
highlight phpMemberSelector ctermfg=07
highlight phpComparison ctermfg=07
highlight phpParent ctermfg=07
highlight phpMethodsVar ctermfg=06

" Python
highlight pythonOperator ctermfg=05
highlight pythonRepeat ctermfg=05
highlight pythonInclude ctermfg=05
highlight pythonStatement ctermfg=05

" Ruby
highlight rubyAttribute ctermfg=04
highlight rubyConstant ctermfg=03
highlight rubyInterpolationDelimiter ctermfg=17
highlight rubyRegexp ctermfg=06
highlight rubySymbol ctermfg=02
highlight rubyStringDelimiter ctermfg=02

" SASS
highlight sassidChar ctermfg=01
highlight sassClassChar ctermfg=16
highlight sassInclude ctermfg=05
highlight sassMixing ctermfg=05
highlight sassMixinName ctermfg=04

" Signify
hi! link SignifySignAdd    GitAddSign
hi! link SignifySignChange GitChangeSign
hi! link SignifySignDelete GitDeleteSign

" Startify
highlight StartifyBracket ctermfg=08
highlight StartifyFile ctermfg=15
highlight StartifyFooter ctermfg=08
highlight StartifyHeader ctermfg=02
highlight StartifyNumber ctermfg=16
highlight StartifyPath ctermfg=08
highlight StartifySection ctermfg=05
highlight StartifySelect ctermfg=06
highlight StartifySlash ctermfg=08
highlight StartifySpecial ctermfg=08

" Treesitter
hi! link TSVariable Identifier

" Treesitter-refactor
if has("nvim")
  highlight TSDefinition ctermbg=08
  highlight TSDefinitionUsage ctermbg=19 cterm=none
endif

" LSP
if has("nvim")
  hi! link DiagnosticError  ErrorSign
  hi! link DiagnosticWarn   WarningSign
  hi! link DiagnosticInfo   InfoSign
  hi! link DiagnosticHint   HintSign

  hi! link DiagnosticFloatingError  ErrorFloat
  hi! link DiagnosticFloatingWarn   WarningFloat
  hi! link DiagnosticFloatingInfo   InfoFloat
  hi! link DiagnosticFloatingHint   HintFloat

  hi! link DiagnosticUnderlineError  ErrorHighlight
  hi! link DiagnosticUnderlineWarn   WarningHighlight
  hi! link DiagnosticUnderlineInfo   InfoHighlight
  hi! link DiagnosticUnderlineHint   HintHighlight

  hi! link DiagnosticsVirtualTextError    ErrorSign
  hi! link DiagnosticsVirtualTextWarning  WarningSign
  hi! link DiagnosticsVirtualTextInfo     InfoSign
  hi! link DiagnosticsVirtualTextHint     HintSign

  " Remove untill endif on next nvim release
  hi! link LspDiagnosticsSignError    ErrorSign
  hi! link LspDiagnosticsSignWarning  WarningSign
  hi! link LspDiagnosticsSignInfo     InfoSign
  hi! link LspDiagnosticsSignHint     HintSign

  hi! link LspDiagnosticsVirtualTextError    ErrorSign
  hi! link LspDiagnosticsVirtualTextWarning  WarningSign
  hi! link LspDiagnosticsVirtualTextInfo     InfoSign
  hi! link LspDiagnosticsVirtualTextHint     HintSign

  hi! link LspDiagnosticsFloatingError    ErrorFloat
  hi! link LspDiagnosticsFloatingWarning  WarningFloat
  hi! link LspDiagnosticsFloatingInfo     InfoFloat
  hi! link LspDiagnosticsFloatingHint     HintFloat

  hi! link LspDiagnosticsUnderlineError    ErrorHighlight
  hi! link LspDiagnosticsUnderlineWarning  WarningHighlight
  hi! link LspDiagnosticsUnderlineInfo     InfoHighlight
  hi! link LspDiagnosticsUnderlineHint     HintHighlight

  hi! link LspReferenceText   ReferenceText
  hi! link LspReferenceRead   ReferenceRead
  hi! link LspReferenceWrite  ReferenceWrite
endif

" Java
highlight javaOperator ctermfg=04
