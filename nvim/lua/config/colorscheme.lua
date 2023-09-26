local M = {}

local function setup_vscode()
  require('vscode').setup({
    italic_comments = true,
    color_overrides = {
      vscBack = '#141b1e',
    },
    group_overrides = {
      Pmenu = { fg = '#d9d9d9', bg = '#10171a' },
      PmenuSel = { fg = '#000000', bg = '#8ccf7e' },
    },
  })
  require('vscode').load('dark')
end

local function setup_terminal()
  vim.g.terminal_color_0  = '#171421'
  vim.g.terminal_color_1  = '#c01c28'
  vim.g.terminal_color_2  = '#26a269'
  vim.g.terminal_color_3  = '#a2734c'
  vim.g.terminal_color_4  = '#12488b'
  vim.g.terminal_color_5  = '#a347ba'
  vim.g.terminal_color_6  = '#2aa1b3'
  vim.g.terminal_color_7  = '#d0cfcc'
  vim.g.terminal_color_8  = '#5e5c64'
  vim.g.terminal_color_9  = '#f66151'
  vim.g.terminal_color_10 = '#33da7a'
  vim.g.terminal_color_11 = '#e9ad0c'
  vim.g.terminal_color_12 = '#2a7bde'
  vim.g.terminal_color_13 = '#c061cb'
  vim.g.terminal_color_14 = '#33c7de'
  vim.g.terminal_color_15 = '#ffffff'
end

M.setup = function()
  setup_vscode()
  setup_terminal()

  local highlight = require('config.utils').highlight
  highlight('StatusLine', { bg = '#1e1e1e' })
  highlight('CmpItemKindCopilot', { fg = '#6CC644' })
end

return M
