nnoremap <buffer> ]n :<c-u>call search('^@@')<cr>
nnoremap <buffer> [n :<c-u>call search('^@@', 'b')<cr>

nnoremap <buffer> ]f :<c-u>lua require('neogit.status').next_item()<CR>
nnoremap <buffer> [f :<c-u>lua require('neogit.status').prev_item()<CR>
