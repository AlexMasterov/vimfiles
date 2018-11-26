"--------------------------------------------------------------------------
" Options

set shortmess=aoOtTIcF
set lazyredraw               " don't redraw while executing macros
set report=0                 " reporting number of lines changes

" Title-line
set title titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)

" Do not wait more than 100 ms for keys
set timeout
set ttimeout ttimeoutlen=100

" Prevents two spaces after on a join (J)
set nojoinspaces

" Buffer
set hidden                   " allows the closing of buffers without saving
set switchbuf=useopen,split  " orders to open the buffer

" Window
set noequalalways
set winminheight=0
set splitbelow splitright

" Tabs
set showtabline=0            " always show the tab pages

" Indent
set backspace=indent,eol,start

set cindent          " smart indenting for c-like code
set autoindent       " indent at the same level of the previous line
set shiftround       " indent multiple of shiftwidth

set expandtab        " spaces instead of tabs
set tabstop=2        " spaces per tab for display
set shiftwidth=2     " spaces per tab in insert mode
set softtabstop=2    " spaces when indenting

set linebreak
set showbreak=\
set breakat=\ \ ;:,!?

" Wrapping
if exists('+breakindent')
  set wrap                         " wrap long lines
  set breakindent                  " wrap lines, taking indentation into account
  set breakindentopt=shift:4       " indent broken lines
  set textwidth=0                  " do not wrap text
  set display+=lastline            " easy browse last line with wrap text
  set whichwrap=<,>,[,],h,l,b,s,~  " end/beginning-of-line cursor wrapping behave human-like
else
  set nowrap
  set sidescroll=1
endif

" Search
set smartcase
set ignorecase
set hlsearch
set incsearch
set gdefault
set magic

" Autocomplete
set tags=
set pumheight=10
set complete=. completeopt=menu,longest

" Command-line
set cmdheight=1
set noshowmode   " don't show the mode ('-- INSERT --') at the bottom
set wildmenu wildmode=longest,full

set number relativenumber
set diffopt=filler,iwhite,vertical

set noswapfile
set nocursorline
set nofoldenable

" Highlight invisible symbols
set nolist listchars=precedes:<,extends:>,nbsp:.,tab:+-,trail:•
" Avoid showing trailing whitespace when in Insert mode
let g:trailChars = matchstr(&listchars, '\(trail:\)\@<=\S')

Autocmd InsertEnter * setlocal list
 \| execute 'setlocal listchars+=trail:' . g:trailChars
Autocmd InsertLeave * setlocal nolist
 \| execute 'setlocal listchars-=trail:' . g:trailChars
