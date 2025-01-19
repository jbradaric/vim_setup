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
  -- {
  --   'kana/vim-textobj-user',
  --   config = function()
  --     vim.fn['textobj#user#plugin']('quotes', {
  --       quotes = {
  --         pattern = { "'", '"' },
  --         select = { 'aq', 'iq' },
  --       },
  --     })
  --   end,
  -- },
  -- { 'kana/vim-textobj-indent', dependencies = { 'kana/vim-textobj-user' } },
  -- { 'kana/vim-textobj-lastpat', dependencies = { 'kana/vim-textobj-user' } },
  -- { 'kana/vim-textobj-underscore', dependencies = { 'kana/vim-textobj-user' } },
  -- { 'michaeljsmith/vim-indent-object' },
  -- {
  --   'wellle/targets.vim',
  --   init = function()
  --     vim.g.targets_argOpening = '[({[]'
  --     vim.g.targets_argClosing = '[]})]'
  --   end,
  -- },
  {
    'folke/paint.nvim',
    config = function()
      require('paint').setup({
        highlights = {
          {
            filter = { filetype = 'python' },
            pattern = '%s*#[^@]*(@%w+)',
            hl = 'Constant',
          },
          {
            filter = { filetype = 'python' },
            pattern = '%s*#.*(TODO)',
            hl = 'Constant',
          },
          {
            filter = { filetype = 'python' },
            pattern = '%s*#.*(XXX)',
            hl = 'Constant',
          },
          {
            filter = { filetype = 'python' },
            pattern = '%s*#.*(NOTE)',
            hl = 'Constant',
          },
          {
            filter = { filetype = 'lua' },
            pattern = '%s*%-%-%-%s*(@%w+)',
            hl = 'Constant',
          },
        }
      })
    end,
  },
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
  {
    'tpope/vim-fugitive',
    init = function()
      vim.keymap.set('n', '<leader>gco', '<cmd>Telescope git_branches<cr>', { silent = true })
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
    branch = 'master',
    dependencies = {
      "sindrets/diffview.nvim",
    },
    config = function()
      require('config.neogit').setup()
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/playground',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('config.telescope').setup()
    end,
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end
  },
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
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    },
  },
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
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    ft = { 'rust' },
  },
  { 'justinmk/vim-dirvish' },
  { 'tyru/open-browser.vim' },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    }
  },
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
    branch = 'fix/matches',
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
  {
    'echasnovski/mini.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    version = false,
    config = function()
      require('mini.comment').setup()
      require('mini.move').setup({
        mappings = {
          left = '',
          right = '',
          down = ']e',
          up = '[e',

          line_left = '',
          line_right = '',
          line_down = ']e',
          line_up = '[e',
        },
        options = {
          reindent_linewise = false,
        },
      })
      require('mini.pairs').setup({
        mappings = {
          ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^\\].', register = { cr = false } },
        },
      })
      local ai = require('mini.ai')
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }),
          f = ai.gen_spec.treesitter({
            a = '@function.outer',
            i = '@function.inner',
          }),
          c = ai.gen_spec.treesitter({
            a = '@class.outer',
            i = '@class.inner',
          }),
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = '[%w_]' })
        },
      })
    end,
  },
  {
    'ThePrimeagen/refactoring.nvim',
    config = function()
      require('config.refactoring').setup()
    end
  },
  {
    dir = vim.fn.expand('~/src/misc/nvim-work-config'),
    cond = vim.uv.fs_stat(vim.fn.expand('~/src/misc/nvim-work-config')) or false,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/nvim-nio',
      -- 'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-python',
    },
    init = function()
      vim.keymap.set('n', '<space>tt', function() require('neotest').run.run() end, { desc = 'Run nearest test' })
      vim.keymap.set('n', '<space>td', function() require('neotest').run.run({ strategy = 'dap' }) end, { desc = 'Debug nearest test' })
      vim.keymap.set('n', '<space>tf', function() require('neotest').run.run(vim.fn.expand('%')) end,
        { desc = 'Run current file' })
      vim.keymap.set('n', '<space>to', function() require('neotest').output.open({ enter = true, quiet = true, auto_close = true }) end,
        { desc = 'Show current test output' })
    end,
    config = function()
      require('neotest').setup({
        output = {
          open_on_run = 'full',
        },
        adapters = {
          require('neotest-python')({
            python = '/home/jurica/.virtualenvs/local-py3.11/bin/python3',
          }),
        },
      })
    end,
  },
  {
    'soulis-1256/eagle.nvim',
    -- config = true,
    init = function()
      require('eagle').setup({
        border = 'single',
      })
      vim.opt.mousemoveevent = true
    end,
  },
  {
    'nvim-pack/nvim-spectre',
    config = true,
  },
  -- { -- deletes unused buffers
  --   "chrisgrieser/nvim-early-retirement",
  --   config = true,
  --   event = "VeryLazy",
  -- },
  -- {
  --   'github/copilot.vim',
  -- }
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",            -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For working with files with slash commands
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
          agent = {
            adapter = "copilot",
          },
        },
        opts = {
          log_level = "DEBUG",
        },
      })
    end,
  },
  { "miikanissi/modus-themes.nvim", priority = 1000 },
  { "alduraibi/telescope-glyph.nvim" },
  { "rest-nvim/rest.nvim" },
  { 'stevearc/quicker.nvim',
    event = "FileType qf",
    opts = {
      keys = {
        {
          '>',
          function()
            require('quicker').expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = 'Expand quickfix context',
        },
        {
          '<',
          function()
            require('quicker').collapse()
          end,
          desc = 'Collapse quickfix context',
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    },
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      input = { enabled = true },
      scratch = { enabled = true },
      notifier = { enabled = true },
    },
  },
  {
    "3rd/image.nvim",
    opts = {}
  },
}
