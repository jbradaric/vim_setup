lua require('config/utils').setup_lsp()

hi LspDiagnosticsErrorSign guifg=Red guibg=#000000
hi LspDiagnosticsWarningSign guifg=Yellow guibg=#000000

lua require('config/utils').setup_lsp_icons()

lua require('config/statusline').setup()
