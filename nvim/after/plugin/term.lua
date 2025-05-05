local function setup_terminal()
  vim.keymap.set('t', '<C-]>', [[<C-\><C-n><C-w>q]], { noremap = true })
  vim.keymap.set('t', '<C-^>', [[<C-\><C-n><C-^>]], { noremap = true })

  -- Exit terminal mode and go to the last cursor position
  vim.keymap.set('t', [[<C-\><C-\>]], [[<C-\><C-n>]])

  -- Make Alt+. work again
  vim.keymap.set('t', '®', '.', { noremap = true })

  -- Paste selection into terminal using the Insert key
  vim.keymap.set('t', '<Insert>', [[<C-\><C-n>"*pi]], { noremap = true })

  -- Stay in insert mode after pasting with middle click
  vim.keymap.set('t', '<MiddleMouse>', [[<C-\><C-n>"*pa]], { noremap = true })
  vim.keymap.set('t', '<MiddleRelease>', '<Nop>', { noremap = true })
  vim.keymap.set('t', '<M-MiddleDrag>', '<Nop>', { noremap = true })

  local function close_term()
    vim.fn.feedkeys('i<cr>')
  end

  local function set_term_settings()
    vim.opt_local.bufhidden = 'hide'
    vim.opt_local.number = false
    vim.opt_local.signcolumn = 'no'
  end

  local function setup_term_mappings(event)
    vim.keymap.set('n', '<C-]>', '<C-W>q',
      { noremap = true, silent = true, buffer = event.buf })
  end

  local function setup_term_mappings_on_enter(event)
    local bufname = vim.api.nvim_buf_get_name(event.buf)
    if not vim.endswith(bufname, 'nvim-work-term.sh') then
      return
    end
    vim.keymap.set('n', 'q', function() close_term() end,
      { noremap = true, silent = true, buffer = event.buf })
  end

  local group_name = 'terminal_mappings2'
  vim.api.nvim_create_augroup(group_name, { clear = true })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = group_name,
    pattern = 'term://*',
    callback = setup_term_mappings_on_enter,
  })

  vim.api.nvim_create_autocmd('TermOpen', {
    group = group_name,
    pattern = '*',
    callback = setup_term_mappings,
  })

  vim.api.nvim_create_autocmd('TermOpen', {
    group = group_name,
    pattern = '*',
    callback = set_term_settings,
  })
end

local function setup_nvr()
  local function quit_nvr()
    vim.cmd('write')

    local clients = vim.b.nvr
    if clients ~= nil then
      for _, client in ipairs(clients) do
        vim.fn.rpcnotify(client, 'Exit', 0)
      end
    end

    vim.cmd('bdelete')
    if vim.o.buftype == 'terminal' then
      vim.cmd('startinsert')
    end
  end

  vim.api.nvim_create_user_command('Wq', quit_nvr, { force = true })
end

local function setup_autoread()
  local function fix_autoread()
    if vim.fn.filereadable(vim.fn.expand('%:p')) then
      vim.cmd('silent! checktime')
    end
  end

  local group_name = 'make_autoread_work2'
  vim.api.nvim_create_augroup(group_name, { clear = true })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = group_name,
    pattern = '*',
    callback = fix_autoread,
  })
end

local WorkTerm = {}
WorkTerm.__index = WorkTerm

function WorkTerm:new()
  local work_term = {}
  work_term.last_id = -1
  return setmetatable(work_term, self)
end

function WorkTerm:open_new()
  vim.cmd(string.format("silent! execute 'edit term://%s/.scripts/nvim-work-term.sh'", vim.env.HOME))
  self.last_id = vim.api.nvim_get_current_buf()
end

function WorkTerm:open_existing()
  vim.api.nvim_set_current_buf(self.last_id)
end

local term = WorkTerm:new()

local function run_term(same_buffer)
  if not same_buffer then
    vim.cmd('vnew')
  end

  if term.last_id == -1 or vim.fn.bufexists(term.last_id) == 0 then
    term:open_new()
  else
    term:open_existing()
  end

  vim.cmd('normal i')
end

local function setup_work_term()
  vim.keymap.set('n', [[\T]], function()
      local count = vim.v.count
      if count == 0 then
        count = 1
      end
      require('toggleterm').toggle(count, vim.o.columns / 2, nil, 'vertical')
    end,
    { noremap = true, silent = true })
  vim.keymap.set('n', [[\t]], function()
      local count = vim.v.count
      if count == 0 then
        count = 1
      end
      require('toggleterm').toggle(count, nil, nil, 'float')
    end,
    { noremap = true, silent = true })
end

setup_terminal()
setup_nvr()
setup_autoread()
setup_work_term()
