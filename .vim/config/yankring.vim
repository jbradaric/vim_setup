let g:yankring_max_history = 20
let g:yankring_min_element_length = 2
let g:yankring_paste_using_g = 0
let g:yankring_history_dir = '$HOME/.vim/yankring/'
let g:yankring_history_file = 'yankring_history'
let g:yankring_clipboard_monitor = 0
let g:yankring_manual_clipboard_check = 0
let g:yankring_paste_check_default_register = 0
let g:yankring_default_menu_mode = 0
let g:yankring_replace_n_nkey = '<m-p>'
let g:yankring_replace_n_pkey = '<m-n>'

function! YRRunAfterMaps()
    nnoremap Y :<C-U>YRYankCount 'y$'<CR>
endfunction
