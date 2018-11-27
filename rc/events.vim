"--------------------------------------------------------------------------
" Events

Autocmd VimEnter * filetype plugin indent on

Autocmd Syntax *? if line('$') > 5000 | syntax sync minlines=200 | endif

Autocmd WinEnter * let [&l:number, &l:relativenumber] = &l:number ? [1, 1] : [&l:number, &l:relativenumber]
Autocmd WinLeave * let [&l:number, &l:relativenumber] = &l:number ? [1, 0] : [&l:number, &l:relativenumber]

Autocmd WinEnter,FocusGained * checktime

AutocmdFT *? setlocal formatoptions-=ro

" Highlight invisible symbols
set nolist listchars=precedes:<,extends:>,nbsp:.,tab:+-,trail:•
" Avoid showing trailing whitespace when in Insert mode
let g:trailChars = matchstr(&listchars, '\(trail:\)\@<=\S')

Autocmd InsertEnter * setlocal list
 \| execute 'setlocal listchars+=trail:' . g:trailChars
Autocmd InsertLeave * setlocal nolist
 \| execute 'setlocal listchars-=trail:' . g:trailChars
