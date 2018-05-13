" Functions
function! ProcessOutputBuffer(context) abort
  let data = a:context.output

  if &l:fileformat ==# 'dos'
    let data = substitute(data, "\r\n", "\n", 'g')
  endif

  let winView = winsaveview()

  silent 0,$ delete _
  silent $ put = data
  silent 1 delete _

  call winrestview(winView)
  redraw

  return []
endfunction

function! ProcessOutputJson(context) abort
  if !has_key(a:context.json[0], 'output')
    return []
  endif

  let data = a:context.json[0].output

  if &l:fileformat ==# 'dos'
    let data = substitute(data, "\r\n", "\n", 'g')
  endif

  let winView = winsaveview()

  silent 0,$ delete _
  silent $ put = data
  silent 1 delete _

  call winrestview(winView)
  redraw

  return []
endfunction

let g:neomake_verbose = 0
let g:neomake_place_signs = 0
let g:neomake_highlight_lines = 1
let g:neomake_highlight_columns = 0
let g:neomake_echo_current_error = 1

" JavaScript
let g:neomake_javascript_enabled_makers = ['fix']
let g:neomake_javascript_fix_maker = {
  \ 'exe': 'eslint',
  \ 'args': [
  \   '--format=json', '--fix-dry-run', '--config', $CODING_STYLE_PATH . '/javascript/eslint-fix.js',
  \   '--cache', '--cache-location', $CACHE . '/.eslintcache', '%:p'
  \ ],
  \ 'process_json': function('ProcessOutputJson'),
  \ }

" Rust
let g:neomake_rust_enabled_makers = ['fix']
let g:neomake_rust_fix_maker = {
  \ 'exe': 'rustfmt',
  \ 'args': ['-q', '--emit', 'stdout', '--config-path', $CODING_STYLE_PATH . '/rust/rustfmt.toml', '%:p'],
  \ 'append_file': 0,
  \ 'tempfile_enabled': 0,
  \ 'process_output': function('ProcessOutputBuffer'),
  \ }
