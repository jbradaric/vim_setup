local neogit = require('neogit')

local M = {}

local function extract_url_from_command_output(output)
  -- Look for the URL pattern in lines starting with "remote:"
  -- The pattern matches "https://" followed by any non-whitespace characters
  for line in output:gmatch("[^\r\n]+") do
    if line:match("^remote:%s+https://") then
      local url = line:match("(https://[%w%p]+)")
      if url then
        return url
      end
    end
  end

  return nil -- Return nil if no URL is found
end

M.setup = function()
  vim.api.nvim_set_keymap('n', '<Space>m', ':<C-U>Neogit<CR>', { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', '<Space>dvo', ':DiffviewOpen<CR>', { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', '<Space>dvc', ':DiffviewClose<CR>', { silent = true, noremap = true })

  neogit.setup({
    graph_style = 'unicode',
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
    },
    mappings = {
      status = {
        ['[n'] = 'GoToPreviousHunkHeader',
        [']n'] = 'GoToNextHunkHeader',
      },
    },
  })

  vim.api.nvim_create_user_command('CreateMR', function()
    local git_root = vim.fs.root(0, ".git")
    if type(git_root) ~= "string" then
        vim.notify("Not in a repository", vim.log.levels.ERROR)
        return
    end

    local function on_exit(obj)
      vim.schedule(function()
        if obj.code ~= 0 then
          vim.notify("Command failed with exit code: " .. obj.code, vim.log.levels.ERROR)
          return
        end
        local url = extract_url_from_command_output(obj.stderr)
        if url ~= nil then
          vim.notify("Merge request created: " .. url, vim.log.levels.INFO)
          vim.fn['openbrowser#open'](url)
        else
          vim.notify("No merge request URL found in command output.", vim.log.levels.WARN)
        end
      end)
    end

    local cmd = { 'git', 'lab', 'review' }
    vim.system(cmd, { text = true }, on_exit)
  end, {})
end

return M
