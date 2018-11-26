"--------------------------------------------------------------------------
" Abbreviations

" The current file
inoreabbrev <silent> ##f <C-r>=expand('%:t')<CR>
cnoreabbrev          ##f <C-r>=expand('%:t')<CR>

" The current file path
inoreabbrev <silent> ##p <C-r>=expand('%:p')<CR>
cnoreabbrev          ##p <C-r>=expand('%:p')<CR>

" The current file directory
inoreabbrev <silent> ##d <C-r>=expand('%:p:h')<CR>
cnoreabbrev          ##d <C-r>=expand('%:p:h')<CR>

" The current timestamp
inoreabbrev <silent> ##t <C-r>=strftime('%Y-%m-%d')<CR>
cnoreabbrev          ##t <C-r>=strftime('%Y-%m-%d')<CR>

" The current Unix time
inoreabbrev <silent> ##u <C-r>=localtime()<CR>
cnoreabbrev          ##u <C-r>=localtime()<CR>

" Shebang
inoreabbrev <silent> <expr> ##! '#!/usr/bin/env ' . &filetype

" Typos
iabbrev Licence License
iabbrev cosnt   const
iabbrev laod    load
iabbrev paylaod payload
iabbrev Paylaod Payload
