local nvim_lsp = require('lspconfig')
local utils = require('config.utils')

local M = {}

local function setup_ccls(capabilities, on_attach)
  nvim_lsp.ccls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
      compilationDatabaseDirectory = 'build',
      completion = {
        enableSnippetInsertion = false,
      },
    },
  }
end

local function setup_rls(capabilities, on_attach)
  nvim_lsp.rls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

local function setup_jedi_language_server(capabilities, on_attach)
  local jedi_config = {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    init_options = {
      completion = {
        disableSnippets = true,
      },
      diagnostics = {
        enable = false,
      },
      workspace = {
        symbols = {
          ignoreFolders = { "__pycache__", ".ccls-cache", ".mypy_cache", ".pytest_cache" },
        }
      }
    }
  }

  -- Override jedi settings with machine-specific settings if available
  local have_lc, local_config = pcall(require, 'local_config')
  if have_lc then
    jedi_config['cmd'] = local_config.jedi_cmd
    jedi_config['init_options']['jediSettings'] = {}
    jedi_config['init_options']['jediSettings']['autoImportModules'] = local_config.autoimport_modules
    jedi_config['init_options']['workspace']['extraPaths'] = local_config.extra_paths
    jedi_config['init_options']['workspace']['symbols']['ignoreFolders'] = local_config.ignore_folders
  end


  nvim_lsp.jedi_language_server.setup(jedi_config)
end

local function setup_diagnosticls(capabilities, on_attach)
  nvim_lsp.diagnosticls.setup {
    capabilities = capabilities,
    filetypes = { "python" },
    init_options = {
      linters = {
        flake8 = {
          command = "flake8",
          debounce = 100,
          args = {
            "--append-config",
            "/home/jurica/.config/flake8",
            "--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s",
            "-"
          },
          offsetLine = 0,
          offsetColumn = 0,
          sourceName = "flake8",
          formatLines = 1,
          formatPattern = {
            "(\\d+),(\\d+),([A-Z]),(.*)(\\r|\\n)*$",
            {
              line = 1,
              column = 2,
              security = 3,
              message = 4
            }
          },
          securities = {
            W = "info",
            E = "warning",
            F = "error",
            C = "info",
            N = "hint"
          }
        }
      },
      filetypes = {
        python = "flake8",
      }
    }
  }
end

local function setup_lua_language_server(capabilities, on_attach)
  nvim_lsp.sumneko_lua.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim' },
          neededFileStatus = {
            ['codestyle-check'] = "Any",
          },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
        },
        telemetry = {
          enable = false,
        },
        format = {
          enable = true,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
          },
        },
      },
    },
  }
end

local function setup_vim_diagnostic()
  vim.diagnostic.config({ severity_sort = true })
end

local function setup_highlights()
  utils.highlight('LspDiagnosticsErrorSign', { fg = 'Red', bg = '#000000' })
  utils.highlight('LspDiagnosticsWarningSign', { fg = 'Yellow', bg = '#000000' })
end

local function on_attach(client, bufnr)
  vim.api.nvim_command('setlocal signcolumn=yes:1')
  vim.api.nvim_buf_set_var(bufnr, 'show_signs', true)

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
end

local function get_capabilities()
  return require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

M.setup = function()
  setup_highlights()
  setup_vim_diagnostic()

  local capabilities = get_capabilities()
  setup_ccls(capabilities, on_attach)
  setup_rls(capabilities, on_attach)
  setup_jedi_language_server(capabilities, on_attach)
  setup_diagnosticls(capabilities, on_attach)
  setup_lua_language_server(capabilities, on_attach)
end

return M
