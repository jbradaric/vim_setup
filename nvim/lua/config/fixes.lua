local winfixbuf_buftypes = {
  'quickfix',
}
local winfixbuf_filetypes = {
  'noice',
  'git',
  'fugitiveblame',
  'dap-repl',
  'dapui_scopes',
  'dapui_stacks',
  'dapui_watches',
  'dapui_console',
  'dapui_breakpoints',
}

local function contains(tbl, key)
  for _, k in ipairs(tbl) do
    if k == key then
      return true
    end
  end
  return false
end

local winfixbuf_group = vim.api.nvim_create_augroup('Winfixbuf', {})
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Set winfixbuf if necessary',
  group = winfixbuf_group,
  callback = function(args)
    vim.defer_fn(function()
      if args.buf == vim.api.nvim_get_current_buf() then
        local buftype = vim.bo[args.buf].buftype
        local filetype = vim.bo[args.buf].filetype
        if contains(winfixbuf_buftypes, buftype) then
          vim.wo.winfixbuf = true
        elseif contains(winfixbuf_filetypes, filetype) then
          vim.wo.winfixbuf = true
        end
      end
    end, 5)
  end,
})

vim.api.nvim_create_user_command('OpenInPopup', function(opts)
  vim.print(opts)
  local buf = vim.api.nvim_get_current_buf()
  local config = {
    style = "minimal",
    relative = "editor",
    width = opts.fargs[1] ~= nil and tonumber(opts.fargs[1]) or 80,
    height = opts.fargs[2] ~= nil and tonumber(opts.fargs[2]) or 40,
    row = 50,
    col = 50,
    border = "rounded",
  }
  vim.api.nvim_open_win(buf, true, config)
end, { nargs = '*' })
