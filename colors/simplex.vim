" Vim colour file
" Maintainer:   Alex Masterov <alex.masterow@gmail.com>
" Last Change:  2013 Apr 22
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
hi iCursor                              guibg=#FF7311   gui=none
hi lCursor                              guibg=#FF7311   gui=none
hi Visual                               guibg=#BBDDFF   gui=none
hi VisualNOS                            guibg=#BBDDFF   gui=none
hi LineNr               guifg=#BEBEBE   guibg=#F8F8F8   gui=none
hi NonText              guifg=#FAFAFA   guibg=#FFFFFF   gui=none
hi VertSplit            guifg=#EEEEEE   guibg=#EEEEEE   gui=none
hi StatusLine           guifg=#333333   guibg=#EEEEEE   gui=none
hi StatusLineNC         guifg=#888888   guibg=#EEEEEE   gui=none
hi TabLine              guifg=#333333   guibg=#FFFFFF   gui=none
hi TabLineFill          guifg=#333333   guibg=#FFFFFF   gui=none
hi TabLineSel           guifg=#333333   guibg=#BBDDFF   gui=none

hi Folded               guifg=#60656F   guibg=#EEEEEE   gui=none
hi SignColumn           guifg=#EEEEEE   guibg=#FFFFFF   gui=none

hi ErrorMsg             guifg=#333333   guibg=#FFBBBB   gui=none
hi Error                guifg=#333333   guibg=#FF0000   gui=none
hi ModeMsg              guifg=#333333   guibg=#EEEEEE   gui=none
hi MoreMsg              guifg=#333333   guibg=#EEEEEE   gui=none

" Users
hi User1                guifg=#0000FF   guibg=#EEEEEE   gui=none
hi User2                guifg=#D14000   guibg=#EEEEEE   gui=none

" Vim 7.x specific
if version >= 700
    hi Pmenu            guifg=#60656F   guibg=#F0F5FF   gui=none
    hi PmenuSel         guifg=#FFFFFF   guibg=#3585EF   gui=bold
    hi PmenuSbar        guifg=#D0D5DD   guibg=#E0E5EE   gui=bold
    hi PmenuThumb       guifg=#E0E5EE   guibg=#C0C5DD   gui=bold
    hi Search                           guibg=#FCFCAA   gui=none
    hi IncSearch                        guibg=#FFFF33   gui=bold
    hi MatchParen                       guibg=#CCFFDD   gui=none
    hi CursorLine                       guibg=#F1FAFF   gui=none
    hi CursorLineNr                     guibg=#F1FAFF   gui=none
    hi CursorColumn                     guibg=#F1FAFF   gui=none
    hi ColorColumn                      guibg=#FAFAFA   gui=none
endif

" Syntax
hi Todo                 guifg=#446644   guibg=#DDEECC   gui=none
hi Type                 guifg=#0050B0                   gui=none
hi Comment              guifg=#93A1A1                   gui=none
hi Constant             guifg=#BA4747                   gui=none
hi Function             guifg=#333333                   gui=bold
hi Operator             guifg=#333333                   gui=none
hi Delimiter            guifg=#333333                   gui=none
hi Statement            guifg=#333333                   gui=none
hi Identifier           guifg=#333333                   gui=none
hi Conditional          guifg=#0050B0                   gui=none
hi Define               guifg=#0050B0                   gui=bold
hi PreProc              guifg=#446644                   gui=none
hi Special              guifg=#006633                   gui=none
hi Keyword              guifg=#007050                   gui=none
hi Number               guifg=#4183C4                   gui=none

hi link Character       Constant
hi link String          Constant
hi link Boolean         Constant
hi link Float           Number
hi link Include         Normal
hi link Function        Normal
hi link Label           Statement
hi link Exception       Statement
hi link Repeat          Conditional
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
hi phpEcho                    guifg=#333333                   gui=bold
hi phpType                    guifg=#0050B0                   gui=none
hi phpParent                  guifg=#999999                   gui=none
hi phpNumber                  guifg=#1299DA                   gui=none
hi phpBoolean                 guifg=#CD7F32                   gui=bold
hi phpClasses                 guifg=#B729D9                   gui=none
hi phpStatement               guifg=#0050B1                   gui=none
hi phpException               guifg=#0050B1                   gui=bold
hi phpOperator                guifg=#A67F59   guibg=#FFF9F9   gui=none
hi phpStrEsc                  guifg=#A67F59   guibg=#FFF9F9   gui=none
hi phpInclude                 guifg=#333333                   gui=bold
hi phpFunctions               guifg=#333333                   gui=bold
hi phpBraceError              guifg=#FF0000                   gui=bold
hi phpParentError             guifg=#FF0000                   gui=bold
hi phpSemicolon               guifg=#FF0000                   gui=bold
hi phpDefineFuncName          guifg=#3A75C4                   gui=bold
hi phpDefineClassName         guifg=#3A75C4                   gui=bold
hi phpMethodsVar              guifg=#008080                   gui=none
hi phpVarSelector             guifg=#708090                   gui=none
hi phpMemberSelector          guifg=#333333                   gui=none
hi phpMagicConstants          guifg=#009926                   gui=none

" Haskell
hi ConId                      guifg=#008080                   gui=none
hi hsConSym                   guifg=#D14000                   gui=none
hi hsVarSym                   guifg=#333333                   gui=none
hi hsType                     guifg=#1E347B                   gui=none
hi hsNumber                   guifg=#1299DA                   gui=none
hi hsImport                   guifg=#333333                   gui=bold
hi hsModule                   guifg=#333333                   gui=bold
hi hsPragma                   guifg=#009926                   gui=none
hi hsBoolean                  guifg=#CD7F32                   gui=bold
hi hsDelimiter                guifg=#999999                   gui=none
hi hsStatement                guifg=#0050B1                   gui=none
hi hsStructure                guifg=#0050B1                   gui=none
hi hsConditional              guifg=#0050B1                   gui=none
hi hsNiceOperator             guifg=#A67F59                   gui=none
hi hs_DeclareFunction         guifg=#D14000                   gui=none

" JS
hi javaScriptParens           guifg=#999999                   gui=none
hi javaScriptBraces           guifg=#999999                   gui=none
hi javaScriptBoolean          guifg=#CD7F32                   gui=bold
hi javaScriptOpSymbols        guifg=#A67F59   guibg=#FFF9F9   gui=none
hi javaScriptDOMObjects       guifg=#708090                   gui=none
hi javaScriptGlobalObjects    guifg=#708090                   gui=none
hi javaScriptBrowserObjects   guifg=#708090                   gui=none
hi javaScriptRegexpString     guifg=#009926                   gui=none

" HTML
hi htmlArg                    guifg=#0077AA                   gui=none
hi htmlTag                    guifg=#1E347B                   gui=none
hi htmlTagN                   guifg=#1E347B                   gui=none
hi htmlTagName                guifg=#1E347B                   gui=none
hi htmlEndTag                 guifg=#1E347B                   gui=none
hi htmlLink                   guifg=#0050B1                   gui=none

" CSS
hi cssBraces                  guifg=#999999                   gui=none
hi cssVendor                  guifg=#D14000                   gui=none
hi cssUIAttr                  guifg=#333333                   gui=none
hi cssBoxAttr                 guifg=#333333                   gui=none
hi cssTextAttr                guifg=#333333                   gui=none
hi cssFontAttr                guifg=#333333                   gui=none
hi cssRenderAttr              guifg=#333333                   gui=none
hi cssCommonAttr              guifg=#333333                   gui=none
hi cssPositioningAttr         guifg=#446644   guibg=#DDEECC   gui=none
hi cssBorderOutLineAttr       guifg=#A67F59   guibg=#FFF9F9   gui=none

" Twig
hi twigVariable               guifg=#333333                   gui=bold
hi twigBlockName              guifg=#333333                   gui=bold
hi twigStatement              guifg=#008080                   gui=none
hi twigOperator               guifg=#999999                   gui=none
hi twigVarDelim               guifg=#999999                   gui=none
hi twigTagDelim               guifg=#999999                   gui=none

" Yaml
hi yamlConstant               guifg=#CD7F32                   gui=bold
hi yamlFlowIndicator          guifg=#999999                   gui=none
hi yamlFlowMappingKey         guifg=#0050B1                   gui=none
hi yamlBlockMappingKey        guifg=#0050B1                   gui=none
hi yamlKeyValueDelimiter      guifg=#A67F59   guibg=#FFF9F9   gui=none

" Syntastic
hi SyntasticErrorSign         guifg=#FF7311                   gui=none
hi SyntasticWarningSign       guifg=#FF7311                   gui=none

" EasyMotion
hi link EasyMotionShade    Comment
hi link EasyMotionTarget   ErrorMsg
