local ts = vim.treesitter

local M = {}

function M.get_node_type_at_pos(line, col)
  local node = ts.get_node({
    bufnr = 0,
    pos = { line - 1, col },
  })
  if not node then
    return ''
  end
  local x = node
  while x ~= nil do
    if x:type() == 'string' or x:type() == 'string_content' then
      return 'string'
    end
    x = x:parent()
  end
  return node:type()
end

return M
