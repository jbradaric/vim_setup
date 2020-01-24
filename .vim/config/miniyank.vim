map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)
if has('nvim')
  map <A-p> <Plug>(miniyank-cycle)
  map <A-n> <Plug>(miniyank-cycleback)
else
  map <leader>n <Plug>(miniyank-cycle)
  map <leader>N <Plug>(miniyank-cycleback)
endif
