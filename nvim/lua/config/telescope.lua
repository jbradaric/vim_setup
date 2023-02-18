local Path = require('plenary.path')
local telescope = require('telescope.builtin')
local themes = require('telescope.themes')

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

local M = {}

local function get_theme_opts(opts)
  local max_lines = opts.lines or 20
  local max_width = opts.width or 120
  local settings = { max_lines = max_lines, max_width = max_width }
  return themes.get_dropdown({
    winblend = 0,
    prompt = ' ',
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
    find_command = { 'fd', '--no-hidden', '--ignore-file', Path:new('~/.config/nvim/my_ignores'):expand() },
    search_dirs = { Path:new(search_dir):expand() },
  }
  local theme_opts = get_theme_opts({})
  opts = vim.tbl_extend('force', opts, theme_opts)
  telescope.find_files(opts)
end

local function live_grep_cb(opts)
  opts = opts or {}
  opts.prompt_title = 'Search...'
  local theme_opts = get_theme_opts({ max_lines = 30 })
  opts = vim.tbl_extend('force', opts, theme_opts)
  require('telescope.builtin').live_grep(opts)
end

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

M.treesitter_kind = function(kind)
  local opts = {
    default_text = ':' .. kind .. ': ',
    prompt_title = 'Symbols',
  }
  local theme_opts = get_theme_opts({})
  opts = vim.tbl_extend('force', opts, theme_opts)
  telescope.treesitter(opts)
end

local function reverse(tbl)
  local rev = {}
  for i = #tbl, 1, -1 do
    rev[#rev + 1] = tbl[i]
  end
  return rev
end

M.get_path = function(node)
  if not node then
    return nil
  end
  local path = {}
  while node do
    local type = node:type()
    if type == 'function_definition' then
      local line = vim.trim(vim.treesitter.get_node_text(node)[1] or '')
      local name = string.match(line, '^def ([a-zA-Z_][a-zA-Z0-9_]*).*$')
      if name == nil then
        return nil
      end
      if not vim.startswith(name:lower(), 'test') then
        return nil
      end
      path[#path + 1] = name
    end
    if type == 'class_definition' then
      local line = vim.trim(vim.treesitter.get_node_text(node)[1] or '')
      local name = string.match(line, '^class ([a-zA-Z_][a-zA-Z0-9_]*).*$')
      if name == nil then
        return nil
      end
      if not vim.startswith(name:lower(), 'test') then
        return nil
      end
      path[#path + 1] = name
    end
    node = node:parent()
    if node == nil then
      break
    end
  end
  if not path then
    return nil
  end
  return table.concat(reverse(path), '::')
end

M.setup = function()
  local yabs = require('yabs')

  yabs:setup({
    languages = {
      python = {
        tasks = {
          ['Run All Tests in File'] = {
            command = function()
              return '/home/jurica/local_workenv3.sh python -m pytest %'
            end,
            output = 'terminal',
          },
          ['Run Current Test'] = {
            type = 'lua',
            command = function()
              local ts_utils = require('nvim-treesitter.ts_utils')
              local node = ts_utils.get_node_at_cursor()
              local test_path = M.get_path(node)
              if test_path == nil then
                vim.notify('No test found at the current position')
                return
              end
              local bufname = vim.fn.expand('%')
              local command = string.format('%s -m pytest %s::%s',
                                            '/home/jurica/local_workenv3.sh python',
                                            bufname, test_path)
              yabs.run_command(command, 'terminal', { open_on_run = 'always' })
            end,
          },
        },
      },
    }
  })

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
  require('telescope').load_extension('yabs')

  map('n', '<C-p>', function() require('config.telescope').find_files(vim.fn.getcwd()) end, {})
  map('n', '<Leader>b', function() vim.cmd('Telescope buffers theme=dropdown previewer=false') end, {})
  map('n', '<Leader>l', function() vim.cmd('Telescope current_buffer_fuzzy_find skip_empty_lines=true theme=dropdown previewer=false') end,
      {})
  map('n', '<Leader>f', function() require('config.telescope').treesitter_kind('function') end, {})
  map('n', '<Leader>t', function() require('config.telescope').treesitter_kind('type') end, {})

  vim.api.nvim_create_user_command('Rg', live_grep_cb, {})
  vim.api.nvim_create_user_command('Files',
                                   function(opts) M.find_files(opts.args) end,
                                   { nargs = 1, complete = 'dir', desc = 'Pick files' })

  map('n', '<Space>/', function()
    vim.cmd('Rooter')
    live_grep_cb()
  end, {})

end

return M
