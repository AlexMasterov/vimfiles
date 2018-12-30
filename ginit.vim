" Use the last UI in the list
let ui_chan = nvim_list_uis()[-1].chan
let ui_name = get(nvim_get_chan_info(ui_chan).client, 'name', '')

" https://github.com/equalsraf/neovim-qt/blob/master/src/gui/runtime/doc/nvim_gui_shim.txt
if ui_name ==# 'nvim-qt'
  let g:clipboard = {
    \   'name': ui_name,
    \   'cache_enabled': 1,
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
  call rpcnotify(0, 'Gui', 'Option', 'Popupmenu', v:false)

  command! -nargs=1 FullScreen
    \ call rpcnotify(0, 'Gui', 'WindowFullScreen', <q-args>)
  command! -nargs=1 Maximized
    \ call rpcnotify(0, 'Gui', 'WindowMaximized', <q-args>)

  augroup nvim_qt
    autocmd!
    autocmd VimLeave * call rpcnotify(0, 'Gui', 'Close')
  augroup END
endif
