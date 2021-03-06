if !has('nvim')
  finish
endif

lua require'utils'.setup_lsp()

hi LspDiagnosticsErrorSign guifg=Red guibg=#000000
hi LspDiagnosticsWarningSign guifg=Yellow guibg=#000000

lua require('lspkind').init({with_text = true, preset = 'codicons' })
