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
  -- if node:type() == 'escape_sequence' then
  --   if node:parent() and (node:parent():type() == 'string' or node:parent():type() == 'string_content') then
  --     return 'string'
  --   end
  -- end
  -- if node:type() == 'string_content' then
  --   if node:parent() and node:parent():type() == 'string' then
  --     return 'string'
  --   end
  -- end
  return node:type()
end

return M
