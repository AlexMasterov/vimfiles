let b:did_ftplugin = 1

Indent 2

setlocal nowrap textwidth=120
setlocal nonumber norelativenumber
setlocal commentstring=//%s comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
setlocal iskeyword+=$

hi typescriptBraces        guifg=#999999 gui=NONE
hi typescriptGlobalObjects guifg=#D14000 gui=NONE
hi typescriptAccessPublic  guifg=#1E347B gui=NONE
hi typescriptAccessPrivate guifg=#0077AA gui=NONE
