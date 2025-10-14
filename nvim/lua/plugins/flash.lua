local function flash_diagnostic()
  require("flash").jump({
    action = function(match, state)
      vim.api.nvim_win_call(match.win, function()
        vim.api.nvim_win_set_cursor(match.win, match.pos)
        vim.diagnostic.open_float()
      end)
      state:restore()
    end,
  })
end

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    modes = {
      char = {
        enabled = false,
      },
      treesitter = {
        label = {
          style = 'overlay',
        },
      },
      treesitter_search = {
        label = {
          style = 'overlay',
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<space>dd", mode = { "n" }, flash_diagnostic, desc = "Flash Diagnostic" },
  },
}
