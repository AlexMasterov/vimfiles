" vimrc functions
"---------------------------------------------------------------------------

function! vimrc#onFiletype() abort
  if execute('filetype') =~# 'OFF'
    " Lazy loading
    silent! filetype plugin indent on
    syntax enable
    filetype detect
  endif
endfunction

function! vimrc#trimWhiteSpace() abort
  if &binary
    return
  endif

  let register = @/
  let winView = winsaveview()

  silent %s/\s\+$//ge

  call winrestview(winView)
  let @/ = register
endfunction

function! vimrc#makeDir(name, ...) abort
  let force = a:0 >= 1 && a:1 ==# '!'
  let name = expand(a:name, 1)

  if !isdirectory(name)
    \ && (force || input('^y\%[es]$' =~? printf('"%s" does not exist. Create? [yes/no]', name)))
    silent call mkdir(iconv(name, &encoding, &termencoding), 'p')
  endif
endfunction
