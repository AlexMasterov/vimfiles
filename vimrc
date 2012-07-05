" .vimrc Alex Masterov <alex.masterow@gmail.com>

" Environment
    set nocompatible

    set autoread
    set autochdir
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

    " Filetypes detection       Syntax highlighting
    filetype plugin indent on | syntax on

    " Syntax coloring lines that are too long just slows down the world
    set synmaxcol=512

    " +100 speed. Avoid loading Matchparen plugin
    let g:loaded_matchparen = 1

    " Basic remapping
    let mapleader = ',' | nmap ; :

    " Basic autocommands
    augroup environment
        au!
        au BufWritePost $MYVIMRC source $MYVIMRC
        " Save when losing focus
        au FocusLost silent! :wa
        " Only show the cursorline in the current window
        au WinEnter * set cursorline
        au WinLeave * set nocursorline
        " Toggle type of line numbers and invisible symbols
        au InsertEnter * set number nolist
        au InsertLeave * set relativenumber list
        " Dont continue comments when pushing
        au FileType * setlocal formatoptions-=ro
        " Auto strip ^M characters
        au BufWritePre * silent! :%s/\r\+$//
        " Auto strip trailing spaces
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
        au BufNewFile,BufRead *.conf setlocal filetype=nginx
        " Json
        au BufNewFile,BufRead *.json setlocal filetype=javascript
        " Twig syntax
        au BufNewFile,BufRead *.twig setlocal filetype=twig
        au BufNewFile,BufRead *.html.twig setlocal filetype=html.twig
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
        let g:gundo_right = 1
        let g:gundo_width = 32
        let g:gundo_preview_bottom = 1
        let g:gundo_tree_statusline = ' '
        let g:gundo_preview_statusline = ' '
        nmap <silent> <F8> :GundoToggle<cr><cr>
    endif

    " Session manager
    Bundle 'sessionman.vim'
    nmap <silent> <leader>sl :SessionList<cr>
    nmap <silent> <leader>ss :SessionSave<cr>
    set sessionoptions=buffers,curdir,folds,resize,tabpages,unix,slash

    " NerdTree
    Bundle 'scrooloose/nerdtree'
    let NERDTreeWinPos = 'right'
    let NERDTreeWinSize = 34
    let NERDTreeMinimalUI = 1
    let NERDTreeDirArrows = 1
    let NERDTreeShowBookmarks = 1
    let NERDTreeBookmarksFile = $VIM.'/NERDTreeBookmarks'
    let NERDTreeIgnore = [
        \ '\.swo$', '\.swp$', '\.hg', '\.bzr',
        \ '\.git', '\.svn', '\.pyc', '\~$']
    " NerdTreeTabs
    Bundle 'jistr/vim-nerdtree-tabs'
    let nerdtree_tabs_focus_on_files = 1
    let nerdtree_tabs_open_on_gui_startup = 0
    nmap <silent> <F4> :NERDTreeTabsToggle<cr>

    " Syntastic
    Bundle 'scrooloose/syntastic'
    let g:syntastic_auto_jump = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 0
    let g:syntastic_mode_map = {
        \ 'mode': 'active',
        \ 'active_filetypes': ['php', 'html', 'javascript'],
        \ 'passive_filetypes': ['css'] }
    nmap <silent> <leader>E :Errors<cr>

    " Tabularize
    Bundle 'godlygeek/tabular'
    map <leader>t== :Tabularize /=<cr>
    map <leader>t=> :Tabularize /=><cr>
    map <leader>t:  :Tabularize /:<cr>
    map <leader>t:: :Tabularize /:\zs<cr>
    map <leader>t,  :Tabularize /,<cr>

    " EasyMotion
    Bundle 'Lokaltog/vim-easymotion'
    let g:EasyMotion_mapping_w = '<F1>'
    let g:EasyMotion_mapping_b = '<F2>'

    " Zen Coding
    Bundle 'mattn/zencoding-vim'
    let g:user_zen_expandabbr_key = '<c-e>'

    " UltiSnips
    if has('python')
        Bundle 'UltiSnips'
        let g:UltiSnipsJumpForwardTrigger = '<tab>'
        let g:UltiSnipsJumpBackwardTrigger = '<S-tab>'
        let g:UltiSnipsSnippetDirectories = ['snippets']
    endif

    " Colorv
    if has('python')
        Bundle 'Rykka/colorv.vim'
        let g:colorv_preview_ftype = 'css,html,javascript,vim'
    endif

    " ZoomWin
    Bundle 'ZoomWin'
    nmap <silent> <A-0> :ZoomWin<cr>

    " CSSComb
    Bundle 'miripiruni/CSScomb-for-Vim'
    nmap <silent> <F9> :CSSComb<cr>

    " Highlights the matching HTML tag
    Bundle 'gregsexton/MatchTag'
    Bundle 'AutoClose'
    " Fullscreen
    Bundle 'shell.vim--Odding'
    " Surrounding
    Bundle 'tpope/vim-surround'
    " Repeating
    Bundle 'tpope/vim-repeat'
    " NerdCommenter
    Bundle 'scrooloose/nerdcommenter'

    " Syntax files
    Bundle 'nginx.vim'
    Bundle 'nono/jquery.vim'
    Bundle 'jelera/vim-javascript-syntax'

    " PHP
    Bundle 'paulyg/Vim-PHP-Stuff'
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
        Bundle 'AutoComplPop'
        Bundle 'ervandew/supertab'
        " Limit the popup menu height
        set pumheight=10
        set complete=.,w,b,u,U
        set completeopt=menuone,longest,preview
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
            au Filetype *
                \ if &omnifunc == '' |
                \ setlocal omnifunc=syntaxcomplete#Complete |
                \ endif

            " Automatically open and close the popup menu / preview window
            au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        augroup END
    endif

" Vim UI
    colorscheme simplex

    set guioptions=a
    set guifont=DejaVu_Sans_Mono:h10:cRUSSIAN,Consolas:h11:cRUSSIAN
    winsize 120 100 | winpos 0 0

    set lazyredraw              " don't redraw while executing macros
    set linespace=2             " extra spaces between rows
    set scrolloff=3             " minimum lines to keep above and below cursor
    set showtabline=2           " always show the tab pages
    set relativenumber          " show the line number
    set virtualedit=all         " allow virtual editing in all modes
    set shortmess=fmxsIa        " no intro screen and abbrev. of message

" Buffers & Window
    set hidden                  " allow buffer switching without saving
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
    set mousehide               " hide the mouse when typing text
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
    set statusline=%1*\ %l%*.%L\ %*             " line & total line
    set statusline+=%<%f\ %2*%-4M%*             " filename
    set statusline+=%=%2*%{&paste?'paste':''}%* " pastemode
    set statusline+=\ %{FileSize()}             " filesize
    set statusline+=\ %{&fileencoding}          " encoding
    set statusline+=%2*\ %Y\ %*                 " filetype
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

" Keybindings
    " Fast Esc
    imap jj <Esc>
    imap <A-s> <Esc>
    " Fast save
    map <A-w> :w!<cr>
    imap <A-w> <Esc>:w!<cr>
    imap <C-s> <Esc>:w!<cr>
    " Move one line
    nmap <A-h> <<
    nmap <A-l> >>
    nmap <A-j> ddp
    nmap <A-k> ddkP
    " Move multiple selected lines
    vmap <A-h> <'[V']
    vmap <A-l> >'[V']
    vmap <A-j> xp'[V']
    vmap <A-k> xkP'[V']
    " Ctrl + hjkl in Insert mode
    imap <C-h> <C-o>h
    imap <C-j> <C-o>j
    imap <C-k> <C-o>k
    imap <C-l> <C-o>l
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
    vmap <tab> %
    " Change language
    imap <A-r> <C-^>
    " Q to qq
    nmap Q qq
    " Ctrl+c
    imap <C-c> <Esc>
    " Don't skip wrap lines
    nmap j gj
    nmap k gk
    " ,ev opens .vimrc in a new tab
    nmap <leader>ev :tabedit $MYVIMRC<cr>
    " Toggle modes
    nmap <silent> <leader>p :set paste!<cr>
    nmap <silent> <leader>lw :set wrap!<cr>
    nmap <silent> <leader>tt :set shellslash!<cr>
    " Clear highlight after search
    nmap <silent> <leader>/ :nohlsearch<cr>
    " Search results in the center
    nmap n nzz
    nmap N Nzz
    nmap * *zz
    nmap # #zz
    nmap g* g*zz
    nmap g# g#zz

    " Try this
    nmap <C-l> 10zl
    nmap <C-h> 10zh
    nmap <S-F1> <C-f>
    nmap <S-F2> <C-b>
