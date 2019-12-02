"--------------------------------------------------------------------------
" Status-line

set laststatus=2

let s:status_line = [
  \ " %3*%L%*",
  \ "%4l %2v ",
  \ "%2t ",
  \ "%3*%(%-1.60{IfFit(70) ? expand('%:~:.:h') : ''}\ %)%*",
  \ "%2*%(%{SetBufModified()}\ %)%*",
  \ "%=",
  \ "%2*%(%{IfFit(100) && &paste ? '[P]' : ''}\ %)%*",
  \ "%3*%(%-2.8{IfFit(100) ? get(b:, 'buf_size', '') : ''}\ %)%*",
  \ "%3*%(%{IfFit(90) ? &l:fileformat : ''}\ %)%*",
  \ "%2*%(%{IfFit(90) ? (&l:fileencoding ==# 'utf-8' ? '' : &l:fileencoding . (&l:bomb ? ' /BOM' : '')) : ''}\ %)%*",
  \ "%2*%(%Y\ %)%*",
  \ ]

let &statusline = join(s:status_line)

" Functions
"---------------------------------------------------------------------------
function! AddStatusLine(line, pos) abort
  if s:status_line[a:pos] !=# a:line
    let &statusline = join(insert(s:status_line, a:line, a:pos))
  endif
endfunction

function! IfFit(width) abort
  return get(b:, 'win_width', winwidth(0)) >= a:width
endfunction

function! SetBufModified() abort
  return &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! CountBufSize() abort
  let size = &buftype ==# 'nofile'
    \ ? line2byte(line('$') + 1) - 1
    \ : getfsize(expand('%:p'))

  return size < 1024
    \ ? size . 'B'
    \ : (size / 1024) . 'K'
endfunction

" Events
"---------------------------------------------------------------------------
Autocmd BufEnter,WinEnter,VimResized * let b:win_width = winwidth(0)
Autocmd BufReadPost,BufWritePost     * let b:buf_size = CountBufSize()
