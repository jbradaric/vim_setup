local dap = require('dap')
local dapui = require('dapui')
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
    ['<S-F5>'] = function()
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

M.stop_debugging = function()
  teardown_mappings()
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

  vim.keymap.set('n', '<F29>', '<cmd>DapContinue<CR>')
  vim.keymap.set('n', '<F9>', '<cmd>DapToggleBreakpoint<CR>')

  create_command('Debug', function() debug_file() end, 'Run file in debugger')
  create_command('DebugFunction', function() debug_current_function() end, 'Debug current function')
  create_command('Stop', function() M.stop_debugging() end, 'Stop debugging')
  create_command('Into', function() dap.step_into() end, 'Step into')
  create_command('Over', function() dap.step_over() end, 'Step over')
  create_command('Up', function() dap.up() end, 'Go up')
  create_command('Down', function() dap.down() end, 'Go down')
  create_command('Break', function() dap.toggle_breakpoint() end, 'Toggle breakpoint')

  local dapui_layout = {
    {
      elements = {
        { id = 'scopes', size = 0.25 },
        { id = 'stacks', size = 0.50 },
      },
      position = 'left',
      size = 50
    },
    {
      elements = {
        { id = 'repl', size = 0.5 },
        { id = 'console', size = 0.5 },
      },
      position = 'bottom',
      size = 15
    }
  }

  dapui.setup({
    layouts = dapui_layout,
    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    expand_lines = true,
  })
  dap.listeners.after.event_initialized['dapui_config'] = function()
    setup_mappings()
    dapui.open()
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
  end
end

return M
