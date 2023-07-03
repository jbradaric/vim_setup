vim.diagnostic.config({ severity_sort = true })

vim.fn.sign_define('DiagnosticSignError', { text = '✖', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '⚠', texthl = 'DiagnosticSignError' })
