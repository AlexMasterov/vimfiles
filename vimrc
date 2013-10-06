" .vimrc Alex Masterov <alex.masterow@gmail.com>

" Environment
    " My vimfiles
    let $DOTVIM = expand($VIM.'/vimfiles')

    set nocompatible
    set noswapfile
    set noexrc
    set viminfo+=n$DOTVIM/viminfo

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
    let g:loaded_gzip = 1               " disable gzip.vim
    let g:loaded_zipPlugin = 1          " disable zipPlugin.vim
    let g:loaded_tarPlugin = 1          " disable tarPlugin.vim
    " let g:loaded_matchparen = 1         " disable matchparen.vim
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
        au BufWritePre *.{hs,php,js,css,html,htmltwig,hamlet,yml,vim} :%s/\s\+$//e | retab
        " Restore cursor to file position in previous editing session (from viminfo)
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")|exe 'normal! g`"zvzz'|endif
        " Large files are > 5M
        let g:LargeFile = 1024 * 1024 * 5
        au BufReadPre * if getfsize(expand('<afile>')) > g:LargeFile|setl ei+=FileType bh=unload bt=nowrite ul=-1|endif
    augroup END

    " Basic filetypes
    augroup filetypes
        au!
        au BufNewFile,BufRead */conf/*            setl filetype=nginx
        au BufNewFile,BufRead *.md                setl filetype=markdown
        au BufNewFile,BufRead js.twig             setl filetype=javascript
        au BufNewFile,BufRead jquery.*.js         setl filetype=jquery syntax=jquery
        au BufNewFile,BufRead *.twig              setl filetype=twig
        au BufNewFile,BufRead *.html.twig         setl filetype=htmltwig syntax=html.twig
        au BufNewFile,BufRead *.{twig,html.twig}  setl commentstring={#%s#}
        " Haskell
        au BufNewFile,BufRead *.hs setl formatprg=pointfree
        au FileWritePost,BufWritePost haskell.vim syntax off|syntax on
    augroup END

    " Basic indentation
    augroup indentation
        au!
        au FileType python                     setl ts=4 sts=4 sw=4 si
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
            " \| imap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
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
        " VIM
        au FileWritePost,BufWritePost *.vim if &autoread|source <afile>|endif
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

    " Personal plugins
    NeoBundle 'AlexMasterov/dotvim'
    " Local plugins for doing development
    NeoBundleLocal $DOTVIM.'/dev'

    NeoBundle 'tpope/vim-repeat'       " repeat last plugin command
    NeoBundle 'tpope/vim-abolish'      " awesome replace
    NeoBundle 'tpope/vim-surround'     " surroundings
    NeoBundle 'shell.vim--Odding'      " <F11>: fullscreen mode
    NeoBundle 'kana/vim-smartchr'      " insert several candidates with a single key
    NeoBundle 'tpope/vim-speeddating'  " increment date
    " Experiment
    " NeoBundle 'terryma/vim-multiple-cursors'
    " let g:multi_cursor_next_key = '<C-n>'
    " let g:multi_cursor_prev_key = '<C-p>'
    " let g:multi_cursor_skip_key = '<C-x>'
    " let g:multi_cursor_quit_key = '<C-c>'
    NeoBundle 'AndrewRadev/splitjoin.vim'
    nmap <silent> <A-n> :SplitjoinSplit<CR>
    nmap <silent> <A-m> :SplitjoinJoin<CR>
    NeoBundleLazy 'shmay/vim-yaml',
        \ {'autoload' : {'filetypes' : 'yaml'}}
    NeoBundleLazy 'elzr/vim-json',
        \ {'autoload' : {'filetypes' : 'json'}}
    NeoBundleLazy 'gcmt/psearch.vim',
        \ {'autoload' : {'commands' : 'PSearch'}}
    nmap <F1> :PSearch<CR>

    " Auto Pairs
    NeoBundle 'jiangmiao/auto-pairs'
    let g:AutoPairsFlyMode = 0
    let g:AutoPairsShortcutJump = '<Nop>'
    let g:AutoPairsShortcutFastWrap = '<Nop>'
    let g:AutoPairsShortcutBackInsert = '<Nop>'
    let g:AutoPairs = {'(':')', '[':']', '{':'}', "'":"'", '"':'"'}

    " Expand Region
    NeoBundle 'terryma/vim-expand-region'
    map vv <Plug>(expand_region_expand)
    vmap <C-v> <Plug>(expand_region_shrink)

    " Tabularize
    NeoBundleLazy 'godlygeek/tabular',
        \ {'autoload' : {'commands' : 'Tabularize'}}
    map <leader>t== :Tabularize /=<CR>
    map <leader>t=> :Tabularize /=><CR>
    map <leader>t:  :Tabularize /:\zs<CR>
    map <leader>t:: :Tabularize /:\zs<CR>
    map <leader>t,  :Tabularize /,<CR>
    map <leader>t<space> :Tabularize / <CR>

    " tComment
    NeoBundle 'tomtom/tcomment_vim'
    " q: toggle comment line
    nmap q gcc
    vmap q gc

    " NERDTree
    NeoBundleLazy 'scrooloose/nerdtree',
        \ {'autoload' : {'commands' : 'NERDTreeTabsToggle'}}
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
    nmap <silent> <F4> :NERDTreeTabsToggle<CR>

    " CtrlP
    NeoBundle 'kien/ctrlp.vim'
    let g:ctrlp_map = '<leader>f'
    let g:ctrlp_clear_cache_on_exit = 0
    let g:ctrlp_cache_dir = $DOTVIM.'/cache/ctrlp'

    " EasyMotion
    NeoBundle 'Lokaltog/vim-easymotion'
    let g:EasyMotion_mapping_w  = '<Space>w'
    let g:EasyMotion_mapping_e  = '<Space>e'
    let g:EasyMotion_mapping_b  = '<Space>b'

    " Session manager
    NeoBundle 'xolox/vim-session',
        \ {'depends' : 'xolox/vim-misc'}
    let g:session_autosave = 'yes'
    let g:session_autoload = 'yes'
    let g:session_default_to_last = 1
    let g:session_directory = $DOTVIM.'/session'
    set sessionoptions=buffers,curdir,folds,resize,tabpages,unix,slash
    nmap <leader>sl :OpenSession<space>
    nmap <leader>sa :SaveSession<space>
    nmap <leader>ss :SaveSession!<CR>
    nmap <leader>sc :CloseSession!<CR>
    nmap <leader>sd :DeleteSession!<CR>

    " Syntastic
    NeoBundle 'scrooloose/syntastic'
    let g:syntastic_auto_jump = 0
    let g:syntastic_auto_loc_list = 2  " auto close error window when there are no errors
    let g:syntastic_check_on_open = 0
    let g:syntastic_error_symbol = '✗'
    let g:syntastic_warning_symbol = '∗'
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_stl_format = '%E{err: %e line: %fe}%B{, }%W{warn: %w line: %fw}'
    let g:syntastic_mode_map = {
        \ 'mode': 'passive',
        \ 'active_filetypes':  ['python','php','css','javascript'],
        \ 'passive_filetypes': ['haskell','html','twig'] }
    " Syntax checkers
    let g:syntastic_csslint_options = '--ignore=ids'
    let g:syntastic_javascript_jslint_conf = '--node --nomen --anon --sloppy --regex'
    nmap <silent> <leader>E :Errors<CR>

    if has('python')
        " Gundo
        NeoBundleLazy 'sjl/gundo.vim',
            \ {'autoload' : {'commands' : 'GundoToggle'}}
        let g:gundo_help = 0
        let g:gundo_right = 1
        let g:gundo_width = 30
        let g:gundo_preview_bottom = 1
        let g:gundo_preview_statusline = ' '
        let g:gundo_tree_statusline = ' '
        nmap <silent> <F3> :GundoToggle<CR><CR>
        " UltiSnips
        NeoBundle 'SirVer/ultisnips'
        let g:UltiSnipsExpandTrigger = '`'
        let g:UltiSnipsListSnippets = '<Nop>'
        let g:UltiSnipsJumpForwardTrigger  = '<A-.>'
        let g:UltiSnipsJumpBackwardTrigger = '<A-,>'
        let g:UltiSnipsSnippetDirectories = ['snippets']
        let g:UltiSnipsSnippetsDir = $HOME.'/dotfiles/vim/UltiSnips'
        " Colorv
        NeoBundleLazy 'Rykka/colorv.vim',
            \ {'autoload' : {'filetypes' : ['html','css','lucius','vim']}}
        let g:colorv_cache_fav = $DOTVIM.'/cache/colorv_cache'
        let g:colorv_cache_file = $DOTVIM.'/cache/colorv_cache_fav'
        let g:colorv_preview_ftype = 'html,css,lucius,javascript,vim'
    endif

    " HTML
    NeoBundleLazy 'docunext/closetag.vim',
        \ {'autoload' : {'filetypes' : ['html','xml','twig','htmltwig','hamlet']}}
    NeoBundleLazy 'gregsexton/MatchTag',
        \ {'autoload' : {'filetypes' : ['html','xml','twig','htmltwig','hamlet']}}
    au! FileType twig,htmltwig,hamlet runtime! ftplugin/html.vim

    " CSS
    NeoBundleLazy 'miripiruni/CSScomb-for-Vim',
        \ {'autoload' : {'commands' : 'CSScomb'}}
    nmap <silent> <F9> :CSScomb<CR>

    " Emmet (ex Zen Coding)
    NeoBundleLazy 'mattn/emmet-vim',
        \ {'autoload' : {'filetypes' : ['html','xml','twig','htmltwig','hamlet']}}
    let g:user_emmet_expandabbr_key = '<S-e>'

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
    "      \ {'build' : {'windows' : 'make -f make_mingw32.mak'}}
    "  NeoBundle 'eagletmt/ghcmod-vim'
    "  au! FileType haskell compiler ghc | GhcModCheckAsync
    NeoBundle 'Superior-Haskell-Interaction-Mode-SHIM'
    " Syntax settings
    NeoBundle 'haskell/haskell-mode-vim'
    NeoBundle 'Twinside/vim-syntax-haskell-cabal'
    NeoBundle 'pbrisbin/html-template-syntax'
    let hs_highlight_debug = 1
    let hs_highlight_types = 1
    let hs_highlight_boolean = 1
    let hs_highlight_prelude = 1
    let hs_highlight_functions = 1
    let hs_highlight_classes = 1
    let hs_highlight_delimiters = 1
    let hs_allow_hash_operator = 1
    let hs_highlight_conceal = 1

    " Autocomplete
    NeoBundle 'Valloric/YouCompleteMe'
    let g:ycm_autoclose_preview_window_after_completion = 1
    " Omni complete
    set complete=.,w,b,u,U
    set completeopt=menuone,longest,preview
    " Enable omni completion
    augroup omnicomplete
        au!
        au FileType haskell setl omnifunc=necoghc#omnifunc
        au FileType php setl omnifunc=phpcomplete#CompletePHP
        au FileType sql setl omnifunc=sqlcomplete#Complete
        au FileType xml setl omnifunc=xmlcomplete#CompleteTags
        au FileType css setl omnifunc=csscomplete#CompleteCSS
        au FileType html setl omnifunc=htmlcomplete#CompleteTags
        au FileType ruby setl omnifunc=rubycomplete#Complete
        au FileType python setl omnifunc=pythoncomplete#Complete
        au FileType javascript setl omnifunc=jscomplete#CompleteJS
        " Syntax complete if nothing else available
        au FileType * if &omnifunc == ''|setl omnifunc=syntaxcomplete#Complete|endif
        au FileType * if &completefunc == ''|setl completefunc=syntaxcomplete#Complete|endif
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
    set report=0                " report changes
    set history=50              " history amount
    set linespace=2             " extra spaces between rows
    set lazyredraw              " don't redraw while executing macros
    set textwidth=0             " disable automatic text-width
    set shortmess=fmxsIaoO      " disable intro message
    set relativenumber          " show the line number
    set virtualedit=all         " allows cursor position past true end of line
    set noshowmode              " don't show the mode ("-- INSERT --") at the bottom
    set matchtime=3             " blink matching chars for .x seconds
    set matchpairs+=<:>         " highlight <>
    " set timeoutlen=60           " mapping timeout
    " set ttimeoutlen=0           " keycode timeout
    if exists('&regexpengine')
        set regexpengine=2      " regexp engine (0=auto, 1=old, 2=NFA)
    endif
    " Use clipboard register
    if has('unnamedplus')
        set clipboard& clipboard+=unnamedplus
    else
        set clipboard& clipboard+=unnamed
    endif

" Files & Folders
    set autowrite               " auto save before commands like :make
    set autoread                " auto reload changed files
    set autochdir               " auto switch to the current file directory
    set nostartofline           " avoid moving cursor to BOL when jumping around

" Buffers & Windows
    set hidden                  " allows the closing of buffers without saving
    set switchbuf=useopen       " orders to open the buffer
    set showtabline=2           " always show the tab pages
    set scrolloff=3             " lines visible above/below cursor when scrolling
    set sidescrolloff=3         " lines visible left/right of cursor when scrolling
    set splitbelow splitright   " splitting a window below/right the current one
    set noequalalways           " resize windows as little as possible
    set winminheight=0          " minimal height of a window

" Formatting
    set wrap                    " wrap long lines
    set linebreak               " wrap without line breaks
    set shiftround              " indent multiple of shiftwidth
    set autoindent              " indent at the same level of the previous line
    set smartindent             " smart automatic indenting
    set cindent                 " smart indenting for c-like code
    set copyindent              " copy the previous indentation on (auto)indenting
    set expandtab               " spaces instead of tabs
    set tabstop=4               " number of spaces per tab for display
    set shiftwidth=4            " number of spaces per tab in insert mode
    set softtabstop=4           " number of spaces when indenting
    " Backspacing settings
        " indent  allow backspacing over autoindent
        " eol     allow backspacing over line breaks (join lines)
        " start   allow backspacing over the start of insert;
        "         CTRL-W and CTRL-U stop once at the start of insert
    set backspace=indent,eol,start
    " Highlight invisible symbols
    set list
    set listchars=trail:•,precedes:<,extends:>,nbsp:.,tab:+-

" Folding
    set nofoldenable            " don't do any folding for now
    " set foldmethod=indent       " open all folds initially
    " set foldlevelstart=99       " close folds below this depth, initially

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
    set magic                   " change the way backslashes are used in search patterns

" Command-line
    set wildmenu                    " show list instead of just completing
    set wildmode=list:longest,full  " completion modes
    set wildignorecase              " in-case-sensitive dir/file completion

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
    " Alt-[jkhl]: move selected lines
    nmap <A-j> ddp
    nmap <A-k> ddkP
    nmap <A-h> <<<Esc>
    nmap <A-l> >>><Esc>
    " jk: don't skip wrap lines
    nmap j gj
    nmap k gk
    " ff: jump to end
    nmap ff $
    " tt: jump to first char
    nmap tt ^
    " p: paste and indent
    nmap <silent> <leader>p p`[v`]=
    " Alt-w: fast save
    nmap <A-w> :w!<CR>
    " Ctrl-C: clear highlight after search
    nmap <silent> <C-c> :nohl<CR>:let @/=""<CR>
    " Ctrl-[jk]: scroll up/down
    nmap <C-j> <PageDown>
    nmap <C-k> <PageUp>
    " Ctrl-[hl]: scroll left/right
    nmap <C-h> 10zh
    nmap <C-l> 10zl
    " Alt-2: new tab
    nmap <A-2> :tabnew<CR>
    " Alt-e: close tab
    nmap <A-1> :q<CR>
    " Alt-e: previous tab
    nmap <A-q> gT
    " Alt-e: next tab
    nmap <A-e> gt
    " Alt-[ad]: move tabs
    nmap <silent> <A-a> :exe 'silent! tabmove '.(tabpagenr()-2)<CR>
    nmap <silent> <A-d> :exe 'silent! tabmove '.tabpagenr()<CR>
    " ,bl: show buffers
    nmap <leader>bl :ls<CR>:b
    " ,bp: previous buffer
    nmap <leader>bp :bp<CR>
    " ,bn: next buffer
    nmap <leader>bn :bn<CR>
    " Alt-[upio]: jump to window
    nmap <silent> <A-o> :wincmd k<CR>
    nmap <silent> <A-p> :wincmd l<CR>
    nmap <silent> <A-u> :wincmd h<CR>
    nmap <silent> <A-i> :wincmd j<CR>
    " Alt-r: switch window
    nmap <silent> <A-r> :wincmd w<CR>
    " Alt-r: swap window
    nmap <silent> <A-f> :wincmd x<CR>
    " Alt-[]: split window
    nmap <silent> <A-[> :split<CR>
    nmap <silent> <A-]> :vsplit<CR>
    " zz: move to top/center/bottom
    nmap <expr> zz (winline() == (winheight(0)+1)/ 2) ?
                \ 'zt' : (winline() == 1)? 'zb' : 'zz'
    " *: don't jump when using * for search
    nmap * *<C-o>
    " nN#: search keep matches in the middle
    nmap n nzz
    nmap N Nzz
    nmap # #zz
    " Q: auto indent text
    nmap Q ==
    " Tab: bracket match
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
    " nmap <silent> <F1> :ToggleLocationList<CR>
    " nmap <silent> <F2> :ToggleQuickfixList<CR>
    " Location List shortcuts
    nmap <silent> <A-,> :lprev<CR>
    nmap <silent> <A-.> :lnext<CR>
    " Quickfix List shortcuts
    nmap <silent> <C-,> :cn<CR>
    nmap <silent> <C-.> :cp<CR>

" Insert mode
    " Alt-[jkhl]: standart move
    imap <A-j> <C-o>j
    imap <A-h> <C-o>h
    imap <A-k> <C-o>k
    imap <A-l> <C-o>l
    " Ctrl-a: jump to head
    imap <A-a> <C-o>I
    " Ctrl-e: jump to end
    imap <A-e> <C-o>A
    " Ctrl-q: jump to first char
    imap <A-q> <Home>
    " Ctrl-[jk]: scroll up/down
    imap <C-j> <PageDown>
    imap <C-k> <PageUp>
    " Alt-w: fast save
    imap <A-w> <Esc> :w!<CR>
    " Ctrl-s: old fast save
    imap <C-s> <Esc> :w!<CR>
    " Alt-s: fast Esc
    imap <A-s> <Esc>
    " Ctrl-c: old fast Esc dsa
    imap <C-c> <Esc>
    " Alt-r: change language
    imap <A-r> <C-^>
    " Alt-m: break line
    imap <A-m> <C-m>

" Visual mode
    " Alt-[jkhl]: move selected lines
    vmap <A-j> xp'[V']
    vmap <A-k> xkP'[V']
    vmap <A-h> <'[V']
    vmap <A-l> >'[V']
    " Alt-w: fast save
    vmap <A-w> <Esc>:w!<CR>
    " Ctrl-s: old fast save
    vmap <C-s> <Esc>:w!<CR>
    " Q: auto indent text
    vmap Q ==

" Command mode
    " Ctrl-h: previous char
    cmap <C-h> <Left>
    " Ctrl-l: next char
    cmap <C-l> <Right>
    " Ctrl-h: previous word
    cmap <A-h> <s-left>
    " Ctrl-h: next word
    cmap <A-l> <s-right>
    " Ctrl-j: previous history
    cmap <C-j> <Down>
    " Ctrl-k: next history
    cmap <C-k> <Up>
    " Ctrl-d: delete char
    cmap <C-d> <Del>
    " Ctrl-a: jump to head
    cmap <C-a> <Home>
    " Ctrl-e: jump to end
    cmap <C-e> <End>
    " Ctrl-p: paste
    cmap <C-p> <C-r>*
    " Shortcuts
    cmap %% <C-R>=expand('%')<CR>
    cmap $$ <C-R>=expand('%:p:h').'\'<CR>
