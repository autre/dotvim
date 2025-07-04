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

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" plugins {{{
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-markdown'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'bling/vim-airline'
Plugin 'luochen1990/rainbow'
Plugin 'ronny/birds-of-paradise.vim'
Plugin 'vim-test/vim-test'
"}}}

call vundle#end()
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

" Enable native mouse support
set mouse=a
set ttymouse=sgr
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
set diffopt+=vertical

" Enable 24-bit colors
" set termguicolors
let &t_8f = "\<Esc>[38:2::%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2::%lu:%lu:%lum"

" check file change every 4 seconds ('CursorHold') and reload the buffer upon detecting change
set autoread
au CursorHold * checktime
packadd! matchit

"au FocusLost * :wa " save file when losing focus
" }}}

" Fonts & colors {{{
syntax enable
colorscheme birds-of-paradise
set background=light
set t_ut= " improve screen clearing by using the background color

if has('gui_running')
  " Remove GUI menu and toolbar
  set guioptions-=mT
  set guifont=mononoki\ 13
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
"}}}

" Highlighting, syntax, indentation {{{
filetype off " necessary on some Linux distros for pathogen to properly load bundles
filetype on
filetype plugin on
filetype indent on
" }}}

" Plugin stuff {{{

" fzf
nmap <silent>; :Files<cr>

let g:rainbow_active = 1

" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> <F9> :TestFile<CR>
nmap <silent> <F10> :TestSuite<CR>
nmap <silent> <F8> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

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
au FileType html setl omnifunc=htmlcomplete#CompleteTags
au FileType css setl omnifunc=csscomplete#CompleteCSS
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
