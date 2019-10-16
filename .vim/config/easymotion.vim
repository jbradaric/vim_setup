map <Space> <Plug>(easymotion-prefix)
let g:EasyMotion_do_special_mapping = 1
let g:EasyMotion_keys = 'asdghklqwertzuiopyxcvbnmfj'

" Workaround to keep the cursor position after yank
" For some reason, the cursor position is not restored when using
" <Plug>(easymotion-prefix)l instead of <space>l
nmap <silent> y<space>l <Plug>(easyoperator-line-yank)
