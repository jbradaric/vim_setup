let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'relativepath', 'modified' ],
      \           ],
      \ },
      \ 'component_function': {
      \   'modified': 'lightline#MyModified',
      \   'readonly': 'lightline#MyReadonly',
      \   'fugitive': 'lightline#MyFugitive',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype != "help" && &readonly)',
      \   'modified': '(&filetype != "help" && &modified)',
      \   'fugitive': '(exists("*fugitive#head") && "" != fugitive#head())',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

function! s:prettify_branch(name)
    return " " . a:name
endfunction

function lightline#MyModified()
    if &filetype == 'help'
        return ''
    elseif &modified
        return '+'
    endif
    return ''
endfunction

function! lightline#MyReadonly()
    if &filetype == 'help'
        return ''
    elseif &readonly
        return ''
    endif
    return ''
endfunction

function! lightline#MyFugitive()
    if exists('*FugitiveHead')
        let branch = FugitiveHead()
        if strlen(l:branch)
            return s:prettify_branch(l:branch)
        endif
    endif
    return ''
endfunction
