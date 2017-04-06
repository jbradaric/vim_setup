setlocal tabstop=8
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal smarttab
setlocal expandtab
setlocal nosmartindent
setlocal tw=100
setlocal nowrap

setlocal list
setlocal listchars=tab:>.,trail:. " Show tabs and trailing spaces

augroup JavascriptAutocommands
    autocmd!
    autocmd BufWinLeave *.js silent! mkview
    autocmd BufWinEnter *.js silent! loadview
augroup END
