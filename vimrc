" .vimrc / 2015 Apr
" Author: Alex Masterov <alex.masterow@gmail.com>
" Source: https://github.com/AlexMasterov/dotvim

" My vimfiles
"---------------------------------------------------------------------------
    let $VIMFILES = $VIM.'/vimfiles'
    let $VIMCACHE = $VIMFILES.'/cache'

    " Basic remapping
    let g:mapleader = ','
    " The prefix keys
    nmap <Space> [prefix]
    nnoremap [prefix] <Nop>

    let g:color_codes_ft = 'css,html,twig,html.twig'

    let &suffixes = ''
    " Ignore pattern
    let g:ignore_pattern =
    \   'hq,git,svn'
    \.  ',png,jpg,jpeg,gif,ico,bmp'
    \.  ',zip,rar,tar,tar.bz,tar.bz2'
    \.  ',o,a,so,obj.pyc,bin,exe,lib,dll'
    \.  ',lock,bak,tmp,dist,doc,docx,md'

" Environment
"---------------------------------------------------------------------------
    let s:is_windows = has('win32') || has('win64')

    if &compatible
        set nocompatible  " be improved
    endif
    if s:is_windows
        set shellslash
    endif
    set noexrc            " avoid reading local (g)vimrc, exrc
    set modelines=0       " prevents security exploits

    " Initialize autogroup in MyVimrc
    augroup MyVimrc| exe 'autocmd!' |augroup END

    " Echo startup time on start
    if has('vim_starting') && has('reltime')
        " Shell: vim --startuptime filename -q; vim filename
        " vim --cmd 'profile start profile.txt' --cmd 'profile file $HOME/.vimrc' +q && vim profile.txt
        let s:startuptime = reltime()
        au MyVimrc VimEnter * let s:startuptime = reltime(s:startuptime) | redraw
                    \| echomsg ' startuptime:'. reltimestr(s:startuptime)
    endif

" Functions
"---------------------------------------------------------------------------
    function! s:makeDir(dir, ...)
        let dir = expand(a:dir, 1)
        if !isdirectory(dir)
            \ && (a:0 || input(printf('"%s" does not exist. Create? [y/n]', dir)) =~? '^y\%[es]$')
            silent! call mkdir(iconv(dir, &encoding, &termencoding), 'p')
        endif
    endfunction

" Commands
"---------------------------------------------------------------------------
    " Vimrc augroup sugar
    command! -nargs=* Autocmd   au MyVimrc <args>
    command! -nargs=* AutocmdFT au MyVimrc FileType <args>
    command! -nargs=* Mkdir call <SID>makeDir(<f-args>)
    command! -bar -nargs=* Indent
        \ exe 'setl tabstop='.<q-args> 'softtabstop='.<q-args> 'shiftwidth='.<q-args>
    command! -nargs=* FontSize
        \ let &guifont = substitute(&guifont, '\d\+', '\=submatch(0)+<args>', 'g')
    " Strip trailing whitespace at the end of non-blank lines
    command! -bar FixWhitespace if !&bin| silent! :%s/\s\+$//ge |endif

" Events
"---------------------------------------------------------------------------
    " Reload vimrc
    Autocmd BufWritePost,FileWritePost $MYVIMRC
        \ if exists(':NeoBundleClearCache')| NeoBundleClearCache |endif | source $MYVIMRC | redraw
    " Resize splits then the window is resized
    Autocmd VimResized * wincmd =
    " Leave Insert mode and save when Vim lost focus
    " Autocmd FocusLost * if &filetype !=# 'unite'| call feedkeys("\<Esc>`^") | silent! wall |endif
    " Disable paste mode when leaving Insert mode
    Autocmd InsertLeave * if &paste| set nopaste |endif
    " Toggle settings between modes
    Autocmd InsertEnter * setl list colorcolumn=120
    Autocmd InsertLeave * setl nolist colorcolumn&
    " Don't auto insert a comment when using O/o for a newline (see also :help fo-table)
    Autocmd BufEnter,WinEnter * setl formatoptions-=ro
    " Automake directory
    Autocmd BufWritePre * call <SID>makeDir('<afile>:p:h', v:cmdbang)
    " Converts all remaining tabs to spaces on save
    " Autocmd BufReadPost,BufWrite * if &modifiable| FixWhitespace | retab |endif
    " q: close help buffer
    AutocmdFT help nnoremap <buffer> <expr> q winnr('$') == 1 ? ":\<C-u>bd\<CR>" : "\<C-w>c"

" Encoding
"---------------------------------------------------------------------------
    set encoding=utf-8
    scriptencoding utf-8

    if s:is_windows && has('multi_byte')
        setglobal fileencodings=utf-8,cp1251
        set termencoding=cp850  " cmd.exe uses cp850
    else
        set termencoding=       " same as 'encoding'
    endif

    " Default fileformat
    set fileformat=unix
    set fileformats=unix,dos,mac

    " Open in UTF-8
    command! -bar -bang -nargs=? -complete=file Utf8 edit<bang> ++enc=utf-8 <args>
    " Open in CP1251
    command! -bar -bang -nargs=? -complete=file Cp1251 edit<bang> ++enc=cp1251 <args>

" Misc
"---------------------------------------------------------------------------
    if has('vim_starting')
        set viminfo+=n$VIMFILES/viminfo
        " Cache
        Mkdir $VIMCACHE 1
        set noswapfile
        " Undo
        Mkdir $VIMFILES/undo 1
        set undofile
        set undolevels=500 undoreload=1000
        set undodir=$VIMFILES/undo
        " View
        set viewdir=$VIMFILES/views
        set viewoptions=cursor,slash,unix
    endif

    " Russian keyboard
    set iskeyword=@,48-57,_,192-255
    set keymap=russian-jcukenwin
    if has('multi_byte')
        set iminsert=0 imsearch=0
    endif

    " Regexp engine (0=auto, 1=old, 2=NFA)
    if exists('&regexpengine')
        set regexpengine=2
    endif

" Plugins
"---------------------------------------------------------------------------
    " Avoid loading same default plugins
    let g:loaded_gzip = 1
    let g:loaded_zipPlugin = 1
    let g:loaded_tarPlugin = 1
    let g:loaded_rrhelper = 1
    let g:loaded_matchparen = 1
    let g:loaded_netrwPlugin = 1
    let g:loaded_2html_plugin = 1
    let g:loaded_vimballPlugin = 1
    let g:loaded_getscriptPlugin = 1
    let g:loaded_spellfile_plugin = 1
    let g:did_install_default_menus = 1

    " Install NeoBundle
    if has('vim_starting')
        let s:neobundle_path = $VIMFILES.'/bundle/neobundle.vim'
        let s:neobundle_uri  = 'https://github.com/Shougo/neobundle.vim'
        if !isdirectory(s:neobundle_path)
            Mkdir $VIMFILES/bundle 1
            if executable('git')
                call system(printf('git clone --depth 1 %s %s',
                            \ s:neobundle_uri, s:neobundle_path))
            else
                echom "Can\'t download NeoBundle: Git not found."
            endif
        endif
        exe 'set runtimepath=$VIMFILES,$VIMRUNTIME,'.s:neobundle_path
    endif
    let g:neobundle#types#git#clone_depth = 1
    let g:neobundle#install_max_processes =
        \ exists('$NUMBER_OF_PROCESSORS') ? str2nr($NUMBER_OF_PROCESSORS) : 1

    function! CacheBundles()
        " Let NeoBundle manage NeoBundle
        NeoBundleFetch 'Shougo/neobundle.vim'
        " Local plugins for doing development
        exe 'NeoBundleLocal '.$VIMFILES.'/dev'

        NeoBundleLazy 'Shougo/vimproc.vim', {
        \   'build': {
        \       'mac':     'make -f make_mac.mak',
        \       'windows': 'tools\\update-dll-mingw'
        \}}

        " Util
        NeoBundle 'kopischke/vim-stay'
        " NeoBundle 'lilydjwg/colorizer'
        NeoBundleLazy 'mbbill/undotree', {
        \   'commands': 'UndotreeToggle'
        \}
        NeoBundleLazy 'tpope/vim-repeat', {
        \   'functions': ['repeat#set', 'repeat#setreg'],
        \   'mappings': '<Plug>'
        \}
        NeoBundle 'MattesGroeger/vim-bookmarks'
        NeoBundleLazy 'tyru/restart.vim', {
        \   'commands': 'Restart'
        \}
        NeoBundleLazy 'thinca/vim-quickrun', {
        \   'commands': 'QuickRun',
        \   'mappings': '<Plug>'
        \}
        NeoBundleLazy 'tpope/vim-characterize', {
        \   'mappings': '<Plug>'
        \}
        NeoBundleLazy 'kana/vim-smartword', {
        \   'mappings': '<Plug>'
        \}
        NeoBundleLazy 'maksimr/vim-jsbeautify', {
        \   'filetypes': ['javascript', 'html', 'css']
        \}
        NeoBundleLazy 'tpope/vim-dispatch'
        NeoBundle 'tpope/vim-projectionist', {
        \   'depends': 'tpope/vim-dispatch',
        \}
        NeoBundleLazy 'arecarn/crunch.vim', {
        \   'commands': 'Crunch',
        \   'mappings': ['<Plug>CrunchOperator', '<Plug>VisualCrunchOperator']
        \}

        NeoBundle 'luochen1990/rainbow'

        " UI
        NeoBundle 'Shougo/unite.vim'
        NeoBundle 'Shougo/neomru.vim'
        NeoBundleLazy 'osyo-manga/unite-vimpatches', {
        \   'unite_sources': 'vimpatches'
        \}
        NeoBundleLazy 'osyo-manga/unite-quickfix', {
        \   'unite_sources': 'quickfix'
        \}
        NeoBundleLazy 'Shougo/unite-outline', {
        \   'unite_sources': 'outline'
        \}
        NeoBundleLazy 'tsukkee/unite-tag', {
        \   'unite_sources': ['tag', 'tag/include', 'tag/file']
        \}
        NeoBundleLazy 'Shougo/unite-session', {
        \   'commands': ['UniteSessionSave', 'UniteSessionLoad'],
        \   'unite_sources': 'session'
        \}
        NeoBundleLazy 'thinca/vim-qfreplace', {
        \   'commands': 'Qfreplace',
        \   'filetypes': ['unite', 'quickfix']
        \}
        NeoBundleLazy 'osyo-manga/unite-filetype', {
        \   'unite_sources': ['filetype', 'filetype/new']
        \}

        " View
        NeoBundle 'osyo-manga/vim-brightest'

        " Edit
        NeoBundle 'ervandew/matchem'
        NeoBundle 'tpope/vim-commentary'
        NeoBundleLazy 'jakobwesthoff/argumentrewrap', {
        \   'functions': 'argumentrewrap#RewrapArguments'
        \}
        NeoBundleLazy 'AndrewRadev/sideways.vim', {
        \   'commands': 'Sideways',
        \   'mappings': '<Plug>'
        \}
        NeoBundleLazy 'splitjoin.vim', {
        \   'commands': ['SplitjoinJoin', 'SplitjoinSplit'],
        \}
        NeoBundleLazy 'junegunn/vim-easy-align', {
        \   'mappings': '<Plug>(EasyAlign)'
        \}
        NeoBundleLazy 'gcmt/wildfire.vim', {
        \   'mappings': '<Plug>'
        \}
        NeoBundleLazy 't9md/vim-smalls', {
        \   'mappings': '<Plug>'
        \}
        NeoBundleLazy 'saihoooooooo/glowshi-ft.vim', {
        \   'mappings': '<Plug>'
        \}
        NeoBundleLazy 'triglav/vim-visual-increment', {
        \   'mappings': ['<Plug>VisualIncrement', '<Plug>VisualDecrement']
        \}
        NeoBundleLazy 'AndrewRadev/switch.vim', {
        \   'commands': 'Switch',
        \}
        NeoBundleLazy 'kana/vim-smartchr', {
        \   'insert': 1
        \}
        NeoBundleLazy 'Shougo/context_filetype.vim'
        NeoBundleLazy 'Shougo/neocomplete.vim', {
        \   'depends': 'Shougo/context_filetype.vim',
        \   'commands': ['NeoCompleteLock', 'NeoCompleteUnlock'],
        \   'insert': 1,
        \}
        NeoBundleLazy 'SirVer/ultisnips', {
        \   'functions': 'UltiSnips#FileTypeChanged',
        \   'insert': 1
        \}

        " Text objects
        NeoBundle 'junegunn/vim-after-object'
        NeoBundleLazy 'kana/vim-textobj-user'
        NeoBundleLazy 'machakann/vim-textobj-delimited', {
        \   'depends': 'kana/vim-textobj-user',
        \   'mappings': ['vid', 'viD', 'vad', 'vaD']
        \}

        " Haskell
        NeoBundleLazy 'eagletmt/ghcmod-vim', {
        \   'disabled': !executable('ghc-mod'),
        \   'filetypes': 'haskell'
        \}
        NeoBundleLazy 'eagletmt/neco-ghc', {
        \   'disabled': !executable('ghc-mod'),
        \   'filetypes': 'haskell',
        \}
        NeoBundleLazy 'ujihisa/unite-haskellimport', {
        \   'disabled': !executable('hoogle'),
        \   'filetypes': 'haskell',
        \}
        NeoBundleLazy 'philopon/haskell-indent.vim', {
        \   'filetypes': 'haskell',
        \}
        NeoBundleLazy 'philopon/hassistant.vim', {
        \   'filetypes': 'haskell',
        \}

        " PHP
        NeoBundleLazy '2072/PHP-Indenting-for-VIm', {'filetypes': 'php'}
        NeoBundleLazy 'swekaj/php-foldexpr.vim',    {'filetypes': 'php'}
        NeoBundleLazy 'shawncplus/phpcomplete.vim', {'filetypes': 'php',
        \   'insert': 1
        \}
        NeoBundleLazy 'joonty/vdebug', {'filetypes': 'php'}
        NeoBundleLazy 'tobyS/vmustache'
        NeoBundleLazy 'tobyS/pdv', {
        \   'depends': 'tobyS/vmustache',
        \   'functions': 'pdv#DocumentWithSnip',
        \   'filetypes': 'php',
        \}
        " JavaScript
        NeoBundleLazy 'othree/yajs.vim',                        {'filetypes': 'javascript'}
        NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {'filetypes': 'javascript'}
        NeoBundleLazy 'jiangmiao/simple-javascript-indenter',   {'filetypes': 'javascript'}
        NeoBundleLazy 'hujo/jscomplete-html5API',               {'filetypes': 'javascript'}
        NeoBundleLazy  'https://bitbucket.org/teramako/jscomplete-vim.git', {'filetypes': 'javascript'}
        " CSS
        NeoBundleLazy 'JulesWang/css.vim',                   {'filetypes': 'css'}
        NeoBundleLazy 'hail2u/vim-css3-syntax',              {'filetypes': 'css'}
        NeoBundleLazy '1995eaton/vim-better-css-completion', {'filetypes': 'css'}
        " JSON
        NeoBundleLazy 'elzr/vim-json', {'filetypes': 'json'}
        " HTML / Twig
        NeoBundleLazy 'docunext/closetag.vim', {'filetypes': ['html', 'twig', 'html.twig']}
        NeoBundleLazy 'gregsexton/MatchTag' ,  {'filetypes': ['html', 'twig', 'html.twig']}
        NeoBundleLazy 'othree/html5.vim',      {'filetypes': ['html', 'twig', 'html.twig']}
        NeoBundleLazy 'evidens/vim-twig',      {'filetypes': ['twig', 'html.twig']}
        NeoBundleLazy 'tokutake/twig-indent',  {'filetypes': ['twig', 'html.twig']}
        " CSV
        NeoBundleLazy 'chrisbra/csv.vim', {'filetypes': 'csv'}
        " SQL
        NeoBundleLazy 'shmup/vim-sql-syntax', {'filetypes': ['sql', 'php']}
        " Nginx
        NeoBundleLazy 'yaroot/vim-nginx', {'filetypes': 'nginx'}
        " Log
        NeoBundle 'dzeban/vim-log-syntax'
        " VCS
        NeoBundle 'itchyny/vim-gitbranch'
        NeoBundleLazy 'cohama/agit.vim', {
        \   'commands': 'Agit'
        \}

        " NeoBundleCheck
        NeoBundleSaveCache
    endfunction

    call neobundle#begin($VIMFILES.'/bundle')
    if neobundle#has_cache()
        NeoBundleLoadCache
    else
        call CacheBundles()
    endif
    call neobundle#end()

    filetype plugin indent on
    if !exists('g:syntax_on')| syntax on |endif

" Bundle settings
"---------------------------------------------------------------------------
    if neobundle#is_installed('restart.vim')
        nnoremap <silent> <F9> :<C-u>Restart<CR>
    endif

    if neobundle#is_installed('undotree')
        let g:undotree_WindowLayout = 4
        let g:undotree_SplitWidth = 36
        let g:undotree_SetFocusWhenToggle = 1
        nnoremap <silent> <leader>u :call <SID>undotreeMyToggle()<CR>
        function! s:undotreeMyToggle()
            if &filetype != 'php'
                let s:undotree_lastft = &filetype
                AutocmdFT diff Autocmd BufEnter,WinEnter <buffer>
                    \ exe 'setl syntax='.s:undotree_lastft
            endif
            AutocmdFT diff Autocmd BufEnter,WinEnter <buffer>
                \ nmap <silent> <buffer> q :<C-u>UndotreeHide<CR>
                \| nmap <silent> <buffer> ` :<C-u>UndotreeHide<CR>
            UndotreeToggle
        endfunction
        function! g:Undotree_CustomMap()
            nmap <buffer> o <CR>
            nmap <buffer> u <Plug>UndotreeUndo
            nmap <buffer> r <Plug>UndotreeRedo
            nmap <buffer> h <Plug>UndotreeGoNextState
            nmap <buffer> l <Plug>UndotreeGoPreviousState
            nmap <buffer> d <Plug>UndotreeDiffToggle
            nmap <buffer> t <Plug>UndotreeTimestampToggle
            nmap <buffer> C <Plug>UndotreeClearHistory
        endfunction
        AutocmdFT diff,undotree setl nornu nonu colorcolumn=
    endif

    if neobundle#is_installed('crunch.vim')
        let g:crunch_result_type_append = 0
        nmap <silent> <leader>x <Plug>CrunchOperator_
        xmap <silent> <leader>x <Plug>VisualCrunchOperator
        " <L>z: toggle crunch append
        nmap <silent> <leader>z :<C-r>={
            \ '0': 'let g:crunch_result_type_append = 1',
            \ '1': 'let g:crunch_result_type_append = 0'}[g:crunch_result_type_append]<CR><CR>
    endif

    if neobundle#is_installed('vim-bookmarks')
        let g:bookmark_center = 1
        let g:bookmark_sign = '=>'
        let g:bookmark_auto_save = 1
        let g:bookmark_auto_save_file = $VIMCACHE.'/bookmarks'
        let g:bookmark_highlight_lines = 1
        nmap mm <Plug>BookmarkToggle
        nmap me <Plug>BookmarkNext
        nmap ma <Plug>BookmarkPrev
        nmap mq <Plug>BookmarkClear
        nmap mQ <Plug>BookmarkClearAll
        nmap <silent> [prefix]m :<C-u>BookmarkShowAll<CR>
        Autocmd VimEnter,Colorscheme *
            \ hi BookmarkLine guifg=#2B2B2B guibg=#F9EDDF gui=NONE
    endif

    if neobundle#is_installed('vim-visual-increment')
        " CTRL+A and CTRL+X works also for letters
        set nrformats+=alpha
        xmap <C-a> <Plug>VisualIncrement
        xmap <C-x> <Plug>VisualDecrement
    endif

    if neobundle#is_installed('vim-smartword')
        nmap w <Plug>(smartword-w)
        vmap w <Plug>(smartword-w)
        nmap e <Plug>(smartword-e)
        nmap b <Plug>(smartword-b)
    endif

    if neobundle#is_installed('vim-easy-align')
        let g:easy_align_ignore_groups = ['Comment', 'String']
        let g:easy_align_delimiters = {
        \   '>': {'pattern': '>>\|=>\|>' },
        \   '/': {'pattern': '//\+\|/\*\|\*/', 'delimiter_align': 'l', 'ignore_groups': ['^\(.\(Comment\)\@!\)*$']},
        \   ']': {'pattern': '[[\]]', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0},
        \   ')': {'pattern': '[()]', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0},
        \   'd': {'pattern': ' \(\S\+\s*[;=]\)\@=', 'left_margin': 0, 'right_margin': 0}
        \}
        vmap <Enter> <Plug>(EasyAlign)
    endif

    if neobundle#is_installed('vim-brightest')
        let g:brightest#enable_filetypes = {
        \   '_': 0,
        \   'php': 1,
        \   'javascript': 1
        \}
        let g:brightest#highlight = {'group': 'BrightestCursorLine'}
        let g:brightest#ignore_syntax_list = ['Comment']
        Autocmd VimEnter,Colorscheme *
            \ hi BrightestCursorLine guifg=#2B2B2B guibg=#FBF8EA gui=NONE
    endif

    if neobundle#is_installed('sideways.vim')
       nnoremap <silent> <C-h> :<C-u>SidewaysLeft<CR>
       nnoremap <silent> <C-l> :<C-u>SidewaysRight<CR>
       nnoremap <silent> <S-h> :<C-u>SidewaysJumpLeft<CR>
       nnoremap <silent> <S-l> :<C-u>SidewaysJumpRight<CR>
    endif

    if neobundle#is_installed('vim-jsbeautify')
        AutocmdFT javascript nmap <silent> <buffer> <leader>b :<C-u>call JsBeautify()<CR>
        AutocmdFT html       nmap <silent> <buffer> <leader>b :<C-u>call HtmlBeautify()<CR>
        AutocmdFT css        nmap <silent> <buffer> <leader>b :<C-u>call CSSBeautify()<CR>
    endif

    if neobundle#is_installed('agit.vim')
        nnoremap <silent> <leader>g :<C-u>Agit<CR>
    endif

    if neobundle#is_installed('closetag')
        let g:closetag_filenames = "*.html,*.twig,*.html,twig,*.xml"
    endif

    if neobundle#is_installed('vim-after-object')
        Autocmd VimEnter * call after_object#enable(
        \   '=', '-', ':', ';', '#', '>', '>', '$', '(', ')', '[', ']', ' '
        \)
    endif

    if neobundle#is_installed('wildfire.vim')
        let g:wildfire_objects = {
        \   '*': split("iw iW i' i\" i) a) a] a} it i> a> vV ip"),
        \   'html,twig,html.twig,xml': ["at"]
        \}
        nmap vv    <Plug>(wildfire-fuel)
        xmap vv    <Plug>(wildfire-fuel)
        xmap <C-v> <Plug>(wildfire-water)
    endif

    if neobundle#tap('vim-commentary')
        let g:commentary_map_backslash = 0
        function! neobundle#hooks.on_source(bundle)
            unmap cgc
        endfunction
        nmap q <Plug>CommentaryLine
        vmap q <Plug>Commentary
        nmap <leader>q gccyypgcc
        xmap <silent> <expr> <leader>q 'gcgvyp`['. strpart(getregtype(), 0, 1) .'`]gc'
        call neobundle#untap()
    endif

    if neobundle#is_installed('argumentrewrap')
        nnoremap <silent> <S-k> :<C-u>call argumentrewrap#RewrapArguments()<CR>
    endif

    if neobundle#is_installed('splitjoin.vim')
        " Join line in Insert mode using <C-J>
        nnoremap <silent> J :<C-u>call <SID>trySplitJoin('SplitjoinJoin',  'J')<CR>
        nnoremap <silent> S :<C-u>call <SID>trySplitJoin('SplitjoinSplit', "r\015")<CR><CR>
        function! s:trySplitJoin(cmd, default)
            if exists(':' . a:cmd) && !v:count
                let tick = b:changedtick
                exe a:cmd
                if tick == b:changedtick
                    exe join(['normal!', a:default])
                endif
            else
                exe join(['normal! ', v:count, a:default], '')
            endif
        endfunction
    endif

    if neobundle#is_installed('vim-smalls')
        let g:smalls_highlight = {
        \   'SmallsCandidate'  : [['NONE', 'NONE', 'NONE'],['NONE', '#DDEECC', '#000000']],
        \   'SmallsCurrent'    : [['NONE', 'NONE', 'NONE'],['bold', '#9DBAD7', '#000000']],
        \   'SmallsJumpTarget' : [['NONE', 'NONE', 'NONE'],['NONE', '#FF7311', '#000000']],
        \   'SmallsPos'        : [['NONE', 'NONE', 'NONE'],['NONE', '#FF7311', '#000000']],
        \   'SmallsCli'        : [['NONE', 'NONE', 'NONE'],['bold', '#DDEECC', '#000000']]
        \}
        call smalls#keyboard#cli#extend_table({
        \   "\<C-o>" : 'do_excursion',
        \   "\<C-i>" : 'do_excursion',
        \   "\<C-j>" : 'do_excursion',
        \   "\<C-k>" : 'do_excursion',
        \   "\<C-c>" : 'do_cancel',
        \   "\q"     : 'do_cancel',
        \   "\`"     : 'do_cancel'
        \})
        call smalls#keyboard#excursion#extend_table({
        \   "\Q" : 'do_cancel',
        \   "\o" : 'do_set',
        \   "\`" : 'do_set',
        \   "\p" : 'do_jump'
        \})
        nmap s <Plug>(smalls)
    endif

    if neobundle#is_installed('glowshi-ft.vim')
        let g:glowshi_ft_fix_key = '[\<NL>\o]'
        let g:glowshi_ft_cancel_key = '\`'
        let g:glowshi_ft_selected_hl_guibg = '#9DBAD7'
        let g:glowshi_ft_candidates_hl_guibg = '#DDEECC'
        let g:glowshi_ft_no_default_key_mappings = 1
        map f <Plug>(glowshi-ft-f)
        map F <Plug>(glowshi-ft-F)
        map t <Plug>(glowshi-ft-t)
        map T <Plug>(glowshi-ft-T)
    endif

    if neobundle#is_installed('switch.vim')
        let g:switch_mapping = ''
        let g:switch_def_quotes = [{
        \   '''\(.\{-}\)''': '"\1"',
        \   '"\(.\{-}\)"':  '''\1''',
        \   '`\(.\{-}\)`':  '''\1'''
        \}]
        let g:switch_def_camelcase = [{
        \   '\<\(\l\)\(\l\+\(\u\l\+\)\+\)\>': '\=toupper(submatch(1)) . submatch(2)',
        \   '\<\(\u\l\+\)\(\u\l\+\)\+\>': "\\=tolower(substitute(submatch(0), '\\(\\l\\)\\(\\u\\)', '\\1_\\2', 'g'))",
        \   '\<\(\l\+\)\(_\l\+\)\+\>': '\U\0',
        \   '\<\(\u\+\)\(_\u\+\)\+\>': "\\=tolower(substitute(submatch(0), '_', '-', 'g'))",
        \   '\<\(\l\+\)\(-\l\+\)\+\>': "\\=substitute(submatch(0), '-\\(\\l\\)', '\\u\\1', 'g')"
        \}]
        AutocmdFT php let b:switch_custom_definitions = [
        \   ['public', 'protected', 'private'],
        \   ['extends', 'implements'],
        \   ['use', 'namespace'],
        \   ['var_dump', 'print_r'],
        \   ['array', 'string'],
        \   ['include', 'require'],
        \   ['$_GET', '$_POST', '$_REQUEST'],
        \   {
        \       '\([^=]\)===\([^=]\)': '\1==\2',
        \       '\([^=]\)==\([^=]\)': '\1===\2'
        \   }
        \]
        AutocmdFT html,twig,html.twig let b:switch_custom_definitions = [
        \   ['id=', 'class=', 'style='],
        \   {
        \     '<div\(.\{-}\)>\(.\{-}\)</div>': '<span\1>\2</span>',
        \     '<span\(.\{-}\)>\(.\{-}\)</span>': '<div\1>\2</div>'
        \   },
        \   {
        \     '<ol\(.\{-}\)>\(.\{-}\)</ol>': '<ul\1>\2</ul>',
        \     '<ul\(.\{-}\)>\(.\{-}\)</ul>': '<ol\1>\2</ol>'
        \   }
        \]
        AutocmdFT css let b:switch_custom_definitions = [
        \   ['border-top', 'border-bottom'],
        \   ['border-left', 'border-right'],
        \   ['border-left-width', 'border-right-width'],
        \   ['border-top-width', 'border-bottom-width'],
        \   ['border-left-style', 'border-right-style'],
        \   ['border-top-style', 'border-bottom-style'],
        \   ['margin-left', 'margin-right'],
        \   ['margin-top', 'margin-bottom'],
        \   ['padding-left', 'padding-right'],
        \   ['padding-top', 'padding-bottom'],
        \   ['margin', 'padding'],
        \   ['height', 'width'],
        \   ['min-width', 'max-width'],
        \   ['min-height', 'max-height'],
        \   ['transition', 'animation'],
        \   ['absolute', 'relative', 'fixed'],
        \   ['overflow', 'overflow-x', 'overflow-y'],
        \   ['before', 'after'],
        \   ['none', 'block'],
        \   ['left', 'right'],
        \   ['top', 'bottom'],
        \   ['em', 'px', '%']
        \]
        nnoremap <silent> ` :Switch<CR>
        xnoremap <silent> ` :Switch<CR>
        nnoremap <silent> ! :<C-u>silent! call switch#Switch(g:switch_def_camelcase)<CR>
        nnoremap <silent> @ :<C-u>silent! call switch#Switch(g:switch_def_quotes)<CR>

    endif

    if neobundle#is_installed('vim-smartchr')
        command! -nargs=* ImapBufExpr inoremap <buffer> <expr> <args>
        " AutocmdFT php,javascript
        "     \  ImapBufExpr , smartchr#loop(',', ', ')
        AutocmdFT haskell
            \  ImapBufExpr \ smartchr#loop('\ ', '\')
            \| ImapBufExpr - smartchr#loop('-', ' -> ', ' <- ')
        AutocmdFT php
            \  ImapBufExpr - smartchr#loop('-', '->')
            \| ImapBufExpr $ smartchr#loop('$', '$this->', '$$')
            \| ImapBufExpr > smartchr#loop('>', '=>')
            \| ImapBufExpr ; smartchr#loop(';', '::')
        AutocmdFT javascript
            \| ImapBufExpr - smartchr#loop('-', '--', '_')
            \| ImapBufExpr $ smartchr#loop('$', 'this.', 'self.')
        AutocmdFT css
            \  ImapBufExpr ; smartchr#loop(';', ': ')
            \| ImapBufExpr % smartchr#loop('%', '% ')
            \| ImapBufExpr p smartchr#loop('p', 'px', 'px ')
        AutocmdFT yaml
            \  ImapBufExpr > smartchr#loop('>', '%>')
            \| ImapBufExpr < smartchr#loop('<', '<%', '<%=')
    endif

    if neobundle#is_installed('context_filetype.vim')
        function! s:addContext(rule, filetype)
            let s:context_ft_def = context_filetype#default_filetypes()
            let g:context_filetype#filetypes[a:filetype] = add(s:context_ft_def.html, a:rule)
        endfunction
        " ReactJS
        let s:context_ft_jsx = {
        \   'start': '<script\%( [^>]*\)\? type="text/jsx"\%( [^>]*\)\?>',
        \   'end': '</script>',
        \   'filetype': 'javascript',
        \}
        call <SID>addContext(s:context_ft_jsx, 'html')
        " CSS
        let s:context_ft_css = {
        \   'start': '<style>',
        \   'end': '</style>',
        \   'filetype': 'css',
        \}
        call <SID>addContext(s:context_ft_css, 'html')
    endif

    if neobundle#is_installed('neocomplete.vim')
        let g:neocomplete#enable_at_startup = 1
        let g:neocomplete#enable_smart_case = 1
        let g:neocomplete#enable_camel_case = 1
        let g:neocomplete#enable_insert_char_pre = 1
        let g:neocomplete#data_directory = $VIMCACHE.'/neocomplete'
        let g:neocomplete#min_keyword_length = 2
        let g:neocomplete#auto_completion_start_length = 1
        let g:neocomplete#manual_completion_start_length = 1
        let g:neocomplete#sources#syntax#min_keyword_length = 3
        let g:neocomplete#sources#buffer#disabled_pattern = '\.log\|\.log\.'

        let g:neocomplete#enable_cursor_hold_i = 1
        let g:neocomplete#cursor_hold_i_time = 4000
        " Reset 'CursorHold' time
        Autocmd InsertEnter * setl updatetime=260
        Autocmd InsertLeave * set  updatetime=4000

        " Alias filetypes
        let g:neocomplete#same_filetypes = get(g:, 'neocomplete#same_filetypes', {})
        let g:neocomplete#same_filetypes.html  = 'twig,html.twig'
        " " Sources
        let g:neocomplete#sources = get(g:, 'g:neocomplete#sources', {})
        let g:neocomplete#sources._ = ['buffer']
        let g:neocomplete#sources.php = ['buffer', 'member', 'omni', 'tag', 'file', 'ultisnips']
        let g:neocomplete#sources.javascript = ['buffer', 'member', 'omni', 'tag', 'ultisnips']
        let g:neocomplete#sources.html = ['buffer', 'omni', 'file', 'ultisnips']
        let g:neocomplete#sources.css = ['omni', 'ultisnips']
        " Custom settings
        call neocomplete#custom#source('omni', 'rank', 10)
        call neocomplete#custom#source('tag', 'rank', 20)
        call neocomplete#custom#source('buffer', 'rank', 30)
        call neocomplete#custom#source('ultisnips', 'rank', 100)
        call neocomplete#custom#source('ultisnips', 'min_pattern_length', 1)
        " Completion patterns
        let g:neocomplete#sources#omni#input_patterns = get(g:, 'g:neocomplete#sources#omni#input_patterns', {})
        let g:neocomplete#sources#omni#input_patterns.php =
            \ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?\|\(new\|use\|extends\|implements\|instanceof\)\%(\s\|\s\\\)'
        let g:neocomplete#sources#omni#input_patterns.javascript = '\h\w*\|\h\w*\.\%(\h\w*\)\?\[^. \t]\.\%(\h\w*\)\?'
        let g:neocomplete#sources#omni#input_patterns.css = '\w*\|\w\+[-:;)]\?\s\+\%(\h\w*\)\?\|[@!]'
        let g:neocomplete#sources#omni#input_patterns.sql = '\h\w*\|[^.[:digit:] *\t]\%(\.\)\%(\h\w*\)\?'

        " Tab: completion
        imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-x>\<C-o>"
        imap <expr> <C-j>   pumvisible() ? "\<C-n>" : "\<C-j>"
        imap <expr> <C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"
        imap <silent> <expr> <Tab> pumvisible() ?
            \ "\<C-n>" : <SID>checkBackSpace() ?
            \ "\<Tab>" : neocomplete#start_manual_complete()

        function! s:checkBackSpace()
            let col = col('.') - 1
            return !col || getline('.')[col-1] =~ '\s'
        endfunction
    endif

    if neobundle#is_installed('ultisnips')
        let g:UltiSnipsExpandTrigger = '`'
        let g:UltiSnipsListSnippets = '<F12>'
        let g:UltiSnipsJumpForwardTrigger = '<C-m>'
        let g:UltiSnipsJumpBackwardTrigger = '<C-n>'
        let g:UltiSnipsSnippetsDir = $VIMFILES.'/dev/dotvim/ultisnips'
        snoremap <C-c> <Esc>
        Autocmd BufNewFile,BufRead *.snippets setl filetype=snippets
    endif

    if neobundle#is_installed('unite.vim')
        let g:unite_source_history_yank_enable = 0
        let g:unite_source_rec_min_cache_files = 50
        let g:unite_source_buffer_time_format = '%H:%M '
        let g:unite_data_directory = $VIMCACHE.'/unite'
        " Search tool
        let g:unite_source_grep_command = executable('pt') ? 'pt' : executable('ag') ? 'ag' : 'ack'
        let g:unite_source_grep_recursive_opt = ''
        let g:unite_source_grep_encoding = 'utf-8'
        let g:unite_source_grep_default_opts = '--follow --smart-case --nogroup --nocolor'
        if executable('ag')
            let g:unite_source_rec_async_command = 'ag'
                \.  ' '. join(map(split(g:ignore_pattern, ','), '"\--ignore \"*.".v:val."\""'), ' ')
                \.  (&smartcase ? ' -S' : ''). ' --nogroup --nocolor -C4 -l .'
        endif

        " Default profile
        let s:unite_default = {
        \   'winheight': 14,
        \   'direction': 'below',
        \   'prompt_direction': 'top',
        \   'cursor_line_time': '0.0',
        \   'short_source_names': 1,
        \   'hide_source_names': 1,
        \   'hide_icon': 0,
        \   'marked_icon': '+',
        \   'prompt': '>',
        \   'wipe': 1
        \}
        " Quickfix profile
        let s:unite_quickfix = {
        \   'winheight': 16,
        \   'no_quit': 1,
        \   'keep_focus': 1
        \}
        " Line profile
        let s:unite_line = {
        \   'winheight': 20
        \}

        " Custom profiles
        call unite#custom#profile('default', 'context', s:unite_default)
        call unite#custom#profile('source/quickfix', 'context', s:unite_quickfix)
        call unite#custom#profile('source/line,source/grep', 'context', s:unite_line)

        " Custom filters
        call unite#filters#sorter_default#use(['sorter_rank'])
        call unite#filters#matcher_default#use(['matcher_fuzzy'])
        call unite#custom#source('buffer', 'sorters', 'sorter_reverse')
        call unite#custom#source('file_rec/async', 'max_candidates', 0)
        call unite#custom#source('file_rec/async',
            \ 'matchers', ['converter_relative_word', 'matcher_fuzzy'])
        call unite#custom#source('source/grep,',
            \ 'ignore_globs', map(split(g:ignore_pattern, ','), '"\*.".v:val.""'))

        " Unite tuning
        AutocmdFT unite
            \ setl nolist guicursor=a:blinkon0
            \| Autocmd InsertEnter,InsertLeave <buffer>
                \ setl nonu nornu nolist colorcolumn=
        Autocmd VimEnter,Colorscheme *
            \  hi uniteStatusHead             guifg=#2B2B2B guibg=#E6E6E6 gui=NONE
            \| hi uniteStatusNormal           guifg=#2B2B2B guibg=#E6E6E6 gui=NONE
            \| hi uniteStatusMessage          guifg=#2B2B2B guibg=#E6E6E6 gui=NONE
            \| hi uniteStatusLineNR           guifg=#D14000 guibg=#E6E6E6 gui=NONE
            \| hi uniteStatusSourceNames      guifg=#2B2B2B guibg=#E6E6E6 gui=NONE
            \| hi uniteStatusSourceCandidates guifg=#0000FF guibg=#E6E6E6 gui=NONE

        AutocmdFT unite call <SID>uniteSettings()
            \| imap <buffer> <C-i> <Plug>(unite_insert_leave)
        function! s:uniteSettings()
            " Normal mode
            nmap <buffer> `       <Plug>(unite_exit)
            nmap <buffer> q       <Plug>(unite_exit)
            nmap <buffer> <S-Tab> <Plug>(unite_loop_cursor_up)
            nmap <buffer> <Tab>   <Plug>(unite_loop_cursor_down)
            nmap <silent> <buffer> <expr> o  unite#do_action('open')
            nmap <silent> <buffer> <expr> ss unite#do_action('split')
            nmap <silent> <buffer> <expr> sv unite#do_action('vsplit')
            nmap <silent> <buffer> <expr> cc unite#do_action('lcd')
            nmap <silent> <buffer> <expr> b  unite#do_action('backup')
            nmap <silent> <buffer> <expr> y  unite#do_action('yank')
            nmap <silent> <buffer> <expr> Y  unite#do_action('yank_escape')

            let unite = unite#get_current_unite()
            if unite.profile_name ==# 'line'
                nmap <silent> <buffer> <expr> r unite#do_action('replace')
            else
                nmap <silent> <buffer> <expr> r unite#do_action('rename')
            endif

            " Insert mode
            imap <buffer> `       <Plug>(unite_exit)
            imap <buffer> <C-n>   <Plug>(unite_complete)
            imap <buffer> <Tab>   <Plug>(unite_select_next_line)
            imap <buffer> <S-Tab> <Plug>(unite_select_previous_line)
            imap <buffer> <C-a>   <Plug>(unite_move_head)
            imap <buffer> <C-j>   <Plug>(unite_move_left)
            imap <buffer> <C-l>   <Plug>(unite_move_right)
            imap <buffer> <C-p>   <Plug>(unite_delete_backward_path)
            imap <buffer> <C-d>   <Plug>(unite_delete_backward_line)
            imap <buffer> <C-j>   <Plug>(unite_select_next_line)
            imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
            imap <buffer> <expr> <C-e> len(getline('.')) != 1 ? "\<Plug>(unite_delete_backward_char)" : ''
            imap <buffer> <expr> <BS>  len(getline('.')) != 1 ? "\<Plug>(unite_delete_backward_char)" : ''

            " Command mode
            cmap <buffer> ` <Esc>
        endfunction

        " Space-b: open buffers
        nnoremap <silent> <Space>b :<C-u>Unite buffer<CR>
        " Space-h: open windows
        nnoremap <silent> <Space>h :<C-u>Unite window<CR>
        " Space-t: open tab pages
        nnoremap <silent> [prefix]t
            \ :<C-u>Unite tab -buffer-name=tabs -select=`tabpagenr()-1`<CR>
        " Space-f: open files
        nnoremap <silent> <Space>f
            \ :<C-u>UniteWithCurrentDir file_rec/async file/new directory/new -start-insert<CR>

        " Space-g: grep search
        nnoremap <silent> <Space>g
            \ :<C-u>Unite grep:. -no-split -auto-preview<CR>
        " /: search
        nnoremap <silent> /
            \ :<C-u>Unite line:forward:wrap -buffer-name=search-`bufnr('%')` -no-wipe -no-split -start-insert<CR>
        " *: search keyword under the cursor
        nnoremap <silent> <expr> *
            \ :<C-u>UniteWithCursorWord line:forward:wrap -buffer-name=search-`bufnr('%')` -no-wipe<CR>
        " [prefix]r: resume search buffer
        nnoremap <silent> <expr> [prefix]r
            \ :<C-u>UniteResume search-`bufnr('%')` -no-start-insert -force-redraw<CR>

        " [prefix]o: open message log
        nnoremap <silent> [prefix]x :<C-u>Unite output:message<CR>
        " [prefix]i: NeoBundle update
        nnoremap <silent> [prefix]u :<C-u>Unite neobundle/update
            \ -buffer-name=neobundle -no-split -no-start-insert -multi-line -max-multi-lines=1 -log<CR>
    endif

    if neobundle#is_installed('neomru.vim')
        let g:neomru#file_mru_path = $VIMCACHE.'/unite/file'
        let g:neomru#file_mru_ignore_pattern = '\.\%([_]vimrc\|txt\)$'
        let g:neomru#filename_format = ':~:.'
        let g:neomru#directory_mru_path = $VIMCACHE.'/unite/directory'
        let g:neomru#time_format = '%d.%m %H:%M — '
        " Limit results for recently edited files
        call unite#custom#source('neomru/file,neomru/directory', 'limit', 30)
        " Search relative to Project Root if it exists
        call unite#custom#source('neomru/file,neomru/directory',
            \ 'matchers', ['matcher_project_files', 'matcher_fuzzy'])
        " [prefix]l: open recently-opened files
        nnoremap <silent> [prefix]l :<C-u>Unite neomru/file<CR>
        " [prefix]L: open recently-opened directories
        nnoremap <silent> [prefix]L :<C-u>Unite neomru/directory<CR>
    endif

    if neobundle#is_installed('unite-vimpatches')
        " [prefix]p: open vimpatches log
        nnoremap <silent> [prefix]U :<C-u>Unite vimpatches -buffer-name=neobundle<CR>
    endif

    if neobundle#is_installed('unite-outline')
        " [prefix]o: outline
        nnoremap <silent> [prefix]o :<C-u>Unite outline -winheight=16 -silent<CR>
    endif

    if neobundle#is_installed('unite-filetype')
        call unite#custom#source('filetype', 'sorters', 'sorter_length')
        " [prefix]r: filetype change
        nnoremap <silent> [prefix]z :<C-u>Unite filetype filetype/new -start-insert<CR>
    endif

    if neobundle#is_installed('unite-tag')
        Autocmd BufEnter,WinEnter * call <SID>UniteTagSettings()
        function! s:UniteTagSettings()
            if empty(&buftype)
                " Ctrl-]: open tag under cursor
                nnoremap <silent> <buffer> <C-]> :<C-u>UniteWithCursorWord tag -immediately<CR>
                " m+t: open tag
                nmap <silent> <buffer> mt :<C-u>UniteWithCursorWord tag tag/include<CR>
                " m+T: search tag by name
                nmap <silent> <buffer> mT :<C-u>call <SID>inputSearchTag()<CR>
            endif
        endfu
        function! s:inputSearchTag()
            let search_word = input(' Tag name: ')
            if search_word != ''
                exe ':Unite tag:'. escape(search_word, '"')
            endif
        endfunction
    endif

    if neobundle#is_installed('unite-session')
        let g:unite_source_session_path = $VIMFILES.'/session'
        let g:unite_source_session_options = 'buffers,folds,curdir,winsize,winpos,winsize'
        nmap <silent> <leader>sa :<C-u>call <SID>inputSessionName()<CR>
        nmap <silent> <leader>ss :<C-u>SessionSaveWithTimeStamp<CR>
        nmap <silent> <leader>sl :<C-u>Unite session -buffer-name=session -default-action=load<CR>

        command! -nargs=0 SessionSaveWithTimeStamp
            \  exe 'UniteSessionSave' strftime('%y%m%d_%H%M%S')
            \| echo ' Session saved. '. strftime('(%H:%M:%S — %d.%m.%Y)')

        function! s:inputSessionName()
            let session_name = input(' Session name: ')
            if session_name != ''
                exe ':UniteSessionSave '. escape(session_name, '"')
            endif
        endfunction

        AutocmdFT unite call <SID>UniteSessionSettings()
        function! s:UniteSessionSettings()
            if unite#get_current_unite().profile_name ==# 'session'
                nmap <silent> <buffer> <expr> o unite#do_action('load')
                nmap <silent> <buffer> <expr> s unite#do_action('save')
                nmap <silent> <buffer> <expr> d unite#do_action('delete')
                nmap <silent> <buffer> <expr> r unite#do_action('rename')
            endif
        endfunction
    endif

    if neobundle#is_installed('vim-qfreplace')
        " qfreplace tuning
        AutocmdFT qfreplace call feedkeys("\<CR>\<CR>")
        Autocmd BufNewFile,BufRead \[qfreplace\] call feedkeys("\<CR>\<CR>")
        AutocmdFT qfreplace setl nornu nonu colorcolumn= laststatus=0
        AutocmdFT qfreplace Autocmd InsertEnter,InsertLeave <buffer> setl nornu nonu colorcolumn=
        AutocmdFT qfreplace Autocmd BufEnter,WinEnter <buffer> setl laststatus=0
        AutocmdFT qfreplace Autocmd BufLeave,BufDelete <buffer> set laststatus=2
        AutocmdFT qfreplace nnoremap <silent> <buffer> ` :<C-u>bdelete!<CR>
    endif

" Languages
"---------------------------------------------------------------------------
" Haskell
    AutocmdFT haskell,lhaskell,chaskell Indent 4
    AutocmdFT cabal   Indent 2
    " Syntax
    AutocmdFT haskell,lhaskell,chaskell setl iskeyword+='
    AutocmdFT haskell,lhaskell,chaskell setl commentstring=--\ %s
    " Autocomplete
    if neobundle#tap('neco-ghc')
        function! neobundle#hooks.on_source(bundle)
            let g:necoghc_enable_detailed_browse = 1
        endfunction
        call neobundle#untap()
        AutocmdFT haskell,lhaskell,chaskell setl omnifunc=necoghc#omnifunc
    endif
    " Misc
    if neobundle#is_installed('ghcmod-vim')
        AutocmdFT haskell,lhaskell,chaskell
            \  nnoremap <silent> <buffer> <leader>t :<C-u>GhcModType<CR>
            \| nnoremap <silent> <buffer> <leader>l :<C-u>GhcModLint<CR>
            \| Autocmd BufWritePost,FileWritePost <buffer> GhcModCheckAsync
    endif

" PHP
    AutocmdFT php Indent 4
    " Syntax
    let g:php_highlight_html = 1
    " Fold
    if neobundle#is_installed('php-foldexpr.vim')
        AutocmdFT php setl foldenable
            \| let b:phpfold_use = 1
            \| let b:phpfold_group_args = 0
            \| let b:phpfold_group_case = 0
            \| let b:phpfold_group_iftry = 0
            \| let b:phpfold_text = 1
            \| let b:phpfold_text_percent = 0
            \| let b:phpfold_text_right_lines = 1
            \| let b:phpfold_heredocs = 1
            \| let b:phpfold_docblocks = 0
            \| let b:phpfold_doc_with_funcs = 0
    endif
    " Autocomplete
    if neobundle#tap('phpcomplete.vim')
        function! neobundle#hooks.on_source(bundle)
            let g:phpcomplete_relax_static_constraint = 0
            let g:phpcomplete_parse_docblock_comments = 0
            let g:phpcomplete_search_tags_for_variables = 1
            let g:phpcomplete_complete_for_unknown_classes = 0
            let g:phpcomplete_remove_function_extensions = [
            \   'apache', 'apc', 'dba', 'dbase', 'odbc', 'msql', 'mssql', 'mysql'
            \]
            let g:phpcomplete_remove_class_extensions = [
            \   'apc'
            \]
            let g:phpcomplete_remove_constant_extensions = [
            \   'apc', 'ms_sql_server_pdo', 'msql', 'mssql', 'mysql'
            \]
        endfunction
        AutocmdFT php setl omnifunc=phpcomplete#CompletePHP
        call neobundle#untap()
    endif
    " PHP Documentor
    if neobundle#tap('pdv')
        function! neobundle#hooks.on_source(bundle)
            let g:pdv_template_dir = $VIMFILES.'/dev/dotvim/templates'
        endfunction
        AutocmdFT php
            \ nmap <silent> <buffer> <leader>c :<C-u>silent! call pdv#DocumentWithSnip()<CR>
        call neobundle#untap()
    endif
    " vDebug (for xDebug)
    if neobundle#tap('vdebug')
        function! neobundle#hooks.on_source(bundle)
            let g:vdebug_options = {
            \   'port': 9001,
            \   'server': '10.10.78.16',
            \   'on_close': 'detach',
            \   'break_on_open': 1,
            \   'debug_window_level': 0,
            \   'watch_window_style': 'compact',
            \   'path_maps': {'/www': 'D:/Vagrant/projects'},
            \}
            let g:vdebug_features = {
            \   'max_depth': 2048
            \}
        endfunction
        Autocmd VimEnter,Colorscheme *
            \  hi DbgCurrentLine guifg=#2B2B2B guibg=#D2FAC1 gui=NONE
            \| hi DbgCurrentSign guifg=#2B2B2B guibg=#E4F3FB gui=NONE
            \| hi DbgBreakptLine guifg=#2B2B2B guibg=#FDCCD9 gui=NONE
            \| hi DbgBreakptSign guifg=#2B2B2B guibg=#E4F3FB gui=NONE
        call neobundle#untap()
    endif

" JavaScript
    AutocmdFT javascript Indent 4
    " Syntax
    if neobundle#tap('javascript-libraries-syntax')
        function! neobundle#hooks.on_source(bundle)
            let g:used_javascript_libs = 'react,angularjs,underscore,jquery'
        endfunction
        call neobundle#untap()
    endif
    if neobundle#tap('simple-javascript-indenter')
        function! neobundle#hooks.on_source(bundle)
            let g:SimpleJsIndenter_BriefMode = 1
            let g:SimpleJsIndenter_CaseIndentLevel = -1
        endfunction
        call neobundle#untap()
    endif
    " Autocomplete
    if neobundle#tap('jscomplete-vim')
        function! neobundle#hooks.on_source(bundle)
            let g:jscomplete_use = ['dom', 'moz', 'es6th', 'html5API']
        endfunction
        Autocmd BufNewFile,BufRead *.js setl omnifunc=jscomplete#CompleteJS
        call neobundle#untap()
    endif

" HTML
    AutocmdFT html Indent 2
    AutocmdFT html iabbrev <buffer> & &amp;
    " Autocomplete
    AutocmdFT html setl omnifunc=htmlcomplete#CompleteTags

" CSS
    AutocmdFT css setl nowrap | Indent 2
    " Syntax
    AutocmdFT css setl iskeyword+=-,%
    if neobundle#is_installed('colorizer')
        Autocmd BufEnter,WinEnter *
            \ exe index(split(g:color_codes_ft, ','), &filetype) == -1
            \ ? ':ColorClear' : ':ColorHighlight'
    endif
    " Autocomplete
    AutocmdFT css setl omnifunc=csscomplete#CompleteCSS

" Twig
    AutocmdFT twig,html.twig Indent 2
    " Syntax
    if neobundle#is_installed('MatchTag')
        AutocmdFT twig,html.twig runtime! ftplugin/html.vim
    endif

" JSON
    " Syntax
    if neobundle#tap('vim-json')
        function! neobundle#hooks.on_source(bundle)
            let g:vim_json_syntax_concealcursor = 'inc'
        endfunction

        Autocmd InsertEnter *.json setl concealcursor=
        Autocmd InsertLeave *.json setl concealcursor=inc
        AutocmdFT json
            \ nmap <buffer> <silent> <leader>c :<C-r>={
            \   '0': 'setl conceallevel=2',
            \   '2': 'setl conceallevel=0'}[&conceallevel]<CR><CR>

        call neobundle#untap()
    endif

" Yaml
    AutocmdFT yaml setl nowrap | Indent 4

" XML
    AutocmdFT xml setl nowrap | Indent 4
    " Autocomplete
    AutocmdFT xml setl omnifunc=xmlcomplete#CompleteTags

" Nginx
    Autocmd BufNewFile,BufRead */nginx/** setl filetype=nginx commentstring=#%s

" Vagrant
    Autocmd BufNewFile,BufRead Vagrantfile setl filetype=ruby

" Vim
    AutocmdFT vim setl iskeyword+=:

" GUI
"---------------------------------------------------------------------------
    if has('gui_running')
        set guioptions=ac
        set guicursor=n-v:blinkon0  " turn off blinking the cursor
        set linespace=3             " extra spaces between rows
        " Window size and position
        if has('vim_starting')
            winsize 176 38 | winpos 492 314
            " winsize 140 46 | winpos 360 224
        endif
    endif

    " Font
    if s:is_windows
        set guifont=Droid_Sans_Mono:h10,Consolas:h11
    else
        set guifont=Droid\ Sans\ Mono\ 10,Consolas\ 11
    endif

    " DirectWrite
    if s:is_windows && has('directx')
        set renderoptions=type:directx,gamma:2.2,contrast:0.5,level:0.0,geom:1,taamode:1,renmode:3
    endif

" View
"---------------------------------------------------------------------------
    " Don't override colorscheme on reloading
    if !exists('g:colors_name')| silent! colorscheme topos |endif
    " Reload the colorscheme whenever we write the file
    exe 'Autocmd BufWritePost '.g:colors_name.'.vim colorscheme '.g:colors_name

    set shortmess=aoOtTIc
    set number relativenumber    " show the line number
    set nocursorline             " highlight the current line
    set hidden                   " allows the closing of buffers without saving
    set switchbuf=useopen,split  " orders to open the buffer
    set showtabline=1            " always show the tab pages
    set noequalalways            " resize windows as little as possible
    set winminheight=0
    set splitbelow splitright

    " Diff
    set diffopt=iwhite,vertical

    " Fold
    set nofoldenable

    " Wrapping
    if exists('+breakindent')
        set wrap                         " wrap long lines
        set linebreak                    " wrap without line breaks
        set breakindent                  " wrap lines, taking indentation into account
        set breakindentopt=shift:4       " indent broken lines
        set breakat=\ \ ;:,!?            " break point for linebreak
        set textwidth=0                  " do not wrap text
        set display+=lastline            " easy browse last line with wrap text
        set whichwrap=<,>,[,],h,l,b,s,~  " end/beginning-of-line cursor wrapping behave human-like
    else
        set nowrap
    endif

    " Highlight invisible symbols
    set nolist listchars=precedes:<,extends:>,nbsp:.,tab:+-,trail:•
    " Avoid showing trailing whitespace when in Insert mode
    let s:trailchar = matchstr(&listchars, '\(trail:\)\@<=\S')
    Autocmd InsertEnter * exe 'setl listchars-=trail:'. s:trailchar
    Autocmd InsertLeave * exe 'setl listchars+=trail:'. s:trailchar

    " Title-line
    set titlestring=%t\ %{(!empty(expand('%:h'))\ ?\ printf('(%s)',\ expand('%:h'))\ :\ '')}

    " Command-line
    set cmdheight=1
    set noshowcmd    " don't show command on statusline
    set noshowmode   " don't show the mode ("-- INSERT --") at the bottom
    set wildmenu wildmode=longest,full

    " Status-line
    set laststatus=2
    " Format the statusline
    let &statusline =
    \ "%1* %L %*"
    \. "%(%{exists('*GitStatus()') ? GitStatus() : ''}\ %)"
    \. "%-0.50f "
    \. "%2*%(%{exists('*BufModified()') ? BufModified() : ''}\ %)%*"
    \. "%="
    \. "%(%{exists('*FileSize()') ? FileSize() : ''}\ %)"
    \. "%2*%(%{&paste ? '[P]' : ''}\ %)%*"
    \. "%2*%(%{&iminsert ? 'RU' : 'EN'}\ %)%*"
    \. "%(%{&fileencoding == '' ? &encoding : &fileencoding}\ %)"
    \. "%2*%(%Y\ %)%*"

    " Status-line functions
    function! BufModified()
        return &ft =~ 'help' ? '' : (&modified ? '+' : '')
    endfunction

    function! FileSize()
        let bytes = getfsize(expand('%:p'))
        return bytes <= 0 ? '' :
            \ bytes < 1024 ? bytes.'B' : (bytes / 1024).'K'
    endfunction

    function! GitStatus()
        return exists('*gitbranch#name()') && gitbranch#name() !=# '' ?
            \ printf('[%s]', gitbranch#name()) : ''
    endfunction

" Edit
"---------------------------------------------------------------------------
    set report=0           " reporting number of lines changes
    set lazyredraw         " don't redraw while executing macros
    set nostartofline      " avoid moving cursor to BOL when jumping around
    set virtualedit=all    " allows the cursor position past true end of line
    set clipboard=unnamed  " use * register for copy-paste

    " Keymapping timeout (mapping / keycode)
    set notimeout ttimeoutlen=100
    " set timeoutlen=2000 ttimeoutlen=100

    " Indent
    set cindent          " smart indenting for c-like code
    set autoindent       " indent at the same level of the previous line
    set shiftround       " indent multiple of shiftwidth
    set expandtab        " spaces instead of tabs
    set tabstop=4        " number of spaces per tab for display
    set shiftwidth=4     " number of spaces per tab in insert mode
    set softtabstop=4    " number of spaces when indenting
    set nojoinspaces     " prevents inserting two spaces after punctuation on a join (J)

    " Backspacing settings
    " indent  allow backspacing over autoindent
    " eol     allow backspacing over line breaks (join lines)
    " start   allow backspacing over the start of insert;
    "         CTRL-W and CTRL-U stop once at the start of insert
    set backspace=indent,eol,start

    " Search
    set hlsearch         " highlight search results
    set incsearch        " find as you type search
    set ignorecase
    set smartcase
    set magic            " change the way backslashes are used in search patterns
    " set gdefault         " flag 'g' by default for replacing

    " Autocomplete
    set complete=.
    set completeopt=longest
    set pumheight=9
    " Syntax complete if nothing else available
    Autocmd BufEnter,WinEnter * if &omnifunc == ''| setl omnifunc=syntaxcomplete#Complete |endif

" Shortcuts
"---------------------------------------------------------------------------
    " Insert the current file
    ab ##f <C-r>=expand('%:t:r')<CR>
    ca ##f <C-r>=expand('%:t:r')<CR>
    " Insert the current file path
    ab ##p <C-r>=expand('%:p')<CR>
    ca ##p <C-r>=expand('%:p')<CR>
    " Insert the current file directory
    ab ##d <C-r>=expand('%:p:h').'\'<CR>
    ca ##d <C-r>=expand('%:p:h').'\'<CR>
    " Inset the current timestamp
    ab ##t <C-r>=strftime('%Y-%m-%d')<CR>
    ca ##t <C-r>=strftime('%Y-%m-%d')<CR>
    " Inset the current Unix time
    ab ##l <C-r>=localtime()<CR>
    ca ##l <C-r>=localtime()<CR>

" Normal mode
"---------------------------------------------------------------------------
    " jk: don't skip wrap lines
    nmap <expr> j v:count ? 'j' : 'gj'
    nmap <expr> k v:count ? 'k' : 'gk'
    " Alt-[jkhl]: move selected lines
    nnoremap <A-j> ddp
    nnoremap <A-k> ddkP
    nnoremap <A-h> <<<Esc>
    nnoremap <A-l> >>><Esc>
    " H: move to start of line
    nnoremap H ^
    " L: move to end of line
    nnoremap L $
    " Q: auto indent text
    nnoremap Q ==
    " Y: yank line
    nnoremap Y y$
    " Ctrl-[jk]: scroll up/down
    nnoremap <C-j> <C-d>
    nnoremap <C-k> <C-u>
    " Ctrl-d: duplicate line
    nnoremap <silent> <C-d> yyp
    " [dDcC]: don't update register
    nnoremap d "_d
    nnoremap D "_D
    nnoremap c "_c
    nnoremap C "_C
    nnoremap dd dd
    " nnoremap x "_x
    " nnoremap X "_dd
    
    " [n]+Enter: jump to a line number
    nnoremap <silent> <expr> <Enter> v:count ?
        \ ':<C-u>call cursor(v:count, 0)<CR>zz' : '<CR>'

    " ;e: reopen file
    nnoremap <silent> ;e :<C-u>edit!<CR>
    " Ctrl-Enter: save file
    nnoremap <silent> <C-Enter> :<C-u>write!<CR>
    " Shift-Enter: force save file
    nnoremap <silent> <S-Enter> :<C-u>update!<CR>
    " <L>+ev: open .vimrc in a new tab
    nnoremap <leader>ev :<C-u>tabnew $MYVIMRC<CR>

    " ;d: delete buffer
    nnoremap <silent> ;d :<C-u>bdelete!<CR>
    " ;b: next buffer
    nnoremap <silent> ;b :<C-u>bnext<CR>
    " ;B: previous buffer
    nnoremap <silent> ;B :<C-u>bprev<CR>

    " ;n: create tab
    nnoremap <silent> ;n :<C-u>tabnew<CR>
    " ;q: close tab
    nnoremap <silent> ;q :<C-u>quit!<CR>
    " ;t: next tab
    nnoremap <silent> ;t :<C-u>tabnext<CR>
    " ;T: previous tab
    nnoremap <silent> ;T :<C-u>tabprev<CR>
    " [n]+;t: jump to a tab number
    nnoremap <expr> ;t v:count ? 
        \ ':<C-u>tabnext'. v:count .'<CR>' : 'gt'

    " ;w: next window
    nnoremap ;w <C-w>w
    " ;W: previous window
    nnoremap ;W <C-w>W
    " ;h: split window horizontaly
    nnoremap <silent> ;h :<C-u>split<CR>
    " ;v: split window verticaly
    nnoremap <silent> ;v :<C-u>vertical split<CR>

    " Alt-a: select all
    nnoremap <silent> <A-a> :<C-u>keepjumps normal ggVG<CR>

    " ;c: clear highlight after search
    nnoremap <silent> ;c :<C-u>nohl<CR>:let @/=""<CR>
    " Ctrl+c: old clear highlight after search
    nnoremap <silent> <C-c> :<C-u>nohl<CR>:let @/=""<CR>

    " gr: replace word under the cursor
    nnoremap gr :%s/<C-r><C-w>/<C-r><C-w>/g<left><left>
    " g.: smart replace word under the cursor
    nnoremap <silent> g. :let @/=escape(expand('<cword>'),'$*[]/')<CR>cgn
    " gl: select last changed text
    nnoremap gl `[v`]
    " gp: select last paste in visual mode
    nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
    " gv: last selected text operator
    onoremap gv :<C-u>normal! gv<CR>

    " Unbinds
    map <F1> <Nop>
    map <S-k> <Nop>
    map ZZ <Nop>
    map ZQ <Nop>

" Insert mode
"---------------------------------------------------------------------------
    " Alt-[jkhl]: standart move
    imap <A-j> <C-o>gj
    imap <A-h> <C-o>h
    imap <A-k> <C-o>gk
    imap <A-l> <C-o>l
    " jj: fast Esc
    inoremap jj <Esc>`^
    " Ctrl-a: jump to head
    inoremap <C-a> <C-o>I
    " Ctrl-e: jump to end
    inoremap <C-e> <C-o>A
    " Ctrl-b: jump back to beginning of previous wordmp to first char
    inoremap <C-q> <Home>
    " Ctrl-BS: delete word
    inoremap <C-d> <BS>
    " Ctrl-d: delete next char
    inoremap <C-f> <Del>
    " Ctrl-d: deleting till start of line
    " inoremap <C-d> <C-g>u<C-u>
    " Ctrl-Enter: break line below
    inoremap <C-CR> <Esc>O
    " Shift-Enter: break line above
    inoremap <S-CR> <C-m>
    " Ctrl-l: fast Esc
    inoremap <C-l> <Esc>`^
    " Alt-e: fast Esc
    inoremap <A-e> <Esc>`^
    " Ctrl-c: old fast Esc
    inoremap <C-c> <Esc>`^
    " Ctrl-_: undo
    inoremap <C-_> <C-o>u
    " Ctrl-p: paste
    imap <C-p> <S-Insert>
    " Alt+w: force save file
    inoremap <silent> <A-w> <Esc> :write!<CR>i
    inoremap <silent> <C-s> <Esc> :write!<CR>i
    inoremap <silent> <C-w> <Esc> :write!<CR>i
    " Alt-r: change language
    inoremap <A-q> <C-^>
    " qq: smart fast Esc
    imap <expr> q getline('.')[col('.')-2] ==# 'q' ? "\<BS>\<Esc>`^" : 'q'

" Visual mode
"---------------------------------------------------------------------------
    " jk: don't skip wrap lines
    vnoremap <expr> j mode() ==# 'V' ? 'j' : 'gj'
    vnoremap <expr> k mode() ==# 'V' ? 'k' : 'gk'
    " Alt-[jkhl]: move selected lines
    xnoremap <A-j> xp'[V']
    xnoremap <A-k> xkP'[V']
    xnoremap <A-h> <'[V']
    xnoremap <A-l> >'[V']
    " L: move to end of line
    xnoremap L $h
    " Q: auto indent text
    xnoremap Q ==<Esc>
    " Space: fast Esc
    snoremap <Space> <Esc>
    xnoremap <Space> <Esc>
    " Alt-w: fast save
    xmap <silent> <A-w> <Esc> :update<CR>
    " Ctrl-s: old fast save
    xmap <C-s> <Esc> :write!<CR>
    " Ctrl-[jk]: scroll up/down
    xnoremap <C-j> <C-d>
    xnoremap <C-k> <C-u>
    " .: repeat command for each line
    vnoremap . :normal .<CR>
    " @: repeat macro for each line
    vnoremap @ :normal @
    " [yY]: keep cursor position when yanking
    xnoremap <silent> <expr> y 'ygv'. mode()
    xnoremap <silent> <expr> Y 'Ygv'. mode()
    " Ctrl-c: copy
    xnoremap <C-c> y`]
    " Backspace: delete selected and go into insert mode
    xnoremap <BS> c
    " p: paste not replace the default register
    xnoremap p "_dP
    " [dDcC]: delete to black hole register
    xnoremap d "_d
    xnoremap D "_D
    xnoremap c "_c
    xnoremap C "_C
    " xnoremap x "_x
    " xnoremap X "_X

" Command mode
"---------------------------------------------------------------------------
    " Ctrl-h: previous char
    cnoremap <C-h> <Left>
    " Ctrl-l: next char
    cnoremap <C-l> <Right>
    " Ctrl-h: previous word
    cnoremap <A-h> <S-left>
    " Ctrl-h: next word
    cnoremap <A-l> <S-right>
    " Ctrl-j: previous history
    cnoremap <C-j> <Down>
    " Ctrl-k: next history
    cnoremap <C-k> <Up>
    " Ctrl-d: delete char
    cnoremap <C-d> <Del>
    " Ctrl-a: jump to head
    cnoremap <C-a> <Home>
    " Ctrl-e: jump to end
    cnoremap <C-e> <End>
    " Ctrl-v: open the command-line window
    cnoremap <C-v> <C-f>a
    " jj: smart fast Esc
    cnoremap <expr> j getcmdline()[getcmdpos()-2] ==# 'j' ? "\<C-c>" : 'j'
    " qq: smart fast Esc
    cnoremap <expr> q getcmdline()[getcmdpos()-2] ==# 'q' ? "\<C-c>" : 'q'
    " `: old fast Esc
    cnoremap <silent> ` <C-c>

" Experimental
"---------------------------------------------------------------------------
    " ;p: toggle paste  mode
    nnoremap <silent> ;p :<C-r>={
        \ '0': 'set paste',
        \ '1': 'set nopaste'}[&paste]<CR><CR>

    " [prefix]p: indent paste
    nnoremap <silent> [prefix]p o<Esc>pm``[=`]``^
    xnoremap <silent> [prefix]p s<Esc>pm``[=`]``^
    nnoremap <silent> [prefix]P U<Esc>Pm``[=`]``^
    xnoremap <silent> [prefix]P W<Esc>Pm``[=`]``^

    " [nN]: append blank line and space
    nnoremap <silent> <expr> n v:count ?
        \ ":\<C-u>for i in range(1, v:count1) \| call append(line('.'), '') \| endfor\<CR>" : 'i<Space><Esc>'
    nnoremap <silent> <expr> N v:count ?
        \ ":\<C-u>for i in range(1, v:count1) \| call append(line('.')-1, '') \| endfor\<CR>" : 'i<Space><Esc>`^'

    " [-=]: Input vertical serial number
    nnoremap <silent> <expr> - v:count ?
        \ ":\<C-u>for i in reverse(range(1, v:count)) \| call append(line('.'), i) \| endfor\<CR>" : '='
    nnoremap <silent> <expr> = v:count ?
        \ ":\<C-u>for i in range(1, v:count) \| call append(line('.'), i) \| endfor\<CR>" : '+'

    " zz: move to top/center/bottom
    nnoremap <expr> zz (winline() == (winheight(0)+1)/ 2) ?
      \ 'zt' : (winline() == 1) ? 'zb' : 'zz'

    " #: keep search pattern at the center of the screen
    nnoremap <silent># #zz

    " <L>+r: replace a word under cursor
    nnoremap <leader>r :%s/<C-R><C-w>/<C-r><C-w>/g<left><left>
    xnoremap re y:%s/<C-r>=substitute(@0, '/', '\\/', 'g')<CR>//gI<Left><Left><Left>

    nnoremap g* g*N
    nnoremap <Tab> %
