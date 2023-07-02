vim.g.mapleader = ','

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local options = {
  backup = false,
  swapfile = false,
  modeline = false,
  undofile = true,
  autochdir = false,
  complete = { 'k' },
  showbreak = '↪',
  listchars = { 'tab:→ ', 'trail:•' },
  mouse = 'a',
  wrap = false,
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = true,
  wildignore = { '*.bak', '*.o', '*.e', '*~', '*.class', '*.pyc' },
  wildmode = 'full',
  wildoptions = 'pum',
  number = true,
  virtualedit = 'block',
  splitright = true,
  splitbelow = true,
  scrolloff = 3,
  updatetime = 750,
  splitkeep = 'cursor',
  ignorecase = true,
  smartcase = true,
  ttimeoutlen = 0,
  foldenable = false,
  pumblend = 5,
  previewheight = 20,
}

for name, value in pairs(options) do
  if type(value) == 'table' then
    for _, v in ipairs(value) do
      vim.opt[name]:append(v)
    end
  else
    vim.opt[name] = value
  end
end

vim.fn.sign_define('DiagnosticSignError', { text = '✖', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '⚠', texthl = 'DiagnosticSignError' })

require('lazy').setup('plugins')
require('config').setup()
