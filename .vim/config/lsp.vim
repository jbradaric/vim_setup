if !has('nvim')
  finish
endif

lua require'utils'.setup_lsp()
