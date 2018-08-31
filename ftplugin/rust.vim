" Disable default settings
let b:did_ftplugin = 1

Indent 2

setlocal nowrap textwidth=120
setlocal formatoptions-=t formatoptions+=croqnl

setlocal comments=s0:/*!,m:\ ,ex:*/,s1:/*,mb:*,ex:*/,:///,://!,://
setlocal commentstring=//%s

" j was only added in 7.3.541, so stop complaints about its nonexistence
silent! setlocal formatoptions+=j

" setlocal conceallevel=1 concealcursor=n
" syntax match rustOperator "->" conceal cchar=→
" syntax match rustOperator "=>" conceal cchar=⇒
" syntax match rustOperator "<=" conceal cchar=≤
" syntax match rustOperator ">=" conceal cchar=≥
" syntax match rustOperator "!=" conceal cchar=≢
