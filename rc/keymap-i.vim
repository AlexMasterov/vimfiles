"---------------------------------------------------------------------------
" Keypmap (Insert mode)

" Alt-[jkhl]: standart move
inoremap <A-j> <C-o>gj
inoremap <A-h> <C-o>h
inoremap <A-k> <C-o>gk
inoremap <A-l> <C-o>l

" Ctrl-a: jump to head
inoremap <expr> <C-a> empty(getline('.')[getcurpos()[4] - 2]) ? '<Home>' : '<C-o>I'

" Ctrl-e: jump to end
inoremap <C-e> <C-o>A

" Ctrl-d: delete next char
inoremap <C-d> <Del>
