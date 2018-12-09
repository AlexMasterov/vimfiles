if exists('did_load_filetypes')
  finish
endif
let did_load_filetypes = 1

augroup filetypedetect
  " Vim
  autocmd BufNewFile,BufRead *.vim,vimrc*,$MYVIMRC set filetype=vim

  " PHP
  autocmd BufNewFile,BufRead *.{php,phpt} set filetype=php
  " JavaScript
  autocmd BufNewFile,BufRead *.{js,jsx,es6,mjs} set filetype=javascript
  " TypeScript
  autocmd BufNewFile,BufRead *.ts set filetype=typescript
  " Rust
  autocmd BufNewFile,BufRead *.{rs,rt} set filetype=rust
  " Golang
  autocmd BufNewFile,BufRead *.go set filetype=go
  " Python
  autocmd BufNewFile,BufRead *.py set filetype=python
  " Lua
  autocmd BufNewFile,BufRead *.lua set filetype=lua
  " #F
  autocmd BufNewFile,BufRead *.fs set filetype=forth
  " C
  autocmd BufNewFile,BufRead *.{c,h} set filetype=c
  " C++
  autocmd BufNewFile,BufRead *.{cc,cpp} set filetype=cpp
  " Haskell
  autocmd BufNewFile,BufRead *.hs set filetype=haskell
  " Scala
  autocmd BufNewFile,BufRead *.scala set filetype=scala
  " Ruby
  autocmd BufNewFile,BufRead *.{rb,rbw},Vagrantfile* set filetype=ruby

  " HTML
  autocmd BufNewFile,BufRead *.{html,htm} set filetype=html
  " Json
  autocmd BufNewFile,BufRead *.{json,jsonp},.{babelrc,eslintrc} set filetype=json
  " Yaml
  autocmd BufNewFile,BufRead *.{yml,yaml} set filetype=yaml
  " XML
  autocmd BufNewFile,BufRead *.{xml,xml.*} set filetype=xml
  " Toml
  autocmd BufNewFile,BufRead *.toml set filetype=toml
  " Markdown
  autocmd BufNewFile,BufRead *.{md,markdown,mdown,mkd,mkdn} set filetype=markdown
  " Text
  autocmd BufNewFile,BufRead *.txt set filetype=text
  " GraphQL
  autocmd BufNewFile,BufRead *.{graphql,gql} set filetype=graphql

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
  " Bash
  autocmd BufNewFile,BufRead *.sh,[.]bash* set filetype=sh
  " DOS Batch
  autocmd BufNewFile,BufRead *.{bat,sys} set filetype=dosbatch
  " MSDOS
  autocmd BufNewFile,BufRead *.ini set filetype=dosini
  " Makefile
  autocmd BufNewFile,BufRead *{[mM]akefile,mk,mak} set filetype=make
  " Configure files
  autocmd BufNewFile,BufRead *.{cfg,conf},.env set filetype=cfg
  " CMake
  autocmd BufNewFile,BufRead CMakeLists.txt set filetype=cmake
  " M4
  autocmd BufNewFile,BufRead *.m4 set filetype=m4
  " Git
  autocmd BufNewFile,BufRead *.git{[/]config,modules} set filetype=gitconfig
  " Diff files
  autocmd BufNewFile,BufRead *.{diff,patch} set filetype=diff

  " Terminal
  if has('nvim')
    autocmd TermOpen * set filetype=terminal
  else
    autocmd BufWinEnter *
      \ if &filetype ==# '' && &buftype ==# 'terminal' |
      \   set filetype=terminal |
      \ endif
  endif

  " Fallback
  autocmd BufNewFile,BufRead,StdinReadPost *
    \ if !did_filetype() && <SID>checkLine()
    \   | set filetype=FALLBACK conf |
    \ endif

  " Use the filetype detect plugins
  runtime! ftdetect/*.vim
augroup END

function! s:checkLine() abort
  for line in getline(1, 5)
    if line =~ '^#' | return v:true | endif
  endfor
  return v:false
endfunction
