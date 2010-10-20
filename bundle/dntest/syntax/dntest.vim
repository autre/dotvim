
" vim syntax settings for ITest
" Της Νίκη

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

if version < 600
  syntax clear
endif

set syntax=scheme

syntax keyword iTestCodeKeywords let set include macro loader staff
syntax keyword iTestReKeywords newlbl newroot newstf newsym resource  display delstf delsym time
syntax keyword iTestReStatusExportKeywords btcend btcstart connect disconnect reconnectAndDisconnect clr canExport export
syntax keyword iTestRestKeywords echo help pause sleep

syntax keyword iTestVariableKeywords $ $$ load>
syn match iTestVariableKeywords  /\$[a-zA-Z0-9\-_\.]\+/hs=s
syn match iTestVariableKeywords  /load>/hs=s

syntax keyword ifStatementKeywords if: else:  }endif => if{
syn match ifStatementKeywords  /if{/hs=s
syn match ifStatementKeywords  /}endif/hs=s

syntax match   DnTestComment "#.*"  contains=All
syntax match   DnTestComment ";.*"  contains=All

syntax keyword Normal -> ,

highlight default iTestCodeKeywords guifg=pink2
highlight default iTestReKeywords guifg=lightblue  gui=bold
highlight default iTestReStatusExportKeywords guifg=seagreen gui=bold
highlight default iTestRestKeywords guifg=orange
highlight default iTestVariableKeywords guifg=lightgreen
highlight default ifStatementKeywords guifg=red  guibg=black
highlight default DnTestComment guifg=darkgrey

let b:current_syntax = "dntest"
