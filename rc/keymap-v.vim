"---------------------------------------------------------------------------
" Keypmap (Visual mode)

" Q: auto indent text
xnoremap Q ==<Esc>
" L: move to end of line
xnoremap L $h

" p: paste not replace the default register
xnoremap p "_dP

" [yY]: keep cursor position when yanking
xnoremap <silent> <expr> y 'ygv' . mode()
xnoremap <silent> <expr> Y 'Ygv' . mode()

" Don't update register
xnoremap d "_d
xnoremap D "_D
xnoremap c "_c
xnoremap C "_C

" [#*]: work in visual mode
xnoremap # y?<C-r>*<CR>
xnoremap * y/<C-r>*<CR>

" jk: don't skip wrap lines
xnoremap <expr> j v:count > 0 && mode() ==# 'V' ? 'gj' : 'j'
xnoremap <expr> k v:count > 0 && mode() ==# 'V' ? 'gk' : 'k'

" Alt-[jkhl]: move selected lines
xnoremap <A-h> <'[V']
xnoremap <A-l> >'[V']
xnoremap <silent> <A-j> :move'>+1<CR>gv=gv
xnoremap <silent> <A-k> :move'<-2<CR>gv=gv

" Ctrl-d: duplicate line
xnoremap <silent> <C-d> :t'><CR>

" Ctrl-[jk]: scroll up/down
xnoremap <C-j> <C-d>
xnoremap <C-k> <C-u>

" Space: fast Esc
xnoremap <Space> <Esc>
snoremap <Space> <Esc>
