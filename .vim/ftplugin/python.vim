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

let g:python_highlight_builtins = 1
let g:python_highlight_exceptions = 1
let g:python_highlight_string_formatting = 1
let g:python_slow_sync = 1

augroup PythonAutocommands
    autocmd!
    autocmd BufWinLeave *.py silent! mkview
    autocmd BufWinEnter *.py silent! loadview

    " if has('nvim')
    "     autocmd BufWinEnter * if &ft ==# 'python' | exe 'Neomake' | endif
    "     autocmd BufWrite    * if &ft ==# 'python' | exe 'Neomake' | endif
    " endif
augroup END

iabbrev <buffer> ppr print '+' * 50print print '=' * 50kA
iabbrev <buffer> pdb import pdb; pdb.set_trace()
iabbrev <buffer> trace import traceback; traceback.print_stack()
