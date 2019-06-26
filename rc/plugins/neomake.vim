function! s:rebuffer(data) abort
  let data = a:data
  if &l:fileformat ==# 'dos'
    let data = substitute(data, "\r\n", "\n", 'g')
  endif

  let view = winsaveview()
  let register = getreg('/')

  silent 0,$ delete _
  silent $ put = data
  silent 1 delete _

  call winrestview(view)
  call setreg('/', register)
  redraw
endfunction

function! s:reopen() abort
  let cwd = getcwd()
  let view = winsaveview()
  let register = getreg('/')
  let format = &l:formatoptions
  let conceal = &l:conceallevel

  silent edit!

  execute 'silent cd ' . cwd
  call winrestview(view)
  call setreg('/', register)
  let &l:formatoptions = format
  let &l:conceallevel = conceal

  if !exists('g:syntax_on')
    syntax on
  endif
endfunction

function! ProcessOutputBuffer(context) abort
  call s:rebuffer(a:context.output)
  return []
endfunction

function! ProcessOutputJson(context) abort
  let data = a:context.json[0]
  if has_key(data, 'output')
    call s:rebuffer(data.output)
  endif

  return []
endfunction

function! ProcessOutputFile() abort
  let jobinfo = g:neomake_hook_context.jobinfo
  if jobinfo.finished !=# 1
    return
  endif

  if index(g:neomake_fixers, jobinfo.maker.exe) !=# -1
    call s:reopen()
  endif
endfunction

"--------------------------------------------------------------------------
let g:neomake_fixers = []

function! s:addFixer(fixer) abort
  if index(g:neomake_fixers, a:fixer) ==# -1
    call add(g:neomake_fixers, a:fixer)
  endif
endfunction

" JavaScript
let g:neomake_javascript_enabled_makers = ['fix']
let g:neomake_javascript_fix_maker = {
  \ 'exe': 'eslint',
  \ 'args': [
  \   '--no-eslintrc', '--config', expand('$CODING_STYLE_PATH/javascript/eslint-fix.js'),
  \   '--cache', '--cache-location', expand('$VIMHOME/eslint'),
  \   '--fix-dry-run', '--format=json', '%:p',
  \ ],
  \ 'process_json': function('ProcessOutputJson'),
  \ }

" TypeScript
let g:neomake_typescript_enabled_makers = ['fix']
let g:neomake_typescript_fix_maker = {
  \ 'exe': 'tslint',
  \ 'args': [
  \   '--config', expand('$CODING_STYLE_PATH/typescript/tslint.json'),
  \   '--fix', '%:p',
  \ ],
  \ }

call s:addFixer(g:neomake_typescript_fix_maker.exe)
AutocmdFT typescript,typescript.jsx
 \ Autocmd User NeomakeJobFinished call ProcessOutputFile()

" Rust
let g:neomake_rust_enabled_makers = ['fix']
let g:neomake_rust_fix_maker = {
  \ 'exe': 'rustfmt',
  \ 'args': [
  \   '--config-path', expand('$CODING_STYLE_PATH/rust/rustfmt.toml'),
  \   '-q', '--color', 'never', '--emit', 'stdout', '%:p'
  \ ],
  \ 'append_file': 0,
  \ 'tempfile_enabled': 0,
  \ 'process_output': function('ProcessOutputBuffer'),
  \ }

if executable('rustc')
  silent! let isNightly = system('rustc --version') =~? '\-nightly'
  if isNightly
    let g:neomake_rust_fix_maker.args =
     \ ['--unstable-features', '--skip-children']
     \ + g:neomake_rust_fix_maker.args
  endif
endif

" PHP
let g:neomake_php_enabled_makers = ['fix']
let g:neomake_php_fix_maker = {
  \ 'exe': 'php-cs-fixer',
  \ 'args': [
  \   'fix', expand('--config=$CODING_STYLE_PATH/php/phpcs-fix.php'),
  \   '--using-cache=yes', '--cache-file', expand('$VIMHOME/phpcs'),
  \   '-q', '%:p'
  \ ],
  \ }

call s:addFixer(g:neomake_php_fix_maker.exe)
AutocmdFT php
  \ Autocmd User NeomakeJobFinished call ProcessOutputFile()

" Golang
let g:neomake_go_enabled_makers = ['fix']
let g:neomake_go_fix_maker = {
  \ 'exe': 'gofmt',
  \ 'args': ['%:p'],
  \ 'append_file': 0,
  \ 'tempfile_enabled': 0,
  \ 'process_output': function('ProcessOutputBuffer'),
  \ }

" HTML
let g:neomake_html_enabled_makers = ['fix']
let g:neomake_html_fix_maker = {
  \ 'exe': 'tidy',
  \ 'args': [
  \   '-config', expand('$CODING_STYLE_PATH/html/tidy-fix.cfg'),
  \   '-quiet', '%:p'
  \ ],
  \ 'append_file': 0,
  \ 'tempfile_enabled': 0,
  \ 'process_output': function('ProcessOutputBuffer'),
  \ }

" XML
let g:neomake_xml_enabled_makers = ['fix']
let g:neomake_xml_fix_maker = deepcopy(g:neomake_html_fix_maker)
let g:neomake_xml_fix_maker.args = [
  \ '-config', expand('$CODING_STYLE_PATH/xml/tidy-fix.cfg'), '-quiet', '%:p']

" JSON
let g:neomake_json_enabled_makers = ['fix']
let g:neomake_json_fix_maker = {
  \ 'exe': 'prettier',
  \ 'args': [
  \   '--no-config', '--no-editorconfig', '--loglevel', 'silent',
  \   '--parser', 'json', '%:p'],
  \ 'append_file': 0,
  \ 'tempfile_enabled': 0,
  \ 'process_output': function('ProcessOutputBuffer'),
  \ }

" YAML
let g:neomake_yaml_enabled_makers = ['fix']
let g:neomake_yaml_fix_maker = deepcopy(g:neomake_json_fix_maker)
let g:neomake_yaml_fix_maker.args = [
  \ '--no-config', '--no-editorconfig', '--loglevel', 'silent', '--parser', 'yaml', '%:p']

" Markdown
let g:neomake_markdown_enabled_makers = ['fix']
let g:neomake_markdown_fix_maker = deepcopy(g:neomake_json_fix_maker)
let g:neomake_markdown_fix_maker.args = [
  \ '--no-config', '--no-editorconfig', '--loglevel', 'silent', '--parser', 'markdown', '%:p']
