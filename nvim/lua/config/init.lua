local MODULES = {
  'colorscheme',
  'dap',
  'lsp',
  'lsp_icons',
  'neogit',
  'notify',
  'nvim_cmp',
  'rooter',
  'statusline',
  'telescope',
  'treesitter',
  'ui',
}

local M = {}

M.setup = function()
  for _, name in ipairs(MODULES) do
    require(string.format('config/%s', name)).setup()
  end
end

return M
