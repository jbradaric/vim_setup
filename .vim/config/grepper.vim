let g:grepper = {
    \ 'open':     1,
    \ 'quickfix': 1,
    \ 'switch':   1,
    \ 'jump':     0,
    \ }

if has('nvim')
    let g:grepper.dispatch = 0
endif

command! -nargs=+ -complete=file Rg Grepper -noprompt -tool rg -query <args>
