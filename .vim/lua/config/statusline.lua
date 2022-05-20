local vi_mode_utils = require('feline.providers.vi_mode')
local feline_defaults = require('feline.defaults')
local nvim_treesitter = require('nvim-treesitter')
local gps = require('nvim-gps')

local conf = {
  active = {},
  inactive = {},
}

conf.active[1] = {
  {
    provider = '▊ ',
    hl = {
      fg = 'skyblue',
    },
  },
  {
    provider = 'vi_mode',
    hl = function()
      return {
        name = vi_mode_utils.get_mode_highlight_name(),
        fg = vi_mode_utils.get_mode_color(),
        style = 'bold',
      }
    end,
  },
  -- {
  --   provider = 'file_info',
  --   hl = {
  --     fg = 'white',
  --     bg = 'oceanblue',
  --     style = 'bold',
  --   },
  --   left_sep = {
  --     'slant_left_2',
  --     { str = ' ', hl = { bg = 'oceanblue', fg = 'NONE' } },
  --   },
  --   right_sep = {
  --     { str = ' ', hl = { bg = 'oceanblue', fg = 'NONE' } },
  --     'slant_right_2',
  --     ' ',
  --   },
  -- },
  {
    provider = 'position',
    left_sep = ' ',
    right_sep = {
      ' ',
      {
        str = 'vertical_bar',
        hl = {
          fg = 'fg',
          bg = 'bg',
        },
      },
      ' ',
    },
  },
  {
    provider = 'diagnostic_errors',
    hl = { fg = 'red' },
  },
  {
    provider = 'diagnostic_warnings',
    hl = { fg = 'yellow' },
  },
  {
    provider = 'diagnostic_hints',
    hl = { fg = 'cyan' },
  },
  {
    provider = 'diagnostic_info',
    hl = { fg = 'skyblue' },
  },
}

conf.active[2] = {
  -- {
  --   provider = function()
  --       return gps.get_location()
  --   end,
  --   enabled = function()
  --     return gps.is_available()
  --   end,
  --   hl = {
  --     fg = 'cyan',
  --     bg = 'bg',
  --   },
  --   left_sep = 'slant_right',
  --   right_sep = 'slant_left',
  -- },
  {
    provider = 'git_branch',
    hl = {
      fg = 'white',
      bg = 'black',
      style = 'bold',
    },
    right_sep = {
      str = ' ',
      hl = {
        fg = 'NONE',
        bg = 'black',
      },
    },
  },
  {
    provider = 'git_diff_added',
    hl = {
      fg = 'green',
      bg = 'black',
    },
  },
  {
    provider = 'git_diff_changed',
    hl = {
      fg = 'orange',
      bg = 'black',
    },
  },
  {
    provider = 'git_diff_removed',
    hl = {
      fg = 'red',
      bg = 'black',
    },
    right_sep = {
      str = ' ',
      hl = {
        fg = 'NONE',
        bg = 'black',
      },
    },
  },
  {
    provider = 'line_percentage',
    hl = {
      style = 'bold',
    },
    left_sep = '  ',
    right_sep = ' ',
  },
  {
    provider = 'scroll_bar',
    hl = {
      fg = 'skyblue',
      style = 'bold',
    },
  },
}

conf.inactive[1] = {
  {
    provider = 'file_type',
    hl = {
      fg = 'white',
      bg = 'oceanblue',
      style = 'bold',
    },
    left_sep = {
      str = ' ',
      hl = {
        fg = 'NONE',
        bg = 'oceanblue',
      },
    },
    right_sep = {
      {
        str = ' ',
        hl = {
          fg = 'NONE',
          bg = 'oceanblue',
        },
      },
      'slant_right',
    },
  },
  -- Empty component to fix the highlight till the end of the statusline
  {},
}

local M = {}

local timeout_scheduled = false
local function redraw_status()
  vim.cmd('redrawstatus')
  timeout_scheduled = false
end

local function on_cursor_moved()
  if not timeout_scheduled then
    timeout_scheduled = true
    vim.defer_fn(redraw_status, 100)
  end
end

M.setup = function()
  require('gitsigns').setup({
    signcolumn = false,
    numhl = true,
    current_line_blame = false,
  })
  require('nvim-gps').setup()
  require('feline').setup({
    components = { active = conf.active, inactive = conf.inactive },
    highlight_reset_triggers = {},
  })

  vim.o.laststatus = 3
  vim.o.winbar = "%{%v:lua.require('config.statusline').winbar()%}"

  vim.api.nvim_command('highlight WinBarBackground guibg=#0066cc')
  vim.api.nvim_command('highlight WinBarFilename gui=bold guifg=white guibg=#0066cc')
  vim.api.nvim_command('highlight WinBarSeparator guifg=#0066cc guibg=NONE')

  local id = vim.api.nvim_create_augroup("RedrawWinbar", { clear = true })
  vim.api.nvim_create_autocmd({'CursorMoved'}, {
    callback = on_cursor_moved,
  })


  -- vim.o.statusline = "%{%v:lua.require('config.statusline').my_statusline()%}"
end

M.my_statusline = function()
  local s = require('feline').statusline()
  vim.pretty_print(s)
  return s
end

local highlights = {}
local next_highlight_num = 1

local function get_highlight(color)
  local h = highlights[color]
  if h ~= nil then
    return h
  end
  local name = string.format('MyWinbarHl%d', next_highlight_num + 1)
  vim.api.nvim_command(string.format('highlight %s guifg=%s guibg=#0066cc', name, color))
  next_highlight_num = next_highlight_num + 1
  highlights[color] = name
  return name
end

M.winbar = function()
  local devicons = require('nvim-web-devicons')
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  if path == '' then
    return ''
  end
  if path:match('^term://') then
    return ''
  end
  local icon, color = devicons.get_icon_color(path, nil, { default = true })
  local border_right = ''
  local fmt = '%%#%s#'
           .. ' %s'
           .. '%%#WinBarFilename#'
           .. ' %s '
           .. '%%#WinBarSeparator#'
           .. '%s'
           .. '%%#Normal#'
  local status = string.format(fmt, get_highlight(color), icon, vim.fn.fnamemodify(path, ':t'), border_right)
  if gps.is_available() then
    status = status .. '%=' .. gps.get_location() .. ' '
  end
  return status
end

return M
