if exists('b:did_indent')
  finish
endif

let b:did_indent = 1

setlocal indentkeys=o
setlocal indentexpr=GetSugarssIndent()

if exists('*GetSugarssIndent')
  finish
endif

function! GetSugarssIndent() abort
  let line = getline(v:lnum - 1)

  if line =~# '^\s*\w\+'
    return &shiftwidth
  endif

  return 0
endfunction
