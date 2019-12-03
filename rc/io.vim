"---------------------------------------------------------------------------
" I/O

set noautoread
set lazyredraw  " don't redraw while executing macros

" keyboard
set keymap=russian-jcukenwin
set iskeyword=@,48-57,_,192-255,:
set iminsert=0 imsearch=0

" clipboard
set clipboard=unnamedplus

" timers
set timeout
set ttimeout
set ttimeoutlen=50
set updatetime=100   " CursorHold time

" backup
set nobackup
set writebackup
set backupcopy=yes

" views
set viewoptions=cursor,slash,unix

" undos
set undofile
set undolevels=500
set undoreload=1000

" swaps
set noswapfile

if has('nvim')
  set nofsync
endif

call Iter([&undodir, &viewdir, &backupdir], {dir -> vimrc#make_dir(dir, v:true)})
