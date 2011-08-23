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
Bundle 'tpope/vim-unimpaired'
Bundle 'vim-scripts/VimClojure'
Bundle 'vim-scripts/The-NERD-tree'
Bundle 'vim-scripts/snipMate'
Bundle 'vim-scripts/matchit.zip'
Bundle 'vim-scripts/taglist-plus'
Bundle 'vim-scripts/javacomplete'
Bundle 'vim-scripts/Command-T'
Bundle 'autre/Rainbow-Parenthsis-Bundle'
Bundle 'nuclearsandwich/vim-latex'
Bundle 'altercation/vim-colors-solarized'
Bundle 'Raimondi/delimitMate'
"}}}

filetype on " bring it back on

" Gui fonts & colors {{{1
set background=dark

if has('gui_running')
  set t_Co=256

  if has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
      set guifont=Inconsolata:h16
    else
      set guifont=Inconsolata\ 13
    endif
  endif

  " Remove GUI menu and toolbar
  set guioptions-=m
  set guioptions-=T
  set background=light
  colorscheme solarized
else
  set background=dark
  colorscheme desert256
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
set wildignore+=classes,build,.hg,.git,*.class,*.jar,*.o,*.hi,*.pyc,*~
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

"" The following came from
"" http://concisionandconcinnity.blogspot.com/2009/07/vim-part-ii-matching-pairs.html
"inoremap ( ()<Left>
"inoremap [ []<Left>
"inoremap { {}<Left>
"autocmd Syntax html,vim inoremap < <lt>><left>
"
"function! ClosePair(char)
"  if getline('.')[col('.') - 1] == a:char
"    return "\<Right>"
"  else
"    return a:char
"  endif
"endf
"
"inoremap ) <c-r>=ClosePair(')')<CR>
"inoremap } <c-r>=ClosePair('}')<CR>
"inoremap ] <c-r>=ClosePair(']')<CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
"map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" CTags
"map <Leader>rt :!ctags --extra=+f -R *<CR><CR>

nmap \n :cn<cr>
nmap \p :cp<cr>
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
let NERDTreeWinSize = 30
let NERDTreeIgnore = ['\.o', '\.hi', '\.pyc', '\.class']
let NERDTreeWinPos = "left"
map <Leader>p :NERDTreeToggle<cr>

let g:CommandTMaxHeight=20

let g:Tlist_Compact_Format=1
let g:Tlist_Highlight_Tag_On_BufEnter=1
let g:Tlist_Show_One_File=1
let g:Tlist_Exit_OnlyWindow = 1
nnoremap <silent> <F8> :TlistToggle<CR>

" vimclojure repl mappings
map <silent> <f2> <leader>et
imap <silent> <f2> <leader>et
map <silent> <f3> <leader>ef
imap <silent> <f3> <leader>ef

nmap <silent> ,t :CommandT<cr>

let g:solarized_termtrans=1
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"
" }}}

" Language specific {{{
au FileType c setl softtabstop=8 shiftwidth=8 noet
au FileType sh setl softtabstop=8 shiftwidth=8 noet
au FileType python :ToggleRaibowParenthesis
au FileType javascript :ToggleRaibowParenthesis
au FileType javascript setl tags=.tags
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
au BufRead,BufNewFile *.json setl filetype=javascript
au FileType coffeescript :ToggleRaibowParenthesis
au FileType clojure setl softtabstop=2 shiftwidth=2 lisp
au FileType clojure :ToggleRaibowParenthesis
au FileType scheme setl softtabstop=2 shiftwidth=2 lisp
au FileType scheme :ToggleRaibowParenthesis
au FileType java :ToggleRaibowParenthesis
au FileType java set makeprg=ant\ -emacs\ -q\ -find
au FileType java setl tags=~/.tags,.tags complete=.,w,b,u,t,i omnifunc=javacomplete#Complete
au FileType html setl softtabstop=2 shiftwidth=2
au FileType html set omnifunc=htmlcomplete#CompleteTags
au FileType xml setl softtabstop=2 shiftwidth=2
au FileType tex setl grepprg=grep\ -nH\ $* sw=2 iskeyword+=:
au FileType css set omnifunc=csscomplete#CompleteCSS

let g:tex_flavor='latex'
" }}}

" Various functions {{{
" reformat file
fun! IndentStayPut()
  let oldLine=line('.')
  normal(gg=G)
  execute ':' . oldLine
endf

" }}}
