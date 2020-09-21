local api = vim.api
local json = require 'json'

local function read_compile_commands(buf)
  local f = io.open(api.nvim_buf_get_var(buf, 'compile_commands_path'), 'rb')
  if f == nil then
    return nil
  end
  local contents = f:read '*a'
  f:close()
  return json.decode(contents)
end

local function init_ale()
  local buf = api.nvim_get_current_buf()
  if pcall(api.nvim_buf_get_var, buf, 'ale_cpp_clang_options') or
    pcall(api.nvim_buf_get_var, buf, 'ale_c_clang_options') then
    return
  end
  if not pcall(api.nvim_buf_get_var, buf, 'compile_commands_path') then
    local project_root = vim.fn.FindRootDirectory()
    if project_root == '' then
      return
    end
    local path = project_root .. '/compile_commands.json'
    api.nvim_buf_set_var(buf, 'compile_commands_path', path)
  end

  if not vim.fn.filereadable(api.nvim_buf_get_var(buf, 'compile_commands_path')) then
    return
  end

  local t = read_compile_commands(buf)
  if t == nil then
    return
  end
  local buf_name = api.nvim_buf_get_name(buf)
  for _, v in pairs(t) do
    if (v['directory'] .. '/' .. v['file']) == buf_name then
      local arr = {}
      local skip_count = 1
      for _, arg in pairs(v['arguments']) do
        if skip_count > 0 then
          skip_count = skip_count - 1
          goto continue
        end
        if arg == v['file'] then
          goto continue
        end
        if arg == v['file']:sub(v['directory']:len() + 2) then
          goto continue
        end
        if arg == '-c' then
          goto continue
        end
        if arg == '-o' then
          skip_count = 1
          goto continue
        end
        table.insert(arr, arg)
        ::continue::
      end
      table.insert(arr, '-Wno-tautological-constant-out-of-range-compare')
      table.insert(arr, '-Wno-unsupported-friend')
      local options = table.concat(arr, ' ')
      if api.nvim_buf_get_option(buf, 'filetype') == 'c' then
        api.nvim_buf_set_var(buf, 'ale_c_clang_options', options)
      else
        api.nvim_buf_set_var(buf, 'ale_cpp_clang_options', options)
      end
    end
  end
end

local nvim_lsp = require 'nvim_lsp'
local function setup_lsp()
  -- Disable diagnostics globally
  vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end
  nvim_lsp.ccls.setup{
    on_attach=require'completion'.on_attach,
  }
  nvim_lsp.pyls.setup{
    cmd = {"/home/jurica/local_workenv3.sh", "/home/jurica/.local/bin/pyls"},
    settings = {
      pyls = {
        configurationSources = { "flake8" },
        plugins = {
          preload = {
            enabled = true,
            modules = { "act", "stfw", "age", "gtk", "gio", "glib", "gobject", "numpy" },
          },
          jedi_completion = { include_class_objects = false },
          mccabe = { enabled = false },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },
        },
      },
    },
    on_attach=require'completion'.on_attach,
  }
end

return {
  init_ale = init_ale,
  setup_lsp = setup_lsp,
}
