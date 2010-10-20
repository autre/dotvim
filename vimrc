
"""
" general settings
"""

set nocompatible
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype off
syntax on
filetype plugin indent on

call vundle#rc()

set encoding=utf-8
set fileencoding=utf-8
set fileformat=unix
set history=1000
set title
"set runtimepath+=~/.vim/plugin
set dir=/tmp
set backup
execute "set backupdir=" . "$HOME/.bak"
set autoread " Set to auto read when a file is changed from the outside

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

" on .vimrc change, auto source
autocmd! Bufwritepost $MYVIMRC source $MYVIMRC


"""
" ui settings
"""

if has('gui_running')
  set t_Co=256
  if system('uname') ==? "linux" " FIXME: wtf?
    set guifont=Monaco:h16
  else
    set guifont=Droid\ Sans\ Mono\ Slashed\ 14
  endif
  " Remove GUI menu and toolbar
  set guioptions-=m
  set guioptions-=T
  colorscheme desert
else
  colorscheme elflord
endif

set wildmenu " wmenu for file/command completion
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set hls
set incsearch " do incremental searching
" Make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase
" use std regex chars
nnoremap / /\v
vnoremap / /\v
nnoremap <leader><space> :let @/=''<cr>

set nolazyredraw "Don't redraw while executing macros
" GRB: clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<CR>/<BS>
set magic "Set magic on, for regular expressions
set splitright
set showmatch " bouncy parens, must have
set list listchars=tab:\ \ ,trail:·
"set mouse=a => use the "* register
"set textwidth=80
set scrolloff=2 " Minimum lines between cursor and window edge
set laststatus=2
"set statusline=\ (%n)\ %t\ %M\ [hg:\ %{HGRev()}]\ %=%([%l,\%c]%)\ %p%%
hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" reformat file
fun! IndentStayPut()
  let oldLine=line('.')
  normal(gg=G)
  execute ':' . oldLine
endf
map == :call IndentStayPut()<cr>

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving/opening
nmap <leader>w :w!<cr>
nmap <leader>q :q!<cr>
nmap <leader>wq :wq<cr>
nmap <leader>tt :tabe<cr>

" no fucking arrows
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" move up down on file lines
nnoremap j gj
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Bash like keys for the command line
cnoremap <c-a>		<home>
cnoremap <c-e>		<end>
cnoremap <c-k>		<c-U>

cnoremap <c-p> <up>
cnoremap <c-n> <down>

" Smart way to move between windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-h> <c-w>h
map <c-l> <c-w>l

" The following came from
" http://concisionandconcinnity.blogspot.com/2009/07/vim-part-ii-matching-pairs.html
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
autocmd Syntax html,vim inoremap < <lt>><left>

function! ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
    return "\<Right>"
  else
    return a:char
  endif
endf

inoremap ) <c-r>=ClosePair(')')<CR>
inoremap } <c-r>=ClosePair('}')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>

fun! QuoteDelim(char)
  let line = getline('.')
  let col = col('.')
  if line[col - 2] == "\\"
    " inserting a quoted quotation mark into the string
    return a:char
  elseif line[col - 1] == a:char
    " escaping out of the string
    return "\<Right>"
  else
    " starting a string
    return a:char.a:char."\<Left>"
  endif
endf

inoremap " <c-r>=QuoteDelim('"')<CR>
"inoremap ' <c-r>=QuoteDelim("'")<CR>

" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

"""
" plugin support
"""

"""
" hgrev conf
"""
let g:hgrevFlags = '-nbti'
let g:hgrevAddStatus = 0
let g:hgrevAutoUpdate = 1
let g:hgrevNoRepoChar = '-'

map <f2> <esc>:TlistToggle<cr>
map <f3> <esc>:NERDTree<cr>
map ,h :set hlsearch! hlsearch?<cr>
nmap <silent> ,t :CommandT<cr>

" also used by command-t
set wildignore+=bin,classes,build,lib,.hg,.git,*.class,*.jar,*.o,*.hi,*.pyc
let NERDTreeSortOrder = ['\/$', '\.py', '\.y', '\.h', '\.c', '\.hs']
let NERDTreeWinSize = 20
let NERDTreeIgnore = ['\.o', '\.hi', '\.pyc', '\.class']
let NERDTreeWinPos = "right"

let twitvim_enable_python = 1

au FocusLost * :wa " save file when losing focus

let vimclojure#NailgunClient = "/usr/local/bin/ng"
let vimclojure#WantNailgun = 1
let vimclojure#HighlightBuiltins = 1
let vimclojure#ParenRainbow = 1

"""
" language specific
"""


" ts = tabstop
" sw = shiftwidth
" sts = softtabstop
" ai = autoident
" sta = smart tab
" et = expand tabs to spaces
augroup C "mother of all languages
  au BufNewFile *.c 0r           ~/.vim/templates/templ.c
  au BufNewFile,BufRead *.c,*.h  setl filetype=c sw=8 ts=8 ai sta noet
augroup END

augroup SH
  au BufNewFile *.sh 0r       ~/.vim/templates/templ.sh
  au BufNewFile,BufRead *.sh  setl filetype=sh ts=8 sw=8 ai sta noet
augroup END

augroup PYTHON
  au BufNewFile *.py 0r       ~/.vim/templates/templ.py
  au BufRead,BufNewFile *.py  setl filetype=python sw=4 ts=4 sts=4 ai sta et
  au BufRead,BufNewFile *.py  setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
  au Filetype python          setl omnifunc=pythoncomplete#Complete
augroup END

augroup JAVASCRIPT
  au BufRead,BufNewFile *.js,*.json  setl filetype=javascript sw=4 ts=4 sts=4 ai sta et
  au Filetype javascript             nmap <F5> :call JSExec()<cr>
  au FileType javascript             setl errorformat=js:\ "%f",\ line\ %l:\ %m
  au FileType javascript             :ToggleRaibowParenthesis
augroup END

augroup COFFEE
  au BufRead,BufNewFile *.coffee  setl filetype=coffeescript sw=4 ts=4 sts=4 ai sta et
  au FileType coffeescript        :ToggleRaibowParenthesis
augroup END

augroup CLOJURE
  au BufRead,BufNewFile *.clj  setl sw=2 ts=2 sts=2 ai sta et
  au Filetype clojure          map <f2> \ef
  au FileType clojure         :ToggleRaibowParenthesis
augroup END

augroup SCHEME
  au BufRead,BufNewFile *.scm  setl filetype=scheme ts=2 sw=2 ai sta et
  au FileType clojure         :ToggleRaibowParenthesis
augroup END

augroup HASKELL
  au BufRead,BufNewFile *.hs   setl filetype=haskell ts=2 sw=2 ai sta et
augroup END

augroup JAVA
  au BufRead,BufNewFile *.java  setl filetype=java ts=4 sw=4 ai sta et
  au BufRead,BufNewFile *.java  setl tags=~/.jtags,~/src/ntua/.tags
  au Filetype java              setl makeprg=ant\ -find\ build.xml efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
  au Filetype java              nmap <F5> :mak<cr>
  au Filetype java              nmap <F6> :mak pub start<cr>
  au Filetype java              setl omnifunc=javacomplete#Complete
  au Filetype java              setl completefunc=javacomplete#CompleteParamsInfo
  au Filetype java              :ino <buffer> <tab> <c-x><c-o>
  au Filetype java              :ino <buffer> <c-s-space> <c-r>=TriggerSnippet()<cr>
  au Filetype java              :snor <buffer> <c-s-space> <esc>i<right><c-r>=TriggerSnippet()<cr>
augroup END

augroup HTML
  au BufNewFile *.html,.htm 0r       ~/.vim/templates/templ.html
  au BufRead,BufNewFile *.html,.htm  setl filetype=html sw=2 ts=2 sts=2 ai sta et
augroup END

augroup XML
  au BufNewFile build.xml 0r                ~/.vim/templates/templ.build.xml
  au BufNewFile *.xml 0r                    ~/.vim/templates/templ.xml
  au BufRead,BufNewFile *.xml,*.rss,*.opml  setl filetype=xml sw=2 ts=2 sts=2 ai sta et
  au BufRead,BufNewFile *.xsd,*.wsdd        setl filetype=xml sw=2 ts=2 sts=2 ai sta et
  au BufRead,BufNewFile *.pml               setl filetype=xml sw=2 ts=2 sts=2 ai sta et
  au BufRead,BufNewFile *.svg               setl filetype=svg sw=2 ts=2 sts=2 ai sta et
augroup END

augroup DN
  au BufNewFile,BufRead *.test,*.macro setl filetype=dntest sw=8 ts=8 sts=8 ai sta noet
augroup END

augroup VisualBasic
  au BufNewFile,BufRead *.vb  setl syntax=dntest sw=8 ts=8 sts=8 ai sta noet
augroup END

augroup STG
  au BufNewFile,BufRead *.stg  setl filetype=stringtemplate syntax=stringtemplatedollar sw=4 ts=4 sts=4 ai sta et
augroup END

augroup YAML
  au BufNewFile,BufRead *.yaml,*.yml  setl filetype=yaml sw=4 ts=4 sts=4 ai sta et
augroup END

" vim: set ts=2 sw=2 sts ai et
