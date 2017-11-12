Indent 2

setlocal textwidth=120
setlocal commentstring={{--%s--}}

hi bladeEcho          guifg=#2B2B2B gui=bold
hi bladeKeyword       guifg=#008080 gui=NONE
hi bladePhpParenBlock guifg=#999999 gui=NONE
hi link bladeDelimiter phpParent
" Reset SQL syntax
hi link sqlStatement phpString
hi link sqlKeyword   phpString
