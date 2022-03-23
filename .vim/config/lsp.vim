if !has('nvim')
  finish
endif

lua require'utils'.setup_lsp()

hi LspDiagnosticsErrorSign guifg=Red guibg=#000000
hi LspDiagnosticsWarningSign guifg=Yellow guibg=#000000

lua require'utils'.setup_lsp_icons()

lua require'my_statusline'.setup()
