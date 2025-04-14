return {
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      messages = {
        enabled = true,
      },
      notify = {
        enabled = false,
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
            any = {
              { find = '%d+L, %d+B' },
              { find = '^%d+ changes?; after #%d+' },
              { find = '^%d+ changes?; before #%d+' },
              { find = '^Hunk %d+ of %d+$' },
              { find = '^%d+ fewer lines;?' },
              { find = '^%d+ more lines?;?' },
              { find = '^%d+ line less;?' },
              { find = '^%d+ lines >ed %d+ times?' },
              { find = '^%d+ lines <ed %d+ times?' },
              { find = '^Already at newest change' },
              { kind = 'wmsg' },
              { kind = 'emsg', find = 'E486' },
              { kind = 'quickfix' },
            },
          },
          opts = { skip = true },
        },
      },
    }
  },
}
