let b:did_ftplugin = 1

Indent 2

setlocal fileformat=unix
setlocal nowrap
setlocal nonumber norelativenumber
setlocal commentstring=#%s

setlocal formatoptions&
setlocal formatoptions+=tqn
setlocal formatlistpat=^\\s*\\(\\d\\+\\\|[a-z]\\)[\\].)]\\s*
