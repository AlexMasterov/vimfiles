" Abbreviations

" The current file
inoreabbrev ##f <C-r>=expand('%:t')<CR>
cnoreabbrev ##f <C-r>=expand('%:t')<CR>

" The current file path
inoreabbrev ##p <C-r>=expand('%:p')<CR>
cnoreabbrev ##p <C-r>=expand('%:p')<CR>

" The current file directory
inoreabbrev ##d <C-r>=expand('%:p:h')<CR>
cnoreabbrev ##d <C-r>=expand('%:p:h')<CR>

" The current timestamp
inoreabbrev ##t <C-r>=strftime('%Y-%m-%d')<CR>
cnoreabbrev ##t <C-r>=strftime('%Y-%m-%d')<CR>

" The current Unix time
inoreabbrev ##u <C-r>=localtime()<CR>
cnoreabbrev ##u <C-r>=localtime()<CR>

" Shebang
inoreabbrev <expr> ##! '#!/usr/bin/env ' . &filetype

" Typos
iabbrev cosnt   const
iabbrev Licence License
