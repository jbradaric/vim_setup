setlocal comments=sl:/**,mb:\ *,elx:\ */
setlocal shiftwidth=4
setlocal tabstop=8
setlocal expandtab
setlocal softtabstop=4
setlocal list

augroup CppAutocommands
    autocmd!
    autocmd BufWinLeave *.cpp silent! mkview
    autocmd BufWinEnter *.cpp silent! loadview
    autocmd BufWinEnter _core/*.cpp setlocal shiftwidth=2 softtabstop=2
augroup END
