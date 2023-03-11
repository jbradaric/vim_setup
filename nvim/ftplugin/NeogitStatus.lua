vim.keymap.set('n', ']n', function() vim.fn.search('^@@') end, { silent = true, buffer = true })
vim.keymap.set('n', '[n', function() vim.fn.search('^@@', 'b') end, { silent = true, buffer = true })

vim.keymap.set('n', ']f', function() require('neogit.status').next_item() end, { silent = true, buffer = true })
vim.keymap.set('n', '[f', function() require('neogit.status').prev_item() end, { silent = true, buffer = true })
