"--------------------------------------------------------------------------
" Options

set report=0              " reporting number of lines changes
set shortmess=aoOtTIcqF
set cpoptions=aABceFs
set number relativenumber

set nofoldenable
set nocursorline
set nojoinspaces " prevents two spaces after on a join (J)

set diffopt=filler,iwhite,vertical,internal,algorithm:patience

set sidescroll=0

" Highlight invisible symbols
set nolist
set listchars=precedes:<,extends:>,nbsp:.,tab:+-,trail:•

set title
set titlelen=100
set titlestring=%t%(\ %M%)%(\ (%{expand('%:~:.:h')})%)%(\ %a%)

" Buffer
set hidden                   " allows the closing of buffers without saving
set switchbuf=useopen,split  " orders to open the buffer

" Window
set noequalalways
set winminheight=0
set splitbelow splitright

" Tab
set showtabline=0    " no tabs

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
set regexpengine=0  " 0=auto 1=old 2=NFA
set smartcase
set ignorecase
set hlsearch
set incsearch
set gdefault
set magic

set includeexpr=substitute(v:fname,'^[^\/]*/','','')

" Autocomplete
set tags=
set pumheight=10
set complete=. completeopt=menu

" Command-line
set cmdheight=1
set noshowmode   " don't show the mode ('-- INSERT --') at the bottom
set wildmenu wildmode=longest,full

if has('nvim')
  set pumblend=20
  set termguicolors
  set inccommand=nosplit
else
  if exists('+previewpopup')
    set previewpopup=height:10,width:60
  endif
  if exists('+completepopup')
    set completeopt+=popup
    set completepopup=height:4,width:60,highlight:InfoPopup
  endif
endif

set wildignore+=*swp,*.class,*.pyc,*.png,*.jpg,*.gif,*.zip
set wildignore+=*/tmp/*,*.o,*.obj,*.so     " Unix
set wildignore+=*\\tmp\\*,*.exe            " Windows
