" vimrc
" Author: Alex Masterov <alex.masterow@gmail.com>
" Source: https://github.com/AlexMasterov/vimfiles

if has('vim_starting')
  " vim --startuptime filename -q; vim filename
  let s:startup_time = reltime()
  autocmd VimEnter * ++once
    \ echomsg reltimestr(reltime(s:startup_time)) | unlet s:startup_time
endif

" Environment
"---------------------------------------------------------------------------
let $VIMFILES = exists('$VIMFILES') ? $VIMFILES : expand('~/vimfiles')
let $VIMHOME = exists('$VIMHOME') ? $VIMHOME : expand('~/.vim')

set packpath=
set runtimepath=$VIMFILES,$VIMRUNTIME,$PATH

set undodir=$VIMHOME/.undo
set viewdir=$VIMHOME/.view
set directory=$VIMHOME/.tmp
set backupdir=$VIMHOME/.backup

" Prevents security exploits
set noexrc nomodeline modelines=0

" Functions
"---------------------------------------------------------------------------
let s:is_windows = has('win64') || has('win32')

function! IsWindows() abort
  return s:is_windows
endfunction

function! Iter(list, on_iter) abort
  for item in a:list | call a:on_iter(item) | endfor
endfunction

function! s:source_rc(path) abort
  execute 'source $VIMFILES/rc/' . a:path
endfunction

" Commands
"---------------------------------------------------------------------------
augroup myVimrc | autocmd! | augroup END

command! -nargs=* -bang Autocmd   autocmd<bang> myVimrc <args>
command! -nargs=* -bang AutocmdFT autocmd<bang> myVimrc FileType <args>

command! -nargs=* -complete=file TrimSpace f <args> | call vimrc#trim_spaces()
command! -nargs=1 -bang MakeDir call vimrc#make_dir(<f-args>, !empty("<bang>"))
command! -nargs=1 Indent
  \ execute 'setlocal tabstop='.<q-args> 'softtabstop='.<q-args> 'shiftwidth='.<q-args>
  "\ let [&l:tabstop, &l:softtabstop, &l:shiftwidth] = repeat([<q-args>], 3)

" Events
"---------------------------------------------------------------------------
Autocmd VimEnter * ++once
  \  filetype plugin indent on
  \| let g:python3_host_prog = exepath('python')

Autocmd BufWritePre,FileWritePre *?
  \  call vimrc#trim_spaces()
  \| call vimrc#make_dir('<afile>:h', v:cmdbang)

" ---------------------------------------------------------------------------
if has('vim_starting')
  call s:source_rc('init.vim')
endif

call s:source_rc('encoding.vim')
call s:source_rc('commands.vim')
call s:source_rc('events.vim')
call s:source_rc('options.vim')
call s:source_rc('statusline.vim')
call s:source_rc('io.vim')

call s:source_rc('dein.vim')

call s:source_rc('keymap-n.vim')
call s:source_rc('keymap-i.vim')
call s:source_rc('keymap-t.vim')
call s:source_rc('keymap-c.vim')
call s:source_rc('keymap.vim')
call s:source_rc('abbr.vim')

if !has('nvim') && has('gui_running')
  call s:source_rc('gui.vim')
endif

if !exists('g:syntax_on')
  syntax on
endif

if !exists('g:colors_name')
  silent! colorscheme mild
endif
