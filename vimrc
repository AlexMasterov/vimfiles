" .vimrc Alex Masterov <alex.masterow@gmail.com>

" Environment
    " My vimfiles
    let $DOTVIM = expand($VIM.'/vimfiles')

    set nocompatible
    set noswapfile
    set noexrc
    set viminfo+=n$DOTVIM/_viminfo

    " Remember changes
    if has('persistent_undo')
        set undofile       undodir=$DOTVIM/undo
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
        au WinEnter * setl cursorline
        au WinLeave * setl nocursorline
        " Smart toggle settings between modes
        au InsertEnter * set nu  nolist colorcolumn=80
        au InsertLeave * set rnu list   colorcolumn=""
        " Dont continue comments when pushing
        au FileType * setl formatoptions-=ro
        " Auto strip ^M characters
        au BufWritePre * silent! :%s/\r\+$//e
        " Auto strip trailing whitespace at the end of non-blank lines
        au BufWritePre *.{hs,php,js,css,html,html.twig,hamlet,yml,vim} :%s/\s\+$//e | retab
        " Restore cursor to file position in previous editing session (from viminfo)
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")|exe 'normal! g`"zvzz'|endif
        " Large files are > 5M
        let g:LargeFile = 1024 * 1024 * 5
        au BufReadPre * if getfsize(expand('<afile>')) > g:LargeFile|setl ei+=FileType bh=unload bt=nowrite ul=-1|endif
    augroup END

    " Basic filetypes
    augroup filetypes
        au!
        au BufNewFile,BufRead */conf/*         setl filetype=nginx
        au BufNewFile,BufRead *.twig           setl filetype=twig
        au BufNewFile,BufRead *.html.twig      setl filetype=html.twig
        au BufNewFile,BufRead *.{json,js.twig} setl filetype=javascript
        au BufNewFile,BufRead jquery.*.js      setl filetype=jquery syntax=jquery
    augroup END

    " Basic indentation
    augroup indentation
        au!
        au FileType haskell                    setl ts=8 sts=4 sw=4 nojs ai sta sr
        au FileType php,yaml                   setl ts=4 sts=4 sw=4 nowrap
        au FileType css,scss,less,lucius       setl ts=2 sts=2 sw=2
        au FileType javascript,jquery,julius   setl ts=4 sts=4 sw=4
        au FileType html,hamlet,twig,html.twig setl ts=2 sts=2 sw=2
    augroup END

    " Super special
    augroup special
        au!
        " Haskell
        au FileType haskell
            \  imap <buffer> <expr> \ smartchr#loop('\ ', '\')
            \| imap <buffer> <expr> $ smartchr#loop(' $ ', '$')
            \| imap <buffer> <expr> + smartchr#loop('+', ' ++ ')
            \| imap <buffer> <expr> . smartchr#loop('.', ' . ', '..')
            \| imap <buffer> <expr> : smartchr#loop(':', ' :: ', ' : ')
            \| imap <buffer> <expr> = smartchr#loop('=', ' = ', ' == ')
            \| imap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
        " PHP
        au FileType php
            \  imap <buffer> <expr> - smartchr#loop('-', '->')
            \| imap <buffer> <expr> $ smartchr#loop('$', '$this->')
            \| imap <buffer> <expr> = smartchr#loop('=', ' = ', ' == ')
        " CSS
        au FileType css,lucius
            \  imap <buffer> <expr> ; smartchr#loop(';', ': ')
            \| imap <buffer> <expr> % smartchr#loop('%', '% ')
            \| imap <buffer> <expr> p smartchr#loop('p', 'px', 'px ')
    augroup END

" Setup NeoBundle Support
    if has('vim_starting')
        let s:neobundle = $DOTVIM.'/bundle/neobundle.vim'
        if !isdirectory(s:neobundle)
            exe printf('!git clone --depth 1 git://github.com/Shougo/neobundle.vim.git %s',
                    \ s:neobundle)
        endif
        exe 'set runtimepath+='.s:neobundle
        call neobundle#rc($DOTVIM.'/bundle/')
    endif
    " Let NeoBundle manage NeoBundle
    NeoBundleFetch 'Shougo/neobundle.vim'

" Bundles
    " Personal
    NeoBundle 'Quetka/dotvim'
    " Basic utility
    NeoBundle 'tpope/vim-abolish'        " awesome replace
    NeoBundle 'tpope/vim-surround'       " surroundings
    NeoBundle 'tpope/vim-repeat'         " repeat last plugin command
    NeoBundle 'tpope/vim-speeddating'    " increment dates
    NeoBundle 'shell.vim--Odding'        " <F11>: fullscreen mode
    NeoBundle 'kana/vim-smartchr'        " insert several candidates with a single key
    NeoBundle 'gorkunov/smartpairs.vim'  " vv: one shortcut for all typical combinations

    " Auto Pairs
    NeoBundle 'jiangmiao/auto-pairs'
    let g:AutoPairsFlyMode = 1
    let g:AutoPairsShortcutJump = '<Nop>'
    let g:AutoPairsShortcutFastWrap = '<Nop>'
    let g:AutoPairsShortcutBackInsert = '<Nop>'
    let g:AutoPairs = {'(':')', '[':']', '{':'}', "'":"'", '"':'"'}

    " tComment
    NeoBundle 'tomtom/tcomment_vim'
    " q: toggle comment line
    nmap q gcc
    vmap q gc

    " EasyMotion
    NeoBundle 'Lokaltog/vim-easymotion'
    let g:EasyMotion_mapping_w  = '<Space>w'
    let g:EasyMotion_mapping_e  = '<Space>e'
    let g:EasyMotion_mapping_b  = '<Space>b'

    " Session manager
    NeoBundle 'xolox/vim-session'
    let g:session_autosave = 1
    let g:session_autoload = 1
    let g:session_default_to_last = 1
    let g:session_directory = $DOTVIM.'/session'
    set sessionoptions=buffers,curdir,folds,resize,tabpages,unix,slash
    nmap <leader>sl :OpenSession<space>
    nmap <leader>sa :SaveSession<space>
    nmap <leader>ss :SaveSession!<CR>
    nmap <leader>sc :CloseSession!<CR>
    nmap <leader>sd :DeleteSession!<CR>

    " NERDTree
    NeoBundle 'scrooloose/nerdtree'
    let NERDTreeWinPos = 'right'
    let NERDTreeWinSize = 34
    let NERDTreeMinimalUI = 1
    let NERDTreeDirArrows = 1
    let NERDTreeShowBookmarks = 1
    let NERDTreeBookmarksFile = $DOTVIM.'/NERDTreeBookmarks'
    let NERDTreeIgnore = map(split(&suffixes, ','), '"\\".v:val."\$"')
    " NERDTreeTabs
    NeoBundle 'jistr/vim-nerdtree-tabs'
    let nerdtree_tabs_focus_on_files = 1
    let nerdtree_tabs_open_on_gui_startup = 0
    nmap <silent> <F3> :NERDTreeTabsToggle<CR>

    " Syntastic
    NeoBundle 'scrooloose/syntastic'
    let g:syntastic_auto_jump = 1
    let g:syntastic_auto_loc_list = 2  " auto close error window when there are no errors
    let g:syntastic_check_on_open = 0
    let g:syntastic_error_symbol = '✗'
    let g:syntastic_warning_symbol = '∗'
    let g:syntastic_stl_format = '%E{err: %e line: %fe}%B{, }%W{warn: %w line: %fw}'
    let g:syntastic_mode_map = {
        \ 'mode': 'passive',
        \ 'active_filetypes':  ['haskell','php','css','javascript'],
        \ 'passive_filetypes': ['html','twig'] }
    " Syntax checkers
    let g:syntastic_csslint_options = '--ignore=ids'
    let g:syntastic_javascript_jslint_conf = '--node --nomen --anon --sloppy --regex'
    nmap <silent> <leader>E :Errors<CR>

    if has('python')
        " Gundo
        NeoBundle 'sjl/gundo.vim'
        let g:gundo_help = 0
        let g:gundo_right = 1
        let g:gundo_width = 30
        let g:gundo_preview_bottom = 1
        let g:gundo_preview_statusline = ' '
        let g:gundo_tree_statusline = ' '
        nmap <silent> <F4> :GundoToggle<CR><CR>
        " Colorv
        NeoBundleLazy 'Rykka/colorv.vim',
            \ {'autoload' : {'filetypes' : ['html','css','lucius','vim']}}
        let g:colorv_cache_fav = $DOTVIM.'/colorv_cache'
        let g:colorv_cache_file = $DOTVIM.'/colorv_cache_fav'
        let g:colorv_preview_ftype = 'html,css,lucius,javascript,vim'
        " UltiSnips
        NeoBundle 'SirVer/ultisnips'
        let g:UltiSnipsExpandTrigger = '`'
        let g:UltiSnipsListSnippets = '<Nop>'
        let g:UltiSnipsJumpForwardTrigger  = '<A-.>'
        let g:UltiSnipsJumpBackwardTrigger = '<A-,>'
        let g:UltiSnipsSnippetDirectories = ['snippets']
    endif

    " Tabularize
    NeoBundle 'godlygeek/tabular'
    map <leader>t== :Tabularize /=<CR>
    map <leader>t=> :Tabularize /=><CR>
    map <leader>t:  :Tabularize /:\zs<CR>
    map <leader>t:: :Tabularize /:\zs<CR>
    map <leader>t,  :Tabularize /,<CR>
    map <leader>t<space> :Tabularize / <CR>

    " HTML
    NeoBundleLazy 'gregsexton/MatchTag',
        \ {'autoload' : {'filetypes' : ['html','html.twig','twig','hamlet']}}
    NeoBundleLazy 'docunext/closetag.vim',
        \ {'autoload' : {'filetypes' : ['html','html.twig','twig','hamlet']}}
    " Zen Coding
    NeoBundleLazy 'mattn/zencoding-vim',
        \ {'autoload' : {'filetypes' : ['html','html.twig','twig','hamlet']}}
    let g:user_zen_expandabbr_key = '<C-q>'

    "   CSS
    NeoBundleLazy 'miripiruni/CSScomb-for-Vim',
        \ {'autoload' : {'filetypes' : 'css,lucius'}}
    nmap <silent> <F9> :CSSComb<CR>

    " PHP
    NeoBundle 'phpvim'
    " Syntax settings
    let php_folding = 0
    let php_sql_query = 1
    let php_html_in_strings = 1

    " Haskell
    NeoBundleLazy 'ujihisa/neco-ghc',
        \ {'autoload' : {'filetypes' : 'haskell'}}
    NeoBundleLazy 'Twinside/vim-haskellConceal',
        \ {'autoload' : {'filetypes' : 'haskell'}}
    NeoBundleLazy 'lukerandall/haskellmode-vim',
        \ {'autoload' : {'filetypes' : 'haskell'}}
    " Configure browser for haskell_doc.vim
    let g:haddock_browser = 'open'
    let g:haddock_browser_callformat = '%s %s'
   " NeoBundleLazy 'Shougo/vimproc',
    "     \ {'build' : {'windows' : 'make -f make_mingw32.mak'}}
    " NeoBundle 'eagletmt/ghcmod-vim'
    " au! FileType haskell compiler ghc | GhcModCheckAsync
    " Syntax settings
    NeoBundle 'haskell/haskell-mode-vim'
    NeoBundle 'Twinside/vim-syntax-haskell-cabal'
    NeoBundle 'pbrisbin/html-template-syntax'
    let hs_highlight_debug = 1
    let hs_highlight_types = 1
    let hs_highlight_boolean = 1
    let hs_allow_hash_operator = 1

    " JavaScript
    NeoBundleLazy 'teramako/jscomplete-vim',
        \ {'autoload' : {'filetypes' : ['javascript','jquery']}}
    let g:jscomplete_use = ['dom', 'moz']
    " Syntax settings
    NeoBundle 'nono/jquery.vim'
    NeoBundle 'jelera/vim-javascript-syntax'
    NeoBundle 'jiangmiao/simple-javascript-indenter'
    let g:SimpleJsIndenter_BriefMode = 1
    let g:SimpleJsIndenter_CaseIndentLevel = -1

    " Ultimate auto-completion
    NeoBundle 'Shougo/neocomplcache'
    let g:neocomplcache_max_list = 10
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_auto_select = 1
    let g:neocomplcache_enable_auto_close_preview = 1
    let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_disable_auto_complete = 1
    let g:neocomplcache_temporary_dir = $DOTVIM.'/neocomplcache'
    " <Tab>: completion
    imap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>"
    imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-x>\<C-o>"
    " UltiSnips integration
    NeoBundle 'JazzCore/neocomplcache-ultisnips'

    " Omni complete
    set complete=.,w,b,u,U
    set completeopt=menuone,longest,preview
    " Enable omni completion
    augroup omnicomplete
        au!
        au FileType haskell setl omnifunc=necoghc#omnifunc
        au FileType php setl omnifunc=phpcomplete#CompletePHP
        au FileType css setl omnifunc=csscomplete#CompleteCSS
        au FileType xml setl omnifunc=xmlcomplete#CompleteTags
        au FileType html setl omnifunc=htmlcomplete#CompleteTags
        au FileType javascript setl omnifunc=jscomplete#CompleteJS
        " Syntax complete if nothing else available
        au FileType * if &omnifunc == ''|setl omnifunc=syntaxcomplete#Complete|endif
    augroup END

" Vim UI
    colorscheme simplex | syntax on
    " Reload the colorscheme whenever we write the file
    au! BufWritePost simplex.vim colorscheme simplex | ColorVPreview

    if has('gui_running')
        set guioptions=a
        set guifont=DejaVu_Sans_Mono:h10:cRUSSIAN,Consolas:h11:cRUSSIAN
        " winsize 120 100 | winpos 0 0
    endif
    set autowrite               " automatically save before commands like :make
    set shortmess=fmxsIaoO      " disable intro message
    set linespace=2             " extra spaces between rows
    set textwidth=0             " disable automatic text-width
    set relativenumber          " show the line number
    set virtualedit=all         " allows cursor position past true end of line
    set nostartofline           " avoid moving cursor to BOL when jumping around
    set lazyredraw              " don't redraw while executing macros
    set timeoutlen=1200         " a little bit more time for macros
    set ttimeoutlen=50          " make Esc work faster

" Buffers & Windows
    set hidden                  " allows the closing of buffers without saving
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
    set statusline+=%<%-0.50f\ %2*%-2M%*               " filename
    set statusline+=%2*%{SyntasticStatuslineFlag()}%*  " syntastic.vim: syntax errors
    set statusline+=%=                                 " left/right separator
    set statusline+=%2*%(%{&paste?'paste':''}\ %)%*    " pastemode
    set statusline+=%2*%(%{&wrap?'':'nowrap'}\ %)%*    " wrapmode
    set statusline+=%(%{FileSize()}\ %)                " filesize.vim: identify filesize
    set statusline+=%(%{&fileencoding}\ %)             " encoding
    set statusline+=%2*%(%Y\ %)%*                      " filetype
    " set statusline+=%(%{SynStack()}\ %)                " synstack.vim: identify syntax

" Normal mode
    " <A-jkhl>: move selected lines
    nmap <A-j> ddp
    nmap <A-k> ddkP
    nmap <A-h> <<
    nmap <A-l> >>
    " jk: don't skip wrap lines
    nmap j gj
    nmap k gk
    " ff: jump to end
    nmap ff $
    " tt: jump to first char
    nmap tt ^
    " <A-w>: fast save
    nmap <A-w> :w!<CR>
    " <C-C>: clear highlight after search
    nmap <silent> <C-c> :nohl<CR>:let @/=""<CR>
    " <C-jk>: scroll up/down
    nmap <C-j> <PageDown>
    nmap <C-k> <PageUp>
    " <C-hl>: scroll left/right
    nmap <C-h> 10zh
    nmap <C-l> 10zl
    " <A-2>: new tab
    nmap <A-2> :tabnew<CR>
    " <A-e>: close tab
    nmap <A-1> :q<CR>
    " <A-e>: previous tab
    nmap <A-q> gT
    " <A-e>: next tab
    nmap <A-e> gt
    " <A-ad>: move tabs
    nmap <silent> <A-a> :exe 'silent! tabmove '.(tabpagenr()-2)<CR>
    nmap <silent> <A-d> :exe 'silent! tabmove '.tabpagenr()<CR>
    " <A-upio>: jump to window
    nmap <silent> <A-o> :wincmd k<CR>
    nmap <silent> <A-p> :wincmd l<CR>
    nmap <silent> <A-u> :wincmd h<CR>
    nmap <silent> <A-i> :wincmd j<CR>
    " <A-r>: switch window
    nmap <silent> <A-r> :wincmd w<CR>
    " <A-r>: swap window
    nmap <silent> <A-f> :wincmd x<CR>
    " <A-[]>: split window
    nmap <silent> <A-[> :split<CR>
    nmap <silent> <A-]> :vsplit<CR>
    " *: don't jump when using * for search
    nmap * *<C-o>
    " nN#: search keep matches in the middle
    nmap n nzz
    nmap N Nzz
    nmap # #zz
    " Q: auto indent text
    nmap Q ==
    " <Tab>: bracket match
    nmap <Tab> %
    " vA: select all
    nmap vA ggVG
    " ,ev: open .vimrc in a new tab
    nmap <leader>ev :tabedit $MYVIMRC<CR>
    " ,gw: swap two words
    nmap <leader> <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'
    " ,p: toggle paste mode
    nmap <silent> <leader>p :setl paste!<CR>
    " ,w: toggle wrap mode
    nmap <silent> <leader>w :setl wrap!<CR>
    " togglelist.vim: toggle window
    nmap <silent> <F1> :ToggleLocationList<CR>
    nmap <silent> <F2> :ToggleQuickfixList<CR>
    " Location List shortcuts
    nmap <silent> <A-,> :lprev<CR>
    nmap <silent> <A-.> :lnext<CR>
    " Quickfix List shortcuts
    nmap <silent> <C-,> :cn<CR>
    nmap <silent> <C-.> :cp<CR>

" Insert mode
    " <A-jkhl>: standart move
    imap <A-j> <C-o>j
    imap <A-h> <C-o>h
    imap <A-k> <C-o>k
    imap <A-l> <C-o>l
    " <C-a>: jump to head
    imap <A-a> <C-o>I
    " <C-e>: jump to end
    imap <A-e> <C-o>A
    " <C-q>: jump to first char
    imap <A-q> <Home>
    " <C-jk>: scroll up/down
    imap <C-j> <PageDown>
    imap <C-k> <PageUp>
    " <A-w>: fast save
    imap <A-w> <Esc> :w!<CR>
    " <C-s>: old fast save
    imap <C-s> <Esc> :w!<CR>
    " <A-s>: fast Esc
    imap <A-s> <Esc>
    " <C-c>: old fast Esc
    imap <C-c> <Esc>
    " <A-r>: change language
    imap <A-r> <C-^>
    " <A-m>: break line
    imap <A-m> <C-m>

" Visual mode
    " <A-jkhl>: move selected lines
    vmap <A-j> xp'[V']
    vmap <A-k> xkP'[V']
    vmap <A-h> <'[V']
    vmap <A-l> >'[V']
    " <A-w>: fast save
    vmap <A-w> <Esc>:w!<CR>
    " <C-s>: old fast save
    vmap <C-s> <Esc>:w!<CR>
    " Q: auto indent text
    vmap Q ==

" Command mode
    " <C-h>: previous char
    cmap <C-h> <Left>
    " <C-l>: next char
    cmap <C-l> <Right>
    " <C-j>: previous history
    cmap <C-j> <Down>
    " <C-k>: next history
    cmap <C-k> <Up>
    " <C-d>: delete char
    cmap <C-d> <Del>
    " <C-a>: jump to head
    cmap <C-a> <Home>
    " <C-e>: jump to end
    cmap <C-e> <End>
    " <C-p>: paste
    cmap <C-p> <C-r>*
    " Shortcuts
    cmap %% <C-R>=expand('%')<CR>
    cmap $$ <C-R>=expand('%:p:h').'\'<CR>
