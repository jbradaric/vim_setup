setlocal foldenable
nnoremap <buffer> ]n :<C-u>call magit#jump_hunk('N')<CR>
nnoremap <buffer> [n :<C-u>call magit#jump_hunk('P')<CR>
