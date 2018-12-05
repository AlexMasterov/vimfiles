" vimrc
" Author: Alex Masterov <alex.masterow@gmail.com>
" Source: https://github.com/AlexMasterov/vimfiles

if has('vim_starting')
  " vim --startuptime filename -q; vim filename
  let s:startupTime = reltime()
  autocmd VimEnter * let s:startupTime = reltime(s:startupTime)
                  \| redraw | echomsg reltimestr(s:startupTime)
endif

if &compatible
  set nocompatible
endif

" Prevents security exploits
set nomodeline modelines=0

" Environment
"---------------------------------------------------------------------------
let $VIMFILES = exists('$VIMFILES') ? $VIMFILES : expand('~/vimfiles')
let $VIMHOME = exists('$VIMHOME') ? $VIMHOME : expand('~/.vim')

set noexrc
set packpath=
set runtimepath=$VIMFILES,$VIMRUNTIME,$PATH

" ---------------------------------------------------------------------------
function s:source_rc(path) abort
  execute 'source $VIMFILES/rc/' . a:path
endfunction

if has('vim_starting')
  call s:source_rc('init.vim')
endif

call s:source_rc('encoding.vim')
call s:source_rc('commands.vim')
call s:source_rc('events.vim')
call s:source_rc('options.vim')

call s:source_rc('dein.vim')

call s:source_rc('statusline.vim')
call s:source_rc('keymap.vim')
call s:source_rc('abbr.vim')

if !has('nvim') && has('gui_running')
  call s:source_rc('gui.vim')
endif

if !exists('g:syntax_on') | syntax on | endif
if !exists('g:colors_name')
  silent! colorscheme mild
  " Reload the colorscheme whenever we write the file
  execute 'Autocmd BufWritePost '. g:colors_name '.vim colorscheme '. g:colors_name
endif

if !has('vim_starting')
  call dein#call_hook('source')
  call dein#call_hook('post_source')

  syntax enable
  filetype plugin indent on
endif
