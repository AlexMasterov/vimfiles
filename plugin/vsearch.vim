" From http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html

" Exit quickly when this plugin was already loaded
if exists('g:loaded_vsearch_plugin')
    finish
endif
let g:loaded_vsearch_plugin = 1

" Makes * and # work on visual mode too
function! s:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype . '\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

xmap * :<C-u>call <SID>VSetSearch('/')<cr>/<C-R>=@/<cr><cr><C-o>
xmap # :<C-u>call <SID>VSetSearch('?')<cr>?<C-R>=@/<cr><cr><C-o>
