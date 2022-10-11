local M = {}

local function setup_darkplus()
  local highlight = require('config.utils').highlight
  local darkplus_colors = require('darkplus.colors')
  vim.cmd('colorscheme darkplus')

  highlight('TSComment', { fg = darkplus_colors.gray, style = 'italic' })
  highlight('VertSplit', { fg = '#444444', bg = '#444444' })
  highlight('TSString', { fg = '#6bab37' })
  highlight('Normal', { fg = '#f6f3e8', bg = '#1e1e1e' })
  highlight('NormalNC', { bg = '#212121' })
end

local function setup_vim_code_dark()
  vim.g.codedark_conservative = 0
  vim.g.codedark_italics = 1
  vim.cmd([[colorscheme codedark]])
end

local function setup_vscode()
  require('vscode').setup({
    italic_comments = true,
  })
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

local function setup_onedark()
  require('onedark').setup({})
  vim.cmd([[ colorscheme onedark ]])
end

M.setup = function()
  -- setup_darkplus()
  -- setup_vim_code_dark()

  setup_vscode()
  setup_terminal()

  -- setup_onedark()
end

return M
