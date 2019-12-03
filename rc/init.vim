"---------------------------------------------------------------------------
" Init

filetype on

if has('nvim')
  set shada=!,'50,<50,s10,h,n$VIMHOME/shada
  let &shadafile = $VIMHOME . '/shada'
else
  set viminfo=!,'50,<50,s10,h,n$VIMHOME/viminfo
endif

call histdel(':', '^w\?q\%[all]!\?$')

" Use English interface
language messages C

" Disable built-in plugins
let g:loaded_csv = 1
let g:loaded_gzip = 1
let g:loaded_zipPlugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_parenmatch = 1
let g:loaded_netrwPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_spellfile_plugin = 1
let g:did_install_syntax_menu = 1
let g:did_install_default_menus = 1

" Nvim
let g:loaded_man = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_python_provider = 0

" Setup Dein plugin manager
if &runtimepath !~# '/dein.vim'
  let s:repo = expand('$VIMHOME/dein/repos/github.com/Shougo/dein.vim')
  if !isdirectory(s:repo)
    call system('git clone --depth 1 https://github.com/Shougo/dein.vim.git ' . s:repo)
  endif
  execute 'set runtimepath^=' . s:repo
endif
