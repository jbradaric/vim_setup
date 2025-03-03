vim.diagnostic.config({
  virtual_lines = true,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✖',
      [vim.diagnostic.severity.WARN] = '⚠',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignError',
    }
  }
})

vim.api.nvim_create_augroup('diagnostics-config', { clear = true })

vim.api.nvim_create_autocmd('InsertEnter', {
  group = 'diagnostics-config',
  pattern = '*',
  callback = function() vim.diagnostic.config({ virtual_lines = false }) end
})

vim.api.nvim_create_autocmd('InsertLeave', {
  group = 'diagnostics-config',
  pattern = '*',
  callback = function() vim.diagnostic.config({ virtual_lines = true }) end
})

local function add_desc(opts, desc)
  return vim.tbl_extend('keep', { desc = desc }, opts)
end

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end,
  add_desc(opts, 'Go to previous diagnostic message'))
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end,
  add_desc(opts, 'Go to previous diagnostic message'))
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,
  add_desc(opts, 'Open diagnostic message in a floating window'))
vim.keymap.set('n', '<leader>q', function() require('trouble').open('document_diagnostics') end,
  add_desc(opts, 'Open list of diagnostics for the current document'))
