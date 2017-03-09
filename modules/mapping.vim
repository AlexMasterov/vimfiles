" Normal mode
"---------------------------------------------------------------------------
  " [jk]: don't skip wrap lines
  nnoremap <expr> j v:count ? 'gj' : 'j'
  nnoremap <expr> k v:count ? 'gk' : 'k'

  " Alt-[jkhl]: move selected lines
  nnoremap <A-h> <<<Esc>
  nnoremap <A-l> >>><Esc>
  nnoremap <silent> <A-j> :<C-u>move+1<CR>
  nnoremap <silent> <A-k> :<C-u>move-2<CR>

  " Ctrl-[jk]: scroll up/down 1/3 page
  nnoremap <expr> <C-j> v:count ?
    \ '<C-d>zz' : (winheight('.') / 4) . '<C-d>zz'
  nnoremap <expr> <C-k> v:count ?
    \ '<C-u>zz' : (winheight('.') / 4) . '<C-u>zz'

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

  " Ctrl-d: duplicate line
  nnoremap <expr> <C-d> 'yyp' . col('.') . 'l'

  " Q: auto indent text
  nnoremap Q ==

  " [dDcC]: don't update register
  nnoremap d "_d
  nnoremap D "_dd
  nnoremap c "_c
  nnoremap C "_C

  " ,ev: open vimrc in a new tab
  nnoremap <silent> ,ev :<C-u>edit $MYVIMRC<CR>

  " ,r: replace a word under cursor
  nnoremap ,r :%s/<C-R><C-w>/<C-r><C-w>/g<left><left>

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

" Buffers
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
  " Space + t: new buffer
  nnoremap <silent> <Space>t :<C-u>call <SID>makeBuffer()<CR>
  " Space + T: force new buffer
  nnoremap <silent> <Space>T :<C-u>call <SID>makeBuffer()<CR>:bnext<CR>
  " Space + q: smart close tab -> window -> buffer
  nnoremap <silent> <Space>q :<C-u>call <SID>smartClose()<CR>

" Files
  " ;e: reopen file
  nnoremap <silent> ;e :<C-u>edit<CR>
  " ;E: force reopen file
  nnoremap <silent> ;E :<C-u>edit!<CR>
  " Shift-m: save file
  nnoremap <silent> <S-m> :<C-u>write!<CR>
  " Ctrl-Enter: force save file
  nnoremap <silent> <C-Enter> :<C-u>write!<CR>
  " Shift-Enter: force save file when buffer was changed
  nnoremap <silent> <S-Enter> :<C-u>update!<CR>

" Tabs
  " Space + 1-9: jumps to a tab number
  " for n in range(1, 9)
  "   execute printf('nnoremap <silent> <nowait> <Space>%d %dgt', n, n)
  " endfor | unlet n
  " Space + A: previous tab
  nnoremap <silent> <Space>A :<C-u>tabprev<CR>
  " Space + E: next tab
  nnoremap <silent> <Space>E :<C-u>tabnext<CR>
  " Space + o: tab only
  nnoremap <silent> <Space>o :<C-u>tabonly<CR>
  " Space + t: tab new
  " nnoremap <silent> <Space>t :<C-u>tabnew<CR>:normal! <C-o><CR>
  " Space + T: tab new and move
  " nnoremap <silent> <Space>T :<C-u>tabnew<CR>:tabmove<CR>:normal! <C-o><CR>
  " Space + m: tab move
  nnoremap <silent> <Space>m :<C-u>tabmove<CR>
  " Space + <: move tab to first spot
  nnoremap <silent> <Space>< :<C-u>tabmove 0<CR>
  " Space + >: move tab to last spot
  nnoremap <silent> <expr> <Space>> ':<C-u>tabmove '.tabpagenr('$').'<CR>'
  " Space + ,: move tab to left
  nnoremap <silent> <expr> <Space>,
    \ ':<C-u>tabmove '.max([tabpagenr() - v:count1 - 1, 0]).'<CR>'
  " Space + .: move tab to right
  nnoremap <silent> <expr> <Space>.
    \ ':<C-u>tabmove '.min([tabpagenr() + v:count1, tabpagenr('$')]).'<CR>'
  " [N] + Space + c: close tab
  nnoremap <silent> <expr> <Space>c v:count ?
    \ ':<C-u>'.v:count.'tabclose<CR>' : ':<C-u>tabclose<CR>'
  " [N] + Space + C: force close tab
  nnoremap <silent> <expr> <Space>c v:count ?
    \ ':<C-u>'.v:count.'tabclose!<CR>' : ':<C-u>tabclose!<CR>'

" Windows
  for char in split('h j k l')
    " Space + [hjkl]: jump to a window
    execute printf('nnoremap <silent> <Space>%s :<C-u>wincmd %s<CR>', char, char)
    " Space + [HJKL]: move the current window
    execute printf('nnoremap <silent> <Space>%s :<C-u>wincmd %s<CR>', toupper(char), toupper(char))
  endfor | unlet char
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
  " Space + v: split window horizontaly
  nnoremap <silent> <expr> <Space>v ':<C-u>'. (v:count ? v:count : '') .'split<CR>'
  " Space + V: split window verticaly
  nnoremap <silent> <expr> <Space>V ':<C-u>vertical '. (v:count ? v:count : '') .'split<CR>'
  " Space + m: move window to a new tab page
  nnoremap <silent> <Space>m :<C-u>wincmd T<CR>
  " Space + q: smart close window -> tab -> buffer
  " nnoremap <silent> <expr> <Space>q winnr('$') ==# 1
  "   \ ? printf(':<C-u>%s<CR>', (tabpagenr('$') ==# 1 ? 'bdelete!' : 'tabclose!'))
  "   \ : ':<C-u>close<CR>'
  " Space + Q: force smart close window -> tab -> buffer
  " nnoremap <silent> <expr> <Space>Q winnr('$') ==# 1
  "   \ ? printf(':<C-u>%s<CR>', (tabpagenr('$') ==# 1 ? 'bdelete!' : 'tabclose!'))
  "   \ : ':<C-u>close!<CR>'

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

" Insert mode
"---------------------------------------------------------------------------
  " Alt-[jkhl]: standart move
  inoremap <A-j> <C-o>gj
  inoremap <A-h> <C-o>h
  inoremap <A-k> <C-o>gk
  inoremap <A-l> <C-o>l
  " Ctrl-a: jump to head
  inoremap <expr> <C-a> empty(getline('.')[getcurpos()[4]-2]) ? "<Home>" : "<C-o>I"
  " Ctrl-e: jump to end
  inoremap <C-e> <C-o>A
  " Ctrl-d: delete next char
  inoremap <C-d> <Del>
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
  inoremap <expr> j getline('.')[getcurpos()[4]-2] ==# 'j' ? "\<BS>\<Esc>`^" : "\j"
  inoremap <expr> q getline('.')[getcurpos()[4]-2] ==# 'q' ? "\<BS>\<Esc>`^" : "\q"

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
  xnoremap <silent> <expr> y 'ygv'. mode()
  xnoremap <silent> <expr> Y 'Ygv'. mode()
  " p: paste not replace the default register
  xnoremap p "_dP
  " [dDcC]: delete to black hole register
  xnoremap d "_d
  xnoremap D "_D
  xnoremap c "_c
  xnoremap C "_C
  " xnoremap x "_x
  " xnoremap X "_X

"   " Space: fast Esc
  xnoremap <Space> <Esc>
  snoremap <Space> <Esc>

" Command mode
"---------------------------------------------------------------------------
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
  " Ctrl-v: open the command-line window
  cnoremap <C-v> <C-f>a

"   " `: old fast Esc
"   cnoremap <C-c> <C-c>
"   " jj: smart fast Esc
"   cnoremap <expr> j getcmdline()[getcmdpos()-2] ==# 'j' ? "\<C-c>" : 'j'
"   " qq: smart fast Esc
"   cnoremap <expr> q getcmdline()[getcmdpos()-2] ==# 'q' ? "\<C-c>" : 'q'
"   " Backspace: don't leave Command mode
"   cnoremap <expr> <BS> getcmdpos() > 1 ? "\<BS>" : ""

"   " Copy to clipboard
"   " vnoremap y  "*y
"   " nnoremap Y  "*yg_
"   " nnoremap y  "*y
"   " nnoremap yy "*yy

"   " p: paste from clipboard
"   nnoremap p "*p
"   vnoremap P "*P

"   " sort lines inside block
"   nnoremap ;4 ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:silent! nohlsearch<CR>

" Functions
"---------------------------------------------------------------------------
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

  function! s:makeBuffer() abort
    let buffers = filter(range(1, bufnr('$')),
      \ 'buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype")')
    execute ':badd buffer'. (max(buffers) + 1)
  endfunction

  function! s:smartClose() abort
    let tabPageNr = tabpagenr('$')
    if tabPageNr > 1
      tabclose | return
    endif
    if winnr('$') > 1
      let buffers = filter(tabpagebuflist(tabPageNr),
        \ 'bufname(v:val) =~? "vimfiler"')
      if empty(buffers)
        close | return
      endif
    endif
    if empty(bufname('#'))
      silent! bwipeout | return
    endif
    bprev | silent! bwipeout # | return
  endfunction
