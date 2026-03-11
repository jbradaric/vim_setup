-- Trim trailing whitespace from yanks in sidekick_terminal buffers.
if vim.b.sidekick_terminal_trim_yank_loaded then
  return
end
vim.b.sidekick_terminal_trim_yank_loaded = true
local autocmd_id = vim.api.nvim_create_autocmd("TextYankPost", {
  buffer = 0,
  callback = function()
    local ev = vim.v.event
    if ev.operator ~= "y" or not ev.visual then
      return
    end
    -- Skip blockwise yanks.
    if ev.regtype:sub(1, 1) == "\022" then
      return
    end
    local reg = ev.regname ~= "" and ev.regname or '"'
    local lines = vim.deepcopy(ev.regcontents)
    local strip_leading = #lines > 0
    for _, line in ipairs(lines) do
      if line:sub(1, 5) ~= "     " then
        strip_leading = false
        break
      end
    end
    for i, line in ipairs(lines) do
      if strip_leading then
        line = line:sub(6)
      end
      lines[i] = line:gsub("%s+$", "")
    end
    vim.fn.setreg(reg, lines, ev.regtype)
  end,
})
local undo = string.format(
  "lua pcall(vim.api.nvim_del_autocmd, %d) | unlet! b:sidekick_terminal_trim_yank_loaded",
  autocmd_id
)
vim.b.undo_ftplugin = vim.b.undo_ftplugin
    and (vim.b.undo_ftplugin .. " | " .. undo)
    or undo
