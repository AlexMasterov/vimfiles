let s:reopen = {'name': 'reopen', 'kind': 'outputter'}

function! s:reopen.start(session) abort
endfunction

function! s:reopen.output(data, session) abort
endfunction

function! s:reopen.finish(session) abort
  let format = &l:formatoptions
  let conceal = &l:conceallevel
  let cwd = getcwd()
  let winView = winsaveview()

  silent edit!

  call winrestview(winView)
  execute 'silent cd '. cwd

  let &l:conceallevel = conceal
  let &l:formatoptions = format

  if !exists('g:syntax_on')
    syntax on
  endif
endfunction

call quickrun#module#register(s:reopen, 1) | unlet s:reopen
