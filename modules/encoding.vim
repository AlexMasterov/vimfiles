" Encoding
"--------------------------------------------------------------------------

set encoding=utf-8
scriptencoding utf-8

if IsWindows()
  set fileencodings=utf-8,cp1251
  set termencoding=cp850  " cmd.exe uses cp850
else
  set termencoding=       " same as 'encoding'
endif

" Default fileformat
set fileformat=unix
set fileformats=unix,dos,mac

" Open in UTF-8
command! -nargs=? -bar -bang -complete=file EUtf8
    \ edit<bang> ++enc=utf-8 <args>
" Open in CP1251
command! -nargs=? -bar -bang -complete=file ECp1251
    \ edit<bang> ++enc=cp1251 <args>

" Write as Unix
command! -nargs=? -bar -bang -complete=file WUnix
    \ write<bang> ++fileformat=unix <args> | edit <args>
" Write as Dos
command! -nargs=? -bar -bang -complete=file WDos
    \ write<bang> ++fileformat=dos <args> | edit <args>
