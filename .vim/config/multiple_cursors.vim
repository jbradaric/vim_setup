function! Multiple_cursors_before()
    if exists("g:loaded_khuno") && &filetype ==# "python"
        exe "Khuno off"
    endif
endfunction

function! Multiple_cursors_after()
    if exists("g:loaded_khuno") && &filetype ==# "python"
        exe "Khuno on"
    endif
    set virtualedit-=onemore
endfunction

let g:multi_cursor_start_key='g<C-n>'
let g:multi_cursor_start_word_key='<C-n>'
