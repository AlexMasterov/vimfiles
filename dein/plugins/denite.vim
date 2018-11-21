call denite#custom#option('default', {
  \ 'mode': 'normal',
  \ 'prompt': ' ❯',
  \ 'empty': 1,
  \ 'source_names': 'short',
  \ 'highlight_mode_normal': 'Visual',
  \ 'highlight_matched_range': 'User5'
  \ })

call denite#custom#option('buffer', {
  \ 'reversed': v:true,
  \ 'statusline': v:false,
  \ })

call denite#custom#var('buffer', 'date_format', '')

" Sources
call denite#custom#source('buffer',            'sorters',  ['sorter/reverse'])
call denite#custom#source('file_rec',          'sorters',  ['sorter/sublime'])
call denite#custom#source('file_rec,file_mru', 'matchers', ['matcher/fruzzy'])
call denite#custom#source('file_rec,file_mru,file_old,buffer',
  \ 'converters', ['converter/relative_abbr'])

" Ripgrep: https://github.com/BurntSushi/ripgrep
if executable('rg')
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', ['.'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'default_opts', ['--no-heading', '--maxdepth', '8', '--vimgrep'])
  call denite#custom#var('file_rec', 'command',  ['rg',
    \ '--no-messages', '--no-line-number',
    \ '--maxdepth', '8', '--fixed-strings', '--files-with-matches', '--hidden', '--follow', '.'])
endif

" Mappings
let s:NORMAL = {
  \ 'Q':     '<denite:quit>',
  \ '`':     '<denite:quit>',
  \ '<Esc>': '<denite:quit>',
  \ '-':     '<denite:choose_action>',
  \ 'd':     '<denite:do_action:delete>',
  \ 'D':     '<denite:do_action:delete>',
  \ 'o':     '<denite:do_action:default>',
  \ 'f':     '<denite:do_action:find>',
  \ 'r':     '<denite:do_action:reset>',
  \ 'u':     '<denite:do_action:update>',
  \ 's':     '<denite:do_action:split>',
  \ 'v':     '<denite:do_action:vsplit>',
  \ '<Tab>': '<denite:enter_mode:insert>',
  \ '<C-j>': '<denite:scroll_window_downwards>',
  \ '<C-k>': '<denite:scroll_window_upwards>',
  \ }

let s:INSERT = {
  \ '<C-i>':    '<denite:choose_action>',
  \ '<Tab>':    '<denite:enter_mode:normal>',
  \ '<C-j>':    '<denite:move_to_next_line>',
  \ '<C-k>':    '<denite:move_to_previous_line>',
  \ '<C-p>':    '<denite:paste_from_default_register>',
  \ '<C-d>':    '<denite:delete_char_before_caret>',
  \ '<BS>':     '<denite:delete_char_before_caret>',
  \ '<A-j>':    '<denite:scroll_window_downwards>',
  \ '<A-k>':    '<denite:scroll_window_upwards>',
  \ '<C-h>':    '<denite:move_caret_to_left>',
  \ '<C-l>':    '<denite:move_caret_to_right>',
  \ '<C-a>':    '<denite:move_caret_to_head>',
  \ '<C-e>':    '<denite:move_caret_to_tail>',
  \ '<Space>v': '<denite:do_action:vsplit>',
  \ }

function! s:noremaps(mode, keymaps) abort
  for [key, value] in items(a:keymaps)
    call denite#custom#map(a:mode, key, value, 'noremap')
  endfor
endfunction

call s:noremaps('normal', s:NORMAL)
call s:noremaps('insert', s:INSERT)
