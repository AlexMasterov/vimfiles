" Pairs
let [left, right] = [0, 1]

for pair in split('() {} []')
  call lexima#add_rule({'char': pair[left], 'input_after': pair[right], 'except': '\%#.*[-0-9a-zA-Z_,:]'})
  call lexima#add_rule({'char': pair[right], 'at': '\%#' . pair[right], 'leave': 1})
endfor | unlet pair left right

call lexima#add_rule({'char': '<BS>', 'at': '(\%#)', 'input': '<BS>', 'delete': 1})
call lexima#add_rule({'char': '<BS>', 'at': '{\%#}', 'input': '<BS>', 'delete': 1})
call lexima#add_rule({'char': '<BS>', 'at': '\[\%#\]', 'input': '<BS>', 'delete': 1})
