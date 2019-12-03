"---------------------------------------------------------------------------
" Keypmap (Insert mode)

" Alt-[jkhl]: standart move
inoremap <A-j> <C-o>gj
inoremap <A-h> <C-o>h
inoremap <A-k> <C-o>gk
inoremap <A-l> <C-o>l

" [jj|qq]: smart fast Esc
inoremap <expr> j getline('.')[getcurpos()[4] - 2] ==# 'j' ? "\<BS>\<Esc>`^" : "\j"
inoremap <expr> q getline('.')[getcurpos()[4] - 2] ==# 'q' ? "\<BS>\<Esc>`^" : "\q"

" Ctrl-[cl]: fast Esc
inoremap <C-c> <Esc>`^
inoremap <C-l> <Esc>`^

" Ctrl-a: jump to head
inoremap <expr> <C-a> empty(getline('.')[getcurpos()[4] - 2]) ? '<Home>' : '<C-o>I'
" Ctrl-e: jump to end
inoremap <C-e> <C-o>A
" Ctrl-d: delete next char
inoremap <C-d> <Del>
" Ctrl-u: undo
inoremap <C-u> <C-o>u
" Ctrl-[pv]: paste
imap <C-p> <C-R>"
imap <C-v> <C-R>"

" Ctrl-Enter: break line below
inoremap <C-CR> <Esc>O
" Shift-Enter: break line above
inoremap <S-CR> <C-m>

" Enter: to redo a changes
imap <CR> <C-g>u<CR>

" Unbinds
inoremap <C-j> <Nop>
inoremap <C-k> <Nop>
