let s:save_eventignore = ''

function! Multiple_cursors_before()
    if exists("g:loaded_khuno") && &filetype ==# "python"
        exe "Khuno off"
    endif
    let s:save_eventignore = &eventignore
    set eventignore=all
endfunction

function! Multiple_cursors_after()
    if exists("g:loaded_khuno") && &filetype ==# "python"
        exe "Khuno on"
    endif
    set virtualedit-=onemore
    let &eventignore = s:save_eventignore
endfunction

let g:multi_cursor_start_key='g<C-n>'
let g:multi_cursor_start_word_key='<C-n>'
