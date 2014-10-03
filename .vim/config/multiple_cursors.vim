function! Multiple_cursors_before()
    if exists("g:loaded_khuno") && &filetype ==# "python"
        exe "Khuno off"
    endif
endfunction

function! Multiple_cursors_after()
    if exists("g:loaded_khuno") && &filetype ==# "python"
        exe "Khuno on"
    endif
endfunction

let g:multi_cursor_before_hook = "Multiple_cursors_before"
" let g:multi_cursor_after_hook = "Multiple_cursors_after"
