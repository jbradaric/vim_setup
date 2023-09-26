return {
  {
    'folke/neodev.nvim',
    opts = {},
  },
  {
    'jbradaric/rooter.nvim',
    config = function()
      require('config.rooter').setup()
    end
  },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signcolumn = false,
      numhl = true,
      current_line_blame = false,
      on_attach = function(bufnr)
        local gitsigns = package.loaded.gitsigns
        vim.keymap.set('n', ']g', function() vim.schedule(gitsigns.next_hunk) end, { buffer = bufnr })
        vim.keymap.set('n', '[g', function() vim.schedule(gitsigns.prev_hunk) end, { buffer = bufnr })
      end,
    },
    config = true,
  },
  { 'stevearc/dressing.nvim' },
  {
    'rcarriga/nvim-notify',
    config = function()
      require('config.notify').setup()
    end
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = true,
  },
  {
    'rebelot/heirline.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'jbradaric/rooter.nvim',
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      require('config.statusline').setup()
    end,
  },
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
  {
    'mg979/vim-visual-multi',
    init = function()
      vim.g.VM_sublime_mappings = true
      vim.g.VM_default_mappings = false
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>',
        ['Find Subword Under'] = '<C-d>',
      }
    end,
  },
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
      vim.keymap.set('n', '<leader>gco', '<cmd>Telescope git_branches', { silent = true })
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
  {
    'NeogitOrg/neogit',
    config = function()
      require('config.neogit').setup()
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('config.telescope').setup()
    end,
  },
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
  { 'liuchengxu/vista.vim' },

  {
    'onsails/lspkind-nvim',
    config = function()
      require('config.lsp_icons').setup()
    end,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('config.lsp').setup()
    end,
  },
  { 'simrat39/rust-tools.nvim' },

  { 'justinmk/vim-dirvish' },
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
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('config.treesitter').setup()
    end,
  },
  {
    'Mofiqul/vscode.nvim',
    priority = 10000,
    config = function()
      require('config.colorscheme').setup()
    end,
  },
  {
    'mfussenegger/nvim-dap',
    config = function()
      require('config.dap').setup()
    end
  },
  {
    'mfussenegger/nvim-dap-python',
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  {
    'luukvbaal/statuscol.nvim',
    opts = {
      setopt = true,
    },
  },
  { 'MunifTanjim/nui.nvim' },
  { 'echasnovski/mini.nvim' },
  {
    'ThePrimeagen/refactoring.nvim',
    config = function()
      require('config.refactoring').setup()
    end
  },
  { dir = vim.fn.expand('~/src/misc/nvim-work-config') },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        suggestions = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    dependencies = { 'zbirenbaum/copilot.lua', 'hrsh7th/nvim-cmp' },
    config = function()
      require('copilot_cmp').setup()
    end,
  },
}
