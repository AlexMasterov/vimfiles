" .vimrc Alex Masterov <alex.masterow@gmail.com>

" Environment
    set nocompatible
    set noswapfile
    set viminfo+=n$VIM/_viminfo

    " Ignore binary files
    set suffixes=.db,.obj,.exe,.dll,.o,.a,.la,.mo,.so
    " Ignore bytecode files
    set suffixes+=.pyc,.zwc,.class
    " Ignore backup files
    set suffixes+=.swp,~,.bak,.old

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

    " Filetypes detection       Syntax highlighting
    filetype plugin indent on | syntax on

    " Syntax coloring lines
    set synmaxcol=512

    " Avoid loading Matchparen plugin. +100 speed
    let g:loaded_matchparen = 1

    " Basic remapping
    let mapleader = ',' | nmap ; :

    " Basic autocommands
    augroup environment
        au!
        au BufWritePost $MYVIMRC source $MYVIMRC
        " Save when losing focus
        au FocusLost silent! :wa
        " Toggle type of line numbers and display invisible symbols
        au InsertEnter * set number nolist
        au InsertLeave * set relativenumber list
        " Only show the cursorline in the current window
        au WinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
        " Dont continue comments when pushing
        au FileType * setlocal formatoptions-=ro
        " Auto strip ^M characters
        au BufWritePre * silent! :%s/\r\+$//e
        " Auto strip trailing whitespace at the end of non-blank lines
        au BufWritePre *.{php,js,css,html,html.twig,yml,vim} :%s/\s\+$//e
        au BufWritePre *.{php,css} :retab
        au BufRead *.{css,html,html.twig} setlocal tabstop=2 softtabstop=2 shiftwidth=2
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
        au BufNewFile,BufRead */conf/*.conf setlocal filetype=nginx
        " Json syntax
        au BufNewFile,BufRead *.json setlocal filetype=javascript
        " Twig syntax
        au BufNewFile,BufRead *.twig setlocal filetype=twig
        au BufNewFile,BufRead *.html.twig setlocal filetype=html.twig
        au Filetype twig,html.twig setlocal commentstring={#%s#}
        " jQuery syntax
        au BufNewFile,BufRead jquery.*.js setlocal filetype=jquery syntax=jquery
    augroup END

" Setup Bundle Support
    set rtp+=$VIMRUNTIME/bundle/vundle
    call vundle#rc('$VIMRUNTIME/bundle')
    " Let Vundle manage Vundle
    Bundle 'gmarik/vundle'
    " BundleInstall can not work with 'shellslash' on Windows
    au! FileType vundle setlocal noshellslash shellxquote=

" Bundles
    " Ack
    if executable('ack')
        Bundle 'mileszs/ack.vim'
        nmap <leader>as :Ack!<space>
        nmap <leader>ar :AckFromSearch<cr>
        nmap <leader>aw :exe 'Ack ' . expand('<cword>') <Bar> cw<cr>
    endif

    " Gundo
    if has('python') && has('persistent_undo')
        Bundle 'sjl/gundo.vim'
        let g:gundo_help = 0
        let g:gundo_right = 1
        let g:gundo_width = 32
        let g:gundo_preview_bottom = 1
        let g:gundo_tree_statusline = ' '
        let g:gundo_preview_statusline = ' '
        nmap <silent> <C-u> :GundoToggle<cr><cr>
    endif

    " Session manager
    Bundle 'sessionman.vim'
    nmap <silent> <leader>sl :SessionList<cr>
    nmap <silent> <leader>ss :SessionSave<cr>
    set sessionoptions=buffers,curdir,folds,resize,tabpages,unix,slash

    " NERDTree
    Bundle 'scrooloose/nerdtree'
    let NERDTreeWinPos = 'right'
    let NERDTreeWinSize = 34
    let NERDTreeMinimalUI = 1
    let NERDTreeDirArrows = 1
    let NERDTreeShowBookmarks = 1
    let NERDTreeBookmarksFile = $VIM.'/NERDTreeBookmarks'
    let NERDTreeIgnore = map(split(&suffixes, ','), '"\\".v:val."\$"')
    " NERDTreeTabs
    Bundle 'jistr/vim-nerdtree-tabs'
    let nerdtree_tabs_focus_on_files = 1
    let nerdtree_tabs_open_on_gui_startup = 0
    nmap <silent> <C-o> :NERDTreeTabsToggle<cr>

    " NERDCommenter
    Bundle 'scrooloose/nerdcommenter'
    let NERDSpaceDelims = 1

    " Syntastic
    Bundle 'scrooloose/syntastic'
    let g:syntastic_auto_jump = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 0
    let g:syntastic_mode_map = {
        \ 'mode': 'active',
        \ 'active_filetypes': ['php', 'html', 'javascript'],
        \ 'passive_filetypes': ['css'] }
    " Ignore line-too-long errors with flake8
    let g:syntastic_python_checker_args = '--ignore=E501'
    nmap <silent> <leader>E :Errors<cr>

    " Tabularize
    Bundle 'godlygeek/tabular'
    map <leader>t== :Tabularize /=<cr>
    map <leader>t=> :Tabularize /=><cr>
    map <leader>t:  :Tabularize /:<cr>
    map <leader>t:: :Tabularize /:\zs<cr>
    map <leader>t,  :Tabularize /,<cr>
    map <leader>t<space>  :Tabularize / <cr>

    " EasyMotion
    Bundle 'Lokaltog/vim-easymotion'
    let g:EasyMotion_mapping_w = '<C-q>'
    let g:EasyMotion_mapping_b = '<C-w>'

    " Zen Coding
    Bundle 'mattn/zencoding-vim'
    let g:user_zen_expandabbr_key = '<c-e>'

    " UltiSnips
    if has('python')
        Bundle 'UltiSnips'
        let g:UltiSnipsSnippetDirectories = ['snippets']
        " Use hardtabs in snippets
        au! FileType snippets setlocal noexpandtab
        au! FileType * call UltiSnips_FileTypeChanged()
    endif

    " Colorv
    if has('python')
        Bundle 'Rykka/colorv.vim'
        let g:colorv_preview_ftype = 'css,html,javascript,vim'
    endif

    " Supertab
    if exists('+omnifunc')
        Bundle 'ervandew/supertab'
        let g:SuperTabDefaultCompletionType = 'context'
        " Disable cr to fix conflict with delimitMate
        let g:SuperTabCrMapping = '<C-cr>'
    endif

    " CSSComb
    Bundle 'miripiruni/CSScomb-for-Vim'
    nmap <silent> <F9> :CSSComb<cr>

    " Utility
    Bundle 'AutoComplPop'
    Bundle 'tpope/vim-repeat'
    Bundle 'tpope/vim-surround'
    Bundle 'shell.vim--Odding'
    Bundle 'gregsexton/MatchTag'
    Bundle 'Raimondi/delimitMate'
    Bundle 'docunext/closetag.vim'

    " Syntax files
    Bundle 'nginx.vim'
    Bundle 'nono/jquery.vim'
    Bundle 'jelera/vim-javascript-syntax'

    " PHP
    Bundle 'phpvim'
    " Syntax settings
    let php_folding = 0
    let php_sql_query = 1
    let php_html_in_strings = 1
    au! Filetype php set nowrap

    " JS Complete
    Bundle 'teramako/jscomplete-vim'
    let g:jscomplete_use = ['dom', 'moz']

    " OmniComplete
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

        augroup omnicomplete
            au!
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
    colorscheme simplex
    " Reload the colorscheme whenever we write the file
    au! BufWritePost simplex.vim colorscheme simplex | ColorVPreview

    set guioptions=a
    set guifont=DejaVu_Sans_Mono:h10:cRUSSIAN,Consolas:h11:cRUSSIAN
    " winsize 120 100 | winpos 0 0

    set shortmess=fmxsIaoO      " disable intro message
    set lazyredraw              " don't redraw while executing macros
    set linespace=2             " extra spaces between rows
    set virtualedit=all         " allow virtual editing in all modes
    set relativenumber          " show the line number

" Buffers & Windows
    set hidden                  " allow buffer switching without saving
    set autoread                " auto reload changed files
    set autochdir               " auto switch to the current file directory
    set showtabline=2           " always show the tab pages
    set scrolloff=3             " lines visible above/below cursor when scrolling
    set sidescrolloff=3         " lines visible left/right of cursor when scrolling
    set splitbelow splitright   " splitting a window below/right the current one

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
    set nofoldenable

" Mouse
    set mousehide               " hide the mouse while typing
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
    set statusline=%1*\ %l%*.%L\ %*                  " line & total line
    set statusline+=%<%f\ %2*%-4M%*                  " filename
    set statusline+=%=                               " left/right separator
    set statusline+=%2*%(%{&paste?'paste':''}\ %)%*  " pastemode
    set statusline+=%2*%(%{&wrap?'':'nowrap'}\ %)%*  " wrapmode
    set statusline+=%(%{FileSize()}\ %)              " filesize
    set statusline+=%(%{&fileencoding}\ %)           " encoding
    set statusline+=%2*%(%Y\ %)%*                    " filetype
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
    " Clear highlight after search
    nmap <silent> <leader><space> :nohlsearch<cr>
    " Search results in the center
    nmap n nzz
    nmap N Nzz
    nmap * *zz
    nmap # #zz
    nmap g* g*zz
    nmap g# g#zz
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
    " Auto complete {} indent and position the cursor in the middle line
    imap (<cr> (<cr>)<Esc>O
    imap [<cr> [<cr>]<Esc>O
    imap {<cr> {<cr>}<Esc>O
    imap {{ {
    imap {} {}

" Visual mode
    " Fast save
    vmap <A-w> <Esc>:w!<cr>
    vmap <C-s> <Esc>:w!<cr>
    " Move multiple selected lines
    vmap <A-h> <'[V']
    vmap <A-l> >'[V']
    vmap <A-j> xp'[V']
    vmap <A-k> xkP'[V']
