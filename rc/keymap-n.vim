"---------------------------------------------------------------------------
" Keypmap (Normal mode)

" Q: auto indent text
nnoremap Q ==

" Don't update register
nnoremap d "_d
nnoremap D "_dd
nnoremap c "_c
nnoremap C "_C

" [*#]: with use 'smartcase'
nnoremap * /\<<C-r>=expand('<cword>')<CR>\><CR>zv
nnoremap # ?\<<C-r>=expand('<cword>')<CR>\><CR>zv

" [jk]: don't skip wrap lines
nnoremap <expr> j v:count > 0 ? 'gj' : 'j'
nnoremap <expr> k v:count > 0 ? 'gk' : 'k'

" Alt-[jkhl]: move selected lines
nnoremap <A-h> <<<Esc>
nnoremap <A-l> >>><Esc>
nnoremap <silent> <A-j> :<C-u>move+1<CR>
nnoremap <silent> <A-k> :<C-u>move-2<CR>

" Ctrl-[jk]: scroll up/down 1/3 page
nnoremap <expr> <C-j> v:count > 0 ? '<C-d>zz' : (winheight('.') / 4) . '<C-d>zz'
nnoremap <expr> <C-k> v:count > 0 ? '<C-u>zz' : (winheight('.') / 4) . '<C-u>zz'

" Ctrl-d: duplicate line
nnoremap <expr> <C-d> 'yyp' . col('.') . 'l'

" Ctrl-c: clear search highlight
nnoremap <silent> <C-c> :<C-u>let @/ = ""<CR>

" ,r: replace a word under cursor
nnoremap ,r :<C-u>%s/<C-R><C-w>/<C-r><C-w>

" ,Space: trim white spaces
if exists(':TrimSpace')
  nnoremap <silent> ,<Space> :<C-u>TrimSpace<CR>
endif

" ,ev: open vimrc in a new tab
if has('nvim')
  nnoremap <silent> ,ev :<C-u>edit $VIMFILES/vimrc<CR>
else
  nnoremap <silent> ,ev :<C-u>edit $MYVIMRC<CR>
endif

" Files
"---------------------------------------------------------------------------
" ;e: reopen file
nnoremap <silent> ;e :<C-u>edit<CR>
" ;E: force reopen file
nnoremap <silent> ;E :<C-u>edit!<CR>
" Shift-m: save file
nnoremap <silent> <S-m> :<C-u>write!<CR>
nnoremap <silent> <C-s> :<C-u>write!<CR>
" Ctrl-Enter: force save file
nnoremap <silent> <C-Enter> :<C-u>write!<CR>
" Shift-Enter: force save file when buffer was changed
nnoremap <silent> <S-Enter> :<C-u>update!<CR>

" Buffers
"---------------------------------------------------------------------------
" Space + a: previous buffer
nnoremap <silent> <Space>a :<C-u>bprev<CR>
" Space + e: next buffer
nnoremap <silent> <Space>e :<C-u>bnext<CR>
" Space + d: delete buffer
nnoremap <silent> <Space>d :<C-u>bdelete<CR>
" Space + D: force delete buffer
nnoremap <silent> <Space>D :<C-u>bdelete!<CR>
" Space + i: jump to alternate buffer
nnoremap <silent> <Space>i :<C-u>buffer#<CR>
" Backspace
nnoremap <silent> <BS> :<C-u>buffer#<CR>
" Space + t: new buffer
nnoremap <silent> <Space>t :<C-u>call <SID>make_buffer()<CR>
" Space + T: force new buffer
nnoremap <silent> <Space>T :<C-u>call <SID>make_buffer()<CR>:bnext<CR>
" Space + q: smart close tab -> window -> buffer
nnoremap <silent> <Space>q :<C-u>call <SID>smart_close_buffer()<CR>

" Windows
"---------------------------------------------------------------------------
" Space + w: next window
nnoremap <silent> <Space>w :<C-u>wincmd w<CR>
" Space + W: previous window
nnoremap <silent> <Space>W :<C-u>wincmd W<CR>
" Space + I: previous (last accessed) window
nnoremap <silent> <Space>I :<C-u>wincmd p<CR>
" Space + r: rotate windows downwards / rightwards
nnoremap <silent> <Space>r :<C-u>wincmd r<CR>
" Space + R: rotate windows upwards / leftwards
nnoremap <silent> <Space>R :<C-u>wincmd R<CR>
" Space + m: move window to a new tab page
nnoremap <silent> <Space>m :<C-u>wincmd T<CR>
" Space + v: split window verticaly
nnoremap <silent> <expr> <Space>v ':<C-u>vertical '. (v:count ? v:count : '') .'split<CR>'
" Space + V: split window horizontaly
nnoremap <silent> <expr> <Space>V ':<C-u>'. (v:count ? v:count : '') .'split<CR>'

" Space + [hjkl]: jump to a window
nnoremap <silent> <Space>h :<C-u>wincmd h<CR>
nnoremap <silent> <Space>l :<C-u>wincmd l<CR>
nnoremap <silent> <Space>k :<C-u>wincmd k<CR>
nnoremap <silent> <Space>j :<C-u>wincmd j<CR>

" Unbinds
map <F1> <Nop>
map ZZ <Nop>
map ZQ <Nop>

" Functions
"---------------------------------------------------------------------------
function! s:make_buffer() abort
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  execute ':badd buffer'. (max(buffers) + 1)
endfunction

function! s:smart_close_buffer() abort
  let tabpage_nr = tabpagenr('$')
  if tabpage_nr > 1
    tabclose
    return
  endif

  if winnr('$') > 1
    let buffers = filter(tabpagebuflist(tabpage_nr),
     \ 'bufname(v:val) =~? "vimfiler"')

    if empty(buffers)
      close
      return
    endif
  endif

  if empty(bufname('#'))
    silent! bwipeout
    return
  endif

  silent! bprev | bwipeout #
endfunction

" {N} + Enter: jump to a line number / mark
nnoremap <silent> <expr> <Enter> v:count ?
  \ ':<C-u>call <SID>jumpToLine(v:count)<CR>' : "\'"

" [nN]: append line
nnoremap <silent> <expr> n v:count ?
  \ ':<C-u>call <SID>appendLineUp(v:count1)<CR>' : 'i<Space><Esc>'
nnoremap <silent> <expr> N v:count ?
  \ ':<C-u>call <SID>appendLineDown(v:count1)<CR>' : 'i<Space><Esc>`^'

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
