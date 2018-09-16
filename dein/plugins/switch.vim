nnoremap <silent> <S-Tab> :<C-u>silent call switch#Switch()<CR>
xnoremap <silent> <S-Tab> :silent call switch#Switch({'reverse': 1})<CR>
nnoremap <silent> ! :<C-u>silent call switch#Switch({'definitions': g:switch_quotes, 'reverse': 1})<CR>
nnoremap <silent> @ :<C-u>silent call switch#Switch({'definitions': g:switch_camelcase, 'reverse': 1})<CR>

let g:loaded_switch = 1
let g:switch_mapping = ''
let g:switch_reverse_mapping = ''
let g:switch_find_smallest_match = 1

let g:switch_definitions = [
  \   {
  \     '\Ctrue':  'false',
  \     '\Cfalse': 'true',
  \   },
  \ ]

let g:switch_quotes = [
  \   {
  \     "'\\(.\\{-}\\)'": '"\1"',
  \     '"\(.\{-}\)"': "'\\1'",
  \     '`\(.\{-}\)`': "'\\1'"
  \   }
  \ ]

let g:switch_camelcase = [
  \   {
  \     '\<\(\l\)\(\l\+\(\u\l\+\)\+\)\>': '\=toupper(submatch(1)) . submatch(2)',
  \     '\<\(\u\l\+\)\(\u\l\+\)\+\>':     "\\=tolower(substitute(submatch(0), '\\(\\l\\)\\(\\u\\)', '\\1_\\2', 'g'))",
  \     '\<\(\l\+\)\(_\l\+\)\+\>':        '\U\0',
  \     '\<\(\u\+\)\(_\u\+\)\+\>':        "\\=tolower(substitute(submatch(0), '_', '-', 'g'))",
  \     '\<\(\l\+\)\(-\l\+\)\+\>':        "\\=substitute(submatch(0), '-\\(\\l\\)', '\\u\\1', 'g')"
  \   }
  \ ]

AutocmdFT rust
  \ let b:switch_custom_definitions = [
  \  ['Result', 'Ok'],
  \  ['println!', 'eprintln!'],
  \  ['String', 'bool'],
  \  ['u8', 'u16', 'u32', 'u64', 'u128', 'isize'],
  \  ['i8', 'i16', 'i32', 'i64', 'i128', 'usize'],
  \  ['f32', 'f64'],
  \  ['enum', 'impl'],
  \  ['{:?}', '{:#?}'],
  \  {
  \    'let \(\k\+\)': 'let mut \1',
  \    'let mut\s\(\k\+\)': 'let \1',
  \  },
  \  {
  \    '&mut\s\(\k\+\)': '&\1',
  \    '&\%(mut\|\s\)\@!\(\k\+\)': '&mut \1',
  \   },
  \   {
  \    '\(fn\|struct\|mod\)\s\(\k\+\)': 'pub \1 \2',
  \    'pub\s\(fn\|struct\|mod\)\s\(\k\+\)': '\1 \2',
  \   },
  \ ]

AutocmdFT php
  \ let b:switch_custom_definitions = [
  \  ['prod', 'dev', 'test'],
  \  ['&&', '||'],
  \  ['and', 'or'],
  \  ['public', 'protected', 'private'],
  \  ['extends', 'implements'],
  \  ['string ', 'int ', 'array '],
  \  ['use', 'namespace'],
  \  ['var_dump', 'print_r'],
  \  ['include', 'require'],
  \  ['include_once', 'require_once'],
  \  ['$_GET', '$_POST', '$_REQUEST'],
  \  ['__DIR__', '__FILE__'],
  \  ['map', 'bind', 'ap'],
  \  {
  \    '\([^=]\)===\([^=]\)': '\1==\2',
  \    '\([^=]\)==\([^=]\)': '\1===\2'
  \  },
  \  {
  \    '\[[''"]\(\k\+\)[''"]\]': '->\1',
  \    '\->\(\k\+\)': '[''\1'']'
  \  },
  \  {
  \    '\(array\|list\)(\(.\{-}\))': '[\2]',
  \    '\[\(.\{-}\)]': '\array(\1)',
  \  },
  \  {
  \    '^class \(\k\+\)': 'final class \1',
  \    '^final class \(\k\+\)': 'abstract class \1',
  \    '^abstract class \(\k\+\)': 'trait \1',
  \    '^trait \(\k\+\)': 'class \1'
  \  }
  \]

AutocmdFT go
  \ let b:switch_custom_definitions = [
  \  ['var', 'const', 'type'],
  \  ['string', 'bool'],
  \  ['int8', 'uint8', 'int16', 'uint16', 'int32', 'uint32', 'int64', 'uint64'],
  \  ['float32', 'float64'],
  \  ['complex64', 'complex128'],
  \ ]

AutocmdFT javascript
  \ let b:switch_custom_definitions = [
  \  ['get', 'set'],
  \  ['var', 'const', 'let'],
  \  ['<', '>'], ['==', '!=', '==='],
  \  ['left', 'right'], ['top', 'bottom'],
  \  ['getElementById', 'getElementByClassName'],
  \  {
  \    '\function\s*(\(.\{-}\))': '(\1) =>'
  \  },
  \  {
  \    '\<\([a-zA-z.()]\+\) === false': '!\1',
  \    '!\<\([a-zA-z.()]\+\)':          '\1 === false',
  \  }
  \]

AutocmdFT html,twig,blade
  \ let b:switch_custom_definitions = [
  \  ['h1', 'h2', 'h3'],
  \  ['png', 'jpg', 'gif'],
  \  ['id=', 'class=', 'style='],
  \  {
  \    '<div\(.\{-}\)>\(.\{-}\)</div>': '<span\1>\2</span>',
  \    '<span\(.\{-}\)>\(.\{-}\)</span>': '<div\1>\2</div>'
  \  },
  \  {
  \    '<ol\(.\{-}\)>\(.\{-}\)</ol>': '<ul\1>\2</ul>',
  \    '<ul\(.\{-}\)>\(.\{-}\)</ul>': '<ol\1>\2</ol>'
  \  }
  \]

AutocmdFT css
  \ let b:switch_custom_definitions = [
  \  ['border-top', 'border-bottom'],
  \  ['border-left', 'border-right'],
  \  ['border-left-width', 'border-right-width'],
  \  ['border-top-width', 'border-bottom-width'],
  \  ['border-left-style', 'border-right-style'],
  \  ['border-top-style', 'border-bottom-style'],
  \  ['margin-left', 'margin-right'],
  \  ['margin-top', 'margin-bottom'],
  \  ['padding-left', 'padding-right'],
  \  ['padding-top', 'padding-bottom'],
  \  ['margin', 'padding'],
  \  ['height', 'width'],
  \  ['min-width', 'max-width'],
  \  ['min-height', 'max-height'],
  \  ['transition', 'animation'],
  \  ['absolute', 'relative', 'fixed'],
  \  ['inline', 'inline-block', 'block', 'flex'],
  \  ['overflow', 'overflow-x', 'overflow-y'],
  \  ['before', 'after'],
  \  ['none', 'block'],
  \  ['left', 'right'],
  \  ['top', 'bottom'],
  \  ['em', 'px', '%'],
  \  ['bold', 'normal'],
  \  ['hover', 'active']
  \]
