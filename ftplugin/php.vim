let b:did_ftplugin = 1

" Syntax
let b:php_sql_query = 1
let b:php_highlight_html = 1

Indent 4

setlocal nonumber norelativenumber

setlocal nowrap textwidth=120
setlocal commentstring=//%s

setlocal iskeyword+=$,\\
setlocal matchpairs-=<:>

setlocal omnifunc=phpcomplete#CompletePHP
