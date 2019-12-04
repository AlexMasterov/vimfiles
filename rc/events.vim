"--------------------------------------------------------------------------
" Events

" Avoid showing trailing whitespace when in Insert mode
function! UpdateTrailCharEvents() abort
  augroup myVimrcI | autocmd! | augroup END

  let trail_char = matchstr(&listchars, '\(trail:\)\@<=\S')
  if strlen(trail_char) > 0
    execute 'autocmd myVimrcI InsertEnter * setlocal list listchars+=trail:'. trail_char
    execute 'autocmd myVimrcI InsertLeave * setlocal nolist listchars-=trail:'. trail_char
  endif
endfunction

function! ToggleNumberLine(nu, rnu) abort
  let [&l:number, &l:relativenumber] = &l:number
        \ ? [a:nu, a:rnu]
        \ : [&l:number, &l:relativenumber]
endfunction

" Disable Visual bell
Autocmd GUIEnter * ++once set noerrorbells novisualbell belloff=all t_vb=

" Check if any buffers were changed outside of Vim
Autocmd FocusGained * if &buftype !=# 'nofile' | checktime | endif

" Reload the colorscheme whenever we write the file
Autocmd ColorSchemePre * execute 'Autocmd! BufWritePost '. g:colors_name .'.vim'
Autocmd ColorScheme    * execute 'Autocmd! BufWritePost '. g:colors_name .'.vim colorscheme '. g:colors_name

Autocmd WinEnter * call ToggleNumberLine(1, 1)
Autocmd WinLeave * call ToggleNumberLine(1, 0)

Autocmd VimEnter * ++once   call UpdateTrailCharEvents()
Autocmd OptionSet listchars call UpdateTrailCharEvents()

Autocmd OptionSet formatoptions setlocal formatoptions-=ro

Autocmd CompleteDone * if pumvisible() ==# 0 | pclose | endif

if has('nvim')
  " Share the histories
  Autocmd FocusGained * rshada | wshada
  " Modifiable terminal
  Autocmd TermOpen * setlocal modifiable
  Autocmd TermClose * buffer #
endif
