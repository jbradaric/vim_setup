local M = {}

local function previewer_maker(filepath, bufnr, opts)
  local previewers = require('telescope.previewers')
  local Job = require('plenary.job')

  filepath = vim.fn.expand(filepath)
  Job:new({
    command = 'file',
    args = { '--mime-type', '-b', filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], '/')[1]
      if mime_type == 'text' then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'BINARY' })
        end)
      end
    end
  }):sync()
end

M.setup = function()
  local action_layout = require('telescope.actions.layout')
  require('telescope').setup({
    defaults = {
      buffer_previewer_maker = previewer_maker,
      mappings = {
        i = {
          ['<C-j>'] = 'move_selection_next',
          ['<C-k>'] = 'move_selection_previous',
          ['<C-s>'] = 'select_horizontal',
          ['<C-v>'] = 'select_vertical',
          ['<C-g>'] = 'close',
          ['<M-p>'] = action_layout.toggle_preview,
          ['<C-u>'] = false,
          ['<C-n>'] = false,
          ['<C-p>'] = false,
          ['<C-x>'] = false,
        },
        n = {
          ['<C-s>'] = 'select_horizontal',
          ['<C-v>'] = 'select_vertical',
          ['<C-g>'] = 'close',
          ['<M-p>'] = action_layout.toggle_preview,
        },
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case',
      },
    },
  })
  require('telescope').load_extension('fzf')
end

return M
