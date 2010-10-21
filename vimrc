" my .vimrc
" vim: nowrap fdm=marker

" Folding cheet sheet
" zR    open all folds
" zM    close all folds
" za    toggle fold at cursor position
" zj    move down to start of next fold
" zk    move up to end of previous fold

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Manage plugins with pathogen {{{1
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
" }}}

" Gui fonts & colors {{{1
if has('gui_running')
  set t_Co=256

  if has("gui_mac") || has("gui_macvim")
    set guifont=Monaco:h14
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
" }}}

" General settings {{{1
set encoding=utf-8
set fileencoding=utf-8
set fileformat=unix
set history=1000
set title
set dir=/tmp
set backup
exec "set backupdir=" . "$HOME/.bak"
set autoread " Set to auto read when a file is changed from the outside
autocmd! Bufwritepost $MYVIMRC source $MYVIMRC " on .vimrc change, auto source

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set backspace=indent,eol,start " allow backspacing over everything in insert mode

set wildmenu " wmenu for file/command completion
set wildignore+=bin,classes,build,lib,.hg,.git,*.class,*.jar,*.o,*.hi,*.pyc,*~
set wildchar=<TAB>
set shellslash " use / rather than \ for filenames

set hls " hilight searches by default
set incsearch " do incremental searching
set ignorecase " case insensitive search
set smartcase " "case-sensitive if there are upper-case letters in the search pattern
set magic "Set magic on, for regular expressions

set showmatch " bouncy parens, must have
set nolazyredraw " don't redraw while executing macros
set splitright
set list listchars=tab:▸\ ,trail:·
set mouse=a " you can also use the * register
set ttymouse=xterm2 " magic stuff to enable the mouse
set scrolloff=2 " minimum lines between cursor and window edge
set laststatus=2
set statusline=\ %m%f%r%h\ %y\ \ %=%(%l,\ %c%)
set statusline+=\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}

set tabstop=8 " how many spaces for one tab?
set softtabstop=4 " emulating tab insertion
set shiftwidth=4 " number of spaces for each indent
set expandtab " turn tabs into spaces
set cindent
set autoindent

au BufWritePre * :%s/\s\+$//e " removing trailing whitespace on writing a file

au FocusLost * :wa " save file when losing focus
" }}}

" Basic mappings {{{

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let maplocalleader = ","

map == :call IndentStayPut()<cr>

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

" Clipboard copy/paste
vmap <Leader>c "+y
map <Leader>v "+gP

" Move by screen lines rather than actual lines
map j gj
map k gk
map <S-Down> <Down>
map <S-j> j
map <S-k> k

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Bash like keys for the command line
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-k> <c-U>

cnoremap <c-p> <up>
cnoremap <c-n> <down>

" Smart way to move between windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-h> <c-w>h
map <c-l> <c-w>l
"}}}

" Highlighting, syntax, indentation {{{
filetype off " necessary on some Linux distros for pathogen to properly load bundles
filetype on
filetype plugin on
filetype indent on
syntax on
" }}}

" Plugin stuff {{{
let vimclojure#WantNailgun = 1
let vimclojure#HighlightBuiltins = 1
let vimclojure#ParenRainbow = 1

let NERDTreeSortOrder = ['\/$', '\.py', '\.y', '\.h', '\.c', '\.hs']
let NERDTreeWinSize = 20
let NERDTreeIgnore = ['\.o', '\.hi', '\.pyc', '\.class']
let NERDTreeWinPos = "right"

map <silent> <f2> <leader>et
imap <silent> <f2> <leader>et
map <silent> <f3> <leader>ef
imap <silent> <f3> <leader>ef
map <silent> <f5> <esc>:NERDTree<cr>
nmap <silent> ,t :CommandT<cr>
" }}}

" Language specific {{{
au FileType c setl softtabstop=8 shiftwidth=8 noet
au FileType python setl :ToggleRaibowParenthesis
au FileType javascript :ToggleRaibowParenthesis
au BufRead,BufNewFile *.json setl filetype=javascript
au FileType coffeescript :ToggleRaibowParenthesis
au FileType clojure setl softtabstop=2 shiftwidth=2 lisp
au FileType clojure :ToggleRaibowParenthesis
au FileType scheme setl softtabstop=2 shiftwidth=2 lisp
au FileType scheme :ToggleRaibowParenthesis
au FileType html setl softtabstop=2 shiftwidth=2
au FileType xml setl softtabstop=2 shiftwidth=2
" }}}

" Various functions {{{
" reformat file
fun! IndentStayPut()
  let oldLine=line('.')
  normal(gg=G)
  execute ':' . oldLine
endf

" }}}
