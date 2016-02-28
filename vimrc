" .vimrc / 2016 Feb.
" Author: Alex Masterov <alex.masterow@gmail.com>
" Source: https://github.com/AlexMasterov/vimfiles

" Environment
"---------------------------------------------------------------------------
  " Unification
  let $VIM = substitute($VIM, '[\\/]\+', '/', 'g')
  let $VIMRUNTIME = substitute($VIMRUNTIME, '[\\/]\+', '/', 'g')
  " Vimfiles
  let $VIMFILES = $VIM.'/vimfiles'
  let $VIMCACHE = $VIMFILES.'/cache'
  " Store
  set viminfo+=n$VIMFILES/viminfo

  let s:is_windows = has('win32') || has('win64')

  if &compatible
    set nocompatible  " be improved
  endif
  if s:is_windows
    set shellslash
  endif
  set noexrc          " avoid reading local (g)vimrc, exrc
  set modelines=0     " prevents security exploits

  " Initialize autogroup in MyVimrc
  augroup MyVimrc| exe 'autocmd!' |augroup END

  " Echo startup time on start
  if has('vim_starting') && has('reltime')
    " Shell: vim --startuptime filename -q; vim filename
    " vim --cmd 'profile start profile.txt' --cmd 'profile file $HOME/.vimrc' +q && vim profile.txt
    let s:startuptime = reltime()
    autocmd MyVimrc VimEnter * let s:startuptime = reltime(s:startuptime) | redraw
                    \| echomsg ' startuptime:'. reltimestr(s:startuptime)
  endif

" Functions
"---------------------------------------------------------------------------
  function! s:installDein(deinPath) abort
    if !executable('git')
      echom "Can\'t download Dein: Git not found." | return
    endif
    let deinUri = 'https://github.com/Shougo/dein.vim.git'
    call system(printf('git clone --depth 1 %s %s', deinUri, a:deinPath))
  endfunction

  function! s:makeDir(dir, ...) abort
    let dir = expand(a:dir, 1)
    if !isdirectory(dir)
      \ && (a:0 || input(printf('"%s" does not exist. Create? [yes/no]', dir)) =~? '^y\%[es]$')
      silent call mkdir(iconv(dir, &encoding, &termencoding), 'p')
    endif
  endfunction

  function! s:trimWhiteSpace() abort
    if &bin| return |endif
    let [winView, _s] = [winsaveview(), @/]
    silent! %s/\s\+$//ge
    call winrestview(winView)
    let @/=_s
  endfunction

" Commands
"---------------------------------------------------------------------------
  " Vimrc augroup sugar
  command! -nargs=* Autocmd   autocmd MyVimrc <args>
  command! -nargs=* AutocmdFT autocmd MyVimrc FileType <args>
  command! -bar -nargs=* Indent
    \ exe 'setl tabstop='.<q-args> 'softtabstop='.<q-args> 'shiftwidth='.<q-args>
  command! -nargs=* FontSize let &guifont = substitute(&guifont, '\d\+', '\=<args>', 'g')
  command! -nargs=* Mkdir call s:makeDir(<f-args>)
  " Strip trailing whitespace at the end of non-blank lines
  command! -bar -nargs=* -complete=file FixWhitespace f <args>|call s:trimWhiteSpace()
  " Rename current file name
  command! -nargs=1 -complete=file Rename f <args>| w |call delete(expand('#'))
  " Shows the syntax stack under the cursor
  command! -bar SS echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  " Golden ratio
  command! -bar -nargs=0 GoldenRatio exe 'vertical resize' &columns * 5 / 8

" Events
"---------------------------------------------------------------------------
  " Auto reload VimScript
  Autocmd BufWritePost,FileWritePost *.vim nested
    \ if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') |
    \ endif
  " Auto reload .vimrc
  Autocmd BufWritePost $MYVIMRC nested | source $MYVIMRC | redraw
  " Apply new set variables
  Autocmd VimEnter * if argc() == 0 && bufname('%') ==# ''| enew |endif
  " Remove quit command from history
  Autocmd VimEnter * call histdel(':', '^w\?q\%[all]!\?$')
  " Create directories if not exist
  Autocmd BufWritePre,FileWritePre * call s:makeDir('<afile>:p:h', v:cmdbang)
  " Don't auto insert a comment when using O/o for a newline (see also :help fo-table)
  AutocmdFT * Autocmd BufEnter,WinEnter <buffer> setl formatoptions-=ro
  " Toggle settings between modes
  Autocmd InsertEnter * setl list
  Autocmd InsertLeave * setl nolist
  Autocmd WinLeave * setl nornu
  Autocmd WinEnter * let [&l:nu, &l:rnu] = &l:nu ? [1, 1] : [&l:nu, &l:rnu]
  Autocmd Syntax * if 5000 < line('$')| syntax sync minlines=100 |endif
  " Save all buffers when focus lost, ignoring warnings, and return to normal mode
  " Autocmd FocusLost * nested wa
  " Autocmd FocusLost * if mode()[0] =~ 'i\|R'| call feedkeys("\<Esc>`^") |endif

" Encoding
"---------------------------------------------------------------------------
  set encoding=utf-8
  scriptencoding utf-8

  if s:is_windows && has('multi_byte')
    set fileencodings=utf-8,cp1251
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
  " Cache
  call s:makeDir($VIMCACHE, 1)
  set directory=$VIMFILES/tmp
  set noswapfile
  " Undo
  call s:makeDir($VIMFILES.'/undo', 1)
  set undodir=$VIMFILES/undo
  set undofile undolevels=500 undoreload=1000
  " View
  set viewdir=$VIMFILES/views
  set viewoptions=cursor,slash,unix

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
  let g:loaded_logipat = 1
  let g:loaded_rrhelper = 1
  let g:loaded_matchparen = 1
  let g:loaded_netrwPlugin = 1
  let g:loaded_2html_plugin = 1
  let g:loaded_vimballPlugin = 1
  let g:loaded_getscriptPlugin = 1
  let g:loaded_spellfile_plugin = 1
  let g:did_install_default_menus = 1

  " Install Dein plugin manager
  if has('vim_starting')
    let s:deinDirectory = $VIMFILES
      \ .'/dein/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:deinDirectory)
      call s:installDein(s:deinDirectory)
    endif
    exe 'set runtimepath='. s:deinDirectory .',$VIMFILES,$VIMRUNTIME'
  endif
  let g:dein#types#git#clone_depth = 1
  let g:dein#install_max_processes =
    \ exists('$NUMBER_OF_PROCESSORS') ? str2nr($NUMBER_OF_PROCESSORS) : 1

  call dein#begin($VIMFILES.'/dein')
  if dein#load_cache()
    call dein#add('Shougo/dein.vim', {'rtp': ''})
    call dein#add('Shougo/vimproc.vim', {
      \ 'lazy': 1,
      \ 'build': {
      \   'linux': 'make',
      \   'mac': 'make -f make_mac.mak',
      \   'windows': 'tools\\update-dll-mingw'
      \ }
      \})

    " Load develop version plugins
    call dein#local($VIMFILES.'/dev', {'frozen': 1},
      \ ['dotvim', 'gist'])
    call dein#local($VIMFILES.'/dev', {'frozen': 1,
      \ 'on_func': 'ternjs#Complete',
      \ 'on_cmd': ['TernjsRun', 'TernjsStop']},
      \ ['ternjs.vim'])

    call dein#add('kopischke/vim-stay', {
      \ 'on_path': '.*'
      \})
    call dein#add('dylanaraps/root.vim', {
      \ 'on_cmd': 'Root'
      \})
    call dein#add('tyru/caw.vim', {
      \ 'on_map': [['nv', '<Plug>(caw:']]
      \})
    call dein#add('easymotion/vim-easymotion', {
      \ 'on_cmd': 'EasyMotionWordsBeginningWithChar',
      \ 'on_map': [['nx', '<Plug>(easymotion-']]
      \})
    call dein#add('t9md/vim-choosewin', {
      \ 'on_map': [['n', '<Plug>(choosewin)']]
      \})
    call dein#add('mbbill/undotree', {
      \ 'on_cmd': 'UndotreeToggle'
      \})
    call dein#add('Shougo/vimfiler.vim', {
      \ 'on_cmd': ['VimFiler', 'VimFilerCurrentDir']
      \})
    call dein#add('osyo-manga/vim-over', {
     \ 'on_cmd': 'OverCommandLine'
     \})
    call dein#add('cohama/agit.vim', {
     \ 'on_cmd': ['Agit', 'AgitFile']
     \})
    call dein#add('lambdalisue/vim-gita', {
     \ 'on_cmd': 'Gita'
     \})
    call dein#add('tpope/vim-characterize', {
      \ 'on_map': [['nx', '<Plug>(characterize)']]
      \})
    call dein#add('kshenoy/vim-signature', {
      \ 'on_path': '.*',
      \ 'on_func': 'signature#',
      \ 'on_cmd': 'SignatureRefresh'
      \})
    call dein#add('tpope/vim-repeat', {
      \ 'on_func': 'repeat#',
      \ 'on_map': [['nv', '.'], ['nv', '<Plug>(Repeat']]
      \})
    call dein#add('SirVer/ultisnips', {
      \ 'lazy': 1
      \})
    call dein#add('Shougo/context_filetype.vim', {
      \ 'lazy': 1
      \})
    call dein#add('Shougo/neocomplete.vim', {
      \ 'depends': 'context_filetype.vim',
      \ 'on_i': 1
      \})
    call dein#add('Shougo/neoinclude.vim', {
      \ 'on_source': 'neocomplete.vim'
      \})
    call dein#add('Shougo/neopairs.vim', {
      \ 'on_source': 'neocomplete.vim'
      \})
    call dein#add('Shougo/neco-syntax', {
      \ 'on_source': 'neocomplete.vim'
      \})
    call dein#add('Shougo/neoyank.vim', {
      \ 'on_source': 'unite.vim'
      \})
    " call dein#add('kana/vim-altr', {
    "   \ 'on_func': 'altr#define',
    "   \ 'on_map': '<Plug>(altr-'
    "   \})
    call dein#add('haya14busa/incsearch.vim', {
      \ 'on_func': 'incsearch#go'
      \})
    call dein#add('haya14busa/incsearch-easymotion.vim', {
      \ 'depends': 'incsearch.vim',
      \ 'on_source': 'vim-easymotion'
      \})
    call dein#add('cohama/lexima.vim', {
      \ 'on_i': 1
      \})
    call dein#add('tpope/vim-surround', {
      \ 'on_map': [['n', '<Plug>D'], ['n', '<Plug>C'], ['n', '<Plug>Y'], ['x', '<Plug>V']]
      \})
    call dein#add('gcmt/wildfire.vim', {
      \ 'on_map': '<Plug>(wildfire-'
      \})

    call dein#add('osyo-manga/vim-brightest', {
      \ 'on_cmd': 'Brightest'
      \})
    call dein#add('lilydjwg/colorizer', {
      \ 'on_cmd': ['ColorToggle', 'ColorHighlight', 'ColorClear']
      \})
    call dein#add('tpope/vim-projectionist', {
      \ 'on_func': 'ProjectionistDetect'
      \})
    call dein#add('osyo-manga/vim-reanimate', {
      \ 'on_source': 'unite.vim',
      \ 'on_cmd': 'ReanimateSaveInput'
      \})
    call dein#add('kana/vim-smartword', {
      \ 'on_map': [['nx', '<Plug>(smartword-']]
      \})
    call dein#add('osyo-manga/vim-jplus', {
      \ 'on_map': [['nv', '<Plug>(jplus']]
      \})
    call dein#add('AndrewRadev/splitjoin.vim', {
      \ 'on_cmd': 'SplitjoinSplit'
      \})
    call dein#add('jakobwesthoff/argumentrewrap', {
      \ 'on_func': 'argumentrewrap#RewrapArguments'
      \})
    call dein#add('AndrewRadev/switch.vim', {
      \ 'on_func': 'switch#Switch',
      \ 'on_cmd': 'Switch'
      \})
    call dein#add('kana/vim-smartchr', {
      \ 'on_func': 'smartchr#loop'
      \})
    call dein#add('junegunn/vim-easy-align', {
      \ 'on_map': [['nx', '<Plug>(EasyAlign)']]
      \})
    call dein#add('AndrewRadev/sideways.vim', {
      \ 'on_cmd': 'Sideways'
      \})
    call dein#add('triglav/vim-visual-increment', {
      \ 'on_map': [['x', '<Plug>Visual']]
      \})
    call dein#add('whatyouhide/vim-lengthmatters', {
      \ 'on_cmd': 'Lengthmatters'
      \})

    call dein#add('thinca/vim-quickrun', {
      \ 'depends': 'vimproc.vim',
      \ 'on_func': 'quickrun#',
      \ 'on_cmd': 'QuickRun',
      \ 'on_map': [['n', '<Plug>(quickrun)']]
      \})
    " vim-quickrun bundles
    call dein#local($VIMFILES.'/dev', {'frozen': 1,
      \ 'on_source': 'vim-quickrun'
      \}, ['quickrun'])

    " Unite
    call dein#add('Shougo/unite.vim', {
      \ 'lazy': 1,
      \ 'pre_cmd': 'Unite'
      \})
    call dein#add('Shougo/neomru.vim', {
      \ 'on_source': 'unite.vim',
      \ 'on_path': '.*',
      \ 'on_cmd': ['NeoMRUSave', 'NeoMRUReload']
      \})
    call dein#add('thinca/vim-qfreplace', {
      \ 'on_source': 'unite.vim'
      \})
    call dein#add('Shougo/unite-outline', {
      \ 'on_source': 'unite.vim'
      \})
    call dein#add('chemzqm/unite-location', {
      \ 'on_source': 'unite.vim'
      \})
    call dein#add('osyo-manga/unite-filetype', {
      \ 'on_source': 'unite.vim'
      \})
    call dein#add('tsukkee/unite-tag', {
      \ 'on_source': 'unite.vim'
      \})
    call dein#add('mattn/httpstatus-vim', {
      \ 'on_source': 'unite.vim'
      \})
    call dein#add('osyo-manga/unite-vimpatches', {
      \ 'on_source': 'unite.vim'
      \})
    call dein#add('Shougo/junkfile.vim', {
      \ 'on_source': 'unite.vim',
      \ 'on_cmd': 'JunkfileOpen'
      \})

    " Text objects
    call dein#add('tommcdo/vim-exchange', {
      \ 'on_map': [['nv', '<Plug>(Exchange']]
      \})
    call dein#add('kana/vim-textobj-user', {
      \ 'lazy': 1
      \})
    call dein#add('machakann/vim-textobj-delimited', {
      \ 'depends': 'vim-textobj-user',
      \ 'on_map': ['vid', 'viD', 'vad', 'vaD']
      \})
    call dein#add('whatyouhide/vim-textobj-xmlattr', {
      \ 'depends': 'vim-textobj-user',
      \ 'on_map': ['vix', 'vax']
      \})

    " Operators
    call dein#add('kana/vim-operator-user', {
      \ 'lazy': 1
      \})
    call dein#add('kana/vim-operator-replace', {
      \ 'depends': 'vim-operator-user',
      \ 'on_map': [['nx', '<Plug>(operator-replace)']]
      \})
    call dein#add('rhysd/vim-operator-surround', {
      \ 'depends': 'vim-operator-user',
      \ 'on_map': [['v', '<Plug>(operator-surround-']]
      \})
    call dein#add('tyru/operator-reverse.vim', {
      \ 'depends': 'vim-operator-user',
      \ 'on_map': [['v', '<Plug>(operator-reverse-']]
      \})
    call dein#add('kusabashira/vim-operator-eval', {
      \ 'depends': 'vim-operator-user',
      \ 'on_map': [['v', '<Plug>(operator-eval-']]
      \})
    call dein#add('haya14busa/vim-operator-flashy', {
      \ 'depends': 'vim-operator-user',
      \ 'on_map': [['n', '<Plug>(operator-flashy)']]
      \})

    " Haskell
    call dein#add('itchyny/vim-haskell-indent', {
      \ 'on_ft': 'haskell'
      \})
    call dein#add('enomsg/vim-haskellConcealPlus', {
      \ 'on_ft': 'haskell'
      \})
    call dein#add('Twinside/vim-syntax-haskell-cabal', {
      \ 'on_path': '\.cabal$'
      \})
    call dein#add('eagletmt/ghcmod-vim', {
      \ 'on_cmd': ['GhcModCheck', 'GhcModLint', 'GhcModCheckAndLintAsync']
      \})
    call dein#add('eagletmt/neco-ghc', {
      \ 'on_func': 'necoghc#omnifunc'
      \})

    " PHP
    call dein#add('2072/PHP-Indenting-for-VIm', {
      \ 'on_ft': 'php'
      \})
    call dein#add('shawncplus/phpcomplete.vim', {
      \ 'on_func': 'phpcomplete#CompletePHP'
      \})
    call dein#add('tobyS/vmustache', {
      \ 'on_source': 'pdv'
      \})
    call dein#add('tobyS/pdv', {
      \ 'on_func': 'pdv#'
      \})
    " call dein#add('joonty/vdebug', {
    "   \ 'on_ft': 'php'
    "   \})
    call dein#add('jwalton512/vim-blade', {
      \ 'on_path': '\.blade.php$'
      \})

    " JavaScript
    call dein#add('othree/yajs.vim', {
      \ 'on_ft': 'javascript'
      \})
    call dein#add('othree/es.next.syntax.vim', {
      \ 'on_ft': 'javascript'
      \})
    call dein#add('gavocanov/vim-js-indent', {
      \ 'on_ft': 'javascript'
      \})
    call dein#add('heavenshell/vim-jsdoc', {
      \ 'on_map': [['n', '<Plug>(jsdoc)']]
      \})

    " HTML
    call dein#add('gregsexton/MatchTag', {
      \ 'on_ft': ['html', 'xml', 'twig', 'blade']
      \})
    call dein#add('othree/html5.vim', {
      \ 'on_ft': ['html', 'twig']
      \})
    call dein#add('alvan/vim-closetag', {
      \ 'lazy': 1
      \})
    call dein#add('mattn/emmet-vim', {
      \ 'on_map': [['i', '<Plug>(emmet-']]
      \})

    " CSS
    call dein#add('JulesWang/css.vim', {
      \ 'on_ft': 'css'
      \})
    call dein#add('hail2u/vim-css3-syntax', {
      \ 'on_ft': 'css'
      \})
    call dein#add('othree/csscomplete.vim', {
      \ 'on_func': 'csscomplete#CompleteCSS'
      \})
    call dein#add('rstacruz/vim-hyperstyle', {
      \ 'frozen': 1,
      \ 'on_map': [['i', '<Plug>(hyperstyle']]
      \})

    " Twig
    call dein#local($VIMFILES.'/dev', {'frozen': 1,
      \ 'on_path': ['\.twig$', '\.html.twig$'],
      \ 'on_ft': 'twig'
      \}, ['twig.vim'])
    call dein#add('tokutake/twig-indent', {
      \ 'on_path': ['\.twig$', '\.html.twig$'],
      \ 'on_ft': 'twig'
      \})

    " SVG
    call dein#add('aur-archive/vim-svg', {
      \ 'on_path': '\.svg$',
      \ 'on_ft': 'svg'
      \})
    call dein#add('jasonshell/vim-svg-indent', {
      \ 'on_path': '\.svg$',
      \ 'on_ft': 'svg'
      \})

    " JSON
    call dein#add('elzr/vim-json', {
      \ 'on_ft': 'json'
      \})

    " SQL
    call dein#add('shmup/vim-sql-syntax', {
      \ 'on_path': '\.sql$',
      \ 'on_ft': 'php',
      \})

    " Postgres
    call dein#add('exu/pgsql.vim', {
      \ 'on_path': '\.pgsql$'
      \})

    " Nginx
    call dein#add('yaroot/vim-nginx', {
      \ 'on_ft': 'nginx'
      \})

    " CSV
    call dein#add('chrisbra/csv.vim', {
      \ 'on_path': '\.csv$'
      \})

    " Docker
    call dein#add('ekalinin/Dockerfile.vim', {
      \ 'on_path': 'Dockerfile$'
      \})
    call dein#save_cache()
  endif
  call dein#end()

  filetype plugin indent on
  if !exists('g:syntax_on')| syntax on |endif

" Bundle settings
"---------------------------------------------------------------------------
  if dein#tap('dein.vim')
    nnoremap <silent> ;u :<C-u>call dein#update()<CR>
  endif

  " if dein#tap('hiddenBuffersLimit.vim')
    let g:bufcleaner_max_saved = 9
    Autocmd BufHidden * CleanBuffers -f

  "   Autocmd User dein#source#hiddenBuffersLimit.vim
  "     \ let g:bufcleaner_max_saved = 9
  " endif

  if dein#tap('caw.vim')
    nmap <silent> <expr> q <SID>cawRangeComment()
    xmap <silent> <expr> q <SID>cawRangeComment()
    nmap ,q <Plug>(caw:jump:comment-prev)
    nmap ,w <Plug>(caw:jump:comment-next)
    nmap ,a <Plug>(caw:a:toggle)

    function! s:cawRangeComment() abort
      if v:count > 1
        let [line, pos] = [getcurpos()[1], getcurpos()[4]]
        return printf(
          \ "\<Esc>V%dj\<Plug>(caw:i:toggle):call cursor(%d, %d)\<CR>",
          \ (v:count-1), line, pos
          \)
      endif
      return "\<Plug>(caw:i:toggle)"
    endfunction

    Autocmd User dein#source#caw.vim
      \  let g:caw_no_default_keymappings = 1
      \| let g:caw_i_skip_blank_line = 1
  endif

  if dein#tap('vim-easymotion')
    nmap  s <Plug>(easymotion-s)
    nmap ,w <Plug>(easymotion-overwin-w)
    nmap ,k <Plug>(easymotion-overwin-f)
    nmap ,K <Plug>(easymotion-overwin-f2)
    nmap ,l <Plug>(easymotion-overwin-line)
    nmap W  <Plug>(easymotion-lineforward)
    nmap B  <Plug>(easymotion-linebackward)

    map <expr> f getcurpos()[4] < col('$')-1 ? "\<Plug>(easymotion-fl)" : "\<Plug>(easymotion-Fl)"
    map <expr> F getcurpos()[4] <= 1         ? "\<Plug>(easymotion-fl)" : "\<Plug>(easymotion-Fl)"

    function! s:easymotionOnSource() abort
      let g:EasyMotion_verbose = 0
      let g:EasyMotion_do_mapping = 0
      let g:EasyMotion_show_prompt = 0
      let g:EasyMotion_startofline = 0
      let g:EasyMotion_space_jump_first = 1
      let g:EasyMotion_enter_jump_first = 1

      hi BookmarkLine guifg=#2B2B2B guibg=#F9EDDF gui=NONE
      hi EasyMotionTarget       guifg=#2B2B2B guibg=#F6F7F7 gui=bold
      hi EasyMotionTarget2First guifg=#FF0000 guibg=#F6F7F7 gui=bold
      hi link EasyMotionShade         Comment
      hi link EasyMotionMoveHL        Search
      hi link EasyMotionIncCursor     Cursor
      hi link EasyMotionTarget2Second EasyMotionTarget
    endfunction

    Autocmd User dein#source#vim-easymotion call s:easymotionOnSource()
  endif

  if dein#tap('context_filetype.vim')
    function! s:context_filetypeOnSource() abort
      let g:context_filetype#search_offset = 500

      function! s:addContext(filetype, rule) abort
        let context_ft_def = get(context_filetype#default_filetypes(), a:filetype, [])
        let g:context_filetype#filetypes[a:filetype] = add(context_ft_def, a:rule)
      endfunction

      " CSS
      let s:context_ft_css = {
        \ 'start':    '<script\%( [^>]*\)\?>',
        \ 'end':      '</style>',
        \ 'filetype': 'css'
        \}
      for filetype in split('html twig')
        call s:addContext(filetype, s:context_ft_css)
      endfor | unlet filetype
    endfunction

    Autocmd User dein#source#context_filetype.vim call s:context_filetypeOnSource()
  endif

  if dein#tap('neocomplete.vim') && has('lua')
    inoremap <silent> <Tab> <C-r>=<SID>neoComplete("\<Tab>")<CR>
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-x>\<C-o>"
    " Ctrl-d: select the previous match OR delete till start of line
    inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-g>u<C-u>"
    " Ctrl-k: select the next match OR delete to end of line
    inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : col('.') == col('$') ? "\<C-k>" : "\<C-o>D"

    function! s:neoComplete(key) abort
      if pumvisible()
        return "\<C-n>"
      endif
      let [curPos, lineLength] = [getcurpos()[4], col('$')]
      let isText = curPos <= lineLength
      let isStartLine = curPos <= 1
      let isBackspace = getline('.')[curPos-2] =~ '\s'
      if isText && !isStartLine && !isBackspace
        return neocomplete#helper#get_force_omni_complete_pos(neocomplete#get_cur_text(1)) >= 0
          \ ? "\<C-x>\<C-o>\<C-r>=neocomplete#mappings#popup_post()\<CR>"
          \ : neocomplete#start_manual_complete()
      endif
      return a:key
    endfunction

    function! s:neocompleteOnSource() abort
      let g:neocomplete#enable_at_startup = 1
      let g:neocomplete#enable_smart_case = 1
      let g:neocomplete#enable_camel_case = 1
      let g:neocomplete#enable_auto_delimiter = 1
      let g:neocomplete#auto_completion_start_length = 2
      let g:neocomplete#manual_completion_start_length = 2
      let g:neocomplete#min_keyword_length = 2
      let g:neocomplete#data_directory = $VIMCACHE.'/neocomplete'

      " Custom settings
      call neocomplete#custom#source('tag', 'rank', 60)
      call neocomplete#custom#source('omni', 'rank', 80)
      call neocomplete#custom#source('ultisnips', 'rank', 100)
      call neocomplete#custom#source('ultisnips', 'min_pattern_length', 1)
      call neocomplete#custom#source('_', 'converters',
        \ ['converter_add_paren', 'converter_remove_overlap', 'converter_delimiter', 'converter_abbr']
        \)

      " Sources
      let g:neocomplete#sources = {
        \ '_':          ['buffer', 'file/include'],
        \ 'javascript': ['omni', 'file/include', 'ultisnips', 'tag'],
        \ 'haskell':    ['omni', 'file/include', 'ultisnips', 'tag'],
        \ 'php':        ['omni', 'file/include', 'ultisnips', 'tag'],
        \ 'css':        ['omni', 'file/include', 'ultisnips'],
        \ 'html':       ['omni', 'file/include', 'ultisnips'],
        \ 'twig':       ['omni', 'file/include', 'ultisnips']
        \}

      " Completion patterns
      let g:neocomplete#sources#omni#input_patterns = {
        \ 'haskell':    '\h\w*\|\(import\|from\)\s',
        \ 'sql':        '\h\w*\|[^.[:digit:] *\t]\%(\.\)\%(\h\w*\)\?',
        \ 'javascript': '\h\w*\|\h\w*\.\%(\h\w*\)\?\|[^. \t]\.\%(\h\w*\)\?\|\(import\|from\)\s',
        \ 'php':        '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?\|\(new\|use\|extends\|implements\|instanceof\)\%(\s\|\s\\\)',
        \}
      call neocomplete#util#set_default_dictionary('g:neocomplete#sources#omni#input_patterns',
        \ 'html,twig', '<\|\s[[:alnum:]-]*')
      call neocomplete#util#set_default_dictionary('g:neocomplete#sources#omni#input_patterns',
        \ 'css,scss,sass', '\w\+\|\w\+[):;]\?\s\+\w*\|[@!]')
    endfunction

    Autocmd User dein#source#neocomplete.vim call s:neocompleteOnSource()
  endif

  if dein#tap('root.vim')
    Autocmd BufNewFile,BufRead * Root

    function! s:rootOnSource() abort
      let g:root#auto = 0
      let g:root#echo = 0
      let g:root#disable_autochdir = 0
      let g:root#patterns = [
        \  '.git', '.git/', '.hg', '.hg/',
        \  'composer.json',
        \  'package.json',
        \  '.tern-project'
        \]
    endfunction

    Autocmd User dein#source#root.vim call s:rootOnSource()
  endif

  if dein#tap('undotree')
    nnoremap <silent> ,u :<C-u>call <SID>undotreeMyToggle()<CR>

    AutocmdFT diff,undotree setl nonu nornu colorcolumn=

    function! s:undotreeMyToggle() abort
      if &l:filetype != 'php'
        let s:undotree_last_ft = &l:filetype
        AutocmdFT diff Autocmd BufEnter,WinEnter <buffer>
          \ let &l:syntax = s:undotree_last_ft
      endif
      UndotreeToggle
    endfunction

    function! s:undotreeOnSource() abort
      function! g:Undotree_CustomMap() abort
        nmap <buffer> o <Enter>
        nmap <buffer> u <Plug>UndotreeUndo
        nmap <buffer> r <Plug>UndotreeRedo
        nmap <buffer> h <Plug>UndotreeGoNextState
        nmap <buffer> l <Plug>UndotreeGoPreviousState
        nmap <buffer> d <Plug>UndotreeDiffToggle
        nmap <buffer> t <Plug>UndotreeTimestampToggle
        nmap <buffer> C <Plug>UndotreeClearHistory
      endfunction

      let g:undotree_WindowLayout = 4
      let g:undotree_SplitWidth = 36
      let g:undotree_SetFocusWhenToggle = 1

      AutocmdFT diff Autocmd BufEnter,WinEnter <buffer>
        \  nnoremap <silent> <buffer> q :<C-u>UndotreeHide<CR>
        \| nnoremap <silent> <buffer> ` :<C-u>UndotreeHide<CR>
    endfunction

    Autocmd User dein#source#undotree call s:undotreeOnSource()
  endif

  if dein#tap('vim-lengthmatters')
    AutocmdFT php,javascript,haskell LengthmattersEnable

    function! s:vimLengthmattersOnSource() abort
      let g:lengthmatters_on_by_default = 0
      let g:lengthmatters_excluded = split(
        \ 'vim help unite vimfiler undotree qfreplace'
        \)
      call lengthmatters#highlight_link_to('ColorColumn')
    endfunction

    Autocmd User dein#source#vim-lengthmatters call s:vimLengthmattersOnSource()
  endif

  if dein#tap('vim-signature')
    let s:signature_ignore_ft = 'unite qfreplace vimfiler'
    Autocmd BufNewFile,BufRead *
      \ if index(split(s:signature_ignore_ft), &filetype) == -1| call s:signatureMappings() |endif

    function! s:signatureMappings() abort
      nnoremap <silent> <buffer> <BS>
        \ :<C-u>call signature#mark#Toggle('next')<CR>:call signature#sign#ToggleDummy()<CR>
      nnoremap <silent> <buffer> <S-BS>
        \ :<C-u>call signature#mark#ToggleAtLine()<CR>:call signature#sign#ToggleDummy()<CR>
      nnoremap <silent> <buffer> \ :<C-u>call signature#utils#Input()<CR>
      nnoremap <silent> <buffer> <Del>   :<C-u>call signature#mark#Purge('line')<CR>
      nnoremap <silent> <buffer> <S-Del> :<C-u>call signature#mark#Purge('all')<CR>
      nnoremap <silent> <buffer> <C-Del> :<C-u>call signature#marker#Purge()<CR>
      " jump to spot alpha
      nnoremap <silent> <buffer> [ :<C-u>silent! call signature#mark#Goto('next', 'spot', 'alpha')<CR>zz
      nnoremap <silent> <buffer> ] :<C-u>silent! call signature#mark#Goto('prev', 'spot', 'alpha')<CR>zz
      " jump to any marker
      nnoremap <silent> <buffer> <S-[> :<C-u>silent! call signature#marker#Goto('next', 'any',  v:count)<CR>zz
      nnoremap <silent> <buffer> <S-]> :<C-u>silent! call signature#marker#Goto('prev', 'any',  v:count)<CR>zz

      Autocmd BufEnter,WinEnter <buffer> call s:signatureCleanUp()
      function! s:signatureCleanUp() abort
        for char in split('[] ][ [[ ]] [" ]"')
          exe 'silent! nunmap <buffer> '. char
        endfor
      endfunction
    endfunction

    function! s:vimSignatureOnSource() abort
      let g:SignatureMarkTextHL = "'BookmarkLine'"
      let g:SignatureIncludeMarks = 'weratsdfqglcvbzxyi'
      let g:SignaturePeriodicRefresh = 0
      let g:SignatureErrorIfNoAvailableMarks = 0

      Autocmd Syntax,ColorScheme *
        \ hi BookmarkLine guifg=#2B2B2B guibg=#F9EDDF gui=NONE
    endfunction

    function! s:vimSignatureOnPostSource() abort
      au! sig_autocmds CursorHold
      call signature#utils#Maps('remove')
    endfunction

    Autocmd User dein#source#vim-signature call s:vimSignatureOnSource()
    Autocmd User dein#post_source#vim-signature call s:vimSignatureOnPostSource()
  endif

  if dein#tap('vim-over')
    nnoremap <silent> ;/ ms:<C-u>OverCommandLine<CR>%s/
    xnoremap <silent> ;/ ms:<C-u>OverCommandLine<CR>%s/\%V

    function! s:vimOverOnSource() abort
      let g:over_command_line_key_mappings = {
        \ "\<C-c>": "\<Esc>",
        \ "\<C-j>": "\<CR>"
        \}
      let g:over#command_line#paste_escape_chars = '\\/.*$^~'
    endfunction

    Autocmd User dein#source#vim-over call s:vimOverOnSource()
  endif

  if dein#tap('vimfiler.vim')
    " ;[dD]: open vimfiler explrer
    nnoremap <silent> ;d
      \ :<C-u>VimFiler -split -invisible -create -no-quit<CR>
    " Shift-Tab: jump to vimfiler window
    nnoremap <silent> <Tab> :<C-u>call <SID>jumpToVimfiler()<CR>

    function! s:jumpToVimfiler() abort
      if getwinvar(winnr(), '&filetype') ==# 'vimfiler'
        wincmd p
      else
        for winnr in filter(range(1, winnr('$')), "getwinvar(v:val, '&filetype') ==# 'vimfiler'")
          exe winnr . 'wincmd w'
        endfor
      endif
    endfunction

    AutocmdFT vimfiler call s:vimfilerMappings()
    " Vimfiler tuning
    AutocmdFT vimfiler let &l:statusline = ' '
    Autocmd BufEnter,WinEnter vimfiler*
      \ setl nonu nornu nolist cursorline colorcolumn=
    Autocmd BufLeave,WinLeave vimfiler* setl nocursorline

    function! s:vimfilerMappings() abort
      nunmap <buffer> <Space>
      nunmap <buffer> <Tab>
      " Normal mode
      nmap <buffer> <C-j> 4j
      nmap <buffer> <C-k> 4k
      nmap <buffer> <C-c> <Esc>
      nmap <buffer> f <Plug>(vimfiler_grep)
      nmap <buffer> H <Plug>(vimfiler_cursor_top)
      nmap <buffer> R <Plug>(vimfiler_redraw_screen)
      nmap <buffer> l <Plug>(vimfiler_expand_tree)
      nmap <buffer> L <Plug>(vimfiler_cd_file)
      nmap <buffer> J <Plug>(vimfiler_switch_to_root_directory)
      nmap <buffer> K <Plug>(vimfiler_switch_to_project_directory)
      nmap <buffer> H <Plug>(vimfiler_switch_to_parent_directory)
      nmap <buffer> o <Plug>(vimfiler_expand_or_edit)
      nmap <buffer> O <Plug>(vimfiler_open_file_in_another_vimfiler)
      nmap <buffer> w <Plug>(vimfiler_expand_tree_recursive)
      nmap <buffer> W <Plug>(vimfiler_toggle_visible_ignore_files)
      nmap <buffer> e <Plug>(vimfiler_toggle_mark_current_line)
      nmap <buffer> E <Plug>(vimfiler_toggle_mark_current_line_up)
      nmap <buffer> <expr> q winnr('$') == 1 ? "\<Plug>(vimfiler_hide)" : "\<Plug>(vimfiler_switch_to_other_window)"
      nmap <buffer> <expr> <Enter> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
      nmap <buffer> <nowait> <expr> t vimfiler#do_action('tabopen')
      nmap <buffer> <nowait> <expr> s vimfiler#do_switch_action('split')
      nmap <buffer> <nowait> <expr> S vimfiler#do_switch_action('vsplit')
      nmap <buffer> <nowait> <expr> v vimfiler#do_switch_action('vsplit')
      nmap <buffer> <nowait> n <Plug>(vimfiler_new_file)
      nmap <buffer> <nowait> N <Plug>(vimfiler_make_directory)
      nmap <buffer> <nowait> d <Plug>(vimfiler_mark_current_line)<Plug>(vimfiler_delete_file)y
      nmap <buffer> <nowait> D <Plug>(vimfiler_mark_current_line)<Plug>(vimfiler_force_delete_file)
      nmap <buffer> <nowait> c <Plug>(vimfiler_mark_current_line)<Plug>(vimfiler_copy_file)
      nmap <buffer> <nowait> m <Plug>(vimfiler_mark_current_line)<Plug>(vimfiler_move_file)y
    endfunction

    function! s:vimfilerOnSource() abort
      let g:vimfiler_data_directory = $VIMCACHE.'/vimfiler'
      let g:unite_kind_file_use_trashbox = s:is_windows

      let g:vimfiler_ignore_pattern =
        \ '^\%(\..*\|^.\|.git\|.hg\|bin\|var\|etc\|build\|vendor\|node_modules\)$'

      " Icons
      let g:vimfiler_file_icon = ' '
      let g:vimfiler_tree_leaf_icon = ''
      let g:vimfiler_tree_opened_icon = '▾'
      let g:vimfiler_tree_closed_icon = '▸'
      let g:vimfiler_marked_file_icon = '+'

      " Default profile
      let s:vimfiler_default = {
        \ 'safe': 0,
        \ 'parent': 0,
        \ 'explorer': 1,
        \ 'winwidth': 26,
        \ 'winminwidth': 16
        \}
      call vimfiler#custom#profile('default', 'context', s:vimfiler_default)
    endfunction

    Autocmd User dein#source#vimfiler.vim call s:vimfilerOnSource()
  endif

  if dein#tap('vim-choosewin')
    nmap - <Plug>(choosewin)

    AutocmdFT vimfiler nmap <buffer> - <Plug>(choosewin)

    function! s:vimChoosewinOnSource() abort
      let g:choosewin_keymap = {
        \ '0': 'win_land', 'q': 'tab_close', "\<Space>": 'previous',
        \ 'h': 'tab_prev', 'l': 'tab_next', 'j': 'tab_prev', 'k': 'tab_next'
        \}
      let g:choosewin_label = 'WERABC'
      let g:choosewin_label_align = 'left'
      let g:choosewin_blink_on_land = 0
      let g:choosewin_overlay_enable = 2
      let g:choosewin_color_land = {'gui': ['#0000FF', '#F6F7F7', 'NONE']}
      let g:choosewin_color_label = {'gui': ['#FFE1CC', '#2B2B2B', 'bold']}
      let g:choosewin_color_label_current = {'gui': ['#CCE5FF', '#2B2B2B', 'bold']}
      let g:choosewin_color_other = {'gui': ['#F6F7F7', '#EEEEEE', 'NONE']}
      let g:choosewin_color_shade = {'gui': ['#F6F7F7', '#EEEEEE', 'NONE']}
      let g:choosewin_color_overlay = {'gui': ['#2B2B2B', '#2B2B2B', 'bold']}
      let g:choosewin_color_overlay_current = {'gui': ['#CCE5FF', '#CCE5FF', 'bold']}
    endfunction

    Autocmd User dein#source#vim-choosewin call s:vimChoosewinOnSource()
  endif

  if dein#tap('vim-quickrun')
    nmap ;q <Plug>(quickrun)
    nnoremap <expr> <silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

    AutocmdFT php
      \  nnoremap <silent> <buffer> ,b :<C-u>call <SID>quickrunType('csfixer')<CR>
      \| nnoremap <silent> <buffer> ,t :<C-u>call <SID>quickrunType('phpunit')<CR>

    AutocmdFT javascript,html,twig,css,json
      \ nnoremap <silent> <buffer> ,b :<C-u>call <SID>quickrunType('formatter')<CR>

    AutocmdFT javascript
      \ nnoremap <silent> <buffer> ,t :<C-u>call <SID>quickrunType('nodejs')<CR>
      \| nnoremap <silent> <buffer> ,c :<C-u>call <SID>quickrunType('lint')<CR>

    Autocmd BufEnter,WinEnter runner:*
      \ let &l:statusline = ' ' | setl nonu nornu nolist colorcolumn=

    function! s:quickrunType(type) abort
      let g:quickrun_config = get(g:, 'quickrun_config', {})
      let g:quickrun_config[&filetype] = {'type': printf('%s/%s', &filetype, a:type)}
      call quickrun#run(printf('-%s', a:type))
    endfunction

    function! s:vimQuickrunOnSource() abort
      let g:quickrun_config = get(g:, 'quickrun_config', {})
      let g:quickrun_config._ = {
        \ 'outputter': 'null',
        \ 'runner': 'vimproc',
        \ 'runner/vimproc/updatetime': 30
        \}

      " PHP
      let g:quickrun_config['php/csfixer'] = {
        \ 'command': 'php-cs-fixer', 'exec': '%c -q fix %a -- %s', 'outputter': 'reopen',
        \ 'args': '--level=psr2'
        \}
      let g:quickrun_config['php/phpunit'] = {
        \ 'command': 'phpunit', 'exec': '%c %a', 'outputter': 'phpunit',
        \ 'args': printf('-c %s/preset/phpunit.xml.dist', $VIMFILES)
        \}

      " JavaScript
      let g:quickrun_config['javascript/nodejs'] = {
        \ 'command': 'node', 'exec': '%c %a %s', 'outputter': 'buffer',
        \ 'outputter/buffer/name': 'runner:nodejs',
        \ 'outputter/buffer/filetype': 'json',
        \ 'outputter/buffer/running_mark': '...'
        \}
      let g:quickrun_config['javascript/formatter'] = {
        \ 'command': 'esformatter', 'exec': '%c %a %s', 'outputter': 'rebuffer',
        \ 'args': printf('--config %s/preset/js.json --no-color', $VIMFILES)
        \}
      let g:quickrun_config['javascript/lint'] = {
        \ 'command': 'eslint', 'exec': '%c %a %s', 'outputter': 'eslint',
        \ 'args': printf('-c %s/preset/.eslintrc --no-color -f compact', $VIMFILES)
        \}

      " CSS
      let g:quickrun_config['css/formatter'] = {
        \ 'command': 'csscomb', 'exec': '%c %a %s', 'outputter': 'reopen',
        \ 'args': printf('--config %s/preset/css.json', $VIMFILES)
        \}

      " HTML
      let g:quickrun_config['html/formatter'] = {
        \ 'command': 'html-beautify', 'exec': '%c -f %s %a', 'outputter': 'rebuffer',
        \ 'args': '--indent-size 2 --unformatted script'
        \}
      " Twig
      let g:quickrun_config['twig/formatter'] = g:quickrun_config['html/formatter']

      " JSON
      let g:quickrun_config['json/formatter'] = {
        \ 'command': 'js-beautify', 'exec': '%c -f %s %a', 'outputter': 'rebuffer',
        \ 'args': '--indent-size 2'
        \}

      " Temporary
      let s:eslint = {'name': 'eslint', 'kind': 'outputter'}

      function! s:eslint.output(data, session) abort
        let self.result = a:data
      endfunction

      function! s:eslint.finish(session) abort
        if a:session.exit_code == 0 " if NO error
          echo ' No errors'
          return
        endif

        let data = split(self.result, "\n")
        let errors = join(data[:-3], "\n")
        let errorMessage = data[-1:][0]

        echo printf(' %s ', errorMessage)

        set errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m

        lgetexpr errors
        Unite location_list
        redraw
      endfunction

      call quickrun#module#register(s:eslint, 1) | unlet s:eslint
    endfunction

    Autocmd User dein#source#vim-quickrun call s:vimQuickrunOnSource()
  endif

  if dein#tap('agit.vim')
    nnoremap <silent> ,gl :<C-u>Agit<CR>
    nnoremap <silent> ,gf :<C-u>AgitFile<CR>

    function! s:agitOnSource() abort
      AutocmdFT agit setl cursorline
      AutocmdFT agit* let &l:statusline = ' '
    endfunction

    Autocmd User dein#source#agit.vim call s:agitOnSource()
  endif

  if dein#tap('vim-gita')
    nnoremap <silent> ,gs :<C-u>Gita status<CR>
    nnoremap <silent> ,gc :<C-u>Gita commit<CR>
    nnoremap <silent> ,ga :<C-u>Gita commit --amend<CR>
    nnoremap <silent> ,gd :<C-u>Gita diff<CR>
    nnoremap <silent> ,gb :<C-u>Gita browse<CR>
    " nnoremap <silent> ,gl :<C-u>Gita blame<CR>

    function! s:vimGitaOnSource() abort
      let gita#features#commit#enable_default_mappings = 0

      AutocmdFT gita*
        \ let &l:statusline = ' ' | setl nonu nornu
    endfunction

    Autocmd User dein#source#vim-gita call s:vimGitaOnSource()
  endif

  if dein#tap('vim-projectionist')
    " ;p: detect .projections.json
    nnoremap <silent> ;p :<C-u>call ProjectionistDetect(resolve(expand('<afile>:p')))<CR>

    AutocmdFT vimfiler
      \ call ProjectionistDetect(resolve(expand('<afile>:p')))
  endif

  if dein#tap('vim-altr')
    AutocmdFT php,twig call s:altrMappings()

    function! s:altrMappings() abort
      nmap <buffer> { <Plug>(altr-back)
      nmap <buffer> } <Plug>(altr-forward)
    endfunction

    Autocmd User dein#source#vim-altr
      \ call altr#remove_all()
  endif

  if dein#tap('vim-exchange')
    vmap <Tab>  <Plug>(Exchange)
    nmap ,x     <Plug>(Exchange)
    nmap ,X     <Plug>(ExchangeLine)

    function! s:vimExchangeOnSource() abort
      let g:exchange_no_mappings = 1
      exe 'nmap <silent> <C-c> <Plug>(ExchangeClear)'. maparg('<C-c>', 'n')
      hi _exchange_region guifg=#2B2B2B guibg=#0079A2 gui=NONE
    endfunction

    Autocmd User dein#source#vim-exchange call s:vimExchangeOnSource()
  endif

  if dein#tap('vim-visual-increment')
    xmap <C-a> <Plug>VisualIncrement
    xmap <C-x> <Plug>VisualDecrement

    " CTRL+A and CTRL+X works also for letters
    Autocmd User dein#source#vim-visual-increment
      \ set nrformats+=alpha
  endif

  if dein#tap('vim-easy-align')
    vmap <Enter> <Plug>(EasyAlign)

    function! s:vimEasyAlignOnSource() abort
      let g:easy_align_ignore_groups = ['Comment', 'String']
      let g:easy_align_delimiters = {
        \ '>': {'pattern': '>>\|=>\|>' },
        \ ']': {'pattern': '[[\]]', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0},
        \ ')': {'pattern': '[()]', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0},
        \ 'f': {'pattern': ' \(\S\+(\)\@=', 'left_margin': 0, 'right_margin': 0 },
        \ 'd': {'pattern': ' \(\S\+\s*[;=]\)\@=', 'left_margin': 0, 'right_margin': 0},
        \ ';': {'pattern': ':', 'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1},
        \ '/': {'pattern': '//\+\|/\*\|\*/', 'delimiter_align': 'l', 'ignore_groups': ['^\(.\(Comment\)\@!\)*$']},
        \ '=': {'pattern': '===\|<=>\|=\~[#?]\?\|=>\|[:+/*!%^=><&|.-?]*=[#?]\?\|[-=]>\|<[-=]', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0}
        \}
    endfunction

    Autocmd User dein#source#vim-easy-align call s:vimEasyAlignOnSource()
  endif

  if dein#tap('vim-brightest')
    AutocmdFT php,javascript
      \ nnoremap <silent> <buffer> ,v :<C-u>BrightestToggle<CR>
        \:echo printf(' Brightest mode: %3S', (g:brightest_enable == 0 ? 'Off' : 'On'))<CR>

    Autocmd Syntax php,javascript
      \ hi BrightestCursorLine guifg=#2B2B2B guibg=#EDE5F4 gui=NONE

    let s:brightest_ignore_syntax_def = split(
      \ 'None Normal Comment Type Keyword Delimiter Conditional Statement Constant Number Operator'
      \)

    " PHP
    AutocmdFT php BrightestDisable
      \| let b:brightest_ignore_syntax_list = split(
        \ 'phpRegion phpIf phpDelimiter phpBoolean phpInteger phpInclude',
        \ 'phpStatement phpEncapsulation phpAnnotation phpDocTags phpOperator'
        \) + s:brightest_ignore_syntax_def

    " JavaScript
    AutocmdFT javascript BrightestDisable
      \| let b:brightest_ignore_syntax_list = split(
        \ ' javascriptVariable javaScriptBraces javaScriptParens javascriptReturn javascriptBlock',
        \ 'javascriptFuncCallArg javascriptArrowFuncDef javascriptDotNotation javascriptOperator',
        \ 'javaScriptRegexpString javascriptObjectLiteral javascriptArray javaScriptBoolean'
        \) + s:brightest_ignore_syntax_def

    function! s:vimBrightestOnSource() abort
      let g:brightest#enable_filetypes = {'_': 0}
      let g:brightest#enable_filetypes.php = 1
      let g:brightest#enable_filetypes.javascript = 1
      let g:brightest#enable_highlight_all_window = 0
      let g:brightest#highlight = {'group': 'BrightestCursorLine', 'priority': -1}
    endfunction

    Autocmd User dein#source#vim-brightest call s:vimBrightestOnSource()
  endif

  if dein#tap('sideways.vim')
    nnoremap <silent> <C-h> :<C-u>SidewaysLeft<CR>
    nnoremap <silent> <C-l> :<C-u>SidewaysRight<CR>
    nnoremap <silent> <S-h> :<C-u>SidewaysJumpLeft<CR>
    nnoremap <silent> <S-l> :<C-u>SidewaysJumpRight<CR>
  endif

  if dein#tap('wildfire.vim')
    nmap vv    <Plug>(wildfire-fuel)
    xmap vv    <Plug>(wildfire-fuel)
    xmap <C-v> <Plug>(wildfire-water)

    function! s:wildfireOnSource() abort
      let g:wildfire_objects = {
        \ '*': split("iw iW i' i\" i) a) a] a}"),
        \ 'html,twig,xml': ["at"]
        \}
    endfunction

    Autocmd User dein#source#wildfire.vim call s:wildfireOnSource()
  endif

  if dein#tap('argumentrewrap')
    map <silent> K :<C-u>call argumentrewrap#RewrapArguments()<CR>
  endif

  if dein#tap('incsearch.vim')
    noremap <silent> <expr> /  incsearch#go(<SID>incsearchConfig())
    noremap <silent> <expr> ?  incsearch#go(<SID>incsearchConfig({'command': '?'}))
    noremap <silent> <expr> g/ incsearch#go(<SID>incsearchConfig({'is_stay': 1}))

    function! s:incsearchConfig(...) abort
      return incsearch#util#deepextend(deepcopy({
        \ 'modules': [incsearch#config#easymotion#module({'overwin': 1})],
        \ 'keymap': {
        \   "\<C-CR>": '<Over>(easymotion)',
        \   "\<S-CR>": '<Over>(easymotion)'
        \ },
        \ 'is_expr': 0
        \}), get(a:, 1, {}))
    endfunction

    Autocmd User dein#source#incsearch.vim
      \ let g:incsearch#auto_nohlsearch = 1
  endif

  if dein#tap('vim-jplus')
    nmap J <Plug>(jplus)
    vmap J <Plug>(jplus)
    nmap ,j <Plug>(jplus-input)
    vmap ,j <Plug>(jplus-input)
    nmap ,J <Plug>(jplus-getchar)
    vmap ,J <Plug>(jplus-getchar)

    function! s:vimJplusOnSource() abort
      let g:jplus#config = get(g:, 'jplus#config', {})
      let g:jplus#config = {
        \ 'php': {'delimiter_format': ''}
        \}
    endfunction

    Autocmd User dein#source#vim-jplus call s:vimJplusOnSource()()
  endif

  if dein#tap('splitjoin.vim')
    nmap <silent> S :<C-u>SplitjoinSplit<CR><CR><Esc>
  endif

  if dein#tap('vim-smartword')
    for char in split('w e b ge')
      exe printf('nmap %s <Plug>(smartword-%s)', char, char)
      exe printf('vmap %s <Plug>(smartword-%s)', char, char)
    endfor | unlet char
  endif

  if dein#tap('lexima.vim')
    function! s:leximaOnSource() abort
      let g:lexima_no_default_rules = 1
      let g:lexima_no_map_to_escape = 1
      let g:lexima_enable_newline_rules = 1
      let g:lexima_enable_endwise_rules = 0

      silent! call remove(g:lexima#default_rules, 11, -1)
      for rule in g:lexima#default_rules
        call lexima#add_rule(rule)
      endfor | unlet rule

      function! s:disable_lexima_inside_regexp(char) abort
        call lexima#add_rule({'char': a:char, 'at': '\(...........\)\?/\S.*\%#.*\S/', 'input': a:char})
      endfunction

      " Fix pair completion
      for pair in split('() []')
        call lexima#add_rule({
          \ 'char': pair[0], 'at': '\(........\)\?\%#[^\s'.escape(pair[1], ']') .']', 'input': pair[0]
          \})
      endfor | unlet pair

      " Quotes
      for quote in split("\" '")
        call lexima#add_rule({'char': quote, 'at': '\(.......\)\?'. quote .'\%#', 'input': quote})
        call lexima#add_rule({'char': quote, 'at': '\(...........\)\?\%#'. quote, 'input': '<Right>'})
        call lexima#add_rule({'char': '<BS>', 'at': '\(.......\)\?'. quote .'\%#'. quote, 'delete': 1})
        call s:disable_lexima_inside_regexp(quote)
      endfor | unlet quote

      " { <CR> }
      call lexima#add_rule({'at': '{\%#}', 'char': '<CR>', 'input_after': '<CR>'})
      call lexima#add_rule({'at': '{\%#$', 'char': '<CR>', 'input_after': '<CR>}', 'filetype': []})

      " { <Space> }
      call lexima#add_rule({
        \ 'filetype': ['javascript', 'yaml'],
        \ 'at': '\(.......\)\?{\%#}', 'char': '<Space>', 'input_after': '<Space>'
        \})

      " Twig / Blade
      " {{ <Space> }}
      call lexima#add_rule({
        \ 'filetype': ['twig', 'blade'],
        \ 'at': '\(........\)\?{\%#}', 'char': '{', 'input': '{<Space>', 'input_after': '<Space>}'
        \})
      call lexima#add_rule({
        \ 'filetype': ['twig', 'blade'],
        \ 'at': '\(........\)\?{{ \%# }}', 'char': '<BS>', 'input': '<BS><BS>', 'delete': 2
        \})
      " {# <Space> #}
      call lexima#add_rule({
        \ 'filetype': 'twig',
        \ 'at': '\(........\)\?{\%#}', 'char': '#', 'input': '#<Space><Space>#<Left><Left>'
        \})
      call lexima#add_rule({
        \ 'filetype': 'twig',
        \ 'at': '\(........\)\?{# \%# #}', 'char': '<BS>', 'input': '<Right><Right><BS><BS><BS>', 'delete': 2
        \})
      " {# <Space> #}
      call lexima#add_rule({
        \ 'filetype': 'twig',
        \ 'at': '{\%#}', 'char': '%', 'input': '%<Space><Space>%<Left><Left>'
        \})
      call lexima#add_rule({
        \ 'filetype': 'twig',
        \ 'at': '{% \%# %}', 'char': '<BS>', 'input': '<Right><Right><BS><BS><BS>', 'delete': 2
        \})

      " Attributes
      call lexima#add_rule({
        \ 'filetype': ['html', 'xml', 'javascript', 'twig', 'blade'],
        \ 'at': '\(........\)\?<.\+\%#', 'char': '=', 'input': '=""<Left>'
        \})

      " /* */
      call lexima#add_rule({
        \ 'filetype': 'css',
        \ 'at': '\(........\)\?/\%#', 'char': '/', 'input': '*<Space><Space>*/<Left><Left><Left>'
        \})

      if exists(':Rename')
        " Rename :er
        call lexima#add_rule({
          \ 'mode':  ':',
          \ 'at': '^e\%#', 'char': 'r', 'input': "\<C-u>Rename \<C-r>=expand('%:p') \<CR>\<C-w>"
          \})
      endif
    endfunction

    Autocmd User dein#source#lexima.vim call s:leximaOnSource()
  endif

  if dein#tap('switch.vim')
    nnoremap <silent> <S-Tab> :<C-u>silent! Switch<CR>
    xnoremap <silent> <S-Tab> :silent! Switch<CR>
    nnoremap <silent> ! :<C-u>silent! call switch#Switch([g:switch_def_quotes], {'reverse': 0})<CR>
    nnoremap <silent> ` :<C-u>silent! call switch#Switch([g:switch_def_camelcase], {'reverse': 0})<CR>

    let g:switch_mapping = ''
    let g:switch_def_quotes = {
      \ '''\(.\{-}\)''': '"\1"',
      \ '"\(.\{-}\)"':  '''\1''',
      \ '`\(.\{-}\)`':  '''\1'''
      \}
    let g:switch_def_camelcase = {
      \ '\<\(\l\)\(\l\+\(\u\l\+\)\+\)\>': '\=toupper(submatch(1)) . submatch(2)',
      \ '\<\(\u\l\+\)\(\u\l\+\)\+\>': "\\=tolower(substitute(submatch(0), '\\(\\l\\)\\(\\u\\)', '\\1_\\2', 'g'))",
      \ '\<\(\l\+\)\(_\l\+\)\+\>': '\U\0',
      \ '\<\(\u\+\)\(_\u\+\)\+\>': "\\=tolower(substitute(submatch(0), '_', '-', 'g'))",
      \ '\<\(\l\+\)\(-\l\+\)\+\>': "\\=substitute(submatch(0), '-\\(\\l\\)', '\\u\\1', 'g')"
      \}

    " PHP
    AutocmdFT php let b:switch_custom_definitions = [
      \ ['prod', 'dev', 'test'],
      \ ['&&', '||'],
      \ ['and', 'or'],
      \ ['public', 'protected', 'private'],
      \ ['extends', 'implements'],
      \ ['string ', 'int ', 'array '],
      \ ['use', 'namespace'],
      \ ['var_dump', 'print_r'],
      \ ['include', 'require'], ['include_once', 'require_once'],
      \ ['$_GET', '$_POST', '$_REQUEST'],
      \ {
      \   '\([^=]\)===\([^=]\)': '\1==\2',
      \   '\([^=]\)==\([^=]\)': '\1===\2'
      \ },
      \ {
      \   '\[[''"]\(\k\+\)[''"]\]': '->\1',
      \   '\->\(\k\+\)': '[''\1'']'
      \ },
      \ {
      \   '\array(\(.\{-}\))': '[\1]',
      \   '\[\(.\{-}\)]': '\array(\1)'
      \ }
      \]

    " JavaScript
    AutocmdFT javascript let b:switch_custom_definitions = [
      \ ['get', 'set'],
      \ ['var', 'const', 'let'],
      \ ['<', '>'], ['==', '!=', '==='],
      \ ['left', 'right'], ['top', 'bottom'],
      \ ['getElementById', 'getElementByClassName'],
      \ {
      \   '\function\s*(\(.\{-}\))': '(\1) =>'
      \ }
      \]

    " HTML
    AutocmdFT html,twig let b:switch_custom_definitions = [
      \ ['h1', 'h2', 'h3'],
      \ ['png', 'jpg', 'gif'],
      \ ['id=', 'class=', 'style='],
      \ {
      \   '<div\(.\{-}\)>\(.\{-}\)</div>': '<span\1>\2</span>',
      \   '<span\(.\{-}\)>\(.\{-}\)</span>': '<div\1>\2</div>'
      \ },
      \ {
      \   '<ol\(.\{-}\)>\(.\{-}\)</ol>': '<ul\1>\2</ul>',
      \   '<ul\(.\{-}\)>\(.\{-}\)</ul>': '<ol\1>\2</ol>'
      \ }
      \]

    " CSS
    AutocmdFT css let b:switch_custom_definitions = [
      \ ['border-top', 'border-bottom'],
      \ ['border-left', 'border-right'],
      \ ['border-left-width', 'border-right-width'],
      \ ['border-top-width', 'border-bottom-width'],
      \ ['border-left-style', 'border-right-style'],
      \ ['border-top-style', 'border-bottom-style'],
      \ ['margin-left', 'margin-right'],
      \ ['margin-top', 'margin-bottom'],
      \ ['padding-left', 'padding-right'],
      \ ['padding-top', 'padding-bottom'],
      \ ['margin', 'padding'],
      \ ['height', 'width'],
      \ ['min-width', 'max-width'],
      \ ['min-height', 'max-height'],
      \ ['transition', 'animation'],
      \ ['absolute', 'relative', 'fixed'],
      \ ['inline', 'inline-block', 'block', 'flex'],
      \ ['overflow', 'overflow-x', 'overflow-y'],
      \ ['before', 'after'],
      \ ['none', 'block'],
      \ ['left', 'right'],
      \ ['top', 'bottom'],
      \ ['em', 'px', '%'],
      \ ['bold', 'normal'],
      \ ['hover', 'active']
      \]
  endif

  if dein#tap('vim-smartchr')
    command! -nargs=* ImapBufExpr inoremap <buffer> <expr> <args>
    AutocmdFT haskell
      \  ImapBufExpr \ smartchr#loop('\ ', '\')
      \| ImapBufExpr - smartchr#loop('-', ' -> ', ' <- ')
    AutocmdFT php
      \  ImapBufExpr $ smartchr#loop('$', '$this->', '$$')
      \| ImapBufExpr > smartchr#loop('>', '=>')
      \| ImapBufExpr - smartchr#loop('-', '->')
    AutocmdFT javascript
      \  ImapBufExpr - smartchr#loop('-', '--', '_')
      \| ImapBufExpr $ smartchr#loop('$', 'this.', 'self.')
    AutocmdFT yaml
      \  ImapBufExpr > smartchr#loop('>', '%>')
      \| ImapBufExpr < smartchr#loop('<', '<%', '<%=')
  endif

  if dein#tap('vim-operator-replace')
    nmap R <Plug>(operator-replace)
    vmap R <Plug>(operator-replace)
  endif

  if dein#tap('vim-operator-surround')
    vmap sa <Plug>(operator-surround-append)
    vmap sd <Plug>(operator-surround-delete)
    vmap sr <Plug>(operator-surround-replace)
  endif

  if dein#tap('operator-reverse.vim')
    vmap <silent> sw <Plug>(operator-reverse-text)
    vmap <silent> sl <Plug>(operator-reverse-lines)
  endif

  if dein#tap('vim-operator-flashy')
    nmap y <Plug>(operator-flashy)
    nmap Y <Plug>(operator-flashy)$

    Autocmd User dein#source#vim-operator-flashy
      \  let g:operator#flashy#group = 'Visual'
      \| let g:operator#flashy#flash_time = 280
  endif

  if dein#tap('vim-operator-eval')
    vmap <silent> se <Plug>(operator-eval-vim)
  endif

  if dein#tap('vim-surround')
    nmap ,d <Plug>Dsurround
    nmap ,i <Plug>Csurround
    nmap ,I <Plug>CSurround
    nmap ,t <Plug>Yssurround
    nmap ,T <Plug>YSsurround
    xmap ,s <Plug>VSurround
    xmap ,S <Plug>VgSurround

    for char in split("' ` \" ( ) { } [ ]")
      exe printf('nmap ,%s ,Iw%s', char, char)
    endfor | unlet char

    Autocmd User dein#source#vim-surround
      \ let g:surround_no_mappings = 1
  endif

  if dein#tap('colorizer')
    let s:color_codes_ft = 'css html twig'
    Autocmd BufNewFile,BufRead,BufEnter,WinEnter *
      \ exe index(split(s:color_codes_ft), &filetype) == -1
        \ ? 'call s:removeColorizerEvent()'
        \ : 'ColorHighlight'

    function! s:removeColorizerEvent() abort
      if !exists('#Colorizer')| return |endif
      augroup Colorizer
        autocmd!
      augroup END
      augroup! Colorizer
    endfunction

    Autocmd User dein#source#colorizer
      \ let g:colorizer_nomap = 1
  endif

  if dein#tap('ultisnips')
    inoremap <silent> ` <C-r>=<SID>ultiComplete("\`")<CR>
    xnoremap <silent> ` :<C-u>call UltiSnips#SaveLastVisualSelection()<CR>gvs
    snoremap <C-c> <Esc>

    function! s:ultiComplete(key) abort
      if len(UltiSnips#SnippetsInCurrentScope()) >= 1
        let [curPos, lineLength] = [getcurpos()[4], col('$')]
        let isBackspace = getline('.')[curPos-2] =~ '\s'
        let isStartLine = curPos <= 1
        let isText = curPos <= lineLength
        if isText && !isStartLine && !isBackspace
          return UltiSnips#ExpandSnippet()
        endif
      endif
      return a:key
    endfunction

    Autocmd BufNewFile,BufRead *.snippets setl filetype=snippets

    function! s:ultiOnSource() abort
      let g:UltiSnipsEnableSnipMate = 0
      let g:UltiSnipsExpandTrigger = '<C-F12>'
      let g:UltiSnipsListSnippets = '<C-F12>'
      let g:UltiSnipsSnippetsDir = $VIMFILES.'/dev/dotvim/ultisnips'

      AutocmdFT twig call UltiSnips#AddFiletypes('twig.html')
      AutocmdFT blade call UltiSnips#AddFiletypes('blade.html')
    endfunction

    Autocmd User dein#source#ultisnips call s:ultiOnSource()
  endif

  if dein#tap('unite.vim')
    " ;f: open files
    nnoremap <silent> ;f
      \ :<C-u>UniteWithCurrentDir file_rec/async file/new directory/new -buffer-name=files -start-insert<CR>
    nnoremap <silent> ;F
      \ :<C-u>UniteWithCurrentDir file_rec/async file/new directory/new -buffer-name=files -start-insert -no-smartcase<CR>

    " ;b: open buffers
    nnoremap <silent> ;b :<C-u>Unite buffer -toggle<CR>
    nnoremap <silent> =  :<C-u>Unite buffer -toggle<CR>
    " ;h: open windows
    nnoremap <silent> ;h :<C-u>Unite window:all:no-current -toggle<CR>
    " ;H: open tab pages
    nnoremap <silent> ;H
      \ :<C-u>Unite tab -buffer-name=tabs -select=`tabpagenr()-1` -toggle<CR>

    " ;g: grep search
    nnoremap <silent> ;g :<C-u>Unite grep:. -no-split -auto-preview<CR>
    " ;s: search
    nnoremap <silent> ;s
      \ :<C-u>Unite line:all -buffer-name=search%`bufnr('%')` -no-wipe -no-split -start-insert<CR>
    nnoremap <silent> ;S
      \ :<C-u>Unite line:all -buffer-name=search%`bufnr('%')` -no-wipe -no-split -start-insert -no-smartcase<CR>
    " *: search keyword under the cursor
    nnoremap <silent> ;*
      \ :<C-u>UniteWithCursorWord line:forward:wrap -buffer-name=search%`bufnr('%')` -no-wipe<CR>

    " ;r: resume search buffer
    nnoremap <silent> ;r
      \ :<C-u>UniteResume search%`bufnr('%')` -no-start-insert -force-redraw<CR>
    " ;o: open message log
    nnoremap <silent> ;O :<C-u>Unite output:message<CR>

    AutocmdFT unite call s:uniteMappings()
    " Unite tuning
    AutocmdFT unite,unite_exrename
      \ setl nolist
        \| Autocmd InsertEnter,InsertLeave <buffer>
          \ setl nonu nornu nolist colorcolumn=

    function! s:uniteMappings() abort
      let b:unite = unite#get_current_unite()

      " Normal mode
      nmap <buffer> <BS> <Nop>
      nmap <buffer> e <Nop>
      nmap <buffer> <C-k> <C-u>
      nmap <buffer> R     <Plug>(unite_redraw)
      nmap <buffer> <Tab> <Plug>(unite_insert_head)
      nmap <silent> <buffer> <nowait> <expr> o unite#do_action('open')
      nmap <silent> <buffer> <nowait> <expr> O unite#do_action('choose')
      nmap <silent> <buffer> <nowait> <expr> s unite#do_action('above')
      nmap <silent> <buffer> <nowait> <expr> S unite#do_action('below')
      nmap <silent> <buffer> <nowait> <expr> v unite#do_action('left')
      nmap <silent> <buffer> <nowait> <expr> V unite#do_action('right')
      nmap <silent> <buffer> <nowait> <expr> b unite#do_action('backup')
      nmap <silent> <buffer> <nowait> <expr> D unite#do_action('fdelete')
      nmap <silent> <buffer> <nowait> <expr> r
        \ b:unite.profile_name ==# 'line' ? unite#do_action('replace') : unite#do_action('rename')
      nmap <silent> <buffer> <nowait> <expr> R
        \ b:unite.profile_name ==# 'line' ? unite#do_action('replace') : unite#do_action('exrename')
      nmap <buffer> <expr> <C-x> unite#mappings#set_current_sorters(
        \ unite#mappings#get_current_sorters() == [] ? ['sorter_ftime', 'sorter_reverse'] : []) . "\<Plug>(unite_redraw)"

      " Insert mode
      imap <buffer> <C-e> <C-o>A
      imap <buffer> <C-a> <Plug>(unite_move_head)
      imap <buffer> <C-j> <Plug>(unite_move_left)
      imap <buffer> <C-l> <Plug>(unite_move_right)
      imap <buffer> <Tab> <Plug>(unite_insert_leave)
      imap <buffer> <C-j> <Plug>(unite_select_next_line)
      imap <buffer> <C-k> <Plug>(unite_select_previous_line)
      imap <buffer> <expr> <C-h>  col('$') > 2 ? "\<Plug>(unite_delete_backward_char)" : ""
      imap <buffer> <expr> <BS>   col('$') > 2 ? "\<Plug>(unite_delete_backward_char)" : ""
      imap <buffer> <expr> <S-BS> col('$') > 2 ? "\<Plug>(unite_delete_backward_word)" : ""
      imap <buffer> <expr> q      getline('.')[getcurpos()[4]-2] ==# 'q' ? "\<Plug>(unite_exit)" : "\q"
      imap <buffer> <expr> <C-x> unite#mappings#set_current_sorters(
        \ unite#mappings#get_current_sorters() == [] ? ['sorter_ftime', 'sorter_reverse'] : [])
          \ . (col('$') > 2 ? "" : "\<Plug>(unite_delete_backward_word)")
    endfunction

    function! s:uniteOnSource() abort
      let g:unite_source_buffer_time_format = '%H:%M '
      let g:unite_data_directory = $VIMCACHE.'/unite'
      if executable('ag')
        let g:unite_source_grep_command = 'ag'
        let g:unite_source_grep_recursive_opt = ''
        let g:unite_source_grep_encoding = 'utf-8'
        let g:unite_source_grep_default_opts = '--follow --smart-case --nogroup --nocolor'
        let g:unite_source_rec_async_command = [
          \ 'ag', &smartcase ? '-S' : '', '--nocolor', '--nogroup', '--hidden', '--follow', '-l', '.'
          \]
      endif

      " Default profile
      let unite_default = {
        \ 'winheight': 20,
        \ 'direction': 'botright',
        \ 'prompt_direction': 'bellow',
        \ 'cursor_line_time': '0.0',
        \ 'short_source_names': 1,
        \ 'hide_source_names': 1,
        \ 'hide_icon': 0,
        \ 'marked_icon': '+',
        \ 'prompt': '>',
        \ 'wipe': 1
        \}
      " Grep profile
      let unite_grep = {
        \ 'winheight': 20
        \}
      " Quickfix profile
      let unite_quickfix = {
        \ 'winheight': 16,
        \ 'no_quit': 1,
        \ 'keep_focus': 1
        \}

      " Custom profiles
      call unite#custom#profile('default', 'context', unite_default)
      call unite#custom#profile('grep', 'context', unite_grep)
      call unite#custom#profile('quickfix', 'context', unite_quickfix)
      " Custom filters
      call unite#custom#source('file_rec/async', 'max_candidates', 40)
      call unite#custom#source('file_rec/async', 'matchers', ['converter_relative_word', 'matcher_fuzzy'])

      Autocmd Syntax unite
        \  hi link uniteStatusHead             StatusLine
        \| hi link uniteStatusNormal           StatusLine
        \| hi link uniteStatusMessage          StatusLine
        \| hi link uniteStatusSourceNames      StatusLine
        \| hi link uniteStatusSourceCandidates User1
        \| hi link uniteStatusLineNR           User2
    endfunction

    Autocmd User dein#source#unite.vim call s:uniteOnSource()
  endif

  if dein#tap('neomru.vim')
    " ;w: open recently-opened files in project
    nnoremap <silent> ;w
      \ :<C-u>call <SID>openMRU(['matcher_fuzzy', 'matcher_hide_current_file', 'matcher_project_files'])<CR>
    " ;W: open recently-opened files
    nnoremap <silent> ;W
      \ :<C-u>call <SID>openMRU(['matcher_fuzzy', 'matcher_hide_current_file'])<CR>

    Autocmd BufWipeout,BufLeave,WinLeave,BufWinLeave,VimLeavePre * NeoMRUSave

    function! s:openMRU(matchers) abort
      call unite#custom#source('neomru/file', 'matchers', a:matchers)
      Unite neomru/file -toggle
    endfunction

    function! s:neomruOnSource() abort
      let g:neomru#file_mru_path = $VIMCACHE.'/unite/file'
      let g:neomru#file_mru_ignore_pattern = '\.\%([_]vimrc\|txt\)$'
      let g:neomru#filename_format = ':.'
      let g:neomru#directory_mru_path = $VIMCACHE.'/unite/directory'
      let g:neomru#time_format = '%d.%m %H:%M — '
      " Limit results for recently edited files
      call unite#custom#source('neomru/file,neomru/directory', 'limit', 20)
    endfunction

    Autocmd User dein#source#neomru.vim call s:neomruOnSource()
  endif

  if dein#tap('unite-vimpatches')
    " ;p: open vimpatches log
    nnoremap <silent> ;U :<C-u>Unite vimpatches -buffer-name=dein<CR>
  endif
"
  if dein#tap('unite-outline')
    " ;o: outline
    nnoremap <silent> ;o :<C-u>Unite outline -toggle -no-empty -winheight=16 -silent<CR>
  endif

  if dein#tap('unite-filetype')
    " ;i: filetype change
    nnoremap <silent> ;z :<C-u>Unite filetype filetype/new -start-insert<CR>

    Autocmd User dein#source#unite-filetype
      \ call unite#custom#source('filetype', 'sorters', 'sorter_length')
  endif

  if dein#tap('httpstatus-vim')
    " F12: http codes
    nnoremap <silent> <F12> :<C-u>Unite httpstatus -start-insert<CR>
  endif

  if dein#tap('junkfile.vim')
    nnoremap ,sj :<C-u>JunkfileOpen<CR>
    nnoremap <silent> ,sJ :<C-u>Unite junkfile/new junkfile -split<CR>

    Autocmd User dein#source#junkfile.vim
      \ let g:junkfile#directory = $VIMFILES.'/cache/junkfile'
  endif

  if dein#tap('unite-tag')
    AutocmdFT php,javascript
      \ Autocmd BufRead,BufEnter <buffer> call s:uniteTagMappings()

    function! s:uniteTagMappings() abort
      " if !empty(&buftype) " just <empty> == normal buffer
      "   return
      " endif
      " ;t: open tag
      nnoremap <silent> <buffer> ;t :<C-u>UniteWithCursorWord tag tag/include<CR>
      " ;T: search tag by name
      nnoremap <silent> <buffer> ;T :<C-u>call <SID>inputSearchTag()<CR>
      " Ctrl-t: open tag under cursor
      nnoremap <silent> <buffer> <C-t> :<C-u>UniteWithCursorWord tag -immediately<CR>

      function! s:inputSearchTag() abort
        let searchWord = input(' Tag name: ')
        if !empty(searchWord)
          exe ':Unite tag:'.escape(searchWord, '"')
        endif
      endfunction
    endfu
  endif

  if dein#tap('neoyank.vim')
    nnoremap <silent> ;y
      \ :<C-u>Unite history/yank -buffer-name=history_yank -toggle -no-empty<CR>

    AutocmdFT unite call s:historyYankMappings()

    function! s:historyYankMappings() abort
      let b:unite = unite#get_current_unite()
      if b:unite.buffer_name ==# 'history_yank'
        " Normal mode
        nmap <silent> <buffer> o <Plug>(unite_do_default_action)
      endif
    endfunction

    Autocmd User dein#source#neoyank.vim
      \ let g:neoyank#file = $VIMCACHE.'/yankring'
  endif

  if dein#tap('vim-reanimate')
    nnoremap <silent> ,sa :<C-u>ReanimateSaveInput<CR>
    nnoremap <silent> ,sl :<C-u>Unite reanimate -buffer-name=reanimate<CR>

    command! -nargs=0 ReanimateSaveWithTimeStamp
      \ exe ':ReanimateSave '. strftime('%y%m%d_%H%M%S')

    " Autocmd VimLeavePre * ReanimateSaveWithTimeStamp
    AutocmdFT unite call s:reanimateMappings()

    function! s:reanimateMappings() abort
      let b:unite = unite#get_current_unite()
      if b:unite.buffer_name ==# 'reanimate'
        " Normal mode
        nmap <silent> <buffer> <expr> <CR> unite#do_action('reanimate_load')
        nmap <silent> <buffer> <expr> o    unite#do_action('reanimate_load')
        nmap <silent> <buffer> <expr> s    unite#do_action('reanimate_save')
        nmap <silent> <buffer> <expr> r    unite#do_action('reanimate_rename')
        nmap <silent> <buffer> <expr> t    unite#do_action('reanimate_switch')
        nmap <silent> <buffer> <expr> S    unite#do_action('reanimate_new_save')
        nmap <silent> <buffer> <expr> n    unite#do_action('reanimate_new_save')
      endif
    endfunction

    function! s:vimReanimateOnSource() abort
      let g:reanimate_event_disables = {
        \ '_': {'reanimate_confirm': 1}
        \}
      let g:reanimate_default_category = 'project'
      let g:reanimate_save_dir = $VIMFILES.'/session'
      let g:reanimate_sessionoptions = 'curdir,folds,help,localoptions,slash,tabpages,winsize'

      function! s:deleteNoActiveBuffers() abort
        " https://gist.github.com/AlexMasterov/da5cd633829166d9fac9
        if exists(':CleanBuffers')| CleanBuffers |endif
      endfunction

      " Custom events
      let s:event = {'name': 'user_event'}

      function! s:event.load_pre_post(...) abort
        wall | tabnew | call s:deleteNoActiveBuffers() | tabonly
      endfunction

      function! s:event.save_pre(...) abort
        try
          argd * | call s:deleteNoActiveBuffers()
        catch
        endtry
      endfunction

      function! s:event.save(...) abort
        echom printf(' Session saved (%s)', strftime('%Y/%m/%d %H:%M:%S'))
      endfunction

      call reanimate#hook(s:event) | unlet s:event
    endfunction

    Autocmd User dein#source#vim-reanimate call s:vimReanimateOnSource()
  endif

  if dein#tap('vim-qfreplace')
    " qfreplace tuning
    AutocmdFT qfreplace
      \  call feedkeys("\<CR>\<Esc>")
      \| setl nonu nornu colorcolumn= laststatus=0
      \| Autocmd BufEnter,WinEnter <buffer> setl laststatus=0
      \| Autocmd BufLeave,BufDelete <buffer> set laststatus=2
      \| Autocmd InsertEnter,InsertLeave <buffer> setl nonu nornu colorcolumn=
  endif

" Languages
"---------------------------------------------------------------------------
" Haskell
  " Indent
  AutocmdFT haskell setl nowrap textwidth=80 | Indent 4
  " Syntax
  if dein#tap('vim-haskellConcealPlus')
    " AutocmdFT haskell let &l:conceallevel = 0
    AutocmdFT haskell
      \ nnoremap <silent> <buffer> ,c :<C-u>let &l:conceallevel = (&l:conceallevel == 0 ? 2 : 0)<CR>
        \:echo printf(' Conceal mode: %3S (local)', (&l:conceallevel == 0 ? 'Off' : 'On'))<CR>
  endif
  " Autocomplete
  if dein#tap('neco-ghc')
    AutocmdFT haskell setl omnifunc=necoghc#omnifunc

    Autocmd User dein#source#neco-ghc
      \ let g:necoghc_enable_detailed_browse = 1
  endif
  if dein#tap('ghcmod-vim')
    AutocmdFT haskell
      \  nnoremap <silent> <buffer> ;t :<C-u>GhcModType!<CR>
      \| nnoremap <silent> <buffer> ;T :<C-u>GhcModTypeClear<CR>

    AutocmdFT haskell Autocmd BufWritePost <buffer> GhcModCheckAndLintAsync

    function! s:ghcmodVimOnSource() abort
      let g:ghcmod_open_quickfix_function = 's:ghcmodQuickfix'

      function! s:ghcmodQuickfix()
        Unite quickfix -no-empty -silent
      endfunction
    endfunction

    Autocmd User dein#source#ghcmod-vim call s:ghcmodVimOnSource()
  endif

" PHP
  " Indent
  AutocmdFT php setl nowrap textwidth=120 | Indent 4
  " Syntax
  let g:php_sql_query = 1
  let g:php_highlight_html = 1
  " Autocomplete
  if dein#tap('phpcomplete.vim')
    function! s:phpcompleteOnSource() abort
      let g:phpcomplete_relax_static_constraint = 0
      let g:phpcomplete_parse_docblock_comments = 0
      let g:phpcomplete_search_tags_for_variables = 1
      let g:phpcomplete_complete_for_unknown_classes = 0
      let g:phpcomplete_remove_function_extensions = split(
        \ 'apache dba dbase odbc msql mssql'
        \)
      let g:phpcomplete_remove_constant_extensions = split(
        \ 'ms_sql_server_pdo msql mssql'
        \)
    endfunction

    Autocmd User dein#source#phpcomplete.vim call s:phpcompleteOnSource()
  endif
  " PHP Documentor
  if dein#tap('pdv')
    AutocmdFT php
      \ nnoremap <silent> <buffer> ,c :<C-u>silent! call pdv#DocumentWithSnip()<CR>

    Autocmd User dein#source#pdv
      \ let g:pdv_template_dir = $VIMFILES.'/dev/dotvim/templates'
  endif
  " vDebug (for xDebug)
  if dein#tap('vdebug')
    AutocmdFT php call s:vdebugMappings()

    function! s:vdebugMappings()
      nnoremap <silent> <buffer> ,d      :<C-u>python debugger.run()<CR>
      vnoremap <silent> <buffer> ,d      :<C-u>python debugger.handle_visual_eval()<CR>
      nnoremap <silent> <buffer> ,,      :<C-u>python debugger.set_breakpoint()<CR>
      nnoremap <silent> <buffer> <Left>  :<C-u>python debugger.step_over()<CR>
      nnoremap <silent> <buffer> <Right> :<C-u>python debugger.step_into()<CR>
      nnoremap <silent> <buffer> <Up>    :<C-u>python debugger.step_out()<CR>
    endfunction

    function! s:vdebugOnSource() abort
      let g:vdebug_keymap = {}
      let g:vdebug_options = {
        \ 'port': 9001,
        \ 'server': '10.10.78.16',
        \ 'on_close': 'detach',
        \ 'break_on_open': 1,
        \ 'debug_window_level': 0,
        \ 'watch_window_style': 'compact',
        \ 'path_maps': {'/www': 'D:/Lab/backend'}
        \}
      let g:vdebug_features = {
        \ 'max_depth': 2048,
        \ 'max_children': 128
        \}

      Autocmd BufNewFile,BufRead Debugger*
        \ let &l:statusline = ' ' | setl nonu nornu
      Autocmd Syntax php
        \  hi DbgCurrentLine guifg=#2B2B2B guibg=#D2FAC1 gui=NONE
        \| hi DbgCurrentSign guifg=#2B2B2B guibg=#E4F3FB gui=NONE
        \| hi DbgBreakptLine guifg=#2B2B2B guibg=#FDCCD9 gui=NONE
        \| hi DbgBreakptSign guifg=#2B2B2B guibg=#E4F3FB gui=NONE
    endfunction

    Autocmd User dein#source#vdebug call s:vdebugOnSource()
  endif

" JavaScript
  Autocmd BufNewFile,BufRead *.{jsx,es6} setl filetype=javascript
  " Indent
  AutocmdFT javascript setl nowrap textwidth=100 | Indent 2
  " Syntax
  if dein#tap('yajs.vim')
    function! s:yajsOnPostSource() abort
      function! s:yajsJsxSyntax()
        syntax include @XMLSyntax syntax/xml.vim
        syntax region jsxRegion contains=@XMLSyntax,jsxRegion,jsBlock,javascriptBlock
          \ start=+<\@<!<\z([a-zA-Z][a-zA-Z0-9:\-.]*\)+ skip=+<!--\_.\{-}-->+
          \ end=+</\z1\_\s\{-}>+ end=+/>+
          \ keepend extend
        syntax region xmlString contained start=+{+ end=++ contains=jsBlock,javascriptBlock
        syntax cluster jsExpression add=jsxRegion
        syntax cluster javascriptNoReserved add=jsxRegion
      endfunction

      Autocmd Syntax javascript
        \  call s:yajsJsxSyntax()
        \| hi link javascriptReserved  Normal
        \| hi link javascriptInvalidOp Normal
    endfunction

    Autocmd User dein#post_source#yajs.vim call s:yajsOnPostSource()
  endif
  " Autocomplete
  if dein#tap('ternjs.vim')
    Autocmd BufNewFile,BufRead *.js setl omnifunc=ternjs#Complete

    AutocmdFT javascript
      \  Autocmd BufNewFile,BufEnter <buffer> TernjsRun
      \| Autocmd VimLeavePre <buffer> TernjsStop
  endif
  " JSDoc
  if dein#tap('vim-jsdoc')
    AutocmdFT javascript nmap <buffer> ,C <Plug>(jsdoc)

    function! s:vimJsdocOnSource() abort
      let g:jsdoc_enable_es6 = 1
      let g:jsdoc_allow_input_prompt = 1
      let g:jsdoc_input_description = 1
      let g:jsdoc_additional_descriptions = 0
      let g:jsdoc_return_description = 0
    endfunction

    Autocmd User dein#source#vim-jsdoc call s:vimJsdocOnSource()
  endif

" HTML
  AutocmdFT html iabbrev <buffer> & &amp;
  AutocmdFT html setl includeexpr=substitute(v:fname,'^\\/','','') path+=./;/
  " Indent
  AutocmdFT html setl textwidth=120 | Indent 2
  " Syntax
  if dein#tap('html5.vim')
    Autocmd User dein#source#html5.vim
      \  hi link htmlError    htmlTag
      \| hi link htmlTagError htmlTag
  endif
  if dein#tap('MatchTag')
    Autocmd Syntax xml runtime! ftplugin/xml.vim
    Autocmd Syntax twig,blade runtime! ftplugin/html.vim
  endif
  " Autocomplete
  AutocmdFT html setl omnifunc=htmlcomplete#CompleteTags
  if dein#tap('emmet-vim')
    AutocmdFT html,twig call s:emmetMappings()

    function! s:emmetMappings() abort
      imap <silent> <buffer> <Tab> <C-r>=<SID>emmetComplete("\<Tab>")<CR>
    endfunction

    function! s:emmetComplete(key) abort
      if pumvisible()
        return "\<C-n>"
      endif
      if emmet#isExpandable()
        let isBackspace = getline('.')[getcurpos()[4]-2] =~ '\s'
        if !isBackspace
          return emmet#expandAbbr(0, '')
        endif
      endif
      if exists('*s:neoComplete')
        return <SID>neoComplete(a:key)
      endif
      return a:key
    endfunction

    function! s:emmetVimOnSource() abort
      let g:user_emmet_mode = 'i'
      let g:user_emmet_complete_tag = 0
      let g:user_emmet_install_global = 0
    endfunction

    Autocmd User dein#source#emmet-vim call s:emmetVimOnSource()
  endif
  if dein#tap('vim-closetag')
    Autocmd BufReadPre *.{html,twig,xml} call dein#source(['vim-closetag'])
  endif

" Twig
  Autocmd BufNewFile,BufRead *.*.twig,*.twig setl filetype=twig commentstring={#<!--%s-->#}
  " Indent
  AutocmdFT twig setl textwidth=120 | Indent 2
  " Syntax
  if dein#tap('twig.vim')
    function! s:twigOnSource() abort
      Autocmd Syntax twig runtime! syntax/html.vim
      Autocmd Syntax twig
        \  hi twigVariable  guifg=#2B2B2B gui=bold
        \| hi twigStatement guifg=#008080 gui=NONE
        \| hi twigOperator  guifg=#999999 gui=NONE
        \| hi link twigBlockName twigVariable
        \| hi link twigVarDelim  twigOperator
        \| hi link twigTagDelim  twigOperator
    endfunction

    Autocmd User dein#source#twig.vim call s:twigOnSource()
  endif

" Blade
  Autocmd BufNewFile,BufRead *.blade.php setl filetype=blade commentstring={{--%s--}}
  " Indent
  AutocmdFT blade setl textwidth=120 | Indent 2
  " Syntax
  if dein#tap('vim-blade')
    function! s:vimBladeOnSource() abort
      Autocmd Syntax blade
        \  hi bladeEcho          guifg=#2B2B2B gui=bold
        \| hi bladeKeyword       guifg=#008080 gui=NONE
        \| hi bladePhpParenBlock guifg=#999999 gui=NONE
        \| hi link bladeDelimiter phpParent
      " Reset SQL syntax
      Autocmd Syntax blade
        \  hi link sqlStatement phpString
        \| hi link sqlKeyword   phpString
    endfunction

    Autocmd User dein#source#vim-blade call s:vimBladeOnSource()
  endif

" CSS
  Autocmd BufNewFile,BufRead *.scss setl filetype=css commentstring=/*%s*/
  AutocmdFT css setl nonu nornu
  " Indent
  AutocmdFT css setl nowrap | Indent 2
  " Syntax
  AutocmdFT css setl iskeyword+=-,%
  if dein#tap('css.vim')
    function! s:cssOnSource() abort
      Autocmd Syntax css
        \  hi link cssError Normal
        \| hi link cssBraceError Normal
        \| hi link cssDeprecated Normal
    endfunction

    Autocmd User dein#source#css.vim call s:cssOnSource()
  endif
  " Autocomplete
  AutocmdFT css setl omnifunc=csscomplete#CompleteCSS
  if dein#tap('vim-hyperstyle')
    Autocmd BufNewFile,BufRead *.{css,scss} call s:hyperstyleReset()

    function! s:hyperstyleReset()
      let b:hyperstyle = 1
      let b:hyperstyle_semi = ' '

      for char in split("<BS> <CR> <Tab> <Space> ; :")
        exe printf('silent! iunmap <buffer> %s', char)
      endfor | unlet char

      imap <buffer> <expr> <Space>
        \ getline('.')[getcurpos()[4]-2] =~ '[; ]' ? "\<Space>" : "\<Space>\<Plug>(hyperstyle-tab)"
      if exists('*neoComplete')
        imap <silent> <buffer> <Tab> <C-r>=<SID>neoComplete("\<Tab>")<CR>
      endif
    endfunction
  endif

" JSON
  Autocmd BufNewFile,BufRead .{babelrc,eslintrc} setl filetype=json
  AutocmdFT json setl nonu nornu
  " Indent
  AutocmdFT json
    \ Autocmd BufEnter,WinEnter <buffer> setl formatoptions+=2l | Indent 2
  " Syntax
  if dein#tap('vim-json')
    AutocmdFT json
      \ nnoremap <silent> <buffer> ,c :<C-u>let &l:conceallevel = (&l:conceallevel == 0 ? 2 : 0)<CR>
        \:echo printf(' Conceal mode: %3S (local)', (&l:conceallevel == 0 ? 'Off' : 'On'))<CR>

    function! s:vimJsonOnSource() abort
      let g:vim_json_warnings = 0
      let g:vim_json_syntax_concealcursor = 'n'

      Autocmd Syntax json
        \  syntax match jsonComment "//.\{-}$"
        \| hi link jsonComment Comment
    endfunction

    Autocmd User dein#source#vim-json call s:vimJsonOnSource()
  endif

" Yaml
  AutocmdFT yaml setl nowrap | Indent 2

" XML
  Autocmd BufNewFile,BufRead *.xml.* setl filetype=xml
  " Syntax
  AutocmdFT xml setl nowrap | Indent 4
  " Autocomplete
  AutocmdFT xml setl omnifunc=xmlcomplete#CompleteTags

" MySQL
  if dein#tap('vim-sql-syntax')
    function! s:vimSqlSyntaxOnSource() abort
      Autocmd Syntax php
        \  hi link sqlStatement phpStatement
        \| hi link sqlKeyword   phpOperator
    endfunction

    Autocmd User dein#source#vim-sql-syntax call s:vimSqlSyntaxOnSource()
  endif

" Nginx
  Autocmd BufNewFile,BufRead */nginx/** setl filetype=nginx commentstring=#%s

" Vagrant
  Autocmd BufNewFile,BufRead Vagrantfile setl filetype=ruby

" Vim
  AutocmdFT vim setl iskeyword+=: | Indent 2

" GUI
"---------------------------------------------------------------------------
  if has('gui_running')
    if has('vim_starting')
        winsize 190 34 | winpos 492 326
        " winsize 176 34 | winpos 492 326
    endif
    set guioptions=ac
    set guicursor=a:blinkon0  " turn off blinking the cursor
    set linespace=3           " extra spaces between rows

    " Font
    if s:is_windows
      set guifont=Droid_Sans_Mono:h10,Consolas:h11
    else
      set guifont=Droid\ Sans\ Mono\ 10,Consolas\ 11
    endif
  endif

  " DirectWrite
  if s:is_windows && has('directx')
    set renderoptions=type:directx,gamma:2.2,contrast:0.5,level:0.0,geom:1,taamode:1,renmode:3
  endif

" View
"---------------------------------------------------------------------------
  " Don't override colorscheme on reloading
  if !exists('g:colors_name')
    silent! colorscheme topos
    " Reload the colorscheme whenever we write the file
    exe 'Autocmd BufWritePost '. g:colors_name .'.vim colorscheme '. g:colors_name
  endif

  set shortmess=aoOtTIc
  set number relativenumber     " show the line number
  set nocursorline             " highlight the current line
  set hidden                   " allows the closing of buffers without saving
  set switchbuf=useopen,split  " orders to open the buffer
  set showtabline=1            " always show the tab pages
  set noequalalways            " resize windows as little as possible
  set winminheight=0
  set splitbelow splitright

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

  " Folding
  set nofoldenable
  " Diff
  set diffopt=filler,iwhite,vertical

  " Highlight invisible symbols
  set nolist listchars=precedes:<,extends:>,nbsp:.,tab:+-,trail:•
  " Avoid showing trailing whitespace when in Insert mode
  let s:trailchar = matchstr(&listchars, '\(trail:\)\@<=\S')
  Autocmd InsertEnter * exe 'setl listchars+=trail:'. s:trailchar
  Autocmd InsertLeave * exe 'setl listchars-=trail:'. s:trailchar

  " Title-line
  set title titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)

  " Command-line
  set cmdheight=1
  set noshowmode   " don't show the mode ('-- INSERT --') at the bottom
  set wildmenu wildmode=longest,full

  " Status-line
  set laststatus=2
  " Format the statusline
  let &statusline =
    \  "%3*%(%{exists('*SignatureMarksIndent') ? SignatureMarksIndent() : ' '}\%L %)%*"
    \. "%l%3*:%*%v "
    \. "%-0.60t "
    \. "%3*%(%{IfFit(70) ? expand('%:~:.:h') : ''}\ %)%*"
    \. "%2*%(%{exists('*BufModified') ? BufModified() : ''}\ %)%*"
    \. "%="
    \. "%1*%(%{IfFit(90) && exists('*GitStatus') ? GitStatus() : ''}\ %)%*"
    \. "%(%{IfFit(90) && exists('*GitBranch') ? GitBranch() : ''}\ %)"
    \. "%(%{IfFit(100) && exists('*ReanimateIsSaved') ? ReanimateIsSaved() : ''}\ %)"
    \. "%(%{IfFit(100) && exists('*FileSize') ? FileSize() : ''}\ %)"
    \. "%2*%(%{IfFit(100) && &paste ? '[P]' : ''}\ %)%*"
    \. "%2*%(%{IfFit(100) ? &iminsert ? 'RU' : 'EN' : ''}\ %)%*"
    \. "%(%{IfFit(90) ? !empty(&fileencoding) ? &fileencoding : &encoding : ''}\ %)"
    \. "%2*%(%Y\ %)%*"

  " Status-line functions
  function! IfFit(width)
    return winwidth(0) > a:width
  endfunction

  function! BufModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! FileSize()
    let size = &encoding ==# &fileencoding || &fileencoding ==# ''
      \ ? line2byte(line('$') + 1) - 1
      \ : getfsize(expand('%:p'))
    return size <= 0 ? '' :
      \ size < 1024 ? size.'B' : (size / 1024).'K'
  endfunction

  function! SignatureMarksIndent()
    return exists('b:sig_marks') && len(b:sig_marks) > 0 ? repeat(' ', 4) : ' '
  endfunction

  function! ReanimateIsSaved()
    return exists('*reanimate#is_saved()') && reanimate#is_saved()
      \ ? matchstr(reanimate#last_point(), '.*/\zs.*') : ''
  endfunction

  function! GitBranch()
    return exists('*gita#statusline#preset') ? matchstr(gita#statusline#preset('branch_short'), '.*/\zs.*') : ''
  endfunction

  function! GitTraffic()
    return gita#statusline#preset('traffic')
  endfunction

  function! GitStatus()
    return exists('*gita#statusline#preset') ? gita#statusline#preset('status') : ''
  endfunction

" Edit
"---------------------------------------------------------------------------
  set report=0           " reporting number of lines changes
  set lazyredraw         " don't redraw while executing macros
  set nostartofline      " avoid moving cursor to BOL when jumping around
  set virtualedit=all    " allows the cursor position past true end of line
  " set clipboard=unnamed  " use * register for copy-paste

  " Keymapping timeout (mapping / keycode)
  set notimeout ttimeoutlen=100

  " Indent
  set cindent          " smart indenting for c-like code
  set autoindent       " indent at the same level of the previous line
  set shiftround       " indent multiple of shiftwidth
  set expandtab        " spaces instead of tabs
  set tabstop=2        " number of spaces per tab for display
  set shiftwidth=2     " number of spaces per tab in insert mode
  set softtabstop=2    " number of spaces when indenting
  set nojoinspaces     " prevents inserting two spaces after punctuation on a join (J)
  " Backspacing setting
  set backspace=indent,eol,start

  " Search
  set hlsearch         " highlight search results
  set incsearch        " find as you type search
  set ignorecase
  set smartcase
  set magic            " change the way backslashes are used in search patterns
  set gdefault         " flag 'g' by default for replacing

  " Autocomplete
  set complete=.
  set completeopt=longest
  set pumheight=14
  " Syntax complete if nothing else available
  Autocmd BufEnter,WinEnter * if &omnifunc == ''| setl omnifunc=syntaxcomplete#Complete |endif

" Shortcuts
"---------------------------------------------------------------------------
  " Insert the current file
  iab <silent> ##f <C-r>=expand('%:t:r')<CR>
  ca ##f <C-r>=expand('%:t:r')<CR>
  " Insert the current file path
  ia <silent> ##p <C-r>=expand('%:p')<CR>
  ca ##p <C-r>=expand('%:p')<CR>
  " Insert the current file directory
  ia <silent> ##d <C-r>=expand('%:p:h').'\'<CR>
  ca ##d <C-r>=expand('%:p:h').'\'<CR>
  " Inset the current timestamp
  ia <silent> ##t <C-r>=strftime('%Y-%m-%d')<CR>
  ca ##t <C-r>=strftime('%Y-%m-%d')<CR>
  " Inset the current Unix time
  ia <silent> ##l <C-r>=localtime()<CR>
  ca ##l <C-r>=localtime()<CR>
  " Shebang
  ia <silent> <expr> ##! '#!/usr/bin/env' . (empty(&filetype) ? '' : ' '.&filetype)

" Normal mode
"---------------------------------------------------------------------------
  " jk: don't skip wrap lines
  nnoremap <expr> j v:count ? 'gj' : 'j'
  nnoremap <expr> k v:count ? 'gk' : 'k'
  " Alt-[jkhl]: move selected lines
  nnoremap <silent> <A-j> :<C-u>move+<CR>
  nnoremap <silent> <A-k> :<C-u>move-2<CR>
  nnoremap <A-h> <<<Esc>
  nnoremap <A-h> <<<Esc>
  nnoremap <A-l> >>><Esc>
  " Q: auto indent text
  nnoremap Q ==
  " @: record macros
  nnoremap @ q
  " Ctrl-[jk]: scroll up/down 1/3 page
  nnoremap <expr> <C-j> v:count ? "\<C-d>" : winheight('.') / (3 + 1). "\<C-d>"
  nnoremap <expr> <C-k> v:count ? "\<C-u>" : winheight('.') / (3 + 1). "\<C-u>"
  " [dDcC]: don't update register
  nnoremap d "_d
  nnoremap D "_D
  nnoremap c "_c
  nnoremap C "_C
  nnoremap dd dd
  " nnoremap x "_x
  " nnoremap X "_dd

  " gu: capitalize
  nnoremap gu gUiw`]
  " gr: replace word under the cursor
  nnoremap gr :<C-u>%s/<C-r><C-w>/<C-r><C-w>/g<left><left>
  " g.: smart replace word under the cursor
  nnoremap <silent> g. :<C-u>let @/=escape(expand('<cword>'),'$*[]/')<CR>cgn
  " gl: select last changed text
  nnoremap gl `[v`]
  " gp: select last paste in visual mode
  nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
  " gv: last selected text operator
  onoremap gv :<C-u>normal! gv<CR>
  " gy: replace last yanked selected text
  nnoremap <expr> gy ':<C-u>%s/' . @" . '//g<Left><Left>'

  " Ctrl-c: clear highlight after search
  nnoremap <silent> <C-c> :<C-u>let @/ = ""<CR>
  " [N]+Enter: jump to a line number or mark
  nnoremap <silent> <expr> <Enter> v:count ?
    \ ':<C-u>call cursor(v:count, 0)<CR>zz' : "\'"

  if exists(':FixWhitespace')
    " ,<Space>: remove spaces at the end of lines
    nnoremap <silent> ,<Space> :<C-u>FixWhitespace<CR>
  endif

  " Buffers
  "-----------------------------------------------------------------------
  " <Space>A: next buffer
  nnoremap <silent> <Space>A :<C-u>bnext<CR>
  " <Space>E: previous buffer
  nnoremap <silent> <Space>E :<C-u>bprev<CR>
  " <Space>d: delete buffer
  nnoremap <silent> <Space>d :<C-u>bdelete<CR>
  " <Space>D: force delete buffer
  nnoremap <silent> <Space>D :<C-u>bdelete!<CR>
  " <Space>i: jump to alternate buffer
  nnoremap <silent> <Space>i <C-^>

  " Files
  "-----------------------------------------------------------------------
  " ,ev: open .vimrc in a new tab
  nnoremap <silent> ,ev :<C-u>tabnew $MYVIMRC<CR>
  " Ctrl-Enter: save file
  nnoremap <silent> <C-Enter> :<C-u>write!<CR>
  " Shift-Enter: force save file
  nnoremap <silent> <S-Enter> :<C-u>update!<CR>
  " ;e: reopen file
  nnoremap <silent> ;e :<C-u>edit<CR>
  " ;E: force reopen file
  nnoremap <silent> ;E :<C-u>edit!<CR>

  " Tabs
  "-----------------------------------------------------------------------
  " <Space>1-9: jumps to a tab number
  for n in range(1, 9)
    exe printf('nnoremap <silent> <nowait> <Space>%d %dgt', n, n)
  endfor | unlet n
  " <Space>a: previous tab
  nnoremap <silent> <Space>a :<C-u>tabprev<CR>
  " <Space>e: next tab
  nnoremap <silent> <Space>e :<C-u>tabnext<CR>
  " [N]+<Space>c: close tab
  nnoremap <silent> <expr> <Space>c v:count
    \ ? ':<C-u>'.v:count.'tabclose<CR>'
    \ : ':<C-u>tabclose<CR>'
  " [N]+<Space>C: force close tab
  nnoremap <silent> <expr> <Space>c v:count
    \ ? ':<C-u>'.v:count.'tabclose!<CR>'
    \ : ':<C-u>tabclose!<CR>'
  nnoremap <silent> <Space>C :<C-u>tabclose!<CR>
  " <Space>o: tab only
  nnoremap <silent> <Space>o :<C-u>tabonly<CR>
  " <Space>m: tab move
  nnoremap <silent> <Space>m :<C-u>tabmove<CR>
  " <Space>t: tab new
  nnoremap <silent> <Space>t :<C-u>tabnew<CR>:normal! <C-o><CR>
  " <Space>T: tab new and move
  nnoremap <silent> <Space>T :<C-u>tabnew<CR>:tabmove<CR>:normal! <C-o><CR>
  " <Space><: move tab to first spot
  nnoremap <silent> <Space>< :<C-u>tabmove 0<CR>
  " <Space>>: move tab to last spot
  nnoremap <silent> <expr> <Space>> ':<C-u>tabmove '.tabpagenr('$').'<CR>'
  " <Space>,: move tab to left
  nnoremap <silent> <expr> <Space>,
    \ ':<C-u>tabmove '.max([tabpagenr() - v:count1 - 1, 0]).'<CR>'
  " <Space>.: move tab to right
  nnoremap <silent> <expr> <Space>.
    \ ':<C-u>tabmove '.min([tabpagenr() + v:count1, tabpagenr('$')]).'<CR>'

  " Windows
  "-----------------------------------------------------------------------
  for char in split('h j k l')
    " <Space>[hjkl]: jump to a window
    exe printf('nnoremap <silent> <Space>%s :<C-u>wincmd %s<CR>', char, char)
    " <Space>[HJKL]: move the current window
    exe printf('nnoremap <silent> <Space>%s :<C-u>wincmd %s<CR>', toupper(char), toupper(char))
  endfor | unlet char
  " <Space>w: next window
  nnoremap <silent> <Space>w :<C-u>wincmd w<CR>
  " <Space>W: previous window
  nnoremap <silent> <Space>W :<C-u>wincmd W<CR>
  " <Space>I: previous (last accessed) window
  nnoremap <silent> <Space>I :<C-u>wincmd p<CR>
  " <Space>r: rotate windows downwards/rightwards
  nnoremap <silent> <Space>r :<C-u>wincmd r<CR>
  " <Space>R: rotate windows upwards/leftwards
  nnoremap <silent> <Space>R :<C-u>wincmd R<CR>
  " <Space>n: set current window to highest possible
  nnoremap <silent> <Space>n :<C-u>wincmd _<CR>
  " <Space>b: make all windows (almost) equally high and wide
  nnoremap <silent> <Space>b :<C-u>wincmd =<CR>
  " >: increase current window height
  nnoremap <silent> > :<C-u>resize +3<CR>
  " <: decrease current window height
  nnoremap <silent> < :<C-u>resize -3<CR>
  " <Space>m: move window to a new tab page
  nnoremap <silent> <Space>m :<C-u>wincmd T<CR>
  " <Space>q: smart close window -> tab -> buffer
  nnoremap <silent> <expr> <Space>q winnr('$') == 1
    \ ? printf(':<C-u>%s<CR>', (tabpagenr('$') == 1 ? 'bdelete!' : 'tabclose!'))
    \ : ':<C-u>close<CR>'
  " <Space>Q: force smart close window -> tab -> buffer
  nnoremap <silent> <expr> <Space>Q winnr('$') == 1
    \ ? printf(':<C-u>%s<CR>', (tabpagenr('$') == 1 ? 'bdelete!' : 'tabclose!'))
    \ : ':<C-u>close!<CR>'
  " <Space>s: split window horizontaly
  nnoremap <silent> <expr> <Space>s ':<C-u>'. (v:count == 0 ? '' : v:count) .'split<CR>'
  " <Space>S: split window verticaly
  nnoremap <silent> <expr> <Space>S ':<C-u>vertical '. (v:count == 0 ? '' : v:count) .'split<CR>'

  if exists(':GoldenRatio')
    " ,g: golden ratio
    nnoremap <silent> ,g :<C-u>GoldenRatio<CR>
    nnoremap <silent> <Space>g :<C-u>GoldenRatio<CR>
  endif

  " Text objects
  "-----------------------------------------------------------------------
  " vi
  for char in split("' \" ` ( [ { <")
    exe printf('nmap ;%s <Esc>vi%s', char, char)
  endfor | unlet char
  " va
  for char in split(") ] } >")
    exe printf('nmap ;%s <Esc>va%s', char, char)
  endfor | unlet char

  " Unbinds
  "-----------------------------------------------------------------------
  for char in split("<F1> ZZ ZQ")
    exe printf('map %s <Nop>', char)
  endfor | unlet char
  nmap ` <Nop>

" Insert mode
"---------------------------------------------------------------------------
  " Alt-[jkhl]: standart move
  imap <A-j> <C-o>gj
  imap <A-h> <C-o>h
  imap <A-k> <C-o>gk
  imap <A-l> <C-o>l
  " Ctrl-a: jump to head
  inoremap <C-a> <C-o>I
  " Ctrl-e: jump to end
  inoremap <C-e> <C-o>A
  " Ctrl-b: jump back to beginning of previous wordmp to first char
  inoremap <C-q> <Home>
  " Ctrl-<BS>: delete word
  inoremap <C-d> <BS>
  " Ctrl-f: delete next char
  inoremap <C-f> <Del>
  " Ctrl-Enter: break line below
  inoremap <C-CR> <Esc>O
  " Shift-Enter: break line above
  inoremap <S-CR> <C-m>
  " jj: fast Esc
  inoremap <expr> j getline('.')[getcurpos()[4]-2] ==# 'j' ? "\<BS>\<Esc>`^" : "\j"
  " Ctrl-l: fast Esc
  inoremap <C-l> <Esc>`^
  " Ctrl-c: old fast Esc
  inoremap <C-c> <Esc>`^
  " Ctrl-_: undo
  inoremap <C-_> <C-o>u
  " Ctrl-p: paste
  imap <C-p> <S-Insert>
  " Ctrl+s: force save file
  inoremap <silent> <C-s> <Esc> :write!<CR>i
  " Alt+w: force save file
  inoremap <silent> <A-w> <Esc> :write!<CR>i
  " Alt-q: change language
  inoremap <A-q> <C-^>
  " qq: smart fast Esc
  imap <expr> q getline('.')[getcurpos()[4]-2] ==# 'q' ? "\<BS>\<Esc>`^" : "\q"

" Visual mode
"---------------------------------------------------------------------------
  " jk: don't skip wrap lines
  xnoremap <expr> j v:count && mode() ==# 'V' ? 'j' : 'gj'
  xnoremap <expr> k v:count && mode() ==# 'V' ? 'k' : 'gk'
  " Alt-[jkhl]: move selected lines
  xnoremap <silent> <A-j> :move'>+<CR>gv
  xnoremap <silent> <A-k> :move-2<CR>gv
  xnoremap <A-h> <'[V']
  xnoremap <A-l> >'[V']
  " L: move to end of line
  xnoremap L $h
  " Q: auto indent text
  xnoremap Q ==<Esc>
  " <Space>: fast Esc
  snoremap <Space> <Esc>
  xnoremap <Space> <Esc>
  " Alt-w: fast save
  xmap <silent> <A-w> <Esc> :update<CR>
  " Ctrl-s: old fast save
  xmap <C-s> <Esc> :write!<CR>
  " Ctrl-[jk]: scroll up/down
  xnoremap <C-j> <C-d>
  xnoremap <C-k> <C-u>
  " @: repeat macro for each line
  vnoremap @ :normal @
  " [yY]: keep cursor position when yanking
  xnoremap <silent> <expr> y 'ygv'. mode()
  xnoremap <silent> <expr> Y 'Ygv'. mode()
  " Ctrl-c: copy
  xnoremap <C-c> y`]
  " <BS>: delete selected and go into insert mode
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
  cnoremap ` <C-c>
  cnoremap <C-c> <C-c>

" Experimental
"---------------------------------------------------------------------------
  " ,p: toggle paste mode
  nnoremap <silent> ,p :<C-u>let &paste = !&paste<CR>
    \:echo printf(' Paste mode: %3S (global)', (&paste == 1 ? 'On' : 'Off'))<CR>

  " ,o: toggle wrapping of text (local)
  nnoremap <silent> ,o :<C-u>let &l:wrap = !&l:wrap<CR>
    \:echo printf(' Wrap mode: %3S (local)', (&l:wrap == 1 ? 'On' : 'Off'))<CR>

  " ,n: toggle show line numbers
  nnoremap <silent> ,n :<C-u>let [&l:nu, &l:rnu] = &l:nu ? [0, 0] : [1, 1]<CR>
    \:echo printf(' Show line number: %3S (local)', (&l:nu == 1 ? 'On' : 'Off'))<CR>

  " [nN]: append blank line and space
  nnoremap <silent> <expr> n v:count ?
    \ ":\<C-u>for i in range(1, v:count1) \| call append(line('.'), '') \| endfor\<CR>" : 'i<Space><Esc>'
  nnoremap <silent> <expr> N v:count ?
    \ ":\<C-u>for i in range(1, v:count1) \| call append(line('.')-1, '') \| endfor\<CR>" : 'i<Space><Esc>`^'

  " ): jump to next pair
  nnoremap ) f)
  " (: jump to previous pair
  nnoremap ( F(

  " mode()[0] =~ 'i\|R'
  xnoremap <expr> } mode() == '<c-v>' ? line("'}") - 1 . 'G' : '}'
  xnoremap <expr> { mode() == '<c-v>' ? line("'{") + 1 . 'G' : '{'

  " [#*]: make # and * work in visual mode too
  vnoremap # y?<C-r>*<CR>
  vnoremap * y/<C-r>*<CR>

  " ,yn: copy file name to clipboard (foo/bar/foobar.c => foobar.c)
  nnoremap <silent> ,yn :<C-u>let @*=fnamemodify(bufname('%'),':p:t')<CR>
  nnoremap <silent> ,yp :<C-u>let @*=fnamemodify(bufname('%'),':p')<CR>

  " ,r: replace a word under cursor
  noremap ,r :%s/<C-R><C-w>/<C-r><C-w>/g<left><left>
  " :s::: is more useful than :s/// when replacing paths
  " https://github.com/jalanb/dotjab/commit/35a40d11c425351acb9a31d6cff73ba91e1bd272
  noremap ,R :%s:::<Left><Left>

  xnoremap re y:%s/<C-r>=substitute(@0, '/', '\\/', 'g')<CR>//gI<Left><Left><Left>

  " Alt-q: delete line
  inoremap <silent> <A-q> <C-o>$<C-u>
  " Atl-d: duplicate line
  inoremap <silent> <A-d> <Esc>mxyyp`x:delmarks x<CR>:sleep 100m<CR>a
  " Ctrl-d: duplicate line
  nnoremap <expr> <C-d> 'yyp'. col('.') .'l'
  " Ctrl-d: duplicate line
  vnoremap <C-d> :t'><CR>
