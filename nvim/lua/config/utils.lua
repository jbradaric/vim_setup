local ts = vim.treesitter

local M = {}

M.link_highlight = function(from_group, to_group)
  local cmd = table.concat({ 'highlight', 'link', from_group, to_group }, ' ')
  vim.api.nvim_command(cmd)
end

M.highlight = function(group, props)
  local bg = props.bg == nil and '' or 'guibg=' .. props.bg
  local fg = props.fg == nil and '' or 'guifg=' .. props.fg
  local style = props.style == nil and '' or 'gui=' .. props.style
  local cmd = table.concat({ 'highlight', group, bg, fg, style }, ' ')
  vim.api.nvim_command(cmd)
end

M.function_history = function()
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  local node = ts.get_node({ bufnr = 0, pos = { line - 1, col - 1 } })
  if not node then
    return
  end
  local x = node
  while x ~= nil do
    if x:type() == 'function_definition' then
      local start, _, end_, _ = x:range()
      vim.api.nvim_cmd({ cmd = 'Gclog', range = { start - 1, end_ - 1 } }, {})
    end
    x = x:parent()
  end
end

return M
