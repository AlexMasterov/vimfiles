" Status-line
"--------------------------------------------------------------------------

set laststatus=2
" Format the statusline
let &statusline =
  \  " %3*%L%*"
  \. "%4l %2v "
  \. "%2t "
  \. "%3*%(%-1.60{IfFit(70) ? expand('%:~:.:h') : ''}\ %)%*"
  \. "%(%{&filetype ==# '' ? '' : NeomakeStatus() }\ %)"
  \. "%2*%(%{BufModified()}\ %)%*"
  \. "%="
  \. "%2*%(%{exists('*gina#component#repo#branch()') ? gina#component#repo#branch() : ''}\ %)%*"
  \. "%2*%(%{IfFit(100) && &paste ? '[P]' : ''}\ %)%*"
  \. "%2*%(%{IfFit(100) ? &iminsert ? 'RU' : 'EN' : ''}\ %)%*"
  \. "%(%-2.8{IfFit(100) ? get(b:, 'bufsize', '') : ''}\ %)"
  \. "%(%{IfFit(90) ? (&fileencoding ==# '' ? &encoding : &fileencoding) : ''}\ %)"
  \. "%2*%(%Y\ %)%*"

function! NeomakeStatus() abort
  return neomake#statusline#get(bufnr('%'), {
    \ 'format_running': '…',
    \ 'format_loclist_ok': '✓',
    \ 'format_loclist_unknown': '',
    \ 'format_loclist_type_E': ' {{type}}:{{count}} ',
    \ })
endfunction

" Events
Autocmd BufRead,FileReadPost,FileWritePost * let b:bufsize = BufSize()
Autocmd BufEnter,WinEnter,VimResized * let b:winwidth = winwidth(0)

" Functions
function! IfFit(width) abort
  return get(b:, 'winwidth', winwidth(0)) >= a:width
endfunction

function! BufModified() abort
  return &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! BufSize() abort
  let filepath = expand('%:p')
  let size = filepath ==# ''
    \ ? line2byte(line('$') + 1) - 1
    \ : getfsize(filepath)

  if size >= 1024
    let suffix = 'K'
    let size = size / 1024
  else
    let suffix = 'B'
  endif

  return size . suffix
endfunction

function! LinterStatus() abort
  let counts = ale#statusline#Count(bufnr(''))
  let allErrors = counts.error + counts.style_error
  let allNonErrors = counts.total - allErrors

  return counts.total ==# 0
    \ ? 'OK'
    \ : printf('%dW %dE', allNonErrors, allErrors)
endfunction
