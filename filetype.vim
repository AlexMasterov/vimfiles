if exists('did_load_filetypes')
  finish
endif
let did_load_filetypes = 1

augroup filetypedetect
  " Vim
  autocmd BufNewFile,BufRead *{.vim,vimrc*},$MYVIMRC set filetype=vim
  " Toml
  autocmd BufNewFile,BufRead *.toml set filetype=toml

  " PHP
  autocmd BufNewFile,BufRead *.{php,phpt} set filetype=php
  " JavaScript
  autocmd BufNewFile,BufRead *.{js,jsx,es6,mjs} set filetype=javascript
  " Python
  autocmd BufNewFile,BufRead *.py set filetype=python
  " Rust
  autocmd BufNewFile,BufRead *.rt set filetype=rust
  " Golang
  autocmd BufNewFile,BufRead *.go set filetype=golang
  " Haskell
  autocmd BufNewFile,BufRead *.hs set filetype=haskell
  " Scala
  autocmd BufNewFile,BufRead *.scala set filetype=scala
  " Ruby
  autocmd BufNewFile,BufRead *.{rb,rbw},Vagrantfile* set filetype=ruby
  " Lua
  autocmd BufNewFile,BufRead *.lua set filetype=lua
  " #F
  autocmd BufNewFile,BufRead *.fs set filetype=forth
  " C
  autocmd BufNewFile,BufRead *.{c,h} set filetype=c

  " HTML
  autocmd BufNewFile,BufRead *.{html,htm} set filetype=html
  " Json
  autocmd BufNewFile,BufRead *.{json,jsonp},.{babelrc,eslintrc} set filetype=json
  " Yaml
  autocmd BufNewFile,BufRead *.{yml,yaml} set filetype=yaml
  " XML
  autocmd BufNewFile,BufRead *.{xml,xml.*} set filetype=xml
  " Markdown
  autocmd BufNewFile,BufRead *.{md,markdown,mdown,mkd,mkdn} set filetype=markdown

  " Twig
  autocmd BufNewFile,BufRead *.{twig,*.twig} set filetype=twig
  " Blade
  autocmd BufNewFile,BufRead *.blade.php set filetype=blade

  " CSS
  autocmd BufNewFile,BufRead *.css set filetype=css
  " SASS
  autocmd BufNewFile,BufRead *.scss set filetype=css syntax=sass
  " SugarSS
  autocmd BufNewFile,BufRead *.sss set filetype=sugarss

  " Docker
  autocmd BufNewFile,BufRead Dockerfile,*.Dockerfile set filetype=dockerfile
  " Nginx
  autocmd BufNewFile,BufRead */nginx/** set filetype=nginx
  " Diff files
  autocmd BufNewFile,BufRead *.{diff,patch}	set filetype=diff
  " Bash
  autocmd BufNewFile,BufRead *.sh,[.]bash* set filetype=sh
  " DOS Batch
  autocmd BufNewFile,BufRead *.{bat,sys} set filetype=dosbatch
  " MSDOS
  autocmd BufNewFile,BufRead *.ini set filetype=dosini
  " Configure files
  autocmd BufNewFile,BufRead *.{cfg,conf},.env set filetype=cfg
  " CMake
  autocmd BufNewFile,BufRead CMakeLists.txt	set filetype=cmake
  " M4
  autocmd BufNewFile,BufRead *.m4	set filetype=m4
  " Git
  autocmd BufNewFile,BufRead *.git{[/]config,modules} set filetype=gitconfig
augroup END
