" file: toogglelist.vim
" fork: http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window

" Exit quickly when this plugin was already loaded
if exists('g:loaded_togglelist_plugin')
    finish
endif
let g:loaded_togglelist_plugin = 1

command! -nargs=0 ToggleLocationList :call ToggleList('Location List', 'l')
command! -nargs=0 ToggleQuickfixList :call ToggleList('Quickfix List', 'c')

function! GetBufferList()
    redir =>buflist
    silent! ls
    redir END
    return buflist
endfunction

function! ToggleList(bufname, pfx)
    let buflist = GetBufferList()
    for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
        if bufwinnr(bufnum) != -1
            exec(a:pfx . 'close')
            return
        endif
    endfor

    if a:pfx == 'l' && len(getloclist(0)) == 0
        echohl ErrorMsg
        echo 'Location List is empty.'
        return
    endif
    if a:pfx == 'c' && len(getqflist()) == 0
        echohl ErrorMsg
        echo 'Quickfix List is empty.'
        return
    endif

    exec(a:pfx . 'open')

    let winnr = winnr()
    if winnr() != winnr
        wincmd p
    endif
endfunction
