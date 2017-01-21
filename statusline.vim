" Status-line

set laststatus=2
" Format the statusline
let &statusline =
  \  "%3* %L %*"
  \. "%l%3*:%*%v "
  \. "%-0.60t "
  \. "%3*%(%{IfFit(70) ? expand('%:~:.:h') : ''}\ %)%*"
  \. "%2*%(%{BufModified()}\ %)%*"
  \. "%="
  \. "%(%{IfFit(100) ? get(b:, 'bufsize', '') : ''}\ %)"
  \. "%2*%(%{IfFit(100) && &paste ? '[P]' : ''}\ %)%*"
  \. "%2*%(%{IfFit(100) ? &iminsert ? 'RU' : 'EN' : ''}\ %)%*"
  \. "%(%{IfFit(90) ? &fileencoding !=# '' ? &fileencoding : &encoding : ''}\ %)"
  \. "%2*%(%Y\ %)%*"

" Events
Autocmd BufRead,TextChanged,TextChangedI *
      \ let b:bufsize = BufSize()

Autocmd BufEnter,WinEnter,VimResized *
      \ let b:winwidth = winwidth(0)

" Functions
function! IfFit(width) abort
  return get(b:, 'winwidth', winwidth(0)) >= a:width
endfunction

function! BufModified() abort
  return &modified
        \ ? '+'
        \ : &modifiable ? '' : '-'
endfunction

function! BufSize() abort
  let filepath = expand('%:p')
  let size = filepath !=# ''
        \ ? getfsize(filepath)
        \ : line2byte(line('$') + 1) - 1

  if size >= 1024
    let suffix = 'K'
    let size = size / 1024
  else
    let suffix = 'B'
  endif

  return size . suffix
endfunction