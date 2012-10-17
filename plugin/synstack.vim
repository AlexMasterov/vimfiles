" Exit quickly when this plugin was already loaded
if exists('g:syn_stack')
    finish
endif
let g:syn_stack = 1

" Show syntax highlighting groups for word under cursor
function! <SID>SynStack()
    if !exists('*synstack')
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
