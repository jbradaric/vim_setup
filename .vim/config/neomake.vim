let s:python_ignore = "E123,E126,E128,E261,E265,E266,E301,E302,E402,E731,E701"
let s:python_max_line_length = 100
let s:python_error_types_override = {
    \ '127': 'W',
    \ '124': 'W',
    \ '225': 'W',
    \ '226': 'W',
    \ '231': 'W',
    \ '251': 'W',
    \ '262': 'W',
    \ '501': 'W',
    \ '502': 'W',
    \ '702': 'W',
    \ '713': 'W',
    \ '841': 'W',
    \ }

function! SetWarningType(entry)
    if has_key(s:python_error_types_override, a:entry.nr)
        let a:entry.type = s:python_error_types_override[a:entry.nr]
    endif
    if a:entry.type ==# 'F'
        let a:entry.type = 'E'
    endif
endfunction

let g:neomake_python_flake8_maker = {
    \ 'exe': 'flake8-python2',
    \ 'args':
        \ [
        \  '--ignore=' . s:python_ignore,
        \  '--max-line-length=' . s:python_max_line_length
        \ ],
    \ 'postprocess': function('SetWarningType'),
    \ 'errorformat':
        \ '%E%f:%l: could not compile,%-Z%p^,' .
        \ '%A%f:%l:%c: %t%n %m,' .
        \ '%A%f:%l: %t%n %m,' .
        \ '%-G%.%#'
    \ }

let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_verbose = 0
