"---------------------------------------------------------------------------
" vimrc

function! vimrc#makeDir(name, ...) abort
  let name = expand(a:name, 1)
  let force = a:0 >= 1 && a:1 ==# v:true

  if !isdirectory(name)
    \ && (force || input('^y\%[es]$' =~? printf('"%s" does not exist. Create? [yes/no]', name)))
    silent call mkdir(iconv(name, &encoding, &termencoding), 'p')
  endif
endfunction

function! vimrc#trimWhiteSpace() abort
  if &binary
    return
  endif

  let view = winsaveview()
  let register = getreg('/')

  silent keepjumps %s/\s\+$//ge

  call winrestview(view)
  call setreg('/', register)
endfunction
