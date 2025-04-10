vim.diagnostic.config({
  virtual_lines = false,
  virtual_text = true,
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

vim.api.nvim_create_autocmd('CursorMoved', {
  group = 'diagnostics-config',
  pattern = '*',
  callback = function() vim.diagnostic.config({ virtual_lines = false, virtual_text = true }) end
})

local function show_virtual_lines()
  vim.diagnostic.config({
    virtual_lines = {
      current_line = true,
    },
    -- virtual_text = false,
  })
end

local function add_desc(opts, desc)
  return vim.tbl_extend('keep', { desc = desc }, opts)
end

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '[d',
  function()
    vim.diagnostic.jump({ count = -1, float = false })
    show_virtual_lines()
  end,
  add_desc(opts, 'Go to previous diagnostic message'))
vim.keymap.set('n', ']d',
  function()
    vim.diagnostic.jump({ count = 1, float = false })
    show_virtual_lines()
  end,
  add_desc(opts, 'Go to previous diagnostic message'))
vim.keymap.set('n', '<leader>e',
  function() show_virtual_lines() end,
  add_desc(opts, 'Show diagnostic messages for the current line as virtual lines below'))
vim.keymap.set('n', '<leader>q', function() require('trouble').open('document_diagnostics') end,
  add_desc(opts, 'Open list of diagnostics for the current document'))
