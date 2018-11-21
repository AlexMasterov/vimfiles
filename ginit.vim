call rpcnotify(0, 'Gui', 'Linespace', 6)
call rpcnotify(0, 'Gui', 'Font', 'Droid Sans Mono:h10', v:true)

autocmd VimLeave * call rpcnotify(0, 'Gui', 'Close')
