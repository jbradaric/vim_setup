setlocal comments=sl:/**,mb:\ *,elx:\ */
setlocal shiftwidth=4
setlocal tabstop=8
setlocal expandtab
setlocal softtabstop=4
setlocal list
" Don't complete tags
setlocal complete-=t

augroup CppAutocommands
    autocmd!
    autocmd BufWinEnter _core/*.cpp setlocal shiftwidth=2 softtabstop=2
augroup END
