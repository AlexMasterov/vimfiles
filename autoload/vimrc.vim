"---------------------------------------------------------------------------
" vimrc

function! vimrc#make_dir(name, ...) abort
  let name = expand(a:name, 1)
  let force = a:0 >= 1 && a:1 ==# v:true

  if !isdirectory(name)
    \ && (force || input('^y\%[es]$' =~? printf('"%s" does not exist. Create? [yes/no]', name)))
    silent call mkdir(iconv(name, &encoding, &termencoding), 'p', 0700)
  endif
endfunction

function! vimrc#trim_spaces() abort
  if &binary
    return
  endif

  let view = winsaveview()
  let register = getreg('/')

  silent keepjumps %s/\s\+$//ge

  call winrestview(view)
  call setreg('/', register)
endfunction
