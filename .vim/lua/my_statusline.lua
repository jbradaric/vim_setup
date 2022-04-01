local vi_mode_utils = require('feline.providers.vi_mode')
local feline_defaults = require('feline.defaults')
local nvim_treesitter = require('nvim-treesitter')

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
  {
    provider = 'file_info',
    hl = {
      fg = 'white',
      bg = 'oceanblue',
      style = 'bold',
    },
    left_sep = {
      'slant_left_2',
      { str = ' ', hl = { bg = 'oceanblue', fg = 'NONE' } },
    },
    right_sep = {
      { str = ' ', hl = { bg = 'oceanblue', fg = 'NONE' } },
      'slant_right_2',
      ' ',
    },
  },
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
    provider = function()
      local statusline = require('utils').statusline()
      if statusline == nil or statusline == '' then
        return ''
      end
      local left_sep = feline_defaults['separators']['default_value']['vertical_bar_thin']
      local right_sep = feline_defaults['separators']['default_value']['vertical_bar_thin']
      return string.format('%s %s %s', left_sep, statusline, right_sep)
    end,
    hl = {
      fg = 'cyan',
      bg = 'bg',
    },
    left_sep = 'slant_right',
    right_sep = 'slant_left',
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

M.setup = function()
  require('gitsigns').setup({
    signcolumn = false,
    numhl = true,
    current_line_blame = false,
  })
  require('feline').setup({
    components = { active = conf.active, inactive = conf.inactive },
    highlight_reset_triggers = {},
  })

  vim.o.laststatus = 3
end

return M
