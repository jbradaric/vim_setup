vim.diagnostic.config({ severity_sort = true })

vim.fn.sign_define('DiagnosticSignError', { text = '✖', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '⚠', texthl = 'DiagnosticSignError' })

local function add_desc(opts, desc)
  return vim.tbl_extend('keep', { desc = desc }, opts)
end

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, add_desc(opts, 'Go to previous diagnostic message'))
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, add_desc(opts, 'Go to previous diagnostic message'))
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, add_desc(opts, 'Open diagnostic message in a floating window'))
vim.keymap.set('n', '<leader>q', function() require('trouble').open('document_diagnostics') end,
  add_desc(opts, 'Open list of diagnostics for the current document'))
