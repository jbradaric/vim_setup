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

local nvim_lsp = require 'lspconfig'

local function setup_lsp()
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      -- Enable underline, use default values
      underline = true,
      -- Enable virtual text
      virtual_text = {
        spacing = 2,
      },
      -- Show signs
      signs = function(bufnr, client_id)
        local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, 'show_signs')
        -- No buffer local variable set, disable by default
        if not ok then
          return false
        end
        return result
      end,
      -- Disable diagnostics while in insert mode
      update_in_insert = false,
    }
  )
  local function on_attach(client, bufnr)
    require('completion').on_attach(client)
    -- require('diagnostic').on_attach(client)

    api.nvim_command('setlocal signcolumn=yes:1')
    api.nvim_buf_set_var(bufnr, 'show_signs', true)

    -- api.nvim_command('autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()')

    local opts = { noremap = true, silent = true }
    api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    api.nvim_buf_set_keymap(bufnr, 'x', '<leader>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  nvim_lsp.ccls.setup{
    on_attach=on_attach,
    settings = {
      completion = {
        enableSnippetInsertion = false,
      },
    },
  }

  nvim_lsp.rls.setup{
    on_attach=on_attach,
  }

  nvim_lsp.pyls.setup{
    cmd = {
      "/home/jurica/.virtualenvs/local-py3.9/bin/python",
      "/home/jurica/.local/bin/pyls",
    },
    settings = {
      pyls = {
        configurationSources = { "flake8" },
        plugins = {
          preload = {
            enabled = true,
            modules = { "act", "stfw", "age", "gtk", "gio", "glib", "gobject", "numpy" },
          },
          jedi_completion = { include_class_objects = false },
          autopep8 = { enabled = false },
          mccabe = { enabled = false },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },
          flake8 = { enabled = true, },
          yapf = { enabled = true, },
        },
      },
    },
    on_attach=on_attach,
  }
  nvim_lsp.rust_analyzer.setup {
    on_attach=on_attach,
  }

end

local function setup_treesitter()
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
    },
    refactor = {
      highlight_definitions = { enable = false },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "grr",
        },
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition_lsp_fallback = '<C-]>',
          list_definitions = "gnD",
          list_definitions_toc = "gO",
        },
      },
    },
    textobjects = {
      lsp_interop = {
        enable = true,
        peek_definition_code = {
          ["gdf"] = "@function.outer",
          ["gdF"] = "@class.outer",
        },
      },
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["ib"] = "@block.inner",
          ["ab"] = "@block.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
  }
end

return {
  init_ale = init_ale,
  setup_lsp = setup_lsp,
  setup_treesitter = setup_treesitter,
}
