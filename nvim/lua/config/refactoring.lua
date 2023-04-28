local M = {}

M.setup = function()
  -- Remaps for the refactoring operations currently offered by the plugin
  vim.keymap.set('v', '<leader>rf', [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], { silent = true, expr = false })
  vim.keymap.set('v', '<leader>rv', [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], { silent = true, expr = false })

  -- Extract block doesn't need visual mode
  vim.keymap.set('n', '<leader>rb', [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]], { silent = true, expr = false })

  -- load refactoring Telescope extension
  require('telescope').load_extension('refactoring')

  -- remap to open the Telescope refactoring menu in visual mode
  vim.keymap.set('v', '<leader>rr', [[ <Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR> ]])
end

return M
