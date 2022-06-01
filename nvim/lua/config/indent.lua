local ts_utils = require('nvim-treesitter.ts_utils')
local parsers = require('nvim-treesitter.parsers')

local M = {}

function M.get_node_at_pos(line, col)
  local winnr = 0
  local cursor = { line, col }
  local cursor_range = { cursor[1] - 1, cursor[2] }

  local buf = vim.api.nvim_win_get_buf(winnr)
  local root_lang_tree = parsers.get_parser(buf)
  if not root_lang_tree then
    return
  end

  local root
  root = ts_utils.get_root_for_position(cursor_range[1], cursor_range[2], root_lang_tree)

  if not root then
    return
  end

  return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
end

function M.get_node_type_at_pos(line, col)
  local node = M.get_node_at_pos(line, col)
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
