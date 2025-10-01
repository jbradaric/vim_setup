local has_words_before = function()
  if vim.api.nvim_get_option_value('buftype', { buf = 0 }) == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  -- dependencies = {},

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  build = 'cargo build --release',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = 'none',
      ['<Tab>'] = {
        'snippet_forward',
        function(cmp)
          if require('sidekick').nes_jump_or_apply() then
            return
          elseif vim.lsp.inline_completion.get() then
            return
          elseif cmp.snippet_active() then
            return cmp.accept()
          elseif cmp.is_menu_visible() then
            return cmp.select_next()
          elseif has_words_before() then
            return cmp.show()
          end
        end,
        'fallback',
      },
      ['<C-y>'] = {
        function()
          return vim.lsp.inline_completion.get()
        end,
      },
      ['<M-Right>'] = {
        function()
          vim.lsp.inline_completion.select()
        end,
      },
      ['<M-Left>'] = {
        function()
          vim.lsp.inline_completion.select({ count = -1 })
        end,
      },
      ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
      ['<CR>'] = { 'select_and_accept', 'fallback' },
      -- default mappings
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = false } },

    cmdline = { enabled = false },

    enabled = function()
      if vim.tbl_contains({ 'gitcommit', }, vim.bo.filetype) then
        return false
      end
      return true
    end,

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'buffer' },
      per_filetype = {
        codecompanion = { 'codecompanion' },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = {
      implementation = "rust",
      prebuilt_binaries = {
        download = false,
      },
    },
  },
  opts_extend = { "sources.default" }
}
