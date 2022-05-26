local M = {}

M.link_highlight = function(from_group, to_group)
  local cmd = table.concat({'highlight', 'link', from_group, to_group}, ' ')
  vim.api.nvim_command(cmd)
end

M.highlight = function(group, props)
  local bg = props.bg == nil and '' or 'guibg=' .. props.bg
  local fg = props.fg == nil and '' or 'guifg=' .. props.fg
  local style = props.style == nil and '' or 'gui=' .. props.style
  local cmd = table.concat({ 'highlight', group, bg, fg, style }, ' ')
  vim.api.nvim_command(cmd)
end

return M
