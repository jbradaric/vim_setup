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

local mappings_set = false

local function setup_mappings()
  if mappings_set then
    return
  end
  for mode, mappings in pairs(keymaps) do
    for key, callback in pairs(mappings) do
      vim.keymap.set(mode, key, callback)
    end
  end
  mappings_set = true
end

local function teardown_mappings()
  if not mappings_set then
    return
  end
  for mode, mappings in pairs(keymaps) do
    for key, _ in pairs(mappings) do
      vim.keymap.del(mode, key)
    end
  end
  mappings_set = false
end

local function debug_file()
  require('dap').continue()
end

local function debug_current_function()
  require('dap-python').test_method()
end

local function create_command(name, callback, desc)
  local opts = { desc = desc, force = true }
  vim.api.nvim_create_user_command(name, callback, opts)
end

local function focus_ghostty_on_breakpoint()
  local ghostty_wm_class = "ghostty" -- Adjust this if necessary!

  local command_str = string.format(
    "sh -c 'WID=$(xdotool search --sync --onlyvisible --classname %s | head -n1); [ -n \"$WID\" ] && xdotool windowactivate --sync \"$WID\"'",
    vim.fn.shellescape(ghostty_wm_class) -- Use shellescape for safety if class name could have special chars
  )

  vim.fn.jobstart(command_str, {
    on_stderr = function(_, data, _)
      if data and #data > 0 and data[1] ~= "" then
        vim.schedule(function()
          vim.notify(
            "nvim-dap: Error focusing " .. ghostty_wm_class .. ": " .. table.concat(data, "\n"),
            vim.log.levels.WARN
          )
        end)
      end
    end,
  })
end


local function setup_dap_events()
  local dv = require("dap-view")
  dap.listeners.before.attach["dap-view-config"] = function()
    setup_mappings()
    dv.open()
  end
  dap.listeners.before.launch["dap-view-config"] = function()
    setup_mappings()
    dv.open()
  end
  dap.listeners.before.event_terminated["dap-view-config"] = function()
    teardown_mappings()
    dv.close()
  end
  dap.listeners.before.event_exited["dap-view-config"] = function()
    teardown_mappings()
    dv.close()
  end
  dap.listeners.after.event_stopped['auto_focus_ghostty'] = function()
    focus_ghostty_on_breakpoint()
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
