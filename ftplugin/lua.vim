let b:did_ftplugin = 1

Indent 2

setlocal define=function
setlocal include=require

setlocal includeexpr=substitute(v:fname, '\\.', '/', 'g')
