if !has('nvim')
  finish
endif
lua require('utils').setup_neogit()
nnoremap <silent> <Space>m :<c-u>Neogit<cr>
