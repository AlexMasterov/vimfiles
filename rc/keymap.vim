"---------------------------------------------------------------------------
" Keypmap

" Normal mode
"---------------------------------------------------------------------------
" {N} + Enter: jump to a line number / mark
nnoremap <silent> <expr> <Enter> v:count ?
  \ ':<C-u>call <SID>jumpToLine(v:count)<CR>' : "\'"

" [nN]: append line
nnoremap <silent> <expr> n v:count ?
  \ ':<C-u>call <SID>appendLineUp(v:count1)<CR>' : 'i<Space><Esc>'
nnoremap <silent> <expr> N v:count ?
  \ ':<C-u>call <SID>appendLineDown(v:count1)<CR>' : 'i<Space><Esc>`^'

" Ctrl-c: clear highlight after search
nnoremap <silent> <C-c> :<C-u>let @/ = ""<CR>

" ,r: replace a word under cursor
nnoremap ,r :%s/<C-R><C-w>/<C-r><C-w>

" :s::: is more useful than :s/// when replacing paths
" https://github.com/jalanb/dotjab/commit/35a40d11c425351acb9a31d6cff73ba91e1bd272
nnoremap ,R :%s:<C-R><C-w>:<C-r><C-w>:<Left>

" [*#]: with use 'smartcase'
nnoremap * /\<<C-r>=expand('<cword>')<CR>\><CR>zv
nnoremap # ?\<<C-r>=expand('<cword>')<CR>\><CR>zv

" gr: replace word under the cursor
nnoremap gr :<C-u>%s/<C-r><C-w>/<C-r><C-w>/g<left><left>
" gl: select last changed text
nnoremap gl `[v`]
" gp: select last paste in visual mode
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" gv: last selected text operator
onoremap gv :<C-u>normal! gv<CR>
" gy: replace last yanked selected text
nnoremap <expr> gy ':<C-u>%s/' . @" . '//g<Left><Left>'

" Text objects
nmap <S-<> <Esc>vi<
nmap <S->> <Esc>va>

" vi
for char in split('( [ { < '' "')
  execute printf('nmap %s  <Esc>vi%s', char, char)
  execute printf('nmap ;%s <Esc>vi%s', char, char)
endfor | unlet char
" va
for char in split(') ] } >')
  execute printf('nmap %s  <Esc>va%s', char, char)
  execute printf('nmap ;%s <Esc>va%s', char, char)
endfor | unlet char

" Unbinds
for char in split('<F1> ZZ ZQ')
  execute printf('map %s <Nop>', char)
endfor | unlet char

" Insert mode
"---------------------------------------------------------------------------
" Ctrl-Enter: break line below
inoremap <C-CR> <Esc>O
" Shift-Enter: break line above
inoremap <S-CR> <C-m>
" Ctrl-u: undo
inoremap <C-u> <C-o>u
" Ctrl-[pv]: paste
imap <C-p> <C-R>"*
imap <C-v> <C-R>"*
" Enter: to redo a changes
inoremap <CR> <C-g>u<CR>
" Ctrl-s: force save file
inoremap <silent> <C-s> <Esc> :write!<CR>i
" Ctrl-c: fast Esc
inoremap <C-c> <Esc>`^
" Ctrl-l: fast Esc
inoremap <C-l> <Esc>`^
" [jj|qq]: smart fast Esc
inoremap <expr> j getline('.')[getcurpos()[4] - 2] ==# 'j' ? "\<BS>\<Esc>`^" : "\j"
inoremap <expr> q getline('.')[getcurpos()[4] - 2] ==# 'q' ? "\<BS>\<Esc>`^" : "\q"

" Unbinds
inoremap <C-j> <Nop>
inoremap <C-k> <Nop>

" Ctrl-[jk]: scroll up/down
xnoremap <C-j> <C-d>
xnoremap <C-k> <C-u>
" Ctrl-d: duplicate line
xnoremap <silent> <C-d> :t'><CR>
" Q: auto indent text
xnoremap Q ==<Esc>
" L: move to end of line
xnoremap L $h
" [#*]: make # and * work in visual mode too
xnoremap # y?<C-r>*<CR>
xnoremap * y/<C-r>*<CR>
" [yY]: keep cursor position when yanking
xnoremap <silent> <expr> y 'ygv' . mode()
xnoremap <silent> <expr> Y 'Ygv' . mode()
" p: paste not replace the default register
xnoremap p "_dP
" [dDcC]: delete to black hole register
xnoremap d "_d
xnoremap D "_D
xnoremap c "_c
xnoremap C "_C
" xnoremap x "_x
" xnoremap X "_X

" Space: fast Esc
xnoremap <Space> <Esc>
snoremap <Space> <Esc>

" Visual mode
"---------------------------------------------------------------------------
" jk: don't skip wrap lines
xnoremap <expr> j v:count && mode() ==# 'V' ?
  \ 'gj' : 'j'
xnoremap <expr> k v:count && mode() ==# 'V' ?
  \ 'gk' : 'k'

" Alt-[jkhl]: move selected lines
xnoremap <A-h> <'[V']
xnoremap <A-l> >'[V']
xnoremap <silent> <A-j> :move'>+1<CR>gv
xnoremap <silent> <A-k> :move-2<CR>gv

function! s:jumpToLine(line) abort
  call cursor(a:line, 0)
  call feedkeys('zz')
endfunction

function! s:appendLineUp(line) abort
  for i in range(1, a:line)
    call append(line('.'), '')
  endfor
endfunction

function! s:appendLineDown(line) abort
  for i in range(1, a:line)
    call append(line('.') - 1, '')
  endfor
endfunction
