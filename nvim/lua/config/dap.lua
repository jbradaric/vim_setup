local dap = require('dap')
local dapui = require('dapui')
local dap_python = require('dap-python')
local M = {}

local function debug_file()
  require('dap').continue()
end

local function debug_current_function()
  require('dap-python').test_method()
end

M.stop_debugging = function()
  dap.close()
  dapui.close()
end

local function create_command(name, callback, desc)
  local opts = { desc = desc, force = true }
  vim.api.nvim_create_user_command(name, callback, opts)
end

M.setup = function()
  local have_lc, local_config = pcall(require, 'local_config')
  if have_lc then
    local_config.setup_dap()
  else
    dap_python.setup('/usr/bin/python3')
    dap_python.test_runner = 'pytest'
  end

  create_command('Debug', function() debug_file() end, 'Run file in debugger')
  create_command('DebugFunction', function() debug_current_function() end, 'Debug current function')
  create_command('Stop', function() M.stop_debugging() end, 'Stop debugging')
  create_command('Into', function() dap.step_into() end, 'Step into')
  create_command('Over', function() dap.step_over() end, 'Step over')
  create_command('Up', function() dap.up() end, 'Go up')
  create_command('Down', function() dap.down() end, 'Go down')
  create_command('Break', function() dap.toggle_breakpoint() end, 'Toggle breakpoint')

  dapui.setup()
  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
  end
  -- dap.listeners.before.event_terminated['dapui_config'] = function()
  --   dapui.close()
  -- end
  -- dap.listeners.before.event_exited['dapui_config'] = function()
  --   dapui.close()
  -- end
end

return M
