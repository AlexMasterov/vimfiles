AutocmdFT javascript let b:sideways_definitions = [
  \   {
  \     'start': '<\k\+\_s\+',
  \     'end': '\s*/\?>',
  \     'delimited_by_whitespace': 1,
  \     'brackets': ['"''{', '"''}'],
  \   },
  \ ]

AutocmdFT rust let b:sideways_definitions = [
  \   {
  \     'start': '\<[A-Z]\k\+<',
  \     'end': '>',
  \     'delimiter': ',\s*',
  \     'brackets': ['<([', '>)]'],
  \     'single_line': 1,
  \   },
  \   {
  \     'start': '::<',
  \     'end': '>',
  \     'delimiter': ',\s*',
  \     'brackets': ['<([', '>)]'],
  \     'single_line': 1,
  \   },
  \   {
  \     'start': ')\_s*->\_s*',
  \     'end': '\_s*{',
  \     'delimiter': 'NO_DELIMITER_SIDEWAYS_CARES_ABOUT',
  \     'brackets': ['<([', '>)]'],
  \   },
  \ ]

AutocmdFT php let b:sideways_definitions = [
  \   {
  \     'start': '<%=\=\s*\k\{1,}',
  \     'end': '\s*%>',
  \     'delimiter': ',\s*',
  \     'brackets': ['([''"', ')]''"'],
  \   },
  \ ]

AutocmdFT go let b:sideways_definitions = [
  \   {
  \     'start': '{\_s*',
  \     'end': '\_s*}',
  \     'delimiter': ',\s*',
  \     'brackets': ['([''"', ')]''"'],
  \   },
  \ ]
