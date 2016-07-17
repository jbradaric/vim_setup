" " make YCM compatible with UltiSnips (using supertab)
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
" let g:SuperTabDefaultCompletionType = '<C-n>'

" " better key bindings for UltiSnipsExpandTrigger
" let g:UltiSnipsExpandTrigger = "<tab>"
" let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

let g:ycm_min_num_of_chars_for_completion = 99

augroup YouCompleteMe_PythonMappings
    autocmd!
    autocmd BufEnter * if &ft ==# 'python' | nnoremap <buffer> <C-]> :<C-U>YcmCompleter GoTo<CR> | endif
augroup END

let g:ycm_rust_src_path=$HOME . '/sources/rust/src'

" Disable completion for Python, deoplete does that
let g:ycm_filetype_specific_completion_to_disable = {
    \ 'gitcommit': 1,
    \ 'python': 1
    \ }
