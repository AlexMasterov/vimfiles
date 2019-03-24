"--------------------------------------------------------------------------
" Events

if v:vim_did_enter
  filetype plugin indent on
else
  Autocmd VimEnter * filetype plugin indent on
endif

" Disable Visual bell
Autocmd GUIEnter * set t_vb= belloff=all novisualbell

Autocmd Syntax *? if line('$') > 5000 | syntax sync minlines=200 | endif

Autocmd WinEnter * let [&l:number, &l:relativenumber] = &l:number ? [1, 1] : [&l:number, &l:relativenumber]
Autocmd WinLeave * let [&l:number, &l:relativenumber] = &l:number ? [1, 0] : [&l:number, &l:relativenumber]

AutocmdFT *? setlocal formatoptions-=ro

" Highlight invisible symbols
set nolist listchars=precedes:<,extends:>,nbsp:.,tab:+-,trail:•
" Avoid showing trailing whitespace when in Insert mode
let g:trailChar = matchstr(&listchars, '\(trail:\)\@<=\S')
Autocmd InsertEnter * execute 'setlocal list listchars+=trail:' . g:trailChar
Autocmd InsertLeave * execute 'setlocal nolist listchars-=trail:' . g:trailChar

if has('nvim')
  " Share the histories
  Autocmd FocusGained * rshada | wshada
  " Modifiable terminal
  Autocmd TermOpen * setlocal modifiable
  Autocmd TermClose * buffer #
endif
