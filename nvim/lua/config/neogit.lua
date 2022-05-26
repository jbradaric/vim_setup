local neogit = require('neogit')

local M = {}

M.setup = function()
  vim.api.nvim_set_keymap('n', '<Space>m', ':<C-U>Neogit<CR>', {silent = true, noremap = true})
  neogit.setup({
    disable_commit_confirmation = true,
    sections = {
      stashes = false,
    },
  })
end

return M
