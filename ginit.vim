" Use the last UI in the list
let ui_chan = nvim_list_uis()[-1].chan

let g:clipboard = {
  \   'name': 'nvim-qt',
  \   'copy': {
  \      '+': {lines, regtype -> rpcnotify(ui_chan, 'Gui', 'SetClipboard', lines, regtype, '+')},
  \      '*': {lines, regtype -> rpcnotify(ui_chan, 'Gui', 'SetClipboard', lines, regtype, '*')},
  \    },
  \   'paste': {
  \      '+': {-> rpcrequest(ui_chan, 'Gui', 'GetClipboard', '+')},
  \      '*': {-> rpcrequest(ui_chan, 'Gui', 'GetClipboard', '*')},
  \   },
  \ }

call rpcnotify(0, 'Gui', 'Font', 'Droid Sans Mono:h10', v:true)
call rpcnotify(0, 'Gui', 'Linespace', 6)
call rpcnotify(0, 'Gui', 'Mousehide', v:true)

" call rpcnotify(0, 'Gui', 'WindowMaximized', a:enabled)
" call rpcnotify(0, 'Gui', 'WindowFullScreen', a:enabled)

augroup nvim_qt
  autocmd!
  autocmd VimLeave * call rpcnotify(0, 'Gui', 'Close')
augroup END
