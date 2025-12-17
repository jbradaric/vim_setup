local neogit = require('neogit')

local M = {}

M.setup = function()
  vim.api.nvim_set_keymap('n', '<Space>m', ':<C-U>Neogit<CR>', { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', '<Space>nb', ':<C-U>Neogit branch<CR>', { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', '<Space>dvo', ':DiffviewOpen<CR>', { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', '<Space>dvc', ':DiffviewClose<CR>', { silent = true, noremap = true })

  neogit.setup({
    graph_style = 'kitty',
    disable_commit_confirmation = true,
    sections = {
      stashes = {
        hidden = true,
      },
    },
    integrations = {
      telescope = false,
      fzf_lua = false,
      mini_pick = false,
      diffview = true,
      snacks = true,
    },
    mappings = {
      status = {
        ['[n'] = 'GoToPreviousHunkHeader',
        [']n'] = 'GoToNextHunkHeader',
      },
    },
  })

  -- Override the default rebase editor mappings
  require('neogit.config').values.mappings.rebase_editor = {
    ['<c-c><c-c>'] = 'Submit',
    ['<c-c><c-k>'] = 'Abort',
    ['<cr>'] = 'OpenCommit',
    ['[c'] = 'OpenOrScrollUp',
    [']c'] = 'OpenOrScrollDown',
    ['q'] = 'Close',
    ['<leader>p'] = 'Pick',
    ['<leader>e'] = 'Edit',
    ['<leader>s'] = 'Squash',
    ['<leader>f'] = 'Fixup',
    ['<leader>d'] = 'Drop',
    ['<leader>r'] = 'Reword',
    ['<leader>c'] = 'Comment',
  }

  require("gitlab-mr-cherry-pick").setup({
    remote = "origin",
    base_branch = "master",
    draft = false,
  })

  -- Key mappings
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "NeogitLogView", "NeogitStatus" },
    callback = function(args)
      vim.keymap.set("n", "<leader>gmr", function()
        require("gitlab-mr-cherry-pick").create_mr_from_current_line()
      end, {
        buffer = args.buf,
        desc = "Create GitLab MR from current commit",
      })

      vim.keymap.set("v", "<leader>gmr", function()
        require("gitlab-mr-cherry-pick").create_mr_from_selection()
      end, {
        buffer = args.buf,
        desc = "Create GitLab MR from selected commits",
      })
    end,
  })
end

return M
