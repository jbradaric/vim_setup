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
      debounce_text_changes = 1000,
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
          ignoreFolders = { '__pycache__', '.ccls-cache', '.mypy_cache', '.pytest_cache' },
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

local function setup_pyright(capabilities, on_attach)
  nvim_lsp.pyright.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
      python = {
        analysis = {
          typeCheckingMode = "off",
        },
      },
    }
  })

  local function filter(arr, func)
    -- Filter in place
    -- https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
    local new_index = 1
    local size_orig = #arr
    for old_index, v in ipairs(arr) do
      if func(v, old_index) then
        arr[new_index] = v
        new_index = new_index + 1
      end
    end
    for i = new_index, size_orig do arr[i] = nil end
  end

  local function filter_diagnostics(diagnostic)
    -- Only filter out Pyright stuff for now
    if diagnostic.source ~= "Pyright" then
      return true
    end

    -- Ignore all Pyright diagnostics
    if diagnostic.source == "Pyright" then
      return false
    end

    -- Allow kwargs to be unused, sometimes you want many functions to take the
    -- same arguments but you don't use all the arguments in all the functions,
    -- so kwargs is used to suck up all the extras
    if diagnostic.message == '"kwargs" is not accessed' then
      return false
    end

    -- Allow unused function arguments, just because we override a function 
    -- doesn't mean that we need all the arguments.
    if string.match(diagnostic.message, '".+" is not accessed') then
      return false
    end

    -- Allow variables starting with an underscore
    if string.match(diagnostic.message, '"_.+" is not accessed') then
      return false
    end

    if string.match(diagnostic.message, 'Import ".+" could not be resolved from source') then
      return false
    end

    if string.match(diagnostic.message, '".+" is not a known member of module') then
      return false
    end

    return true
  end

  local function on_publish_diagnostics(a, params, client_id, c, config)
    filter(params.diagnostics, filter_diagnostics)
    vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
  end

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(on_publish_diagnostics, {})
end

local function setup_diagnosticls(capabilities, on_attach)
  nvim_lsp.diagnosticls.setup {
    capabilities = capabilities,
    filetypes = { 'python' },
    init_options = {
      linters = {
        flake8 = {
          command = 'flake8',
          debounce = 1000,
          args = {
            '--append-config',
            '/home/jurica/.config/flake8',
            '--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s',
            '-'
          },
          offsetLine = 0,
          offsetColumn = 0,
          sourceName = 'flake8',
          formatLines = 1,
          formatPattern = {
            '(\\d+),(\\d+),([A-Z]),(.*)(\\r|\\n)*$',
            {
              line = 1,
              column = 2,
              security = 3,
              message = 4
            }
          },
          securities = {
            W = 'info',
            E = 'warning',
            F = 'error',
            C = 'info',
            N = 'hint'
          }
        }
      },
      filetypes = {
        python = 'flake8',
      }
    }
  }
end

local function setup_lua_language_server(capabilities, on_attach)
  nvim_lsp.sumneko_lua.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    single_file_support = true,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim' },
          neededFileStatus = {
            ['codestyle-check'] = 'Any',
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
            indent_style = 'space',
            indent_size = '2',
            quote_style = 'single',
            align_call_args = 'true',
            align_function_define_params = 'true',
            continuous_assign_table_field_align_to_equal_sign = 'false',

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
  -- vim.api.nvim_command('setlocal signcolumn=yes:1')
  -- vim.api.nvim_buf_set_var(bufnr, 'show_signs', true)
  vim.b.show_signs = true

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)

  vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev({ float = false }) end, opts)
  vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next({ float = false }) end, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
end

local function get_capabilities()
  return require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

M.setup = function()
  setup_highlights()
  setup_vim_diagnostic()

  vim.opt.signcolumn = 'yes:1'

  local capabilities = get_capabilities()
  setup_ccls(capabilities, on_attach)
  setup_rls(capabilities, on_attach)
  -- setup_jedi_language_server(capabilities, on_attach)
    setup_pyright(capabilities, on_attach)
  -- if vim.env.USE_JEDI then
  --   setup_jedi_language_server(capabilities, on_attach)
  -- else
  --   setup_pyright(capabilities, on_attach)
  -- end
  setup_diagnosticls(capabilities, on_attach)
  setup_lua_language_server(capabilities, on_attach)
end

return M
