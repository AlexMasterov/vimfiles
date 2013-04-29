" Exit quickly when this plugin was already loaded
if exists('g:loaded_synstack_plugin')
    finish
endif
let g:loaded_synstack_plugin = 1

command! -nargs=0 SynStack :call SynStack()

" Show syntax highlighting groups for word under cursor
function! SynStack()
    let synid = synIDattr(synID(line('.'),col('.'), 0), 'name')
    let synattr = synIDattr(synIDtrans(synID(line('.'), col('.'), 0)), 'name')

    if synid == ''
        let status = ''
    elseif synid == synattr
        let status = synid
    else
        let status = synid . ' [' . synattr . ']'
    endif

    return status
endfunction
