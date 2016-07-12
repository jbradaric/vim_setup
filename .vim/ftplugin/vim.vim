setlocal foldmethod=marker

" Source the selected lines
vnoremap <buffer> <leader>vs y:@"<CR>

setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=8
setlocal expandtab

" Indent continuation lines by 2 * shiftwidth
let g:vim_indent_cont = 2 * &shiftwidth
