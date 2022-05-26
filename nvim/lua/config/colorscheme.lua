local darkplus_colors = require 'darkplus.colors'

local function highlight(group, properties)
  local bg = properties.bg == nil and '' or 'guibg=' .. properties.bg
  local fg = properties.fg == nil and '' or 'guifg=' .. properties.fg
  local style = properties.style == nil and '' or 'gui=' .. properties.style
  local cmd = table.concat({ 'highlight', group, bg, fg, style }, ' ')
  vim.api.nvim_command(cmd)
end

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
