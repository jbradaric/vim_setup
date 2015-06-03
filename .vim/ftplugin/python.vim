setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal smarttab
setlocal expandtab
setlocal nosmartindent
setlocal tw=100
setlocal nowrap

setlocal list
setlocal listchars=tab:>.,trail:. " Show tabs and trailing spaces

augroup PythonAutocommands
    autocmd!
    autocmd BufWinLeave *.py silent! mkview
    autocmd BufWinEnter *.py silent! loadview

    if has('nvim')
        autocmd BufWinEnter * if &ft ==# 'python' | exe 'Neomake' | endif
        autocmd BufWrite    * if &ft ==# 'python' | exe 'Neomake' | endif
    endif
augroup END
