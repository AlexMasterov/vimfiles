call lexima#clear_rules()

for rule in g:lexima#newline_rules
  call lexima#add_rule(rule)
endfor | unlet rule

function! s:disableLeximaInsideRegexp(char) abort
  call lexima#add_rule({'char': a:char, 'at': '\S.*\%#.*\S/', 'input': a:char})
endfunction

" Quotes
for quote in split('" ''')
  call lexima#add_rule({'char': quote, 'input': repeat(quote, 2) . '<Left>', 'except': '\%#.*[-0-9a-zA-Z_,:]'})
  call lexima#add_rule({'char': "'", 'at': '\\\%#'})
  call lexima#add_rule({'char': "'", 'at': '\w\%#''\@!'})
  call lexima#add_rule({'char': quote, 'at': '\%#'. quote, 'leave': 1})
  call lexima#add_rule({'char': quote, 'at': '\%#'. repeat(quote, 2), 'leave': 2})
  call lexima#add_rule({'char': quote, 'at': '\%#'. repeat(quote, 3), 'leave': 3})
  call lexima#add_rule({'char': '<BS>', 'at': quote . '\%#' . quote, 'input': '<BS><Del>', 'delete': 1})
  call s:disableLeximaInsideRegexp(quote)
endfor | unlet quote

" Pairs
let [left, right] = [0, 1]

for pair in split('() {} []')
  call lexima#add_rule({'char': pair[left], 'input': '<Space><BS>' . pair[left] . pair[right] . '<Left>', 'except': '\%#.*[-0-9a-zA-Z_,:]'})
  call lexima#add_rule({'char': pair[left], 'input_after': pair[right], 'except': '^\s*\%#'})
  call lexima#add_rule({'char': pair[right], 'at': '\%#\_s*' . pair[right], 'input': '<Right>'})
endfor | unlet pair

call lexima#add_rule({'char': '<BS>', 'at': '(\%#)', 'input': '<BS>', 'delete': 1})
call lexima#add_rule({'char': '<BS>', 'at': '{\%#}', 'input': '<BS>', 'delete': 1})
call lexima#add_rule({'char': '<BS>', 'at': '\[\%#\]', 'input': '<BS>', 'delete': 1})

" {{ <Space> }}
call lexima#add_rule({
  \ 'filetype': ['twig', 'blade'],
  \ 'at': '\(........\)\?{\%#}', 'char': '{', 'input': '{<Space>', 'input_after': '<Space>}'
  \})
call lexima#add_rule({
  \ 'filetype': ['twig', 'blade'],
  \ 'at': '\(........\)\?{{ \%# }}', 'char': '<BS>', 'input': '<BS><BS>', 'delete': 2
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '\(........\)\?{{\%#}}', 'char': '{', 'input': '{}<Left>'
  \})
call lexima#add_rule({
  \ 'filetype': ['twig', 'blade'],
  \ 'at': '\(........\)\?{{\%#}}', 'char': '<Space>', 'input' : '<Space><Space><Left>'
  \})
call lexima#add_rule({
  \ 'filetype': ['twig', 'blade'],
  \ 'at': '\(........\)\?{{ \%# }}', 'char': '<BS>', 'input': '<Right><Right><BS><BS><BS>', 'delete': 2
  \})

" {# <Space> #}
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '\(........\)\?{\%#}', 'char': '#', 'input': '#<Space><Space>#<Left><Left>'
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '\(........\)\?{# \%# #}', 'char': '<BS>', 'input': '<Right><Right><BS><BS><BS>', 'delete': 2
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '\(........\)\?{\%#}', 'char': '#', 'input': '##<Left>'
  \})
call lexima#add_rule({
  \ 'filetype' : 'twig',
  \ 'at': '\(........\)\?{#\%##}', 'char': '<Space>', 'input' : '<Space><Space><Left>'
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '\(........\)\?{# \%# #}', 'char': '<BS>', 'input': '<Right><Right><BS><BS><BS>', 'delete': 2
  \})

" {% <Space> %}
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '\(........\)\?{\%#}', 'char': '%', 'input': '%<Space><Space>%<Left><Left>'
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '\(........\)\?{% \%# %}', 'char': '<BS>', 'input': '<Right><Right><BS><BS><BS>', 'delete': 2
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '\(........\)\?{\%#}', 'char': '%', 'input': '%%<Left>'
  \})
call lexima#add_rule({
  \ 'filetype' : 'twig',
  \ 'at': '\(........\)\?{%\%#%}', 'char': '<Space>', 'input' : '<Space><Space><Left>'
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '\(........\)\?{% \%# %}', 'char': '<BS>', 'input': '<Right><Right><BS><BS><BS>', 'delete': 2
  \})

" {% = %}
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'char': '=', 'at': '{%.* \w\+\%#.*%}', 'input': '='
  \})
