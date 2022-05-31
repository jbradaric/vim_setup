local nvim_lsp = require 'lspconfig'
local nvim_lsp_status = require 'lsp-status'

local M = {}

M.setup = function()
  vim.api.nvim_command('hi LspDiagnosticsErrorSign guifg=Red guibg=#000000')
  vim.api.nvim_command('hi LspDiagnosticsWarningSign guifg=Yellow guibg=#000000')

  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities = vim.tbl_extend('keep', capabilities or {}, nvim_lsp_status.capabilities)

  local function on_attach(client, bufnr)
    vim.api.nvim_command('setlocal signcolumn=yes:1')
    vim.api.nvim_buf_set_var(bufnr, 'show_signs', true)

    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)

    nvim_lsp_status.on_attach(client)

    if client.server_capabilities.document_symbol then
      vim.cmd([[augroup lsp_status]])
      vim.cmd([[  autocmd CursorHold,BufEnter <buffer> lua require('lsp-status').update_current_function()]])
      vim.cmd([[augroup END]])
    end
  end

  vim.diagnostic.config({ severity_sort = true })

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

  nvim_lsp.rls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }

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
    vim.tbl_deep_extend('force', jedi_config, local_config.get_jedi_settings())
  end

  nvim_lsp.jedi_language_server.setup(jedi_config)

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

  -- nvim_lsp.rust_analyzer.setup {
  --   on_attach=on_attach,
  -- }

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

return M
