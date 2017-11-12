Indent 2

setlocal noautoindent
setlocal textwidth=120
setlocal commentstring={#<!--%s-->#}

setlocal omnifunc=htmlcomplete#CompleteTags

" Syntax
hi twigVariable  guifg=#2B2B2B gui=bold
hi twigStatement guifg=#008080 gui=NONE
hi twigOperator  guifg=#999999 gui=NONE
hi link twigBlockName twigVariable
hi link twigVarDelim  twigOperator
hi link twigTagDelim  twigOperator
