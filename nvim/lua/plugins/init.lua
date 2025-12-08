return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('config.treesitter').setup()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
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
  {
    'rebelot/heirline.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'jbradaric/rooter.nvim',
    },
    config = function()
      require('config.statusline').setup()
    end,
  },
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
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    config = function()
      local mc = require('multicursor-nvim')
      mc.setup()

      vim.keymap.set({'n', 'x'}, '<C-d>', function() mc.matchAddCursor(1) end, { desc = 'Add cursor' })
      vim.keymap.set({'n', 'x'}, '<C-q>', function() mc.matchSkipCursor(1) end, { desc = 'Skip cursor' })


      mc.addKeymapLayer(function(layerSet)
        layerSet('n', '<esc>',
          function()
            if not mc.cursorsEnabled() then
              mc.enableCursors()
            else
              mc.clearCursors()
            end
          end)
      end)
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
      vim.keymap.set('n', '<leader>gco', function() Snacks.picker.git_branches() end, { silent = true })
      vim.keymap.set('n', '<leader>gcm', '<cmd>Git checkout master<cr>', { silent = true })
      vim.keymap.set('n', '<leader>gpl', '<cmd>Git pull<cr>', { silent = true })
      vim.keymap.set('n', '<leader>gpu', '<cmd>Git push<cr>', { silent = true })
    end
  },
  { 'tpope/vim-git' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-eunuch' },
  { 'nvim-lua/plenary.nvim' },
  {
    'NeogitOrg/neogit',
    branch = 'master',
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
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    },
    keys = {
      { '<space>a', '<cmd>AerialToggle<cr>', desc = 'Toggle Aerial' },
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
    'jbradaric/nvim-miniyank',
    init = function()
      vim.cmd([[map p <Plug>(miniyank-autoput)]])
      vim.cmd([[map P <Plug>(miniyank-autoPut)]])
      vim.cmd([[map <A-p> <Plug>(miniyank-cycle)]])
      vim.cmd([[map <A-n> <Plug>(miniyank-cycleback)]])
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
    dependencies = {
      { "igorlfs/nvim-dap-view",
        opts = {
          winbar = {
            sections = { 'watches', 'scopes', 'exceptions', 'breakpoints', 'threads', 'repl', 'console' },
            default_section = 'scopes',
            controls = {
              enabled = true,
            },
          },
          switchbuf = 'useopen',
        },
      },
    },
    config = function()
      require('config.dap').setup()
    end
  },
  {
    'mfussenegger/nvim-dap-python',
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  {
    'luukvbaal/statuscol.nvim',
    opts = {
      setopt = true,
    },
  },
  {
    'echasnovski/mini.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    version = false,
    config = function()
      require('mini.comment').setup()
      require('mini.pick').setup()
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

      require('mini.surround').setup({
        mappings = {
          add = 'ys',
          delete = 'ds',
          replace = 'cs',
          find = '',
          find_left = '',
          highlight = '',
        },
      })

      -- Remove 'ys' mapping in visual mode to avoid conflict with yank mapping
      vim.keymap.del('x', 'ys')
      -- Map "surround selection" to S, like in vim-surround
      vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]],
        { silent = true, desc = 'Add surrounding to selection' })
    end,
  },
  {
    dir = vim.fn.expand('~/src/misc/nvim-work-config'),
    cond = vim.uv.fs_stat(vim.fn.expand('~/src/misc/nvim-work-config')) or false,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
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
      vim.keymap.set('n', '<space>ts', function() require('neotest').summary.toggle() end,
        { desc = 'Toggle summary' })
    end,
    config = function()
      require('neotest').setup({
        output = {
          open_on_run = 'full',
        },
        adapters = {
          require('neotest-python')({
            python = '/work/data/.local/bin/sdt',
          }),
        },
      })
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      start_in_insert = true,
      persist_mode = false,
      highlights = {
        FloatBorder = {
          guifg = '#569cd6',
        },
      },
      float_opts = {
        border = 'curved',
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- Optional: For working with files with slash commands
    },
    config = function()
      require('codecompanion').setup({
        opts = {
          -- Optional: Set the default system prompt
          -- system_prompt = require('config.llm_prompts').get_prompt,
        },})
    end,
    keys = {
      { '<leader>ai', '<cmd>CodeCompanion<cr>',        mode = { 'n', 'v' }, desc = 'Inline Prompt [zi]' },
      { '<leader>ac', '<cmd>CodeCompanionChat<cr>',    mode = { 'n', 'v' }, desc = 'Open Chat [zz]' },
      { '<leader>at', '<cmd>CodeCompanionChat Toggle<cr>',  mode = { 'n', 'v' }, desc = 'Toggle Chat [zt]' },
      { '<leader>aa', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'Actions [za]' },
    },
    commands = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
  },
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        win = {
          layout = 'float',
        },
        mux = {
          enabled = true,
        },
      },
      nes = {
        enabled = false,
      },
    },
    keys = {
      {
        '\\so',
        function()
          require('sidekick.cli').toggle({ name = 'opencode', focus = true })
        end,
        desc = 'Toggle Sidekick',
      },
      {
        '\\sp',
        function()
          require("sidekick.cli").prompt()
        end,
        desc = "Sidekick Ask Prompt",
        mode = { "n", "v" },
      },
    },
  },
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
      { "<space>ss", function() Snacks.picker.lsp_symbols({ layout = { preset = 'vscode' } }) end,
        desc = 'Open LSP symbol picker'
      },
      { "<space>sd", function() Snacks.picker.diagnostics_buffer({ layout = { preset = 'vscode' } }) end,
        desc = 'Open diagnostics picker'
      },
      { "<space>sl", function() Snacks.picker.lines({ layout = { preset = 'vscode' } }) end,
        desc = 'Search lines in the current buffer'
      },
      { "<space>/", function() Snacks.picker.grep({ layout = { preset = 'vscode' } }) end,
        desc = 'Grep in the current project'
      },
      { "<c-p>", function() Snacks.picker.files({ layout = { preset = 'vscode' } }) end,
        desc = 'Open file picker'
      },
      { "<space>r", function() Snacks.picker.resume() end, desc = 'Resume last picker' },
      { "<leader>b", function() Snacks.picker.buffers({ layout = { preset = 'vscode' } }) end,
        desc = 'Select buffer'
      },
      { "<leader>l", function() Snacks.picker.lines({ layout = { preset = 'vscode' } }) end,
        desc = 'Search lines in the current buffer'
      },
      {
        "<leader>f",
        function()
          local opts = { filter = { default = { 'Function' } }, layout = { preset = 'vscode' } }
          Snacks.picker.treesitter(opts)
        end,
        desc = 'Select function from treesitter'
      },
      {
        "<leader>t",
        function()
          local opts = { filter = { default = { 'Class', 'Enum', 'Struct', 'Trait' } }, layout = { preset = 'vscode' } }
          Snacks.picker.treesitter(opts)
        end,
        desc = 'Select type from treesitter'
      },
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
      image = { enabled = true },
      picker = {
        win = {
          input = {
            keys = {
              ["<a-g>"] = { "toggle_live", mode = { "i", "n" } },
              ["<c-g>"] = { "close", mode = { "n", "i" } },
            },
          },
        },
      },
    },
    config = function(_, opts)
      require('snacks').setup(opts)

      vim.api.nvim_create_user_command('Files',
        function(func_args)
          require('snacks').picker.files({ dirs = { func_args.args }, layout = { preset = 'vscode' }})
        end,
        { nargs = 1, complete = 'dir', desc = 'Pick files' })
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        c = { 'clang-format', stop_after_first = true },
        cpp = { 'clang-format', stop_after_first = true },
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "ruff_format" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup({
        preset = 'powerline',
      })
      vim.diagnostic.config({ virtual_text = false })
    end,
  }
}
