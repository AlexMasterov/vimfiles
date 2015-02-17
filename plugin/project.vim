" Exit quickly when this plugin was already loaded
if exists('g:loaded_project_plugin')
    finish
endif
let g:loaded_project_plugin = 1

let g:my_projects = get(g:, 'my_projects', {})

command! -nargs=1 -complete=customlist,s:getProjectList C :call s:setProject(<f-args>)

" C: tunning
cmap <expr> <S-c> getcmdpos() == 1 ? "\C<Space>" : 'C'

function! s:getProjectList(ArgLead, CmdLine, CursorPos) abort
    return exists('g:my_projects') && len(g:my_projects) ?
        \ filter(sort(keys(g:my_projects)), 'v:val =~ "^'. fnameescape(a:ArgLead) . '"') : []
endfunction

function! s:setProject(app) abort
    if isdirectory(g:my_projects[a:app])
        silent! exe ':cd '. g:my_projects[a:app]
        echo ' Project changed: '. a:app
        if filereadable(g:my_projects[a:app].'/project.vim')
            exe 'source '. g:my_projects[a:app] .'/project.vim'
        endif
    endif
endfunction
