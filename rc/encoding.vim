"---------------------------------------------------------------------------
" Encoding

set encoding=utf-8
set fileencodings=utf-8,cp1251
scriptencoding utf-8

set fileformat=unix
set fileformats=unix,dos,mac

if has('gui_running')
  let &termencoding = IsWindows() ? 'cp850' : ''
endif

" Open in UTF-8
command! -nargs=? -bar -bang -complete=file EUtf8
  \ edit<bang> ++enc=utf-8 <args>
" Open in UTF-16
command! -nargs=? -bar -bang -complete=file EUtf16
  \ edit<bang> ++enc=ucs-2le <args>
" Open in UTF-16BE
command! -nargs=? -bar -bang -complete=file EUtf16be
  \ edit<bang> ++enc=ucs-2 <args>
" Open in CP1251
command! -nargs=? -bar -bang -complete=file ECp1251
  \ edit<bang> ++enc=cp1251 <args>

" Write as Unix
command! -nargs=? -bar -bang -complete=file WUnix
  \ write<bang> ++fileformat=unix <args> | edit <args>
" Write as Dos
command! -nargs=? -bar -bang -complete=file WDos
  \ write<bang> ++fileformat=dos <args> | edit <args>
" Write as Mac
command! -nargs=? -bar -bang -complete=file WMac
  \ write<bang> ++fileformat=mac <args> | edit <args>
