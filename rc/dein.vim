"---------------------------------------------------------------------------
" Dein

let s:path = expand('$VIMHOME/dein')

if dein#load_state(s:path)
  call dein#begin(s:path)

  let plugins = globpath('$VIMFILES/rc/{plugins\,ftypes}*',
      \ '*.toml', v:false, v:true)

  for plugin in plugins
    call dein#load_toml(plugin)
  endfor | unlet plugin plugins

  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#end()
  call dein#save_state()
endif
