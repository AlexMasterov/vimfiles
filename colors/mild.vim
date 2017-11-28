" Vim colour file
" File:         mild.vim
" Author:       Alex Masterov <alex.masterow@gmail.com>
" Source:       https://github.com/AlexMasterov/mild.vim
" Description:  GUI only

hi clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'mild'

set background=light

hi Normal               guifg=#2B2B2B   guibg=#F6F7F7   gui=NONE
hi NonText              guifg=#FAFAFA                   gui=NONE
hi Title                guifg=#2B2B2B   guibg=#F6F7F7   gui=NONE
hi Cursor               guifg=#FFFFFF   guibg=#FF7311   gui=NONE
hi iCursor              guifg=#2B2B2B   guibg=#FF7311   gui=NONE
hi lCursor              guifg=#2B2B2B   guibg=#FF7311   gui=NONE
hi Visual                               guibg=#CCE5FF   gui=NONE
hi VisualNOS            guifg=#2B2B2B   guibg=#CCE5FF   gui=NONE
hi LineNr               guifg=#B6B6B6   guibg=#F6F7F7   gui=NONE
hi VertSplit            guifg=#EEEEEE   guibg=#F6F7F7   gui=NONE
hi StatusLine           guifg=#2B2B2B   guibg=#EEEEEE   gui=NONE
hi StatusLineNC         guifg=#888888   guibg=#EEEEEE   gui=NONE
hi StatusLineTerm       guifg=#888888   guibg=#EEEEEE   gui=NONE
hi StatusLineTermNC     guifg=#888888   guibg=#EEEEEE   gui=NONE
hi TabLine              guifg=#2B2B2B   guibg=#F6F7F7   gui=NONE
hi TabLineFill          guifg=#2B2B2B   guibg=#F6F7F7   gui=NONE
hi TabLineSel           guifg=#2B2B2B   guibg=#BBDDFF   gui=NONE
hi Directory            guifg=#2B2B2B                   gui=NONE
hi WildMenu             guifg=#2B2B2B   guibg=#BBDDFF   gui=NONE

hi Folded               guifg=#006C91   guibg=#F6F7F7   gui=NONE
hi FoldColumn           guifg=#C9B0B0   guibg=#F6F7F7   gui=NONE

hi Question             guifg=#2B2B2B   guibg=#F6F7F7   gui=NONE
hi WarningMsg           guifg=#2B2B2B   guibg=#FFD2CF   gui=NONE
hi ModeMsg              guifg=#2B2B2B   guibg=#EEEEEE   gui=NONE
hi MoreMsg              guifg=#2B2B2B   guibg=#EEEEEE   gui=NONE
hi ErrorMsg             guifg=#2B2B2B   guibg=#FFBBBB   gui=NONE
hi Error                guifg=#2B2B2B   guibg=#FF7369   gui=NONE

hi Search               guifg=#2B2B2B   guibg=#FFFFC6   gui=NONE
hi IncSearch            guifg=#2B2B2B   guibg=#FFFF33   gui=bold
hi MatchParen           guifg=#2B2B2B   guibg=#FFE1CC   gui=NONE
hi CursorLine                           guibg=#E4F3FB   gui=NONE
hi CursorLineNr         guifg=#2B2B2B   guibg=#E4F3FB   gui=NONE
hi CursorColumn         guifg=#2B2B2B   guibg=#E4F3FB   gui=NONE
hi ColorColumn          guifg=#2B2B2B   guibg=#FAE5E4   gui=NONE
hi SignColumn           guifg=#EEEEEE   guibg=#F6F7F7   gui=NONE
hi SpecialKey           guifg=#E0E5EE                   gui=NONE

hi DiffAdd              guifg=#2B2B2B   guibg=#DDEECC   gui=NONE
hi DiffText             guifg=#2B2B2B   guibg=#F8FAFD   gui=NONE
hi DiffChange           guifg=#2B2B2B   guibg=#DDEECC   gui=NONE
hi DiffDelete           guifg=#2B2B2B   guibg=#FFBBBB   gui=NONE

" Syntax
"---------------------------------------------------------------------------
hi Type                 guifg=#0050B0                   gui=NONE
hi Number               guifg=#4183C4                   gui=NONE
hi Constant             guifg=#BA4747                   gui=NONE
hi Function             guifg=#2B2B2B                   gui=bold
hi Operator             guifg=#2B2B2B                   gui=NONE
hi Delimiter            guifg=#2B2B2B                   gui=NONE
hi Statement            guifg=#2B2B2B                   gui=NONE
hi Identifier           guifg=#2B2B2B                   gui=NONE
hi Conditional          guifg=#0050B0                   gui=NONE
hi Define               guifg=#0050B0                   gui=bold
hi PreProc              guifg=#446644                   gui=NONE
hi Special              guifg=#006633                   gui=NONE
hi Keyword              guifg=#007050                   gui=NONE

hi Comment              guifg=#93A1A1                   gui=NONE
hi Todo                 guifg=#446644   guibg=#DDEECC   gui=NONE

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

" Popup menu
"---------------------------------------------------------------------------
hi Pmenu                guifg=#60656F   guibg=#F0F5FF   gui=NONE
hi PmenuSel             guifg=#FFFFFF   guibg=#3585EF   gui=bold
hi PmenuSbar            guifg=#D0D5DD   guibg=#E0E5EE   gui=bold
hi PmenuThumb           guifg=#E0E5EE   guibg=#C0C5DD   gui=bold

" User
"---------------------------------------------------------------------------
hi User1                guifg=#0000FF   guibg=#EEEEEE  gui=NONE
hi User2                guifg=#D14000   guibg=#EEEEEE  gui=NONE
hi User3                guifg=#93A1A1   guibg=#EEEEEE  gui=NONE
hi User4                guifg=#64AA03   guibg=#EEEEEE  gui=NONE
hi User5                guifg=#2B2B2B   guibg=#DDEECC  gui=NONE

" Syntax: https://github.com/mageekguy/php.vim
hi phpDelimiter               guifg=#999999                   gui=NONE
hi phpOperator                guifg=#0050B0                   gui=NONE
hi phpIdentifier              guifg=#006C91                   gui=NONE
hi phpInteger                 guifg=#0050B0                   gui=NONE
hi phpAnnotation              guifg=#5B5C5B                   gui=NONE
hi phpInclude                 guifg=#E24500                   gui=bold
hi phpNull                    guifg=#AF4141                   gui=NONE
hi phpBoolean                 guifg=#AF4141                   gui=NONE
hi phpVariable                guifg=#4D4D4D                   gui=NONE
hi phpVariableSelector        guifg=#4D4D4D                   gui=NONE
hi phpStatement               guifg=#2B2B2B                   gui=bold
hi phpFunctions               guifg=#2B2B2B                   gui=NONE
hi phpEncapsulation           guifg=#0079A2                   gui=NONE
hi phpTryKeyword              guifg=#64AA03                   gui=bold
hi phpCatchKeyword            guifg=#64AA03                   gui=NONE
hi phpThrowKeyword            guifg=#2B2B2B                   gui=bold
hi phpNamespaceKeyword        guifg=#2B2B2B                   gui=bold
hi phpNamespace               guifg=#2B2B2B                   gui=NONE
hi phpIf                      guifg=#0050B0                   gui=bold
hi phpClassKeywords           guifg=#0050B0                   gui=bold

" Syntax: vim off.
hi def link phpParent           phpDelimiter
hi def link phpFunctions        phpIdentifier
hi def link phpDefine           phpOperator
hi def link phpNumber           phpInteger
hi def link phpConditional      phpIf
hi def link phpStringSingle     phpString
hi def link phpStringDouble     phpString
hi def link phpStorageClass     phpEncapsulation
hi def link phpType             phpEncapsulation
hi def link phpDocTags          phpAnnotation
hi def link phpException        phpThrowKeyword
hi def link phpClasses          phpIdentifier
hi def link phpLabel            Conditional
hi def link phpComparison       Operator
hi def link phpString           Constant
hi def link phpSpecialFunction  phpFunctions

" Haskell
"---------------------------------------------------------------------------
hi ConId                      guifg=#008080                   gui=NONE
hi hsConSym                   guifg=#D14000                   gui=NONE
hi hsVarSym                   guifg=#2B2B2B                   gui=NONE
hi hsType                     guifg=#1E347B                   gui=NONE
hi hsNumber                   guifg=#1299DA                   gui=NONE
hi hsImport                   guifg=#2B2B2B                   gui=bold
hi hsModule                   guifg=#2B2B2B                   gui=bold
hi hsPragma                   guifg=#009926                   gui=NONE
hi hsBoolean                  guifg=#CD7F32                   gui=bold
hi hsDelimiter                guifg=#999999                   gui=NONE
hi hsStatement                guifg=#0050B1                   gui=NONE
hi hsStructure                guifg=#0050B1                   gui=NONE
hi hsConditional              guifg=#0050B1                   gui=NONE
hi hsNiceOperator             guifg=#A67F59                   gui=NONE
hi hs_DeclareFunction         guifg=#D14000                   gui=NONE

" JS
"---------------------------------------------------------------------------
hi jsxRegion                            guifg=#1E347B gui=NONE
hi javascriptString                     guifg=#BA4747 gui=NONE
hi javascriptBrackets                   guifg=#999999 gui=NONE
hi javaScriptParens                     guifg=#999999 gui=NONE
hi javaScriptBraces                     guifg=#999999 gui=NONE
hi javascriptMethodName                 guifg=#07a000 gui=NONE
hi javascriptClassProperty              guifg=#07a000 gui=NONE
hi javascriptReturn                     guifg=#2B2B2B gui=bold
hi javascriptIdentifier                 guifg=#1E347B gui=NONE
hi javascriptClassStatic                guifg=#008080 gui=NONE
hi javascriptClassProperty              guifg=#0050B0 gui=NONE
hi javascriptMethodName                 guifg=#0050B0 gui=NONE
hi javascriptMethodAccessorWords        guifg=#0079A2 gui=NONE
hi javascriptRegexpString               guifg=#009926 gui=NONE
hi javascriptYield                      guifg=#BA4747 gui=NONE
hi javascriptGlobal                     guifg=#AA0D91 gui=NONE
hi link javascriptDOMDocMethod   javascriptIdentifierName
hi link javascriptBOMHistoryProp javascriptIdentifierName
hi link javascriptArrayMethod    javascriptIdentifierName
hi link javascriptReserved       javascriptIdentifierName
hi link javascriptInvalidOp      javascriptIdentifierName

" HTML
"---------------------------------------------------------------------------
hi htmlArg                    guifg=#0077AA                   gui=NONE
hi htmlTag                    guifg=#1E347B                   gui=NONE
hi htmlTagN                   guifg=#1E347B                   gui=NONE
hi htmlTagName                guifg=#1E347B                   gui=NONE
hi htmlEndTag                 guifg=#1E347B                   gui=NONE
hi htmlLink                   guifg=#0050B1                   gui=NONE

" CSS
"---------------------------------------------------------------------------
hi cssBraces                  guifg=#999999                   gui=NONE
hi cssVendor                  guifg=#D14000                   gui=NONE
hi cssUIAttr                  guifg=#2B2B2B                   gui=NONE
hi cssBoxAttr                 guifg=#2B2B2B                   gui=NONE
hi cssTextAttr                guifg=#2B2B2B                   gui=NONE
hi cssFontAttr                guifg=#2B2B2B                   gui=NONE
hi cssRenderAttr              guifg=#2B2B2B                   gui=NONE
hi cssCommonAttr              guifg=#2B2B2B                   gui=NONE
hi cssPositioningAttr         guifg=#446644   guibg=#DDEECC   gui=NONE
hi cssBorderOutLineAttr       guifg=#A67F59   guibg=#FFF9F9   gui=NONE
hi cssValueLength             guifg=#BA4747   guibg=#FFF9F9   gui=NONE
hi cssUnitDecorators          guifg=#9DBAD7                   gui=NONE

" Yaml
"---------------------------------------------------------------------------
hi yamlKey                    guifg=#0050B1                   gui=NONE
hi yamlBlockMappingKey        guifg=#0050B1                   gui=NONE
hi yamlKeyValueDelimiter      guifg=#999999                   gui=NONE

" Syntax: github.com/elzr/vim-json
"---------------------------------------------------------------------------
hi jsonString                 guifg=#2B2B2B                   gui=NONE
hi jsonEscape                 guifg=#A67F59                   gui=NONE
hi jsonBraces                 guifg=#999999                   gui=NONE
hi jsonBoolean                guifg=#CD7F32                   gui=NONE
hi jsonKeywordMatch           guifg=#999999                   gui=NONE
hi jsonKeywordRegion          guifg=#0050B1                   gui=NONE
hi jsonKeyword                guifg=#0050B1                   gui=NONE

" Lua
"---------------------------------------------------------------------------
hi luaParen                 guifg=#999999                   gui=NONE
