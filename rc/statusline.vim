"--------------------------------------------------------------------------
" Status-line

function! AddStatusLine(line, pos) abort
  let &statusline = join(insert(g:status_line, a:line, a:pos))
endfunction

function! IfFit(width) abort
  return get(b:, 'winwidth', winwidth(0)) >= a:width
endfunction

function! BufModified() abort
  return &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! BufSize() abort
  let size = &buftype ==# 'nofile'
    \ ? line2byte(line('$') + 1) - 1
    \ : getfsize(expand('%:p'))

  return size < 1024
    \ ? size . 'B'
    \ : (size / 1024) . 'K'
endfunction

" Events
Autocmd BufReadPost,BufWritePost * let b:bufsize = BufSize()
Autocmd BufEnter,WinEnter,VimResized * let b:winwidth = winwidth(0)

set laststatus=2

let g:status_line = [
  \ " %3*%L%*",
  \ "%4l %2v ",
  \ "%2t ",
  \ "%3*%(%-1.60{IfFit(70) ? expand('%:~:.:h') : ''}\ %)%*",
  \ "%2*%(%{BufModified()}\ %)%*",
  \ "%=",
  \ "%2*%(%{IfFit(100) && &paste ? '[P]' : ''}\ %)%*",
  \ "%3*%(%-2.8{IfFit(100) ? get(b:, 'bufsize', '') : ''}\ %)%*",
  \ "%3*%(%{IfFit(90) ? &fileformat : ''}\ %)%*",
  \ "%2*%(%{IfFit(90) ? (&fileencoding !=# 'utf-8' ? &fileencoding : '') : ''}\ %)%*",
  \ "%2*%(%Y\ %)%*",
  \ ]

let &statusline = join(g:status_line)
