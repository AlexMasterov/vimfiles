" GUI
"---------------------------------------------------------------------------

if has('gui_running')
  if has('vim_starting')
    winsize 190 30 | winpos 492 372
    " winsize 190 32 | winpos 492 350
  endif
  set guioptions=ac
  set guicursor=a:blinkon0  " turn off blinking the cursor
  set linespace=4           " extra spaces between rows

  if IsWindows()
    set guifont=Droid_Sans_Mono:h10,Consolas:h11
  else
    set guifont=Droid\ Sans\ Mono\ 10,Consolas\ 11
  endif

  " DirectWrite
  if IsWindows() && has('directx')
    set renderoptions=type:directx,gamma:2.2,contrast:0.5,level:0.5,geom:1,renmode:3,taamode:2
  endif
endif

if exists('g:GuiLoaded')
  " Use cursor shape feature
  set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

  set termguicolors
  try
    GuiMousehide 1
    GuiLinespace 3
    GuiFont Droid Sans Mono:h10
  catch
  endtry
endif
