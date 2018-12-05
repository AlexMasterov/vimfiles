"---------------------------------------------------------------------------
" Dein

let s:path = expand('$VIMHOME/dein')

if dein#load_state(s:path)
  call dein#begin(s:path)

  let plugins = globpath('$VIMFILES/rc/plugins', '*.toml', v:false, v:true)

  for plugin in plugins
    call dein#load_toml(plugin)
  endfor | unlet plugin plugins

  call dein#end()
  call dein#save_state()
endif
