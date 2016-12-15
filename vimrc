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

set rtp+=~/.vim/vundle
call vundle#rc()

" bundles {{{
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
Bundle 'vim-scripts/matchit.zip'
Bundle 'craigemery/vim-autotag'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'bling/vim-airline'
Bundle 'scrooloose/syntastic'
Bundle 'vim-scripts/slimv.vim'
Bundle 'elzr/vim-json'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'ternjs/tern_for_vim'
Bundle 'lambdatoast/elm.vim'
Bundle 'elixir-lang/vim-elixir'
"}}}

filetype on " bring it back on

" General settings {{{
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
set tags=.tags
set diffopt+=vertical
"set cryptmethod=blowfish2

" check file change every 4 seconds ('CursorHold') and reload the buffer upon detecting change
set autoread
au CursorHold * checktime

au FocusLost * :wa " save file when losing focus
" }}}

" Gui fonts & colors {{{

set background=dark
set t_ut= " improve screen clearing by using the background color

if has('gui_running')
  " Remove GUI menu and toolbar
  set guioptions-=mT
  set guifont=Inconsolata\ 15
  colorscheme solarized
else
  set t_Co=256
endif

syntax on
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
"}}}

" Highlighting, syntax, indentation {{{
filetype off " necessary on some Linux distros for pathogen to properly load bundles
filetype on
filetype plugin on
filetype indent on
" }}}

" Plugin stuff {{{

" ctrl-p
nmap <silent> ,r :CtrlP<cr>
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
"let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

" solarized config
"let g:solarized_termtrans=1
"let g:solarized_termcolors=256
"let g:solarized_contrast="high"
"let g:solarized_visibility="high"

let g:tex_flavor='latex'

" slimv/lisp
let g:slimv_python='/usr/bin/python2'

" syntastic
let g:syntastic_enable_signs=1
let g:syntastic_quiet_messages = { 'level': 'all' }
let g:syntastic_javascript_checkers = ['eslint']

" rainbow_parentheses
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" Language specific {{{
au FileType java setl softtabstop=4 shiftwidth=4 et
au FileType java nnoremap <leader>j :JUnit<cr>
au FileType java nnoremap <leader>j* :JUnit<cr>
au BufWritePost *.java call system('ctags -f .tags -R src --languages=java -a '.expand('%'))

au FileType make setl softtabstop=8 shiftwidth=8 noet
au FileType c setl softtabstop=8 shiftwidth=8 et
au FileType sh setl softtabstop=4 shiftwidth=4 et
au FileType lisp,scheme setl equalprg=lispindent.lisp " proper lisp indentation

au FileType javascript setl softtabstop=4 shiftwidth=4 et
au FileType javascript :setl omnifunc=javascriptcomplete#CompleteJS

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
