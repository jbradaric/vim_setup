local hop = require('hop')
local jump_target = require('hop.jump_target')
local directions = require('hop.hint').HintDirection

local M = {}

local function yank_lines(line_start, line_end)
  if line_start > line_end then
    line_end, line_start = line_start, line_end
  end
  vim.cmd(string.format('%s,%sy', line_start + 1, line_end + 1))
end

-- local function get_line_hint(callback)
--   local generator = jump_target.jump_targets_by_scanning_lines
--   hop.hint_with_callback(generator(jump_target.regex_by_line_start_skip_whitespace()),
--     nil, callback)
-- end

-- local function get_end(targets)
--   yank_state.line_end = targets.line
--   yank_lines(yank_state.line_start, yank_state.line_end)
-- end

-- local function get_start(targets)
--   yank_state.start = targets.line
--   get_line_hint(get_end)
-- end

M.setup = function()
  hop.setup()

  vim.keymap.set('', '<Space>s', function() end)
  vim.keymap.set('', '<Space>sw', function() hop.hint_words({ direction = directions.AFTER_CURSOR }) end)
  vim.keymap.set('', '<Space>sb', function() hop.hint_words({ direction = directions.BEFORE_CURSOR }) end)
  vim.keymap.set('', '<Space>sf', function() hop.hint_char1({ direction = directions.AFTER_CURSOR }) end)
  vim.keymap.set('', '<Space>sF', function() hop.hint_char1({ direction = directions.BEFORE_CURSOR }) end)

  -- vim.keymap.set('', 'y<Space>l', function()
  --   local yank_state = {}

  --   local function get_line_hint(callback)
  --     local generator = jump_target.jump_targets_by_scanning_lines
  --     hop.hint_with_callback(generator(jump_target.regex_by_line_start_skip_whitespace()),
  --       nil, callback)
  --   end

  --   local function get_end(targets)
  --     yank_state.line_end = targets.line
  --     vim.api.nvim_buf_clear_namespace(0, yank_state.ns, 0, -1)
  --     yank_lines(yank_state.line_start, yank_state.line_end)
  --   end

  --   local function get_start(targets)
  --     yank_state.ns = vim.api.nvim_buf_add_highlight(0, 0, 'HopYankLineFirst', targets.line + 1, 0, -1)
  --     yank_state.line_start = targets.line
  --     get_line_hint(get_end)
  --   end

  --   get_line_hint(get_start)
  -- end, { remap = false })

end

return M
