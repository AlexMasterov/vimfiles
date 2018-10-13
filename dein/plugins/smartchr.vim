AutocmdFT javascript
  \  inoremap <buffer> <expr> $ smartchr#loop('$', 'this', 'this.')
  \| inoremap <buffer> <expr> - smartchr#loop('-', '--', '_')

AutocmdFT php
  \  inoremap <buffer> <expr> $ smartchr#loop('$', '$this->')
  \| inoremap <buffer> <expr> > smartchr#loop('>', '=>', '>>')

AutocmdFT go
  \ inoremap <buffer> <expr> - smartchr#loop('-', ':=', '--')

AutocmdFT rust
  \  inoremap <buffer> <expr> - smartchr#loop('-', '->')
  \| inoremap <buffer> <expr> @ smartchr#loop('&', '&self', '&&', '@')
  \| inoremap <buffer> <expr> $ smartchr#loop('self::', 'super::', '$')

AutocmdFT c,cpp
  \ inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')

AutocmdFT haskell
  \  inoremap <buffer> <expr> \ smartchr#loop('\ ', '\\')
  \| inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')

AutocmdFT yaml
  \  inoremap <buffer> <expr> > smartchr#loop('>', '%>')
  \| inoremap <buffer> <expr> < smartchr#loop('<', '<%', '<%=')
