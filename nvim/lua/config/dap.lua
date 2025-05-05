local dap = require('dap')
-- local dapui = require('dapui')
local dap_python = require('dap-python')
local M = {}

local keymaps = {
  n = {
    ['<F5>'] = function()
      require('dap').continue()
    end;
    ['<F10>'] = function()
      require('dap').step_over()
    end;
    ['<F11>'] = function()
      require('dap').step_into()
    end;
    ['<S-F11>'] = function()
      require('dap').step_out()
    end;
    ['<F23>'] = function()
      require('dap').step_out()
    end;
    ['<S-F5>'] = function()
      M.stop_debugging()
    end;
    ['<F17>'] = function()
      M.stop_debugging()
    end;
    ['<M-e>'] = function()
      require('dapui').eval()
    end;
  },
  v = {
    ['<M-e>'] = function()
      require('dapui').eval()
    end;
  }
}

local function setup_mappings()
  for mode, mappings in pairs(keymaps) do
    for key, callback in pairs(mappings) do
      vim.keymap.set(mode, key, callback)
    end
  end
end

local function teardown_mappings()
  for mode, mappings in pairs(keymaps) do
    for key, _ in pairs(mappings) do
      vim.keymap.del(mode, key)
    end
  end
end

local function debug_file()
  require('dap').continue()
end

local function debug_current_function()
  require('dap-python').test_method()
end

local debug_win = nil
local debug_tab = nil
local debug_tabnr = nil

local function open_in_tab()
  if debug_win and vim.api.nvim_win_is_valid(debug_win) then
    vim.api.nvim_set_current_win(debug_win)
    return
  end

  vim.cmd('tabedit %')
  debug_win = vim.fn.win_getid()
  if debug_win == nil then
    return
  end
  debug_tab = vim.api.nvim_win_get_tabpage(debug_win)
  debug_tabnr = vim.api.nvim_tabpage_get_number(debug_tab)

  setup_mappings()
  -- dapui.open()
end

local function close_tab()
  -- dapui.close()

  if debug_tab and vim.api.nvim_tabpage_is_valid(debug_tab) then
    vim.api.nvim_exec2('tabclose ' .. debug_tabnr, { output = false })
  end

  debug_win = nil
  debug_tab = nil
  debug_tabnr = nil
end

M.stop_debugging = function()
  teardown_mappings()
  dap.close()
  close_tab()
end

local function create_command(name, callback, desc)
  local opts = { desc = desc, force = true }
  vim.api.nvim_create_user_command(name, callback, opts)
end

local function setup_dap_events()
  local dv = require("dap-view")
  dap.listeners.before.attach["dap-view-config"] = function()
    dv.open()
  end
  dap.listeners.before.launch["dap-view-config"] = function()
    dv.open()
  end
  dap.listeners.before.event_terminated["dap-view-config"] = function()
    dv.close()
  end
  dap.listeners.before.event_exited["dap-view-config"] = function()
    dv.close()
  end
end

M.setup = function()
  local have_lc, local_config = pcall(require, 'local_config')
  if have_lc then
    local_config.setup_dap()
  else
    dap_python.setup('/usr/bin/python3')
    dap_python.test_runner = 'pytest'
  end

  vim.keymap.set('n', '<F29>', function() dap.run_last() end)
  vim.keymap.set('n', '<F9>', '<cmd>DapToggleBreakpoint<CR>')

  create_command('Debug', function() debug_file() end, 'Run file in debugger')
  create_command('DebugFunction', function() debug_current_function() end, 'Debug current function')
  create_command('Stop', function() M.stop_debugging() end, 'Stop debugging')
  create_command('Into', function() dap.step_into() end, 'Step into')
  create_command('Over', function() dap.step_over() end, 'Step over')
  create_command('Up', function() dap.up() end, 'Go up')
  create_command('Down', function() dap.down() end, 'Go down')
  create_command('Break', function() dap.toggle_breakpoint() end, 'Toggle breakpoint')

  setup_dap_events()
end

return M
