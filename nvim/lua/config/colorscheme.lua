local highlight = require('config.utils').highlight
local darkplus_colors = require('darkplus.colors')

local M = {}

M.setup = function()
  vim.cmd('colorscheme darkplus')

  highlight('TSComment', { fg = darkplus_colors.gray, style = 'italic' })
  highlight('VertSplit', { fg = '#444444', bg = '#444444' })
  highlight('TSString', { fg = '#6bab37' })
  highlight('Normal', { fg = '#f6f3e8', bg = '#1e1e1e' })
  highlight('NormalNC', { bg = '#212121' })
end

return M
