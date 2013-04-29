" file: filesize.vim

" Exit quickly when this plugin was already loaded
if exists('g:loaded_filesize_plugin')
    finish
endif
let g:loaded_filesize_plugin = 1

command! -nargs=0 FileSize :call FileSize()

" Statusline function
function! FileSize()
    let bytes = getfsize(expand('%:p'))
    if bytes <= 0
        return ''
    endif
    if bytes < 1024
        return bytes . 'B'
    else
        return (bytes / 1024) . 'K'
    endif
endfunction
