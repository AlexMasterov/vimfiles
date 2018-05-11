inoremap <expr> =
  \ search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
  \: search('\(*\<bar>!\)\%#', 'bcn') ? '= '
  \: smartchr#one_of(' = ', '=', ' == ')

AutocmdFT javascript
  \  inoremap <buffer> <expr> $ smartchr#loop('$', 'this.', '$$')
  \| inoremap <buffer> <expr> - smartchr#loop('-', '--', '_')

AutocmdFT php
  \  inoremap <buffer> <expr> $ smartchr#loop('$', '$this->')
  \| inoremap <buffer> <expr> > smartchr#loop('>', '=>', '>>')

AutocmdFT go
  \ inoremap <buffer> <expr> - smartchr#loop('-', ':=', '--')

AutocmdFT c,cpp
  \ inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')

AutocmdFT haskell
  \  inoremap <buffer> <expr> \ smartchr#loop('\ ', '\\')
  \| inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')

AutocmdFT yaml
  \  inoremap <buffer> <expr> > smartchr#loop('>', '%>')
  \| inoremap <buffer> <expr> < smartchr#loop('<', '<%', '<%=')
