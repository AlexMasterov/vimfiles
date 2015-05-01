" Exit quickly when this plugin was already loaded
if exists('g:loaded_buftonewtap_plugin')
    finish
endif
let g:loaded_buftonewtap_plugin = 1

nnoremap <silent> <Plug>(buffer-to-new-tab) :<C-u>call <SID>move_window_into_tab_page(0)<CR>

function! s:move_window_into_tab_page(target_tabpagenr)
    " Move the current window into a:target_tabpagenr.
    " If a:target_tabpagenr is 0, move into new tab page.
    if a:target_tabpagenr < 0  " ignore invalid number.
        return
    endif
    let original_tabnr = tabpagenr()
    let target_bufnr = bufnr('')
    let window_view = winsaveview()

    if a:target_tabpagenr == 0
        tabnew
        tabmove  " Move new tabpage at the last.
        execute target_bufnr 'buffer'
        let target_tabpagenr = tabpagenr()
    else
        execute a:target_tabpagenr 'tabnext'
        let target_tabpagenr = a:target_tabpagenr
        topleft new  " FIXME: be customizable?
        execute target_bufnr 'buffer'
    endif
    call winrestview(window_view)

    execute original_tabnr 'tabnext'
    if 1 < winnr('$')
        close
    else
        enew
    endif

    execute target_tabpagenr 'tabnext'
endfunction " }}}
