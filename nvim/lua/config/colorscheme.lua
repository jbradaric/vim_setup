local M = {}

local function setup_vscode()
  local bg_color = '#1f1f1f'
  require('vscode').setup({
    italic_comments = true,
    color_overrides = {
      -- vscBack = '#141b1e',
      vscBack = bg_color,
    },
    group_overrides = {
      Pmenu = { fg = '#d9d9d9', bg = '#10171a' },
      PmenuSel = { fg = '#000000', bg = '#8ccf7e' },
      WinSeparator = { fg = '#555555' },
      WinBar = { bg = bg_color },
      WinBarNC = { bg = bg_color },
    },
  })
  require('vscode').load('dark')
end

local function setup_terminal()
  vim.g.terminal_color_0  = '#171421'
  vim.g.terminal_color_1  = '#c01c28'
  vim.g.terminal_color_2  = '#26a269'
  vim.g.terminal_color_3  = '#a2734c'
  vim.g.terminal_color_4  = '#12488b'
  vim.g.terminal_color_5  = '#a347ba'
  vim.g.terminal_color_6  = '#2aa1b3'
  vim.g.terminal_color_7  = '#d0cfcc'
  vim.g.terminal_color_8  = '#5e5c64'
  vim.g.terminal_color_9  = '#f66151'
  vim.g.terminal_color_10 = '#33da7a'
  vim.g.terminal_color_11 = '#e9ad0c'
  vim.g.terminal_color_12 = '#2a7bde'
  vim.g.terminal_color_13 = '#c061cb'
  vim.g.terminal_color_14 = '#33c7de'
  vim.g.terminal_color_15 = '#ffffff'
end

M.setup = function()
  setup_vscode()
  setup_terminal()

  local highlight = require('config.utils').highlight
  highlight('StatusLine', { bg = '#1e1e1e' })
  highlight('CmpItemKindCopilot', { fg = '#6CC644' })

  local hint_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('NonText')), 'fg#')
  highlight('LspInlayHint', { fg = hint_fg, style = 'italic' })
  highlight('LspReferenceRead', { bg = '#24292e' })

  -- highlight('SnacksNormal', { bg = '#141b1e' })
  -- highlight('SnacksPicker', { bg = '#141b1e' })
  -- highlight('SnacksPickerBoxBorder', { fg = '#d4d4d4' })

  -- highlight('@lsp.mod.readonly', { style = 'italic' })
  -- vim.api.nvim_set_hl(0, '@lsp.type.method', { link = '@method', default = true })

  vim.api.nvim_create_autocmd("LspTokenUpdate", {
    callback = function(args)
      local token = args.data.token
      if token.type == 'decorator' then
        vim.lsp.semantic_tokens.highlight_token(
          token, args.buf, args.data.client_id, '@lsp.type.decorator.python',
          { priority = 120 }
        )
      end

      -- if token.modifiers.builtin and token.modifiers.readonly then
      --   vim.lsp.semantic_tokens.highlight_token(
      --     token, args.buf, args.data.client_id, '@lsp.mod.builtin'
      --   )
      -- end
    end,
  })

  -- Make Sncaks.picker look more similar to telescope
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      vim.api.nvim_set_hl(0, "SnacksPicker", { bg = "none", nocombine = true })
      vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = "#316c71", bg = "none", nocombine = true })
    end,
  })

end

return M
