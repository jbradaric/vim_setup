local nvim_lsp = require('lspconfig')
local utils = require('config.utils')

local M = {}

local function setup_ccls(capabilities)
  nvim_lsp.clangd.setup({
    capabilities = capabilities,
    cmd = { 'clangd', '--log=verbose', '--fallback-style=file:/work/data/src/local/py-cef/.clang-format' },
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

local function setup_pyright(capabilities)
  local new_capabilities = vim.tbl_deep_extend('force', {}, capabilities)
  nvim_lsp.basedpyright.setup({
    capabilities = new_capabilities,
    settings = {
      basedpyright = {
        analysis = {
          ignore = { "*" },
          typeCheckingMode = 'off',
          diagnosticSeverityOverrides = {
            reportUnusedFunction = 'none',
          },
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
    if diagnostic.source ~= 'basedpyright' then
      return true
    end

    -- Ignore all Pyright diagnostics
    if diagnostic.source == 'basedpyright' then
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

  local function on_publish_diagnostics(err, result, ctx)
    filter(result.diagnostics, filter_diagnostics)
    vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
  end

  vim.lsp.handlers['textDocument/publishDiagnostics'] = on_publish_diagnostics
end

local function setup_ruff(capabilities)
  nvim_lsp.ruff.setup({
    capabilities = capabilities,
    init_options = {
      settings = {
        -- Any extra CLI arguments for `ruff` go here.
        args = {},
      },
    },
  })
end

local function setup_lua_language_server(capabilities)
  nvim_lsp.lua_ls.setup(
    {
      capabilities = capabilities,
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

local common_keymaps = {
  { 'n', 'K',  vim.lsp.buf.hover },
  { 'n', 'gd', vim.lsp.buf.declaration },
}

local ft_keymaps = {
  rust = {
    { 'n', '\\a', '<cmd>RustLsp codeAction<CR>' },
  },
}

local lsp_method_keymaps = {
  ['textDocument/formatting'] = {
    { 'n', '\\f', vim.lsp.buf.format },
    { 'v', '\\f', vim.lsp.buf.format },
  },
  ['textDocument/implementation'] = {
    { 'n', 'gD', vim.lsp.buf.implementation },
  },
  ['textDocument/codeAction'] = {
    { { 'n', 'v' }, '\\a', vim.lsp.buf.code_action },
  },
}

local function setup_highlights()
  utils.highlight('LspDiagnosticsErrorSign', { fg = 'Red', bg = '#000000' })
  utils.highlight('LspDiagnosticsWarningSign', { fg = 'Yellow', bg = '#000000' })
end

local function setup_lsp_mappings(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  for _, entry in ipairs(common_keymaps) do
    vim.keymap.set(entry[1], entry[2], entry[3], opts)
  end

  for ft, mappings in pairs(ft_keymaps) do
    if vim.bo.filetype == ft then
      for _, entry in ipairs(mappings) do
        vim.keymap.set(entry[1], entry[2], entry[3], opts)
      end
    end
  end

  for lsp_method, mappings in pairs(lsp_method_keymaps) do
    if client.supports_method(lsp_method) then
      for _, entry in ipairs(mappings) do
        vim.keymap.set(entry[1], entry[2], entry[3], opts)
      end
    end
  end

  vim.keymap.set('n', '\\i',
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end,
    opts)
end

local function setup_lsp_autocmds(client, bufnr)
  -- Show variable references on hover
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
end

local function on_attach(client, bufnr)
  vim.b.show_signs = true

  setup_lsp_mappings(client, bufnr)
  setup_lsp_autocmds(client, bufnr)

  if client.name == 'ruff' then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end
end

local function setup_ts_ls(capabilities)
  nvim_lsp.ts_ls.setup({
    capabilities = capabilities,
  })
end

local function setup_tailwindcss(capabilities)
  nvim_lsp.tailwindcss.setup({
    capabilities = capabilities,
  })
end

local function setup_formatting()
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { '*.py', '*.ts', '*.tsx', '*.js', '*.jsx', '*.cpp', '*.hpp', '*.c', '*.h' },
    callback = function(args)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat then
        return
      end

      -- Only autoformat C++ files if they have a .clang-format file
      if vim.bo[args.buf].filetype == 'cpp' or vim.bo[args.buf].filetype == 'c' then
        local buf_path = vim.api.nvim_buf_get_name(args.buf)
        local format_conf = vim.fs.find('.clang-format', { path = buf_path, upward = true })[1]
        if format_conf == nil then
          return
        end
      end

      require("conform").format({ bufnr = args.buf, async = false })
    end,
  })

  vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ["end"] = { args.line2, end_line:len() },
      }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
  end, { range = true })

end

M.setup = function()
  setup_highlights()
  setup_formatting()

  vim.opt.signcolumn = 'yes:1'

  local capabilities = require('blink.cmp').get_lsp_capabilities()
  setup_ccls(capabilities)
  setup_pyright(capabilities)
  setup_ruff(capabilities)
  setup_lua_language_server(capabilities)
  setup_ts_ls(capabilities)
  setup_tailwindcss(capabilities)

  vim.g.rustaceanvim = {
    server = {
      on_attach = on_attach,
    },
  }

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client then
        on_attach(client, vim.api.nvim_get_current_buf())
      end
    end,
  })

end

return M
