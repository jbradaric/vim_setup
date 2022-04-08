local Path = require('plenary.path')
local telescope = require('telescope.builtin')
local themes = require('telescope.themes')

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

local M = {}

local function get_theme_opts(opts)
  local max_lines = opts.lines or 20
  local max_width = opts.width or 120
  local settings = {max_lines = max_lines, max_width = max_width}
  return themes.get_dropdown({
    winblend = 5,
    prompt = " ",
    previewer = false,
    layout_config = {
      preview_cutoff = 1,

      width = function(_, max_columns, _)
        return math.min(max_columns, settings.max_width)
      end,

      height = function(_, _, max_lines)
        return math.min(max_lines, settings.max_lines)
      end,
    },
  })
end

M.find_files = function(search_dir)
  local opts = {
    command = 'fd',
    search_dirs = { Path:new(search_dir):expand() },
  }
  local theme_opts = get_theme_opts({})
  opts = vim.tbl_extend('force', opts, theme_opts)
  telescope.find_files(opts)
end

local function live_grep_cb(opts)
  local opts = {
    prompt_title = 'Search...',
  }
  local theme_opts = get_theme_opts({max_lines = 30})
  opts = vim.tbl_extend('force', opts, theme_opts)
  require('telescope.builtin').live_grep(opts)
end

local function previewer_maker(filepath, bufnr, opts)
  local previewers = require("telescope.previewers")
  local Job = require("plenary.job")

  filepath = vim.fn.expand(filepath)
  Job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end
  }):sync()
end

M.treesitter_kind = function(kind)
  local opts = {
    default_text = ':' .. kind .. ': ',
    prompt_title = 'Symbols',
  }
  local theme_opts = get_theme_opts({})
  opts = vim.tbl_extend('force', opts, theme_opts)
  telescope.treesitter(opts)
end

M.setup = function()
  local action_layout = require("telescope.actions.layout")
  require('telescope').setup({
    defaults = {
      buffer_previewer_maker = previewer_maker,
      mappings = {
        i = {
          ["<C-j>"] = 'move_selection_next',
          ["<C-k>"] = 'move_selection_previous',
          ["<C-s>"] = 'select_horizontal',
          ["<C-v>"] = 'select_vertical',
          ["<C-g>"] = 'close',
          ["<M-p>"] = action_layout.toggle_preview,
          ["<C-u>"] = false,
          ["<C-n>"] = false,
          ["<C-p>"] = false,
          ["<C-x>"] = false,
        },
        n = {
          ["<C-s>"] = 'select_horizontal',
          ["<C-v>"] = 'select_vertical',
          ["<C-g>"] = 'close',
          ["<M-p>"] = action_layout.toggle_preview,
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

  map('n', '<C-p>', ":lua require('config.telescope').find_files(vim.fn.getcwd())<CR>", {})
  map('n', '<Leader>b', ':Telescope buffers theme=dropdown previewer=false<CR>', {})
  map('n', '<Leader>l', ':Telescope current_buffer_fuzzy_find skip_empty_lines=true theme=dropdown previewer=false<CR>', {})
  map('n', '<Leader>f', ":lua require('config.telescope').treesitter_kind('function')<CR>", {})
  map('n', '<Leader>t', ":lua require('config.telescope').treesitter_kind('type')<CR>", {})

  vim.api.nvim_add_user_command('Rg', live_grep_cb, {})

end

return M
