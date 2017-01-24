let g:easy_align_ignore_groups = ['Comment', 'String']
let g:easy_align_delimiters = {
  \ '>': {
  \   'pattern': '>>\|=>\|>'
  \ },
  \ ']': {
  \   'pattern': '[[\]]',
  \   'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0
  \ },
  \ ')': {
  \   'pattern': '[()]',
  \   'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0
  \ },
  \ 'f': {
  \   'pattern': ' \(\S\+(\)\@=',
  \   'left_margin': 0, 'right_margin': 0
  \ },
  \ 'd': {
  \   'pattern': ' \(\S\+\s*[;=]\)\@=',
  \   'left_margin': 0, 'right_margin': 0
  \ },
  \ ';': {
  \   'pattern': ':',
  \   'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1
  \ },
  \ '/': {
  \   'pattern': '//\+\|/\*\|\*/',
  \   'ignore_groups': ['^\(.\(Comment\)\@!\)*$'],
  \   'delimiter_align': 'l'
  \ },
  \ '=': {
  \   'pattern': '===\|<=>\|=\~[#?]\?\|=>\|[:+/*!%^=><&|.-?]*=[#?]\?\|[-=]>\|<[-=]',
  \   'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0
  \ }
  \}
