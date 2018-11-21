let b:did_ftplugin = 1

Indent 2

setlocal fileformat=unix
setlocal formatoptions+=2l
setlocal nonumber norelativenumber

syntax match jsonComment "//.\{-}$"
hi link jsonComment Comment
