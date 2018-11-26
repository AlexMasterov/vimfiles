"---------------------------------------------------------------------------
" Dein

let s:statePath = expand('$VIMCACHE/dein')

if dein#load_state(s:statePath)
  call dein#begin(s:statePath)

  let plugins = globpath('$VIMFILES/rc/plugins', '*.toml', v:false, v:true)
  for plugin in plugins
    call dein#load_toml(plugin)
  endfor

  unlet plugin plugins

  call dein#end()
  call dein#save_state()
endif
