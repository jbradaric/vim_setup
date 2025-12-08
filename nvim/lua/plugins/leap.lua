return {
  'https://codeberg.org/andyg/leap.nvim',
  config = function()
    local leap = require('leap')
    leap.opts.safe_labels = ''
    leap.opts.preview_filter = function () return false end

    vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)', { desc = 'Leap' })
    vim.keymap.set('n', 'S', '<Plug>(leap-from-window)', { desc = 'Leap between windows' })

    vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    vim.api.nvim_set_hl(0, 'LeapLabel', { fg = 'red' })
  end,
}
