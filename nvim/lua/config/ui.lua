local M = {}

M.setup = function()
  require('notify').setup()

  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0

  -- vim.opt.shortmess:append('sS')

  require('statuscol').setup({
    setopt = true,
  })

  require("noice").setup({
    lsp = {
      progress = {
        enabled = false,
      },
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
      command_palette = {
        views = {
          cmdline_popup = {
            position = { row = 20, },
          },
          popupmenu = {
            position = { row = 23, },
          },
        },
      },
    },
    routes = {
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'written',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'change; before',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'change; after',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'line less; ',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'more line; ',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'more lines; ',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'fewer lines; ',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'lines yanked',
        },
        opts = { skip = true },
      },
      {
        filter = {
          kind = 'search_count',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          kind = 'wmsg',
          find = 'search hit',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          kind = 'emsg',
          find = 'Pattern not found',
        },
        opts = { skip = true },
      },
    },
  })
end

return M
