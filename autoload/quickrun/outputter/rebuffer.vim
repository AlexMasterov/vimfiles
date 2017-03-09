let s:rebuffer = {'name': 'rebuffer', 'kind': 'outputter'}

function! s:rebuffer.output(data, session) abort
  let self.result = a:data
endfunction

function! s:rebuffer.finish(session) abort
  if !has_key(self, 'result')
    return
  endif

  if a:session.exit_code == 1 " if error
    echohl WarningMsg| echo ' ERROR! ' |echohl None
    return
  endif

  let data = self.result
  if &l:fileformat ==# 'dos'
    let data = substitute(data, "\r\n", "\n", 'g')
  endif

  let winView = winsaveview()

  normal! ggdG
  silent $ put = data
  silent 1 delete _

  call winrestview(winView)
  redraw
endfunction

call quickrun#module#register(s:rebuffer, 1) | unlet s:rebuffer
