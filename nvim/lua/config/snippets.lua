local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local M = {}

M.setup = function()
  ls.add_snippets('python', {
    s('ppr', {
      t({ '', [[print('+' * 50)]] }),
      t({ '', [[print(]] }), i(1), t(')'),
      t({ '', [[print('-' * 50)]] }),
      i(0),
    }),

    s('trace', {
      t('import traceback; traceback.print_stack()'),
    }),

    s('break', {
      t('breakpoint()'),
    }),
  })

  local list_snips = function()
    local ft_list = require('luasnip').available()[vim.o.filetype]
    local ft_snips = {}
    for _, item in pairs(ft_list) do
      ft_snips[item.trigger] = item.name
    end
    print(vim.inspect(ft_snips))
  end

  vim.api.nvim_create_user_command('SnipList', list_snips, {})
end

return M
