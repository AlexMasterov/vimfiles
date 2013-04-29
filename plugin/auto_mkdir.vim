" file: auto_mkdir.vim

" Exit quickly when this plugin was already loaded
if exists('g:loaded_automkdir_plugin')
    finish
endif
let g:loaded_automkdir_plugin = 1

au! BufWritePre,FileWritePre * :call <SID>auto_mkdir()

function! <SID>auto_mkdir()
    " Get directory the file is supposed to be saved in
    let s:dir = expand('<afile>:p:h')
    " Create that directory (and its parents) if it doesn't exist yet
    if !isdirectory(s:dir)
        call mkdir(s:dir, 'p')
    endif
endfunction
