local heirline = require('heirline')
local conditions = require('heirline.conditions')
local utils = require('heirline.utils')
local rooter = require('rooter')
local icons = require('dapui.config').controls.icons

local M = {}

local LeftBorder = {
  provider = '▊ ',
  hl = { fg = 'blue', bg = 'background', bold = true, }
}

local Ruler = {
  provider = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    return string.format('%010s', string.format('%d:%d', cursor[1], cursor[2]))
  end,
}

local RulerPercent = {
  provider = '%P',
}

local ScrollBar = {
  static = {
    sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = { fg = 'blue', bg = 'bright_bg' },
}

local Align = { provider = '%=' }
local Space = { provider = ' ' }

local ViMode = {
  -- get vim current mode, this information will be required by the provider
  -- and the highlight functions, so we compute it only once per component
  -- evaluation and store it as a component attribute
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()

    -- execute this only once, this is required if you want the ViMode
    -- component to be updated on operator pending mode
    if not self.once then
      vim.api.nvim_create_autocmd('ModeChanged', {
        pattern = '*:*o',
        command = 'redrawstatus'
      })
      self.once = true
    end
  end,
  -- Now we define some dictionaries to map the output of mode() to the
  -- corresponding string and color. We can put these into `static` to compute
  -- them at initialisation time.
  static = {
    mode_names = { -- change the strings if you like it vvvvverbose!
      n = 'N',
      no = 'N?',
      nov = 'N?',
      noV = 'N?',
      ['no\22'] = 'N?',
      niI = 'Ni',
      niR = 'Nr',
      niV = 'Nv',
      nt = 'Nt',
      v = 'V',
      vs = 'Vs',
      V = 'V_',
      Vs = 'Vs',
      ['\22'] = '^V',
      ['\22s'] = '^V',
      s = 'S',
      S = 'S_',
      ['\19'] = '^S',
      i = 'I',
      ic = 'Ic',
      ix = 'Ix',
      R = 'R',
      Rc = 'Rc',
      Rx = 'Rx',
      Rv = 'Rv',
      Rvc = 'Rv',
      Rvx = 'Rv',
      c = 'C',
      cv = 'Ex',
      r = '...',
      rm = 'M',
      ['r?'] = '?',
      ['!'] = '!',
      t = 'T',
    },
    mode_colors = {
      n = 'green',
      i = 'red',
      v = 'blue',
      V = 'blue',
      ['\22'] = 'cyan',
      c = 'orange',
      s = 'purple',
      S = 'purple',
      ['\19'] = 'purple',
      R = 'orange',
      r = 'orange',
      ['!'] = 'red',
      t = 'red',
    }
  },
  -- We can now access the value of mode() that, by now, would have been
  -- computed by `init()` and use it to index our strings dictionary.
  -- note how `static` fields become just regular attributes once the
  -- component is instantiated.
  -- To be extra meticulous, we can also add some vim statusline syntax to
  -- control the padding and make sure our string is always at least 2
  -- characters long. Plus a nice Icon.
  provider = ' ',
  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true, }
  end,
  -- Re-evaluate the component only on ModeChanged event!
  -- This is not required in any way, but it's there, and it's a small
  -- performance improvement.
  update = {
    'ModeChanged',
  },
}

local Diagnostics = {

  condition = conditions.has_diagnostics,

  static = {
    error_icon = vim.fn.sign_getdefined('DiagnosticSignError')[1].text,
    warn_icon = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text,
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  end,

  update = { 'DiagnosticChanged', 'BufEnter' },

  on_click = {
    callback = function()
      require('trouble').toggle({ mode = 'document_diagnostics' })
    end,
    name = 'heirline_diagnostics',
  },

  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (self.error_icon .. self.errors .. ' ')
    end,
    hl = { fg = 'diag_error' },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. ' ')
    end,
    hl = { fg = 'diag_warn' },
  },
}

local GitBranchName = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = { fg = 'orange' },

  {   -- git branch name
    provider = function(self)
      return ' ' .. self.status_dict.head
    end,
    hl = { fg = 'purple', bold = true }
  },
}

local special_files = {
  fugitiveblame = '[Fugitive]',
}

local FileNameBlock = {
  -- let's first set up some attributes needed by this component and it's children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
    self.filetype = vim.opt_local.filetype:get()
  end,
}
-- We can now define some children separately and add them later

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
  end,
  condition = function(self)
    return special_files[self.filetype] == nil
  end,
  provider = function(self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end
}

local function startswith(s, p)
  return string.sub(s, 1, #p) == p
end

local FileName = {
  provider = function(self)
    local special = special_files[self.filetype]
    if special ~= nil then
      return special
    end
    -- show the filename relative to root directory
    local filename = self.filename
    if filename == '' then return '[No Name]' end
    local root_dir = rooter.find_root(filename)
    if root_dir ~= nil and startswith(filename, root_dir .. '/') then
      local prefix = root_dir .. '/'
      filename = string.sub(filename, #prefix + 1, #filename)
    end
    -- now, if the filename would occupy more than 1/4th of the available
    -- space, we trim the file path to its initials
    -- See Flexible Components section below for dynamic truncation
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = { fg = utils.get_highlight('Directory').fg },
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = '[+]',
    hl = { fg = 'green' },
  },
  {
    condition = function(self)
      if special_files[self.filetype] ~= nil then
        return false
      end
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = '',
    hl = { fg = 'orange' },
  },
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = 'cyan', bold = true, force = true }
    end
  end,
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(FileNameBlock,
                             FileIcon,
                             utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
                             FileFlags,
                             { provider = '%<' } -- this means that the statusline is cut here when there's not enough space
)

local DapMessages = {
  condition = function()
    local session = require('dap').session()
    return session ~= nil
  end,
  {
    provider = function()
      local session = require('dap').session()
      if not session or session.stopped_thread_id then
        return ' ' .. icons.play .. ' '
      else
        return ' ' .. icons.pause .. ' '
      end
    end,
    on_click = {
      callback = function()
        local session = require('dap').session()
        if not session or session.stopped_thread_id then
          require('dap').continue()
        else
          require('dap').pause()
        end
      end,
      name = 'heirline_dap_continue',
    },
    hl = 'DapUIPlayPause'
  },
  Space,
  {
    provider = function()
      return ' ' .. icons.step_into .. ' '
    end,
    on_click = {
      callback = function()
        require('dap').step_into()
      end,
      name = 'heirline_dap_step_into',
    },
    hl = 'DapUIStepInto'
  },
  Space,
  {
    provider = function()
      return ' ' .. icons.step_over .. ' '
    end,
    on_click = {
      callback = function()
        require('dap').step_over()
      end,
      name = 'heirline_dap_step_over',
    },
    hl = 'DapUIStepOver'
  },
  Space,
  {
    provider = function()
      return ' ' .. icons.step_out .. ' '
    end,
    on_click = {
      callback = function()
        require('dap').step_out()
      end,
      name = 'heirline_dap_step_out',
    },
    hl = 'DapUIStepOut'
  },
  Space,
  {
    provider = function()
      return ' ' .. icons.run_last .. ' '
    end,
    on_click = {
      callback = function()
        require('dap').run_last()
      end,
      name = 'heirline_dap_run_last',
    },
    hl = 'DapUIRestart'
  },
  Space,
  {
    provider = function()
      return ' ' .. icons.terminate .. ' '
    end,
    on_click = {
      callback = function()
        require('dap').terminate()
      end,
      name = 'heirline_dap_terminate',
    },
    hl = 'DapUIStop'
  },

  Align,

  {
    provider = function()
      return ' ' .. require('dap').status() .. ' '
    end,
    hl = 'Debug',
  },
}

local WinBars = {
  fallthrough = false,
  {   -- Hide the winbar for special buffers
    condition = function()
      return conditions.buffer_matches({
        buftype = { 'nofile', 'prompt', 'help', 'quickfix', 'terminal' },
        filetype = { '^git.*', 'fugitive' },
      })
    end,
    init = function()
      vim.opt_local.winbar = nil
    end
  },
  {   -- An inactive winbar for regular files
    condition = function()
      return not conditions.is_active()
    end,
    utils.surround({ '', '' }, 'bright_bg', { hl = { fg = 'gray', force = true }, FileNameBlock }),
  },
  -- A winbar for regular files
  utils.surround({ '', '' }, 'bright_bg', FileNameBlock),
}

LSPMessages = {
  provider = function()
    local msg = vim.b['lsp_progress']
    if msg == nil or msg == vim.NIL then
      return ''
    else
      return msg
    end
  end,
  hl = 'Debug',
}

LSP = {
  init = function(self)
    local names = {}
    for _, server in pairs(vim.lsp.buf_get_clients(0)) do
      table.insert(names, server.name)
    end
    self.lsp_names = names
  end,
  condition = function(self)
    return self.lsp_names ~= nil and #self.lsp_names > 0
  end,
  provider = function(self)
    return table.concat(self.lsp_names, ',')
  end,
  hl = { fg = 'blue' },
}

M.setup = function()
  -- require('gitsigns').setup({
  --   signcolumn = false,
  --   numhl = true,
  --   current_line_blame = false,
  -- })

  vim.o.laststatus = 3

  local colors = {
    white = utils.get_highlight('Normal').fg,
    background = utils.get_highlight('Normal').bg,
    bright_bg = utils.get_highlight('Folded').bg,
    bright_fg = utils.get_highlight('Folded').fg,
    red = utils.get_highlight('DiagnosticError').fg,
    dark_red = utils.get_highlight('DiffDelete').bg,
    green = utils.get_highlight('Comment').fg,
    blue = utils.get_highlight('Identifier').fg,
    gray = utils.get_highlight('NonText').fg,
    orange = utils.get_highlight('Constant').fg,
    purple = utils.get_highlight('Statement').fg,
    cyan = utils.get_highlight('Special').fg,
    diag_warn = utils.get_highlight('DiagnosticWarn').fg,
    diag_error = utils.get_highlight('DiagnosticError').fg,
    diag_hint = utils.get_highlight('DiagnosticHint').fg,
    diag_info = utils.get_highlight('DiagnosticInfo').fg,
    git_del = utils.get_highlight('GitSignsDelete').fg,
    git_add = utils.get_highlight('GitSignsAdd').fg,
    git_change = utils.get_highlight('GitSignsChange').fg,
  }

  heirline.setup({
    statusline = {
      LeftBorder, Space, ViMode, Space, Ruler, Space, Diagnostics,
      Align,
      LSPMessages, Space, LSP, Space, GitBranchName, Space, RulerPercent, Space, ScrollBar,
    },
    winbar = { WinBars, Align, DapMessages },
    opts = {
      colors = colors,
      disable_winbar_cb = function(args)
        return conditions.buffer_matches({
          buftype = { 'prompt', 'nofile', 'help', 'quickfix', 'terminal', },
          filetype = { '^git.*', 'fugitive', 'Trouble' },
        }, args.buf)
      end,
    },
  })

  local timer = nil

  vim.api.nvim_create_autocmd('LspProgress', {
    pattern = { '*' },
    callback = function(args)
      local bufnr = args.buf
      if not vim.lsp.buf_is_attached(bufnr, args.data.client_id) then
        return
      end
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local msg = args.data.result
      local status = nil
      if msg == nil then
        status = nil
      elseif msg.value == nil then
        status = nil
      elseif msg.value.kind == 'end' or msg.value.kind == 'begin' then
        status = nil
      elseif msg.value.kind ~= 'report' then
        status = nil
      else
        status = msg.value.message
        local title = msg.value.title or ''
        if title ~= '' and title ~= nil then
          status = string.format('[%s] %s - %s', client.name, title, msg.value.message)
        else
          status = string.format('[%s] %s', client.name, msg.value.message)
        end
      end
      vim.api.nvim_buf_set_var(bufnr, 'lsp_progress', status)
      if timer == nil then
        timer = vim.uv.new_timer()
        timer:start(200, 0, function()
          timer:stop()
          timer:close()
          vim.schedule(vim.cmd['redrawstatus'])
          timer = nil
        end)
      end
    end
  })
end

return M
