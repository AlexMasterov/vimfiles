" file: tabline.vim
" fork: http://konishchevdmitry.blogspot.com/2008/07/vim.html

function! MyTabLine()
    let line = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let line .= '%#TabLineSel#'
        else
            let line .= '%#TabLine#'
        endif
        " set the tab page number (for mouse clicks)
        let line .= '%' . (i + 1) . 'T'
        " the label is made by MyTabLabel()
        let line .= ' %{MyTabLabel(' . (i + 1) . ')} '
    endfor
    " after the last tab fill with TabLineFill and reset tab page nr
    let line .= '%#TabLineFill#%T'

    return line
endfunction

function! MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let label = fnamemodify(bufname(buflist[winnr-1]), ':t')

    if label == ''
        let label = 'NoName'
    endif
    if getbufvar(buflist[winnr-1], '&modified')
        let label = '+'.label
    endif
    let label = a:n.':'.label

    return label
endfunction

set tabline=%!MyTabLine()
