local ts = vim.treesitter

local M = {}

function M.get_node_type_at_pos(line, col)
  local node = ts.get_node_at_pos(0, line - 1, col)
  if not node then
    return ''
  end
  if node:type() == 'escape_sequence' then
    if node:parent() and node:parent():type() == 'string' then
      return 'string'
    end
  end
  return node:type()
end

return M
