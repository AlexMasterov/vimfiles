" vimrc
" Source: https://github.com/AlexMasterov/vimfiles
" Author: Alex Masterov <alex.masterow@gmail.com>

if has('reltime') && has('vim_starting')
  " Shell: vim --startuptime filename -q; vim filename
  " vim --cmd 'profile start profile.txt' --cmd 'profile file $HOME/.vimrc' +q && vim profile.txt
  let s:startupTime = reltime()
  autocmd VimEnter * let s:startupTime = reltime(s:startupTime)
                  \| redraw | echomsg reltimestr(s:startupTime)
endif

" Initialize autogroup
  augroup MyVimrc
    autocmd!
  augroup END

" Environment
"---------------------------------------------------------------------------
  let $VIMFILES = expand('~/vimfiles')
  let $VIMHOME = expand((has('nvim') ? '~/.nvim' : '~/.vim'))
  let $DATA  = $VIMHOME . (has('nvim') ? '/shada' : '/viminfo')
  let $CACHE = $VIMHOME . '/.cache'

  set runtimepath=$VIMFILES,$VIMRUNTIME,$PATH

  set nocompatible
  set nomodeline modelines=0  " prevents security exploits
  set noexrc                  " avoid reading local (g)vimrc, exrc
  set packpath=
  set pyxversion=3
  set regexpengine=2          " 0=auto 1=old 2=NFA
  set termguicolors

  if has('nvim')
    set nofsync
    set inccommand=split
    set clipboard+=unnamedplus
    let &shada = "!,'300,<50,s10,h,n" . $DATA
  else
    let &viminfo = "!,'300,<50,s10,h,n" . $DATA
  endif

  " Disable bell
  set t_vb= belloff=all novisualbell

  " Russian keyboard
  set keymap=russian-jcukenwin
  set iskeyword=@,48-57,_,192-255
  set iminsert=0 imsearch=0

  " Undo
  set undodir=$CACHE/undo
  set undofile undolevels=500 undoreload=1000
  call vimrc#makeDir(&undodir, '!')

  " View
  set viewdir=$CACHE/view
  set viewoptions=cursor,slash,unix

  " Tmp
  set noswapfile
  set directory=$CACHE

" Functions
"---------------------------------------------------------------------------
  let s:isWindows = has('win64') || has('win32') || has('win32unix')
  function! IsWindows() abort
    return s:isWindows
  endfunction

  function! IsMac() abort
    return !s:is_windows
      \ && (has('mac') || has('macunix') || has('gui_macvim')
      \   || (!executable('xdg-open') && system('uname') =~? '^darwin'))
  endfunction

" Commands
"---------------------------------------------------------------------------
  command! -nargs=* Autocmd   autocmd MyVimrc <args>
  command! -nargs=* AutocmdFT autocmd MyVimrc FileType <args>
  command! -nargs=1 Indent
    \ execute 'setlocal tabstop='.<q-args> 'softtabstop='.<q-args> 'shiftwidth='.<q-args>
  command! -nargs=0 -bar GoldenRatio exe 'vertical resize' &columns * 5 / 8
   " Shows the syntax stack under the cursor
  command! -bar SS echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

  " TrimWhiteSpace
  command! -nargs=* -complete=file TrimWhiteSpace f <args> | call vimrc#trimWhiteSpace()
  Autocmd BufWritePre,FileWritePre *? call vimrc#trimWhiteSpace()
  nnoremap <silent> ,<Space> :<C-u>TrimWhiteSpace<CR>

  " Mkdir
  command! -nargs=1 -bang MakeDir call vimrc#makeDir(<f-args>, "<bang>")
  " Autocmd BufWritePre,FileWritePre *? call vimrc#makeDir('<afile>:h', v:cmdbang)

" Events
"---------------------------------------------------------------------------
  " if exists('$MYVIMRC')
  "   Autocmd BufWritePost $MYVIMRC | source $MYVIMRC | redraw
  " endif
  Autocmd Syntax * if 5000 < line('$') | syntax sync minlines=200 | endif
  Autocmd VimEnter * filetype plugin indent on
  Autocmd VimEnter * call histdel(':', '^w\?q\%[all]!\?$')
  Autocmd WinEnter * checktime
  Autocmd WinLeave *? let [&l:number, &l:relativenumber] = &l:number ? [1, 0] : [&l:number, &l:relativenumber]
  Autocmd WinEnter *? let [&l:number, &l:relativenumber] = &l:number ? [1, 1] : [&l:number, &l:relativenumber]
  Autocmd InsertEnter *? setlocal list
  Autocmd InsertLeave *? setlocal nolist
  AutocmdFT *? setlocal formatoptions-=ro

" Encoding
"---------------------------------------------------------------------------
  set encoding=utf-8
  setglobal fileencodings=utf-8
  scriptencoding utf-8

  if IsWindows()
    set fileencodings=utf-8,cp1251
    set termencoding=cp850  " cmd.exe uses cp850
  else
    set termencoding=       " same as 'encoding'
  endif

  " Default fileformat
  set fileformat=unix
  set fileformats=unix,dos,mac

  " Open in UTF-8
  command! -nargs=? -bar -bang -complete=file EUtf8
    \ edit<bang> ++enc=utf-8 <args>
  " Open in CP1251
  command! -nargs=? -bar -bang -complete=file ECp1251
    \ edit<bang> ++enc=cp1251 <args>

  " Write as Unix
  command! -nargs=? -bar -bang -complete=file WUnix
    \ write<bang> ++fileformat=unix <args> | edit <args>
  " Write as Dos
  command! -nargs=? -bar -bang -complete=file WDos
    \ write<bang> ++fileformat=dos <args> | edit <args>

" Plugins
" ---------------------------------------------------------------------------
  " Disable built-in plugins
  let g:loaded_csv = 1
  let g:loaded_gzip = 1
  let g:loaded_zipPlugin = 1
  let g:loaded_tarPlugin = 1
  let g:loaded_logiPat = 1
  let g:loaded_rrhelper = 1
  let g:loaded_matchparen = 1
  let g:loaded_parenmatch = 1
  let g:loaded_netrwPlugin = 1
  let g:loaded_2html_plugin = 1
  let g:loaded_vimballPlugin = 1
  let g:loaded_getscriptPlugin = 1
  let g:loaded_spellfile_plugin = 1
  let g:did_install_syntax_menu = 1
  let g:did_install_default_menus = 1

  " Setup Dein plugin manager
  let s:deinPath = $VIMHOME . '/dein'
  if has('vim_starting')
    let s:deinRepo = s:deinPath . '/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:deinRepo)
      if executable('git')
        call system('git clone --single-branch --depth 1 https://github.com/Shougo/dein.vim.git ' . fnameescape(s:deinRepo))
      else
        echom 'Can`t download Dein: Git not found.'
      endif
    endif
    execute 'set runtimepath^=' . fnameescape(s:deinRepo)
  endif

  if dein#load_state(s:deinPath)
    call dein#begin(s:deinPath, [expand('<sfile>')])

    let plugins = [
      \ 'plugins',
      \ 'nvim_rpc',
      \ 'defx',
      \ 'caw',
      \ 'gina',
      \ 'choosewin',
      \ 'ale',
      \ 'neomake',
      \ 'denite',
      \ 'operators',
      \ 'easymotion',
      \ 'colorizer',
      \ 'deoplete',
      \ 'ultisnips',
      \ 'text_objects',
      \ 'lang/javascript',
      \ 'lang/typescript',
      \ 'lang/rust',
      \ 'lang/php',
      \ 'lang/json',
      \ 'lang/yaml',
      \ 'lang/html',
      \ 'lang/css',
      \ 'lang/csv',
      \ 'lang/svg',
      \ ]

    for plugin in plugins
      call dein#load_toml(printf('%s/dein/%s.toml', $VIMFILES, plugin))
    endfor | unlet plugin plugins

    call dein#end()
    call dein#save_state()
  endif

 if !has('vim_starting')
  call dein#call_hook('source')
  call dein#call_hook('post_source')

  syntax enable
  filetype plugin indent on
 endif

" Modules
" ---------------------------------------------------------------------------
  let modules = [
    \ 'gui',
    \ 'view',
    \ 'edit',
    \ 'statusline',
    \ 'mapping',
    \ 'abbr'
    \ ]

  for module in modules
    execute 'source' resolve(printf('%s/modules/%s.vim', $VIMFILES, module))
  endfor | unlet module modules
