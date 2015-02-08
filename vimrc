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
filetype off " required by vundler

set rtp+=~/.vim/vundle.git/
call vundle#rc()

" bundles {{{1
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
Bundle 'vim-scripts/matchit.zip'
Bundle 'scrooloose/syntastic'
Bundle 'craigemery/vim-autotag'
Bundle 'kien/ctrlp.vim'
Bundle 'vim-scripts/slimv.vim'

Bundle 'kien/rainbow_parentheses.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'bling/vim-airline'
"}}}

filetype on " bring it back on

let s:os = substitute(system('uname'), '\n', '', '')

" General settings {{{1
set encoding=utf-8
set fileencoding=utf-8
set fileformat=unix
set history=1000
set title
set dir=/tmp
set nobackup
set nowritebackup
set autoread " Set to auto read when a file is changed from the outside
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set backspace=indent,eol,start " allow backspacing over everything in insert mode

set wildmenu " wmenu for file/command completion
set wildignore+=classes,build,.hg,.git,*.class,*.jar,*.o,*.hi,*.pyc,*~
set wildchar=<TAB>
set shellslash " use / rather than \ for filenames

set hls " hilight searches by default
set incsearch " do incremental searching
set ignorecase " case insensitive search
set smartcase " "case-sensitive if there are upper-case letters in the search pattern
set magic "Set magic on, for regular expressions

set showmatch " bouncy parens, must have
set lazyredraw " redraw only when we need to
set splitright
set list listchars=tab:▸\ ,trail:·
set ttymouse=xterm2 " magic stuff to enable the mouse
set mouse=a
set mousemodel=popup
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
set clipboard+=unnamed " Put contents of unnamed register in system clipboard
set tags=.tags;~/.tags
set diffopt+=vertical
"set cryptmethod=blowfish2

" check file change every 4 seconds ('CursorHold') and reload the buffer upon detecting change
set autoread
au CursorHold * checktime

au FocusLost * :wa " save file when losing focus
" }}}

" Gui fonts & colors {{{1
set t_Co=256
colorscheme badwolf
set background=dark

if has('gui_running')
  colorscheme badwolf

  " Remove GUI menu and toolbar
  set guioptions-=m
  set guioptions-=T

  if s:os == "Darwin"
    set guifont=Inconsolata:h16
  else
    set guifont=Inconsolata\ 11
  endif
endif
" }}}

" Basic mappings {{{
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let maplocalleader = "\\"

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

" Move by screen lines rather than actual lines
map j gj
map k gk
map <S-Down> <Down>

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

" work around the breakage between tmux and command-t
" when issuing ,t and then arrow key.
map <Esc>[B <Down>

" highlight last inserted text
nnoremap gV `[v`]

" decode attachment (notmuch)
vmap <leader>d <esc>:'<,'>:w !base64 -d
"}}}

" Highlighting, syntax, indentation {{{
filetype off " necessary on some Linux distros for pathogen to properly load bundles
filetype on
filetype plugin on
filetype indent on
syntax on
" }}}

" Plugin stuff {{{

" ctrl-p
nmap <silent> ,r :CtrlP<cr>
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

" solarized config
let g:solarized_termtrans=1
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"

let g:tex_flavor='latex'

" slimv/lisp
if s:os == "Darwin"
    let g:slimv_python='/usr/local/bin/python'
    let g:slimv_swank_cmd = '!osascript -e "tell application \"Terminal\" to do script \"sbcl --load ~/.vim/bundle/slimv.vim/slime/start-swank.lisp\""'
else
    let g:slimv_python='/usr/bin/python2'
endif

" syntastic
let g:syntastic_enable_signs=1
let g:syntastic_quiet_messages = { 'level': 'all' }
let g:syntastic_javascript_checkers = ['jshint']

" rainbow_parentheses
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces
" }}}

" Language specific {{{
au FileType java setl softtabstop=4 shiftwidth=4 et

au FileType c setl softtabstop=8 shiftwidth=8 noet
au FileType sh setl softtabstop=8 shiftwidth=8 noet
au FileType lisp :ToggleRaibowParenthesis
au FileType lisp,scheme setlocal equalprg=lispindent.lisp " proper lisp indentation

au FileType javascript setl softtabstop=4 shiftwidth=4 et
au FileType javascript :ToggleRaibowParenthesis
au FileType javascript :setl omnifunc=javascriptcomplete#CompleteJS
au BufRead,BufNewFile *.json setl filetype=javascript

au FileType html setl softtabstop=2 shiftwidth=2
au FileType html set omnifunc=htmlcomplete#CompleteTags
au FileType css set omnifunc=csscomplete#CompleteCSS

au FileType xml setl softtabstop=2 shiftwidth=2

" }}}

" Various helpers {{{
" on .vimrc change, auto source
autocmd! Bufwritepost $MYVIMRC source $MYVIMRC

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

" reformat file
fun! IndentStayPut()
  let oldLine=line('.')
  normal(gg=G)
  execute ':' . oldLine
endf
" }}}
