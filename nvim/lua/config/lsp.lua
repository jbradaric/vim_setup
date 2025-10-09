local utils = require('config.utils')

local M = {}

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
    if client:supports_method(lsp_method) then
      for _, entry in ipairs(mappings) do
        vim.keymap.set(entry[1], entry[2], entry[3], opts)
      end
    end
  end
  if client:supports_method('textDocument/documentColor') then
    vim.lsp.document_color.enable(true, bufnr, { style = 'virtual' })
  end
  vim.keymap.set('n', '\\i', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
  end, opts)
end

local function setup_lsp_autocmds(client, bufnr)
  if client:supports_method('textDocument/documentHighlight') then
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
    client.server_capabilities.hoverProvider = false -- prefer pyrefly
  end
end

local function setup_formatting()
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.py', '*.ts', '*.tsx', '*.js', '*.jsx', '*.cpp', '*.hpp', '*.c', '*.h' },
    callback = function(args)
      if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat then
        return
      end
      if vim.bo[args.buf].filetype == 'cpp' or vim.bo[args.buf].filetype == 'c' then
        local buf_path = vim.api.nvim_buf_get_name(args.buf)
        local format_conf = vim.fs.find('.clang-format', { path = buf_path, upward = true })[1]
        if not format_conf then
          return
        end
      end
      require('conform').format({ bufnr = args.buf, async = false })
    end,
  })
  vim.api.nvim_create_user_command('Format', function(args)
    local range
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = { start = { args.line1, 0 }, ['end'] = { args.line2, end_line:len() } }
    end
    require('conform').format({ async = true, lsp_format = 'fallback', range = range })
  end, { range = true })
end

M.setup = function()
  setup_highlights()
  setup_formatting()

  vim.opt.signcolumn = 'yes:1'

  local capabilities = vim.tbl_deep_extend('force', require('blink.cmp').get_lsp_capabilities(), {
    offsetEncoding = { 'utf-16' },
    general = {
      positionEncodings = { 'utf-16' },
    },
  })

  -- Apply base capabilities to all servers; on_attach handled via LspAttach below.
  vim.lsp.config('*', { capabilities = capabilities })

  vim.lsp.config('clangd', {
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--completion-style=detailed',
      '--header-insertion=never',
      '--offset-encoding=utf-16',
    },
    capabilities = capabilities,
  })

  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false },
        completion = { callSnippet = 'Replace' },
      },
    },
  })

  -- Enable all desired servers
  vim.lsp.enable({ 'clangd', 'pyrefly', 'ruff', 'lua_ls', 'ts_ls', 'tailwindcss', 'copilot' })

  -- Enable inline completion
  vim.lsp.inline_completion.enable()
  vim.keymap.set('i', '<C-y>', function() vim.lsp.inline_completion.get() end, { noremap = true, silent = true })
  vim.keymap.set('i', '<M-[>', function() vim.lsp.inline_completion.select({ count = -1 }) end,
    { noremap = true, silent = true })
  vim.keymap.set('i', '<M-]>', function() vim.lsp.inline_completion.select() end, { noremap = true, silent = true })

  -- Rust (delegated to rustaceanvim plugin)
  vim.g.rustaceanvim = { server = { on_attach = on_attach } }

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client then
        on_attach(client, ev.buf)
      end
    end,
  })
end

return M
