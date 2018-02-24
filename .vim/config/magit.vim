let g:magit_jump_next_hunk = ']n'
let g:magit_jump_prev_hunk = '[n'

let g:magit_commit_title_limit = 80
let g:magit_auto_close = 1

nnoremap <silent> <Space>m :<c-u>MagitOnly<cr>
nnoremap <silent> <Space>M :call magit#show_magit('h')<CR>
