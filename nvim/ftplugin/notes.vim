setlocal wrap
setlocal linebreak

nnoremap <buffer> j gj
nnoremap <buffer> k gk

if has('nvim')
    highlight notesInlineCode guifg=lightblue
endif
