let b:did_ftplugin = 1

Indent 2

setlocal nowrap textwidth=120
" j was only added in 7.3.541, so stop complaints about its nonexistence
silent! setlocal formatoptions+=croqnlj

setlocal commentstring=//%s comments=s0:/*!,m:\ ,ex:*/,s1:/*,mb:*,ex:*/,:///,://!,://

" setlocal conceallevel=1 concealcursor=n
" syntax match rustOperator "->" conceal cchar=→
" syntax match rustOperator "=>" conceal cchar=⇒
" syntax match rustOperator "<=" conceal cchar=≤
" syntax match rustOperator ">=" conceal cchar=≥
" syntax match rustOperator "!=" conceal cchar=≢
