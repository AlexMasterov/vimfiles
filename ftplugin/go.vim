" Disable default settings
let b:did_ftplugin = 1

Indent 2

setlocal formatoptions-=t
setlocal noexpandtab

setlocal commentstring=//\ %s,s1:/*,mb:*,ex:*/,://

setlocal omnifunc=go#complete#Complete
