" Vim syntaxtax file
" Language:	Twig template
" Maintainer:	Gabriel Gosselin <gabrielNOSPAM@evidens.ca>
" Last Change:	2014 December 15
" Version:	1.1
"
" Based Jinja syntax by: Armin Ronacher <armin.ronacher@active-4.com>
" With modifications by Benji Fisher, Ph.D.
"
" Known Bugs:
"   because of odd limitations dicts and the modulo operator
"   appear wrong in the template.
"
" Changes:
"
"     2008 May 9:     Added support for Jinja2 changes (new keyword rules)
"     2011 July 27:   Changed all references of jinja tp twig
"     2014 December 4:   Do not assume that the base filetype is HTML.

if exists('b:current_syntax')
  finish
endif

if !exists('b:main_syntax')
  let b:main_syntax = 'twig'
endif

runtime! syntax/html.vim
unlet b:current_syntax

syntax case match

" Twig template built-in tags and parameters (without filter, macro, is and
" raw, they have special treatment)
syntax keyword twigStatement containedin=twigVarBlock,twigTagBlock,twigNested contained and if else in not or recursive as import

syntax keyword twigStatement containedin=twigVarBlock,twigTagBlock,twigNested contained is filter skipwhite nextgroup=twigFilter
syntax keyword twigStatement containedin=twigTagBlock contained macro skipwhite nextgroup=twigFunction
syntax keyword twigStatement containedin=twigTagBlock contained block skipwhite nextgroup=twigBlockName

" Variable Names
syntax match twigVariable containedin=twigVarBlock,twigTagBlock,twigNested contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/
syntax keyword twigSpecial containedin=twigVarBlock,twigTagBlock,twigNested contained false true none loop super caller varargs kwargs

" Filters
syntax match twigOperator "|" containedin=twigVarBlock,twigTagBlock,twigNested contained nextgroup=twigFilter
syntax match twigFilter contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/
syntax match twigFunction contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/
syntax match twigBlockName contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/

" Twig template constants
syntax region twigString containedin=twigVarBlock,twigTagBlock,twigNested contained start=/"/ skip=/\\"/ end=/"/
syntax region twigString containedin=twigVarBlock,twigTagBlock,twigNested contained start=/'/ skip=/\\'/ end=/'/
syntax match twigNumber containedin=twigVarBlock,twigTagBlock,twigNested contained /[0-9]\+\(\.[0-9]\+\)\?/

" Operators
syntax match twigOperator containedin=twigVarBlock,twigTagBlock,twigNested contained /[+\-*\/<>=!,:]/
syntax match twigPunctuation containedin=twigVarBlock,twigTagBlock,twigNested contained /[()\[\]]/
syntax match twigOperator containedin=twigVarBlock,twigTagBlock,twigNested contained /\./ nextgroup=twigAttribute
syntax match twigAttribute contained /[a-zA-Z_][a-zA-Z0-9_]*/

" Twig template tag and variable blocks
syntax region twigNested matchgroup=twigOperator start="(" end=")" transparent display containedin=twigVarBlock,twigTagBlock,twigNested contained
syntax region twigNested matchgroup=twigOperator start="\[" end="\]" transparent display containedin=twigVarBlock,twigTagBlock,twigNested contained
syntax region twigNested matchgroup=twigOperator start="{" end="}" transparent display containedin=twigVarBlock,twigTagBlock,twigNested contained
syntax region twigTagBlock matchgroup=twigTagDelim start=/{%-\?/ end=/-\?%}/ skipwhite containedin=ALLBUT,twigTagBlock,twigVarBlock,twigRaw,twigString,twigNested,twigComment

syntax region twigVarBlock matchgroup=twigVarDelim start=/{{-\?/ end=/-\?}}/ containedin=ALLBUT,twigTagBlock,twigVarBlock,twigRaw,twigString,twigNested,twigComment

" Twig template 'raw' tag
syntax region twigRaw matchgroup=twigRawDelim start="{%\s*raw\s*%}" end="{%\s*endraw\s*%}" containedin=ALLBUT,twigTagBlock,twigVarBlock,twigString,twigComment

" Twig comments
syntax region twigComment matchgroup=twigCommentDelim start="{#" end="#}" containedin=ALLBUT,twigTagBlock,twigVarBlock,twigString

" Block start keywords.  A bit tricker.  We only highlight at the start of a
" tag block and only if the name is not followed by a comma or equals sign
" which usually means that we have to deal with an assignment.
syntax match twigStatement containedin=twigTagBlock contained skipwhite /\({%-\?\s*\)\@<=\<[a-zA-Z_][a-zA-Z0-9_]*\>\(\s*[,=]\)\@!/

" and context modifiers
syntax match twigStatement containedin=twigTagBlock contained /\<with\(out\)\?\s\+context\>/ skipwhite

highlight twigPunctuation twigOperator
highlight twigAttribute twigVariable
highlight twigFunction twigFilter

highlight twigTagDelim twigTagBlock
highlight twigVarDelim twigVarBlock
highlight twigCommentDelim twigComment
highlight twigRawDelim twig

highlight twigSpecial Special
highlight twigOperator Normal
highlight twigRaw Normal
highlight twigTagBlock PreProc
highlight twigVarBlock PreProc
highlight twigStatement Statement
highlight twigFilter Function
highlight twigBlockName Function
highlight twigVariable Identifier
highlight twigString Constant
highlight twigNumber Constant
highlight twigComment Comment

let b:current_syntax = 'twig'

if b:main_syntax == 'twig'
  unlet b:main_syntax
endif
