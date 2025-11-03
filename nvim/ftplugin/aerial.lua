vim.keymap.set('n', 'gq', function() require('aerial').close() end, { silent = true, buffer = true })
