" Vim colour file
" Maintainer:   Alex Masterov <alex.masterow@gmail.com>
" Last Change:  2012 May 11
" Description:  GUI only

set background=light

hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'simplex'

hi Normal               guifg=#333333   guibg=#FFFFFF   gui=none
hi Title                guifg=#333333   guibg=#FFFFFF   gui=none
hi Cursor                               guibg=#FF7311   gui=none
hi lCursor                              guibg=#FF7311   gui=none
hi LineNr               guifg=#BEBEBE   guibg=#F8F8F8   gui=none
hi Visual                               guibg=#BBDDFF   gui=none
hi NonText              guifg=#FAFAFA   guibg=#FFFFFF   gui=none
hi StatusLine           guifg=#333333   guibg=#EEEEEE   gui=none
hi StatusLineNC         guifg=#888888   guibg=#EEEEEE   gui=none
hi VertSplit            guifg=#EEEEEE   guibg=#EEEEEE   gui=none
hi TabLine                              guibg=#FFFFFF   gui=none
hi TabLineSel                           guibg=#BBDDFF   gui=none
hi TabLineFill          guifg=#FFFFFF                   gui=none

hi SignColumn           guifg=#EEEEEE   guibg=#FFFFFF   gui=none
hi Folded               guifg=#60656F   guibg=#EEEEEE   gui=none

hi ErrorMsg             guifg=#333333   guibg=#FFBBBB   gui=none
hi Error                guifg=#333333   guibg=#FF0000   gui=none
hi ModeMsg              guifg=#333333   guibg=#EEEEEE   gui=none
hi MoreMsg              guifg=#333333   guibg=#EEEEEE   gui=none

" Users
hi User1                guifg=#0000FF   guibg=#EEEEEE   gui=none
hi User2                guifg=#D14000   guibg=#EEEEEE   gui=none

" Vim 7.x specific
if version >= 700
    hi MatchParen                       guibg=#CCFFDD   gui=none
    hi Pmenu            guifg=#60656F   guibg=#F0F5FF   gui=none
    hi PmenuSel         guifg=#FFFFFF   guibg=#3585EF   gui=bold
    hi PmenuSbar        guifg=#D0D5DD   guibg=#E0E5EE   gui=bold
    hi PmenuThumb       guifg=#E0E5EE   guibg=#C0C5DD   gui=bold
    hi Search                           guibg=#FCFCAA   gui=none
    hi IncSearch                        guibg=#FFFF33   gui=bold
    hi CursorLine                       guibg=#F1FAFF   gui=none
    hi CursorLineNr                     guibg=#F1FAFF   gui=none
    hi ColorColumn                      guibg=#FAFAFA   gui=none
endif

" Syntax highlighting
hi Comment              guifg=#93A1A1                   gui=none
hi Todo                 guifg=#446644   guibg=#DDEECC   gui=none
hi Operator             guifg=#333333                   gui=none
hi Identifier           guifg=#333333                   gui=none
hi Statement            guifg=#333333                   gui=none
hi Type                 guifg=#0050B0                   gui=none
hi Constant             guifg=#BA4747                   gui=none
hi Conditional          guifg=#0050B0                   gui=none
hi Delimiter            guifg=#333333                   gui=none
hi PreProc              guifg=#006633                   gui=none
hi Special              guifg=#006633                   gui=none
hi Keyword              guifg=#007050                   gui=none
hi Define               guifg=#0050B0                   gui=bold
hi Function             guifg=#333333                   gui=bold

hi link Function        Normal
hi link Character       Constant
hi link String          Constant
hi link Boolean         Constant
hi link Number          Constant
hi link Float           Number
hi link Repeat          Conditional
hi link Label           Statement
hi link Exception       Statement
hi link Include         Normal
hi link Define          PreProc
hi link Macro           PreProc
hi link PreCondit       PreProc
hi link StorageClass    Type
hi link Structure       Type
hi link Typedef         Type
hi link Tag             Special
hi link SpecialChar     Special
hi link SpecialComment  Special
hi link Debug           Special

" PHP
hi phpEcho              guifg=#333333   gui=bold
hi phpNumber            guifg=#1299DA   gui=none
hi phpBoolean           guifg=#CD7F32   gui=bold
hi phpClasses           guifg=#B729D9   gui=none
hi phpStatement         guifg=#CD7F32   gui=none
hi phpException         guifg=#CD7F32   gui=bold
hi phpFunctions         guifg=#333333   gui=bold
hi phpParent            guifg=#93A1A1   gui=none
hi phpBraceError        guifg=#FF0000   gui=bold
hi phpParentError       guifg=#FF0000   gui=bold
hi phpSemicolon         guifg=#FF0000   gui=bold
hi phpDefineFuncName    guifg=#3A75C4   gui=bold
hi phpDefineClassName   guifg=#3A75C4   gui=bold
hi phpInclude           guifg=#333333   gui=bold
hi phpMethodsVar        guifg=#008080   gui=none
hi phpMemberSelector    guifg=#333333   gui=none
hi phpVarSelector       guifg=#777777   gui=none

" HTML
hi htmlTag              guifg=#1E347B   gui=none
hi htmlTagN             guifg=#1E347B   gui=none
hi htmlTagName          guifg=#1E347B   gui=none
hi htmlEndTag           guifg=#1E347B   gui=none
hi htmlLink             guifg=#0088CC   gui=underline

" CSS
hi cssBraces            guifg=#93A1A1   gui=none
hi cssRenderAttr        guifg=#333333   gui=none
hi cssTextAttr          guifg=#333333   gui=none
hi cssFontAttr          guifg=#333333   gui=none
hi cssUIAttr            guifg=#333333   gui=none
hi cssCommonAttr        guifg=#333333   gui=none

" JS
hi javaScriptParens     guifg=#93A1A1   gui=none
hi javaScriptBraces     guifg=#93A1A1   gui=none
hi javaScriptOperator   guifg=#3A75C4   gui=none
hi javaScriptIdentifier guifg=#008080   gui=none

" Twig
hi twigVariable         guifg=#333333   gui=bold
hi twigBlockName        guifg=#333333   gui=bold
hi twigTagDelim         guifg=#93A1A1   gui=none
hi twigVarDelim         guifg=#93A1A1   gui=none
hi twigOperator         guifg=#93A1A1   gui=none
hi twigStatement        guifg=#008080   gui=none

" EasyMotion
hi EasyMotionTarget     guifg=#333333   guibg=#FFBBBB   gui=bold
hi link EasyMotionShade  Comment
