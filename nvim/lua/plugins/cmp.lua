return {
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'onsails/lspkind-nvim', 'L3MON4D3/LuaSnip' },
    config = function()
      require('config.nvim_cmp').setup()
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'saadparwaiz1/cmp_luasnip' },
    version = '^2.*',
    config = function()
      require('config.snippets').setup()
    end,
  }
}
