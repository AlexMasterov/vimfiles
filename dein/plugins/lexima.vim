function! s:disableLeximaInsideRegexp(char) abort
  call lexima#add_rule({'char': a:char, 'at': '\S.*\%#.*\S/', 'input': a:char})
endfunction

" Quotes
for quote in split('" ''')
  call lexima#add_rule({'char': quote, 'input': repeat(quote, 2) . '<Left>', 'except': '\%#.*[-0-9a-zA-Z_,:]'})
  call lexima#add_rule({'char': quote, 'at': '\%#' . quote, 'input': '<Right>'})
  call lexima#add_rule({'char': quote, 'at': '\w\%#' . quote . '\@!'})
  call lexima#add_rule({'char': '<BS>', 'at': quote . '\%#' . quote, 'input': '<BS><Del>'})
  call s:disableLeximaInsideRegexp(quote)
endfor | unlet quote

" Pairs
let [left, right] = [0, 1]

for pair in split('() {} []')
  call lexima#add_rule({'char': pair[right], 'at': '\%#' . pair[right], 'input': '<Right>'})
  call lexima#add_rule({'char': pair[left], 'input_after': pair[right]})
" call lexima#add_rule({'char': pair[left], 'input': '<Space><BS>' . pair[left] . pair[right] . '<Left>', 'except': '\%#.*[-0-9a-zA-Z_,:]'})
" call lexima#add_rule({'char': pair[left], 'input_after': pair[right], 'except': '^\s*\%#'})
endfor | unlet pair

unlet left right

call lexima#add_rule({'char': '<BS>', 'at': '(\%#)', 'input': '<BS>', 'delete': 1})
call lexima#add_rule({'char': '<BS>', 'at': '{\%#}', 'input': '<BS>', 'delete': 1})
call lexima#add_rule({'char': '<BS>', 'at': '\[\%#\]', 'input': '<BS>', 'delete': 1})

" {{ <Space> }}
call lexima#add_rule({
  \ 'filetype': ['twig', 'blade'],
  \ 'at': '{\%#}', 'char': '{', 'input': '{<Space>', 'input_after': '<Space>}'
  \})
call lexima#add_rule({
  \ 'filetype': ['twig', 'blade'],
  \ 'at': '{{ \%# }}', 'char': '<BS>', 'input': '<BS><BS>', 'delete': 2
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '{{\%#}}', 'char': '{', 'input': '{}<Left>'
  \})
call lexima#add_rule({
  \ 'filetype': ['twig', 'blade'],
  \ 'at': '{{\%#}}', 'char': '<Space>', 'input' : '<Space><Space><Left>'
  \})
call lexima#add_rule({
  \ 'filetype': ['twig', 'blade'],
  \ 'at': '{{ \%# }}', 'char': '<BS>', 'input': '<Right><Right><BS><BS><BS>', 'delete': 2
  \})

" {# <Space> #}
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '{\%#}', 'char': '#', 'input': '#<Space><Space>#<Left><Left>'
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '{# \%# #}', 'char': '<BS>', 'input': '<Right><Right><BS><BS><BS>', 'delete': 2
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '{\%#}', 'char': '#', 'input': '##<Left>'
  \})
call lexima#add_rule({
  \ 'filetype' : 'twig',
  \ 'at': '{#\%##}', 'char': '<Space>', 'input' : '<Space><Space><Left>'
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '{# \%# #}', 'char': '<BS>', 'input': '<Right><Right><BS><BS><BS>', 'delete': 2
  \})

" {% <Space> %}
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '{\%#}', 'char': '%', 'input': '%<Space><Space>%<Left><Left>'
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '{% \%# %}', 'char': '<BS>', 'input': '<Right><Right><BS><BS><BS>', 'delete': 2
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '{\%#}', 'char': '%', 'input': '%%<Left>'
  \})
call lexima#add_rule({
  \ 'filetype' : 'twig',
  \ 'at': '{%\%#%}', 'char': '<Space>', 'input' : '<Space><Space><Left>'
  \})
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'at': '{% \%# %}', 'char': '<BS>', 'input': '<Right><Right><BS><BS><BS>', 'delete': 2
  \})

" {% = %}
call lexima#add_rule({
  \ 'filetype': 'twig',
  \ 'char': '=', 'at': '{%.* \w\+\%#.*%}', 'input': '='
  \})
