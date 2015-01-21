" file: tabline.vim
" fork: http://konishchevdmitry.blogspot.com/2008/07/vim.html

" Exit quickly when this plugin was already loaded
if exists('g:loaded_tabline_plugin')
    finish
endif
let g:loaded_tabline_plugin = 1

function! MyTabLine()
    let line = ''
    for i in range(tabpagenr('$'))
        " Select the highlighting
        if i + 1 == tabpagenr()
            let line .= '%#TabLineSel#'
        else
            let line .= '%#TabLine#'
        endif
        " Set the tab page number (for mouse clicks)
        let line .= '%' . (i + 1) . 'T'
        " The label is made by MyTabLabel()
        let line .= ' %{MyTabLabel(' . (i + 1) . ')} '
    endfor

    " After the last tab fill with TabLineFill and reset tab page nr
    let line .= '%#TabLineFill#%T'

    " Right-align the label to close the current tab page
    " if tabpagenr('$') > 1
    "     let line .= '%=%#TabLine#%999XX'
    " endif

    return line
endfunction

function! MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let label = fnamemodify(bufname(buflist[winnr-1]), ':t')

    if label == ''
        let label = 'NoName'
    elseif strlen(label) > 15
        let label = strpart(label, 0, 15) . '..'
    endif

    if getbufvar(buflist[winnr-1], '&modified')
        let label = '+' . label
    endif
    let label = a:n . ':' . label
    return label
endfunction

set tabline=%!MyTabLine()
