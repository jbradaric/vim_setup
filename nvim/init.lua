vim.g.mapleader = ','

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    -- '--branch=stable', -- latest stable release
    '--branch=pull/2060/head',
    lazypath,
  }):wait()
end
vim.opt.rtp:prepend(lazypath)
require('config.options')
require('config.filetypes')
require('config.diagnostics')
require('config.fixes')

require('lazy').setup('plugins')

-- needs to be loaded after lazy.nvim plugins for some reason
require('config.builtin_plugins')
