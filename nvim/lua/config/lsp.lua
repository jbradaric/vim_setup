local nvim_lsp = require('lspconfig')
local utils = require('config.utils')

local M = {}

local function setup_ccls(capabilities, on_attach)
  nvim_lsp.ccls.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
    end,
    init_options = {
      -- compilationDatabaseDirectory = 'build',
      completion = {
        enableSnippetInsertion = false,
      },
      index = {
        threads = 4,
      },
    },
  })
end

local function setup_pyright(capabilities, on_attach)
  nvim_lsp.basedpyright.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      basedpyright = {
        analysis = {
          ignore = { "*" },
          typeCheckingMode = 'off',
        },
      },
    },
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
    for i = new_index, size_orig do
      arr[i] = nil
    end
  end

  local function filter_diagnostics(diagnostic)
    -- Only filter out Pyright stuff for now
    if diagnostic.source ~= 'Pyright' then
      return true
    end

    -- Ignore all Pyright diagnostics
    if diagnostic.source == 'Pyright' then
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

  local function on_publish_diagnostics(err, result, ctx, config)
    filter(result.diagnostics, filter_diagnostics)
    vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
  end

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(on_publish_diagnostics, {})
end

local function setup_ruff(capabilities, on_attach)
  nvim_lsp.ruff_lsp.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
      on_attach(client, bufnr)
    end,
    init_options = {
      settings = {
        -- Any extra CLI arguments for `ruff` go here.
        args = {},
      },
    },
  })
end

local function setup_lua_language_server(capabilities, on_attach)
  nvim_lsp.lua_ls.setup(
    {
      capabilities = capabilities,
      on_attach = on_attach,
      single_file_support = true,
      settings = {
        Lua = {
          hint = {
            enable = true,
          },
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
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
          format = {
            enable = true,
            defaultConfig = {
              indent_style = 'space',
              indent_size = 2,
              quote_style = 'single',
              align_call_args = true,
              align_function_define_params = true,
              continuous_assign_table_field_align_to_equal_sign = false,
            },
          },
        },
      },
    }
  )
end

local function setup_highlights()
  utils.highlight('LspDiagnosticsErrorSign', { fg = 'Red', bg = '#000000' })
  utils.highlight('LspDiagnosticsWarningSign', { fg = 'Yellow', bg = '#000000' })
end

local function on_attach(client, bufnr)
  vim.b.show_signs = true

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', '\\i',
    function()
      vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(nil))
    end,
    opts)
  if vim.bo[bufnr].filetype == 'rust' then
    vim.keymap.set('n', '\\a', '<cmd>RustLsp codeAction<CR>')
  end
  vim.keymap.set('n', '\\i', function()
    vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
  end, opts)
  if client.supports_method('textDocument/formatting') then
    vim.keymap.set('n', '\\f', vim.lsp.buf.format, opts)
    vim.keymap.set('v', '\\f', vim.lsp.buf.format, opts)
  end
  if client.supports_method('textDocument/codeAction') then
    vim.keymap.set('n', '\\a', function()
      vim.lsp.buf.code_action()
    end, opts)
  end
  if client.supports_method('textDocument/documentHighlight') then
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end
  if client.name == 'ruff_lsp' then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        local buf_path = vim.api.nvim_buf_get_name(bufnr)
        local root = nvim_lsp.util.find_git_ancestor(buf_path)
        if root == nil then
          return
        end
        if nvim_lsp.util.path.exists(nvim_lsp.util.path.join(root, 'ci-ruff.toml')) then
          vim.lsp.buf.format({
            bufnr = bufnr,
            async = false,
            filter = function(c) return c.name == 'ruff_lsp' end,
          })
        end
      end,
    })
  end
end

local function get_capabilities()
  return require('cmp_nvim_lsp').default_capabilities()
end

local function setup_tsserver(capabilities, on_attach)
  nvim_lsp.tsserver.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

M.setup = function()
  setup_highlights()

  vim.opt.signcolumn = 'yes:1'

  local capabilities = get_capabilities()
  setup_ccls(capabilities, on_attach)
  setup_pyright(capabilities, on_attach)
  setup_ruff(capabilities, on_attach)
  setup_lua_language_server(capabilities, on_attach)
  setup_tsserver(capabilities, on_attach)

  vim.g.rustaceanvim = {
    server = {
      on_attach = on_attach,
    },
  }
end

return M
