" .vimrc Alex Masterov <alex.masterow@gmail.com>

" Environment
    set nocompatible
    set noswapfile
    set viminfo+=n$VIM/_viminfo

    " Remember changes
    if has('persistent_undo')
        set undofile       undodir=$VIM/undo
        set undolevels=500 undoreload=1000
    endif

    " Encoding
    if has('multi_byte')
        set fileencodings=utf-8,cp1251
        set encoding=utf-8 | scriptencoding utf-8
    endif

    " Russian keyboard
    set iskeyword=@,48-57,_,192-255
    set keymap=russian-jcukenwin
    set iminsert=0 imsearch=0

    " Filetypes detection
    filetype plugin indent on

    " Syntax coloring lines
    set synmaxcol=512

    " Avoid loading same plugins. +100 speed
    let g:loaded_matchparen = 1         " disable matchparen.vim
    let g:loaded_netrwPlugin = 1        " disable netrw.vim
    let g:loaded_getscriptPlugin = 1    " disable getscriptPlugin.vim

    " Ignore these things
    set suffixes=.hg,.git,.svn          " version control
    set suffixes+=.png,.jpg,.jpeg,.gif  " binary images
    set suffixes+=.o,.obj,.exe,.dll     " compiled object files
    set suffixes+=.cabal-dev            " cabal
    set suffixes+=.dist                 " cabal distrubition

    " Basic remapping
    let mapleader = ',' | nmap ; :

    " Basic autocommands
    augroup environment
        au!
        au BufWritePost $MYVIMRC source $MYVIMRC
        " Save when losing focus
        au FocusLost silent! :wa
        " Only show the cursorline in the current window
        au WinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
        " Color column (only on insert)
        au InsertEnter * setlocal colorcolumn=80
        au InsertLeave * setlocal colorcolumn=""
        " Toggle type of line numbers and display invisible symbols
        au InsertEnter * set number nolist
        au InsertLeave * set relativenumber list
        " Dont continue comments when pushing
        au FileType * setlocal formatoptions-=ro
        " Auto strip ^M characters
        au BufWritePre * silent! :%s/\r\+$//e
        " Auto strip trailing whitespace at the end of non-blank lines
        au BufWritePre *.{hs,php,js,css,html,html.twig,hamlet,yml,vim} :%s/\s\+$//e | retab
        " Restore cursor to file position in previous editing session (from viminfo)
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")|exe 'normal! g`"zvzz'|endif
        " Large files are > 5M
        let g:LargeFile = 1024 * 1024 * 5
        au BufReadPre * if getfsize(expand('<afile>')) > g:LargeFile|setlocal eventignore+=FileType bufhidden=unload buftype=nowrite undolevels=-1|endif
    augroup END

    " Basic filetypes
    augroup filetypes
        au!
        " Nginx syntax
        au BufNewFile,BufRead */conf/* setlocal filetype=nginx
        " Twig syntax
        au BufNewFile,BufRead *.twig setlocal filetype=twig
        au BufNewFile,BufRead *.html.twig setlocal filetype=html.twig
        " Json syntax
        au BufNewFile,BufRead *.json setlocal filetype=javascript
        " jQuery syntax
        au BufNewFile,BufRead jquery.*.js setlocal filetype=jquery syntax=jquery
    augroup END

    " Basic indentation
    augroup indentation
        au!
        " HTML
        au Filetype html setlocal ts=2 sts=2 sw=2
        " CSS
        au Filetype css setlocal ts=2 sts=2 sw=2
        au Syntax   css syntax sync minlines=50
        " JavaScript
        au Filetype javascript setlocal ts=4 sts=4 sw=4 noet
        " PHP
        au Filetype php setlocal ts=4 sts=4 sw=4 nowrap
        " Haskell
        au Filetype haskell setlocal ts=8 sts=4 sw=4 ai sta sr nojs
        " Hamlet
        au Filetype hamlet setlocal ts=2 sts=2 sw=2
        " Twig
        au Filetype twig,html.twig setlocal ts=2 sts=2 sw=2 cms={#%s#}
    augroup END

" Setup NeoBundle Support
    if has('vim_starting')
        set rtp+=$VIMRUNTIME/bundle/neobundle.vim
        call neobundle#rc('$VIMRUNTIME/bundle/')
    endif
    " Let NeoBundle manage NeoBundle
    NeoBundleFetch 'Shougo/neobundle.vim'

" Bundles
    " Ack
    if executable('ack')
        NeoBundle 'mileszs/ack.vim'
        nmap <silent> <leader>ac :Ack!<space>
        nmap <silent> <leader>af :AckFile<cr>
        nmap <silent> <leader>as :AckFromSearch<cr>
        nmap <silent> <leader>aw :exe 'Ack ' . expand('<cword>') <Bar> cw<cr>
    endif

    " Session manager
    NeoBundle 'sessionman.vim'
    nmap <silent> <leader>sl :SessionList<cr>
    nmap <silent> <leader>ss :SessionSave<cr>
    set sessionoptions=buffers,curdir,folds,resize,tabpages,unix,slash

    " Gundo
    if has('python') && has('persistent_undo')
        NeoBundle 'sjl/gundo.vim'
        let g:gundo_help = 0
        let g:gundo_right = 1
        let g:gundo_width = 32
        let g:gundo_preview_bottom = 1
        let g:gundo_tree_statusline = ' '
        let g:gundo_preview_statusline = ' '
        nmap <silent> <leader>o :GundoToggle<cr><cr>
    endif

    " NERDTree
    NeoBundle 'scrooloose/nerdtree'
    let NERDTreeWinPos = 'right'
    let NERDTreeWinSize = 34
    let NERDTreeMinimalUI = 1
    let NERDTreeDirArrows = 1
    let NERDTreeShowBookmarks = 1
    let NERDTreeBookmarksFile = $VIMRUNTIME.'/NERDTreeBookmarks'
    let NERDTreeIgnore = map(split(&suffixes, ','), '"\\".v:val."\$"')
    " NERDTreeTabs
    NeoBundle 'jistr/vim-nerdtree-tabs'
    let nerdtree_tabs_focus_on_files = 1
    let nerdtree_tabs_open_on_gui_startup = 0
    nmap <silent> <leader>i :NERDTreeTabsToggle<cr>

    " Syntastic
    NeoBundle 'scrooloose/syntastic'
    let g:syntastic_auto_jump = 1
    let g:syntastic_auto_loc_list = 2  " auto close error window when there are no errors
    let g:syntastic_check_on_open = 0
    let g:syntastic_error_symbol = '✗'
    let g:syntastic_mode_map = {
        \ 'mode': 'passive',
        \ 'active_filetypes': ['php','html','css','javascript'],
        \ 'passive_filetypes': [] }
    let g:syntastic_stl_format = '%E{err: %e line: %fe}%B{, }%W{warn: %w line: %fw}'
    " Syntax checkers
    let g:syntastic_csslint_options = '--ignore=ids'
    let g:syntastic_javascript_jslint_conf = '--node --nomen --anon --sloppy --regex'
    nmap <silent> <leader>E :Errors<cr>

    " Fugitive
    NeoBundle 'tpope/vim-fugitive'
    nmap <silent> <leader>gs :Gstatus<cr>
    nmap <silent> <leader>gd :Gdiff<cr>
    nmap <silent> <leader>gc :Gcommit<cr>
    nmap <silent> <leader>gb :Gblame<cr>
    nmap <silent> <leader>gl :Glog<cr>
    nmap <silent> <leader>gp :Git push<cr>
    nmap <silent> <leader>gw :Gwrite<cr>

    " Tabularize
    NeoBundle 'godlygeek/tabular'
    map <leader>t== :Tabularize /=<cr>
    map <leader>t=> :Tabularize /=><cr>
    map <leader>t:  :Tabularize /:\zs<cr>
    map <leader>t:: :Tabularize /:\zs<cr>
    map <leader>t,  :Tabularize /,<cr>
    map <leader>t<space> :Tabularize / <cr>

    " NERDCommenter
    NeoBundle 'scrooloose/nerdcommenter'
    let NERDSpaceDelims = 1

    " EasyMotion
    NeoBundle 'Lokaltog/vim-easymotion'
    let g:EasyMotion_mapping_w = '<C-q>'
    let g:EasyMotion_mapping_b = '<C-w>'

    " Colorv
    if has('python')
        NeoBundleLazy 'Rykka/colorv.vim',
        \ {'autoload' : {'filetypes' : ['html','css','vim']}}
        let g:colorv_preview_ftype = 'css,html,javascript,vim'
    endif

    " UltiSnips
    if has('python')
        NeoBundle 'UltiSnips'
        let g:UltiSnipsSnippetDirectories = ['snippets']
    endif

    " Supertab
    if exists('+omnifunc')
        NeoBundle 'ervandew/supertab'
        let g:SuperTabDefaultCompletionType = 'context'
        " Disable cr to fix conflict with delimitMate
        " let g:SuperTabCrMapping = '<C-cr>'
    endif

    " Zen Coding
    NeoBundleLazy 'mattn/zencoding-vim',
        \ {'autoload' : {'filetypes' : ['html','html.twig','twig','hamlet']}}
    let g:user_zen_expandabbr_key = '<c-e>'

    " HTML
    NeoBundleLazy 'gregsexton/MatchTag',
        \ {'autoload' : {'filetypes' : ['html','html.twig','twig','hamlet']}}
    NeoBundleLazy 'docunext/closetag.vim',
        \ {'autoload' : {'filetypes' : ['html','html.twig','twig','hamlet']}}

    " CSS
    NeoBundleLazy 'miripiruni/CSScomb-for-Vim',
        \ {'autoload' : {'filetypes' : 'css'}}
    nmap <silent> <F9> :CSSComb<cr>

    " JavaScript
    NeoBundleLazy 'nono/jquery.vim',
        \ {'autoload' : {'filetypes' : 'jquery'}}
    NeoBundleLazy 'jelera/vim-javascript-syntax',
        \ {'autoload' : {'filetypes' : 'javascript'}}
    NeoBundleLazy 'jiangmiao/simple-javascript-indenter',
        \ {'autoload' : {'filetypes' : ['javascript','jquery']}}
    let g:SimpleJsIndenter_BriefMode = 1
    let g:SimpleJsIndenter_CaseIndentLevel = -1
    NeoBundleLazy 'teramako/jscomplete-vim',
        \ {'autoload' : {'filetypes' : ['javascript','jquery']}}
    let g:jscomplete_use = ['dom', 'moz']

    " PHP
    NeoBundleLazy 'phpvim',
        \ {'autoload' : {'filetypes' : 'php'}}
    " Syntax settings
    let php_folding = 0
    let php_sql_query = 1
    let php_html_in_strings = 1

    " Haskell
    NeoBundleLazy 'ujihisa/neco-ghc',
        \ {'autoload' : {'filetypes' : 'haskell'}}
    NeoBundleLazy 'Shougo/vimproc',
        \ {'autoload' : {'filetypes' : 'haskell'},
        \ 'build' : {'windows' : 'make -f make_mingw32.mak'}}
    NeoBundleLazy 'Twinside/vim-haskellConceal',
        \ {'autoload' : {'filetypes' : 'haskell'}}
    NeoBundleLazy 'haskell/haskell-mode-vim',
        \ {'autoload' : {'filetypes' : 'haskell'}}
    NeoBundleLazy 'Twinside/vim-syntax-haskell-cabal',
        \ {'autoload' : {'filetypes' : 'cabal'}}
    NeoBundleLazy 'pbrisbin/html-template-syntax',
        \ {'autoload' : {'filetypes' : ['hamlet','julius','lucius']}}
    " Syntax settings
    let hs_highlight_debug = 1
    let hs_highlight_types = 1
    let hs_highlight_boolean = 1
    let hs_allow_hash_operator = 1
    " The Haskell mode
    NeoBundleLazy 'lukerandall/haskellmode-vim',
        \ {'autoload' : {'filetypes' : 'haskell'}}
    " Configure browser for haskell_doc.vim
    let g:haddock_browser = 'open'
    let g:haddock_browser_callformat = '%s %s'
    " Happy Haskell programming
    NeoBundle 'eagletmt/ghcmod-vim'
    au! FileType haskell compiler ghc | GhcModCheckAsync

    " Basic utility
    NeoBundle 'AutoComplPop'
    NeoBundle 'tpope/vim-repeat'
    NeoBundle 'tpope/vim-surround'
    NeoBundle 'tpope/vim-abolish'      " awesome replace
    NeoBundle 'shell.vim--Odding'      " fullscreen mode
    NeoBundle 'tpope/vim-speeddating'  " CTRL-A/CTRL-X to increment dates
    " NeoBundle 'jiangmiao/auto-pairs'
    NeoBundle 'kana/vim-smartchr'      " Insert several candidates with a single key
    " Haskell
    au! FileType haskell
        \  imap <buffer> <expr> \ smartchr#loop('\ ', '\')
        \| imap <buffer> <expr> $ smartchr#loop(' $ ', '$')
        \| imap <buffer> <expr> + smartchr#loop('+', ' ++ ')
        \| imap <buffer> <expr> . smartchr#loop('.', ' . ', '..')
        \| imap <buffer> <expr> : smartchr#loop(':', ' :: ', ' : ')
        \| imap <buffer> <expr> = smartchr#loop('=', ' = ', ' == ')
        \| imap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')

    " Omni complete
    if exists('+omnifunc')
        " Limit the popup menu height
        set pumheight=10
        set complete=.,w,b,u,U
        set completeopt=menuone,longest,preview
        " Try to adjust insert completions for case
        set infercase
        " Show full tags when doing search completion
        set showfulltag

        imap <leader>, <C-x><C-o>
        imap <leader>; <C-x><C-f>
        imap <leader>= <C-x><C-l>

        " Enable omni completion
        augroup omnicomplete
            au!
            au FileType haskell setlocal omnifunc=necoghc#omnifunc
            au FileType php setlocal omnifunc=phpcomplete#CompletePHP
            au FileType css setlocal omnifunc=csscomplete#CompleteCSS
            au FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            au FileType html setlocal omnifunc=htmlcomplete#CompleteTags
            au FileType javascript setlocal omnifunc=jscomplete#CompleteJS
            " Syntax complete if nothing else available
            au Filetype * if &omnifunc == ''|setlocal omnifunc=syntaxcomplete#Complete|endif
            " Automatically open and close the popup menu / preview window
            au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        augroup END
    endif

" Vim UI
    colorscheme simplex | syntax on
    " Reload the colorscheme whenever we write the file
    au! BufWritePost simplex.vim colorscheme simplex | ColorVPreview

    set guioptions=a
    set guifont=DejaVu_Sans_Mono:h10:cRUSSIAN,Consolas:h11:cRUSSIAN
    " winsize 120 100 | winpos 0 0

    set autowrite               " automatically save before commands like :make
    set shortmess=fmxsIaoO      " disable intro message
    set linespace=2             " extra spaces between rows
    set textwidth=0             " disable automatic text-width
    set relativenumber          " show the line number
    set virtualedit=all         " allow virtual editing in all modes
    set nostartofline           " avoid moving cursor to BOL when jumping around
    set lazyredraw              " don't redraw while executing macros
    set timeoutlen=1200         " a little bit more time for macros
    set ttimeoutlen=50          " make Esc work faster

" Buffers & Windows
    set hidden                  " allow buffer switching without saving
    set autoread                " auto reload changed files
    set autochdir               " auto switch to the current file directory
    set switchbuf=useopen       " orders to open the buffer
    set showtabline=2           " always show the tab pages
    set scrolloff=3             " lines visible above/below cursor when scrolling
    set sidescrolloff=3         " lines visible left/right of cursor when scrolling
    set splitbelow splitright   " splitting a window below/right the current one
    set noequalalways           " resize windows as little as possible

" Formatting
    set wrap                    " wrap long lines
    set linebreak               " wrap without line breaks
    set expandtab               " spaces instead of tabs
    set autoindent              " indent at the same level of the previous line
    set smartindent             " smart automatic indenting
    set tabstop=4               " number of spaces
    set shiftwidth=4            " number of spaces for (auto)indent
    set softtabstop=4           " backspace delete indent
    " Backspacing settings
        " indent  allow backspacing over autoindent
        " eol     allow backspacing over line breaks (join lines)
        " start   allow backspacing over the start of insert;
        "         CTRL-W and CTRL-U stop once at the start of insert
    set backspace=indent,eol,start
    " Highlight invisible symbols
    set list
    set listchars=trail:.,precedes:<,extends:>,nbsp:.,tab:+-

" Folding
    set nofoldenable            " don't do any folding for now

" Mouse
    set mousehide               " hide the mouse pointer while typing
    set cursorline              " highlight the current line
    set guicursor=n-v:blinkon0  " turn off blinking the cursor

" Search
    set hlsearch                " highlight search results
    set incsearch               " find as you type search
    set ignorecase              " case insensitive search
    set smartcase               " case sensitive when uc present
    set gdefault                " flag 'g' by default for replacing
    set magic                   " turn magic on

" Command-line
    set wildmenu                    " show list instead of just completing
    set wildmode=list:longest,full  " completion modes

" Statusline
    " Always show the statusline
    set laststatus=2
    " Format the statusline
    set statusline=%1*\ %l%*.%L\ %*                    " line & total line
    set statusline+=%<%f\ %2*%-2M%*                    " filename
    set statusline+=%2*%{SyntasticStatuslineFlag()}%*  " syntastic
    set statusline+=%=                                 " left/right separator
    set statusline+=%2*%(%{&paste?'paste':''}\ %)%*    " pastemode
    set statusline+=%2*%(%{&wrap?'':'nowrap'}\ %)%*    " wrapmode
    set statusline+=%(%{FileSize()}\ %)                " filesize
    set statusline+=%(%{&fileencoding}\ %)             " encoding
    set statusline+=%2*%(%Y\ %)%*                      " filetype
    " set statusline+=%(%{synIDattr(synID(line('.'),col('.'),1),'name')}\ %)
    " Statusline function
    function! FileSize()
        let bytes = getfsize(expand('%:p'))
        if bytes <= 0
            return ''
        endif
        if bytes < 1024
            return bytes . 'B'
        else
            return (bytes / 1024) . 'K'
        endif
    endfunction

" Normal mode
    " Fast save
    nmap <A-w> :w!<cr>
    " Move one line
    nmap <A-h> <<
    nmap <A-l> >>
    nmap <A-j> ddp
    nmap <A-k> ddkP
    " Tabs control
    nmap <A-2> :tabnew<cr>
    nmap <A-q> gT
    nmap <A-e> gt
    nmap <A-1> :q<cr>
    nmap <silent> <A-a> :exe 'silent! tabmove ' . (tabpagenr()-2)<cr>
    nmap <silent> <A-d> :exe 'silent! tabmove ' . tabpagenr()<cr>
    " Windows control
    nmap <silent> <A-o> :wincmd k<cr>
    nmap <silent> <A-p> :wincmd l<cr>
    nmap <silent> <A-u> :wincmd h<cr>
    nmap <silent> <A-i> :wincmd j<cr>
    nmap <silent> <A-r> :wincmd w<cr>
    " Window splitting
    nmap <silent> <A-[> :split<cr>
    nmap <silent> <A-]> :vsplit<cr>
    " Window swapping
    nmap <silent> <A-f> :wincmd x<cr>
    " Bracket match
    nmap <tab> %
    " Q to qq
    nmap Q qq
    " Don't skip wrap lines
    nmap j gj
    nmap k gk
    " ,ev opens .vimrc in a new tab
    nmap <leader>ev :tabedit $MYVIMRC<cr>
    " Toggle modes
    nmap <silent> <leader>p :setlocal paste!<cr>
    nmap <silent> <leader>lw :setlocal wrap!<cr>
    nmap <silent> <leader>tt :setlocal shellslash!<cr>
    " Quickfix shortcuts
    nmap <silent> <C-n> :cn<cr>
    nmap <silent> <C-m> :cp<cr>
    " Clear highlight after search
    nmap <silent> <leader><space> :nohlsearch<cr>
    " Don't jump when using * for search
    nmap * *<C-o>
    " Keep search matches in the middle of the window
    nmap n nzz
    nmap N Nzz
    nmap # #zz
    nmap g* g*zz
    nmap g# g#zz
    nmap g; g;zz
    nmap g, g,zz
    " Select all
    nmap vA ggVG
    " Try this
    nmap <C-l> 10zl
    nmap <C-h> 10zh
    nmap <C-j> <C-f>
    nmap <C-k> <C-b>
    " gw Swap two words
    nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<cr>`'

" Insert mode
    " Fast Esc
    imap <A-s> <Esc>
    " Fast save
    imap <A-w> <Esc>:w!<cr>
    imap <C-s> <Esc>:w!<cr>
    " Change language
    imap <A-r> <C-^>
    " Ctrl+c
    imap <C-c> <Esc>
    " Ctrl + hjkl in Insert mode
    imap <C-h> <C-o>h
    imap <C-j> <C-o>j
    imap <C-k> <C-o>k
    imap <C-l> <C-o>l
    " Jump to end of line
    imap <C-e> <C-o>A
    imap <C-a> <C-o>I
    " Auto complete {} indent and position the cursor in the middle line
    imap (<cr> (<cr>)<Esc>O
    imap [<cr> [<cr>]<Esc>O
    imap {<cr> {<cr>}<Esc>O
    imap {{ {
    imap {} {}
    imap <A-m> <C-m>

" Visual mode
    " Fast save
    vmap <A-w> <Esc>:w!<cr>
    vmap <C-s> <Esc>:w!<cr>
    " Move multiple selected lines
    vmap <A-h> <'[V']
    vmap <A-l> >'[V']
    vmap <A-j> xp'[V']
    vmap <A-k> xkP'[V']

" Command mode
    cmap <C-k> <Up>
    cmap <C-j> <Down>
    " Shortcuts
    cmap %% <C-R>=expand('%:p:h').'/'<cr>
    cmap %r <C-R>=expand('%')<cr>
    cmap %. <C-R>=expand('%:t')<cr>
