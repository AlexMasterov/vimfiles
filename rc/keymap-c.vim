"---------------------------------------------------------------------------
" Keypmap (Command mode)

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
" Ctrl-p: paste
cnoremap <C-p> <C-r><C-o>*
" Ctrl-v: open the command-line window
cnoremap <C-v> <C-f>a
