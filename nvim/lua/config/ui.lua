local M = {}

M.setup = function()
  require('notify').setup()

  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0
end

return M
