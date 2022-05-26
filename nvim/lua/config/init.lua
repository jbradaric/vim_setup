local MODULES = {
  'colorscheme',
  'lsp',
  'lsp_icons',
  'neogit',
  'nvim_cmp',
  'statusline',
  'telescope',
  'treesitter',
}

local M = {}

M.setup = function()
  for _, name in ipairs(MODULES) do
    require(string.format('config/%s', name)).setup()
  end
end

return M
