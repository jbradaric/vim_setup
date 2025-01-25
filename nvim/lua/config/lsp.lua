local nvim_lsp = require('lspconfig')
local utils = require('config.utils')

local M = {}

local function setup_ccls(capabilities, on_attach)
  nvim_lsp.clangd.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
    end,
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
  nvim_lsp.ruff.setup({
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
    vim.keymap.set({ 'n', 'v' }, '\\a', function()
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
  if client.name == 'ruff' then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        local buf_path = vim.api.nvim_buf_get_name(bufnr)
        local root = vim.fs.dirname(vim.fs.find('.git', { path = buf_path, upward = true })[1])
        if root == nil then
          return
        end
        if vim.loop.fs_stat(table.concat({ root, 'ci-ruff.toml' }, '/')) then
          vim.lsp.buf.format({
            bufnr = bufnr,
            async = false,
            filter = function(c) return c.name == 'ruff' end,
          })
        end
      end,
    })
  end
end

local function get_capabilities()
  return require('cmp_nvim_lsp').default_capabilities()
end

local function setup_ts_ls(capabilities, on_attach)
  nvim_lsp.ts_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

local function setup_cst_lsp(capabilities, on_attach)
  local util = require 'lspconfig.util'
  local configs = require 'lspconfig.configs'

  configs.cst_lsp = {
    default_config = {
      cmd = { 'cst_lsp' },
      filetypes = { 'python' },
      root_dir = function(fname)
        local root_files = {
          'pyproject.toml',
          'setup.py',
          'setup.cfg',
          'requirements.txt',
          'Pipfile',
        }
        return util.root_pattern(unpack(root_files))(fname)
            or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
      end,
      single_file_support = true,
    },
    docs = {
      description = [[
https://pypi.org/project/cst-lsp/
    ]],
    },
  }

  nvim_lsp.cst_lsp.setup({
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
  setup_cst_lsp(capabilities, on_attach)
  setup_ruff(capabilities, on_attach)
  setup_lua_language_server(capabilities, on_attach)
  setup_ts_ls(capabilities, on_attach)

  vim.g.rustaceanvim = {
    server = {
      on_attach = on_attach,
    },
  }

  ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
  local progress = vim.defaulttable()
  local bla = false
  vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
      if not bla then
        return
      end
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
      if not client or type(value) ~= "table" then
        return
      end
      local p = progress[client.id]

      for i = 1, #p + 1 do
        if i == #p + 1 or p[i].token == ev.data.params.token then
          p[i] = {
            token = ev.data.params.token,
            msg = ("[%3d%%] %s%s"):format(
              value.kind == "end" and 100 or value.percentage or 100,
              value.title or "",
              value.message and (" **%s**"):format(value.message) or ""
            ),
            done = value.kind == "end",
          }
          break
        end
      end

      local msg = {} ---@type string[]
      progress[client.id] = vim.tbl_filter(function(v)
        return table.insert(msg, v.msg) or not v.done
      end, p)

      local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      vim.notify(table.concat(msg, "\n"), "info", {
        id = "lsp_progress",
        title = client.name,
        opts = function(notif)
          notif.icon = #progress[client.id] == 0 and " "
              or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
      })
    end,
  })

end

return M
