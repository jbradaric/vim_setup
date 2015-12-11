augroup QuickFixAutocommands
    autocmd!
    autocmd BufWinEnter * if &buftype ==# 'quickfix' | nnoremap <silent> <buffer> q :cclose<CR>
augroup END
