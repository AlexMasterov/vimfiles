function! s:rebuffer(data) abort
  let data = a:data
  if &l:fileformat ==# 'dos'
    let data = substitute(data, "\r\n", "\n", 'g')
  endif

  let search = @/
  let view = winsaveview()

  silent 0,$ delete _
  silent $ put = data
  silent 1 delete _

  call winrestview(view)
  let @/ = search
  redraw
endfunction

function! s:reopen() abort
  let search = @/
  let format = &l:formatoptions
  let conceal = &l:conceallevel
  let cwd = getcwd()
  let view = winsaveview()

  silent edit!

  call winrestview(view)
  execute 'silent cd ' . cwd

  let &l:formatoptions = format
  let &l:conceallevel = conceal
  let @/ = search

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

let g:neomake_verbose = 0
let g:neomake_place_signs = 0
let g:neomake_highlight_lines = 1
let g:neomake_highlight_columns = 0
let g:neomake_echo_current_error = 1

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
  \   '--cache', '--cache-location', $CACHE . '/eslint',
  \   '--no-eslintrc', '--config', $CODING_STYLE_PATH . '/javascript/eslint-fix.js',
  \   '--fix-dry-run', '--format=json', '%:p',
  \ ],
  \ 'process_json': function('ProcessOutputJson'),
  \ }

" TypeScript
let g:neomake_typescript_enabled_makers = ['fix']
let g:neomake_typescript_fix_maker = {
  \ 'exe': 'tslint',
  \ 'args': [
  \   '--config', $CODING_STYLE_PATH . '/typescript/tslint.json',
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
  \   '-q', '--color', 'never', '--emit', 'stdout',
  \   '--config-path', $CODING_STYLE_PATH . '/rust/rustfmt.toml', '%:p'
  \ ],
  \ 'append_file': 0,
  \ 'tempfile_enabled': 0,
  \ 'process_output': function('ProcessOutputBuffer'),
  \ }

if executable('rustup')
  silent! let isNightly = system('rustc --version') =~? '\-nightly'
  if isNightly
    let g:neomake_rust_fix_maker.args =
      \ ['--unstable-features', '--skip-children'] + g:neomake_rust_fix_maker.args
  endif
endif

" PHP
let g:neomake_php_enabled_makers = ['fix']
let g:neomake_php_fix_maker = {
  \ 'exe': 'php-cs-fixer',
  \ 'args': [
  \   'fix', '-q', printf('--config=%s/php/phpcs-fix.php', $CODING_STYLE_PATH),
  \   '--using-cache=yes', '--cache-file', $CACHE . '/phpcs', '%:p'
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
  \ 'args': ['-quiet', '-config', $CODING_STYLE_PATH . '/html/tidy-fix.cfg', '%:p'],
  \ 'append_file': 0,
  \ 'tempfile_enabled': 0,
  \ 'process_output': function('ProcessOutputBuffer'),
  \ }

" XML
let g:neomake_xml_enabled_makers = ['fix']
let g:neomake_xml_fix_maker = deepcopy(g:neomake_html_fix_maker)
let g:neomake_xml_fix_maker.args = [
  \ '-quiet', '-config', $CODING_STYLE_PATH . '/xml/tidy-fix.cfg', '%:p']

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
