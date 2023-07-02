return {
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  { 'lewis6991/gitsigns.nvim' },
  { 'stevearc/dressing.nvim' },
  { 'rcarriga/nvim-notify' },
  { 'folke/trouble.nvim' },
  { 'rebelot/heirline.nvim' },
  {
    'kana/vim-textobj-user',
    config = function()
      vim.fn['textobj#user#plugin']('quotes', {
        quotes = {
          pattern = { "'", '"' },
          select = { 'aq', 'iq' },
        },
      })
    end,
  },
  { 'kana/vim-textobj-indent', dependencies = { 'kana/vim-textobj-user' } },
  { 'kana/vim-textobj-lastpat', dependencies = { 'kana/vim-textobj-user' } },
  { 'kana/vim-textobj-underscore', dependencies = { 'kana/vim-textobj-user' } },
  { 'michaeljsmith/vim-indent-object' },
  {
    'wellle/targets.vim',
    init = function()
      vim.g.targets_argOpening = '[({[]'
      vim.g.targets_argClosing = '[]})]'
    end,
  },
  { 'folke/paint.nvim' },
  { 'mg979/vim-visual-multi' },
  {
    'jbradaric/vim-interestingwords',
    init = function()
      vim.g.interestingWordsGUIColors = { '#99B3FF', '#B399FF', '#E699FF', '#FF99B3', '#99FFE6', '#FFD65C', '#99FFB3', '#E6FF99', '#FFB399', '#5CD6FF', '#99FF99', '#FFF6CC' }
      vim.keymap.set('n', '<C-k>', '<cmd>call InterestingWords("n")<cr>', { silent = true })
    end,
  },
  { 'tpope/vim-commentary' },
  {
    'tpope/vim-fugitive',
    init = function()
      vim.keymap.set('n', '<leader>gco', '<cmd>Git checkout<space>', { silent = true })
      vim.keymap.set('n', '<leader>gcm', '<cmd>Git checkout master<cr>', { silent = true })
      vim.keymap.set('n', '<leader>gpl', '<cmd>Git pull<cr>', { silent = true })
      vim.keymap.set('n', '<leader>gpu', '<cmd>Git push<cr>', { silent = true })
    end
  },
  { 'tpope/vim-git' },
  { 'tpope/vim-repeat' },
  {
    'tpope/vim-surround',
    init = function()
      vim.g.surround_no_insert_mappings = 1
    end,
  },
  { 'tpope/vim-unimpaired' },
  { 'tpope/vim-eunuch' },
  { 'tpope/vim-abolish' },
  {
    'tpope/vim-sleuth',
    cmd = 'Sleuth',
    init = function()
      vim.g.sleuth_automatic = 0
    end,
  },
  { 'avakhov/vim-yaml', ft = 'yaml' },
  { 'cespare/vim-toml', ft = 'toml' },
  { 'nvim-lua/plenary.nvim' },
  { 'NeogitOrg/neogit' },
  { 'nvim-telescope/telescope.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'chrisbra/NrrwRgn', cmd = 'NRV' },
  {
    'mtth/scratch.vim',
    init = function()
      vim.g.scratch_autohide = 0
      vim.g.scratch_insert_autohide = 0
      vim.g.scratch_no_mappings = 1
    end,
  },
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    init = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  { 'xolox/vim-misc' },
  {
    'xolox/vim-notes',
    cmd = { 'Note', 'NoteFromSelectedText' },
    init = function()
      vim.g.notes_directories = { '~/.config/nvim/notes' }
      vim.g.notes_title_sync = 'rename_file'
    end,
  },
  {
    'ludovicchabant/vim-gutentags',
    init = function()
      vim.g.gutentags_add_default_project_roots = 1
      vim.g.gutentags_file_list_command = 'fd'
    end,
  },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-vsnip' },
  {
    'hrsh7th/vim-vsnip',
    init = function()
      vim.g.vsnip_extra_mapping = false
      vim.g.vsnip_snippet_dir = vim.fn.expand('~/.config/nvim/global-snippets')
    end,
  },
  { 'liuchengxu/vista.vim' },

  { 'onsails/lspkind-nvim' },
  { 'neovim/nvim-lspconfig' },
  { 'simrat39/rust-tools.nvim' },

  { 'justinmk/vim-dirvish' },
  { 'jbradaric/rooter.nvim' },
  { 'tyru/open-browser.vim' },
  { 'gabrielelana/vim-markdown' },
  {
    'jbradaric/nvim-miniyank',
    init = function()
      vim.cmd([[map p <Plug>(miniyank-autoput)]])
      vim.cmd([[map P <Plug>(miniyank-autoPut)]])
      vim.cmd([[map <A-p> <Plug>(miniyank-cycle)]])
      vim.cmd([[map <A-n> <Plug>(miniyank-cycleback)]])
    end,
  },
  { 'nvim-treesitter/nvim-treesitter' },
  { 'Mofiqul/vscode.nvim' },
  { 'mfussenegger/nvim-dap' },
  { 'mfussenegger/nvim-dap-python' },
  { 'rcarriga/nvim-dap-ui' },
  { 'luukvbaal/statuscol.nvim' },
  { 'MunifTanjim/nui.nvim' },
  { 'folke/noice.nvim' },
  { 'echasnovski/mini.nvim' },
  { 'ThePrimeagen/refactoring.nvim' },
}
