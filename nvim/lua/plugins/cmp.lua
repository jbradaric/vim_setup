return {
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'onsails/lspkind-nvim' },
    config = function()
      require('config.nvim_cmp').setup()
    end,
  },
  { 'hrsh7th/cmp-vsnip' },
  {
    'hrsh7th/vim-vsnip',
    init = function()
      vim.g.vsnip_extra_mapping = false
      vim.g.vsnip_snippet_dir = vim.fn.expand('~/.config/nvim/global-snippets')
    end,
  },
}
